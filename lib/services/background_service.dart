import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'database_service.dart';
import 'network_info_service.dart';
import 'speed_test_service.dart';

const _taskName = 'com.netlog.speedtest';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        return true;
      }

      final prefs = await SharedPreferences.getInstance();
      final wifiOnly = prefs.getBool('wifi_only') ?? false;
      final isWifi = connectivityResult.contains(ConnectivityResult.wifi);

      if (wifiOnly && !isWifi) {
        return true;
      }

      final networkType = isWifi ? 'wifi' : 'cellular';
      final speedTest = SpeedTestService();
      final networkInfoService = NetworkInfoService();

      final networkDetailsFuture = networkInfoService.collectNetworkDetails();
      final resultFuture = speedTest.runFullTest();

      final networkDetails = await networkDetailsFuture;
      final result = await resultFuture;

      final db = AppDatabase.instance;
      await db.insertResult(SpeedResultsCompanion(
        timestamp: Value(DateTime.now()),
        downloadMbps: Value(result.downloadMbps),
        uploadMbps: Value(result.uploadMbps),
        pingMs: Value(result.pingMs),
        networkType: Value(networkType),
        failed: Value(result.failed),
        ssid: Value(networkDetails.ssid),
        bssid: Value(networkDetails.bssid),
        externalIp: Value(networkDetails.externalIp),
        ispName: Value(networkDetails.ispName),
        localIp: Value(networkDetails.localIp),
      ));

      // iOS doesn't support periodic tasks, so re-register a one-off task
      // after each execution to simulate periodic behavior.
      if (Platform.isIOS) {
        final frequencyHours = prefs.getInt('test_frequency_hours') ?? 12;
        await Workmanager().registerOneOffTask(
          _taskName,
          _taskName,
          initialDelay: Duration(hours: frequencyHours),
          constraints: Constraints(networkType: NetworkType.connected),
          existingWorkPolicy: ExistingWorkPolicy.replace,
        );
      }

      return true;
    } catch (_) {
      return false;
    }
  });
}

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static Future<void> registerPeriodicTask({int frequencyHours = 12}) async {
    await Workmanager().cancelAll();
    if (Platform.isIOS) {
      await Workmanager().registerOneOffTask(
        _taskName,
        _taskName,
        initialDelay: Duration(hours: frequencyHours),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    } else {
      await Workmanager().registerPeriodicTask(
        _taskName,
        _taskName,
        frequency: Duration(hours: frequencyHours),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    }
  }

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}
