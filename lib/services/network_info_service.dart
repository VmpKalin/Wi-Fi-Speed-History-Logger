import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
    if (!Platform.isAndroid && !Platform.isIOS) return true;

    var status = await Permission.locationWhenInUse.status;

    if (status.isPermanentlyDenied) {
      debugPrint('NetLog: Location permission permanently denied. '
          'SSID/BSSID will be unavailable. Open Settings to grant access.');
      return false;
    }

    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }

    if (!status.isGranted) {
      debugPrint('NetLog: Location permission denied. '
          'SSID/BSSID requires location access on ${Platform.operatingSystem}.');
    }

    return status.isGranted;
  }

  Future<NetworkDetails> collectNetworkDetails() async {
    String? ssid;
    String? bssid;
    String? localIp;
    String? externalIp;
    String? ispName;

    // iOS requires a paid Apple Developer account for the
    // com.apple.developer.networking.wifi-info entitlement,
    // so SSID/BSSID collection is Android-only for now.
    if (!Platform.isIOS) {
      final hasLocationPermission = await _ensureLocationPermission();

      if (hasLocationPermission) {
        try {
          ssid = await _networkInfo.getWifiName();
          ssid = ssid?.replaceAll('"', '');

          if (ssid == '<unknown ssid>' || ssid == '0x') {
            ssid = null;
          }

          bssid = await _networkInfo.getWifiBSSID();
          if (bssid == '02:00:00:00:00:00' || bssid == '00:00:00:00:00:00') {
            bssid = null;
          }

          localIp = await _networkInfo.getWifiIP();
        } catch (e) {
          debugPrint('NetLog: Failed to read Wi-Fi info: $e');
        }
      }
    }

    try {
      localIp ??= await _networkInfo.getWifiIP();
    } catch (_) {}

    try {
      final ipResponse = await http
          .get(Uri.parse('https://api.ipify.org?format=json'))
          .timeout(const Duration(seconds: 5));
      if (ipResponse.statusCode == 200) {
        final data = jsonDecode(ipResponse.body) as Map<String, dynamic>;
        externalIp = data['ip'] as String?;
      }
    } catch (e) {
      debugPrint('NetLog: Failed to fetch external IP: $e');
    }

    try {
      final ispResponse = await http
          .get(Uri.parse('http://ip-api.com/json'))
          .timeout(const Duration(seconds: 5));
      if (ispResponse.statusCode == 200) {
        final data = jsonDecode(ispResponse.body) as Map<String, dynamic>;
        ispName = data['isp'] as String?;
      }
    } catch (e) {
      debugPrint('NetLog: Failed to fetch ISP info: $e');
    }

    return NetworkDetails(
      ssid: ssid,
      bssid: bssid,
      localIp: localIp,
      externalIp: externalIp,
      ispName: ispName,
    );
  }
}
