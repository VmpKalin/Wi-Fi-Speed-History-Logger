import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/speed_providers.dart';
import '../services/database_service.dart';
import '../services/report_service.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allResults = ref.watch(allResultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: allResults.when(
        data: (results) {
          final networks = ReportService.groupByNetwork(results);
          if (networks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assessment_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No network data yet'),
                  SizedBox(height: 8),
                  Text(
                    'Run speed tests to start building reports',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: networks.length,
            itemBuilder: (context, index) =>
                _NetworkCard(network: networks[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _NetworkCard extends StatelessWidget {
  final NetworkGroup network;

  const _NetworkCard({required this.network});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _NetworkReportScreen(network: network),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    network.isCellular ? Icons.cell_tower : Icons.wifi,
                    color: network.isCellular
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          network.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          network.isCellular ? 'Mobile data' : 'Wi-Fi',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.speed,
                    label: '${network.testCount} tests',
                    theme: theme,
                  ),
                  if (network.ispName != null && network.isWifi)
                    _InfoChip(
                      icon: Icons.business,
                      label: network.ispName!,
                      theme: theme,
                    ),
                  _InfoChip(
                    icon: Icons.calendar_today,
                    label:
                        '${dateFormat.format(network.firstTest)} — ${dateFormat.format(network.lastTest)}',
                    theme: theme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _NetworkReportScreen extends ConsumerWidget {
  final NetworkGroup network;

  const _NetworkReportScreen({required this.network});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final theme = Theme.of(context);

    Future<List<SpeedResult>> fetchResults() => db.getResultsForNetworkGroup(
          networkType: network.networkType,
          ssid: network.ssid,
          bssid: network.bssid,
          ispName: network.ispName,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(network.displayName),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.ios_share),
            onSelected: (value) async {
              final results = await fetchResults();
              if (value == 'pdf') {
                await ReportService.exportPdf(results, network);
              } else {
                await ReportService.exportCsv(results, network);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'pdf',
                child: ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text('Export as PDF'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'csv',
                child: ListTile(
                  leading: Icon(Icons.table_chart),
                  title: Text('Export as CSV'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<SpeedResult>>(
        future: fetchResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final results = snapshot.data!;
          final stats = ReportService.computeStats(results);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionCard(
                title: 'Network Details',
                theme: theme,
                children: [
                  _DetailRow('Type', network.isCellular ? 'Cellular / Mobile data' : 'Wi-Fi'),
                  if (network.isWifi) _DetailRow('SSID', network.ssid ?? 'Unknown'),
                  if (network.bssid != null)
                    _DetailRow('BSSID', network.bssid!),
                  if (network.ispName != null)
                    _DetailRow('ISP', network.ispName!),
                  if (network.externalIp != null)
                    _DetailRow('External IP', network.externalIp!),
                  _DetailRow('Total Tests', '${stats.totalTests}'),
                  _DetailRow('Failed Tests', '${stats.failedTests}'),
                  _DetailRow(
                    'Period',
                    '${DateFormat('MMM d, yyyy').format(network.firstTest)} — '
                        '${DateFormat('MMM d, yyyy').format(network.lastTest)}',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Speed Summary',
                theme: theme,
                children: [
                  _StatsRow(
                    label: 'Download',
                    avg: '${stats.avgDownload.toStringAsFixed(1)} Mbps',
                    min: stats.minDownload.toStringAsFixed(1),
                    max: stats.maxDownload.toStringAsFixed(1),
                    color: theme.colorScheme.primary,
                  ),
                  const Divider(height: 16),
                  _StatsRow(
                    label: 'Upload',
                    avg: '${stats.avgUpload.toStringAsFixed(1)} Mbps',
                    min: stats.minUpload.toStringAsFixed(1),
                    max: stats.maxUpload.toStringAsFixed(1),
                    color: theme.colorScheme.secondary,
                  ),
                  const Divider(height: 16),
                  _StatsRow(
                    label: 'Ping',
                    avg: '${stats.avgPing.toStringAsFixed(0)} ms',
                    min: '${stats.minPing}',
                    max: '${stats.maxPing}',
                    color: theme.colorScheme.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Test History',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...results.map(
                (r) => _TestResultTile(result: r, theme: theme),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final ThemeData theme;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.theme,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String label;
  final String avg;
  final String min;
  final String max;
  final Color color;

  const _StatsRow({
    required this.label,
    required this.avg,
    required this.min,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            Text(
              avg,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Min: $min',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Max: $max',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TestResultTile extends StatelessWidget {
  final SpeedResult result;
  final ThemeData theme;

  const _TestResultTile({required this.result, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        dense: true,
        leading: Icon(
          result.failed ? Icons.error_outline : Icons.check_circle_outline,
          color:
              result.failed ? theme.colorScheme.error : theme.colorScheme.primary,
          size: 20,
        ),
        title: result.failed
            ? Text('Test Failed',
                style: TextStyle(color: theme.colorScheme.error, fontSize: 13))
            : Text(
                '${result.downloadMbps?.toStringAsFixed(1) ?? "—"} / '
                '${result.uploadMbps?.toStringAsFixed(1) ?? "—"} Mbps  ·  '
                '${result.pingMs ?? "—"} ms',
                style: const TextStyle(fontSize: 13),
              ),
        subtitle: Text(
          DateFormat('MMM d, yyyy · h:mm a').format(result.timestamp),
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }
}
