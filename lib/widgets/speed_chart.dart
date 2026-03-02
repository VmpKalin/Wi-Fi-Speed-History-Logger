import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/speed_providers.dart';
import '../services/database_service.dart';

class DaySummary {
  final DateTime day;
  final double avg;
  final double min;
  final double max;

  DaySummary({
    required this.day,
    required this.avg,
    required this.min,
    required this.max,
  });
}

class SpeedChart extends StatelessWidget {
  final List<SpeedResult> results;
  final ChartView view;

  const SpeedChart({super.key, required this.results, required this.view});

  List<DaySummary> _buildSummaries() {
    final byDay = <DateTime, List<double>>{};

    for (final r in results) {
      if (r.failed) continue;

      final day = DateTime(r.timestamp.year, r.timestamp.month, r.timestamp.day);
      final value = switch (view) {
        ChartView.download => r.downloadMbps,
        ChartView.upload => r.uploadMbps,
        ChartView.ping => r.pingMs?.toDouble(),
      };
      if (value == null) continue;
      byDay.putIfAbsent(day, () => []).add(value);
    }

    final days = byDay.keys.toList()..sort();
    return days.map((day) {
      final values = byDay[day]!;
      final avg = values.reduce((a, b) => a + b) / values.length;
      final min = values.reduce((a, b) => a < b ? a : b);
      final max = values.reduce((a, b) => a > b ? a : b);
      return DaySummary(day: day, avg: avg, min: min, max: max);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final summaries = _buildSummaries();
    if (summaries.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No data yet')),
      );
    }

    final theme = Theme.of(context);
    final lineColor = theme.colorScheme.primary;
    final areaColor = lineColor.withAlpha(40);

    final yLabel = view == ChartView.ping ? 'ms' : 'Mbps';

    final maxLine = summaries.map((s) => s.max).reduce((a, b) => a > b ? a : b);
    final maxY = (maxLine * 1.2).ceilToDouble();

    final avgSpots = <FlSpot>[];
    final maxSpots = <FlSpot>[];
    final minSpots = <FlSpot>[];

    for (var i = 0; i < summaries.length; i++) {
      avgSpots.add(FlSpot(i.toDouble(), summaries[i].avg));
      maxSpots.add(FlSpot(i.toDouble(), summaries[i].max));
      minSpots.add(FlSpot(i.toDouble(), summaries[i].min));
    }

    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 8),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxY,
            clipData: const FlClipData.all(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY / 4,
              getDrawingHorizontalLine: (value) => FlLine(
                color: theme.colorScheme.outlineVariant.withAlpha(60),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: _xInterval(summaries.length),
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= summaries.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        DateFormat('M/d').format(summaries[idx].day),
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,
                  interval: maxY / 4,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()} $yLabel',
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            betweenBarsData: [
              BetweenBarsData(fromIndex: 1, toIndex: 2, color: areaColor),
            ],
            lineBarsData: [
              // Index 0: average line (visible)
              LineChartBarData(
                spots: avgSpots,
                isCurved: true,
                preventCurveOverShooting: true,
                color: lineColor,
                barWidth: 3,
                dotData: FlDotData(
                  show: summaries.length <= 7,
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter(
                    radius: 3,
                    color: lineColor,
                    strokeWidth: 0,
                  ),
                ),
                belowBarData: BarAreaData(show: false),
              ),
              // Index 1: max line (invisible, for shaded area)
              LineChartBarData(
                spots: maxSpots,
                isCurved: true,
                preventCurveOverShooting: true,
                color: Colors.transparent,
                barWidth: 0,
                dotData: const FlDotData(show: false),
              ),
              // Index 2: min line (invisible, for shaded area)
              LineChartBarData(
                spots: minSpots,
                isCurved: true,
                preventCurveOverShooting: true,
                color: Colors.transparent,
                barWidth: 0,
                dotData: const FlDotData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (spots) {
                  return spots.map((spot) {
                    if (spot.barIndex != 0) return null;
                    return LineTooltipItem(
                      '${spot.y.toStringAsFixed(1)} $yLabel',
                      TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _xInterval(int count) {
    if (count <= 7) return 1;
    if (count <= 14) return 2;
    return (count / 6).ceilToDouble();
  }
}
