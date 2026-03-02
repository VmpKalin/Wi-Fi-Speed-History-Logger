import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/speed_providers.dart';
import '../services/database_service.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsByDay = ref.watch(resultsByDayProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: resultsByDay.when(
        data: (grouped) {
          if (grouped.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No speed tests recorded yet'),
                ],
              ),
            );
          }

          final sortedDays = grouped.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            itemCount: sortedDays.length,
            itemBuilder: (context, dayIndex) {
              final day = sortedDays[dayIndex];
              final entries = grouped[day]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DateHeader(date: day),
                  ...entries.map((entry) => _ResultTile(entry: entry)),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    String label;
    if (date == today) {
      label = 'Today';
    } else if (date == yesterday) {
      label = 'Yesterday';
    } else {
      label = DateFormat('EEEE, MMM d, yyyy').format(date);
    }

    return Container(
      width: double.infinity,
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final SpeedResult entry;

  const _ResultTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        entry.networkType == 'wifi' ? Icons.wifi : Icons.cell_tower,
        color: entry.failed
            ? theme.colorScheme.error
            : theme.colorScheme.primary,
      ),
      title: entry.failed
          ? Text(
              'Test Failed',
              style: TextStyle(color: theme.colorScheme.error),
            )
          : Row(
              children: [
                _MetricChip(
                  icon: Icons.arrow_downward_rounded,
                  value: entry.downloadMbps?.toStringAsFixed(1) ?? '—',
                  unit: 'Mbps',
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                _MetricChip(
                  icon: Icons.arrow_upward_rounded,
                  value: entry.uploadMbps?.toStringAsFixed(1) ?? '—',
                  unit: 'Mbps',
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                _MetricChip(
                  icon: Icons.timer_outlined,
                  value: '${entry.pingMs ?? '—'}',
                  unit: 'ms',
                  color: theme.colorScheme.tertiary,
                ),
              ],
            ),
      subtitle: Text(
        DateFormat('h:mm a').format(entry.timestamp),
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final Color color;

  const _MetricChip({
    required this.icon,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          '$value $unit',
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
