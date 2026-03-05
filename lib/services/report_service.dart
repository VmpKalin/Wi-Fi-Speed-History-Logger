import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'database_service.dart';

class NetworkGroup {
  final String networkType;
  final String? ssid;
  final String? bssid;
  final String? ispName;
  final String? externalIp;
  final int testCount;
  final DateTime firstTest;
  final DateTime lastTest;

  bool get isCellular => networkType == 'cellular';
  bool get isWifi => networkType == 'wifi';

  String get displayName {
    if (isCellular) {
      return ispName != null ? 'Cellular — $ispName' : 'Cellular Network';
    }
    return ssid ?? 'Unknown Wi-Fi';
  }

  String get groupKey {
    if (isCellular) {
      return 'cellular_${ispName ?? "null"}';
    }
    return 'wifi_${ssid ?? "null"}_${bssid ?? "null"}';
  }

  NetworkGroup({
    required this.networkType,
    required this.ssid,
    required this.bssid,
    required this.ispName,
    required this.externalIp,
    required this.testCount,
    required this.firstTest,
    required this.lastTest,
  });
}

class ReportStats {
  final double avgDownload;
  final double minDownload;
  final double maxDownload;
  final double avgUpload;
  final double minUpload;
  final double maxUpload;
  final double avgPing;
  final int minPing;
  final int maxPing;
  final int totalTests;
  final int failedTests;

  ReportStats({
    required this.avgDownload,
    required this.minDownload,
    required this.maxDownload,
    required this.avgUpload,
    required this.minUpload,
    required this.maxUpload,
    required this.avgPing,
    required this.minPing,
    required this.maxPing,
    required this.totalTests,
    required this.failedTests,
  });
}

class ReportService {
  static List<NetworkGroup> groupByNetwork(List<SpeedResult> allResults) {
    final groups = <String, List<SpeedResult>>{};

    for (final result in allResults) {
      final String key;
      if (result.networkType == 'cellular') {
        key = 'cellular_${result.ispName ?? "null"}';
      } else {
        key = 'wifi_${result.ssid ?? "null"}_${result.bssid ?? "null"}';
      }
      groups.putIfAbsent(key, () => []).add(result);
    }

    return groups.entries.map((entry) {
      final results = entry.value;
      final first = results.first;
      final timestamps = results.map((r) => r.timestamp).toList()..sort();

      return NetworkGroup(
        networkType: first.networkType,
        ssid: first.ssid,
        bssid: first.bssid,
        ispName: results
            .where((r) => r.ispName != null)
            .map((r) => r.ispName!)
            .fold<String?>(null, (prev, el) => el),
        externalIp: results
            .where((r) => r.externalIp != null)
            .map((r) => r.externalIp!)
            .fold<String?>(null, (prev, el) => el),
        testCount: results.length,
        firstTest: timestamps.first,
        lastTest: timestamps.last,
      );
    }).toList()
      ..sort((a, b) => b.lastTest.compareTo(a.lastTest));
  }

  static ReportStats computeStats(List<SpeedResult> results) {
    final successful = results.where((r) => !r.failed).toList();
    final failed = results.where((r) => r.failed).length;

    if (successful.isEmpty) {
      return ReportStats(
        avgDownload: 0,
        minDownload: 0,
        maxDownload: 0,
        avgUpload: 0,
        minUpload: 0,
        maxUpload: 0,
        avgPing: 0,
        minPing: 0,
        maxPing: 0,
        totalTests: results.length,
        failedTests: failed,
      );
    }

    final downloads =
        successful.map((r) => r.downloadMbps ?? 0).toList();
    final uploads = successful.map((r) => r.uploadMbps ?? 0).toList();
    final pings = successful.map((r) => r.pingMs ?? 0).toList();

    return ReportStats(
      avgDownload: downloads.reduce((a, b) => a + b) / downloads.length,
      minDownload: downloads.reduce((a, b) => a < b ? a : b),
      maxDownload: downloads.reduce((a, b) => a > b ? a : b),
      avgUpload: uploads.reduce((a, b) => a + b) / uploads.length,
      minUpload: uploads.reduce((a, b) => a < b ? a : b),
      maxUpload: uploads.reduce((a, b) => a > b ? a : b),
      avgPing: pings.reduce((a, b) => a + b) / pings.length,
      minPing: pings.reduce((a, b) => a < b ? a : b),
      maxPing: pings.reduce((a, b) => a > b ? a : b),
      totalTests: results.length,
      failedTests: failed,
    );
  }

  static Future<void> exportCsv(
      List<SpeedResult> results, NetworkGroup network) async {
    final buffer = StringBuffer();
    buffer.writeln('NetLog - Network Speed Report');
    buffer.writeln('Connection Type: ${network.isCellular ? "Cellular" : "Wi-Fi"}');
    buffer.writeln('Network: ${network.displayName}');
    if (network.bssid != null) buffer.writeln('BSSID: ${network.bssid}');
    if (network.ispName != null) buffer.writeln('ISP: ${network.ispName}');
    if (network.externalIp != null) {
      buffer.writeln('External IP: ${network.externalIp}');
    }
    buffer.writeln(
        'Report generated: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}');
    buffer.writeln();
    buffer.writeln(
        'Timestamp,Download (Mbps),Upload (Mbps),Ping (ms),Network Type,SSID,BSSID,External IP,ISP,Failed');

    for (final r in results) {
      buffer.writeln([
        DateFormat('yyyy-MM-dd HH:mm:ss').format(r.timestamp),
        r.downloadMbps?.toStringAsFixed(2) ?? '',
        r.uploadMbps?.toStringAsFixed(2) ?? '',
        r.pingMs?.toString() ?? '',
        r.networkType,
        r.ssid ?? '',
        r.bssid ?? '',
        r.externalIp ?? '',
        r.ispName ?? '',
        r.failed ? 'YES' : 'NO',
      ].join(','));
    }

    final dir = await getTemporaryDirectory();
    final namePart = network.isCellular
        ? 'cellular_${network.ispName ?? "unknown"}'
        : (network.ssid ?? 'unknown');
    final sanitizedName = namePart.replaceAll(RegExp(r'[^\w\s-]'), '_');
    final file = File(
        '${dir.path}/netlog_report_$sanitizedName${DateFormat('_yyyyMMdd_HHmmss').format(DateTime.now())}.csv');
    await file.writeAsString(buffer.toString());

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)]),
    );
  }

  static Future<void> exportPdf(
      List<SpeedResult> results, NetworkGroup network) async {
    final stats = computeStats(results);
    final pdf = pw.Document();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final now = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('NetLog - Network Speed Report',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.Text(dateFormat.format(now),
                    style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          _pdfSection('Network Information', [
            _pdfRow('Connection Type', network.isCellular ? 'Cellular / Mobile data' : 'Wi-Fi'),
            if (network.isWifi) _pdfRow('Network Name (SSID)', network.ssid ?? 'Unknown'),
            if (network.bssid != null)
              _pdfRow('Router ID (BSSID)', network.bssid!),
            if (network.ispName != null)
              _pdfRow('Internet Provider (ISP)', network.ispName!),
            if (network.externalIp != null)
              _pdfRow('External IP Address', network.externalIp!),
            _pdfRow('Testing Period',
                '${dateFormat.format(network.firstTest)} — ${dateFormat.format(network.lastTest)}'),
            _pdfRow('Total Tests', '${stats.totalTests}'),
            _pdfRow('Failed Tests', '${stats.failedTests}'),
          ]),
          pw.SizedBox(height: 16),
          _pdfSection('Summary Statistics', [
            _pdfStatsRow(
              'Download Speed',
              '${stats.avgDownload.toStringAsFixed(2)} Mbps',
              '${stats.minDownload.toStringAsFixed(2)} Mbps',
              '${stats.maxDownload.toStringAsFixed(2)} Mbps',
            ),
            _pdfStatsRow(
              'Upload Speed',
              '${stats.avgUpload.toStringAsFixed(2)} Mbps',
              '${stats.minUpload.toStringAsFixed(2)} Mbps',
              '${stats.maxUpload.toStringAsFixed(2)} Mbps',
            ),
            _pdfStatsRow(
              'Latency (Ping)',
              '${stats.avgPing.toStringAsFixed(0)} ms',
              '${stats.minPing} ms',
              '${stats.maxPing} ms',
            ),
          ]),
          pw.SizedBox(height: 16),
          pw.Header(level: 1, text: 'Individual Test Results'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
            cellStyle: const pw.TextStyle(fontSize: 7),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
            headers: [
              'Date & Time',
              'Download\n(Mbps)',
              'Upload\n(Mbps)',
              'Ping\n(ms)',
              'Type',
              'Status'
            ],
            data: results.map((r) {
              return [
                dateFormat.format(r.timestamp),
                r.downloadMbps?.toStringAsFixed(2) ?? '—',
                r.uploadMbps?.toStringAsFixed(2) ?? '—',
                r.pingMs?.toString() ?? '—',
                r.networkType,
                r.failed ? 'FAILED' : 'OK',
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 24),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Methodology & Disclaimer',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.SizedBox(height: 6),
                pw.Text(
                  'Speed tests were performed using HTTP transfers to Cloudflare edge servers '
                  '(speed.cloudflare.com). Download speed was measured using a 10 MB file transfer, '
                  'upload speed using a 2 MB payload, and ping via minimal HTTP round-trip. '
                  'Results may vary based on device performance, network congestion, and server load. '
                  'All timestamps are in device local time. Network identification (SSID, BSSID) '
                  'confirms tests were conducted on the specified network.',
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final namePart = network.isCellular
        ? 'cellular_${network.ispName ?? "unknown"}'
        : (network.ssid ?? 'unknown');
    final sanitizedName = namePart.replaceAll(RegExp(r'[^\w\s-]'), '_');
    final file = File(
        '${dir.path}/netlog_report_$sanitizedName${DateFormat('_yyyyMMdd_HHmmss').format(now)}.pdf');
    await file.writeAsBytes(await pdf.save());

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)]),
    );
  }

  static pw.Widget _pdfSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: title),
        pw.SizedBox(height: 4),
        ...children,
      ],
    );
  }

  static pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 180,
            child: pw.Text(label,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _pdfStatsRow(
      String label, String avg, String min, String max) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(label,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          ),
          pw.SizedBox(
            width: 100,
            child: pw.Text('Avg: $avg', style: const pw.TextStyle(fontSize: 9)),
          ),
          pw.SizedBox(
            width: 100,
            child: pw.Text('Min: $min', style: const pw.TextStyle(fontSize: 9)),
          ),
          pw.Expanded(
            child: pw.Text('Max: $max', style: const pw.TextStyle(fontSize: 9)),
          ),
        ],
      ),
    );
  }
}
