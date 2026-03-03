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
  static const VerificationMeta _ssidMeta = const VerificationMeta('ssid');
  @override
  late final GeneratedColumn<String> ssid = GeneratedColumn<String>(
    'ssid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bssidMeta = const VerificationMeta('bssid');
  @override
  late final GeneratedColumn<String> bssid = GeneratedColumn<String>(
    'bssid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalIpMeta = const VerificationMeta(
    'externalIp',
  );
  @override
  late final GeneratedColumn<String> externalIp = GeneratedColumn<String>(
    'external_ip',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ispNameMeta = const VerificationMeta(
    'ispName',
  );
  @override
  late final GeneratedColumn<String> ispName = GeneratedColumn<String>(
    'isp_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localIpMeta = const VerificationMeta(
    'localIp',
  );
  @override
  late final GeneratedColumn<String> localIp = GeneratedColumn<String>(
    'local_ip',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    ssid,
    bssid,
    externalIp,
    ispName,
    localIp,
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
    if (data.containsKey('ssid')) {
      context.handle(
        _ssidMeta,
        ssid.isAcceptableOrUnknown(data['ssid']!, _ssidMeta),
      );
    }
    if (data.containsKey('bssid')) {
      context.handle(
        _bssidMeta,
        bssid.isAcceptableOrUnknown(data['bssid']!, _bssidMeta),
      );
    }
    if (data.containsKey('external_ip')) {
      context.handle(
        _externalIpMeta,
        externalIp.isAcceptableOrUnknown(data['external_ip']!, _externalIpMeta),
      );
    }
    if (data.containsKey('isp_name')) {
      context.handle(
        _ispNameMeta,
        ispName.isAcceptableOrUnknown(data['isp_name']!, _ispNameMeta),
      );
    }
    if (data.containsKey('local_ip')) {
      context.handle(
        _localIpMeta,
        localIp.isAcceptableOrUnknown(data['local_ip']!, _localIpMeta),
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
      ssid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ssid'],
      ),
      bssid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bssid'],
      ),
      externalIp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_ip'],
      ),
      ispName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isp_name'],
      ),
      localIp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_ip'],
      ),
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
  final String? ssid;
  final String? bssid;
  final String? externalIp;
  final String? ispName;
  final String? localIp;
  const SpeedResult({
    required this.id,
    required this.timestamp,
    this.downloadMbps,
    this.uploadMbps,
    this.pingMs,
    required this.networkType,
    required this.failed,
    this.ssid,
    this.bssid,
    this.externalIp,
    this.ispName,
    this.localIp,
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
    if (!nullToAbsent || ssid != null) {
      map['ssid'] = Variable<String>(ssid);
    }
    if (!nullToAbsent || bssid != null) {
      map['bssid'] = Variable<String>(bssid);
    }
    if (!nullToAbsent || externalIp != null) {
      map['external_ip'] = Variable<String>(externalIp);
    }
    if (!nullToAbsent || ispName != null) {
      map['isp_name'] = Variable<String>(ispName);
    }
    if (!nullToAbsent || localIp != null) {
      map['local_ip'] = Variable<String>(localIp);
    }
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
      ssid: ssid == null && nullToAbsent ? const Value.absent() : Value(ssid),
      bssid: bssid == null && nullToAbsent
          ? const Value.absent()
          : Value(bssid),
      externalIp: externalIp == null && nullToAbsent
          ? const Value.absent()
          : Value(externalIp),
      ispName: ispName == null && nullToAbsent
          ? const Value.absent()
          : Value(ispName),
      localIp: localIp == null && nullToAbsent
          ? const Value.absent()
          : Value(localIp),
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
      ssid: serializer.fromJson<String?>(json['ssid']),
      bssid: serializer.fromJson<String?>(json['bssid']),
      externalIp: serializer.fromJson<String?>(json['externalIp']),
      ispName: serializer.fromJson<String?>(json['ispName']),
      localIp: serializer.fromJson<String?>(json['localIp']),
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
      'ssid': serializer.toJson<String?>(ssid),
      'bssid': serializer.toJson<String?>(bssid),
      'externalIp': serializer.toJson<String?>(externalIp),
      'ispName': serializer.toJson<String?>(ispName),
      'localIp': serializer.toJson<String?>(localIp),
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
    Value<String?> ssid = const Value.absent(),
    Value<String?> bssid = const Value.absent(),
    Value<String?> externalIp = const Value.absent(),
    Value<String?> ispName = const Value.absent(),
    Value<String?> localIp = const Value.absent(),
  }) => SpeedResult(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    downloadMbps: downloadMbps.present ? downloadMbps.value : this.downloadMbps,
    uploadMbps: uploadMbps.present ? uploadMbps.value : this.uploadMbps,
    pingMs: pingMs.present ? pingMs.value : this.pingMs,
    networkType: networkType ?? this.networkType,
    failed: failed ?? this.failed,
    ssid: ssid.present ? ssid.value : this.ssid,
    bssid: bssid.present ? bssid.value : this.bssid,
    externalIp: externalIp.present ? externalIp.value : this.externalIp,
    ispName: ispName.present ? ispName.value : this.ispName,
    localIp: localIp.present ? localIp.value : this.localIp,
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
      ssid: data.ssid.present ? data.ssid.value : this.ssid,
      bssid: data.bssid.present ? data.bssid.value : this.bssid,
      externalIp: data.externalIp.present
          ? data.externalIp.value
          : this.externalIp,
      ispName: data.ispName.present ? data.ispName.value : this.ispName,
      localIp: data.localIp.present ? data.localIp.value : this.localIp,
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
          ..write('failed: $failed, ')
          ..write('ssid: $ssid, ')
          ..write('bssid: $bssid, ')
          ..write('externalIp: $externalIp, ')
          ..write('ispName: $ispName, ')
          ..write('localIp: $localIp')
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
    ssid,
    bssid,
    externalIp,
    ispName,
    localIp,
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
          other.failed == this.failed &&
          other.ssid == this.ssid &&
          other.bssid == this.bssid &&
          other.externalIp == this.externalIp &&
          other.ispName == this.ispName &&
          other.localIp == this.localIp);
}

class SpeedResultsCompanion extends UpdateCompanion<SpeedResult> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<double?> downloadMbps;
  final Value<double?> uploadMbps;
  final Value<int?> pingMs;
  final Value<String> networkType;
  final Value<bool> failed;
  final Value<String?> ssid;
  final Value<String?> bssid;
  final Value<String?> externalIp;
  final Value<String?> ispName;
  final Value<String?> localIp;
  const SpeedResultsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.downloadMbps = const Value.absent(),
    this.uploadMbps = const Value.absent(),
    this.pingMs = const Value.absent(),
    this.networkType = const Value.absent(),
    this.failed = const Value.absent(),
    this.ssid = const Value.absent(),
    this.bssid = const Value.absent(),
    this.externalIp = const Value.absent(),
    this.ispName = const Value.absent(),
    this.localIp = const Value.absent(),
  });
  SpeedResultsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    this.downloadMbps = const Value.absent(),
    this.uploadMbps = const Value.absent(),
    this.pingMs = const Value.absent(),
    required String networkType,
    this.failed = const Value.absent(),
    this.ssid = const Value.absent(),
    this.bssid = const Value.absent(),
    this.externalIp = const Value.absent(),
    this.ispName = const Value.absent(),
    this.localIp = const Value.absent(),
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
    Expression<String>? ssid,
    Expression<String>? bssid,
    Expression<String>? externalIp,
    Expression<String>? ispName,
    Expression<String>? localIp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (downloadMbps != null) 'download_mbps': downloadMbps,
      if (uploadMbps != null) 'upload_mbps': uploadMbps,
      if (pingMs != null) 'ping_ms': pingMs,
      if (networkType != null) 'network_type': networkType,
      if (failed != null) 'failed': failed,
      if (ssid != null) 'ssid': ssid,
      if (bssid != null) 'bssid': bssid,
      if (externalIp != null) 'external_ip': externalIp,
      if (ispName != null) 'isp_name': ispName,
      if (localIp != null) 'local_ip': localIp,
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
    Value<String?>? ssid,
    Value<String?>? bssid,
    Value<String?>? externalIp,
    Value<String?>? ispName,
    Value<String?>? localIp,
  }) {
    return SpeedResultsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      downloadMbps: downloadMbps ?? this.downloadMbps,
      uploadMbps: uploadMbps ?? this.uploadMbps,
      pingMs: pingMs ?? this.pingMs,
      networkType: networkType ?? this.networkType,
      failed: failed ?? this.failed,
      ssid: ssid ?? this.ssid,
      bssid: bssid ?? this.bssid,
      externalIp: externalIp ?? this.externalIp,
      ispName: ispName ?? this.ispName,
      localIp: localIp ?? this.localIp,
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
    if (ssid.present) {
      map['ssid'] = Variable<String>(ssid.value);
    }
    if (bssid.present) {
      map['bssid'] = Variable<String>(bssid.value);
    }
    if (externalIp.present) {
      map['external_ip'] = Variable<String>(externalIp.value);
    }
    if (ispName.present) {
      map['isp_name'] = Variable<String>(ispName.value);
    }
    if (localIp.present) {
      map['local_ip'] = Variable<String>(localIp.value);
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
          ..write('failed: $failed, ')
          ..write('ssid: $ssid, ')
          ..write('bssid: $bssid, ')
          ..write('externalIp: $externalIp, ')
          ..write('ispName: $ispName, ')
          ..write('localIp: $localIp')
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
      Value<String?> ssid,
      Value<String?> bssid,
      Value<String?> externalIp,
      Value<String?> ispName,
      Value<String?> localIp,
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
      Value<String?> ssid,
      Value<String?> bssid,
      Value<String?> externalIp,
      Value<String?> ispName,
      Value<String?> localIp,
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

  ColumnFilters<String> get ssid => $composableBuilder(
    column: $table.ssid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bssid => $composableBuilder(
    column: $table.bssid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalIp => $composableBuilder(
    column: $table.externalIp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ispName => $composableBuilder(
    column: $table.ispName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localIp => $composableBuilder(
    column: $table.localIp,
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

  ColumnOrderings<String> get ssid => $composableBuilder(
    column: $table.ssid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bssid => $composableBuilder(
    column: $table.bssid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalIp => $composableBuilder(
    column: $table.externalIp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ispName => $composableBuilder(
    column: $table.ispName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localIp => $composableBuilder(
    column: $table.localIp,
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

  GeneratedColumn<String> get ssid =>
      $composableBuilder(column: $table.ssid, builder: (column) => column);

  GeneratedColumn<String> get bssid =>
      $composableBuilder(column: $table.bssid, builder: (column) => column);

  GeneratedColumn<String> get externalIp => $composableBuilder(
    column: $table.externalIp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ispName =>
      $composableBuilder(column: $table.ispName, builder: (column) => column);

  GeneratedColumn<String> get localIp =>
      $composableBuilder(column: $table.localIp, builder: (column) => column);
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
                Value<String?> ssid = const Value.absent(),
                Value<String?> bssid = const Value.absent(),
                Value<String?> externalIp = const Value.absent(),
                Value<String?> ispName = const Value.absent(),
                Value<String?> localIp = const Value.absent(),
              }) => SpeedResultsCompanion(
                id: id,
                timestamp: timestamp,
                downloadMbps: downloadMbps,
                uploadMbps: uploadMbps,
                pingMs: pingMs,
                networkType: networkType,
                failed: failed,
                ssid: ssid,
                bssid: bssid,
                externalIp: externalIp,
                ispName: ispName,
                localIp: localIp,
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
                Value<String?> ssid = const Value.absent(),
                Value<String?> bssid = const Value.absent(),
                Value<String?> externalIp = const Value.absent(),
                Value<String?> ispName = const Value.absent(),
                Value<String?> localIp = const Value.absent(),
              }) => SpeedResultsCompanion.insert(
                id: id,
                timestamp: timestamp,
                downloadMbps: downloadMbps,
                uploadMbps: uploadMbps,
                pingMs: pingMs,
                networkType: networkType,
                failed: failed,
                ssid: ssid,
                bssid: bssid,
                externalIp: externalIp,
                ispName: ispName,
                localIp: localIp,
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
