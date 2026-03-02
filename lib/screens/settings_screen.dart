import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/speed_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequency = ref.watch(testFrequencyProvider);
    final wifiOnly = ref.watch(wifiOnlyProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _SectionHeader('Test Schedule'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 6, label: Text('6h')),
                ButtonSegment(value: 12, label: Text('12h')),
                ButtonSegment(value: 24, label: Text('24h')),
              ],
              selected: {frequency},
              onSelectionChanged: (selection) {
                ref
                    .read(testFrequencyProvider.notifier)
                    .setFrequency(selection.first);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Speed tests run automatically every $frequency hours in the background.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Divider(height: 32),
          _SectionHeader('Network'),
          SwitchListTile(
            title: const Text('Wi-Fi only'),
            subtitle: const Text('Skip tests when on cellular data'),
            value: wifiOnly,
            onChanged: (_) =>
                ref.read(wifiOnlyProvider.notifier).toggle(),
          ),
          const Divider(height: 32),
          _SectionHeader('Data'),
          ListTile(
            leading: Icon(Icons.delete_outline,
                color: theme.colorScheme.error),
            title: Text(
              'Clear all history',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _confirmClearHistory(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearHistory(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'This will permanently delete all speed test records. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(databaseProvider).deleteAllResults();
      ref.invalidate(allResultsProvider);
      ref.invalidate(last30DaysProvider);
      ref.invalidate(resultsByDayProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All history cleared')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
