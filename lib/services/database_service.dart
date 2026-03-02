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
  int get schemaVersion => 1;

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
