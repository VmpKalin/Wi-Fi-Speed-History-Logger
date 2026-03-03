import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/background_service.dart';
import '../services/database_service.dart';
import '../services/network_info_service.dart';
import '../services/speed_test_service.dart';

// ── Core services ──

final databaseProvider = Provider<AppDatabase>((_) => AppDatabase.instance);

final speedTestServiceProvider = Provider<SpeedTestService>((_) => SpeedTestService());

final networkInfoServiceProvider = Provider<NetworkInfoService>((_) => NetworkInfoService());

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});

// ── Settings ──

final testFrequencyProvider =
    StateNotifierProvider<TestFrequencyNotifier, int>((ref) {
  return TestFrequencyNotifier(ref.watch(sharedPreferencesProvider));
});

class TestFrequencyNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  TestFrequencyNotifier(this._prefs)
      : super(_prefs.getInt('test_frequency_hours') ?? 12);

  Future<void> setFrequency(int hours) async {
    state = hours;
    await _prefs.setInt('test_frequency_hours', hours);
    await BackgroundService.registerPeriodicTask(frequencyHours: hours);
  }
}

final wifiOnlyProvider =
    StateNotifierProvider<WifiOnlyNotifier, bool>((ref) {
  return WifiOnlyNotifier(ref.watch(sharedPreferencesProvider));
});

class WifiOnlyNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  WifiOnlyNotifier(this._prefs)
      : super(_prefs.getBool('wifi_only') ?? false);

  Future<void> toggle() async {
    state = !state;
    await _prefs.setBool('wifi_only', state);
  }
}

// ── Data queries ──

final allResultsProvider = FutureProvider<List<SpeedResult>>((ref) {
  return ref.watch(databaseProvider).getAllResults();
});

final last30DaysProvider = FutureProvider<List<SpeedResult>>((ref) {
  return ref.watch(databaseProvider).getLast30DaysResults();
});

final resultsByDayProvider =
    FutureProvider<Map<DateTime, List<SpeedResult>>>((ref) {
  return ref.watch(databaseProvider).getResultsByDay();
});

// ── Speed test execution ──

final isTestRunningProvider = StateProvider<bool>((_) => false);

enum ChartView { download, upload, ping }

final chartViewProvider = StateProvider<ChartView>((_) => ChartView.download);

final runSpeedTestProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.read(isTestRunningProvider.notifier).state = true;
    try {
      final speedTest = ref.read(speedTestServiceProvider);
      final networkInfoService = ref.read(networkInfoServiceProvider);
      final db = ref.read(databaseProvider);

      final connectivityResult = await Connectivity().checkConnectivity();
      final networkType =
          connectivityResult.contains(ConnectivityResult.wifi)
              ? 'wifi'
              : 'cellular';

      final networkDetailsFuture = networkInfoService.collectNetworkDetails();
      final resultFuture = speedTest.runFullTest();

      final networkDetails = await networkDetailsFuture;
      final result = await resultFuture;

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

      ref.invalidate(allResultsProvider);
      ref.invalidate(last30DaysProvider);
      ref.invalidate(resultsByDayProvider);
    } finally {
      ref.read(isTestRunningProvider.notifier).state = false;
    }
  };
});
