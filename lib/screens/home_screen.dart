import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/speed_providers.dart';
import '../services/database_service.dart';
import '../widgets/speed_chart.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final last30Days = ref.watch(last30DaysProvider);
    final isRunning = ref.watch(isTestRunningProvider);
    final chartView = ref.watch(chartViewProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('NetLog')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(last30DaysProvider);
          ref.invalidate(allResultsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _LatestResultCard(results: last30Days),
            const SizedBox(height: 24),
            _ChartViewToggle(current: chartView, ref: ref),
            const SizedBox(height: 12),
            last30Days.when(
              data: (results) =>
                  SpeedChart(results: results, view: chartView),
              loading: () => const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SizedBox(
                height: 220,
                child: Center(child: Text('Error: $e')),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: isRunning ? null : ref.read(runSpeedTestProvider),
              icon: isRunning
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.speed),
              label: Text(isRunning ? 'Testing…' : 'Run Test Now'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatestResultCard extends StatelessWidget {
  final AsyncValue<List<SpeedResult>> results;

  const _LatestResultCard({required this.results});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return results.when(
      data: (list) {
        final latest = list.isNotEmpty ? list.last : null;
        final hasData = latest != null && !latest.failed;
        final timeAgo = latest != null
            ? _timeAgoString(latest.timestamp)
            : 'Never';

        return Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(
                      icon: Icons.arrow_downward_rounded,
                      label: 'Download',
                      value: hasData
                          ? latest.downloadMbps?.toStringAsFixed(1) ?? '—'
                          : '—',
                      unit: 'Mbps',
                      color: theme.colorScheme.primary,
                    ),
                    _StatItem(
                      icon: Icons.arrow_upward_rounded,
                      label: 'Upload',
                      value: hasData
                          ? latest.uploadMbps?.toStringAsFixed(1) ?? '—'
                          : '—',
                      unit: 'Mbps',
                      color: theme.colorScheme.secondary,
                    ),
                    _StatItem(
                      icon: Icons.timer_outlined,
                      label: 'Ping',
                      value: hasData
                          ? '${latest.pingMs ?? '—'}'
                          : '—',
                      unit: 'ms',
                      color: theme.colorScheme.tertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Last tested: $timeAgo',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error loading data: $e'),
        ),
      ),
    );
  }

  String _timeAgoString(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          unit,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ChartViewToggle extends StatelessWidget {
  final ChartView current;
  final WidgetRef ref;

  const _ChartViewToggle({required this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ChartView>(
      segments: const [
        ButtonSegment(value: ChartView.download, label: Text('Download')),
        ButtonSegment(value: ChartView.upload, label: Text('Upload')),
        ButtonSegment(value: ChartView.ping, label: Text('Ping')),
      ],
      selected: {current},
      onSelectionChanged: (selection) {
        ref.read(chartViewProvider.notifier).state = selection.first;
      },
    );
  }
}
