// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_service.dart';

// ignore_for_file: type=lint
class $SpeedResultsTable extends SpeedResults
    with TableInfo<$SpeedResultsTable, SpeedResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeedResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _downloadMbpsMeta = const VerificationMeta(
    'downloadMbps',
  );
  @override
  late final GeneratedColumn<double> downloadMbps = GeneratedColumn<double>(
    'download_mbps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadMbpsMeta = const VerificationMeta(
    'uploadMbps',
  );
  @override
  late final GeneratedColumn<double> uploadMbps = GeneratedColumn<double>(
    'upload_mbps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pingMsMeta = const VerificationMeta('pingMs');
  @override
  late final GeneratedColumn<int> pingMs = GeneratedColumn<int>(
    'ping_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _networkTypeMeta = const VerificationMeta(
    'networkType',
  );
  @override
  late final GeneratedColumn<String> networkType = GeneratedColumn<String>(
    'network_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failedMeta = const VerificationMeta('failed');
  @override
  late final GeneratedColumn<bool> failed = GeneratedColumn<bool>(
    'failed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("failed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    downloadMbps,
    uploadMbps,
    pingMs,
    networkType,
    failed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'speed_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeedResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('download_mbps')) {
      context.handle(
        _downloadMbpsMeta,
        downloadMbps.isAcceptableOrUnknown(
          data['download_mbps']!,
          _downloadMbpsMeta,
        ),
      );
    }
    if (data.containsKey('upload_mbps')) {
      context.handle(
        _uploadMbpsMeta,
        uploadMbps.isAcceptableOrUnknown(data['upload_mbps']!, _uploadMbpsMeta),
      );
    }
    if (data.containsKey('ping_ms')) {
      context.handle(
        _pingMsMeta,
        pingMs.isAcceptableOrUnknown(data['ping_ms']!, _pingMsMeta),
      );
    }
    if (data.containsKey('network_type')) {
      context.handle(
        _networkTypeMeta,
        networkType.isAcceptableOrUnknown(
          data['network_type']!,
          _networkTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_networkTypeMeta);
    }
    if (data.containsKey('failed')) {
      context.handle(
        _failedMeta,
        failed.isAcceptableOrUnknown(data['failed']!, _failedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeedResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeedResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      downloadMbps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}download_mbps'],
      ),
      uploadMbps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}upload_mbps'],
      ),
      pingMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ping_ms'],
      ),
      networkType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network_type'],
      )!,
      failed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}failed'],
      )!,
    );
  }

  @override
  $SpeedResultsTable createAlias(String alias) {
    return $SpeedResultsTable(attachedDatabase, alias);
  }
}

class SpeedResult extends DataClass implements Insertable<SpeedResult> {
  final int id;
  final DateTime timestamp;
  final double? downloadMbps;
  final double? uploadMbps;
  final int? pingMs;
  final String networkType;
  final bool failed;
  const SpeedResult({
    required this.id,
    required this.timestamp,
    this.downloadMbps,
    this.uploadMbps,
    this.pingMs,
    required this.networkType,
    required this.failed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || downloadMbps != null) {
      map['download_mbps'] = Variable<double>(downloadMbps);
    }
    if (!nullToAbsent || uploadMbps != null) {
      map['upload_mbps'] = Variable<double>(uploadMbps);
    }
    if (!nullToAbsent || pingMs != null) {
      map['ping_ms'] = Variable<int>(pingMs);
    }
    map['network_type'] = Variable<String>(networkType);
    map['failed'] = Variable<bool>(failed);
    return map;
  }

  SpeedResultsCompanion toCompanion(bool nullToAbsent) {
    return SpeedResultsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      downloadMbps: downloadMbps == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadMbps),
      uploadMbps: uploadMbps == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadMbps),
      pingMs: pingMs == null && nullToAbsent
          ? const Value.absent()
          : Value(pingMs),
      networkType: Value(networkType),
      failed: Value(failed),
    );
  }

  factory SpeedResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeedResult(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      downloadMbps: serializer.fromJson<double?>(json['downloadMbps']),
      uploadMbps: serializer.fromJson<double?>(json['uploadMbps']),
      pingMs: serializer.fromJson<int?>(json['pingMs']),
      networkType: serializer.fromJson<String>(json['networkType']),
      failed: serializer.fromJson<bool>(json['failed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'downloadMbps': serializer.toJson<double?>(downloadMbps),
      'uploadMbps': serializer.toJson<double?>(uploadMbps),
      'pingMs': serializer.toJson<int?>(pingMs),
      'networkType': serializer.toJson<String>(networkType),
      'failed': serializer.toJson<bool>(failed),
    };
  }

  SpeedResult copyWith({
    int? id,
    DateTime? timestamp,
    Value<double?> downloadMbps = const Value.absent(),
    Value<double?> uploadMbps = const Value.absent(),
    Value<int?> pingMs = const Value.absent(),
    String? networkType,
    bool? failed,
  }) => SpeedResult(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    downloadMbps: downloadMbps.present ? downloadMbps.value : this.downloadMbps,
    uploadMbps: uploadMbps.present ? uploadMbps.value : this.uploadMbps,
    pingMs: pingMs.present ? pingMs.value : this.pingMs,
    networkType: networkType ?? this.networkType,
    failed: failed ?? this.failed,
  );
  SpeedResult copyWithCompanion(SpeedResultsCompanion data) {
    return SpeedResult(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      downloadMbps: data.downloadMbps.present
          ? data.downloadMbps.value
          : this.downloadMbps,
      uploadMbps: data.uploadMbps.present
          ? data.uploadMbps.value
          : this.uploadMbps,
      pingMs: data.pingMs.present ? data.pingMs.value : this.pingMs,
      networkType: data.networkType.present
          ? data.networkType.value
          : this.networkType,
      failed: data.failed.present ? data.failed.value : this.failed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeedResult(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('downloadMbps: $downloadMbps, ')
          ..write('uploadMbps: $uploadMbps, ')
          ..write('pingMs: $pingMs, ')
          ..write('networkType: $networkType, ')
          ..write('failed: $failed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    downloadMbps,
    uploadMbps,
    pingMs,
    networkType,
    failed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeedResult &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.downloadMbps == this.downloadMbps &&
          other.uploadMbps == this.uploadMbps &&
          other.pingMs == this.pingMs &&
          other.networkType == this.networkType &&
          other.failed == this.failed);
}

class SpeedResultsCompanion extends UpdateCompanion<SpeedResult> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<double?> downloadMbps;
  final Value<double?> uploadMbps;
  final Value<int?> pingMs;
  final Value<String> networkType;
  final Value<bool> failed;
  const SpeedResultsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.downloadMbps = const Value.absent(),
    this.uploadMbps = const Value.absent(),
    this.pingMs = const Value.absent(),
    this.networkType = const Value.absent(),
    this.failed = const Value.absent(),
  });
  SpeedResultsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    this.downloadMbps = const Value.absent(),
    this.uploadMbps = const Value.absent(),
    this.pingMs = const Value.absent(),
    required String networkType,
    this.failed = const Value.absent(),
  }) : timestamp = Value(timestamp),
       networkType = Value(networkType);
  static Insertable<SpeedResult> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<double>? downloadMbps,
    Expression<double>? uploadMbps,
    Expression<int>? pingMs,
    Expression<String>? networkType,
    Expression<bool>? failed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (downloadMbps != null) 'download_mbps': downloadMbps,
      if (uploadMbps != null) 'upload_mbps': uploadMbps,
      if (pingMs != null) 'ping_ms': pingMs,
      if (networkType != null) 'network_type': networkType,
      if (failed != null) 'failed': failed,
    });
  }

  SpeedResultsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<double?>? downloadMbps,
    Value<double?>? uploadMbps,
    Value<int?>? pingMs,
    Value<String>? networkType,
    Value<bool>? failed,
  }) {
    return SpeedResultsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      downloadMbps: downloadMbps ?? this.downloadMbps,
      uploadMbps: uploadMbps ?? this.uploadMbps,
      pingMs: pingMs ?? this.pingMs,
      networkType: networkType ?? this.networkType,
      failed: failed ?? this.failed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (downloadMbps.present) {
      map['download_mbps'] = Variable<double>(downloadMbps.value);
    }
    if (uploadMbps.present) {
      map['upload_mbps'] = Variable<double>(uploadMbps.value);
    }
    if (pingMs.present) {
      map['ping_ms'] = Variable<int>(pingMs.value);
    }
    if (networkType.present) {
      map['network_type'] = Variable<String>(networkType.value);
    }
    if (failed.present) {
      map['failed'] = Variable<bool>(failed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeedResultsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('downloadMbps: $downloadMbps, ')
          ..write('uploadMbps: $uploadMbps, ')
          ..write('pingMs: $pingMs, ')
          ..write('networkType: $networkType, ')
          ..write('failed: $failed')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SpeedResultsTable speedResults = $SpeedResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [speedResults];
}

typedef $$SpeedResultsTableCreateCompanionBuilder =
    SpeedResultsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      Value<double?> downloadMbps,
      Value<double?> uploadMbps,
      Value<int?> pingMs,
      required String networkType,
      Value<bool> failed,
    });
typedef $$SpeedResultsTableUpdateCompanionBuilder =
    SpeedResultsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<double?> downloadMbps,
      Value<double?> uploadMbps,
      Value<int?> pingMs,
      Value<String> networkType,
      Value<bool> failed,
    });

class $$SpeedResultsTableFilterComposer
    extends Composer<_$AppDatabase, $SpeedResultsTable> {
  $$SpeedResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get downloadMbps => $composableBuilder(
    column: $table.downloadMbps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get uploadMbps => $composableBuilder(
    column: $table.uploadMbps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pingMs => $composableBuilder(
    column: $table.pingMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get networkType => $composableBuilder(
    column: $table.networkType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get failed => $composableBuilder(
    column: $table.failed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpeedResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeedResultsTable> {
  $$SpeedResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get downloadMbps => $composableBuilder(
    column: $table.downloadMbps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get uploadMbps => $composableBuilder(
    column: $table.uploadMbps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pingMs => $composableBuilder(
    column: $table.pingMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get networkType => $composableBuilder(
    column: $table.networkType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get failed => $composableBuilder(
    column: $table.failed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpeedResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeedResultsTable> {
  $$SpeedResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get downloadMbps => $composableBuilder(
    column: $table.downloadMbps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get uploadMbps => $composableBuilder(
    column: $table.uploadMbps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pingMs =>
      $composableBuilder(column: $table.pingMs, builder: (column) => column);

  GeneratedColumn<String> get networkType => $composableBuilder(
    column: $table.networkType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get failed =>
      $composableBuilder(column: $table.failed, builder: (column) => column);
}

class $$SpeedResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpeedResultsTable,
          SpeedResult,
          $$SpeedResultsTableFilterComposer,
          $$SpeedResultsTableOrderingComposer,
          $$SpeedResultsTableAnnotationComposer,
          $$SpeedResultsTableCreateCompanionBuilder,
          $$SpeedResultsTableUpdateCompanionBuilder,
          (
            SpeedResult,
            BaseReferences<_$AppDatabase, $SpeedResultsTable, SpeedResult>,
          ),
          SpeedResult,
          PrefetchHooks Function()
        > {
  $$SpeedResultsTableTableManager(_$AppDatabase db, $SpeedResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeedResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeedResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeedResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double?> downloadMbps = const Value.absent(),
                Value<double?> uploadMbps = const Value.absent(),
                Value<int?> pingMs = const Value.absent(),
                Value<String> networkType = const Value.absent(),
                Value<bool> failed = const Value.absent(),
              }) => SpeedResultsCompanion(
                id: id,
                timestamp: timestamp,
                downloadMbps: downloadMbps,
                uploadMbps: uploadMbps,
                pingMs: pingMs,
                networkType: networkType,
                failed: failed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                Value<double?> downloadMbps = const Value.absent(),
                Value<double?> uploadMbps = const Value.absent(),
                Value<int?> pingMs = const Value.absent(),
                required String networkType,
                Value<bool> failed = const Value.absent(),
              }) => SpeedResultsCompanion.insert(
                id: id,
                timestamp: timestamp,
                downloadMbps: downloadMbps,
                uploadMbps: uploadMbps,
                pingMs: pingMs,
                networkType: networkType,
                failed: failed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpeedResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpeedResultsTable,
      SpeedResult,
      $$SpeedResultsTableFilterComposer,
      $$SpeedResultsTableOrderingComposer,
      $$SpeedResultsTableAnnotationComposer,
      $$SpeedResultsTableCreateCompanionBuilder,
      $$SpeedResultsTableUpdateCompanionBuilder,
      (
        SpeedResult,
        BaseReferences<_$AppDatabase, $SpeedResultsTable, SpeedResult>,
      ),
      SpeedResult,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SpeedResultsTableTableManager get speedResults =>
      $$SpeedResultsTableTableManager(_db, _db.speedResults);
}
