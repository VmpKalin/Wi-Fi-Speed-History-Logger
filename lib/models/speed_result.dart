import 'package:drift/drift.dart';

class SpeedResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get downloadMbps => real().nullable()();
  RealColumn get uploadMbps => real().nullable()();
  IntColumn get pingMs => integer().nullable()();
  TextColumn get networkType => text()();
  BoolColumn get failed => boolean().withDefault(const Constant(false))();
}
