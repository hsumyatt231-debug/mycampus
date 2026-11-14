// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordSaltMeta = const VerificationMeta(
    'passwordSalt',
  );
  @override
  late final GeneratedColumn<String> passwordSalt = GeneratedColumn<String>(
    'password_salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _academicTimezoneMeta = const VerificationMeta(
    'academicTimezone',
  );
  @override
  late final GeneratedColumn<String> academicTimezone = GeneratedColumn<String>(
    'academic_timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeFormatMeta = const VerificationMeta(
    'timeFormat',
  );
  @override
  late final GeneratedColumn<String> timeFormat = GeneratedColumn<String>(
    'time_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('12'),
  );
  static const VerificationMeta _emailVerifiedMeta = const VerificationMeta(
    'emailVerified',
  );
  @override
  late final GeneratedColumn<bool> emailVerified = GeneratedColumn<bool>(
    'email_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("email_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    fullName,
    role,
    passwordHash,
    passwordSalt,
    academicTimezone,
    timeFormat,
    emailVerified,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('password_salt')) {
      context.handle(
        _passwordSaltMeta,
        passwordSalt.isAcceptableOrUnknown(
          data['password_salt']!,
          _passwordSaltMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordSaltMeta);
    }
    if (data.containsKey('academic_timezone')) {
      context.handle(
        _academicTimezoneMeta,
        academicTimezone.isAcceptableOrUnknown(
          data['academic_timezone']!,
          _academicTimezoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_academicTimezoneMeta);
    }
    if (data.containsKey('time_format')) {
      context.handle(
        _timeFormatMeta,
        timeFormat.isAcceptableOrUnknown(data['time_format']!, _timeFormatMeta),
      );
    }
    if (data.containsKey('email_verified')) {
      context.handle(
        _emailVerifiedMeta,
        emailVerified.isAcceptableOrUnknown(
          data['email_verified']!,
          _emailVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      passwordSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_salt'],
      )!,
      academicTimezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}academic_timezone'],
      )!,
      timeFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_format'],
      )!,
      emailVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}email_verified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String passwordHash;
  final String passwordSalt;
  final String academicTimezone;
  final String timeFormat;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AccountRow({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.passwordHash,
    required this.passwordSalt,
    required this.academicTimezone,
    required this.timeFormat,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['full_name'] = Variable<String>(fullName);
    map['role'] = Variable<String>(role);
    map['password_hash'] = Variable<String>(passwordHash);
    map['password_salt'] = Variable<String>(passwordSalt);
    map['academic_timezone'] = Variable<String>(academicTimezone);
    map['time_format'] = Variable<String>(timeFormat);
    map['email_verified'] = Variable<bool>(emailVerified);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      email: Value(email),
      fullName: Value(fullName),
      role: Value(role),
      passwordHash: Value(passwordHash),
      passwordSalt: Value(passwordSalt),
      academicTimezone: Value(academicTimezone),
      timeFormat: Value(timeFormat),
      emailVerified: Value(emailVerified),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      fullName: serializer.fromJson<String>(json['fullName']),
      role: serializer.fromJson<String>(json['role']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      passwordSalt: serializer.fromJson<String>(json['passwordSalt']),
      academicTimezone: serializer.fromJson<String>(json['academicTimezone']),
      timeFormat: serializer.fromJson<String>(json['timeFormat']),
      emailVerified: serializer.fromJson<bool>(json['emailVerified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'fullName': serializer.toJson<String>(fullName),
      'role': serializer.toJson<String>(role),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'passwordSalt': serializer.toJson<String>(passwordSalt),
      'academicTimezone': serializer.toJson<String>(academicTimezone),
      'timeFormat': serializer.toJson<String>(timeFormat),
      'emailVerified': serializer.toJson<bool>(emailVerified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AccountRow copyWith({
    String? id,
    String? email,
    String? fullName,
    String? role,
    String? passwordHash,
    String? passwordSalt,
    String? academicTimezone,
    String? timeFormat,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AccountRow(
    id: id ?? this.id,
    email: email ?? this.email,
    fullName: fullName ?? this.fullName,
    role: role ?? this.role,
    passwordHash: passwordHash ?? this.passwordHash,
    passwordSalt: passwordSalt ?? this.passwordSalt,
    academicTimezone: academicTimezone ?? this.academicTimezone,
    timeFormat: timeFormat ?? this.timeFormat,
    emailVerified: emailVerified ?? this.emailVerified,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      role: data.role.present ? data.role.value : this.role,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      passwordSalt: data.passwordSalt.present
          ? data.passwordSalt.value
          : this.passwordSalt,
      academicTimezone: data.academicTimezone.present
          ? data.academicTimezone.value
          : this.academicTimezone,
      timeFormat: data.timeFormat.present
          ? data.timeFormat.value
          : this.timeFormat,
      emailVerified: data.emailVerified.present
          ? data.emailVerified.value
          : this.emailVerified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('academicTimezone: $academicTimezone, ')
          ..write('timeFormat: $timeFormat, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    fullName,
    role,
    passwordHash,
    passwordSalt,
    academicTimezone,
    timeFormat,
    emailVerified,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.email == this.email &&
          other.fullName == this.fullName &&
          other.role == this.role &&
          other.passwordHash == this.passwordHash &&
          other.passwordSalt == this.passwordSalt &&
          other.academicTimezone == this.academicTimezone &&
          other.timeFormat == this.timeFormat &&
          other.emailVerified == this.emailVerified &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> fullName;
  final Value<String> role;
  final Value<String> passwordHash;
  final Value<String> passwordSalt;
  final Value<String> academicTimezone;
  final Value<String> timeFormat;
  final Value<bool> emailVerified;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.fullName = const Value.absent(),
    this.role = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.passwordSalt = const Value.absent(),
    this.academicTimezone = const Value.absent(),
    this.timeFormat = const Value.absent(),
    this.emailVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String email,
    required String fullName,
    required String role,
    required String passwordHash,
    required String passwordSalt,
    required String academicTimezone,
    this.timeFormat = const Value.absent(),
    this.emailVerified = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       fullName = Value(fullName),
       role = Value(role),
       passwordHash = Value(passwordHash),
       passwordSalt = Value(passwordSalt),
       academicTimezone = Value(academicTimezone),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? fullName,
    Expression<String>? role,
    Expression<String>? passwordHash,
    Expression<String>? passwordSalt,
    Expression<String>? academicTimezone,
    Expression<String>? timeFormat,
    Expression<bool>? emailVerified,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (fullName != null) 'full_name': fullName,
      if (role != null) 'role': role,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (passwordSalt != null) 'password_salt': passwordSalt,
      if (academicTimezone != null) 'academic_timezone': academicTimezone,
      if (timeFormat != null) 'time_format': timeFormat,
      if (emailVerified != null) 'email_verified': emailVerified,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? fullName,
    Value<String>? role,
    Value<String>? passwordHash,
    Value<String>? passwordSalt,
    Value<String>? academicTimezone,
    Value<String>? timeFormat,
    Value<bool>? emailVerified,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      academicTimezone: academicTimezone ?? this.academicTimezone,
      timeFormat: timeFormat ?? this.timeFormat,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (passwordSalt.present) {
      map['password_salt'] = Variable<String>(passwordSalt.value);
    }
    if (academicTimezone.present) {
      map['academic_timezone'] = Variable<String>(academicTimezone.value);
    }
    if (timeFormat.present) {
      map['time_format'] = Variable<String>(timeFormat.value);
    }
    if (emailVerified.present) {
      map['email_verified'] = Variable<bool>(emailVerified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('academicTimezone: $academicTimezone, ')
          ..write('timeFormat: $timeFormat, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSubjectsTable extends LocalSubjects
    with TableInfo<$LocalSubjectsTable, SubjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF6236F5),
  );
  static const VerificationMeta _teacherNameMeta = const VerificationMeta(
    'teacherName',
  );
  @override
  late final GeneratedColumn<String> teacherName = GeneratedColumn<String>(
    'teacher_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    name,
    code,
    colorValue,
    teacherName,
    room,
    revision,
    syncStatus,
    deletedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubjectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('teacher_name')) {
      context.handle(
        _teacherNameMeta,
        teacherName.isAcceptableOrUnknown(
          data['teacher_name']!,
          _teacherNameMeta,
        ),
      );
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      teacherName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_name'],
      ),
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalSubjectsTable createAlias(String alias) {
    return $LocalSubjectsTable(attachedDatabase, alias);
  }
}

class SubjectRow extends DataClass implements Insertable<SubjectRow> {
  final String id;
  final String accountId;
  final String name;
  final String code;
  final int colorValue;
  final String? teacherName;
  final String? room;
  final int revision;
  final String syncStatus;
  final DateTime? deletedAt;
  final DateTime updatedAt;
  const SubjectRow({
    required this.id,
    required this.accountId,
    required this.name,
    required this.code,
    required this.colorValue,
    this.teacherName,
    this.room,
    required this.revision,
    required this.syncStatus,
    this.deletedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || teacherName != null) {
      map['teacher_name'] = Variable<String>(teacherName);
    }
    if (!nullToAbsent || room != null) {
      map['room'] = Variable<String>(room);
    }
    map['revision'] = Variable<int>(revision);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalSubjectsCompanion toCompanion(bool nullToAbsent) {
    return LocalSubjectsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      code: Value(code),
      colorValue: Value(colorValue),
      teacherName: teacherName == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherName),
      room: room == null && nullToAbsent ? const Value.absent() : Value(room),
      revision: Value(revision),
      syncStatus: Value(syncStatus),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubjectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      teacherName: serializer.fromJson<String?>(json['teacherName']),
      room: serializer.fromJson<String?>(json['room']),
      revision: serializer.fromJson<int>(json['revision']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'colorValue': serializer.toJson<int>(colorValue),
      'teacherName': serializer.toJson<String?>(teacherName),
      'room': serializer.toJson<String?>(room),
      'revision': serializer.toJson<int>(revision),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubjectRow copyWith({
    String? id,
    String? accountId,
    String? name,
    String? code,
    int? colorValue,
    Value<String?> teacherName = const Value.absent(),
    Value<String?> room = const Value.absent(),
    int? revision,
    String? syncStatus,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => SubjectRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    name: name ?? this.name,
    code: code ?? this.code,
    colorValue: colorValue ?? this.colorValue,
    teacherName: teacherName.present ? teacherName.value : this.teacherName,
    room: room.present ? room.value : this.room,
    revision: revision ?? this.revision,
    syncStatus: syncStatus ?? this.syncStatus,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SubjectRow copyWithCompanion(LocalSubjectsCompanion data) {
    return SubjectRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      teacherName: data.teacherName.present
          ? data.teacherName.value
          : this.teacherName,
      room: data.room.present ? data.room.value : this.room,
      revision: data.revision.present ? data.revision.value : this.revision,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('colorValue: $colorValue, ')
          ..write('teacherName: $teacherName, ')
          ..write('room: $room, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    name,
    code,
    colorValue,
    teacherName,
    room,
    revision,
    syncStatus,
    deletedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.code == this.code &&
          other.colorValue == this.colorValue &&
          other.teacherName == this.teacherName &&
          other.room == this.room &&
          other.revision == this.revision &&
          other.syncStatus == this.syncStatus &&
          other.deletedAt == this.deletedAt &&
          other.updatedAt == this.updatedAt);
}

class LocalSubjectsCompanion extends UpdateCompanion<SubjectRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> name;
  final Value<String> code;
  final Value<int> colorValue;
  final Value<String?> teacherName;
  final Value<String?> room;
  final Value<int> revision;
  final Value<String> syncStatus;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalSubjectsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.teacherName = const Value.absent(),
    this.room = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSubjectsCompanion.insert({
    required String id,
    required String accountId,
    required String name,
    required String code,
    this.colorValue = const Value.absent(),
    this.teacherName = const Value.absent(),
    this.room = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       name = Value(name),
       code = Value(code),
       updatedAt = Value(updatedAt);
  static Insertable<SubjectRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? colorValue,
    Expression<String>? teacherName,
    Expression<String>? room,
    Expression<int>? revision,
    Expression<String>? syncStatus,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (colorValue != null) 'color_value': colorValue,
      if (teacherName != null) 'teacher_name': teacherName,
      if (room != null) 'room': room,
      if (revision != null) 'revision': revision,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSubjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? name,
    Value<String>? code,
    Value<int>? colorValue,
    Value<String?>? teacherName,
    Value<String?>? room,
    Value<int>? revision,
    Value<String>? syncStatus,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalSubjectsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      code: code ?? this.code,
      colorValue: colorValue ?? this.colorValue,
      teacherName: teacherName ?? this.teacherName,
      room: room ?? this.room,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (teacherName.present) {
      map['teacher_name'] = Variable<String>(teacherName.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSubjectsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('colorValue: $colorValue, ')
          ..write('teacherName: $teacherName, ')
          ..write('room: $room, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTasksTable extends LocalTasks
    with TableInfo<$LocalTasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueTimeMeta = const VerificationMeta(
    'dueTime',
  );
  @override
  late final GeneratedColumn<String> dueTime = GeneratedColumn<String>(
    'due_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasExplicitTimeMeta = const VerificationMeta(
    'hasExplicitTime',
  );
  @override
  late final GeneratedColumn<bool> hasExplicitTime = GeneratedColumn<bool>(
    'has_explicit_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_explicit_time" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderOffsetMinutesMeta =
      const VerificationMeta('reminderOffsetMinutes');
  @override
  late final GeneratedColumn<int> reminderOffsetMinutes = GeneratedColumn<int>(
    'reminder_offset_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    title,
    description,
    subjectId,
    dueDate,
    dueTime,
    hasExplicitTime,
    priority,
    status,
    completedAt,
    reminderOffsetMinutes,
    revision,
    syncStatus,
    deletedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_time')) {
      context.handle(
        _dueTimeMeta,
        dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta),
      );
    }
    if (data.containsKey('has_explicit_time')) {
      context.handle(
        _hasExplicitTimeMeta,
        hasExplicitTime.isAcceptableOrUnknown(
          data['has_explicit_time']!,
          _hasExplicitTimeMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('reminder_offset_minutes')) {
      context.handle(
        _reminderOffsetMinutesMeta,
        reminderOffsetMinutes.isAcceptableOrUnknown(
          data['reminder_offset_minutes']!,
          _reminderOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      dueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_time'],
      ),
      hasExplicitTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_explicit_time'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      reminderOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_offset_minutes'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalTasksTable createAlias(String alias) {
    return $LocalTasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String accountId;
  final String title;
  final String? description;
  final String? subjectId;
  final String? dueDate;
  final String? dueTime;
  final bool hasExplicitTime;
  final String priority;
  final String status;
  final DateTime? completedAt;
  final int? reminderOffsetMinutes;
  final int revision;
  final String syncStatus;
  final DateTime? deletedAt;
  final DateTime updatedAt;
  const TaskRow({
    required this.id,
    required this.accountId,
    required this.title,
    this.description,
    this.subjectId,
    this.dueDate,
    this.dueTime,
    required this.hasExplicitTime,
    required this.priority,
    required this.status,
    this.completedAt,
    this.reminderOffsetMinutes,
    required this.revision,
    required this.syncStatus,
    this.deletedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<String>(subjectId);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || dueTime != null) {
      map['due_time'] = Variable<String>(dueTime);
    }
    map['has_explicit_time'] = Variable<bool>(hasExplicitTime);
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || reminderOffsetMinutes != null) {
      map['reminder_offset_minutes'] = Variable<int>(reminderOffsetMinutes);
    }
    map['revision'] = Variable<int>(revision);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalTasksCompanion toCompanion(bool nullToAbsent) {
    return LocalTasksCompanion(
      id: Value(id),
      accountId: Value(accountId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueTime: dueTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTime),
      hasExplicitTime: Value(hasExplicitTime),
      priority: Value(priority),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      reminderOffsetMinutes: reminderOffsetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderOffsetMinutes),
      revision: Value(revision),
      syncStatus: Value(syncStatus),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      subjectId: serializer.fromJson<String?>(json['subjectId']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      dueTime: serializer.fromJson<String?>(json['dueTime']),
      hasExplicitTime: serializer.fromJson<bool>(json['hasExplicitTime']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      reminderOffsetMinutes: serializer.fromJson<int?>(
        json['reminderOffsetMinutes'],
      ),
      revision: serializer.fromJson<int>(json['revision']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'subjectId': serializer.toJson<String?>(subjectId),
      'dueDate': serializer.toJson<String?>(dueDate),
      'dueTime': serializer.toJson<String?>(dueTime),
      'hasExplicitTime': serializer.toJson<bool>(hasExplicitTime),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'reminderOffsetMinutes': serializer.toJson<int?>(reminderOffsetMinutes),
      'revision': serializer.toJson<int>(revision),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskRow copyWith({
    String? id,
    String? accountId,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> subjectId = const Value.absent(),
    Value<String?> dueDate = const Value.absent(),
    Value<String?> dueTime = const Value.absent(),
    bool? hasExplicitTime,
    String? priority,
    String? status,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> reminderOffsetMinutes = const Value.absent(),
    int? revision,
    String? syncStatus,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => TaskRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueTime: dueTime.present ? dueTime.value : this.dueTime,
    hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    reminderOffsetMinutes: reminderOffsetMinutes.present
        ? reminderOffsetMinutes.value
        : this.reminderOffsetMinutes,
    revision: revision ?? this.revision,
    syncStatus: syncStatus ?? this.syncStatus,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskRow copyWithCompanion(LocalTasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      hasExplicitTime: data.hasExplicitTime.present
          ? data.hasExplicitTime.value
          : this.hasExplicitTime,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      reminderOffsetMinutes: data.reminderOffsetMinutes.present
          ? data.reminderOffsetMinutes.value
          : this.reminderOffsetMinutes,
      revision: data.revision.present ? data.revision.value : this.revision,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('subjectId: $subjectId, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('hasExplicitTime: $hasExplicitTime, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    title,
    description,
    subjectId,
    dueDate,
    dueTime,
    hasExplicitTime,
    priority,
    status,
    completedAt,
    reminderOffsetMinutes,
    revision,
    syncStatus,
    deletedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.title == this.title &&
          other.description == this.description &&
          other.subjectId == this.subjectId &&
          other.dueDate == this.dueDate &&
          other.dueTime == this.dueTime &&
          other.hasExplicitTime == this.hasExplicitTime &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.completedAt == this.completedAt &&
          other.reminderOffsetMinutes == this.reminderOffsetMinutes &&
          other.revision == this.revision &&
          other.syncStatus == this.syncStatus &&
          other.deletedAt == this.deletedAt &&
          other.updatedAt == this.updatedAt);
}

class LocalTasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> subjectId;
  final Value<String?> dueDate;
  final Value<String?> dueTime;
  final Value<bool> hasExplicitTime;
  final Value<String> priority;
  final Value<String> status;
  final Value<DateTime?> completedAt;
  final Value<int?> reminderOffsetMinutes;
  final Value<int> revision;
  final Value<String> syncStatus;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalTasksCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.hasExplicitTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTasksCompanion.insert({
    required String id,
    required String accountId,
    required String title,
    this.description = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.hasExplicitTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       title = Value(title),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? subjectId,
    Expression<String>? dueDate,
    Expression<String>? dueTime,
    Expression<bool>? hasExplicitTime,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<DateTime>? completedAt,
    Expression<int>? reminderOffsetMinutes,
    Expression<int>? revision,
    Expression<String>? syncStatus,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (subjectId != null) 'subject_id': subjectId,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTime != null) 'due_time': dueTime,
      if (hasExplicitTime != null) 'has_explicit_time': hasExplicitTime,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
      if (reminderOffsetMinutes != null)
        'reminder_offset_minutes': reminderOffsetMinutes,
      if (revision != null) 'revision': revision,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTasksCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? subjectId,
    Value<String?>? dueDate,
    Value<String?>? dueTime,
    Value<bool>? hasExplicitTime,
    Value<String>? priority,
    Value<String>? status,
    Value<DateTime?>? completedAt,
    Value<int?>? reminderOffsetMinutes,
    Value<int>? revision,
    Value<String>? syncStatus,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalTasksCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      title: title ?? this.title,
      description: description ?? this.description,
      subjectId: subjectId ?? this.subjectId,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      reminderOffsetMinutes:
          reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (dueTime.present) {
      map['due_time'] = Variable<String>(dueTime.value);
    }
    if (hasExplicitTime.present) {
      map['has_explicit_time'] = Variable<bool>(hasExplicitTime.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (reminderOffsetMinutes.present) {
      map['reminder_offset_minutes'] = Variable<int>(
        reminderOffsetMinutes.value,
      );
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTasksCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('subjectId: $subjectId, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('hasExplicitTime: $hasExplicitTime, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTimetableEntriesTable extends LocalTimetableEntries
    with TableInfo<$LocalTimetableEntriesTable, TimetableRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTimetableEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    subjectId,
    weekday,
    startMinutes,
    endMinutes,
    room,
    revision,
    syncStatus,
    deletedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_timetable_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimetableRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesMeta);
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinutesMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimetableRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimetableRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      )!,
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      )!,
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalTimetableEntriesTable createAlias(String alias) {
    return $LocalTimetableEntriesTable(attachedDatabase, alias);
  }
}

class TimetableRow extends DataClass implements Insertable<TimetableRow> {
  final String id;
  final String accountId;
  final String subjectId;
  final int weekday;
  final int startMinutes;
  final int endMinutes;
  final String? room;
  final int revision;
  final String syncStatus;
  final DateTime? deletedAt;
  final DateTime updatedAt;
  const TimetableRow({
    required this.id,
    required this.accountId,
    required this.subjectId,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    this.room,
    required this.revision,
    required this.syncStatus,
    this.deletedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['subject_id'] = Variable<String>(subjectId);
    map['weekday'] = Variable<int>(weekday);
    map['start_minutes'] = Variable<int>(startMinutes);
    map['end_minutes'] = Variable<int>(endMinutes);
    if (!nullToAbsent || room != null) {
      map['room'] = Variable<String>(room);
    }
    map['revision'] = Variable<int>(revision);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalTimetableEntriesCompanion toCompanion(bool nullToAbsent) {
    return LocalTimetableEntriesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      subjectId: Value(subjectId),
      weekday: Value(weekday),
      startMinutes: Value(startMinutes),
      endMinutes: Value(endMinutes),
      room: room == null && nullToAbsent ? const Value.absent() : Value(room),
      revision: Value(revision),
      syncStatus: Value(syncStatus),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TimetableRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimetableRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      endMinutes: serializer.fromJson<int>(json['endMinutes']),
      room: serializer.fromJson<String?>(json['room']),
      revision: serializer.fromJson<int>(json['revision']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'subjectId': serializer.toJson<String>(subjectId),
      'weekday': serializer.toJson<int>(weekday),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'endMinutes': serializer.toJson<int>(endMinutes),
      'room': serializer.toJson<String?>(room),
      'revision': serializer.toJson<int>(revision),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TimetableRow copyWith({
    String? id,
    String? accountId,
    String? subjectId,
    int? weekday,
    int? startMinutes,
    int? endMinutes,
    Value<String?> room = const Value.absent(),
    int? revision,
    String? syncStatus,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => TimetableRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    subjectId: subjectId ?? this.subjectId,
    weekday: weekday ?? this.weekday,
    startMinutes: startMinutes ?? this.startMinutes,
    endMinutes: endMinutes ?? this.endMinutes,
    room: room.present ? room.value : this.room,
    revision: revision ?? this.revision,
    syncStatus: syncStatus ?? this.syncStatus,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TimetableRow copyWithCompanion(LocalTimetableEntriesCompanion data) {
    return TimetableRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      room: data.room.present ? data.room.value : this.room,
      revision: data.revision.present ? data.revision.value : this.revision,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimetableRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('subjectId: $subjectId, ')
          ..write('weekday: $weekday, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('room: $room, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    subjectId,
    weekday,
    startMinutes,
    endMinutes,
    room,
    revision,
    syncStatus,
    deletedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimetableRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.subjectId == this.subjectId &&
          other.weekday == this.weekday &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.room == this.room &&
          other.revision == this.revision &&
          other.syncStatus == this.syncStatus &&
          other.deletedAt == this.deletedAt &&
          other.updatedAt == this.updatedAt);
}

class LocalTimetableEntriesCompanion extends UpdateCompanion<TimetableRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> subjectId;
  final Value<int> weekday;
  final Value<int> startMinutes;
  final Value<int> endMinutes;
  final Value<String?> room;
  final Value<int> revision;
  final Value<String> syncStatus;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalTimetableEntriesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.room = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTimetableEntriesCompanion.insert({
    required String id,
    required String accountId,
    required String subjectId,
    required int weekday,
    required int startMinutes,
    required int endMinutes,
    this.room = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       subjectId = Value(subjectId),
       weekday = Value(weekday),
       startMinutes = Value(startMinutes),
       endMinutes = Value(endMinutes),
       updatedAt = Value(updatedAt);
  static Insertable<TimetableRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? subjectId,
    Expression<int>? weekday,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<String>? room,
    Expression<int>? revision,
    Expression<String>? syncStatus,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (subjectId != null) 'subject_id': subjectId,
      if (weekday != null) 'weekday': weekday,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (room != null) 'room': room,
      if (revision != null) 'revision': revision,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTimetableEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? subjectId,
    Value<int>? weekday,
    Value<int>? startMinutes,
    Value<int>? endMinutes,
    Value<String?>? room,
    Value<int>? revision,
    Value<String>? syncStatus,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalTimetableEntriesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      subjectId: subjectId ?? this.subjectId,
      weekday: weekday ?? this.weekday,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      room: room ?? this.room,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTimetableEntriesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('subjectId: $subjectId, ')
          ..write('weekday: $weekday, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('room: $room, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalAcademicEventsTable extends LocalAcademicEvents
    with TableInfo<$LocalAcademicEventsTable, AcademicEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAcademicEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _eventDateMeta = const VerificationMeta(
    'eventDate',
  );
  @override
  late final GeneratedColumn<String> eventDate = GeneratedColumn<String>(
    'event_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderOffsetMinutesMeta =
      const VerificationMeta('reminderOffsetMinutes');
  @override
  late final GeneratedColumn<int> reminderOffsetMinutes = GeneratedColumn<int>(
    'reminder_offset_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    title,
    type,
    eventDate,
    startTime,
    endTime,
    description,
    location,
    reminderOffsetMinutes,
    revision,
    syncStatus,
    deletedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_academic_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AcademicEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('event_date')) {
      context.handle(
        _eventDateMeta,
        eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta),
      );
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('reminder_offset_minutes')) {
      context.handle(
        _reminderOffsetMinutesMeta,
        reminderOffsetMinutes.isAcceptableOrUnknown(
          data['reminder_offset_minutes']!,
          _reminderOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AcademicEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AcademicEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      eventDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_date'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      reminderOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_offset_minutes'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalAcademicEventsTable createAlias(String alias) {
    return $LocalAcademicEventsTable(attachedDatabase, alias);
  }
}

class AcademicEventRow extends DataClass
    implements Insertable<AcademicEventRow> {
  final String id;
  final String accountId;
  final String title;
  final String type;
  final String eventDate;
  final String? startTime;
  final String? endTime;
  final String? description;
  final String? location;
  final int? reminderOffsetMinutes;
  final int revision;
  final String syncStatus;
  final DateTime? deletedAt;
  final DateTime updatedAt;
  const AcademicEventRow({
    required this.id,
    required this.accountId,
    required this.title,
    required this.type,
    required this.eventDate,
    this.startTime,
    this.endTime,
    this.description,
    this.location,
    this.reminderOffsetMinutes,
    required this.revision,
    required this.syncStatus,
    this.deletedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['event_date'] = Variable<String>(eventDate);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || reminderOffsetMinutes != null) {
      map['reminder_offset_minutes'] = Variable<int>(reminderOffsetMinutes);
    }
    map['revision'] = Variable<int>(revision);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalAcademicEventsCompanion toCompanion(bool nullToAbsent) {
    return LocalAcademicEventsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      title: Value(title),
      type: Value(type),
      eventDate: Value(eventDate),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      reminderOffsetMinutes: reminderOffsetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderOffsetMinutes),
      revision: Value(revision),
      syncStatus: Value(syncStatus),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AcademicEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AcademicEventRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      eventDate: serializer.fromJson<String>(json['eventDate']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      description: serializer.fromJson<String?>(json['description']),
      location: serializer.fromJson<String?>(json['location']),
      reminderOffsetMinutes: serializer.fromJson<int?>(
        json['reminderOffsetMinutes'],
      ),
      revision: serializer.fromJson<int>(json['revision']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'eventDate': serializer.toJson<String>(eventDate),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'description': serializer.toJson<String?>(description),
      'location': serializer.toJson<String?>(location),
      'reminderOffsetMinutes': serializer.toJson<int?>(reminderOffsetMinutes),
      'revision': serializer.toJson<int>(revision),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AcademicEventRow copyWith({
    String? id,
    String? accountId,
    String? title,
    String? type,
    String? eventDate,
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<int?> reminderOffsetMinutes = const Value.absent(),
    int? revision,
    String? syncStatus,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => AcademicEventRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    title: title ?? this.title,
    type: type ?? this.type,
    eventDate: eventDate ?? this.eventDate,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    description: description.present ? description.value : this.description,
    location: location.present ? location.value : this.location,
    reminderOffsetMinutes: reminderOffsetMinutes.present
        ? reminderOffsetMinutes.value
        : this.reminderOffsetMinutes,
    revision: revision ?? this.revision,
    syncStatus: syncStatus ?? this.syncStatus,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AcademicEventRow copyWithCompanion(LocalAcademicEventsCompanion data) {
    return AcademicEventRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      description: data.description.present
          ? data.description.value
          : this.description,
      location: data.location.present ? data.location.value : this.location,
      reminderOffsetMinutes: data.reminderOffsetMinutes.present
          ? data.reminderOffsetMinutes.value
          : this.reminderOffsetMinutes,
      revision: data.revision.present ? data.revision.value : this.revision,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AcademicEventRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('eventDate: $eventDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    title,
    type,
    eventDate,
    startTime,
    endTime,
    description,
    location,
    reminderOffsetMinutes,
    revision,
    syncStatus,
    deletedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AcademicEventRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.title == this.title &&
          other.type == this.type &&
          other.eventDate == this.eventDate &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.description == this.description &&
          other.location == this.location &&
          other.reminderOffsetMinutes == this.reminderOffsetMinutes &&
          other.revision == this.revision &&
          other.syncStatus == this.syncStatus &&
          other.deletedAt == this.deletedAt &&
          other.updatedAt == this.updatedAt);
}

class LocalAcademicEventsCompanion extends UpdateCompanion<AcademicEventRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> title;
  final Value<String> type;
  final Value<String> eventDate;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<String?> description;
  final Value<String?> location;
  final Value<int?> reminderOffsetMinutes;
  final Value<int> revision;
  final Value<String> syncStatus;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalAcademicEventsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAcademicEventsCompanion.insert({
    required String id,
    required String accountId,
    required String title,
    this.type = const Value.absent(),
    required String eventDate,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       title = Value(title),
       eventDate = Value(eventDate),
       updatedAt = Value(updatedAt);
  static Insertable<AcademicEventRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? eventDate,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? description,
    Expression<String>? location,
    Expression<int>? reminderOffsetMinutes,
    Expression<int>? revision,
    Expression<String>? syncStatus,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (eventDate != null) 'event_date': eventDate,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (reminderOffsetMinutes != null)
        'reminder_offset_minutes': reminderOffsetMinutes,
      if (revision != null) 'revision': revision,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAcademicEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? title,
    Value<String>? type,
    Value<String>? eventDate,
    Value<String?>? startTime,
    Value<String?>? endTime,
    Value<String?>? description,
    Value<String?>? location,
    Value<int?>? reminderOffsetMinutes,
    Value<int>? revision,
    Value<String>? syncStatus,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalAcademicEventsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      title: title ?? this.title,
      type: type ?? this.type,
      eventDate: eventDate ?? this.eventDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      location: location ?? this.location,
      reminderOffsetMinutes:
          reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<String>(eventDate.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (reminderOffsetMinutes.present) {
      map['reminder_offset_minutes'] = Variable<int>(
        reminderOffsetMinutes.value,
      );
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAcademicEventsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('eventDate: $eventDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedClassroomsTable extends CachedClassrooms
    with TableInfo<$CachedClassroomsTable, CachedClassroomRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedClassroomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teacherIdMeta = const VerificationMeta(
    'teacherId',
  );
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
    'teacher_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teacherNameMeta = const VerificationMeta(
    'teacherName',
  );
  @override
  late final GeneratedColumn<String> teacherName = GeneratedColumn<String>(
    'teacher_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _subjectNameMeta = const VerificationMeta(
    'subjectName',
  );
  @override
  late final GeneratedColumn<String> subjectName = GeneratedColumn<String>(
    'subject_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _joinCodeMeta = const VerificationMeta(
    'joinCode',
  );
  @override
  late final GeneratedColumn<String> joinCode = GeneratedColumn<String>(
    'join_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    teacherId,
    teacherName,
    name,
    subjectName,
    description,
    joinCode,
    timezone,
    archived,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_classrooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedClassroomRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(
        _teacherIdMeta,
        teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teacherIdMeta);
    }
    if (data.containsKey('teacher_name')) {
      context.handle(
        _teacherNameMeta,
        teacherName.isAcceptableOrUnknown(
          data['teacher_name']!,
          _teacherNameMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('subject_name')) {
      context.handle(
        _subjectNameMeta,
        subjectName.isAcceptableOrUnknown(
          data['subject_name']!,
          _subjectNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subjectNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('join_code')) {
      context.handle(
        _joinCodeMeta,
        joinCode.isAcceptableOrUnknown(data['join_code']!, _joinCodeMeta),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedClassroomRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedClassroomRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      teacherId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_id'],
      )!,
      teacherName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_name'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      subjectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      joinCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}join_code'],
      ),
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedClassroomsTable createAlias(String alias) {
    return $CachedClassroomsTable(attachedDatabase, alias);
  }
}

class CachedClassroomRow extends DataClass
    implements Insertable<CachedClassroomRow> {
  final String id;
  final String accountId;
  final String teacherId;
  final String? teacherName;
  final String name;
  final String subjectName;
  final String? description;
  final String? joinCode;
  final String timezone;
  final bool archived;
  final DateTime cachedAt;
  const CachedClassroomRow({
    required this.id,
    required this.accountId,
    required this.teacherId,
    this.teacherName,
    required this.name,
    required this.subjectName,
    this.description,
    this.joinCode,
    required this.timezone,
    required this.archived,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['teacher_id'] = Variable<String>(teacherId);
    if (!nullToAbsent || teacherName != null) {
      map['teacher_name'] = Variable<String>(teacherName);
    }
    map['name'] = Variable<String>(name);
    map['subject_name'] = Variable<String>(subjectName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || joinCode != null) {
      map['join_code'] = Variable<String>(joinCode);
    }
    map['timezone'] = Variable<String>(timezone);
    map['archived'] = Variable<bool>(archived);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedClassroomsCompanion toCompanion(bool nullToAbsent) {
    return CachedClassroomsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      teacherId: Value(teacherId),
      teacherName: teacherName == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherName),
      name: Value(name),
      subjectName: Value(subjectName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      joinCode: joinCode == null && nullToAbsent
          ? const Value.absent()
          : Value(joinCode),
      timezone: Value(timezone),
      archived: Value(archived),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedClassroomRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedClassroomRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      teacherName: serializer.fromJson<String?>(json['teacherName']),
      name: serializer.fromJson<String>(json['name']),
      subjectName: serializer.fromJson<String>(json['subjectName']),
      description: serializer.fromJson<String?>(json['description']),
      joinCode: serializer.fromJson<String?>(json['joinCode']),
      timezone: serializer.fromJson<String>(json['timezone']),
      archived: serializer.fromJson<bool>(json['archived']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'teacherId': serializer.toJson<String>(teacherId),
      'teacherName': serializer.toJson<String?>(teacherName),
      'name': serializer.toJson<String>(name),
      'subjectName': serializer.toJson<String>(subjectName),
      'description': serializer.toJson<String?>(description),
      'joinCode': serializer.toJson<String?>(joinCode),
      'timezone': serializer.toJson<String>(timezone),
      'archived': serializer.toJson<bool>(archived),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedClassroomRow copyWith({
    String? id,
    String? accountId,
    String? teacherId,
    Value<String?> teacherName = const Value.absent(),
    String? name,
    String? subjectName,
    Value<String?> description = const Value.absent(),
    Value<String?> joinCode = const Value.absent(),
    String? timezone,
    bool? archived,
    DateTime? cachedAt,
  }) => CachedClassroomRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    teacherId: teacherId ?? this.teacherId,
    teacherName: teacherName.present ? teacherName.value : this.teacherName,
    name: name ?? this.name,
    subjectName: subjectName ?? this.subjectName,
    description: description.present ? description.value : this.description,
    joinCode: joinCode.present ? joinCode.value : this.joinCode,
    timezone: timezone ?? this.timezone,
    archived: archived ?? this.archived,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedClassroomRow copyWithCompanion(CachedClassroomsCompanion data) {
    return CachedClassroomRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      teacherName: data.teacherName.present
          ? data.teacherName.value
          : this.teacherName,
      name: data.name.present ? data.name.value : this.name,
      subjectName: data.subjectName.present
          ? data.subjectName.value
          : this.subjectName,
      description: data.description.present
          ? data.description.value
          : this.description,
      joinCode: data.joinCode.present ? data.joinCode.value : this.joinCode,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      archived: data.archived.present ? data.archived.value : this.archived,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedClassroomRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('teacherId: $teacherId, ')
          ..write('teacherName: $teacherName, ')
          ..write('name: $name, ')
          ..write('subjectName: $subjectName, ')
          ..write('description: $description, ')
          ..write('joinCode: $joinCode, ')
          ..write('timezone: $timezone, ')
          ..write('archived: $archived, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    teacherId,
    teacherName,
    name,
    subjectName,
    description,
    joinCode,
    timezone,
    archived,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedClassroomRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.teacherId == this.teacherId &&
          other.teacherName == this.teacherName &&
          other.name == this.name &&
          other.subjectName == this.subjectName &&
          other.description == this.description &&
          other.joinCode == this.joinCode &&
          other.timezone == this.timezone &&
          other.archived == this.archived &&
          other.cachedAt == this.cachedAt);
}

class CachedClassroomsCompanion extends UpdateCompanion<CachedClassroomRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> teacherId;
  final Value<String?> teacherName;
  final Value<String> name;
  final Value<String> subjectName;
  final Value<String?> description;
  final Value<String?> joinCode;
  final Value<String> timezone;
  final Value<bool> archived;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedClassroomsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.teacherName = const Value.absent(),
    this.name = const Value.absent(),
    this.subjectName = const Value.absent(),
    this.description = const Value.absent(),
    this.joinCode = const Value.absent(),
    this.timezone = const Value.absent(),
    this.archived = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedClassroomsCompanion.insert({
    required String id,
    required String accountId,
    required String teacherId,
    this.teacherName = const Value.absent(),
    required String name,
    required String subjectName,
    this.description = const Value.absent(),
    this.joinCode = const Value.absent(),
    required String timezone,
    this.archived = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       teacherId = Value(teacherId),
       name = Value(name),
       subjectName = Value(subjectName),
       timezone = Value(timezone),
       cachedAt = Value(cachedAt);
  static Insertable<CachedClassroomRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? teacherId,
    Expression<String>? teacherName,
    Expression<String>? name,
    Expression<String>? subjectName,
    Expression<String>? description,
    Expression<String>? joinCode,
    Expression<String>? timezone,
    Expression<bool>? archived,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (teacherId != null) 'teacher_id': teacherId,
      if (teacherName != null) 'teacher_name': teacherName,
      if (name != null) 'name': name,
      if (subjectName != null) 'subject_name': subjectName,
      if (description != null) 'description': description,
      if (joinCode != null) 'join_code': joinCode,
      if (timezone != null) 'timezone': timezone,
      if (archived != null) 'archived': archived,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedClassroomsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? teacherId,
    Value<String?>? teacherName,
    Value<String>? name,
    Value<String>? subjectName,
    Value<String?>? description,
    Value<String?>? joinCode,
    Value<String>? timezone,
    Value<bool>? archived,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedClassroomsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      name: name ?? this.name,
      subjectName: subjectName ?? this.subjectName,
      description: description ?? this.description,
      joinCode: joinCode ?? this.joinCode,
      timezone: timezone ?? this.timezone,
      archived: archived ?? this.archived,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (teacherName.present) {
      map['teacher_name'] = Variable<String>(teacherName.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (subjectName.present) {
      map['subject_name'] = Variable<String>(subjectName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (joinCode.present) {
      map['join_code'] = Variable<String>(joinCode.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedClassroomsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('teacherId: $teacherId, ')
          ..write('teacherName: $teacherName, ')
          ..write('name: $name, ')
          ..write('subjectName: $subjectName, ')
          ..write('description: $description, ')
          ..write('joinCode: $joinCode, ')
          ..write('timezone: $timezone, ')
          ..write('archived: $archived, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedClassroomMembersTable extends CachedClassroomMembers
    with TableInfo<$CachedClassroomMembersTable, CachedMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedClassroomMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classroomIdMeta = const VerificationMeta(
    'classroomId',
  );
  @override
  late final GeneratedColumn<String> classroomId = GeneratedColumn<String>(
    'classroom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentNameMeta = const VerificationMeta(
    'studentName',
  );
  @override
  late final GeneratedColumn<String> studentName = GeneratedColumn<String>(
    'student_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _studentEmailMeta = const VerificationMeta(
    'studentEmail',
  );
  @override
  late final GeneratedColumn<String> studentEmail = GeneratedColumn<String>(
    'student_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rejoinBlockedMeta = const VerificationMeta(
    'rejoinBlocked',
  );
  @override
  late final GeneratedColumn<bool> rejoinBlocked = GeneratedColumn<bool>(
    'rejoin_blocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rejoin_blocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    classroomId,
    studentId,
    studentName,
    studentEmail,
    status,
    rejoinBlocked,
    joinedAt,
    endedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_classroom_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('classroom_id')) {
      context.handle(
        _classroomIdMeta,
        classroomId.isAcceptableOrUnknown(
          data['classroom_id']!,
          _classroomIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_classroomIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('student_name')) {
      context.handle(
        _studentNameMeta,
        studentName.isAcceptableOrUnknown(
          data['student_name']!,
          _studentNameMeta,
        ),
      );
    }
    if (data.containsKey('student_email')) {
      context.handle(
        _studentEmailMeta,
        studentEmail.isAcceptableOrUnknown(
          data['student_email']!,
          _studentEmailMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('rejoin_blocked')) {
      context.handle(
        _rejoinBlockedMeta,
        rejoinBlocked.isAcceptableOrUnknown(
          data['rejoin_blocked']!,
          _rejoinBlockedMeta,
        ),
      );
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMemberRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      classroomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classroom_id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      studentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_name'],
      ),
      studentEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_email'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      rejoinBlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rejoin_blocked'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      ),
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
    );
  }

  @override
  $CachedClassroomMembersTable createAlias(String alias) {
    return $CachedClassroomMembersTable(attachedDatabase, alias);
  }
}

class CachedMemberRow extends DataClass implements Insertable<CachedMemberRow> {
  final String id;
  final String accountId;
  final String classroomId;
  final String studentId;
  final String? studentName;
  final String? studentEmail;
  final String status;
  final bool rejoinBlocked;
  final DateTime? joinedAt;
  final DateTime? endedAt;
  const CachedMemberRow({
    required this.id,
    required this.accountId,
    required this.classroomId,
    required this.studentId,
    this.studentName,
    this.studentEmail,
    required this.status,
    required this.rejoinBlocked,
    this.joinedAt,
    this.endedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['classroom_id'] = Variable<String>(classroomId);
    map['student_id'] = Variable<String>(studentId);
    if (!nullToAbsent || studentName != null) {
      map['student_name'] = Variable<String>(studentName);
    }
    if (!nullToAbsent || studentEmail != null) {
      map['student_email'] = Variable<String>(studentEmail);
    }
    map['status'] = Variable<String>(status);
    map['rejoin_blocked'] = Variable<bool>(rejoinBlocked);
    if (!nullToAbsent || joinedAt != null) {
      map['joined_at'] = Variable<DateTime>(joinedAt);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  CachedClassroomMembersCompanion toCompanion(bool nullToAbsent) {
    return CachedClassroomMembersCompanion(
      id: Value(id),
      accountId: Value(accountId),
      classroomId: Value(classroomId),
      studentId: Value(studentId),
      studentName: studentName == null && nullToAbsent
          ? const Value.absent()
          : Value(studentName),
      studentEmail: studentEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(studentEmail),
      status: Value(status),
      rejoinBlocked: Value(rejoinBlocked),
      joinedAt: joinedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(joinedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory CachedMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMemberRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      classroomId: serializer.fromJson<String>(json['classroomId']),
      studentId: serializer.fromJson<String>(json['studentId']),
      studentName: serializer.fromJson<String?>(json['studentName']),
      studentEmail: serializer.fromJson<String?>(json['studentEmail']),
      status: serializer.fromJson<String>(json['status']),
      rejoinBlocked: serializer.fromJson<bool>(json['rejoinBlocked']),
      joinedAt: serializer.fromJson<DateTime?>(json['joinedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'classroomId': serializer.toJson<String>(classroomId),
      'studentId': serializer.toJson<String>(studentId),
      'studentName': serializer.toJson<String?>(studentName),
      'studentEmail': serializer.toJson<String?>(studentEmail),
      'status': serializer.toJson<String>(status),
      'rejoinBlocked': serializer.toJson<bool>(rejoinBlocked),
      'joinedAt': serializer.toJson<DateTime?>(joinedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  CachedMemberRow copyWith({
    String? id,
    String? accountId,
    String? classroomId,
    String? studentId,
    Value<String?> studentName = const Value.absent(),
    Value<String?> studentEmail = const Value.absent(),
    String? status,
    bool? rejoinBlocked,
    Value<DateTime?> joinedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
  }) => CachedMemberRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    classroomId: classroomId ?? this.classroomId,
    studentId: studentId ?? this.studentId,
    studentName: studentName.present ? studentName.value : this.studentName,
    studentEmail: studentEmail.present ? studentEmail.value : this.studentEmail,
    status: status ?? this.status,
    rejoinBlocked: rejoinBlocked ?? this.rejoinBlocked,
    joinedAt: joinedAt.present ? joinedAt.value : this.joinedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
  );
  CachedMemberRow copyWithCompanion(CachedClassroomMembersCompanion data) {
    return CachedMemberRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      classroomId: data.classroomId.present
          ? data.classroomId.value
          : this.classroomId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      studentName: data.studentName.present
          ? data.studentName.value
          : this.studentName,
      studentEmail: data.studentEmail.present
          ? data.studentEmail.value
          : this.studentEmail,
      status: data.status.present ? data.status.value : this.status,
      rejoinBlocked: data.rejoinBlocked.present
          ? data.rejoinBlocked.value
          : this.rejoinBlocked,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMemberRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('classroomId: $classroomId, ')
          ..write('studentId: $studentId, ')
          ..write('studentName: $studentName, ')
          ..write('studentEmail: $studentEmail, ')
          ..write('status: $status, ')
          ..write('rejoinBlocked: $rejoinBlocked, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    classroomId,
    studentId,
    studentName,
    studentEmail,
    status,
    rejoinBlocked,
    joinedAt,
    endedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMemberRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.classroomId == this.classroomId &&
          other.studentId == this.studentId &&
          other.studentName == this.studentName &&
          other.studentEmail == this.studentEmail &&
          other.status == this.status &&
          other.rejoinBlocked == this.rejoinBlocked &&
          other.joinedAt == this.joinedAt &&
          other.endedAt == this.endedAt);
}

class CachedClassroomMembersCompanion extends UpdateCompanion<CachedMemberRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> classroomId;
  final Value<String> studentId;
  final Value<String?> studentName;
  final Value<String?> studentEmail;
  final Value<String> status;
  final Value<bool> rejoinBlocked;
  final Value<DateTime?> joinedAt;
  final Value<DateTime?> endedAt;
  final Value<int> rowid;
  const CachedClassroomMembersCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.classroomId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.studentName = const Value.absent(),
    this.studentEmail = const Value.absent(),
    this.status = const Value.absent(),
    this.rejoinBlocked = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedClassroomMembersCompanion.insert({
    required String id,
    required String accountId,
    required String classroomId,
    required String studentId,
    this.studentName = const Value.absent(),
    this.studentEmail = const Value.absent(),
    required String status,
    this.rejoinBlocked = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       classroomId = Value(classroomId),
       studentId = Value(studentId),
       status = Value(status);
  static Insertable<CachedMemberRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? classroomId,
    Expression<String>? studentId,
    Expression<String>? studentName,
    Expression<String>? studentEmail,
    Expression<String>? status,
    Expression<bool>? rejoinBlocked,
    Expression<DateTime>? joinedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (classroomId != null) 'classroom_id': classroomId,
      if (studentId != null) 'student_id': studentId,
      if (studentName != null) 'student_name': studentName,
      if (studentEmail != null) 'student_email': studentEmail,
      if (status != null) 'status': status,
      if (rejoinBlocked != null) 'rejoin_blocked': rejoinBlocked,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedClassroomMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? classroomId,
    Value<String>? studentId,
    Value<String?>? studentName,
    Value<String?>? studentEmail,
    Value<String>? status,
    Value<bool>? rejoinBlocked,
    Value<DateTime?>? joinedAt,
    Value<DateTime?>? endedAt,
    Value<int>? rowid,
  }) {
    return CachedClassroomMembersCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      classroomId: classroomId ?? this.classroomId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentEmail: studentEmail ?? this.studentEmail,
      status: status ?? this.status,
      rejoinBlocked: rejoinBlocked ?? this.rejoinBlocked,
      joinedAt: joinedAt ?? this.joinedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (classroomId.present) {
      map['classroom_id'] = Variable<String>(classroomId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (studentName.present) {
      map['student_name'] = Variable<String>(studentName.value);
    }
    if (studentEmail.present) {
      map['student_email'] = Variable<String>(studentEmail.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rejoinBlocked.present) {
      map['rejoin_blocked'] = Variable<bool>(rejoinBlocked.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedClassroomMembersCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('classroomId: $classroomId, ')
          ..write('studentId: $studentId, ')
          ..write('studentName: $studentName, ')
          ..write('studentEmail: $studentEmail, ')
          ..write('status: $status, ')
          ..write('rejoinBlocked: $rejoinBlocked, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedMembershipEventsTable extends CachedMembershipEvents
    with TableInfo<$CachedMembershipEventsTable, MembershipEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedMembershipEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classroomIdMeta = const VerificationMeta(
    'classroomId',
  );
  @override
  late final GeneratedColumn<String> classroomId = GeneratedColumn<String>(
    'classroom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _membershipIdMeta = const VerificationMeta(
    'membershipId',
  );
  @override
  late final GeneratedColumn<String> membershipId = GeneratedColumn<String>(
    'membership_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentNameMeta = const VerificationMeta(
    'studentName',
  );
  @override
  late final GeneratedColumn<String> studentName = GeneratedColumn<String>(
    'student_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _performedByMeta = const VerificationMeta(
    'performedBy',
  );
  @override
  late final GeneratedColumn<String> performedBy = GeneratedColumn<String>(
    'performed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    classroomId,
    membershipId,
    studentName,
    performedBy,
    eventType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_membership_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<MembershipEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('classroom_id')) {
      context.handle(
        _classroomIdMeta,
        classroomId.isAcceptableOrUnknown(
          data['classroom_id']!,
          _classroomIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_classroomIdMeta);
    }
    if (data.containsKey('membership_id')) {
      context.handle(
        _membershipIdMeta,
        membershipId.isAcceptableOrUnknown(
          data['membership_id']!,
          _membershipIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_membershipIdMeta);
    }
    if (data.containsKey('student_name')) {
      context.handle(
        _studentNameMeta,
        studentName.isAcceptableOrUnknown(
          data['student_name']!,
          _studentNameMeta,
        ),
      );
    }
    if (data.containsKey('performed_by')) {
      context.handle(
        _performedByMeta,
        performedBy.isAcceptableOrUnknown(
          data['performed_by']!,
          _performedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performedByMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MembershipEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MembershipEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      classroomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classroom_id'],
      )!,
      membershipId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}membership_id'],
      )!,
      studentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_name'],
      ),
      performedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}performed_by'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CachedMembershipEventsTable createAlias(String alias) {
    return $CachedMembershipEventsTable(attachedDatabase, alias);
  }
}

class MembershipEventRow extends DataClass
    implements Insertable<MembershipEventRow> {
  final String id;
  final String accountId;
  final String classroomId;
  final String membershipId;
  final String? studentName;
  final String performedBy;
  final String eventType;
  final DateTime createdAt;
  const MembershipEventRow({
    required this.id,
    required this.accountId,
    required this.classroomId,
    required this.membershipId,
    this.studentName,
    required this.performedBy,
    required this.eventType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['classroom_id'] = Variable<String>(classroomId);
    map['membership_id'] = Variable<String>(membershipId);
    if (!nullToAbsent || studentName != null) {
      map['student_name'] = Variable<String>(studentName);
    }
    map['performed_by'] = Variable<String>(performedBy);
    map['event_type'] = Variable<String>(eventType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CachedMembershipEventsCompanion toCompanion(bool nullToAbsent) {
    return CachedMembershipEventsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      classroomId: Value(classroomId),
      membershipId: Value(membershipId),
      studentName: studentName == null && nullToAbsent
          ? const Value.absent()
          : Value(studentName),
      performedBy: Value(performedBy),
      eventType: Value(eventType),
      createdAt: Value(createdAt),
    );
  }

  factory MembershipEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MembershipEventRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      classroomId: serializer.fromJson<String>(json['classroomId']),
      membershipId: serializer.fromJson<String>(json['membershipId']),
      studentName: serializer.fromJson<String?>(json['studentName']),
      performedBy: serializer.fromJson<String>(json['performedBy']),
      eventType: serializer.fromJson<String>(json['eventType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'classroomId': serializer.toJson<String>(classroomId),
      'membershipId': serializer.toJson<String>(membershipId),
      'studentName': serializer.toJson<String?>(studentName),
      'performedBy': serializer.toJson<String>(performedBy),
      'eventType': serializer.toJson<String>(eventType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MembershipEventRow copyWith({
    String? id,
    String? accountId,
    String? classroomId,
    String? membershipId,
    Value<String?> studentName = const Value.absent(),
    String? performedBy,
    String? eventType,
    DateTime? createdAt,
  }) => MembershipEventRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    classroomId: classroomId ?? this.classroomId,
    membershipId: membershipId ?? this.membershipId,
    studentName: studentName.present ? studentName.value : this.studentName,
    performedBy: performedBy ?? this.performedBy,
    eventType: eventType ?? this.eventType,
    createdAt: createdAt ?? this.createdAt,
  );
  MembershipEventRow copyWithCompanion(CachedMembershipEventsCompanion data) {
    return MembershipEventRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      classroomId: data.classroomId.present
          ? data.classroomId.value
          : this.classroomId,
      membershipId: data.membershipId.present
          ? data.membershipId.value
          : this.membershipId,
      studentName: data.studentName.present
          ? data.studentName.value
          : this.studentName,
      performedBy: data.performedBy.present
          ? data.performedBy.value
          : this.performedBy,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MembershipEventRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('classroomId: $classroomId, ')
          ..write('membershipId: $membershipId, ')
          ..write('studentName: $studentName, ')
          ..write('performedBy: $performedBy, ')
          ..write('eventType: $eventType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    classroomId,
    membershipId,
    studentName,
    performedBy,
    eventType,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MembershipEventRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.classroomId == this.classroomId &&
          other.membershipId == this.membershipId &&
          other.studentName == this.studentName &&
          other.performedBy == this.performedBy &&
          other.eventType == this.eventType &&
          other.createdAt == this.createdAt);
}

class CachedMembershipEventsCompanion
    extends UpdateCompanion<MembershipEventRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> classroomId;
  final Value<String> membershipId;
  final Value<String?> studentName;
  final Value<String> performedBy;
  final Value<String> eventType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CachedMembershipEventsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.classroomId = const Value.absent(),
    this.membershipId = const Value.absent(),
    this.studentName = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.eventType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedMembershipEventsCompanion.insert({
    required String id,
    required String accountId,
    required String classroomId,
    required String membershipId,
    this.studentName = const Value.absent(),
    required String performedBy,
    required String eventType,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       classroomId = Value(classroomId),
       membershipId = Value(membershipId),
       performedBy = Value(performedBy),
       eventType = Value(eventType),
       createdAt = Value(createdAt);
  static Insertable<MembershipEventRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? classroomId,
    Expression<String>? membershipId,
    Expression<String>? studentName,
    Expression<String>? performedBy,
    Expression<String>? eventType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (classroomId != null) 'classroom_id': classroomId,
      if (membershipId != null) 'membership_id': membershipId,
      if (studentName != null) 'student_name': studentName,
      if (performedBy != null) 'performed_by': performedBy,
      if (eventType != null) 'event_type': eventType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedMembershipEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? classroomId,
    Value<String>? membershipId,
    Value<String?>? studentName,
    Value<String>? performedBy,
    Value<String>? eventType,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CachedMembershipEventsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      classroomId: classroomId ?? this.classroomId,
      membershipId: membershipId ?? this.membershipId,
      studentName: studentName ?? this.studentName,
      performedBy: performedBy ?? this.performedBy,
      eventType: eventType ?? this.eventType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (classroomId.present) {
      map['classroom_id'] = Variable<String>(classroomId.value);
    }
    if (membershipId.present) {
      map['membership_id'] = Variable<String>(membershipId.value);
    }
    if (studentName.present) {
      map['student_name'] = Variable<String>(studentName.value);
    }
    if (performedBy.present) {
      map['performed_by'] = Variable<String>(performedBy.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedMembershipEventsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('classroomId: $classroomId, ')
          ..write('membershipId: $membershipId, ')
          ..write('studentName: $studentName, ')
          ..write('performedBy: $performedBy, ')
          ..write('eventType: $eventType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedAssignmentsTable extends CachedAssignments
    with TableInfo<$CachedAssignmentsTable, CachedAssignmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classroomIdMeta = const VerificationMeta(
    'classroomId',
  );
  @override
  late final GeneratedColumn<String> classroomId = GeneratedColumn<String>(
    'classroom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classroomNameMeta = const VerificationMeta(
    'classroomName',
  );
  @override
  late final GeneratedColumn<String> classroomName = GeneratedColumn<String>(
    'classroom_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueTimeMeta = const VerificationMeta(
    'dueTime',
  );
  @override
  late final GeneratedColumn<String> dueTime = GeneratedColumn<String>(
    'due_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasExplicitTimeMeta = const VerificationMeta(
    'hasExplicitTime',
  );
  @override
  late final GeneratedColumn<bool> hasExplicitTime = GeneratedColumn<bool>(
    'has_explicit_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_explicit_time" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    classroomId,
    classroomName,
    title,
    description,
    dueDate,
    dueTime,
    hasExplicitTime,
    status,
    publishedAt,
    deletedAt,
    revision,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAssignmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('classroom_id')) {
      context.handle(
        _classroomIdMeta,
        classroomId.isAcceptableOrUnknown(
          data['classroom_id']!,
          _classroomIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_classroomIdMeta);
    }
    if (data.containsKey('classroom_name')) {
      context.handle(
        _classroomNameMeta,
        classroomName.isAcceptableOrUnknown(
          data['classroom_name']!,
          _classroomNameMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('due_time')) {
      context.handle(
        _dueTimeMeta,
        dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta),
      );
    }
    if (data.containsKey('has_explicit_time')) {
      context.handle(
        _hasExplicitTimeMeta,
        hasExplicitTime.isAcceptableOrUnknown(
          data['has_explicit_time']!,
          _hasExplicitTimeMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedAssignmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAssignmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      classroomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classroom_id'],
      )!,
      classroomName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classroom_name'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      )!,
      dueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_time'],
      ),
      hasExplicitTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_explicit_time'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedAssignmentsTable createAlias(String alias) {
    return $CachedAssignmentsTable(attachedDatabase, alias);
  }
}

class CachedAssignmentRow extends DataClass
    implements Insertable<CachedAssignmentRow> {
  final String id;
  final String accountId;
  final String classroomId;
  final String? classroomName;
  final String title;
  final String? description;
  final String dueDate;
  final String? dueTime;
  final bool hasExplicitTime;
  final String status;
  final DateTime? publishedAt;
  final DateTime? deletedAt;
  final int revision;
  final DateTime cachedAt;
  const CachedAssignmentRow({
    required this.id,
    required this.accountId,
    required this.classroomId,
    this.classroomName,
    required this.title,
    this.description,
    required this.dueDate,
    this.dueTime,
    required this.hasExplicitTime,
    required this.status,
    this.publishedAt,
    this.deletedAt,
    required this.revision,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['classroom_id'] = Variable<String>(classroomId);
    if (!nullToAbsent || classroomName != null) {
      map['classroom_name'] = Variable<String>(classroomName);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['due_date'] = Variable<String>(dueDate);
    if (!nullToAbsent || dueTime != null) {
      map['due_time'] = Variable<String>(dueTime);
    }
    map['has_explicit_time'] = Variable<bool>(hasExplicitTime);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['revision'] = Variable<int>(revision);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return CachedAssignmentsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      classroomId: Value(classroomId),
      classroomName: classroomName == null && nullToAbsent
          ? const Value.absent()
          : Value(classroomName),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDate: Value(dueDate),
      dueTime: dueTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTime),
      hasExplicitTime: Value(hasExplicitTime),
      status: Value(status),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      revision: Value(revision),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedAssignmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAssignmentRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      classroomId: serializer.fromJson<String>(json['classroomId']),
      classroomName: serializer.fromJson<String?>(json['classroomName']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDate: serializer.fromJson<String>(json['dueDate']),
      dueTime: serializer.fromJson<String?>(json['dueTime']),
      hasExplicitTime: serializer.fromJson<bool>(json['hasExplicitTime']),
      status: serializer.fromJson<String>(json['status']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      revision: serializer.fromJson<int>(json['revision']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'classroomId': serializer.toJson<String>(classroomId),
      'classroomName': serializer.toJson<String?>(classroomName),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDate': serializer.toJson<String>(dueDate),
      'dueTime': serializer.toJson<String?>(dueTime),
      'hasExplicitTime': serializer.toJson<bool>(hasExplicitTime),
      'status': serializer.toJson<String>(status),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'revision': serializer.toJson<int>(revision),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedAssignmentRow copyWith({
    String? id,
    String? accountId,
    String? classroomId,
    Value<String?> classroomName = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    String? dueDate,
    Value<String?> dueTime = const Value.absent(),
    bool? hasExplicitTime,
    String? status,
    Value<DateTime?> publishedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    int? revision,
    DateTime? cachedAt,
  }) => CachedAssignmentRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    classroomId: classroomId ?? this.classroomId,
    classroomName: classroomName.present
        ? classroomName.value
        : this.classroomName,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    dueDate: dueDate ?? this.dueDate,
    dueTime: dueTime.present ? dueTime.value : this.dueTime,
    hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
    status: status ?? this.status,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    revision: revision ?? this.revision,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedAssignmentRow copyWithCompanion(CachedAssignmentsCompanion data) {
    return CachedAssignmentRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      classroomId: data.classroomId.present
          ? data.classroomId.value
          : this.classroomId,
      classroomName: data.classroomName.present
          ? data.classroomName.value
          : this.classroomName,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      hasExplicitTime: data.hasExplicitTime.present
          ? data.hasExplicitTime.value
          : this.hasExplicitTime,
      status: data.status.present ? data.status.value : this.status,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      revision: data.revision.present ? data.revision.value : this.revision,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssignmentRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('classroomId: $classroomId, ')
          ..write('classroomName: $classroomName, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('hasExplicitTime: $hasExplicitTime, ')
          ..write('status: $status, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('revision: $revision, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    classroomId,
    classroomName,
    title,
    description,
    dueDate,
    dueTime,
    hasExplicitTime,
    status,
    publishedAt,
    deletedAt,
    revision,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAssignmentRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.classroomId == this.classroomId &&
          other.classroomName == this.classroomName &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.dueTime == this.dueTime &&
          other.hasExplicitTime == this.hasExplicitTime &&
          other.status == this.status &&
          other.publishedAt == this.publishedAt &&
          other.deletedAt == this.deletedAt &&
          other.revision == this.revision &&
          other.cachedAt == this.cachedAt);
}

class CachedAssignmentsCompanion extends UpdateCompanion<CachedAssignmentRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> classroomId;
  final Value<String?> classroomName;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> dueDate;
  final Value<String?> dueTime;
  final Value<bool> hasExplicitTime;
  final Value<String> status;
  final Value<DateTime?> publishedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> revision;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedAssignmentsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.classroomId = const Value.absent(),
    this.classroomName = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.hasExplicitTime = const Value.absent(),
    this.status = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.revision = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAssignmentsCompanion.insert({
    required String id,
    required String accountId,
    required String classroomId,
    this.classroomName = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String dueDate,
    this.dueTime = const Value.absent(),
    this.hasExplicitTime = const Value.absent(),
    required String status,
    this.publishedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.revision = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       classroomId = Value(classroomId),
       title = Value(title),
       dueDate = Value(dueDate),
       status = Value(status),
       cachedAt = Value(cachedAt);
  static Insertable<CachedAssignmentRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? classroomId,
    Expression<String>? classroomName,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? dueDate,
    Expression<String>? dueTime,
    Expression<bool>? hasExplicitTime,
    Expression<String>? status,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? revision,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (classroomId != null) 'classroom_id': classroomId,
      if (classroomName != null) 'classroom_name': classroomName,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTime != null) 'due_time': dueTime,
      if (hasExplicitTime != null) 'has_explicit_time': hasExplicitTime,
      if (status != null) 'status': status,
      if (publishedAt != null) 'published_at': publishedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (revision != null) 'revision': revision,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAssignmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? classroomId,
    Value<String?>? classroomName,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? dueDate,
    Value<String?>? dueTime,
    Value<bool>? hasExplicitTime,
    Value<String>? status,
    Value<DateTime?>? publishedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? revision,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedAssignmentsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      classroomId: classroomId ?? this.classroomId,
      classroomName: classroomName ?? this.classroomName,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      hasExplicitTime: hasExplicitTime ?? this.hasExplicitTime,
      status: status ?? this.status,
      publishedAt: publishedAt ?? this.publishedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      revision: revision ?? this.revision,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (classroomId.present) {
      map['classroom_id'] = Variable<String>(classroomId.value);
    }
    if (classroomName.present) {
      map['classroom_name'] = Variable<String>(classroomName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (dueTime.present) {
      map['due_time'] = Variable<String>(dueTime.value);
    }
    if (hasExplicitTime.present) {
      map['has_explicit_time'] = Variable<bool>(hasExplicitTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('classroomId: $classroomId, ')
          ..write('classroomName: $classroomName, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('hasExplicitTime: $hasExplicitTime, ')
          ..write('status: $status, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('revision: $revision, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalAssignmentProgressTable extends LocalAssignmentProgress
    with TableInfo<$LocalAssignmentProgressTable, AssignmentProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAssignmentProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignmentIdMeta = const VerificationMeta(
    'assignmentId',
  );
  @override
  late final GeneratedColumn<String> assignmentId = GeneratedColumn<String>(
    'assignment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    assignmentId,
    isCompleted,
    completedAt,
    revision,
    syncStatus,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_assignment_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssignmentProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('assignment_id')) {
      context.handle(
        _assignmentIdMeta,
        assignmentId.isAcceptableOrUnknown(
          data['assignment_id']!,
          _assignmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignmentIdMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssignmentProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssignmentProgressRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      assignmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assignment_id'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalAssignmentProgressTable createAlias(String alias) {
    return $LocalAssignmentProgressTable(attachedDatabase, alias);
  }
}

class AssignmentProgressRow extends DataClass
    implements Insertable<AssignmentProgressRow> {
  final String id;
  final String accountId;
  final String assignmentId;
  final bool isCompleted;
  final DateTime? completedAt;
  final int revision;
  final String syncStatus;
  final DateTime updatedAt;
  const AssignmentProgressRow({
    required this.id,
    required this.accountId,
    required this.assignmentId,
    required this.isCompleted,
    this.completedAt,
    required this.revision,
    required this.syncStatus,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['assignment_id'] = Variable<String>(assignmentId);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['revision'] = Variable<int>(revision);
    map['sync_status'] = Variable<String>(syncStatus);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalAssignmentProgressCompanion toCompanion(bool nullToAbsent) {
    return LocalAssignmentProgressCompanion(
      id: Value(id),
      accountId: Value(accountId),
      assignmentId: Value(assignmentId),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      revision: Value(revision),
      syncStatus: Value(syncStatus),
      updatedAt: Value(updatedAt),
    );
  }

  factory AssignmentProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssignmentProgressRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      assignmentId: serializer.fromJson<String>(json['assignmentId']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      revision: serializer.fromJson<int>(json['revision']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'assignmentId': serializer.toJson<String>(assignmentId),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'revision': serializer.toJson<int>(revision),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AssignmentProgressRow copyWith({
    String? id,
    String? accountId,
    String? assignmentId,
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    int? revision,
    String? syncStatus,
    DateTime? updatedAt,
  }) => AssignmentProgressRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    assignmentId: assignmentId ?? this.assignmentId,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    revision: revision ?? this.revision,
    syncStatus: syncStatus ?? this.syncStatus,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AssignmentProgressRow copyWithCompanion(
    LocalAssignmentProgressCompanion data,
  ) {
    return AssignmentProgressRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      assignmentId: data.assignmentId.present
          ? data.assignmentId.value
          : this.assignmentId,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      revision: data.revision.present ? data.revision.value : this.revision,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssignmentProgressRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('assignmentId: $assignmentId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    assignmentId,
    isCompleted,
    completedAt,
    revision,
    syncStatus,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssignmentProgressRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.assignmentId == this.assignmentId &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.revision == this.revision &&
          other.syncStatus == this.syncStatus &&
          other.updatedAt == this.updatedAt);
}

class LocalAssignmentProgressCompanion
    extends UpdateCompanion<AssignmentProgressRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> assignmentId;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<int> revision;
  final Value<String> syncStatus;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalAssignmentProgressCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.assignmentId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAssignmentProgressCompanion.insert({
    required String id,
    required String accountId,
    required String assignmentId,
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       assignmentId = Value(assignmentId),
       updatedAt = Value(updatedAt);
  static Insertable<AssignmentProgressRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? assignmentId,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<int>? revision,
    Expression<String>? syncStatus,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (assignmentId != null) 'assignment_id': assignmentId,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (revision != null) 'revision': revision,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAssignmentProgressCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? assignmentId,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<int>? revision,
    Value<String>? syncStatus,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalAssignmentProgressCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      assignmentId: assignmentId ?? this.assignmentId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      revision: revision ?? this.revision,
      syncStatus: syncStatus ?? this.syncStatus,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (assignmentId.present) {
      map['assignment_id'] = Variable<String>(assignmentId.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAssignmentProgressCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('assignmentId: $assignmentId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('revision: $revision, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingOperationsTable extends PendingOperations
    with TableInfo<$PendingOperationsTable, PendingOperationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseRevisionMeta = const VerificationMeta(
    'baseRevision',
  );
  @override
  late final GeneratedColumn<int> baseRevision = GeneratedColumn<int>(
    'base_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dependsOnMeta = const VerificationMeta(
    'dependsOn',
  );
  @override
  late final GeneratedColumn<String> dependsOn = GeneratedColumn<String>(
    'depends_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    accountId,
    entity,
    entityId,
    type,
    payloadJson,
    fingerprint,
    baseRevision,
    retryCount,
    status,
    lastError,
    dependsOn,
    createdAt,
    updatedAt,
    nextAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingOperationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('base_revision')) {
      context.handle(
        _baseRevisionMeta,
        baseRevision.isAcceptableOrUnknown(
          data['base_revision']!,
          _baseRevisionMeta,
        ),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('depends_on')) {
      context.handle(
        _dependsOnMeta,
        dependsOn.isAcceptableOrUnknown(data['depends_on']!, _dependsOnMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  PendingOperationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingOperationRow(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      baseRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_revision'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      dependsOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}depends_on'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
    );
  }

  @override
  $PendingOperationsTable createAlias(String alias) {
    return $PendingOperationsTable(attachedDatabase, alias);
  }
}

class PendingOperationRow extends DataClass
    implements Insertable<PendingOperationRow> {
  final String operationId;
  final String accountId;
  final String entity;
  final String entityId;
  final String type;
  final String payloadJson;
  final String fingerprint;
  final int baseRevision;
  final int retryCount;
  final String status;
  final String? lastError;
  final String? dependsOn;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? nextAttemptAt;
  const PendingOperationRow({
    required this.operationId,
    required this.accountId,
    required this.entity,
    required this.entityId,
    required this.type,
    required this.payloadJson,
    required this.fingerprint,
    required this.baseRevision,
    required this.retryCount,
    required this.status,
    this.lastError,
    this.dependsOn,
    required this.createdAt,
    required this.updatedAt,
    this.nextAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['account_id'] = Variable<String>(accountId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['type'] = Variable<String>(type);
    map['payload_json'] = Variable<String>(payloadJson);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['base_revision'] = Variable<int>(baseRevision);
    map['retry_count'] = Variable<int>(retryCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || dependsOn != null) {
      map['depends_on'] = Variable<String>(dependsOn);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    return map;
  }

  PendingOperationsCompanion toCompanion(bool nullToAbsent) {
    return PendingOperationsCompanion(
      operationId: Value(operationId),
      accountId: Value(accountId),
      entity: Value(entity),
      entityId: Value(entityId),
      type: Value(type),
      payloadJson: Value(payloadJson),
      fingerprint: Value(fingerprint),
      baseRevision: Value(baseRevision),
      retryCount: Value(retryCount),
      status: Value(status),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      dependsOn: dependsOn == null && nullToAbsent
          ? const Value.absent()
          : Value(dependsOn),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
    );
  }

  factory PendingOperationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingOperationRow(
      operationId: serializer.fromJson<String>(json['operationId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      type: serializer.fromJson<String>(json['type']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      baseRevision: serializer.fromJson<int>(json['baseRevision']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      dependsOn: serializer.fromJson<String?>(json['dependsOn']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'accountId': serializer.toJson<String>(accountId),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'type': serializer.toJson<String>(type),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'baseRevision': serializer.toJson<int>(baseRevision),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
      'lastError': serializer.toJson<String?>(lastError),
      'dependsOn': serializer.toJson<String?>(dependsOn),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
    };
  }

  PendingOperationRow copyWith({
    String? operationId,
    String? accountId,
    String? entity,
    String? entityId,
    String? type,
    String? payloadJson,
    String? fingerprint,
    int? baseRevision,
    int? retryCount,
    String? status,
    Value<String?> lastError = const Value.absent(),
    Value<String?> dependsOn = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
  }) => PendingOperationRow(
    operationId: operationId ?? this.operationId,
    accountId: accountId ?? this.accountId,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    type: type ?? this.type,
    payloadJson: payloadJson ?? this.payloadJson,
    fingerprint: fingerprint ?? this.fingerprint,
    baseRevision: baseRevision ?? this.baseRevision,
    retryCount: retryCount ?? this.retryCount,
    status: status ?? this.status,
    lastError: lastError.present ? lastError.value : this.lastError,
    dependsOn: dependsOn.present ? dependsOn.value : this.dependsOn,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
  );
  PendingOperationRow copyWithCompanion(PendingOperationsCompanion data) {
    return PendingOperationRow(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      type: data.type.present ? data.type.value : this.type,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      baseRevision: data.baseRevision.present
          ? data.baseRevision.value
          : this.baseRevision,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      dependsOn: data.dependsOn.present ? data.dependsOn.value : this.dependsOn,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingOperationRow(')
          ..write('operationId: $operationId, ')
          ..write('accountId: $accountId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('type: $type, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('baseRevision: $baseRevision, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('dependsOn: $dependsOn, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('nextAttemptAt: $nextAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    accountId,
    entity,
    entityId,
    type,
    payloadJson,
    fingerprint,
    baseRevision,
    retryCount,
    status,
    lastError,
    dependsOn,
    createdAt,
    updatedAt,
    nextAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOperationRow &&
          other.operationId == this.operationId &&
          other.accountId == this.accountId &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.type == this.type &&
          other.payloadJson == this.payloadJson &&
          other.fingerprint == this.fingerprint &&
          other.baseRevision == this.baseRevision &&
          other.retryCount == this.retryCount &&
          other.status == this.status &&
          other.lastError == this.lastError &&
          other.dependsOn == this.dependsOn &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.nextAttemptAt == this.nextAttemptAt);
}

class PendingOperationsCompanion extends UpdateCompanion<PendingOperationRow> {
  final Value<String> operationId;
  final Value<String> accountId;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> type;
  final Value<String> payloadJson;
  final Value<String> fingerprint;
  final Value<int> baseRevision;
  final Value<int> retryCount;
  final Value<String> status;
  final Value<String?> lastError;
  final Value<String?> dependsOn;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> nextAttemptAt;
  final Value<int> rowid;
  const PendingOperationsCompanion({
    this.operationId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.type = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.baseRevision = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.dependsOn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingOperationsCompanion.insert({
    required String operationId,
    required String accountId,
    required String entity,
    required String entityId,
    required String type,
    required String payloadJson,
    required String fingerprint,
    this.baseRevision = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.dependsOn = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.nextAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       accountId = Value(accountId),
       entity = Value(entity),
       entityId = Value(entityId),
       type = Value(type),
       payloadJson = Value(payloadJson),
       fingerprint = Value(fingerprint),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PendingOperationRow> custom({
    Expression<String>? operationId,
    Expression<String>? accountId,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? type,
    Expression<String>? payloadJson,
    Expression<String>? fingerprint,
    Expression<int>? baseRevision,
    Expression<int>? retryCount,
    Expression<String>? status,
    Expression<String>? lastError,
    Expression<String>? dependsOn,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? nextAttemptAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (accountId != null) 'account_id': accountId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (type != null) 'type': type,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (baseRevision != null) 'base_revision': baseRevision,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
      if (dependsOn != null) 'depends_on': dependsOn,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingOperationsCompanion copyWith({
    Value<String>? operationId,
    Value<String>? accountId,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? type,
    Value<String>? payloadJson,
    Value<String>? fingerprint,
    Value<int>? baseRevision,
    Value<int>? retryCount,
    Value<String>? status,
    Value<String?>? lastError,
    Value<String?>? dependsOn,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? nextAttemptAt,
    Value<int>? rowid,
  }) {
    return PendingOperationsCompanion(
      operationId: operationId ?? this.operationId,
      accountId: accountId ?? this.accountId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      type: type ?? this.type,
      payloadJson: payloadJson ?? this.payloadJson,
      fingerprint: fingerprint ?? this.fingerprint,
      baseRevision: baseRevision ?? this.baseRevision,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      dependsOn: dependsOn ?? this.dependsOn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (baseRevision.present) {
      map['base_revision'] = Variable<int>(baseRevision.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (dependsOn.present) {
      map['depends_on'] = Variable<String>(dependsOn.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingOperationsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('accountId: $accountId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('type: $type, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('baseRevision: $baseRevision, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('dependsOn: $dependsOn, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPullAtMeta = const VerificationMeta(
    'lastPullAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPullAt = GeneratedColumn<DateTime>(
    'last_pull_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPushAtMeta = const VerificationMeta(
    'lastPushAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPushAt = GeneratedColumn<DateTime>(
    'last_push_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    accountId,
    cursor,
    lastPullAt,
    lastPushAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    }
    if (data.containsKey('last_pull_at')) {
      context.handle(
        _lastPullAtMeta,
        lastPullAt.isAcceptableOrUnknown(
          data['last_pull_at']!,
          _lastPullAtMeta,
        ),
      );
    }
    if (data.containsKey('last_push_at')) {
      context.handle(
        _lastPushAtMeta,
        lastPushAt.isAcceptableOrUnknown(
          data['last_push_at']!,
          _lastPushAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId};
  @override
  SyncMetadataRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataRow(
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cursor'],
      ),
      lastPullAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_pull_at'],
      ),
      lastPushAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_push_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataRow extends DataClass implements Insertable<SyncMetadataRow> {
  final String accountId;
  final String? cursor;
  final DateTime? lastPullAt;
  final DateTime? lastPushAt;
  final String? lastError;
  const SyncMetadataRow({
    required this.accountId,
    this.cursor,
    this.lastPullAt,
    this.lastPushAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || cursor != null) {
      map['cursor'] = Variable<String>(cursor);
    }
    if (!nullToAbsent || lastPullAt != null) {
      map['last_pull_at'] = Variable<DateTime>(lastPullAt);
    }
    if (!nullToAbsent || lastPushAt != null) {
      map['last_push_at'] = Variable<DateTime>(lastPushAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      accountId: Value(accountId),
      cursor: cursor == null && nullToAbsent
          ? const Value.absent()
          : Value(cursor),
      lastPullAt: lastPullAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPullAt),
      lastPushAt: lastPushAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPushAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SyncMetadataRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataRow(
      accountId: serializer.fromJson<String>(json['accountId']),
      cursor: serializer.fromJson<String?>(json['cursor']),
      lastPullAt: serializer.fromJson<DateTime?>(json['lastPullAt']),
      lastPushAt: serializer.fromJson<DateTime?>(json['lastPushAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String>(accountId),
      'cursor': serializer.toJson<String?>(cursor),
      'lastPullAt': serializer.toJson<DateTime?>(lastPullAt),
      'lastPushAt': serializer.toJson<DateTime?>(lastPushAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SyncMetadataRow copyWith({
    String? accountId,
    Value<String?> cursor = const Value.absent(),
    Value<DateTime?> lastPullAt = const Value.absent(),
    Value<DateTime?> lastPushAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
  }) => SyncMetadataRow(
    accountId: accountId ?? this.accountId,
    cursor: cursor.present ? cursor.value : this.cursor,
    lastPullAt: lastPullAt.present ? lastPullAt.value : this.lastPullAt,
    lastPushAt: lastPushAt.present ? lastPushAt.value : this.lastPushAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  SyncMetadataRow copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataRow(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
      lastPullAt: data.lastPullAt.present
          ? data.lastPullAt.value
          : this.lastPullAt,
      lastPushAt: data.lastPushAt.present
          ? data.lastPushAt.value
          : this.lastPushAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataRow(')
          ..write('accountId: $accountId, ')
          ..write('cursor: $cursor, ')
          ..write('lastPullAt: $lastPullAt, ')
          ..write('lastPushAt: $lastPushAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(accountId, cursor, lastPullAt, lastPushAt, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataRow &&
          other.accountId == this.accountId &&
          other.cursor == this.cursor &&
          other.lastPullAt == this.lastPullAt &&
          other.lastPushAt == this.lastPushAt &&
          other.lastError == this.lastError);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataRow> {
  final Value<String> accountId;
  final Value<String?> cursor;
  final Value<DateTime?> lastPullAt;
  final Value<DateTime?> lastPushAt;
  final Value<String?> lastError;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.accountId = const Value.absent(),
    this.cursor = const Value.absent(),
    this.lastPullAt = const Value.absent(),
    this.lastPushAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String accountId,
    this.cursor = const Value.absent(),
    this.lastPullAt = const Value.absent(),
    this.lastPushAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId);
  static Insertable<SyncMetadataRow> custom({
    Expression<String>? accountId,
    Expression<String>? cursor,
    Expression<DateTime>? lastPullAt,
    Expression<DateTime>? lastPushAt,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (cursor != null) 'cursor': cursor,
      if (lastPullAt != null) 'last_pull_at': lastPullAt,
      if (lastPushAt != null) 'last_push_at': lastPushAt,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? accountId,
    Value<String?>? cursor,
    Value<DateTime?>? lastPullAt,
    Value<DateTime?>? lastPushAt,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      accountId: accountId ?? this.accountId,
      cursor: cursor ?? this.cursor,
      lastPullAt: lastPullAt ?? this.lastPullAt,
      lastPushAt: lastPushAt ?? this.lastPushAt,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<String>(cursor.value);
    }
    if (lastPullAt.present) {
      map['last_pull_at'] = Variable<DateTime>(lastPullAt.value);
    }
    if (lastPushAt.present) {
      map['last_push_at'] = Variable<DateTime>(lastPushAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('accountId: $accountId, ')
          ..write('cursor: $cursor, ')
          ..write('lastPullAt: $lastPullAt, ')
          ..write('lastPushAt: $lastPushAt, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictsTable extends SyncConflicts
    with TableInfo<$SyncConflictsTable, SyncConflictRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localJsonMeta = const VerificationMeta(
    'localJson',
  );
  @override
  late final GeneratedColumn<String> localJson = GeneratedColumn<String>(
    'local_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cloudJsonMeta = const VerificationMeta(
    'cloudJson',
  );
  @override
  late final GeneratedColumn<String> cloudJson = GeneratedColumn<String>(
    'cloud_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resolutionMeta = const VerificationMeta(
    'resolution',
  );
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
    'resolution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    entity,
    entityId,
    localJson,
    cloudJson,
    createdAt,
    resolvedAt,
    resolution,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncConflictRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('local_json')) {
      context.handle(
        _localJsonMeta,
        localJson.isAcceptableOrUnknown(data['local_json']!, _localJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_localJsonMeta);
    }
    if (data.containsKey('cloud_json')) {
      context.handle(
        _cloudJsonMeta,
        cloudJson.isAcceptableOrUnknown(data['cloud_json']!, _cloudJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_cloudJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    if (data.containsKey('resolution')) {
      context.handle(
        _resolutionMeta,
        resolution.isAcceptableOrUnknown(data['resolution']!, _resolutionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncConflictRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflictRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      localJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_json'],
      )!,
      cloudJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cloud_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
      resolution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolution'],
      ),
    );
  }

  @override
  $SyncConflictsTable createAlias(String alias) {
    return $SyncConflictsTable(attachedDatabase, alias);
  }
}

class SyncConflictRow extends DataClass implements Insertable<SyncConflictRow> {
  final String id;
  final String accountId;
  final String entity;
  final String entityId;
  final String localJson;
  final String cloudJson;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolution;
  const SyncConflictRow({
    required this.id,
    required this.accountId,
    required this.entity,
    required this.entityId,
    required this.localJson,
    required this.cloudJson,
    required this.createdAt,
    this.resolvedAt,
    this.resolution,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['local_json'] = Variable<String>(localJson);
    map['cloud_json'] = Variable<String>(cloudJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    if (!nullToAbsent || resolution != null) {
      map['resolution'] = Variable<String>(resolution);
    }
    return map;
  }

  SyncConflictsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      entity: Value(entity),
      entityId: Value(entityId),
      localJson: Value(localJson),
      cloudJson: Value(cloudJson),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      resolution: resolution == null && nullToAbsent
          ? const Value.absent()
          : Value(resolution),
    );
  }

  factory SyncConflictRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflictRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      localJson: serializer.fromJson<String>(json['localJson']),
      cloudJson: serializer.fromJson<String>(json['cloudJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
      resolution: serializer.fromJson<String?>(json['resolution']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'localJson': serializer.toJson<String>(localJson),
      'cloudJson': serializer.toJson<String>(cloudJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
      'resolution': serializer.toJson<String?>(resolution),
    };
  }

  SyncConflictRow copyWith({
    String? id,
    String? accountId,
    String? entity,
    String? entityId,
    String? localJson,
    String? cloudJson,
    DateTime? createdAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
    Value<String?> resolution = const Value.absent(),
  }) => SyncConflictRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    localJson: localJson ?? this.localJson,
    cloudJson: cloudJson ?? this.cloudJson,
    createdAt: createdAt ?? this.createdAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
    resolution: resolution.present ? resolution.value : this.resolution,
  );
  SyncConflictRow copyWithCompanion(SyncConflictsCompanion data) {
    return SyncConflictRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      localJson: data.localJson.present ? data.localJson.value : this.localJson,
      cloudJson: data.cloudJson.present ? data.cloudJson.value : this.cloudJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
      resolution: data.resolution.present
          ? data.resolution.value
          : this.resolution,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('localJson: $localJson, ')
          ..write('cloudJson: $cloudJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('resolution: $resolution')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    entity,
    entityId,
    localJson,
    cloudJson,
    createdAt,
    resolvedAt,
    resolution,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflictRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.localJson == this.localJson &&
          other.cloudJson == this.cloudJson &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt &&
          other.resolution == this.resolution);
}

class SyncConflictsCompanion extends UpdateCompanion<SyncConflictRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> localJson;
  final Value<String> cloudJson;
  final Value<DateTime> createdAt;
  final Value<DateTime?> resolvedAt;
  final Value<String?> resolution;
  final Value<int> rowid;
  const SyncConflictsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.localJson = const Value.absent(),
    this.cloudJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.resolution = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncConflictsCompanion.insert({
    required String id,
    required String accountId,
    required String entity,
    required String entityId,
    required String localJson,
    required String cloudJson,
    required DateTime createdAt,
    this.resolvedAt = const Value.absent(),
    this.resolution = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       entity = Value(entity),
       entityId = Value(entityId),
       localJson = Value(localJson),
       cloudJson = Value(cloudJson),
       createdAt = Value(createdAt);
  static Insertable<SyncConflictRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? localJson,
    Expression<String>? cloudJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? resolvedAt,
    Expression<String>? resolution,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (localJson != null) 'local_json': localJson,
      if (cloudJson != null) 'cloud_json': cloudJson,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (resolution != null) 'resolution': resolution,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncConflictsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? localJson,
    Value<String>? cloudJson,
    Value<DateTime>? createdAt,
    Value<DateTime?>? resolvedAt,
    Value<String?>? resolution,
    Value<int>? rowid,
  }) {
    return SyncConflictsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      localJson: localJson ?? this.localJson,
      cloudJson: cloudJson ?? this.cloudJson,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolution: resolution ?? this.resolution,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (localJson.present) {
      map['local_json'] = Variable<String>(localJson.value);
    }
    if (cloudJson.present) {
      map['cloud_json'] = Variable<String>(cloudJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('localJson: $localJson, ')
          ..write('cloudJson: $cloudJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('resolution: $resolution, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalReminderStateTable extends LocalReminderState
    with TableInfo<$LocalReminderStateTable, ReminderStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalReminderStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('scheduled'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    entityType,
    entityId,
    scheduledAt,
    status,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_reminder_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalReminderStateTable createAlias(String alias) {
    return $LocalReminderStateTable(attachedDatabase, alias);
  }
}

class ReminderStateRow extends DataClass
    implements Insertable<ReminderStateRow> {
  final String id;
  final String accountId;
  final String entityType;
  final String entityId;
  final DateTime? scheduledAt;
  final String status;
  final DateTime updatedAt;
  const ReminderStateRow({
    required this.id,
    required this.accountId,
    required this.entityType,
    required this.entityId,
    this.scheduledAt,
    required this.status,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || scheduledAt != null) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    }
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalReminderStateCompanion toCompanion(bool nullToAbsent) {
    return LocalReminderStateCompanion(
      id: Value(id),
      accountId: Value(accountId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      scheduledAt: scheduledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledAt),
      status: Value(status),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderStateRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      scheduledAt: serializer.fromJson<DateTime?>(json['scheduledAt']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'scheduledAt': serializer.toJson<DateTime?>(scheduledAt),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReminderStateRow copyWith({
    String? id,
    String? accountId,
    String? entityType,
    String? entityId,
    Value<DateTime?> scheduledAt = const Value.absent(),
    String? status,
    DateTime? updatedAt,
  }) => ReminderStateRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    scheduledAt: scheduledAt.present ? scheduledAt.value : this.scheduledAt,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderStateRow copyWithCompanion(LocalReminderStateCompanion data) {
    return ReminderStateRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderStateRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    entityType,
    entityId,
    scheduledAt,
    status,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderStateRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.scheduledAt == this.scheduledAt &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt);
}

class LocalReminderStateCompanion extends UpdateCompanion<ReminderStateRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<DateTime?> scheduledAt;
  final Value<String> status;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalReminderStateCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalReminderStateCompanion.insert({
    required String id,
    required String accountId,
    required String entityType,
    required String entityId,
    this.scheduledAt = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       updatedAt = Value(updatedAt);
  static Insertable<ReminderStateRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<DateTime>? scheduledAt,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalReminderStateCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<DateTime?>? scheduledAt,
    Value<String>? status,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalReminderStateCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalReminderStateCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $LocalSubjectsTable localSubjects = $LocalSubjectsTable(this);
  late final $LocalTasksTable localTasks = $LocalTasksTable(this);
  late final $LocalTimetableEntriesTable localTimetableEntries =
      $LocalTimetableEntriesTable(this);
  late final $LocalAcademicEventsTable localAcademicEvents =
      $LocalAcademicEventsTable(this);
  late final $CachedClassroomsTable cachedClassrooms = $CachedClassroomsTable(
    this,
  );
  late final $CachedClassroomMembersTable cachedClassroomMembers =
      $CachedClassroomMembersTable(this);
  late final $CachedMembershipEventsTable cachedMembershipEvents =
      $CachedMembershipEventsTable(this);
  late final $CachedAssignmentsTable cachedAssignments =
      $CachedAssignmentsTable(this);
  late final $LocalAssignmentProgressTable localAssignmentProgress =
      $LocalAssignmentProgressTable(this);
  late final $PendingOperationsTable pendingOperations =
      $PendingOperationsTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final $SyncConflictsTable syncConflicts = $SyncConflictsTable(this);
  late final $LocalReminderStateTable localReminderState =
      $LocalReminderStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    appSettings,
    localSubjects,
    localTasks,
    localTimetableEntries,
    localAcademicEvents,
    cachedClassrooms,
    cachedClassroomMembers,
    cachedMembershipEvents,
    cachedAssignments,
    localAssignmentProgress,
    pendingOperations,
    syncMetadata,
    syncConflicts,
    localReminderState,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String email,
  required String fullName,
  required String role,
  required String passwordHash,
  required String passwordSalt,
  required String academicTimezone,
  Value<String> timeFormat,
  Value<bool> emailVerified,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> email,
  Value<String> fullName,
  Value<String> role,
  Value<String> passwordHash,
  Value<String> passwordSalt,
  Value<String> academicTimezone,
  Value<String> timeFormat,
  Value<bool> emailVerified,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AccountsTableFilterComposer
    extends Composer<_$LocalDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get academicTimezone => $composableBuilder(
    column: $table.academicTimezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeFormat => $composableBuilder(
    column: $table.timeFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$LocalDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get academicTimezone => $composableBuilder(
    column: $table.academicTimezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeFormat => $composableBuilder(
    column: $table.timeFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get academicTimezone => $composableBuilder(
    column: $table.academicTimezone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeFormat => $composableBuilder(
    column: $table.timeFormat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $AccountsTable,
          AccountRow,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (
            AccountRow,
            BaseReferences<_$LocalDatabase, $AccountsTable, AccountRow>,
          ),
          AccountRow,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$LocalDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> passwordSalt = const Value.absent(),
                Value<String> academicTimezone = const Value.absent(),
                Value<String> timeFormat = const Value.absent(),
                Value<bool> emailVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                email: email,
                fullName: fullName,
                role: role,
                passwordHash: passwordHash,
                passwordSalt: passwordSalt,
                academicTimezone: academicTimezone,
                timeFormat: timeFormat,
                emailVerified: emailVerified,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String fullName,
                required String role,
                required String passwordHash,
                required String passwordSalt,
                required String academicTimezone,
                Value<String> timeFormat = const Value.absent(),
                Value<bool> emailVerified = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                email: email,
                fullName: fullName,
                role: role,
                passwordHash: passwordHash,
                passwordSalt: passwordSalt,
                academicTimezone: academicTimezone,
                timeFormat: timeFormat,
                emailVerified: emailVerified,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, AccountRow>(table),
                  BaseReferences<_$LocalDatabase, $AccountsTable, AccountRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $AccountsTable,
      AccountRow,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (AccountRow, BaseReferences<_$LocalDatabase, $AccountsTable, AccountRow>),
      AccountRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$LocalDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$LocalDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $AppSettingsTable,
          SettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$LocalDatabase, $AppSettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$LocalDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, SettingRow>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $AppSettingsTable,
                    SettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $AppSettingsTable,
      SettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingRow,
        BaseReferences<_$LocalDatabase, $AppSettingsTable, SettingRow>,
      ),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$LocalSubjectsTableCreateCompanionBuilder =
    LocalSubjectsCompanion Function({
      required String id,
      required String accountId,
      required String name,
      required String code,
      Value<int> colorValue,
      Value<String?> teacherName,
      Value<String?> room,
      Value<int> revision,
      Value<String> syncStatus,
      Value<DateTime?> deletedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalSubjectsTableUpdateCompanionBuilder =
    LocalSubjectsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> name,
      Value<String> code,
      Value<int> colorValue,
      Value<String?> teacherName,
      Value<String?> room,
      Value<int> revision,
      Value<String> syncStatus,
      Value<DateTime?> deletedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalSubjectsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalSubjectsTable> {
  $$LocalSubjectsTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSubjectsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalSubjectsTable> {
  $$LocalSubjectsTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSubjectsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalSubjectsTable> {
  $$LocalSubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalSubjectsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalSubjectsTable,
          SubjectRow,
          $$LocalSubjectsTableFilterComposer,
          $$LocalSubjectsTableOrderingComposer,
          $$LocalSubjectsTableAnnotationComposer,
          $$LocalSubjectsTableCreateCompanionBuilder,
          $$LocalSubjectsTableUpdateCompanionBuilder,
          (
            SubjectRow,
            BaseReferences<_$LocalDatabase, $LocalSubjectsTable, SubjectRow>,
          ),
          SubjectRow,
          PrefetchHooks Function()
        > {
  $$LocalSubjectsTableTableManager(
    _$LocalDatabase db,
    $LocalSubjectsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<String?> teacherName = const Value.absent(),
                Value<String?> room = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSubjectsCompanion(
                id: id,
                accountId: accountId,
                name: name,
                code: code,
                colorValue: colorValue,
                teacherName: teacherName,
                room: room,
                revision: revision,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String name,
                required String code,
                Value<int> colorValue = const Value.absent(),
                Value<String?> teacherName = const Value.absent(),
                Value<String?> room = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalSubjectsCompanion.insert(
                id: id,
                accountId: accountId,
                name: name,
                code: code,
                colorValue: colorValue,
                teacherName: teacherName,
                room: room,
                revision: revision,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSubjectsTable, SubjectRow>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $LocalSubjectsTable,
                    SubjectRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalSubjectsTable,
      SubjectRow,
      $$LocalSubjectsTableFilterComposer,
      $$LocalSubjectsTableOrderingComposer,
      $$LocalSubjectsTableAnnotationComposer,
      $$LocalSubjectsTableCreateCompanionBuilder,
      $$LocalSubjectsTableUpdateCompanionBuilder,
      (
        SubjectRow,
        BaseReferences<_$LocalDatabase, $LocalSubjectsTable, SubjectRow>,
      ),
      SubjectRow,
      PrefetchHooks Function()
    >;
typedef $$LocalTasksTableCreateCompanionBuilder = LocalTasksCompanion Function({
  required String id,
  required String accountId,
  required String title,
  Value<String?> description,
  Value<String?> subjectId,
  Value<String?> dueDate,
  Value<String?> dueTime,
  Value<bool> hasExplicitTime,
  Value<String> priority,
  Value<String> status,
  Value<DateTime?> completedAt,
  Value<int?> reminderOffsetMinutes,
  Value<int> revision,
  Value<String> syncStatus,
  Value<DateTime?> deletedAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$LocalTasksTableUpdateCompanionBuilder = LocalTasksCompanion Function({
  Value<String> id,
  Value<String> accountId,
  Value<String> title,
  Value<String?> description,
  Value<String?> subjectId,
  Value<String?> dueDate,
  Value<String?> dueTime,
  Value<bool> hasExplicitTime,
  Value<String> priority,
  Value<String> status,
  Value<DateTime?> completedAt,
  Value<int?> reminderOffsetMinutes,
  Value<int> revision,
  Value<String> syncStatus,
  Value<DateTime?> deletedAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LocalTasksTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalTasksTable> {
  $$LocalTasksTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasExplicitTime => $composableBuilder(
    column: $table.hasExplicitTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTasksTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalTasksTable> {
  $$LocalTasksTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasExplicitTime => $composableBuilder(
    column: $table.hasExplicitTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTasksTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalTasksTable> {
  $$LocalTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumn<bool> get hasExplicitTime => $composableBuilder(
    column: $table.hasExplicitTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalTasksTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalTasksTable,
          TaskRow,
          $$LocalTasksTableFilterComposer,
          $$LocalTasksTableOrderingComposer,
          $$LocalTasksTableAnnotationComposer,
          $$LocalTasksTableCreateCompanionBuilder,
          $$LocalTasksTableUpdateCompanionBuilder,
          (TaskRow, BaseReferences<_$LocalDatabase, $LocalTasksTable, TaskRow>),
          TaskRow,
          PrefetchHooks Function()
        > {
  $$LocalTasksTableTableManager(_$LocalDatabase db, $LocalTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> subjectId = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<bool> hasExplicitTime = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> reminderOffsetMinutes = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTasksCompanion(
                id: id,
                accountId: accountId,
                title: title,
                description: description,
                subjectId: subjectId,
                dueDate: dueDate,
                dueTime: dueTime,
                hasExplicitTime: hasExplicitTime,
                priority: priority,
                status: status,
                completedAt: completedAt,
                reminderOffsetMinutes: reminderOffsetMinutes,
                revision: revision,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> subjectId = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<bool> hasExplicitTime = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> reminderOffsetMinutes = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalTasksCompanion.insert(
                id: id,
                accountId: accountId,
                title: title,
                description: description,
                subjectId: subjectId,
                dueDate: dueDate,
                dueTime: dueTime,
                hasExplicitTime: hasExplicitTime,
                priority: priority,
                status: status,
                completedAt: completedAt,
                reminderOffsetMinutes: reminderOffsetMinutes,
                revision: revision,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalTasksTable, TaskRow>(table),
                  BaseReferences<_$LocalDatabase, $LocalTasksTable, TaskRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalTasksTable,
      TaskRow,
      $$LocalTasksTableFilterComposer,
      $$LocalTasksTableOrderingComposer,
      $$LocalTasksTableAnnotationComposer,
      $$LocalTasksTableCreateCompanionBuilder,
      $$LocalTasksTableUpdateCompanionBuilder,
      (TaskRow, BaseReferences<_$LocalDatabase, $LocalTasksTable, TaskRow>),
      TaskRow,
      PrefetchHooks Function()
    >;
typedef $$LocalTimetableEntriesTableCreateCompanionBuilder =
    LocalTimetableEntriesCompanion Function({
      required String id,
      required String accountId,
      required String subjectId,
      required int weekday,
      required int startMinutes,
      required int endMinutes,
      Value<String?> room,
      Value<int> revision,
      Value<String> syncStatus,
      Value<DateTime?> deletedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalTimetableEntriesTableUpdateCompanionBuilder =
    LocalTimetableEntriesCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> subjectId,
      Value<int> weekday,
      Value<int> startMinutes,
      Value<int> endMinutes,
      Value<String?> room,
      Value<int> revision,
      Value<String> syncStatus,
      Value<DateTime?> deletedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalTimetableEntriesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalTimetableEntriesTable> {
  $$LocalTimetableEntriesTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTimetableEntriesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalTimetableEntriesTable> {
  $$LocalTimetableEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTimetableEntriesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalTimetableEntriesTable> {
  $$LocalTimetableEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalTimetableEntriesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalTimetableEntriesTable,
          TimetableRow,
          $$LocalTimetableEntriesTableFilterComposer,
          $$LocalTimetableEntriesTableOrderingComposer,
          $$LocalTimetableEntriesTableAnnotationComposer,
          $$LocalTimetableEntriesTableCreateCompanionBuilder,
          $$LocalTimetableEntriesTableUpdateCompanionBuilder,
          (
            TimetableRow,
            BaseReferences<
              _$LocalDatabase,
              $LocalTimetableEntriesTable,
              TimetableRow
            >,
          ),
          TimetableRow,
          PrefetchHooks Function()
        > {
  $$LocalTimetableEntriesTableTableManager(
    _$LocalDatabase db,
    $LocalTimetableEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTimetableEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalTimetableEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalTimetableEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<String?> room = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTimetableEntriesCompanion(
                id: id,
                accountId: accountId,
                subjectId: subjectId,
                weekday: weekday,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                room: room,
                revision: revision,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String subjectId,
                required int weekday,
                required int startMinutes,
                required int endMinutes,
                Value<String?> room = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalTimetableEntriesCompanion.insert(
                id: id,
                accountId: accountId,
                subjectId: subjectId,
                weekday: weekday,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                room: room,
                revision: revision,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalTimetableEntriesTable, TimetableRow>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $LocalTimetableEntriesTable,
                    TimetableRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTimetableEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalTimetableEntriesTable,
      TimetableRow,
      $$LocalTimetableEntriesTableFilterComposer,
      $$LocalTimetableEntriesTableOrderingComposer,
      $$LocalTimetableEntriesTableAnnotationComposer,
      $$LocalTimetableEntriesTableCreateCompanionBuilder,
      $$LocalTimetableEntriesTableUpdateCompanionBuilder,
      (
        TimetableRow,
        BaseReferences<
          _$LocalDatabase,
          $LocalTimetableEntriesTable,
          TimetableRow
        >,
      ),
      TimetableRow,
      PrefetchHooks Function()
    >;
typedef $$LocalAcademicEventsTableCreateCompanionBuilder =
    LocalAcademicEventsCompanion Function({
      required String id,
      required String accountId,
      required String title,
      Value<String> type,
      required String eventDate,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<String?> description,
      Value<String?> location,
      Value<int?> reminderOffsetMinutes,
      Value<int> revision,
      Value<String> syncStatus,
      Value<DateTime?> deletedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalAcademicEventsTableUpdateCompanionBuilder =
    LocalAcademicEventsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> title,
      Value<String> type,
      Value<String> eventDate,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<String?> description,
      Value<String?> location,
      Value<int?> reminderOffsetMinutes,
      Value<int> revision,
      Value<String> syncStatus,
      Value<DateTime?> deletedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalAcademicEventsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalAcademicEventsTable> {
  $$LocalAcademicEventsTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAcademicEventsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalAcademicEventsTable> {
  $$LocalAcademicEventsTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAcademicEventsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalAcademicEventsTable> {
  $$LocalAcademicEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalAcademicEventsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalAcademicEventsTable,
          AcademicEventRow,
          $$LocalAcademicEventsTableFilterComposer,
          $$LocalAcademicEventsTableOrderingComposer,
          $$LocalAcademicEventsTableAnnotationComposer,
          $$LocalAcademicEventsTableCreateCompanionBuilder,
          $$LocalAcademicEventsTableUpdateCompanionBuilder,
          (
            AcademicEventRow,
            BaseReferences<
              _$LocalDatabase,
              $LocalAcademicEventsTable,
              AcademicEventRow
            >,
          ),
          AcademicEventRow,
          PrefetchHooks Function()
        > {
  $$LocalAcademicEventsTableTableManager(
    _$LocalDatabase db,
    $LocalAcademicEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAcademicEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAcademicEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalAcademicEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> eventDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int?> reminderOffsetMinutes = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAcademicEventsCompanion(
                id: id,
                accountId: accountId,
                title: title,
                type: type,
                eventDate: eventDate,
                startTime: startTime,
                endTime: endTime,
                description: description,
                location: location,
                reminderOffsetMinutes: reminderOffsetMinutes,
                revision: revision,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String title,
                Value<String> type = const Value.absent(),
                required String eventDate,
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int?> reminderOffsetMinutes = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalAcademicEventsCompanion.insert(
                id: id,
                accountId: accountId,
                title: title,
                type: type,
                eventDate: eventDate,
                startTime: startTime,
                endTime: endTime,
                description: description,
                location: location,
                reminderOffsetMinutes: reminderOffsetMinutes,
                revision: revision,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalAcademicEventsTable, AcademicEventRow>(
                    table,
                  ),
                  BaseReferences<
                    _$LocalDatabase,
                    $LocalAcademicEventsTable,
                    AcademicEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAcademicEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalAcademicEventsTable,
      AcademicEventRow,
      $$LocalAcademicEventsTableFilterComposer,
      $$LocalAcademicEventsTableOrderingComposer,
      $$LocalAcademicEventsTableAnnotationComposer,
      $$LocalAcademicEventsTableCreateCompanionBuilder,
      $$LocalAcademicEventsTableUpdateCompanionBuilder,
      (
        AcademicEventRow,
        BaseReferences<
          _$LocalDatabase,
          $LocalAcademicEventsTable,
          AcademicEventRow
        >,
      ),
      AcademicEventRow,
      PrefetchHooks Function()
    >;
typedef $$CachedClassroomsTableCreateCompanionBuilder =
    CachedClassroomsCompanion Function({
      required String id,
      required String accountId,
      required String teacherId,
      Value<String?> teacherName,
      required String name,
      required String subjectName,
      Value<String?> description,
      Value<String?> joinCode,
      required String timezone,
      Value<bool> archived,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedClassroomsTableUpdateCompanionBuilder =
    CachedClassroomsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> teacherId,
      Value<String?> teacherName,
      Value<String> name,
      Value<String> subjectName,
      Value<String?> description,
      Value<String?> joinCode,
      Value<String> timezone,
      Value<bool> archived,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedClassroomsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedClassroomsTable> {
  $$CachedClassroomsTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teacherId => $composableBuilder(
    column: $table.teacherId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get joinCode => $composableBuilder(
    column: $table.joinCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedClassroomsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedClassroomsTable> {
  $$CachedClassroomsTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teacherId => $composableBuilder(
    column: $table.teacherId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get joinCode => $composableBuilder(
    column: $table.joinCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedClassroomsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedClassroomsTable> {
  $$CachedClassroomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get teacherId =>
      $composableBuilder(column: $table.teacherId, builder: (column) => column);

  GeneratedColumn<String> get teacherName => $composableBuilder(
    column: $table.teacherName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get subjectName => $composableBuilder(
    column: $table.subjectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get joinCode =>
      $composableBuilder(column: $table.joinCode, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedClassroomsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedClassroomsTable,
          CachedClassroomRow,
          $$CachedClassroomsTableFilterComposer,
          $$CachedClassroomsTableOrderingComposer,
          $$CachedClassroomsTableAnnotationComposer,
          $$CachedClassroomsTableCreateCompanionBuilder,
          $$CachedClassroomsTableUpdateCompanionBuilder,
          (
            CachedClassroomRow,
            BaseReferences<
              _$LocalDatabase,
              $CachedClassroomsTable,
              CachedClassroomRow
            >,
          ),
          CachedClassroomRow,
          PrefetchHooks Function()
        > {
  $$CachedClassroomsTableTableManager(
    _$LocalDatabase db,
    $CachedClassroomsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedClassroomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedClassroomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedClassroomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> teacherId = const Value.absent(),
                Value<String?> teacherName = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> subjectName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> joinCode = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedClassroomsCompanion(
                id: id,
                accountId: accountId,
                teacherId: teacherId,
                teacherName: teacherName,
                name: name,
                subjectName: subjectName,
                description: description,
                joinCode: joinCode,
                timezone: timezone,
                archived: archived,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String teacherId,
                Value<String?> teacherName = const Value.absent(),
                required String name,
                required String subjectName,
                Value<String?> description = const Value.absent(),
                Value<String?> joinCode = const Value.absent(),
                required String timezone,
                Value<bool> archived = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedClassroomsCompanion.insert(
                id: id,
                accountId: accountId,
                teacherId: teacherId,
                teacherName: teacherName,
                name: name,
                subjectName: subjectName,
                description: description,
                joinCode: joinCode,
                timezone: timezone,
                archived: archived,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedClassroomsTable, CachedClassroomRow>(
                    table,
                  ),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedClassroomsTable,
                    CachedClassroomRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedClassroomsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedClassroomsTable,
      CachedClassroomRow,
      $$CachedClassroomsTableFilterComposer,
      $$CachedClassroomsTableOrderingComposer,
      $$CachedClassroomsTableAnnotationComposer,
      $$CachedClassroomsTableCreateCompanionBuilder,
      $$CachedClassroomsTableUpdateCompanionBuilder,
      (
        CachedClassroomRow,
        BaseReferences<
          _$LocalDatabase,
          $CachedClassroomsTable,
          CachedClassroomRow
        >,
      ),
      CachedClassroomRow,
      PrefetchHooks Function()
    >;
typedef $$CachedClassroomMembersTableCreateCompanionBuilder =
    CachedClassroomMembersCompanion Function({
      required String id,
      required String accountId,
      required String classroomId,
      required String studentId,
      Value<String?> studentName,
      Value<String?> studentEmail,
      required String status,
      Value<bool> rejoinBlocked,
      Value<DateTime?> joinedAt,
      Value<DateTime?> endedAt,
      Value<int> rowid,
    });
typedef $$CachedClassroomMembersTableUpdateCompanionBuilder =
    CachedClassroomMembersCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> classroomId,
      Value<String> studentId,
      Value<String?> studentName,
      Value<String?> studentEmail,
      Value<String> status,
      Value<bool> rejoinBlocked,
      Value<DateTime?> joinedAt,
      Value<DateTime?> endedAt,
      Value<int> rowid,
    });

class $$CachedClassroomMembersTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedClassroomMembersTable> {
  $$CachedClassroomMembersTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classroomId => $composableBuilder(
    column: $table.classroomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentEmail => $composableBuilder(
    column: $table.studentEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rejoinBlocked => $composableBuilder(
    column: $table.rejoinBlocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedClassroomMembersTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedClassroomMembersTable> {
  $$CachedClassroomMembersTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classroomId => $composableBuilder(
    column: $table.classroomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentEmail => $composableBuilder(
    column: $table.studentEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rejoinBlocked => $composableBuilder(
    column: $table.rejoinBlocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedClassroomMembersTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedClassroomMembersTable> {
  $$CachedClassroomMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get classroomId => $composableBuilder(
    column: $table.classroomId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get studentEmail => $composableBuilder(
    column: $table.studentEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get rejoinBlocked => $composableBuilder(
    column: $table.rejoinBlocked,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);
}

class $$CachedClassroomMembersTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedClassroomMembersTable,
          CachedMemberRow,
          $$CachedClassroomMembersTableFilterComposer,
          $$CachedClassroomMembersTableOrderingComposer,
          $$CachedClassroomMembersTableAnnotationComposer,
          $$CachedClassroomMembersTableCreateCompanionBuilder,
          $$CachedClassroomMembersTableUpdateCompanionBuilder,
          (
            CachedMemberRow,
            BaseReferences<
              _$LocalDatabase,
              $CachedClassroomMembersTable,
              CachedMemberRow
            >,
          ),
          CachedMemberRow,
          PrefetchHooks Function()
        > {
  $$CachedClassroomMembersTableTableManager(
    _$LocalDatabase db,
    $CachedClassroomMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedClassroomMembersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedClassroomMembersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedClassroomMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> classroomId = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String?> studentName = const Value.absent(),
                Value<String?> studentEmail = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> rejoinBlocked = const Value.absent(),
                Value<DateTime?> joinedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedClassroomMembersCompanion(
                id: id,
                accountId: accountId,
                classroomId: classroomId,
                studentId: studentId,
                studentName: studentName,
                studentEmail: studentEmail,
                status: status,
                rejoinBlocked: rejoinBlocked,
                joinedAt: joinedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String classroomId,
                required String studentId,
                Value<String?> studentName = const Value.absent(),
                Value<String?> studentEmail = const Value.absent(),
                required String status,
                Value<bool> rejoinBlocked = const Value.absent(),
                Value<DateTime?> joinedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedClassroomMembersCompanion.insert(
                id: id,
                accountId: accountId,
                classroomId: classroomId,
                studentId: studentId,
                studentName: studentName,
                studentEmail: studentEmail,
                status: status,
                rejoinBlocked: rejoinBlocked,
                joinedAt: joinedAt,
                endedAt: endedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedClassroomMembersTable, CachedMemberRow>(
                    table,
                  ),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedClassroomMembersTable,
                    CachedMemberRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedClassroomMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedClassroomMembersTable,
      CachedMemberRow,
      $$CachedClassroomMembersTableFilterComposer,
      $$CachedClassroomMembersTableOrderingComposer,
      $$CachedClassroomMembersTableAnnotationComposer,
      $$CachedClassroomMembersTableCreateCompanionBuilder,
      $$CachedClassroomMembersTableUpdateCompanionBuilder,
      (
        CachedMemberRow,
        BaseReferences<
          _$LocalDatabase,
          $CachedClassroomMembersTable,
          CachedMemberRow
        >,
      ),
      CachedMemberRow,
      PrefetchHooks Function()
    >;
typedef $$CachedMembershipEventsTableCreateCompanionBuilder =
    CachedMembershipEventsCompanion Function({
      required String id,
      required String accountId,
      required String classroomId,
      required String membershipId,
      Value<String?> studentName,
      required String performedBy,
      required String eventType,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CachedMembershipEventsTableUpdateCompanionBuilder =
    CachedMembershipEventsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> classroomId,
      Value<String> membershipId,
      Value<String?> studentName,
      Value<String> performedBy,
      Value<String> eventType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CachedMembershipEventsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedMembershipEventsTable> {
  $$CachedMembershipEventsTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classroomId => $composableBuilder(
    column: $table.classroomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get membershipId => $composableBuilder(
    column: $table.membershipId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get performedBy => $composableBuilder(
    column: $table.performedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedMembershipEventsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedMembershipEventsTable> {
  $$CachedMembershipEventsTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classroomId => $composableBuilder(
    column: $table.classroomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get membershipId => $composableBuilder(
    column: $table.membershipId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get performedBy => $composableBuilder(
    column: $table.performedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedMembershipEventsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedMembershipEventsTable> {
  $$CachedMembershipEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get classroomId => $composableBuilder(
    column: $table.classroomId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get membershipId => $composableBuilder(
    column: $table.membershipId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get studentName => $composableBuilder(
    column: $table.studentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get performedBy => $composableBuilder(
    column: $table.performedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CachedMembershipEventsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedMembershipEventsTable,
          MembershipEventRow,
          $$CachedMembershipEventsTableFilterComposer,
          $$CachedMembershipEventsTableOrderingComposer,
          $$CachedMembershipEventsTableAnnotationComposer,
          $$CachedMembershipEventsTableCreateCompanionBuilder,
          $$CachedMembershipEventsTableUpdateCompanionBuilder,
          (
            MembershipEventRow,
            BaseReferences<
              _$LocalDatabase,
              $CachedMembershipEventsTable,
              MembershipEventRow
            >,
          ),
          MembershipEventRow,
          PrefetchHooks Function()
        > {
  $$CachedMembershipEventsTableTableManager(
    _$LocalDatabase db,
    $CachedMembershipEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedMembershipEventsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedMembershipEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedMembershipEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> classroomId = const Value.absent(),
                Value<String> membershipId = const Value.absent(),
                Value<String?> studentName = const Value.absent(),
                Value<String> performedBy = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMembershipEventsCompanion(
                id: id,
                accountId: accountId,
                classroomId: classroomId,
                membershipId: membershipId,
                studentName: studentName,
                performedBy: performedBy,
                eventType: eventType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String classroomId,
                required String membershipId,
                Value<String?> studentName = const Value.absent(),
                required String performedBy,
                required String eventType,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedMembershipEventsCompanion.insert(
                id: id,
                accountId: accountId,
                classroomId: classroomId,
                membershipId: membershipId,
                studentName: studentName,
                performedBy: performedBy,
                eventType: eventType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedMembershipEventsTable, MembershipEventRow>(
                    table,
                  ),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedMembershipEventsTable,
                    MembershipEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedMembershipEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedMembershipEventsTable,
      MembershipEventRow,
      $$CachedMembershipEventsTableFilterComposer,
      $$CachedMembershipEventsTableOrderingComposer,
      $$CachedMembershipEventsTableAnnotationComposer,
      $$CachedMembershipEventsTableCreateCompanionBuilder,
      $$CachedMembershipEventsTableUpdateCompanionBuilder,
      (
        MembershipEventRow,
        BaseReferences<
          _$LocalDatabase,
          $CachedMembershipEventsTable,
          MembershipEventRow
        >,
      ),
      MembershipEventRow,
      PrefetchHooks Function()
    >;
typedef $$CachedAssignmentsTableCreateCompanionBuilder =
    CachedAssignmentsCompanion Function({
      required String id,
      required String accountId,
      required String classroomId,
      Value<String?> classroomName,
      required String title,
      Value<String?> description,
      required String dueDate,
      Value<String?> dueTime,
      Value<bool> hasExplicitTime,
      required String status,
      Value<DateTime?> publishedAt,
      Value<DateTime?> deletedAt,
      Value<int> revision,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedAssignmentsTableUpdateCompanionBuilder =
    CachedAssignmentsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> classroomId,
      Value<String?> classroomName,
      Value<String> title,
      Value<String?> description,
      Value<String> dueDate,
      Value<String?> dueTime,
      Value<bool> hasExplicitTime,
      Value<String> status,
      Value<DateTime?> publishedAt,
      Value<DateTime?> deletedAt,
      Value<int> revision,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedAssignmentsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedAssignmentsTable> {
  $$CachedAssignmentsTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classroomId => $composableBuilder(
    column: $table.classroomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classroomName => $composableBuilder(
    column: $table.classroomName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasExplicitTime => $composableBuilder(
    column: $table.hasExplicitTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedAssignmentsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedAssignmentsTable> {
  $$CachedAssignmentsTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classroomId => $composableBuilder(
    column: $table.classroomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classroomName => $composableBuilder(
    column: $table.classroomName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasExplicitTime => $composableBuilder(
    column: $table.hasExplicitTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedAssignmentsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedAssignmentsTable> {
  $$CachedAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get classroomId => $composableBuilder(
    column: $table.classroomId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classroomName => $composableBuilder(
    column: $table.classroomName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumn<bool> get hasExplicitTime => $composableBuilder(
    column: $table.hasExplicitTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedAssignmentsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CachedAssignmentsTable,
          CachedAssignmentRow,
          $$CachedAssignmentsTableFilterComposer,
          $$CachedAssignmentsTableOrderingComposer,
          $$CachedAssignmentsTableAnnotationComposer,
          $$CachedAssignmentsTableCreateCompanionBuilder,
          $$CachedAssignmentsTableUpdateCompanionBuilder,
          (
            CachedAssignmentRow,
            BaseReferences<
              _$LocalDatabase,
              $CachedAssignmentsTable,
              CachedAssignmentRow
            >,
          ),
          CachedAssignmentRow,
          PrefetchHooks Function()
        > {
  $$CachedAssignmentsTableTableManager(
    _$LocalDatabase db,
    $CachedAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedAssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> classroomId = const Value.absent(),
                Value<String?> classroomName = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<bool> hasExplicitTime = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAssignmentsCompanion(
                id: id,
                accountId: accountId,
                classroomId: classroomId,
                classroomName: classroomName,
                title: title,
                description: description,
                dueDate: dueDate,
                dueTime: dueTime,
                hasExplicitTime: hasExplicitTime,
                status: status,
                publishedAt: publishedAt,
                deletedAt: deletedAt,
                revision: revision,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String classroomId,
                Value<String?> classroomName = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required String dueDate,
                Value<String?> dueTime = const Value.absent(),
                Value<bool> hasExplicitTime = const Value.absent(),
                required String status,
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedAssignmentsCompanion.insert(
                id: id,
                accountId: accountId,
                classroomId: classroomId,
                classroomName: classroomName,
                title: title,
                description: description,
                dueDate: dueDate,
                dueTime: dueTime,
                hasExplicitTime: hasExplicitTime,
                status: status,
                publishedAt: publishedAt,
                deletedAt: deletedAt,
                revision: revision,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedAssignmentsTable, CachedAssignmentRow>(
                    table,
                  ),
                  BaseReferences<
                    _$LocalDatabase,
                    $CachedAssignmentsTable,
                    CachedAssignmentRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CachedAssignmentsTable,
      CachedAssignmentRow,
      $$CachedAssignmentsTableFilterComposer,
      $$CachedAssignmentsTableOrderingComposer,
      $$CachedAssignmentsTableAnnotationComposer,
      $$CachedAssignmentsTableCreateCompanionBuilder,
      $$CachedAssignmentsTableUpdateCompanionBuilder,
      (
        CachedAssignmentRow,
        BaseReferences<
          _$LocalDatabase,
          $CachedAssignmentsTable,
          CachedAssignmentRow
        >,
      ),
      CachedAssignmentRow,
      PrefetchHooks Function()
    >;
typedef $$LocalAssignmentProgressTableCreateCompanionBuilder =
    LocalAssignmentProgressCompanion Function({
      required String id,
      required String accountId,
      required String assignmentId,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<int> revision,
      Value<String> syncStatus,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalAssignmentProgressTableUpdateCompanionBuilder =
    LocalAssignmentProgressCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> assignmentId,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<int> revision,
      Value<String> syncStatus,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalAssignmentProgressTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalAssignmentProgressTable> {
  $$LocalAssignmentProgressTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAssignmentProgressTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalAssignmentProgressTable> {
  $$LocalAssignmentProgressTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAssignmentProgressTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalAssignmentProgressTable> {
  $$LocalAssignmentProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalAssignmentProgressTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalAssignmentProgressTable,
          AssignmentProgressRow,
          $$LocalAssignmentProgressTableFilterComposer,
          $$LocalAssignmentProgressTableOrderingComposer,
          $$LocalAssignmentProgressTableAnnotationComposer,
          $$LocalAssignmentProgressTableCreateCompanionBuilder,
          $$LocalAssignmentProgressTableUpdateCompanionBuilder,
          (
            AssignmentProgressRow,
            BaseReferences<
              _$LocalDatabase,
              $LocalAssignmentProgressTable,
              AssignmentProgressRow
            >,
          ),
          AssignmentProgressRow,
          PrefetchHooks Function()
        > {
  $$LocalAssignmentProgressTableTableManager(
    _$LocalDatabase db,
    $LocalAssignmentProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAssignmentProgressTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalAssignmentProgressTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalAssignmentProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> assignmentId = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAssignmentProgressCompanion(
                id: id,
                accountId: accountId,
                assignmentId: assignmentId,
                isCompleted: isCompleted,
                completedAt: completedAt,
                revision: revision,
                syncStatus: syncStatus,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String assignmentId,
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalAssignmentProgressCompanion.insert(
                id: id,
                accountId: accountId,
                assignmentId: assignmentId,
                isCompleted: isCompleted,
                completedAt: completedAt,
                revision: revision,
                syncStatus: syncStatus,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $LocalAssignmentProgressTable,
                    AssignmentProgressRow
                  >(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $LocalAssignmentProgressTable,
                    AssignmentProgressRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAssignmentProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalAssignmentProgressTable,
      AssignmentProgressRow,
      $$LocalAssignmentProgressTableFilterComposer,
      $$LocalAssignmentProgressTableOrderingComposer,
      $$LocalAssignmentProgressTableAnnotationComposer,
      $$LocalAssignmentProgressTableCreateCompanionBuilder,
      $$LocalAssignmentProgressTableUpdateCompanionBuilder,
      (
        AssignmentProgressRow,
        BaseReferences<
          _$LocalDatabase,
          $LocalAssignmentProgressTable,
          AssignmentProgressRow
        >,
      ),
      AssignmentProgressRow,
      PrefetchHooks Function()
    >;
typedef $$PendingOperationsTableCreateCompanionBuilder =
    PendingOperationsCompanion Function({
      required String operationId,
      required String accountId,
      required String entity,
      required String entityId,
      required String type,
      required String payloadJson,
      required String fingerprint,
      Value<int> baseRevision,
      Value<int> retryCount,
      Value<String> status,
      Value<String?> lastError,
      Value<String?> dependsOn,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> nextAttemptAt,
      Value<int> rowid,
    });
typedef $$PendingOperationsTableUpdateCompanionBuilder =
    PendingOperationsCompanion Function({
      Value<String> operationId,
      Value<String> accountId,
      Value<String> entity,
      Value<String> entityId,
      Value<String> type,
      Value<String> payloadJson,
      Value<String> fingerprint,
      Value<int> baseRevision,
      Value<int> retryCount,
      Value<String> status,
      Value<String?> lastError,
      Value<String?> dependsOn,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> nextAttemptAt,
      Value<int> rowid,
    });

class $$PendingOperationsTableFilterComposer
    extends Composer<_$LocalDatabase, $PendingOperationsTable> {
  $$PendingOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseRevision => $composableBuilder(
    column: $table.baseRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dependsOn => $composableBuilder(
    column: $table.dependsOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingOperationsTableOrderingComposer
    extends Composer<_$LocalDatabase, $PendingOperationsTable> {
  $$PendingOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseRevision => $composableBuilder(
    column: $table.baseRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dependsOn => $composableBuilder(
    column: $table.dependsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingOperationsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $PendingOperationsTable> {
  $$PendingOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseRevision => $composableBuilder(
    column: $table.baseRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get dependsOn =>
      $composableBuilder(column: $table.dependsOn, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );
}

class $$PendingOperationsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $PendingOperationsTable,
          PendingOperationRow,
          $$PendingOperationsTableFilterComposer,
          $$PendingOperationsTableOrderingComposer,
          $$PendingOperationsTableAnnotationComposer,
          $$PendingOperationsTableCreateCompanionBuilder,
          $$PendingOperationsTableUpdateCompanionBuilder,
          (
            PendingOperationRow,
            BaseReferences<
              _$LocalDatabase,
              $PendingOperationsTable,
              PendingOperationRow
            >,
          ),
          PendingOperationRow,
          PrefetchHooks Function()
        > {
  $$PendingOperationsTableTableManager(
    _$LocalDatabase db,
    $PendingOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<int> baseRevision = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> dependsOn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOperationsCompanion(
                operationId: operationId,
                accountId: accountId,
                entity: entity,
                entityId: entityId,
                type: type,
                payloadJson: payloadJson,
                fingerprint: fingerprint,
                baseRevision: baseRevision,
                retryCount: retryCount,
                status: status,
                lastError: lastError,
                dependsOn: dependsOn,
                createdAt: createdAt,
                updatedAt: updatedAt,
                nextAttemptAt: nextAttemptAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String accountId,
                required String entity,
                required String entityId,
                required String type,
                required String payloadJson,
                required String fingerprint,
                Value<int> baseRevision = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> dependsOn = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOperationsCompanion.insert(
                operationId: operationId,
                accountId: accountId,
                entity: entity,
                entityId: entityId,
                type: type,
                payloadJson: payloadJson,
                fingerprint: fingerprint,
                baseRevision: baseRevision,
                retryCount: retryCount,
                status: status,
                lastError: lastError,
                dependsOn: dependsOn,
                createdAt: createdAt,
                updatedAt: updatedAt,
                nextAttemptAt: nextAttemptAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PendingOperationsTable, PendingOperationRow>(
                    table,
                  ),
                  BaseReferences<
                    _$LocalDatabase,
                    $PendingOperationsTable,
                    PendingOperationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $PendingOperationsTable,
      PendingOperationRow,
      $$PendingOperationsTableFilterComposer,
      $$PendingOperationsTableOrderingComposer,
      $$PendingOperationsTableAnnotationComposer,
      $$PendingOperationsTableCreateCompanionBuilder,
      $$PendingOperationsTableUpdateCompanionBuilder,
      (
        PendingOperationRow,
        BaseReferences<
          _$LocalDatabase,
          $PendingOperationsTable,
          PendingOperationRow
        >,
      ),
      PendingOperationRow,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String accountId,
      Value<String?> cursor,
      Value<DateTime?> lastPullAt,
      Value<DateTime?> lastPushAt,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> accountId,
      Value<String?> cursor,
      Value<DateTime?> lastPullAt,
      Value<DateTime?> lastPushAt,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$LocalDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPullAt => $composableBuilder(
    column: $table.lastPullAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPushAt => $composableBuilder(
    column: $table.lastPushAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$LocalDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPullAt => $composableBuilder(
    column: $table.lastPullAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPushAt => $composableBuilder(
    column: $table.lastPushAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$LocalDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPullAt => $composableBuilder(
    column: $table.lastPullAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPushAt => $composableBuilder(
    column: $table.lastPushAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $SyncMetadataTable,
          SyncMetadataRow,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataRow,
            BaseReferences<
              _$LocalDatabase,
              $SyncMetadataTable,
              SyncMetadataRow
            >,
          ),
          SyncMetadataRow,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$LocalDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> accountId = const Value.absent(),
                Value<String?> cursor = const Value.absent(),
                Value<DateTime?> lastPullAt = const Value.absent(),
                Value<DateTime?> lastPushAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(
                accountId: accountId,
                cursor: cursor,
                lastPullAt: lastPullAt,
                lastPushAt: lastPushAt,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String accountId,
                Value<String?> cursor = const Value.absent(),
                Value<DateTime?> lastPullAt = const Value.absent(),
                Value<DateTime?> lastPushAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                accountId: accountId,
                cursor: cursor,
                lastPullAt: lastPullAt,
                lastPushAt: lastPushAt,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncMetadataTable, SyncMetadataRow>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $SyncMetadataTable,
                    SyncMetadataRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $SyncMetadataTable,
      SyncMetadataRow,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataRow,
        BaseReferences<_$LocalDatabase, $SyncMetadataTable, SyncMetadataRow>,
      ),
      SyncMetadataRow,
      PrefetchHooks Function()
    >;
typedef $$SyncConflictsTableCreateCompanionBuilder =
    SyncConflictsCompanion Function({
      required String id,
      required String accountId,
      required String entity,
      required String entityId,
      required String localJson,
      required String cloudJson,
      required DateTime createdAt,
      Value<DateTime?> resolvedAt,
      Value<String?> resolution,
      Value<int> rowid,
    });
typedef $$SyncConflictsTableUpdateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> entity,
      Value<String> entityId,
      Value<String> localJson,
      Value<String> cloudJson,
      Value<DateTime> createdAt,
      Value<DateTime?> resolvedAt,
      Value<String?> resolution,
      Value<int> rowid,
    });

class $$SyncConflictsTableFilterComposer
    extends Composer<_$LocalDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localJson => $composableBuilder(
    column: $table.localJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cloudJson => $composableBuilder(
    column: $table.cloudJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncConflictsTableOrderingComposer
    extends Composer<_$LocalDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localJson => $composableBuilder(
    column: $table.localJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cloudJson => $composableBuilder(
    column: $table.cloudJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncConflictsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get localJson =>
      $composableBuilder(column: $table.localJson, builder: (column) => column);

  GeneratedColumn<String> get cloudJson =>
      $composableBuilder(column: $table.cloudJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => column,
  );
}

class $$SyncConflictsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $SyncConflictsTable,
          SyncConflictRow,
          $$SyncConflictsTableFilterComposer,
          $$SyncConflictsTableOrderingComposer,
          $$SyncConflictsTableAnnotationComposer,
          $$SyncConflictsTableCreateCompanionBuilder,
          $$SyncConflictsTableUpdateCompanionBuilder,
          (
            SyncConflictRow,
            BaseReferences<
              _$LocalDatabase,
              $SyncConflictsTable,
              SyncConflictRow
            >,
          ),
          SyncConflictRow,
          PrefetchHooks Function()
        > {
  $$SyncConflictsTableTableManager(
    _$LocalDatabase db,
    $SyncConflictsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> localJson = const Value.absent(),
                Value<String> cloudJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<String?> resolution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion(
                id: id,
                accountId: accountId,
                entity: entity,
                entityId: entityId,
                localJson: localJson,
                cloudJson: cloudJson,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                resolution: resolution,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String entity,
                required String entityId,
                required String localJson,
                required String cloudJson,
                required DateTime createdAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<String?> resolution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion.insert(
                id: id,
                accountId: accountId,
                entity: entity,
                entityId: entityId,
                localJson: localJson,
                cloudJson: cloudJson,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                resolution: resolution,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncConflictsTable, SyncConflictRow>(table),
                  BaseReferences<
                    _$LocalDatabase,
                    $SyncConflictsTable,
                    SyncConflictRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncConflictsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $SyncConflictsTable,
      SyncConflictRow,
      $$SyncConflictsTableFilterComposer,
      $$SyncConflictsTableOrderingComposer,
      $$SyncConflictsTableAnnotationComposer,
      $$SyncConflictsTableCreateCompanionBuilder,
      $$SyncConflictsTableUpdateCompanionBuilder,
      (
        SyncConflictRow,
        BaseReferences<_$LocalDatabase, $SyncConflictsTable, SyncConflictRow>,
      ),
      SyncConflictRow,
      PrefetchHooks Function()
    >;
typedef $$LocalReminderStateTableCreateCompanionBuilder =
    LocalReminderStateCompanion Function({
      required String id,
      required String accountId,
      required String entityType,
      required String entityId,
      Value<DateTime?> scheduledAt,
      Value<String> status,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalReminderStateTableUpdateCompanionBuilder =
    LocalReminderStateCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> entityType,
      Value<String> entityId,
      Value<DateTime?> scheduledAt,
      Value<String> status,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalReminderStateTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalReminderStateTable> {
  $$LocalReminderStateTableFilterComposer({
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

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalReminderStateTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalReminderStateTable> {
  $$LocalReminderStateTableOrderingComposer({
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

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalReminderStateTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalReminderStateTable> {
  $$LocalReminderStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalReminderStateTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalReminderStateTable,
          ReminderStateRow,
          $$LocalReminderStateTableFilterComposer,
          $$LocalReminderStateTableOrderingComposer,
          $$LocalReminderStateTableAnnotationComposer,
          $$LocalReminderStateTableCreateCompanionBuilder,
          $$LocalReminderStateTableUpdateCompanionBuilder,
          (
            ReminderStateRow,
            BaseReferences<
              _$LocalDatabase,
              $LocalReminderStateTable,
              ReminderStateRow
            >,
          ),
          ReminderStateRow,
          PrefetchHooks Function()
        > {
  $$LocalReminderStateTableTableManager(
    _$LocalDatabase db,
    $LocalReminderStateTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalReminderStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalReminderStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalReminderStateTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<DateTime?> scheduledAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalReminderStateCompanion(
                id: id,
                accountId: accountId,
                entityType: entityType,
                entityId: entityId,
                scheduledAt: scheduledAt,
                status: status,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String entityType,
                required String entityId,
                Value<DateTime?> scheduledAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalReminderStateCompanion.insert(
                id: id,
                accountId: accountId,
                entityType: entityType,
                entityId: entityId,
                scheduledAt: scheduledAt,
                status: status,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalReminderStateTable, ReminderStateRow>(
                    table,
                  ),
                  BaseReferences<
                    _$LocalDatabase,
                    $LocalReminderStateTable,
                    ReminderStateRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalReminderStateTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalReminderStateTable,
      ReminderStateRow,
      $$LocalReminderStateTableFilterComposer,
      $$LocalReminderStateTableOrderingComposer,
      $$LocalReminderStateTableAnnotationComposer,
      $$LocalReminderStateTableCreateCompanionBuilder,
      $$LocalReminderStateTableUpdateCompanionBuilder,
      (
        ReminderStateRow,
        BaseReferences<
          _$LocalDatabase,
          $LocalReminderStateTable,
          ReminderStateRow
        >,
      ),
      ReminderStateRow,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$LocalSubjectsTableTableManager get localSubjects =>
      $$LocalSubjectsTableTableManager(_db, _db.localSubjects);
  $$LocalTasksTableTableManager get localTasks =>
      $$LocalTasksTableTableManager(_db, _db.localTasks);
  $$LocalTimetableEntriesTableTableManager get localTimetableEntries =>
      $$LocalTimetableEntriesTableTableManager(_db, _db.localTimetableEntries);
  $$LocalAcademicEventsTableTableManager get localAcademicEvents =>
      $$LocalAcademicEventsTableTableManager(_db, _db.localAcademicEvents);
  $$CachedClassroomsTableTableManager get cachedClassrooms =>
      $$CachedClassroomsTableTableManager(_db, _db.cachedClassrooms);
  $$CachedClassroomMembersTableTableManager get cachedClassroomMembers =>
      $$CachedClassroomMembersTableTableManager(
        _db,
        _db.cachedClassroomMembers,
      );
  $$CachedMembershipEventsTableTableManager get cachedMembershipEvents =>
      $$CachedMembershipEventsTableTableManager(
        _db,
        _db.cachedMembershipEvents,
      );
  $$CachedAssignmentsTableTableManager get cachedAssignments =>
      $$CachedAssignmentsTableTableManager(_db, _db.cachedAssignments);
  $$LocalAssignmentProgressTableTableManager get localAssignmentProgress =>
      $$LocalAssignmentProgressTableTableManager(
        _db,
        _db.localAssignmentProgress,
      );
  $$PendingOperationsTableTableManager get pendingOperations =>
      $$PendingOperationsTableTableManager(_db, _db.pendingOperations);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
  $$SyncConflictsTableTableManager get syncConflicts =>
      $$SyncConflictsTableTableManager(_db, _db.syncConflicts);
  $$LocalReminderStateTableTableManager get localReminderState =>
      $$LocalReminderStateTableTableManager(_db, _db.localReminderState);
}
