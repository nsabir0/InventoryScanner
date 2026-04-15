// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $ScanItemsTable extends ScanItems
    with TableInfo<$ScanItemsTable, ScanItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemCodeMeta =
      const VerificationMeta('itemCode');
  @override
  late final GeneratedColumn<String> itemCode = GeneratedColumn<String>(
      'item_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userBarcodeMeta =
      const VerificationMeta('userBarcode');
  @override
  late final GeneratedColumn<String> userBarcode = GeneratedColumn<String>(
      'user_barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sBarcodeMeta =
      const VerificationMeta('sBarcode');
  @override
  late final GeneratedColumn<String> sBarcode = GeneratedColumn<String>(
      's_barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _itemDescriptionMeta =
      const VerificationMeta('itemDescription');
  @override
  late final GeneratedColumn<String> itemDescription = GeneratedColumn<String>(
      'item_description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scanQtyMeta =
      const VerificationMeta('scanQty');
  @override
  late final GeneratedColumn<String> scanQty = GeneratedColumn<String>(
      'scan_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _adjQtyMeta = const VerificationMeta('adjQty');
  @override
  late final GeneratedColumn<String> adjQty = GeneratedColumn<String>(
      'adj_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _zoneNameMeta =
      const VerificationMeta('zoneName');
  @override
  late final GeneratedColumn<String> zoneName = GeneratedColumn<String>(
      'zone_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scQtyMeta = const VerificationMeta('scQty');
  @override
  late final GeneratedColumn<String> scQty = GeneratedColumn<String>(
      'sc_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _srQtyMeta = const VerificationMeta('srQty');
  @override
  late final GeneratedColumn<String> srQty = GeneratedColumn<String>(
      'sr_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _enQtyMeta = const VerificationMeta('enQty');
  @override
  late final GeneratedColumn<String> enQty = GeneratedColumn<String>(
      'en_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createDateMeta =
      const VerificationMeta('createDate');
  @override
  late final GeneratedColumn<String> createDate = GeneratedColumn<String>(
      'create_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _systemQtyMeta =
      const VerificationMeta('systemQty');
  @override
  late final GeneratedColumn<String> systemQty = GeneratedColumn<String>(
      'system_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sQtyMeta = const VerificationMeta('sQty');
  @override
  late final GeneratedColumn<String> sQty = GeneratedColumn<String>(
      's_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _outletCodeMeta =
      const VerificationMeta('outletCode');
  @override
  late final GeneratedColumn<String> outletCode = GeneratedColumn<String>(
      'outlet_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _salePriceMeta =
      const VerificationMeta('salePrice');
  @override
  late final GeneratedColumn<String> salePrice = GeneratedColumn<String>(
      'sale_price', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cpuMeta = const VerificationMeta('cpu');
  @override
  late final GeneratedColumn<String> cpu = GeneratedColumn<String>(
      'cpu', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        itemCode,
        barcode,
        userBarcode,
        sBarcode,
        itemDescription,
        scanQty,
        adjQty,
        userId,
        deviceId,
        zoneName,
        scQty,
        srQty,
        enQty,
        createDate,
        systemQty,
        sQty,
        outletCode,
        salePrice,
        cpu,
        sessionId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_items';
  @override
  VerificationContext validateIntegrity(Insertable<ScanItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_code')) {
      context.handle(_itemCodeMeta,
          itemCode.isAcceptableOrUnknown(data['item_code']!, _itemCodeMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('user_barcode')) {
      context.handle(
          _userBarcodeMeta,
          userBarcode.isAcceptableOrUnknown(
              data['user_barcode']!, _userBarcodeMeta));
    }
    if (data.containsKey('s_barcode')) {
      context.handle(_sBarcodeMeta,
          sBarcode.isAcceptableOrUnknown(data['s_barcode']!, _sBarcodeMeta));
    }
    if (data.containsKey('item_description')) {
      context.handle(
          _itemDescriptionMeta,
          itemDescription.isAcceptableOrUnknown(
              data['item_description']!, _itemDescriptionMeta));
    }
    if (data.containsKey('scan_qty')) {
      context.handle(_scanQtyMeta,
          scanQty.isAcceptableOrUnknown(data['scan_qty']!, _scanQtyMeta));
    }
    if (data.containsKey('adj_qty')) {
      context.handle(_adjQtyMeta,
          adjQty.isAcceptableOrUnknown(data['adj_qty']!, _adjQtyMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('zone_name')) {
      context.handle(_zoneNameMeta,
          zoneName.isAcceptableOrUnknown(data['zone_name']!, _zoneNameMeta));
    }
    if (data.containsKey('sc_qty')) {
      context.handle(
          _scQtyMeta, scQty.isAcceptableOrUnknown(data['sc_qty']!, _scQtyMeta));
    }
    if (data.containsKey('sr_qty')) {
      context.handle(
          _srQtyMeta, srQty.isAcceptableOrUnknown(data['sr_qty']!, _srQtyMeta));
    }
    if (data.containsKey('en_qty')) {
      context.handle(
          _enQtyMeta, enQty.isAcceptableOrUnknown(data['en_qty']!, _enQtyMeta));
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    }
    if (data.containsKey('system_qty')) {
      context.handle(_systemQtyMeta,
          systemQty.isAcceptableOrUnknown(data['system_qty']!, _systemQtyMeta));
    }
    if (data.containsKey('s_qty')) {
      context.handle(
          _sQtyMeta, sQty.isAcceptableOrUnknown(data['s_qty']!, _sQtyMeta));
    }
    if (data.containsKey('outlet_code')) {
      context.handle(
          _outletCodeMeta,
          outletCode.isAcceptableOrUnknown(
              data['outlet_code']!, _outletCodeMeta));
    }
    if (data.containsKey('sale_price')) {
      context.handle(_salePriceMeta,
          salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta));
    }
    if (data.containsKey('cpu')) {
      context.handle(
          _cpuMeta, cpu.isAcceptableOrUnknown(data['cpu']!, _cpuMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_code']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      userBarcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_barcode']),
      sBarcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}s_barcode']),
      itemDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}item_description']),
      scanQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scan_qty']),
      adjQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}adj_qty']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      zoneName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zone_name']),
      scQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sc_qty']),
      srQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sr_qty']),
      enQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}en_qty']),
      createDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}create_date']),
      systemQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_qty']),
      sQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}s_qty']),
      outletCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}outlet_code']),
      salePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_price']),
      cpu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpu']),
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
    );
  }

  @override
  $ScanItemsTable createAlias(String alias) {
    return $ScanItemsTable(attachedDatabase, alias);
  }
}

class ScanItem extends DataClass implements Insertable<ScanItem> {
  final int id;
  final String? itemCode;
  final String? barcode;
  final String? userBarcode;
  final String? sBarcode;
  final String? itemDescription;
  final String? scanQty;
  final String? adjQty;
  final String? userId;
  final String? deviceId;
  final String? zoneName;
  final String? scQty;
  final String? srQty;
  final String? enQty;
  final String? createDate;
  final String? systemQty;
  final String? sQty;
  final String? outletCode;
  final String? salePrice;
  final String? cpu;
  final String? sessionId;
  const ScanItem(
      {required this.id,
      this.itemCode,
      this.barcode,
      this.userBarcode,
      this.sBarcode,
      this.itemDescription,
      this.scanQty,
      this.adjQty,
      this.userId,
      this.deviceId,
      this.zoneName,
      this.scQty,
      this.srQty,
      this.enQty,
      this.createDate,
      this.systemQty,
      this.sQty,
      this.outletCode,
      this.salePrice,
      this.cpu,
      this.sessionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || itemCode != null) {
      map['item_code'] = Variable<String>(itemCode);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || userBarcode != null) {
      map['user_barcode'] = Variable<String>(userBarcode);
    }
    if (!nullToAbsent || sBarcode != null) {
      map['s_barcode'] = Variable<String>(sBarcode);
    }
    if (!nullToAbsent || itemDescription != null) {
      map['item_description'] = Variable<String>(itemDescription);
    }
    if (!nullToAbsent || scanQty != null) {
      map['scan_qty'] = Variable<String>(scanQty);
    }
    if (!nullToAbsent || adjQty != null) {
      map['adj_qty'] = Variable<String>(adjQty);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    if (!nullToAbsent || zoneName != null) {
      map['zone_name'] = Variable<String>(zoneName);
    }
    if (!nullToAbsent || scQty != null) {
      map['sc_qty'] = Variable<String>(scQty);
    }
    if (!nullToAbsent || srQty != null) {
      map['sr_qty'] = Variable<String>(srQty);
    }
    if (!nullToAbsent || enQty != null) {
      map['en_qty'] = Variable<String>(enQty);
    }
    if (!nullToAbsent || createDate != null) {
      map['create_date'] = Variable<String>(createDate);
    }
    if (!nullToAbsent || systemQty != null) {
      map['system_qty'] = Variable<String>(systemQty);
    }
    if (!nullToAbsent || sQty != null) {
      map['s_qty'] = Variable<String>(sQty);
    }
    if (!nullToAbsent || outletCode != null) {
      map['outlet_code'] = Variable<String>(outletCode);
    }
    if (!nullToAbsent || salePrice != null) {
      map['sale_price'] = Variable<String>(salePrice);
    }
    if (!nullToAbsent || cpu != null) {
      map['cpu'] = Variable<String>(cpu);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    return map;
  }

  ScanItemsCompanion toCompanion(bool nullToAbsent) {
    return ScanItemsCompanion(
      id: Value(id),
      itemCode: itemCode == null && nullToAbsent
          ? const Value.absent()
          : Value(itemCode),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      userBarcode: userBarcode == null && nullToAbsent
          ? const Value.absent()
          : Value(userBarcode),
      sBarcode: sBarcode == null && nullToAbsent
          ? const Value.absent()
          : Value(sBarcode),
      itemDescription: itemDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(itemDescription),
      scanQty: scanQty == null && nullToAbsent
          ? const Value.absent()
          : Value(scanQty),
      adjQty:
          adjQty == null && nullToAbsent ? const Value.absent() : Value(adjQty),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      zoneName: zoneName == null && nullToAbsent
          ? const Value.absent()
          : Value(zoneName),
      scQty:
          scQty == null && nullToAbsent ? const Value.absent() : Value(scQty),
      srQty:
          srQty == null && nullToAbsent ? const Value.absent() : Value(srQty),
      enQty:
          enQty == null && nullToAbsent ? const Value.absent() : Value(enQty),
      createDate: createDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createDate),
      systemQty: systemQty == null && nullToAbsent
          ? const Value.absent()
          : Value(systemQty),
      sQty: sQty == null && nullToAbsent ? const Value.absent() : Value(sQty),
      outletCode: outletCode == null && nullToAbsent
          ? const Value.absent()
          : Value(outletCode),
      salePrice: salePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(salePrice),
      cpu: cpu == null && nullToAbsent ? const Value.absent() : Value(cpu),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
    );
  }

  factory ScanItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanItem(
      id: serializer.fromJson<int>(json['id']),
      itemCode: serializer.fromJson<String?>(json['itemCode']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      userBarcode: serializer.fromJson<String?>(json['userBarcode']),
      sBarcode: serializer.fromJson<String?>(json['sBarcode']),
      itemDescription: serializer.fromJson<String?>(json['itemDescription']),
      scanQty: serializer.fromJson<String?>(json['scanQty']),
      adjQty: serializer.fromJson<String?>(json['adjQty']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      zoneName: serializer.fromJson<String?>(json['zoneName']),
      scQty: serializer.fromJson<String?>(json['scQty']),
      srQty: serializer.fromJson<String?>(json['srQty']),
      enQty: serializer.fromJson<String?>(json['enQty']),
      createDate: serializer.fromJson<String?>(json['createDate']),
      systemQty: serializer.fromJson<String?>(json['systemQty']),
      sQty: serializer.fromJson<String?>(json['sQty']),
      outletCode: serializer.fromJson<String?>(json['outletCode']),
      salePrice: serializer.fromJson<String?>(json['salePrice']),
      cpu: serializer.fromJson<String?>(json['cpu']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemCode': serializer.toJson<String?>(itemCode),
      'barcode': serializer.toJson<String?>(barcode),
      'userBarcode': serializer.toJson<String?>(userBarcode),
      'sBarcode': serializer.toJson<String?>(sBarcode),
      'itemDescription': serializer.toJson<String?>(itemDescription),
      'scanQty': serializer.toJson<String?>(scanQty),
      'adjQty': serializer.toJson<String?>(adjQty),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'zoneName': serializer.toJson<String?>(zoneName),
      'scQty': serializer.toJson<String?>(scQty),
      'srQty': serializer.toJson<String?>(srQty),
      'enQty': serializer.toJson<String?>(enQty),
      'createDate': serializer.toJson<String?>(createDate),
      'systemQty': serializer.toJson<String?>(systemQty),
      'sQty': serializer.toJson<String?>(sQty),
      'outletCode': serializer.toJson<String?>(outletCode),
      'salePrice': serializer.toJson<String?>(salePrice),
      'cpu': serializer.toJson<String?>(cpu),
      'sessionId': serializer.toJson<String?>(sessionId),
    };
  }

  ScanItem copyWith(
          {int? id,
          Value<String?> itemCode = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          Value<String?> userBarcode = const Value.absent(),
          Value<String?> sBarcode = const Value.absent(),
          Value<String?> itemDescription = const Value.absent(),
          Value<String?> scanQty = const Value.absent(),
          Value<String?> adjQty = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          Value<String?> deviceId = const Value.absent(),
          Value<String?> zoneName = const Value.absent(),
          Value<String?> scQty = const Value.absent(),
          Value<String?> srQty = const Value.absent(),
          Value<String?> enQty = const Value.absent(),
          Value<String?> createDate = const Value.absent(),
          Value<String?> systemQty = const Value.absent(),
          Value<String?> sQty = const Value.absent(),
          Value<String?> outletCode = const Value.absent(),
          Value<String?> salePrice = const Value.absent(),
          Value<String?> cpu = const Value.absent(),
          Value<String?> sessionId = const Value.absent()}) =>
      ScanItem(
        id: id ?? this.id,
        itemCode: itemCode.present ? itemCode.value : this.itemCode,
        barcode: barcode.present ? barcode.value : this.barcode,
        userBarcode: userBarcode.present ? userBarcode.value : this.userBarcode,
        sBarcode: sBarcode.present ? sBarcode.value : this.sBarcode,
        itemDescription: itemDescription.present
            ? itemDescription.value
            : this.itemDescription,
        scanQty: scanQty.present ? scanQty.value : this.scanQty,
        adjQty: adjQty.present ? adjQty.value : this.adjQty,
        userId: userId.present ? userId.value : this.userId,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        zoneName: zoneName.present ? zoneName.value : this.zoneName,
        scQty: scQty.present ? scQty.value : this.scQty,
        srQty: srQty.present ? srQty.value : this.srQty,
        enQty: enQty.present ? enQty.value : this.enQty,
        createDate: createDate.present ? createDate.value : this.createDate,
        systemQty: systemQty.present ? systemQty.value : this.systemQty,
        sQty: sQty.present ? sQty.value : this.sQty,
        outletCode: outletCode.present ? outletCode.value : this.outletCode,
        salePrice: salePrice.present ? salePrice.value : this.salePrice,
        cpu: cpu.present ? cpu.value : this.cpu,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
      );
  ScanItem copyWithCompanion(ScanItemsCompanion data) {
    return ScanItem(
      id: data.id.present ? data.id.value : this.id,
      itemCode: data.itemCode.present ? data.itemCode.value : this.itemCode,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      userBarcode:
          data.userBarcode.present ? data.userBarcode.value : this.userBarcode,
      sBarcode: data.sBarcode.present ? data.sBarcode.value : this.sBarcode,
      itemDescription: data.itemDescription.present
          ? data.itemDescription.value
          : this.itemDescription,
      scanQty: data.scanQty.present ? data.scanQty.value : this.scanQty,
      adjQty: data.adjQty.present ? data.adjQty.value : this.adjQty,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      zoneName: data.zoneName.present ? data.zoneName.value : this.zoneName,
      scQty: data.scQty.present ? data.scQty.value : this.scQty,
      srQty: data.srQty.present ? data.srQty.value : this.srQty,
      enQty: data.enQty.present ? data.enQty.value : this.enQty,
      createDate:
          data.createDate.present ? data.createDate.value : this.createDate,
      systemQty: data.systemQty.present ? data.systemQty.value : this.systemQty,
      sQty: data.sQty.present ? data.sQty.value : this.sQty,
      outletCode:
          data.outletCode.present ? data.outletCode.value : this.outletCode,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      cpu: data.cpu.present ? data.cpu.value : this.cpu,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanItem(')
          ..write('id: $id, ')
          ..write('itemCode: $itemCode, ')
          ..write('barcode: $barcode, ')
          ..write('userBarcode: $userBarcode, ')
          ..write('sBarcode: $sBarcode, ')
          ..write('itemDescription: $itemDescription, ')
          ..write('scanQty: $scanQty, ')
          ..write('adjQty: $adjQty, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('zoneName: $zoneName, ')
          ..write('scQty: $scQty, ')
          ..write('srQty: $srQty, ')
          ..write('enQty: $enQty, ')
          ..write('createDate: $createDate, ')
          ..write('systemQty: $systemQty, ')
          ..write('sQty: $sQty, ')
          ..write('outletCode: $outletCode, ')
          ..write('salePrice: $salePrice, ')
          ..write('cpu: $cpu, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        itemCode,
        barcode,
        userBarcode,
        sBarcode,
        itemDescription,
        scanQty,
        adjQty,
        userId,
        deviceId,
        zoneName,
        scQty,
        srQty,
        enQty,
        createDate,
        systemQty,
        sQty,
        outletCode,
        salePrice,
        cpu,
        sessionId
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanItem &&
          other.id == this.id &&
          other.itemCode == this.itemCode &&
          other.barcode == this.barcode &&
          other.userBarcode == this.userBarcode &&
          other.sBarcode == this.sBarcode &&
          other.itemDescription == this.itemDescription &&
          other.scanQty == this.scanQty &&
          other.adjQty == this.adjQty &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.zoneName == this.zoneName &&
          other.scQty == this.scQty &&
          other.srQty == this.srQty &&
          other.enQty == this.enQty &&
          other.createDate == this.createDate &&
          other.systemQty == this.systemQty &&
          other.sQty == this.sQty &&
          other.outletCode == this.outletCode &&
          other.salePrice == this.salePrice &&
          other.cpu == this.cpu &&
          other.sessionId == this.sessionId);
}

class ScanItemsCompanion extends UpdateCompanion<ScanItem> {
  final Value<int> id;
  final Value<String?> itemCode;
  final Value<String?> barcode;
  final Value<String?> userBarcode;
  final Value<String?> sBarcode;
  final Value<String?> itemDescription;
  final Value<String?> scanQty;
  final Value<String?> adjQty;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<String?> zoneName;
  final Value<String?> scQty;
  final Value<String?> srQty;
  final Value<String?> enQty;
  final Value<String?> createDate;
  final Value<String?> systemQty;
  final Value<String?> sQty;
  final Value<String?> outletCode;
  final Value<String?> salePrice;
  final Value<String?> cpu;
  final Value<String?> sessionId;
  const ScanItemsCompanion({
    this.id = const Value.absent(),
    this.itemCode = const Value.absent(),
    this.barcode = const Value.absent(),
    this.userBarcode = const Value.absent(),
    this.sBarcode = const Value.absent(),
    this.itemDescription = const Value.absent(),
    this.scanQty = const Value.absent(),
    this.adjQty = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.zoneName = const Value.absent(),
    this.scQty = const Value.absent(),
    this.srQty = const Value.absent(),
    this.enQty = const Value.absent(),
    this.createDate = const Value.absent(),
    this.systemQty = const Value.absent(),
    this.sQty = const Value.absent(),
    this.outletCode = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.cpu = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
  ScanItemsCompanion.insert({
    this.id = const Value.absent(),
    this.itemCode = const Value.absent(),
    this.barcode = const Value.absent(),
    this.userBarcode = const Value.absent(),
    this.sBarcode = const Value.absent(),
    this.itemDescription = const Value.absent(),
    this.scanQty = const Value.absent(),
    this.adjQty = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.zoneName = const Value.absent(),
    this.scQty = const Value.absent(),
    this.srQty = const Value.absent(),
    this.enQty = const Value.absent(),
    this.createDate = const Value.absent(),
    this.systemQty = const Value.absent(),
    this.sQty = const Value.absent(),
    this.outletCode = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.cpu = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
  static Insertable<ScanItem> custom({
    Expression<int>? id,
    Expression<String>? itemCode,
    Expression<String>? barcode,
    Expression<String>? userBarcode,
    Expression<String>? sBarcode,
    Expression<String>? itemDescription,
    Expression<String>? scanQty,
    Expression<String>? adjQty,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<String>? zoneName,
    Expression<String>? scQty,
    Expression<String>? srQty,
    Expression<String>? enQty,
    Expression<String>? createDate,
    Expression<String>? systemQty,
    Expression<String>? sQty,
    Expression<String>? outletCode,
    Expression<String>? salePrice,
    Expression<String>? cpu,
    Expression<String>? sessionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemCode != null) 'item_code': itemCode,
      if (barcode != null) 'barcode': barcode,
      if (userBarcode != null) 'user_barcode': userBarcode,
      if (sBarcode != null) 's_barcode': sBarcode,
      if (itemDescription != null) 'item_description': itemDescription,
      if (scanQty != null) 'scan_qty': scanQty,
      if (adjQty != null) 'adj_qty': adjQty,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (zoneName != null) 'zone_name': zoneName,
      if (scQty != null) 'sc_qty': scQty,
      if (srQty != null) 'sr_qty': srQty,
      if (enQty != null) 'en_qty': enQty,
      if (createDate != null) 'create_date': createDate,
      if (systemQty != null) 'system_qty': systemQty,
      if (sQty != null) 's_qty': sQty,
      if (outletCode != null) 'outlet_code': outletCode,
      if (salePrice != null) 'sale_price': salePrice,
      if (cpu != null) 'cpu': cpu,
      if (sessionId != null) 'session_id': sessionId,
    });
  }

  ScanItemsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? itemCode,
      Value<String?>? barcode,
      Value<String?>? userBarcode,
      Value<String?>? sBarcode,
      Value<String?>? itemDescription,
      Value<String?>? scanQty,
      Value<String?>? adjQty,
      Value<String?>? userId,
      Value<String?>? deviceId,
      Value<String?>? zoneName,
      Value<String?>? scQty,
      Value<String?>? srQty,
      Value<String?>? enQty,
      Value<String?>? createDate,
      Value<String?>? systemQty,
      Value<String?>? sQty,
      Value<String?>? outletCode,
      Value<String?>? salePrice,
      Value<String?>? cpu,
      Value<String?>? sessionId}) {
    return ScanItemsCompanion(
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      barcode: barcode ?? this.barcode,
      userBarcode: userBarcode ?? this.userBarcode,
      sBarcode: sBarcode ?? this.sBarcode,
      itemDescription: itemDescription ?? this.itemDescription,
      scanQty: scanQty ?? this.scanQty,
      adjQty: adjQty ?? this.adjQty,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      zoneName: zoneName ?? this.zoneName,
      scQty: scQty ?? this.scQty,
      srQty: srQty ?? this.srQty,
      enQty: enQty ?? this.enQty,
      createDate: createDate ?? this.createDate,
      systemQty: systemQty ?? this.systemQty,
      sQty: sQty ?? this.sQty,
      outletCode: outletCode ?? this.outletCode,
      salePrice: salePrice ?? this.salePrice,
      cpu: cpu ?? this.cpu,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemCode.present) {
      map['item_code'] = Variable<String>(itemCode.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (userBarcode.present) {
      map['user_barcode'] = Variable<String>(userBarcode.value);
    }
    if (sBarcode.present) {
      map['s_barcode'] = Variable<String>(sBarcode.value);
    }
    if (itemDescription.present) {
      map['item_description'] = Variable<String>(itemDescription.value);
    }
    if (scanQty.present) {
      map['scan_qty'] = Variable<String>(scanQty.value);
    }
    if (adjQty.present) {
      map['adj_qty'] = Variable<String>(adjQty.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (zoneName.present) {
      map['zone_name'] = Variable<String>(zoneName.value);
    }
    if (scQty.present) {
      map['sc_qty'] = Variable<String>(scQty.value);
    }
    if (srQty.present) {
      map['sr_qty'] = Variable<String>(srQty.value);
    }
    if (enQty.present) {
      map['en_qty'] = Variable<String>(enQty.value);
    }
    if (createDate.present) {
      map['create_date'] = Variable<String>(createDate.value);
    }
    if (systemQty.present) {
      map['system_qty'] = Variable<String>(systemQty.value);
    }
    if (sQty.present) {
      map['s_qty'] = Variable<String>(sQty.value);
    }
    if (outletCode.present) {
      map['outlet_code'] = Variable<String>(outletCode.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<String>(salePrice.value);
    }
    if (cpu.present) {
      map['cpu'] = Variable<String>(cpu.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanItemsCompanion(')
          ..write('id: $id, ')
          ..write('itemCode: $itemCode, ')
          ..write('barcode: $barcode, ')
          ..write('userBarcode: $userBarcode, ')
          ..write('sBarcode: $sBarcode, ')
          ..write('itemDescription: $itemDescription, ')
          ..write('scanQty: $scanQty, ')
          ..write('adjQty: $adjQty, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('zoneName: $zoneName, ')
          ..write('scQty: $scQty, ')
          ..write('srQty: $srQty, ')
          ..write('enQty: $enQty, ')
          ..write('createDate: $createDate, ')
          ..write('systemQty: $systemQty, ')
          ..write('sQty: $sQty, ')
          ..write('outletCode: $outletCode, ')
          ..write('salePrice: $salePrice, ')
          ..write('cpu: $cpu, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }
}

class $TempScanItemsTable extends TempScanItems
    with TableInfo<$TempScanItemsTable, TempScanItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TempScanItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemCodeMeta =
      const VerificationMeta('itemCode');
  @override
  late final GeneratedColumn<String> itemCode = GeneratedColumn<String>(
      'item_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userBarcodeMeta =
      const VerificationMeta('userBarcode');
  @override
  late final GeneratedColumn<String> userBarcode = GeneratedColumn<String>(
      'user_barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sBarcodeMeta =
      const VerificationMeta('sBarcode');
  @override
  late final GeneratedColumn<String> sBarcode = GeneratedColumn<String>(
      's_barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _itemDescriptionMeta =
      const VerificationMeta('itemDescription');
  @override
  late final GeneratedColumn<String> itemDescription = GeneratedColumn<String>(
      'item_description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scanQtyMeta =
      const VerificationMeta('scanQty');
  @override
  late final GeneratedColumn<String> scanQty = GeneratedColumn<String>(
      'scan_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _adjQtyMeta = const VerificationMeta('adjQty');
  @override
  late final GeneratedColumn<String> adjQty = GeneratedColumn<String>(
      'adj_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _zoneNameMeta =
      const VerificationMeta('zoneName');
  @override
  late final GeneratedColumn<String> zoneName = GeneratedColumn<String>(
      'zone_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scQtyMeta = const VerificationMeta('scQty');
  @override
  late final GeneratedColumn<String> scQty = GeneratedColumn<String>(
      'sc_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _srQtyMeta = const VerificationMeta('srQty');
  @override
  late final GeneratedColumn<String> srQty = GeneratedColumn<String>(
      'sr_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _enQtyMeta = const VerificationMeta('enQty');
  @override
  late final GeneratedColumn<String> enQty = GeneratedColumn<String>(
      'en_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createDateMeta =
      const VerificationMeta('createDate');
  @override
  late final GeneratedColumn<String> createDate = GeneratedColumn<String>(
      'create_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _systemQtyMeta =
      const VerificationMeta('systemQty');
  @override
  late final GeneratedColumn<String> systemQty = GeneratedColumn<String>(
      'system_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sQtyMeta = const VerificationMeta('sQty');
  @override
  late final GeneratedColumn<String> sQty = GeneratedColumn<String>(
      's_qty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _outletCodeMeta =
      const VerificationMeta('outletCode');
  @override
  late final GeneratedColumn<String> outletCode = GeneratedColumn<String>(
      'outlet_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _salePriceMeta =
      const VerificationMeta('salePrice');
  @override
  late final GeneratedColumn<String> salePrice = GeneratedColumn<String>(
      'sale_price', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cpuMeta = const VerificationMeta('cpu');
  @override
  late final GeneratedColumn<String> cpu = GeneratedColumn<String>(
      'cpu', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        itemCode,
        barcode,
        userBarcode,
        sBarcode,
        itemDescription,
        scanQty,
        adjQty,
        userId,
        deviceId,
        zoneName,
        scQty,
        srQty,
        enQty,
        createDate,
        systemQty,
        sQty,
        outletCode,
        salePrice,
        cpu,
        sessionId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'temp_scan_items';
  @override
  VerificationContext validateIntegrity(Insertable<TempScanItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_code')) {
      context.handle(_itemCodeMeta,
          itemCode.isAcceptableOrUnknown(data['item_code']!, _itemCodeMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('user_barcode')) {
      context.handle(
          _userBarcodeMeta,
          userBarcode.isAcceptableOrUnknown(
              data['user_barcode']!, _userBarcodeMeta));
    }
    if (data.containsKey('s_barcode')) {
      context.handle(_sBarcodeMeta,
          sBarcode.isAcceptableOrUnknown(data['s_barcode']!, _sBarcodeMeta));
    }
    if (data.containsKey('item_description')) {
      context.handle(
          _itemDescriptionMeta,
          itemDescription.isAcceptableOrUnknown(
              data['item_description']!, _itemDescriptionMeta));
    }
    if (data.containsKey('scan_qty')) {
      context.handle(_scanQtyMeta,
          scanQty.isAcceptableOrUnknown(data['scan_qty']!, _scanQtyMeta));
    }
    if (data.containsKey('adj_qty')) {
      context.handle(_adjQtyMeta,
          adjQty.isAcceptableOrUnknown(data['adj_qty']!, _adjQtyMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('zone_name')) {
      context.handle(_zoneNameMeta,
          zoneName.isAcceptableOrUnknown(data['zone_name']!, _zoneNameMeta));
    }
    if (data.containsKey('sc_qty')) {
      context.handle(
          _scQtyMeta, scQty.isAcceptableOrUnknown(data['sc_qty']!, _scQtyMeta));
    }
    if (data.containsKey('sr_qty')) {
      context.handle(
          _srQtyMeta, srQty.isAcceptableOrUnknown(data['sr_qty']!, _srQtyMeta));
    }
    if (data.containsKey('en_qty')) {
      context.handle(
          _enQtyMeta, enQty.isAcceptableOrUnknown(data['en_qty']!, _enQtyMeta));
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    }
    if (data.containsKey('system_qty')) {
      context.handle(_systemQtyMeta,
          systemQty.isAcceptableOrUnknown(data['system_qty']!, _systemQtyMeta));
    }
    if (data.containsKey('s_qty')) {
      context.handle(
          _sQtyMeta, sQty.isAcceptableOrUnknown(data['s_qty']!, _sQtyMeta));
    }
    if (data.containsKey('outlet_code')) {
      context.handle(
          _outletCodeMeta,
          outletCode.isAcceptableOrUnknown(
              data['outlet_code']!, _outletCodeMeta));
    }
    if (data.containsKey('sale_price')) {
      context.handle(_salePriceMeta,
          salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta));
    }
    if (data.containsKey('cpu')) {
      context.handle(
          _cpuMeta, cpu.isAcceptableOrUnknown(data['cpu']!, _cpuMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TempScanItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TempScanItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_code']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      userBarcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_barcode']),
      sBarcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}s_barcode']),
      itemDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}item_description']),
      scanQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scan_qty']),
      adjQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}adj_qty']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      zoneName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zone_name']),
      scQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sc_qty']),
      srQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sr_qty']),
      enQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}en_qty']),
      createDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}create_date']),
      systemQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_qty']),
      sQty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}s_qty']),
      outletCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}outlet_code']),
      salePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_price']),
      cpu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpu']),
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
    );
  }

  @override
  $TempScanItemsTable createAlias(String alias) {
    return $TempScanItemsTable(attachedDatabase, alias);
  }
}

class TempScanItem extends DataClass implements Insertable<TempScanItem> {
  final int id;
  final String? itemCode;
  final String? barcode;
  final String? userBarcode;
  final String? sBarcode;
  final String? itemDescription;
  final String? scanQty;
  final String? adjQty;
  final String? userId;
  final String? deviceId;
  final String? zoneName;
  final String? scQty;
  final String? srQty;
  final String? enQty;
  final String? createDate;
  final String? systemQty;
  final String? sQty;
  final String? outletCode;
  final String? salePrice;
  final String? cpu;
  final String? sessionId;
  const TempScanItem(
      {required this.id,
      this.itemCode,
      this.barcode,
      this.userBarcode,
      this.sBarcode,
      this.itemDescription,
      this.scanQty,
      this.adjQty,
      this.userId,
      this.deviceId,
      this.zoneName,
      this.scQty,
      this.srQty,
      this.enQty,
      this.createDate,
      this.systemQty,
      this.sQty,
      this.outletCode,
      this.salePrice,
      this.cpu,
      this.sessionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || itemCode != null) {
      map['item_code'] = Variable<String>(itemCode);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || userBarcode != null) {
      map['user_barcode'] = Variable<String>(userBarcode);
    }
    if (!nullToAbsent || sBarcode != null) {
      map['s_barcode'] = Variable<String>(sBarcode);
    }
    if (!nullToAbsent || itemDescription != null) {
      map['item_description'] = Variable<String>(itemDescription);
    }
    if (!nullToAbsent || scanQty != null) {
      map['scan_qty'] = Variable<String>(scanQty);
    }
    if (!nullToAbsent || adjQty != null) {
      map['adj_qty'] = Variable<String>(adjQty);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    if (!nullToAbsent || zoneName != null) {
      map['zone_name'] = Variable<String>(zoneName);
    }
    if (!nullToAbsent || scQty != null) {
      map['sc_qty'] = Variable<String>(scQty);
    }
    if (!nullToAbsent || srQty != null) {
      map['sr_qty'] = Variable<String>(srQty);
    }
    if (!nullToAbsent || enQty != null) {
      map['en_qty'] = Variable<String>(enQty);
    }
    if (!nullToAbsent || createDate != null) {
      map['create_date'] = Variable<String>(createDate);
    }
    if (!nullToAbsent || systemQty != null) {
      map['system_qty'] = Variable<String>(systemQty);
    }
    if (!nullToAbsent || sQty != null) {
      map['s_qty'] = Variable<String>(sQty);
    }
    if (!nullToAbsent || outletCode != null) {
      map['outlet_code'] = Variable<String>(outletCode);
    }
    if (!nullToAbsent || salePrice != null) {
      map['sale_price'] = Variable<String>(salePrice);
    }
    if (!nullToAbsent || cpu != null) {
      map['cpu'] = Variable<String>(cpu);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    return map;
  }

  TempScanItemsCompanion toCompanion(bool nullToAbsent) {
    return TempScanItemsCompanion(
      id: Value(id),
      itemCode: itemCode == null && nullToAbsent
          ? const Value.absent()
          : Value(itemCode),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      userBarcode: userBarcode == null && nullToAbsent
          ? const Value.absent()
          : Value(userBarcode),
      sBarcode: sBarcode == null && nullToAbsent
          ? const Value.absent()
          : Value(sBarcode),
      itemDescription: itemDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(itemDescription),
      scanQty: scanQty == null && nullToAbsent
          ? const Value.absent()
          : Value(scanQty),
      adjQty:
          adjQty == null && nullToAbsent ? const Value.absent() : Value(adjQty),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      zoneName: zoneName == null && nullToAbsent
          ? const Value.absent()
          : Value(zoneName),
      scQty:
          scQty == null && nullToAbsent ? const Value.absent() : Value(scQty),
      srQty:
          srQty == null && nullToAbsent ? const Value.absent() : Value(srQty),
      enQty:
          enQty == null && nullToAbsent ? const Value.absent() : Value(enQty),
      createDate: createDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createDate),
      systemQty: systemQty == null && nullToAbsent
          ? const Value.absent()
          : Value(systemQty),
      sQty: sQty == null && nullToAbsent ? const Value.absent() : Value(sQty),
      outletCode: outletCode == null && nullToAbsent
          ? const Value.absent()
          : Value(outletCode),
      salePrice: salePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(salePrice),
      cpu: cpu == null && nullToAbsent ? const Value.absent() : Value(cpu),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
    );
  }

  factory TempScanItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TempScanItem(
      id: serializer.fromJson<int>(json['id']),
      itemCode: serializer.fromJson<String?>(json['itemCode']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      userBarcode: serializer.fromJson<String?>(json['userBarcode']),
      sBarcode: serializer.fromJson<String?>(json['sBarcode']),
      itemDescription: serializer.fromJson<String?>(json['itemDescription']),
      scanQty: serializer.fromJson<String?>(json['scanQty']),
      adjQty: serializer.fromJson<String?>(json['adjQty']),
      userId: serializer.fromJson<String?>(json['userId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      zoneName: serializer.fromJson<String?>(json['zoneName']),
      scQty: serializer.fromJson<String?>(json['scQty']),
      srQty: serializer.fromJson<String?>(json['srQty']),
      enQty: serializer.fromJson<String?>(json['enQty']),
      createDate: serializer.fromJson<String?>(json['createDate']),
      systemQty: serializer.fromJson<String?>(json['systemQty']),
      sQty: serializer.fromJson<String?>(json['sQty']),
      outletCode: serializer.fromJson<String?>(json['outletCode']),
      salePrice: serializer.fromJson<String?>(json['salePrice']),
      cpu: serializer.fromJson<String?>(json['cpu']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemCode': serializer.toJson<String?>(itemCode),
      'barcode': serializer.toJson<String?>(barcode),
      'userBarcode': serializer.toJson<String?>(userBarcode),
      'sBarcode': serializer.toJson<String?>(sBarcode),
      'itemDescription': serializer.toJson<String?>(itemDescription),
      'scanQty': serializer.toJson<String?>(scanQty),
      'adjQty': serializer.toJson<String?>(adjQty),
      'userId': serializer.toJson<String?>(userId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'zoneName': serializer.toJson<String?>(zoneName),
      'scQty': serializer.toJson<String?>(scQty),
      'srQty': serializer.toJson<String?>(srQty),
      'enQty': serializer.toJson<String?>(enQty),
      'createDate': serializer.toJson<String?>(createDate),
      'systemQty': serializer.toJson<String?>(systemQty),
      'sQty': serializer.toJson<String?>(sQty),
      'outletCode': serializer.toJson<String?>(outletCode),
      'salePrice': serializer.toJson<String?>(salePrice),
      'cpu': serializer.toJson<String?>(cpu),
      'sessionId': serializer.toJson<String?>(sessionId),
    };
  }

  TempScanItem copyWith(
          {int? id,
          Value<String?> itemCode = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          Value<String?> userBarcode = const Value.absent(),
          Value<String?> sBarcode = const Value.absent(),
          Value<String?> itemDescription = const Value.absent(),
          Value<String?> scanQty = const Value.absent(),
          Value<String?> adjQty = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          Value<String?> deviceId = const Value.absent(),
          Value<String?> zoneName = const Value.absent(),
          Value<String?> scQty = const Value.absent(),
          Value<String?> srQty = const Value.absent(),
          Value<String?> enQty = const Value.absent(),
          Value<String?> createDate = const Value.absent(),
          Value<String?> systemQty = const Value.absent(),
          Value<String?> sQty = const Value.absent(),
          Value<String?> outletCode = const Value.absent(),
          Value<String?> salePrice = const Value.absent(),
          Value<String?> cpu = const Value.absent(),
          Value<String?> sessionId = const Value.absent()}) =>
      TempScanItem(
        id: id ?? this.id,
        itemCode: itemCode.present ? itemCode.value : this.itemCode,
        barcode: barcode.present ? barcode.value : this.barcode,
        userBarcode: userBarcode.present ? userBarcode.value : this.userBarcode,
        sBarcode: sBarcode.present ? sBarcode.value : this.sBarcode,
        itemDescription: itemDescription.present
            ? itemDescription.value
            : this.itemDescription,
        scanQty: scanQty.present ? scanQty.value : this.scanQty,
        adjQty: adjQty.present ? adjQty.value : this.adjQty,
        userId: userId.present ? userId.value : this.userId,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        zoneName: zoneName.present ? zoneName.value : this.zoneName,
        scQty: scQty.present ? scQty.value : this.scQty,
        srQty: srQty.present ? srQty.value : this.srQty,
        enQty: enQty.present ? enQty.value : this.enQty,
        createDate: createDate.present ? createDate.value : this.createDate,
        systemQty: systemQty.present ? systemQty.value : this.systemQty,
        sQty: sQty.present ? sQty.value : this.sQty,
        outletCode: outletCode.present ? outletCode.value : this.outletCode,
        salePrice: salePrice.present ? salePrice.value : this.salePrice,
        cpu: cpu.present ? cpu.value : this.cpu,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
      );
  TempScanItem copyWithCompanion(TempScanItemsCompanion data) {
    return TempScanItem(
      id: data.id.present ? data.id.value : this.id,
      itemCode: data.itemCode.present ? data.itemCode.value : this.itemCode,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      userBarcode:
          data.userBarcode.present ? data.userBarcode.value : this.userBarcode,
      sBarcode: data.sBarcode.present ? data.sBarcode.value : this.sBarcode,
      itemDescription: data.itemDescription.present
          ? data.itemDescription.value
          : this.itemDescription,
      scanQty: data.scanQty.present ? data.scanQty.value : this.scanQty,
      adjQty: data.adjQty.present ? data.adjQty.value : this.adjQty,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      zoneName: data.zoneName.present ? data.zoneName.value : this.zoneName,
      scQty: data.scQty.present ? data.scQty.value : this.scQty,
      srQty: data.srQty.present ? data.srQty.value : this.srQty,
      enQty: data.enQty.present ? data.enQty.value : this.enQty,
      createDate:
          data.createDate.present ? data.createDate.value : this.createDate,
      systemQty: data.systemQty.present ? data.systemQty.value : this.systemQty,
      sQty: data.sQty.present ? data.sQty.value : this.sQty,
      outletCode:
          data.outletCode.present ? data.outletCode.value : this.outletCode,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      cpu: data.cpu.present ? data.cpu.value : this.cpu,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TempScanItem(')
          ..write('id: $id, ')
          ..write('itemCode: $itemCode, ')
          ..write('barcode: $barcode, ')
          ..write('userBarcode: $userBarcode, ')
          ..write('sBarcode: $sBarcode, ')
          ..write('itemDescription: $itemDescription, ')
          ..write('scanQty: $scanQty, ')
          ..write('adjQty: $adjQty, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('zoneName: $zoneName, ')
          ..write('scQty: $scQty, ')
          ..write('srQty: $srQty, ')
          ..write('enQty: $enQty, ')
          ..write('createDate: $createDate, ')
          ..write('systemQty: $systemQty, ')
          ..write('sQty: $sQty, ')
          ..write('outletCode: $outletCode, ')
          ..write('salePrice: $salePrice, ')
          ..write('cpu: $cpu, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        itemCode,
        barcode,
        userBarcode,
        sBarcode,
        itemDescription,
        scanQty,
        adjQty,
        userId,
        deviceId,
        zoneName,
        scQty,
        srQty,
        enQty,
        createDate,
        systemQty,
        sQty,
        outletCode,
        salePrice,
        cpu,
        sessionId
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TempScanItem &&
          other.id == this.id &&
          other.itemCode == this.itemCode &&
          other.barcode == this.barcode &&
          other.userBarcode == this.userBarcode &&
          other.sBarcode == this.sBarcode &&
          other.itemDescription == this.itemDescription &&
          other.scanQty == this.scanQty &&
          other.adjQty == this.adjQty &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.zoneName == this.zoneName &&
          other.scQty == this.scQty &&
          other.srQty == this.srQty &&
          other.enQty == this.enQty &&
          other.createDate == this.createDate &&
          other.systemQty == this.systemQty &&
          other.sQty == this.sQty &&
          other.outletCode == this.outletCode &&
          other.salePrice == this.salePrice &&
          other.cpu == this.cpu &&
          other.sessionId == this.sessionId);
}

class TempScanItemsCompanion extends UpdateCompanion<TempScanItem> {
  final Value<int> id;
  final Value<String?> itemCode;
  final Value<String?> barcode;
  final Value<String?> userBarcode;
  final Value<String?> sBarcode;
  final Value<String?> itemDescription;
  final Value<String?> scanQty;
  final Value<String?> adjQty;
  final Value<String?> userId;
  final Value<String?> deviceId;
  final Value<String?> zoneName;
  final Value<String?> scQty;
  final Value<String?> srQty;
  final Value<String?> enQty;
  final Value<String?> createDate;
  final Value<String?> systemQty;
  final Value<String?> sQty;
  final Value<String?> outletCode;
  final Value<String?> salePrice;
  final Value<String?> cpu;
  final Value<String?> sessionId;
  const TempScanItemsCompanion({
    this.id = const Value.absent(),
    this.itemCode = const Value.absent(),
    this.barcode = const Value.absent(),
    this.userBarcode = const Value.absent(),
    this.sBarcode = const Value.absent(),
    this.itemDescription = const Value.absent(),
    this.scanQty = const Value.absent(),
    this.adjQty = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.zoneName = const Value.absent(),
    this.scQty = const Value.absent(),
    this.srQty = const Value.absent(),
    this.enQty = const Value.absent(),
    this.createDate = const Value.absent(),
    this.systemQty = const Value.absent(),
    this.sQty = const Value.absent(),
    this.outletCode = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.cpu = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
  TempScanItemsCompanion.insert({
    this.id = const Value.absent(),
    this.itemCode = const Value.absent(),
    this.barcode = const Value.absent(),
    this.userBarcode = const Value.absent(),
    this.sBarcode = const Value.absent(),
    this.itemDescription = const Value.absent(),
    this.scanQty = const Value.absent(),
    this.adjQty = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.zoneName = const Value.absent(),
    this.scQty = const Value.absent(),
    this.srQty = const Value.absent(),
    this.enQty = const Value.absent(),
    this.createDate = const Value.absent(),
    this.systemQty = const Value.absent(),
    this.sQty = const Value.absent(),
    this.outletCode = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.cpu = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
  static Insertable<TempScanItem> custom({
    Expression<int>? id,
    Expression<String>? itemCode,
    Expression<String>? barcode,
    Expression<String>? userBarcode,
    Expression<String>? sBarcode,
    Expression<String>? itemDescription,
    Expression<String>? scanQty,
    Expression<String>? adjQty,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<String>? zoneName,
    Expression<String>? scQty,
    Expression<String>? srQty,
    Expression<String>? enQty,
    Expression<String>? createDate,
    Expression<String>? systemQty,
    Expression<String>? sQty,
    Expression<String>? outletCode,
    Expression<String>? salePrice,
    Expression<String>? cpu,
    Expression<String>? sessionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemCode != null) 'item_code': itemCode,
      if (barcode != null) 'barcode': barcode,
      if (userBarcode != null) 'user_barcode': userBarcode,
      if (sBarcode != null) 's_barcode': sBarcode,
      if (itemDescription != null) 'item_description': itemDescription,
      if (scanQty != null) 'scan_qty': scanQty,
      if (adjQty != null) 'adj_qty': adjQty,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (zoneName != null) 'zone_name': zoneName,
      if (scQty != null) 'sc_qty': scQty,
      if (srQty != null) 'sr_qty': srQty,
      if (enQty != null) 'en_qty': enQty,
      if (createDate != null) 'create_date': createDate,
      if (systemQty != null) 'system_qty': systemQty,
      if (sQty != null) 's_qty': sQty,
      if (outletCode != null) 'outlet_code': outletCode,
      if (salePrice != null) 'sale_price': salePrice,
      if (cpu != null) 'cpu': cpu,
      if (sessionId != null) 'session_id': sessionId,
    });
  }

  TempScanItemsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? itemCode,
      Value<String?>? barcode,
      Value<String?>? userBarcode,
      Value<String?>? sBarcode,
      Value<String?>? itemDescription,
      Value<String?>? scanQty,
      Value<String?>? adjQty,
      Value<String?>? userId,
      Value<String?>? deviceId,
      Value<String?>? zoneName,
      Value<String?>? scQty,
      Value<String?>? srQty,
      Value<String?>? enQty,
      Value<String?>? createDate,
      Value<String?>? systemQty,
      Value<String?>? sQty,
      Value<String?>? outletCode,
      Value<String?>? salePrice,
      Value<String?>? cpu,
      Value<String?>? sessionId}) {
    return TempScanItemsCompanion(
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      barcode: barcode ?? this.barcode,
      userBarcode: userBarcode ?? this.userBarcode,
      sBarcode: sBarcode ?? this.sBarcode,
      itemDescription: itemDescription ?? this.itemDescription,
      scanQty: scanQty ?? this.scanQty,
      adjQty: adjQty ?? this.adjQty,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      zoneName: zoneName ?? this.zoneName,
      scQty: scQty ?? this.scQty,
      srQty: srQty ?? this.srQty,
      enQty: enQty ?? this.enQty,
      createDate: createDate ?? this.createDate,
      systemQty: systemQty ?? this.systemQty,
      sQty: sQty ?? this.sQty,
      outletCode: outletCode ?? this.outletCode,
      salePrice: salePrice ?? this.salePrice,
      cpu: cpu ?? this.cpu,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemCode.present) {
      map['item_code'] = Variable<String>(itemCode.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (userBarcode.present) {
      map['user_barcode'] = Variable<String>(userBarcode.value);
    }
    if (sBarcode.present) {
      map['s_barcode'] = Variable<String>(sBarcode.value);
    }
    if (itemDescription.present) {
      map['item_description'] = Variable<String>(itemDescription.value);
    }
    if (scanQty.present) {
      map['scan_qty'] = Variable<String>(scanQty.value);
    }
    if (adjQty.present) {
      map['adj_qty'] = Variable<String>(adjQty.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (zoneName.present) {
      map['zone_name'] = Variable<String>(zoneName.value);
    }
    if (scQty.present) {
      map['sc_qty'] = Variable<String>(scQty.value);
    }
    if (srQty.present) {
      map['sr_qty'] = Variable<String>(srQty.value);
    }
    if (enQty.present) {
      map['en_qty'] = Variable<String>(enQty.value);
    }
    if (createDate.present) {
      map['create_date'] = Variable<String>(createDate.value);
    }
    if (systemQty.present) {
      map['system_qty'] = Variable<String>(systemQty.value);
    }
    if (sQty.present) {
      map['s_qty'] = Variable<String>(sQty.value);
    }
    if (outletCode.present) {
      map['outlet_code'] = Variable<String>(outletCode.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<String>(salePrice.value);
    }
    if (cpu.present) {
      map['cpu'] = Variable<String>(cpu.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TempScanItemsCompanion(')
          ..write('id: $id, ')
          ..write('itemCode: $itemCode, ')
          ..write('barcode: $barcode, ')
          ..write('userBarcode: $userBarcode, ')
          ..write('sBarcode: $sBarcode, ')
          ..write('itemDescription: $itemDescription, ')
          ..write('scanQty: $scanQty, ')
          ..write('adjQty: $adjQty, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('zoneName: $zoneName, ')
          ..write('scQty: $scQty, ')
          ..write('srQty: $srQty, ')
          ..write('enQty: $enQty, ')
          ..write('createDate: $createDate, ')
          ..write('systemQty: $systemQty, ')
          ..write('sQty: $sQty, ')
          ..write('outletCode: $outletCode, ')
          ..write('salePrice: $salePrice, ')
          ..write('cpu: $cpu, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }
}

class $InventoryDataTable extends InventoryData
    with TableInfo<$InventoryDataTable, InventoryDataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sBarcodeMeta =
      const VerificationMeta('sBarcode');
  @override
  late final GeneratedColumn<String> sBarcode = GeneratedColumn<String>(
      's_barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userBarcodeMeta =
      const VerificationMeta('userBarcode');
  @override
  late final GeneratedColumn<String> userBarcode = GeneratedColumn<String>(
      'user_barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startQtyMeta =
      const VerificationMeta('startQty');
  @override
  late final GeneratedColumn<double> startQty = GeneratedColumn<double>(
      'start_qty', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _scanQtyMeta =
      const VerificationMeta('scanQty');
  @override
  late final GeneratedColumn<double> scanQty = GeneratedColumn<double>(
      'scan_qty', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _scanStartDateMeta =
      const VerificationMeta('scanStartDate');
  @override
  late final GeneratedColumn<String> scanStartDate = GeneratedColumn<String>(
      'scan_start_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mrpMeta = const VerificationMeta('mrp');
  @override
  late final GeneratedColumn<double> mrp = GeneratedColumn<double>(
      'mrp', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cpuMeta = const VerificationMeta('cpu');
  @override
  late final GeneratedColumn<double> cpu = GeneratedColumn<double>(
      'cpu', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        barcode,
        sBarcode,
        userBarcode,
        startQty,
        scanQty,
        scanStartDate,
        mrp,
        description,
        cpu
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_data';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryDataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('s_barcode')) {
      context.handle(_sBarcodeMeta,
          sBarcode.isAcceptableOrUnknown(data['s_barcode']!, _sBarcodeMeta));
    }
    if (data.containsKey('user_barcode')) {
      context.handle(
          _userBarcodeMeta,
          userBarcode.isAcceptableOrUnknown(
              data['user_barcode']!, _userBarcodeMeta));
    }
    if (data.containsKey('start_qty')) {
      context.handle(_startQtyMeta,
          startQty.isAcceptableOrUnknown(data['start_qty']!, _startQtyMeta));
    }
    if (data.containsKey('scan_qty')) {
      context.handle(_scanQtyMeta,
          scanQty.isAcceptableOrUnknown(data['scan_qty']!, _scanQtyMeta));
    }
    if (data.containsKey('scan_start_date')) {
      context.handle(
          _scanStartDateMeta,
          scanStartDate.isAcceptableOrUnknown(
              data['scan_start_date']!, _scanStartDateMeta));
    }
    if (data.containsKey('mrp')) {
      context.handle(
          _mrpMeta, mrp.isAcceptableOrUnknown(data['mrp']!, _mrpMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('cpu')) {
      context.handle(
          _cpuMeta, cpu.isAcceptableOrUnknown(data['cpu']!, _cpuMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryDataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryDataData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      sBarcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}s_barcode']),
      userBarcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_barcode']),
      startQty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}start_qty']),
      scanQty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}scan_qty']),
      scanStartDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scan_start_date']),
      mrp: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mrp']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      cpu: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cpu']),
    );
  }

  @override
  $InventoryDataTable createAlias(String alias) {
    return $InventoryDataTable(attachedDatabase, alias);
  }
}

class InventoryDataData extends DataClass
    implements Insertable<InventoryDataData> {
  final int id;
  final String? sessionId;
  final String? barcode;
  final String? sBarcode;
  final String? userBarcode;
  final double? startQty;
  final double? scanQty;
  final String? scanStartDate;
  final double? mrp;
  final String? description;
  final double? cpu;
  const InventoryDataData(
      {required this.id,
      this.sessionId,
      this.barcode,
      this.sBarcode,
      this.userBarcode,
      this.startQty,
      this.scanQty,
      this.scanStartDate,
      this.mrp,
      this.description,
      this.cpu});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || sBarcode != null) {
      map['s_barcode'] = Variable<String>(sBarcode);
    }
    if (!nullToAbsent || userBarcode != null) {
      map['user_barcode'] = Variable<String>(userBarcode);
    }
    if (!nullToAbsent || startQty != null) {
      map['start_qty'] = Variable<double>(startQty);
    }
    if (!nullToAbsent || scanQty != null) {
      map['scan_qty'] = Variable<double>(scanQty);
    }
    if (!nullToAbsent || scanStartDate != null) {
      map['scan_start_date'] = Variable<String>(scanStartDate);
    }
    if (!nullToAbsent || mrp != null) {
      map['mrp'] = Variable<double>(mrp);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || cpu != null) {
      map['cpu'] = Variable<double>(cpu);
    }
    return map;
  }

  InventoryDataCompanion toCompanion(bool nullToAbsent) {
    return InventoryDataCompanion(
      id: Value(id),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      sBarcode: sBarcode == null && nullToAbsent
          ? const Value.absent()
          : Value(sBarcode),
      userBarcode: userBarcode == null && nullToAbsent
          ? const Value.absent()
          : Value(userBarcode),
      startQty: startQty == null && nullToAbsent
          ? const Value.absent()
          : Value(startQty),
      scanQty: scanQty == null && nullToAbsent
          ? const Value.absent()
          : Value(scanQty),
      scanStartDate: scanStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(scanStartDate),
      mrp: mrp == null && nullToAbsent ? const Value.absent() : Value(mrp),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      cpu: cpu == null && nullToAbsent ? const Value.absent() : Value(cpu),
    );
  }

  factory InventoryDataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryDataData(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      sBarcode: serializer.fromJson<String?>(json['sBarcode']),
      userBarcode: serializer.fromJson<String?>(json['userBarcode']),
      startQty: serializer.fromJson<double?>(json['startQty']),
      scanQty: serializer.fromJson<double?>(json['scanQty']),
      scanStartDate: serializer.fromJson<String?>(json['scanStartDate']),
      mrp: serializer.fromJson<double?>(json['mrp']),
      description: serializer.fromJson<String?>(json['description']),
      cpu: serializer.fromJson<double?>(json['cpu']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String?>(sessionId),
      'barcode': serializer.toJson<String?>(barcode),
      'sBarcode': serializer.toJson<String?>(sBarcode),
      'userBarcode': serializer.toJson<String?>(userBarcode),
      'startQty': serializer.toJson<double?>(startQty),
      'scanQty': serializer.toJson<double?>(scanQty),
      'scanStartDate': serializer.toJson<String?>(scanStartDate),
      'mrp': serializer.toJson<double?>(mrp),
      'description': serializer.toJson<String?>(description),
      'cpu': serializer.toJson<double?>(cpu),
    };
  }

  InventoryDataData copyWith(
          {int? id,
          Value<String?> sessionId = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          Value<String?> sBarcode = const Value.absent(),
          Value<String?> userBarcode = const Value.absent(),
          Value<double?> startQty = const Value.absent(),
          Value<double?> scanQty = const Value.absent(),
          Value<String?> scanStartDate = const Value.absent(),
          Value<double?> mrp = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<double?> cpu = const Value.absent()}) =>
      InventoryDataData(
        id: id ?? this.id,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
        barcode: barcode.present ? barcode.value : this.barcode,
        sBarcode: sBarcode.present ? sBarcode.value : this.sBarcode,
        userBarcode: userBarcode.present ? userBarcode.value : this.userBarcode,
        startQty: startQty.present ? startQty.value : this.startQty,
        scanQty: scanQty.present ? scanQty.value : this.scanQty,
        scanStartDate:
            scanStartDate.present ? scanStartDate.value : this.scanStartDate,
        mrp: mrp.present ? mrp.value : this.mrp,
        description: description.present ? description.value : this.description,
        cpu: cpu.present ? cpu.value : this.cpu,
      );
  InventoryDataData copyWithCompanion(InventoryDataCompanion data) {
    return InventoryDataData(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      sBarcode: data.sBarcode.present ? data.sBarcode.value : this.sBarcode,
      userBarcode:
          data.userBarcode.present ? data.userBarcode.value : this.userBarcode,
      startQty: data.startQty.present ? data.startQty.value : this.startQty,
      scanQty: data.scanQty.present ? data.scanQty.value : this.scanQty,
      scanStartDate: data.scanStartDate.present
          ? data.scanStartDate.value
          : this.scanStartDate,
      mrp: data.mrp.present ? data.mrp.value : this.mrp,
      description:
          data.description.present ? data.description.value : this.description,
      cpu: data.cpu.present ? data.cpu.value : this.cpu,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryDataData(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('barcode: $barcode, ')
          ..write('sBarcode: $sBarcode, ')
          ..write('userBarcode: $userBarcode, ')
          ..write('startQty: $startQty, ')
          ..write('scanQty: $scanQty, ')
          ..write('scanStartDate: $scanStartDate, ')
          ..write('mrp: $mrp, ')
          ..write('description: $description, ')
          ..write('cpu: $cpu')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, barcode, sBarcode, userBarcode,
      startQty, scanQty, scanStartDate, mrp, description, cpu);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryDataData &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.barcode == this.barcode &&
          other.sBarcode == this.sBarcode &&
          other.userBarcode == this.userBarcode &&
          other.startQty == this.startQty &&
          other.scanQty == this.scanQty &&
          other.scanStartDate == this.scanStartDate &&
          other.mrp == this.mrp &&
          other.description == this.description &&
          other.cpu == this.cpu);
}

class InventoryDataCompanion extends UpdateCompanion<InventoryDataData> {
  final Value<int> id;
  final Value<String?> sessionId;
  final Value<String?> barcode;
  final Value<String?> sBarcode;
  final Value<String?> userBarcode;
  final Value<double?> startQty;
  final Value<double?> scanQty;
  final Value<String?> scanStartDate;
  final Value<double?> mrp;
  final Value<String?> description;
  final Value<double?> cpu;
  const InventoryDataCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.sBarcode = const Value.absent(),
    this.userBarcode = const Value.absent(),
    this.startQty = const Value.absent(),
    this.scanQty = const Value.absent(),
    this.scanStartDate = const Value.absent(),
    this.mrp = const Value.absent(),
    this.description = const Value.absent(),
    this.cpu = const Value.absent(),
  });
  InventoryDataCompanion.insert({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.sBarcode = const Value.absent(),
    this.userBarcode = const Value.absent(),
    this.startQty = const Value.absent(),
    this.scanQty = const Value.absent(),
    this.scanStartDate = const Value.absent(),
    this.mrp = const Value.absent(),
    this.description = const Value.absent(),
    this.cpu = const Value.absent(),
  });
  static Insertable<InventoryDataData> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<String>? barcode,
    Expression<String>? sBarcode,
    Expression<String>? userBarcode,
    Expression<double>? startQty,
    Expression<double>? scanQty,
    Expression<String>? scanStartDate,
    Expression<double>? mrp,
    Expression<String>? description,
    Expression<double>? cpu,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (barcode != null) 'barcode': barcode,
      if (sBarcode != null) 's_barcode': sBarcode,
      if (userBarcode != null) 'user_barcode': userBarcode,
      if (startQty != null) 'start_qty': startQty,
      if (scanQty != null) 'scan_qty': scanQty,
      if (scanStartDate != null) 'scan_start_date': scanStartDate,
      if (mrp != null) 'mrp': mrp,
      if (description != null) 'description': description,
      if (cpu != null) 'cpu': cpu,
    });
  }

  InventoryDataCompanion copyWith(
      {Value<int>? id,
      Value<String?>? sessionId,
      Value<String?>? barcode,
      Value<String?>? sBarcode,
      Value<String?>? userBarcode,
      Value<double?>? startQty,
      Value<double?>? scanQty,
      Value<String?>? scanStartDate,
      Value<double?>? mrp,
      Value<String?>? description,
      Value<double?>? cpu}) {
    return InventoryDataCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      barcode: barcode ?? this.barcode,
      sBarcode: sBarcode ?? this.sBarcode,
      userBarcode: userBarcode ?? this.userBarcode,
      startQty: startQty ?? this.startQty,
      scanQty: scanQty ?? this.scanQty,
      scanStartDate: scanStartDate ?? this.scanStartDate,
      mrp: mrp ?? this.mrp,
      description: description ?? this.description,
      cpu: cpu ?? this.cpu,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (sBarcode.present) {
      map['s_barcode'] = Variable<String>(sBarcode.value);
    }
    if (userBarcode.present) {
      map['user_barcode'] = Variable<String>(userBarcode.value);
    }
    if (startQty.present) {
      map['start_qty'] = Variable<double>(startQty.value);
    }
    if (scanQty.present) {
      map['scan_qty'] = Variable<double>(scanQty.value);
    }
    if (scanStartDate.present) {
      map['scan_start_date'] = Variable<String>(scanStartDate.value);
    }
    if (mrp.present) {
      map['mrp'] = Variable<double>(mrp.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cpu.present) {
      map['cpu'] = Variable<double>(cpu.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryDataCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('barcode: $barcode, ')
          ..write('sBarcode: $sBarcode, ')
          ..write('userBarcode: $userBarcode, ')
          ..write('startQty: $startQty, ')
          ..write('scanQty: $scanQty, ')
          ..write('scanStartDate: $scanStartDate, ')
          ..write('mrp: $mrp, ')
          ..write('description: $description, ')
          ..write('cpu: $cpu')
          ..write(')'))
        .toString();
  }
}

class $UsedSessionDataTable extends UsedSessionData
    with TableInfo<$UsedSessionDataTable, UsedSessionDataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsedSessionDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, sessionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'used_session_data';
  @override
  VerificationContext validateIntegrity(
      Insertable<UsedSessionDataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsedSessionDataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsedSessionDataData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
    );
  }

  @override
  $UsedSessionDataTable createAlias(String alias) {
    return $UsedSessionDataTable(attachedDatabase, alias);
  }
}

class UsedSessionDataData extends DataClass
    implements Insertable<UsedSessionDataData> {
  final int id;
  final String? sessionId;
  const UsedSessionDataData({required this.id, this.sessionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    return map;
  }

  UsedSessionDataCompanion toCompanion(bool nullToAbsent) {
    return UsedSessionDataCompanion(
      id: Value(id),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
    );
  }

  factory UsedSessionDataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsedSessionDataData(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String?>(sessionId),
    };
  }

  UsedSessionDataData copyWith(
          {int? id, Value<String?> sessionId = const Value.absent()}) =>
      UsedSessionDataData(
        id: id ?? this.id,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
      );
  UsedSessionDataData copyWithCompanion(UsedSessionDataCompanion data) {
    return UsedSessionDataData(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsedSessionDataData(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsedSessionDataData &&
          other.id == this.id &&
          other.sessionId == this.sessionId);
}

class UsedSessionDataCompanion extends UpdateCompanion<UsedSessionDataData> {
  final Value<int> id;
  final Value<String?> sessionId;
  const UsedSessionDataCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
  UsedSessionDataCompanion.insert({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
  static Insertable<UsedSessionDataData> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
    });
  }

  UsedSessionDataCompanion copyWith(
      {Value<int>? id, Value<String?>? sessionId}) {
    return UsedSessionDataCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsedSessionDataCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScanItemsTable scanItems = $ScanItemsTable(this);
  late final $TempScanItemsTable tempScanItems = $TempScanItemsTable(this);
  late final $InventoryDataTable inventoryData = $InventoryDataTable(this);
  late final $UsedSessionDataTable usedSessionData =
      $UsedSessionDataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [scanItems, tempScanItems, inventoryData, usedSessionData];
}

typedef $$ScanItemsTableCreateCompanionBuilder = ScanItemsCompanion Function({
  Value<int> id,
  Value<String?> itemCode,
  Value<String?> barcode,
  Value<String?> userBarcode,
  Value<String?> sBarcode,
  Value<String?> itemDescription,
  Value<String?> scanQty,
  Value<String?> adjQty,
  Value<String?> userId,
  Value<String?> deviceId,
  Value<String?> zoneName,
  Value<String?> scQty,
  Value<String?> srQty,
  Value<String?> enQty,
  Value<String?> createDate,
  Value<String?> systemQty,
  Value<String?> sQty,
  Value<String?> outletCode,
  Value<String?> salePrice,
  Value<String?> cpu,
  Value<String?> sessionId,
});
typedef $$ScanItemsTableUpdateCompanionBuilder = ScanItemsCompanion Function({
  Value<int> id,
  Value<String?> itemCode,
  Value<String?> barcode,
  Value<String?> userBarcode,
  Value<String?> sBarcode,
  Value<String?> itemDescription,
  Value<String?> scanQty,
  Value<String?> adjQty,
  Value<String?> userId,
  Value<String?> deviceId,
  Value<String?> zoneName,
  Value<String?> scQty,
  Value<String?> srQty,
  Value<String?> enQty,
  Value<String?> createDate,
  Value<String?> systemQty,
  Value<String?> sQty,
  Value<String?> outletCode,
  Value<String?> salePrice,
  Value<String?> cpu,
  Value<String?> sessionId,
});

class $$ScanItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ScanItemsTable> {
  $$ScanItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemCode => $composableBuilder(
      column: $table.itemCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userBarcode => $composableBuilder(
      column: $table.userBarcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sBarcode => $composableBuilder(
      column: $table.sBarcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemDescription => $composableBuilder(
      column: $table.itemDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scanQty => $composableBuilder(
      column: $table.scanQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adjQty => $composableBuilder(
      column: $table.adjQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zoneName => $composableBuilder(
      column: $table.zoneName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scQty => $composableBuilder(
      column: $table.scQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get srQty => $composableBuilder(
      column: $table.srQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get enQty => $composableBuilder(
      column: $table.enQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemQty => $composableBuilder(
      column: $table.systemQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sQty => $composableBuilder(
      column: $table.sQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outletCode => $composableBuilder(
      column: $table.outletCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cpu => $composableBuilder(
      column: $table.cpu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));
}

class $$ScanItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanItemsTable> {
  $$ScanItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemCode => $composableBuilder(
      column: $table.itemCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userBarcode => $composableBuilder(
      column: $table.userBarcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sBarcode => $composableBuilder(
      column: $table.sBarcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemDescription => $composableBuilder(
      column: $table.itemDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scanQty => $composableBuilder(
      column: $table.scanQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adjQty => $composableBuilder(
      column: $table.adjQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zoneName => $composableBuilder(
      column: $table.zoneName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scQty => $composableBuilder(
      column: $table.scQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get srQty => $composableBuilder(
      column: $table.srQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get enQty => $composableBuilder(
      column: $table.enQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemQty => $composableBuilder(
      column: $table.systemQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sQty => $composableBuilder(
      column: $table.sQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outletCode => $composableBuilder(
      column: $table.outletCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cpu => $composableBuilder(
      column: $table.cpu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));
}

class $$ScanItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanItemsTable> {
  $$ScanItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemCode =>
      $composableBuilder(column: $table.itemCode, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get userBarcode => $composableBuilder(
      column: $table.userBarcode, builder: (column) => column);

  GeneratedColumn<String> get sBarcode =>
      $composableBuilder(column: $table.sBarcode, builder: (column) => column);

  GeneratedColumn<String> get itemDescription => $composableBuilder(
      column: $table.itemDescription, builder: (column) => column);

  GeneratedColumn<String> get scanQty =>
      $composableBuilder(column: $table.scanQty, builder: (column) => column);

  GeneratedColumn<String> get adjQty =>
      $composableBuilder(column: $table.adjQty, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get zoneName =>
      $composableBuilder(column: $table.zoneName, builder: (column) => column);

  GeneratedColumn<String> get scQty =>
      $composableBuilder(column: $table.scQty, builder: (column) => column);

  GeneratedColumn<String> get srQty =>
      $composableBuilder(column: $table.srQty, builder: (column) => column);

  GeneratedColumn<String> get enQty =>
      $composableBuilder(column: $table.enQty, builder: (column) => column);

  GeneratedColumn<String> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => column);

  GeneratedColumn<String> get systemQty =>
      $composableBuilder(column: $table.systemQty, builder: (column) => column);

  GeneratedColumn<String> get sQty =>
      $composableBuilder(column: $table.sQty, builder: (column) => column);

  GeneratedColumn<String> get outletCode => $composableBuilder(
      column: $table.outletCode, builder: (column) => column);

  GeneratedColumn<String> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<String> get cpu =>
      $composableBuilder(column: $table.cpu, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);
}

class $$ScanItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScanItemsTable,
    ScanItem,
    $$ScanItemsTableFilterComposer,
    $$ScanItemsTableOrderingComposer,
    $$ScanItemsTableAnnotationComposer,
    $$ScanItemsTableCreateCompanionBuilder,
    $$ScanItemsTableUpdateCompanionBuilder,
    (ScanItem, BaseReferences<_$AppDatabase, $ScanItemsTable, ScanItem>),
    ScanItem,
    PrefetchHooks Function()> {
  $$ScanItemsTableTableManager(_$AppDatabase db, $ScanItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> itemCode = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> userBarcode = const Value.absent(),
            Value<String?> sBarcode = const Value.absent(),
            Value<String?> itemDescription = const Value.absent(),
            Value<String?> scanQty = const Value.absent(),
            Value<String?> adjQty = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<String?> zoneName = const Value.absent(),
            Value<String?> scQty = const Value.absent(),
            Value<String?> srQty = const Value.absent(),
            Value<String?> enQty = const Value.absent(),
            Value<String?> createDate = const Value.absent(),
            Value<String?> systemQty = const Value.absent(),
            Value<String?> sQty = const Value.absent(),
            Value<String?> outletCode = const Value.absent(),
            Value<String?> salePrice = const Value.absent(),
            Value<String?> cpu = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
          }) =>
              ScanItemsCompanion(
            id: id,
            itemCode: itemCode,
            barcode: barcode,
            userBarcode: userBarcode,
            sBarcode: sBarcode,
            itemDescription: itemDescription,
            scanQty: scanQty,
            adjQty: adjQty,
            userId: userId,
            deviceId: deviceId,
            zoneName: zoneName,
            scQty: scQty,
            srQty: srQty,
            enQty: enQty,
            createDate: createDate,
            systemQty: systemQty,
            sQty: sQty,
            outletCode: outletCode,
            salePrice: salePrice,
            cpu: cpu,
            sessionId: sessionId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> itemCode = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> userBarcode = const Value.absent(),
            Value<String?> sBarcode = const Value.absent(),
            Value<String?> itemDescription = const Value.absent(),
            Value<String?> scanQty = const Value.absent(),
            Value<String?> adjQty = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<String?> zoneName = const Value.absent(),
            Value<String?> scQty = const Value.absent(),
            Value<String?> srQty = const Value.absent(),
            Value<String?> enQty = const Value.absent(),
            Value<String?> createDate = const Value.absent(),
            Value<String?> systemQty = const Value.absent(),
            Value<String?> sQty = const Value.absent(),
            Value<String?> outletCode = const Value.absent(),
            Value<String?> salePrice = const Value.absent(),
            Value<String?> cpu = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
          }) =>
              ScanItemsCompanion.insert(
            id: id,
            itemCode: itemCode,
            barcode: barcode,
            userBarcode: userBarcode,
            sBarcode: sBarcode,
            itemDescription: itemDescription,
            scanQty: scanQty,
            adjQty: adjQty,
            userId: userId,
            deviceId: deviceId,
            zoneName: zoneName,
            scQty: scQty,
            srQty: srQty,
            enQty: enQty,
            createDate: createDate,
            systemQty: systemQty,
            sQty: sQty,
            outletCode: outletCode,
            salePrice: salePrice,
            cpu: cpu,
            sessionId: sessionId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScanItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScanItemsTable,
    ScanItem,
    $$ScanItemsTableFilterComposer,
    $$ScanItemsTableOrderingComposer,
    $$ScanItemsTableAnnotationComposer,
    $$ScanItemsTableCreateCompanionBuilder,
    $$ScanItemsTableUpdateCompanionBuilder,
    (ScanItem, BaseReferences<_$AppDatabase, $ScanItemsTable, ScanItem>),
    ScanItem,
    PrefetchHooks Function()>;
typedef $$TempScanItemsTableCreateCompanionBuilder = TempScanItemsCompanion
    Function({
  Value<int> id,
  Value<String?> itemCode,
  Value<String?> barcode,
  Value<String?> userBarcode,
  Value<String?> sBarcode,
  Value<String?> itemDescription,
  Value<String?> scanQty,
  Value<String?> adjQty,
  Value<String?> userId,
  Value<String?> deviceId,
  Value<String?> zoneName,
  Value<String?> scQty,
  Value<String?> srQty,
  Value<String?> enQty,
  Value<String?> createDate,
  Value<String?> systemQty,
  Value<String?> sQty,
  Value<String?> outletCode,
  Value<String?> salePrice,
  Value<String?> cpu,
  Value<String?> sessionId,
});
typedef $$TempScanItemsTableUpdateCompanionBuilder = TempScanItemsCompanion
    Function({
  Value<int> id,
  Value<String?> itemCode,
  Value<String?> barcode,
  Value<String?> userBarcode,
  Value<String?> sBarcode,
  Value<String?> itemDescription,
  Value<String?> scanQty,
  Value<String?> adjQty,
  Value<String?> userId,
  Value<String?> deviceId,
  Value<String?> zoneName,
  Value<String?> scQty,
  Value<String?> srQty,
  Value<String?> enQty,
  Value<String?> createDate,
  Value<String?> systemQty,
  Value<String?> sQty,
  Value<String?> outletCode,
  Value<String?> salePrice,
  Value<String?> cpu,
  Value<String?> sessionId,
});

class $$TempScanItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TempScanItemsTable> {
  $$TempScanItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemCode => $composableBuilder(
      column: $table.itemCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userBarcode => $composableBuilder(
      column: $table.userBarcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sBarcode => $composableBuilder(
      column: $table.sBarcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemDescription => $composableBuilder(
      column: $table.itemDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scanQty => $composableBuilder(
      column: $table.scanQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adjQty => $composableBuilder(
      column: $table.adjQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zoneName => $composableBuilder(
      column: $table.zoneName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scQty => $composableBuilder(
      column: $table.scQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get srQty => $composableBuilder(
      column: $table.srQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get enQty => $composableBuilder(
      column: $table.enQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemQty => $composableBuilder(
      column: $table.systemQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sQty => $composableBuilder(
      column: $table.sQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outletCode => $composableBuilder(
      column: $table.outletCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cpu => $composableBuilder(
      column: $table.cpu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));
}

class $$TempScanItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TempScanItemsTable> {
  $$TempScanItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemCode => $composableBuilder(
      column: $table.itemCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userBarcode => $composableBuilder(
      column: $table.userBarcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sBarcode => $composableBuilder(
      column: $table.sBarcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemDescription => $composableBuilder(
      column: $table.itemDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scanQty => $composableBuilder(
      column: $table.scanQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adjQty => $composableBuilder(
      column: $table.adjQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zoneName => $composableBuilder(
      column: $table.zoneName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scQty => $composableBuilder(
      column: $table.scQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get srQty => $composableBuilder(
      column: $table.srQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get enQty => $composableBuilder(
      column: $table.enQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemQty => $composableBuilder(
      column: $table.systemQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sQty => $composableBuilder(
      column: $table.sQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outletCode => $composableBuilder(
      column: $table.outletCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cpu => $composableBuilder(
      column: $table.cpu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));
}

class $$TempScanItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TempScanItemsTable> {
  $$TempScanItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemCode =>
      $composableBuilder(column: $table.itemCode, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get userBarcode => $composableBuilder(
      column: $table.userBarcode, builder: (column) => column);

  GeneratedColumn<String> get sBarcode =>
      $composableBuilder(column: $table.sBarcode, builder: (column) => column);

  GeneratedColumn<String> get itemDescription => $composableBuilder(
      column: $table.itemDescription, builder: (column) => column);

  GeneratedColumn<String> get scanQty =>
      $composableBuilder(column: $table.scanQty, builder: (column) => column);

  GeneratedColumn<String> get adjQty =>
      $composableBuilder(column: $table.adjQty, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get zoneName =>
      $composableBuilder(column: $table.zoneName, builder: (column) => column);

  GeneratedColumn<String> get scQty =>
      $composableBuilder(column: $table.scQty, builder: (column) => column);

  GeneratedColumn<String> get srQty =>
      $composableBuilder(column: $table.srQty, builder: (column) => column);

  GeneratedColumn<String> get enQty =>
      $composableBuilder(column: $table.enQty, builder: (column) => column);

  GeneratedColumn<String> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => column);

  GeneratedColumn<String> get systemQty =>
      $composableBuilder(column: $table.systemQty, builder: (column) => column);

  GeneratedColumn<String> get sQty =>
      $composableBuilder(column: $table.sQty, builder: (column) => column);

  GeneratedColumn<String> get outletCode => $composableBuilder(
      column: $table.outletCode, builder: (column) => column);

  GeneratedColumn<String> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<String> get cpu =>
      $composableBuilder(column: $table.cpu, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);
}

class $$TempScanItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TempScanItemsTable,
    TempScanItem,
    $$TempScanItemsTableFilterComposer,
    $$TempScanItemsTableOrderingComposer,
    $$TempScanItemsTableAnnotationComposer,
    $$TempScanItemsTableCreateCompanionBuilder,
    $$TempScanItemsTableUpdateCompanionBuilder,
    (
      TempScanItem,
      BaseReferences<_$AppDatabase, $TempScanItemsTable, TempScanItem>
    ),
    TempScanItem,
    PrefetchHooks Function()> {
  $$TempScanItemsTableTableManager(_$AppDatabase db, $TempScanItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TempScanItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TempScanItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TempScanItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> itemCode = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> userBarcode = const Value.absent(),
            Value<String?> sBarcode = const Value.absent(),
            Value<String?> itemDescription = const Value.absent(),
            Value<String?> scanQty = const Value.absent(),
            Value<String?> adjQty = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<String?> zoneName = const Value.absent(),
            Value<String?> scQty = const Value.absent(),
            Value<String?> srQty = const Value.absent(),
            Value<String?> enQty = const Value.absent(),
            Value<String?> createDate = const Value.absent(),
            Value<String?> systemQty = const Value.absent(),
            Value<String?> sQty = const Value.absent(),
            Value<String?> outletCode = const Value.absent(),
            Value<String?> salePrice = const Value.absent(),
            Value<String?> cpu = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
          }) =>
              TempScanItemsCompanion(
            id: id,
            itemCode: itemCode,
            barcode: barcode,
            userBarcode: userBarcode,
            sBarcode: sBarcode,
            itemDescription: itemDescription,
            scanQty: scanQty,
            adjQty: adjQty,
            userId: userId,
            deviceId: deviceId,
            zoneName: zoneName,
            scQty: scQty,
            srQty: srQty,
            enQty: enQty,
            createDate: createDate,
            systemQty: systemQty,
            sQty: sQty,
            outletCode: outletCode,
            salePrice: salePrice,
            cpu: cpu,
            sessionId: sessionId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> itemCode = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> userBarcode = const Value.absent(),
            Value<String?> sBarcode = const Value.absent(),
            Value<String?> itemDescription = const Value.absent(),
            Value<String?> scanQty = const Value.absent(),
            Value<String?> adjQty = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<String?> zoneName = const Value.absent(),
            Value<String?> scQty = const Value.absent(),
            Value<String?> srQty = const Value.absent(),
            Value<String?> enQty = const Value.absent(),
            Value<String?> createDate = const Value.absent(),
            Value<String?> systemQty = const Value.absent(),
            Value<String?> sQty = const Value.absent(),
            Value<String?> outletCode = const Value.absent(),
            Value<String?> salePrice = const Value.absent(),
            Value<String?> cpu = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
          }) =>
              TempScanItemsCompanion.insert(
            id: id,
            itemCode: itemCode,
            barcode: barcode,
            userBarcode: userBarcode,
            sBarcode: sBarcode,
            itemDescription: itemDescription,
            scanQty: scanQty,
            adjQty: adjQty,
            userId: userId,
            deviceId: deviceId,
            zoneName: zoneName,
            scQty: scQty,
            srQty: srQty,
            enQty: enQty,
            createDate: createDate,
            systemQty: systemQty,
            sQty: sQty,
            outletCode: outletCode,
            salePrice: salePrice,
            cpu: cpu,
            sessionId: sessionId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TempScanItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TempScanItemsTable,
    TempScanItem,
    $$TempScanItemsTableFilterComposer,
    $$TempScanItemsTableOrderingComposer,
    $$TempScanItemsTableAnnotationComposer,
    $$TempScanItemsTableCreateCompanionBuilder,
    $$TempScanItemsTableUpdateCompanionBuilder,
    (
      TempScanItem,
      BaseReferences<_$AppDatabase, $TempScanItemsTable, TempScanItem>
    ),
    TempScanItem,
    PrefetchHooks Function()>;
typedef $$InventoryDataTableCreateCompanionBuilder = InventoryDataCompanion
    Function({
  Value<int> id,
  Value<String?> sessionId,
  Value<String?> barcode,
  Value<String?> sBarcode,
  Value<String?> userBarcode,
  Value<double?> startQty,
  Value<double?> scanQty,
  Value<String?> scanStartDate,
  Value<double?> mrp,
  Value<String?> description,
  Value<double?> cpu,
});
typedef $$InventoryDataTableUpdateCompanionBuilder = InventoryDataCompanion
    Function({
  Value<int> id,
  Value<String?> sessionId,
  Value<String?> barcode,
  Value<String?> sBarcode,
  Value<String?> userBarcode,
  Value<double?> startQty,
  Value<double?> scanQty,
  Value<String?> scanStartDate,
  Value<double?> mrp,
  Value<String?> description,
  Value<double?> cpu,
});

class $$InventoryDataTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryDataTable> {
  $$InventoryDataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sBarcode => $composableBuilder(
      column: $table.sBarcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userBarcode => $composableBuilder(
      column: $table.userBarcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get startQty => $composableBuilder(
      column: $table.startQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get scanQty => $composableBuilder(
      column: $table.scanQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scanStartDate => $composableBuilder(
      column: $table.scanStartDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get mrp => $composableBuilder(
      column: $table.mrp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cpu => $composableBuilder(
      column: $table.cpu, builder: (column) => ColumnFilters(column));
}

class $$InventoryDataTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryDataTable> {
  $$InventoryDataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sBarcode => $composableBuilder(
      column: $table.sBarcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userBarcode => $composableBuilder(
      column: $table.userBarcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get startQty => $composableBuilder(
      column: $table.startQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get scanQty => $composableBuilder(
      column: $table.scanQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scanStartDate => $composableBuilder(
      column: $table.scanStartDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get mrp => $composableBuilder(
      column: $table.mrp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cpu => $composableBuilder(
      column: $table.cpu, builder: (column) => ColumnOrderings(column));
}

class $$InventoryDataTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryDataTable> {
  $$InventoryDataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get sBarcode =>
      $composableBuilder(column: $table.sBarcode, builder: (column) => column);

  GeneratedColumn<String> get userBarcode => $composableBuilder(
      column: $table.userBarcode, builder: (column) => column);

  GeneratedColumn<double> get startQty =>
      $composableBuilder(column: $table.startQty, builder: (column) => column);

  GeneratedColumn<double> get scanQty =>
      $composableBuilder(column: $table.scanQty, builder: (column) => column);

  GeneratedColumn<String> get scanStartDate => $composableBuilder(
      column: $table.scanStartDate, builder: (column) => column);

  GeneratedColumn<double> get mrp =>
      $composableBuilder(column: $table.mrp, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get cpu =>
      $composableBuilder(column: $table.cpu, builder: (column) => column);
}

class $$InventoryDataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryDataTable,
    InventoryDataData,
    $$InventoryDataTableFilterComposer,
    $$InventoryDataTableOrderingComposer,
    $$InventoryDataTableAnnotationComposer,
    $$InventoryDataTableCreateCompanionBuilder,
    $$InventoryDataTableUpdateCompanionBuilder,
    (
      InventoryDataData,
      BaseReferences<_$AppDatabase, $InventoryDataTable, InventoryDataData>
    ),
    InventoryDataData,
    PrefetchHooks Function()> {
  $$InventoryDataTableTableManager(_$AppDatabase db, $InventoryDataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryDataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryDataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryDataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> sBarcode = const Value.absent(),
            Value<String?> userBarcode = const Value.absent(),
            Value<double?> startQty = const Value.absent(),
            Value<double?> scanQty = const Value.absent(),
            Value<String?> scanStartDate = const Value.absent(),
            Value<double?> mrp = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double?> cpu = const Value.absent(),
          }) =>
              InventoryDataCompanion(
            id: id,
            sessionId: sessionId,
            barcode: barcode,
            sBarcode: sBarcode,
            userBarcode: userBarcode,
            startQty: startQty,
            scanQty: scanQty,
            scanStartDate: scanStartDate,
            mrp: mrp,
            description: description,
            cpu: cpu,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> sBarcode = const Value.absent(),
            Value<String?> userBarcode = const Value.absent(),
            Value<double?> startQty = const Value.absent(),
            Value<double?> scanQty = const Value.absent(),
            Value<String?> scanStartDate = const Value.absent(),
            Value<double?> mrp = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double?> cpu = const Value.absent(),
          }) =>
              InventoryDataCompanion.insert(
            id: id,
            sessionId: sessionId,
            barcode: barcode,
            sBarcode: sBarcode,
            userBarcode: userBarcode,
            startQty: startQty,
            scanQty: scanQty,
            scanStartDate: scanStartDate,
            mrp: mrp,
            description: description,
            cpu: cpu,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InventoryDataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InventoryDataTable,
    InventoryDataData,
    $$InventoryDataTableFilterComposer,
    $$InventoryDataTableOrderingComposer,
    $$InventoryDataTableAnnotationComposer,
    $$InventoryDataTableCreateCompanionBuilder,
    $$InventoryDataTableUpdateCompanionBuilder,
    (
      InventoryDataData,
      BaseReferences<_$AppDatabase, $InventoryDataTable, InventoryDataData>
    ),
    InventoryDataData,
    PrefetchHooks Function()>;
typedef $$UsedSessionDataTableCreateCompanionBuilder = UsedSessionDataCompanion
    Function({
  Value<int> id,
  Value<String?> sessionId,
});
typedef $$UsedSessionDataTableUpdateCompanionBuilder = UsedSessionDataCompanion
    Function({
  Value<int> id,
  Value<String?> sessionId,
});

class $$UsedSessionDataTableFilterComposer
    extends Composer<_$AppDatabase, $UsedSessionDataTable> {
  $$UsedSessionDataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));
}

class $$UsedSessionDataTableOrderingComposer
    extends Composer<_$AppDatabase, $UsedSessionDataTable> {
  $$UsedSessionDataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));
}

class $$UsedSessionDataTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsedSessionDataTable> {
  $$UsedSessionDataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);
}

class $$UsedSessionDataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsedSessionDataTable,
    UsedSessionDataData,
    $$UsedSessionDataTableFilterComposer,
    $$UsedSessionDataTableOrderingComposer,
    $$UsedSessionDataTableAnnotationComposer,
    $$UsedSessionDataTableCreateCompanionBuilder,
    $$UsedSessionDataTableUpdateCompanionBuilder,
    (
      UsedSessionDataData,
      BaseReferences<_$AppDatabase, $UsedSessionDataTable, UsedSessionDataData>
    ),
    UsedSessionDataData,
    PrefetchHooks Function()> {
  $$UsedSessionDataTableTableManager(
      _$AppDatabase db, $UsedSessionDataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsedSessionDataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsedSessionDataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsedSessionDataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
          }) =>
              UsedSessionDataCompanion(
            id: id,
            sessionId: sessionId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
          }) =>
              UsedSessionDataCompanion.insert(
            id: id,
            sessionId: sessionId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsedSessionDataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsedSessionDataTable,
    UsedSessionDataData,
    $$UsedSessionDataTableFilterComposer,
    $$UsedSessionDataTableOrderingComposer,
    $$UsedSessionDataTableAnnotationComposer,
    $$UsedSessionDataTableCreateCompanionBuilder,
    $$UsedSessionDataTableUpdateCompanionBuilder,
    (
      UsedSessionDataData,
      BaseReferences<_$AppDatabase, $UsedSessionDataTable, UsedSessionDataData>
    ),
    UsedSessionDataData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScanItemsTableTableManager get scanItems =>
      $$ScanItemsTableTableManager(_db, _db.scanItems);
  $$TempScanItemsTableTableManager get tempScanItems =>
      $$TempScanItemsTableTableManager(_db, _db.tempScanItems);
  $$InventoryDataTableTableManager get inventoryData =>
      $$InventoryDataTableTableManager(_db, _db.inventoryData);
  $$UsedSessionDataTableTableManager get usedSessionData =>
      $$UsedSessionDataTableTableManager(_db, _db.usedSessionData);
}
