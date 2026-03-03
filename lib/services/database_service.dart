import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/speed_result.dart';

part 'database_service.g.dart';

@DriftDatabase(tables: [SpeedResults])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase._();

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(speedResults, speedResults.ssid);
            await migrator.addColumn(speedResults, speedResults.bssid);
            await migrator.addColumn(speedResults, speedResults.externalIp);
            await migrator.addColumn(speedResults, speedResults.ispName);
            await migrator.addColumn(speedResults, speedResults.localIp);
          }
        },
      );

  Future<int> insertResult(SpeedResultsCompanion entry) {
    return into(speedResults).insert(entry);
  }

  Future<List<SpeedResult>> getAllResults() {
    return (select(speedResults)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<List<SpeedResult>> getLast30DaysResults() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return (select(speedResults)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(thirtyDaysAgo))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
  }

  Future<Map<DateTime, List<SpeedResult>>> getResultsByDay() async {
    final results = await getAllResults();
    final map = <DateTime, List<SpeedResult>>{};
    for (final result in results) {
      final day = DateTime(
        result.timestamp.year,
        result.timestamp.month,
        result.timestamp.day,
      );
      map.putIfAbsent(day, () => []).add(result);
    }
    return map;
  }

  /// Returns unique network identifiers (SSID + BSSID pairs) with their test counts.
  Future<List<SpeedResult>> getResultsForNetwork(
      String? ssid, String? bssid) async {
    final query = select(speedResults)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);

    if (ssid != null) {
      query.where((t) => t.ssid.equals(ssid));
    } else {
      query.where((t) => t.ssid.isNull());
    }

    if (bssid != null) {
      query.where((t) => t.bssid.equals(bssid));
    } else {
      query.where((t) => t.bssid.isNull());
    }

    return query.get();
  }

  Future<int> deleteAllResults() {
    return delete(speedResults).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'netlog.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
