import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class NetworkDetails {
  final String? ssid;
  final String? bssid;
  final String? localIp;
  final String? externalIp;
  final String? ispName;

  NetworkDetails({
    this.ssid,
    this.bssid,
    this.localIp,
    this.externalIp,
    this.ispName,
  });
}

class NetworkInfoService {
  final _networkInfo = NetworkInfo();

  Future<bool> _ensureLocationPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.locationWhenInUse.status;
      if (!status.isGranted) {
        status = await Permission.locationWhenInUse.request();
      }
      return status.isGranted;
    }
    return true;
  }

  Future<NetworkDetails> collectNetworkDetails() async {
    String? ssid;
    String? bssid;
    String? localIp;
    String? externalIp;
    String? ispName;

    final hasLocationPermission = await _ensureLocationPermission();

    if (hasLocationPermission) {
      try {
        ssid = await _networkInfo.getWifiName();
        ssid = ssid?.replaceAll('"', '');
        bssid = await _networkInfo.getWifiBSSID();
        localIp = await _networkInfo.getWifiIP();
      } catch (_) {}
    }

    try {
      final ipResponse = await http
          .get(Uri.parse('https://api.ipify.org?format=json'))
          .timeout(const Duration(seconds: 5));
      if (ipResponse.statusCode == 200) {
        final data = jsonDecode(ipResponse.body) as Map<String, dynamic>;
        externalIp = data['ip'] as String?;
      }
    } catch (_) {}

    try {
      final ispResponse = await http
          .get(Uri.parse('http://ip-api.com/json'))
          .timeout(const Duration(seconds: 5));
      if (ispResponse.statusCode == 200) {
        final data = jsonDecode(ispResponse.body) as Map<String, dynamic>;
        ispName = data['isp'] as String?;
      }
    } catch (_) {}

    return NetworkDetails(
      ssid: ssid,
      bssid: bssid,
      localIp: localIp,
      externalIp: externalIp,
      ispName: ispName,
    );
  }
}
