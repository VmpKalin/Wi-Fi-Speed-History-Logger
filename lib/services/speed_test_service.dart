import 'dart:typed_data';
import 'package:http/http.dart' as http;

class SpeedTestResult {
  final double? downloadMbps;
  final double? uploadMbps;
  final int? pingMs;
  final bool failed;

  SpeedTestResult({
    this.downloadMbps,
    this.uploadMbps,
    this.pingMs,
    this.failed = false,
  });
}

class SpeedTestService {
  static const _downloadUrl =
      'https://speed.cloudflare.com/__down?bytes=10000000';
  static const _uploadUrl = 'https://speed.cloudflare.com/__up';
  static const _pingUrl = 'https://speed.cloudflare.com/__down?bytes=0';

  Future<int> measurePing() async {
    final stopwatch = Stopwatch()..start();
    await http.get(Uri.parse(_pingUrl));
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }

  Future<double> measureDownloadSpeed() async {
    final stopwatch = Stopwatch()..start();
    final response = await http.get(Uri.parse(_downloadUrl));
    stopwatch.stop();

    final bytes = response.contentLength ?? response.bodyBytes.length;
    final seconds = stopwatch.elapsedMilliseconds / 1000.0;
    if (seconds <= 0) return 0;
    return (bytes * 8) / (seconds * 1000000);
  }

  Future<double> measureUploadSpeed() async {
    final payload = Uint8List(2 * 1024 * 1024);
    final stopwatch = Stopwatch()..start();
    await http.post(Uri.parse(_uploadUrl), body: payload);
    stopwatch.stop();

    final bytes = payload.length;
    final seconds = stopwatch.elapsedMilliseconds / 1000.0;
    if (seconds <= 0) return 0;
    return (bytes * 8) / (seconds * 1000000);
  }

  Future<SpeedTestResult> runFullTest() async {
    try {
      final ping = await measurePing();
      final download = await measureDownloadSpeed();
      final upload = await measureUploadSpeed();
      return SpeedTestResult(
        downloadMbps: download,
        uploadMbps: upload,
        pingMs: ping,
      );
    } catch (_) {
      return SpeedTestResult(failed: true);
    }
  }
}
