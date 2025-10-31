// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $LocalSummariesTable extends LocalSummaries
    with TableInfo<$LocalSummariesTable, LocalSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryTextMeta = const VerificationMeta(
    'summaryText',
  );
  @override
  late final GeneratedColumn<String> summaryText = GeneratedColumn<String>(
    'summary_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    startDate,
    endDate,
    generatedAt,
    summaryText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    }
    if (data.containsKey('summary_text')) {
      context.handle(
        _summaryTextMeta,
        summaryText.isAcceptableOrUnknown(
          data['summary_text']!,
          _summaryTextMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSummary(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      ),
      summaryText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_text'],
      ),
    );
  }

  @override
  $LocalSummariesTable createAlias(String alias) {
    return $LocalSummariesTable(attachedDatabase, alias);
  }
}

class LocalSummary extends DataClass implements Insertable<LocalSummary> {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? generatedAt;
  final String? summaryText;
  const LocalSummary({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.generatedAt,
    this.summaryText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    if (!nullToAbsent || generatedAt != null) {
      map['generated_at'] = Variable<DateTime>(generatedAt);
    }
    if (!nullToAbsent || summaryText != null) {
      map['summary_text'] = Variable<String>(summaryText);
    }
    return map;
  }

  LocalSummariesCompanion toCompanion(bool nullToAbsent) {
    return LocalSummariesCompanion(
      id: Value(id),
      userId: Value(userId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      generatedAt: generatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(generatedAt),
      summaryText: summaryText == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryText),
    );
  }

  factory LocalSummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSummary(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      generatedAt: serializer.fromJson<DateTime?>(json['generatedAt']),
      summaryText: serializer.fromJson<String?>(json['summaryText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'generatedAt': serializer.toJson<DateTime?>(generatedAt),
      'summaryText': serializer.toJson<String?>(summaryText),
    };
  }

  LocalSummary copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    Value<DateTime?> generatedAt = const Value.absent(),
    Value<String?> summaryText = const Value.absent(),
  }) => LocalSummary(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    generatedAt: generatedAt.present ? generatedAt.value : this.generatedAt,
    summaryText: summaryText.present ? summaryText.value : this.summaryText,
  );
  LocalSummary copyWithCompanion(LocalSummariesCompanion data) {
    return LocalSummary(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      summaryText: data.summaryText.present
          ? data.summaryText.value
          : this.summaryText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSummary(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('summaryText: $summaryText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, startDate, endDate, generatedAt, summaryText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSummary &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.generatedAt == this.generatedAt &&
          other.summaryText == this.summaryText);
}

class LocalSummariesCompanion extends UpdateCompanion<LocalSummary> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<DateTime?> generatedAt;
  final Value<String?> summaryText;
  final Value<int> rowid;
  const LocalSummariesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSummariesCompanion.insert({
    required String id,
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    this.generatedAt = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<LocalSummary> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? generatedAt,
    Expression<String>? summaryText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (summaryText != null) 'summary_text': summaryText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSummariesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<DateTime?>? generatedAt,
    Value<String?>? summaryText,
    Value<int>? rowid,
  }) {
    return LocalSummariesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      generatedAt: generatedAt ?? this.generatedAt,
      summaryText: summaryText ?? this.summaryText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (summaryText.present) {
      map['summary_text'] = Variable<String>(summaryText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSummariesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('summaryText: $summaryText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalEmergencyContactsTable extends LocalEmergencyContacts
    with TableInfo<$LocalEmergencyContactsTable, LocalEmergencyContact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalEmergencyContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationMeta = const VerificationMeta(
    'relation',
  );
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
    'relation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    phone,
    email,
    relation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_emergency_contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalEmergencyContact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('relation')) {
      context.handle(
        _relationMeta,
        relation.isAcceptableOrUnknown(data['relation']!, _relationMeta),
      );
    } else if (isInserting) {
      context.missing(_relationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalEmergencyContact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalEmergencyContact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      relation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation'],
      )!,
    );
  }

  @override
  $LocalEmergencyContactsTable createAlias(String alias) {
    return $LocalEmergencyContactsTable(attachedDatabase, alias);
  }
}

class LocalEmergencyContact extends DataClass
    implements Insertable<LocalEmergencyContact> {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String relation;
  const LocalEmergencyContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.relation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['relation'] = Variable<String>(relation);
    return map;
  }

  LocalEmergencyContactsCompanion toCompanion(bool nullToAbsent) {
    return LocalEmergencyContactsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      phone: Value(phone),
      email: Value(email),
      relation: Value(relation),
    );
  }

  factory LocalEmergencyContact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalEmergencyContact(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      relation: serializer.fromJson<String>(json['relation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'relation': serializer.toJson<String>(relation),
    };
  }

  LocalEmergencyContact copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? relation,
  }) => LocalEmergencyContact(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    relation: relation ?? this.relation,
  );
  LocalEmergencyContact copyWithCompanion(
    LocalEmergencyContactsCompanion data,
  ) {
    return LocalEmergencyContact(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      relation: data.relation.present ? data.relation.value : this.relation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalEmergencyContact(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('relation: $relation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, name, phone, email, relation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalEmergencyContact &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.relation == this.relation);
}

class LocalEmergencyContactsCompanion
    extends UpdateCompanion<LocalEmergencyContact> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> relation;
  final Value<int> rowid;
  const LocalEmergencyContactsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.relation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalEmergencyContactsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String phone,
    required String email,
    required String relation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       phone = Value(phone),
       email = Value(email),
       relation = Value(relation);
  static Insertable<LocalEmergencyContact> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? relation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (relation != null) 'relation': relation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalEmergencyContactsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? email,
    Value<String>? relation,
    Value<int>? rowid,
  }) {
    return LocalEmergencyContactsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      relation: relation ?? this.relation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalEmergencyContactsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('relation: $relation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $LocalSummariesTable localSummaries = $LocalSummariesTable(this);
  late final $LocalEmergencyContactsTable localEmergencyContacts =
      $LocalEmergencyContactsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localSummaries,
    localEmergencyContacts,
  ];
}

typedef $$LocalSummariesTableCreateCompanionBuilder =
    LocalSummariesCompanion Function({
      required String id,
      required String userId,
      required DateTime startDate,
      required DateTime endDate,
      Value<DateTime?> generatedAt,
      Value<String?> summaryText,
      Value<int> rowid,
    });
typedef $$LocalSummariesTableUpdateCompanionBuilder =
    LocalSummariesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<DateTime?> generatedAt,
      Value<String?> summaryText,
      Value<int> rowid,
    });

class $$LocalSummariesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalSummariesTable> {
  $$LocalSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSummariesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalSummariesTable> {
  $$LocalSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSummariesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalSummariesTable> {
  $$LocalSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => column,
  );
}

class $$LocalSummariesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalSummariesTable,
          LocalSummary,
          $$LocalSummariesTableFilterComposer,
          $$LocalSummariesTableOrderingComposer,
          $$LocalSummariesTableAnnotationComposer,
          $$LocalSummariesTableCreateCompanionBuilder,
          $$LocalSummariesTableUpdateCompanionBuilder,
          (
            LocalSummary,
            BaseReferences<_$LocalDatabase, $LocalSummariesTable, LocalSummary>,
          ),
          LocalSummary,
          PrefetchHooks Function()
        > {
  $$LocalSummariesTableTableManager(
    _$LocalDatabase db,
    $LocalSummariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<DateTime?> generatedAt = const Value.absent(),
                Value<String?> summaryText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSummariesCompanion(
                id: id,
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                generatedAt: generatedAt,
                summaryText: summaryText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime startDate,
                required DateTime endDate,
                Value<DateTime?> generatedAt = const Value.absent(),
                Value<String?> summaryText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSummariesCompanion.insert(
                id: id,
                userId: userId,
                startDate: startDate,
                endDate: endDate,
                generatedAt: generatedAt,
                summaryText: summaryText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalSummariesTable,
      LocalSummary,
      $$LocalSummariesTableFilterComposer,
      $$LocalSummariesTableOrderingComposer,
      $$LocalSummariesTableAnnotationComposer,
      $$LocalSummariesTableCreateCompanionBuilder,
      $$LocalSummariesTableUpdateCompanionBuilder,
      (
        LocalSummary,
        BaseReferences<_$LocalDatabase, $LocalSummariesTable, LocalSummary>,
      ),
      LocalSummary,
      PrefetchHooks Function()
    >;
typedef $$LocalEmergencyContactsTableCreateCompanionBuilder =
    LocalEmergencyContactsCompanion Function({
      required String id,
      required String userId,
      required String name,
      required String phone,
      required String email,
      required String relation,
      Value<int> rowid,
    });
typedef $$LocalEmergencyContactsTableUpdateCompanionBuilder =
    LocalEmergencyContactsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<String> phone,
      Value<String> email,
      Value<String> relation,
      Value<int> rowid,
    });

class $$LocalEmergencyContactsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalEmergencyContactsTable> {
  $$LocalEmergencyContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalEmergencyContactsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalEmergencyContactsTable> {
  $$LocalEmergencyContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalEmergencyContactsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalEmergencyContactsTable> {
  $$LocalEmergencyContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);
}

class $$LocalEmergencyContactsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalEmergencyContactsTable,
          LocalEmergencyContact,
          $$LocalEmergencyContactsTableFilterComposer,
          $$LocalEmergencyContactsTableOrderingComposer,
          $$LocalEmergencyContactsTableAnnotationComposer,
          $$LocalEmergencyContactsTableCreateCompanionBuilder,
          $$LocalEmergencyContactsTableUpdateCompanionBuilder,
          (
            LocalEmergencyContact,
            BaseReferences<
              _$LocalDatabase,
              $LocalEmergencyContactsTable,
              LocalEmergencyContact
            >,
          ),
          LocalEmergencyContact,
          PrefetchHooks Function()
        > {
  $$LocalEmergencyContactsTableTableManager(
    _$LocalDatabase db,
    $LocalEmergencyContactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalEmergencyContactsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalEmergencyContactsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalEmergencyContactsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> relation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalEmergencyContactsCompanion(
                id: id,
                userId: userId,
                name: name,
                phone: phone,
                email: email,
                relation: relation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required String phone,
                required String email,
                required String relation,
                Value<int> rowid = const Value.absent(),
              }) => LocalEmergencyContactsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                phone: phone,
                email: email,
                relation: relation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalEmergencyContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalEmergencyContactsTable,
      LocalEmergencyContact,
      $$LocalEmergencyContactsTableFilterComposer,
      $$LocalEmergencyContactsTableOrderingComposer,
      $$LocalEmergencyContactsTableAnnotationComposer,
      $$LocalEmergencyContactsTableCreateCompanionBuilder,
      $$LocalEmergencyContactsTableUpdateCompanionBuilder,
      (
        LocalEmergencyContact,
        BaseReferences<
          _$LocalDatabase,
          $LocalEmergencyContactsTable,
          LocalEmergencyContact
        >,
      ),
      LocalEmergencyContact,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$LocalSummariesTableTableManager get localSummaries =>
      $$LocalSummariesTableTableManager(_db, _db.localSummaries);
  $$LocalEmergencyContactsTableTableManager get localEmergencyContacts =>
      $$LocalEmergencyContactsTableTableManager(
        _db,
        _db.localEmergencyContacts,
      );
}
