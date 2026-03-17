// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarIconMeta =
      const VerificationMeta('avatarIcon');
  @override
  late final GeneratedColumn<String> avatarIcon = GeneratedColumn<String>(
      'avatar_icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        avatarIcon,
        isActive,
        pinHash,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_icon')) {
      context.handle(
          _avatarIconMeta,
          avatarIcon.isAcceptableOrUnknown(
              data['avatar_icon']!, _avatarIconMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatarIcon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_icon']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final String name;
  final String? avatarIcon;
  final bool isActive;
  final String? pinHash;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  const Profile(
      {required this.id,
      required this.name,
      this.avatarIcon,
      required this.isActive,
      this.pinHash,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatarIcon != null) {
      map['avatar_icon'] = Variable<String>(avatarIcon);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      avatarIcon: avatarIcon == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarIcon),
      isActive: Value(isActive),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarIcon: serializer.fromJson<String?>(json['avatarIcon']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatarIcon': serializer.toJson<String?>(avatarIcon),
      'isActive': serializer.toJson<bool>(isActive),
      'pinHash': serializer.toJson<String?>(pinHash),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Profile copyWith(
          {String? id,
          String? name,
          Value<String?> avatarIcon = const Value.absent(),
          bool? isActive,
          Value<String?> pinHash = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          String? syncStatus}) =>
      Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarIcon: avatarIcon.present ? avatarIcon.value : this.avatarIcon,
        isActive: isActive ?? this.isActive,
        pinHash: pinHash.present ? pinHash.value : this.pinHash,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarIcon:
          data.avatarIcon.present ? data.avatarIcon.value : this.avatarIcon,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarIcon: $avatarIcon, ')
          ..write('isActive: $isActive, ')
          ..write('pinHash: $pinHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, avatarIcon, isActive, pinHash,
      createdAt, updatedAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarIcon == this.avatarIcon &&
          other.isActive == this.isActive &&
          other.pinHash == this.pinHash &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> avatarIcon;
  final Value<bool> isActive;
  final Value<String?> pinHash;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarIcon = const Value.absent(),
    this.isActive = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String name,
    this.avatarIcon = const Value.absent(),
    this.isActive = const Value.absent(),
    this.pinHash = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatarIcon,
    Expression<bool>? isActive,
    Expression<String>? pinHash,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarIcon != null) 'avatar_icon': avatarIcon,
      if (isActive != null) 'is_active': isActive,
      if (pinHash != null) 'pin_hash': pinHash,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? avatarIcon,
      Value<bool>? isActive,
      Value<String?>? pinHash,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      isActive: isActive ?? this.isActive,
      pinHash: pinHash ?? this.pinHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarIcon.present) {
      map['avatar_icon'] = Variable<String>(avatarIcon.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarIcon: $avatarIcon, ')
          ..write('isActive: $isActive, ')
          ..write('pinHash: $pinHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('scheduled'));
  static const VerificationMeta _scheduledTimeMeta =
      const VerificationMeta('scheduledTime');
  @override
  late final GeneratedColumn<int> scheduledTime = GeneratedColumn<int>(
      'scheduled_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _actualTriggerTimeMeta =
      const VerificationMeta('actualTriggerTime');
  @override
  late final GeneratedColumn<int> actualTriggerTime = GeneratedColumn<int>(
      'actual_trigger_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _snoozeCountMeta =
      const VerificationMeta('snoozeCount');
  @override
  late final GeneratedColumn<int> snoozeCount = GeneratedColumn<int>(
      'snooze_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _escalationCountMeta =
      const VerificationMeta('escalationCount');
  @override
  late final GeneratedColumn<int> escalationCount = GeneratedColumn<int>(
      'escalation_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _confirmationModeMeta =
      const VerificationMeta('confirmationMode');
  @override
  late final GeneratedColumn<String> confirmationMode = GeneratedColumn<String>(
      'confirmation_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('swipeToConfirm'));
  static const VerificationMeta _linkedEntityIdMeta =
      const VerificationMeta('linkedEntityId');
  @override
  late final GeneratedColumn<String> linkedEntityId = GeneratedColumn<String>(
      'linked_entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _linkedEntityTypeMeta =
      const VerificationMeta('linkedEntityType');
  @override
  late final GeneratedColumn<String> linkedEntityType = GeneratedColumn<String>(
      'linked_entity_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _maxSnoozesMeta =
      const VerificationMeta('maxSnoozes');
  @override
  late final GeneratedColumn<int> maxSnoozes = GeneratedColumn<int>(
      'max_snoozes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _snoozeBaseDelayMinutesMeta =
      const VerificationMeta('snoozeBaseDelayMinutes');
  @override
  late final GeneratedColumn<int> snoozeBaseDelayMinutes = GeneratedColumn<int>(
      'snooze_base_delay_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _responseWindowSecondsMeta =
      const VerificationMeta('responseWindowSeconds');
  @override
  late final GeneratedColumn<int> responseWindowSeconds = GeneratedColumn<int>(
      'response_window_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(300));
  static const VerificationMeta _maxEscalationsMeta =
      const VerificationMeta('maxEscalations');
  @override
  late final GeneratedColumn<int> maxEscalations = GeneratedColumn<int>(
      'max_escalations', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _escalationIntervalSecondsMeta =
      const VerificationMeta('escalationIntervalSeconds');
  @override
  late final GeneratedColumn<int> escalationIntervalSeconds =
      GeneratedColumn<int>('escalation_interval_seconds', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(600));
  static const VerificationMeta _confirmationWindowSecondsMeta =
      const VerificationMeta('confirmationWindowSeconds');
  @override
  late final GeneratedColumn<int> confirmationWindowSeconds =
      GeneratedColumn<int>('confirmation_window_seconds', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(30));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cancellationReasonMeta =
      const VerificationMeta('cancellationReason');
  @override
  late final GeneratedColumn<String> cancellationReason =
      GeneratedColumn<String>('cancellation_reason', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  static const VerificationMeta _xpValueMeta =
      const VerificationMeta('xpValue');
  @override
  late final GeneratedColumn<int> xpValue = GeneratedColumn<int>(
      'xp_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        type,
        title,
        body,
        status,
        scheduledTime,
        actualTriggerTime,
        snoozeCount,
        escalationCount,
        confirmationMode,
        linkedEntityId,
        linkedEntityType,
        maxSnoozes,
        snoozeBaseDelayMinutes,
        responseWindowSeconds,
        maxEscalations,
        escalationIntervalSeconds,
        confirmationWindowSeconds,
        createdAt,
        updatedAt,
        completedAt,
        cancellationReason,
        syncStatus,
        xpValue
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
          _scheduledTimeMeta,
          scheduledTime.isAcceptableOrUnknown(
              data['scheduled_time']!, _scheduledTimeMeta));
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('actual_trigger_time')) {
      context.handle(
          _actualTriggerTimeMeta,
          actualTriggerTime.isAcceptableOrUnknown(
              data['actual_trigger_time']!, _actualTriggerTimeMeta));
    }
    if (data.containsKey('snooze_count')) {
      context.handle(
          _snoozeCountMeta,
          snoozeCount.isAcceptableOrUnknown(
              data['snooze_count']!, _snoozeCountMeta));
    }
    if (data.containsKey('escalation_count')) {
      context.handle(
          _escalationCountMeta,
          escalationCount.isAcceptableOrUnknown(
              data['escalation_count']!, _escalationCountMeta));
    }
    if (data.containsKey('confirmation_mode')) {
      context.handle(
          _confirmationModeMeta,
          confirmationMode.isAcceptableOrUnknown(
              data['confirmation_mode']!, _confirmationModeMeta));
    }
    if (data.containsKey('linked_entity_id')) {
      context.handle(
          _linkedEntityIdMeta,
          linkedEntityId.isAcceptableOrUnknown(
              data['linked_entity_id']!, _linkedEntityIdMeta));
    }
    if (data.containsKey('linked_entity_type')) {
      context.handle(
          _linkedEntityTypeMeta,
          linkedEntityType.isAcceptableOrUnknown(
              data['linked_entity_type']!, _linkedEntityTypeMeta));
    }
    if (data.containsKey('max_snoozes')) {
      context.handle(
          _maxSnoozesMeta,
          maxSnoozes.isAcceptableOrUnknown(
              data['max_snoozes']!, _maxSnoozesMeta));
    }
    if (data.containsKey('snooze_base_delay_minutes')) {
      context.handle(
          _snoozeBaseDelayMinutesMeta,
          snoozeBaseDelayMinutes.isAcceptableOrUnknown(
              data['snooze_base_delay_minutes']!, _snoozeBaseDelayMinutesMeta));
    }
    if (data.containsKey('response_window_seconds')) {
      context.handle(
          _responseWindowSecondsMeta,
          responseWindowSeconds.isAcceptableOrUnknown(
              data['response_window_seconds']!, _responseWindowSecondsMeta));
    }
    if (data.containsKey('max_escalations')) {
      context.handle(
          _maxEscalationsMeta,
          maxEscalations.isAcceptableOrUnknown(
              data['max_escalations']!, _maxEscalationsMeta));
    }
    if (data.containsKey('escalation_interval_seconds')) {
      context.handle(
          _escalationIntervalSecondsMeta,
          escalationIntervalSeconds.isAcceptableOrUnknown(
              data['escalation_interval_seconds']!,
              _escalationIntervalSecondsMeta));
    }
    if (data.containsKey('confirmation_window_seconds')) {
      context.handle(
          _confirmationWindowSecondsMeta,
          confirmationWindowSeconds.isAcceptableOrUnknown(
              data['confirmation_window_seconds']!,
              _confirmationWindowSecondsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('cancellation_reason')) {
      context.handle(
          _cancellationReasonMeta,
          cancellationReason.isAcceptableOrUnknown(
              data['cancellation_reason']!, _cancellationReasonMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('xp_value')) {
      context.handle(_xpValueMeta,
          xpValue.isAcceptableOrUnknown(data['xp_value']!, _xpValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      scheduledTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheduled_time'])!,
      actualTriggerTime: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}actual_trigger_time']),
      snoozeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}snooze_count'])!,
      escalationCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}escalation_count'])!,
      confirmationMode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}confirmation_mode'])!,
      linkedEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_entity_id']),
      linkedEntityType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_entity_type']),
      maxSnoozes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_snoozes'])!,
      snoozeBaseDelayMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}snooze_base_delay_minutes'])!,
      responseWindowSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}response_window_seconds'])!,
      maxEscalations: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_escalations'])!,
      escalationIntervalSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}escalation_interval_seconds'])!,
      confirmationWindowSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}confirmation_window_seconds'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_at']),
      cancellationReason: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cancellation_reason']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      xpValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_value'])!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String profileId;
  final String type;
  final String title;
  final String? body;
  final String status;
  final int scheduledTime;
  final int? actualTriggerTime;
  final int snoozeCount;
  final int escalationCount;
  final String confirmationMode;
  final String? linkedEntityId;
  final String? linkedEntityType;
  final int maxSnoozes;
  final int snoozeBaseDelayMinutes;
  final int responseWindowSeconds;
  final int maxEscalations;
  final int escalationIntervalSeconds;
  final int confirmationWindowSeconds;
  final int createdAt;
  final int updatedAt;
  final int? completedAt;
  final String? cancellationReason;
  final String syncStatus;
  final int xpValue;
  const Reminder(
      {required this.id,
      required this.profileId,
      required this.type,
      required this.title,
      this.body,
      required this.status,
      required this.scheduledTime,
      this.actualTriggerTime,
      required this.snoozeCount,
      required this.escalationCount,
      required this.confirmationMode,
      this.linkedEntityId,
      this.linkedEntityType,
      required this.maxSnoozes,
      required this.snoozeBaseDelayMinutes,
      required this.responseWindowSeconds,
      required this.maxEscalations,
      required this.escalationIntervalSeconds,
      required this.confirmationWindowSeconds,
      required this.createdAt,
      required this.updatedAt,
      this.completedAt,
      this.cancellationReason,
      required this.syncStatus,
      required this.xpValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['status'] = Variable<String>(status);
    map['scheduled_time'] = Variable<int>(scheduledTime);
    if (!nullToAbsent || actualTriggerTime != null) {
      map['actual_trigger_time'] = Variable<int>(actualTriggerTime);
    }
    map['snooze_count'] = Variable<int>(snoozeCount);
    map['escalation_count'] = Variable<int>(escalationCount);
    map['confirmation_mode'] = Variable<String>(confirmationMode);
    if (!nullToAbsent || linkedEntityId != null) {
      map['linked_entity_id'] = Variable<String>(linkedEntityId);
    }
    if (!nullToAbsent || linkedEntityType != null) {
      map['linked_entity_type'] = Variable<String>(linkedEntityType);
    }
    map['max_snoozes'] = Variable<int>(maxSnoozes);
    map['snooze_base_delay_minutes'] = Variable<int>(snoozeBaseDelayMinutes);
    map['response_window_seconds'] = Variable<int>(responseWindowSeconds);
    map['max_escalations'] = Variable<int>(maxEscalations);
    map['escalation_interval_seconds'] =
        Variable<int>(escalationIntervalSeconds);
    map['confirmation_window_seconds'] =
        Variable<int>(confirmationWindowSeconds);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    if (!nullToAbsent || cancellationReason != null) {
      map['cancellation_reason'] = Variable<String>(cancellationReason);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['xp_value'] = Variable<int>(xpValue);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      profileId: Value(profileId),
      type: Value(type),
      title: Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      status: Value(status),
      scheduledTime: Value(scheduledTime),
      actualTriggerTime: actualTriggerTime == null && nullToAbsent
          ? const Value.absent()
          : Value(actualTriggerTime),
      snoozeCount: Value(snoozeCount),
      escalationCount: Value(escalationCount),
      confirmationMode: Value(confirmationMode),
      linkedEntityId: linkedEntityId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedEntityId),
      linkedEntityType: linkedEntityType == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedEntityType),
      maxSnoozes: Value(maxSnoozes),
      snoozeBaseDelayMinutes: Value(snoozeBaseDelayMinutes),
      responseWindowSeconds: Value(responseWindowSeconds),
      maxEscalations: Value(maxEscalations),
      escalationIntervalSeconds: Value(escalationIntervalSeconds),
      confirmationWindowSeconds: Value(confirmationWindowSeconds),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      cancellationReason: cancellationReason == null && nullToAbsent
          ? const Value.absent()
          : Value(cancellationReason),
      syncStatus: Value(syncStatus),
      xpValue: Value(xpValue),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      status: serializer.fromJson<String>(json['status']),
      scheduledTime: serializer.fromJson<int>(json['scheduledTime']),
      actualTriggerTime: serializer.fromJson<int?>(json['actualTriggerTime']),
      snoozeCount: serializer.fromJson<int>(json['snoozeCount']),
      escalationCount: serializer.fromJson<int>(json['escalationCount']),
      confirmationMode: serializer.fromJson<String>(json['confirmationMode']),
      linkedEntityId: serializer.fromJson<String?>(json['linkedEntityId']),
      linkedEntityType: serializer.fromJson<String?>(json['linkedEntityType']),
      maxSnoozes: serializer.fromJson<int>(json['maxSnoozes']),
      snoozeBaseDelayMinutes:
          serializer.fromJson<int>(json['snoozeBaseDelayMinutes']),
      responseWindowSeconds:
          serializer.fromJson<int>(json['responseWindowSeconds']),
      maxEscalations: serializer.fromJson<int>(json['maxEscalations']),
      escalationIntervalSeconds:
          serializer.fromJson<int>(json['escalationIntervalSeconds']),
      confirmationWindowSeconds:
          serializer.fromJson<int>(json['confirmationWindowSeconds']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
      cancellationReason:
          serializer.fromJson<String?>(json['cancellationReason']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      xpValue: serializer.fromJson<int>(json['xpValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'status': serializer.toJson<String>(status),
      'scheduledTime': serializer.toJson<int>(scheduledTime),
      'actualTriggerTime': serializer.toJson<int?>(actualTriggerTime),
      'snoozeCount': serializer.toJson<int>(snoozeCount),
      'escalationCount': serializer.toJson<int>(escalationCount),
      'confirmationMode': serializer.toJson<String>(confirmationMode),
      'linkedEntityId': serializer.toJson<String?>(linkedEntityId),
      'linkedEntityType': serializer.toJson<String?>(linkedEntityType),
      'maxSnoozes': serializer.toJson<int>(maxSnoozes),
      'snoozeBaseDelayMinutes': serializer.toJson<int>(snoozeBaseDelayMinutes),
      'responseWindowSeconds': serializer.toJson<int>(responseWindowSeconds),
      'maxEscalations': serializer.toJson<int>(maxEscalations),
      'escalationIntervalSeconds':
          serializer.toJson<int>(escalationIntervalSeconds),
      'confirmationWindowSeconds':
          serializer.toJson<int>(confirmationWindowSeconds),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'completedAt': serializer.toJson<int?>(completedAt),
      'cancellationReason': serializer.toJson<String?>(cancellationReason),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'xpValue': serializer.toJson<int>(xpValue),
    };
  }

  Reminder copyWith(
          {String? id,
          String? profileId,
          String? type,
          String? title,
          Value<String?> body = const Value.absent(),
          String? status,
          int? scheduledTime,
          Value<int?> actualTriggerTime = const Value.absent(),
          int? snoozeCount,
          int? escalationCount,
          String? confirmationMode,
          Value<String?> linkedEntityId = const Value.absent(),
          Value<String?> linkedEntityType = const Value.absent(),
          int? maxSnoozes,
          int? snoozeBaseDelayMinutes,
          int? responseWindowSeconds,
          int? maxEscalations,
          int? escalationIntervalSeconds,
          int? confirmationWindowSeconds,
          int? createdAt,
          int? updatedAt,
          Value<int?> completedAt = const Value.absent(),
          Value<String?> cancellationReason = const Value.absent(),
          String? syncStatus,
          int? xpValue}) =>
      Reminder(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        type: type ?? this.type,
        title: title ?? this.title,
        body: body.present ? body.value : this.body,
        status: status ?? this.status,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        actualTriggerTime: actualTriggerTime.present
            ? actualTriggerTime.value
            : this.actualTriggerTime,
        snoozeCount: snoozeCount ?? this.snoozeCount,
        escalationCount: escalationCount ?? this.escalationCount,
        confirmationMode: confirmationMode ?? this.confirmationMode,
        linkedEntityId:
            linkedEntityId.present ? linkedEntityId.value : this.linkedEntityId,
        linkedEntityType: linkedEntityType.present
            ? linkedEntityType.value
            : this.linkedEntityType,
        maxSnoozes: maxSnoozes ?? this.maxSnoozes,
        snoozeBaseDelayMinutes:
            snoozeBaseDelayMinutes ?? this.snoozeBaseDelayMinutes,
        responseWindowSeconds:
            responseWindowSeconds ?? this.responseWindowSeconds,
        maxEscalations: maxEscalations ?? this.maxEscalations,
        escalationIntervalSeconds:
            escalationIntervalSeconds ?? this.escalationIntervalSeconds,
        confirmationWindowSeconds:
            confirmationWindowSeconds ?? this.confirmationWindowSeconds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        cancellationReason: cancellationReason.present
            ? cancellationReason.value
            : this.cancellationReason,
        syncStatus: syncStatus ?? this.syncStatus,
        xpValue: xpValue ?? this.xpValue,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      status: data.status.present ? data.status.value : this.status,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      actualTriggerTime: data.actualTriggerTime.present
          ? data.actualTriggerTime.value
          : this.actualTriggerTime,
      snoozeCount:
          data.snoozeCount.present ? data.snoozeCount.value : this.snoozeCount,
      escalationCount: data.escalationCount.present
          ? data.escalationCount.value
          : this.escalationCount,
      confirmationMode: data.confirmationMode.present
          ? data.confirmationMode.value
          : this.confirmationMode,
      linkedEntityId: data.linkedEntityId.present
          ? data.linkedEntityId.value
          : this.linkedEntityId,
      linkedEntityType: data.linkedEntityType.present
          ? data.linkedEntityType.value
          : this.linkedEntityType,
      maxSnoozes:
          data.maxSnoozes.present ? data.maxSnoozes.value : this.maxSnoozes,
      snoozeBaseDelayMinutes: data.snoozeBaseDelayMinutes.present
          ? data.snoozeBaseDelayMinutes.value
          : this.snoozeBaseDelayMinutes,
      responseWindowSeconds: data.responseWindowSeconds.present
          ? data.responseWindowSeconds.value
          : this.responseWindowSeconds,
      maxEscalations: data.maxEscalations.present
          ? data.maxEscalations.value
          : this.maxEscalations,
      escalationIntervalSeconds: data.escalationIntervalSeconds.present
          ? data.escalationIntervalSeconds.value
          : this.escalationIntervalSeconds,
      confirmationWindowSeconds: data.confirmationWindowSeconds.present
          ? data.confirmationWindowSeconds.value
          : this.confirmationWindowSeconds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      cancellationReason: data.cancellationReason.present
          ? data.cancellationReason.value
          : this.cancellationReason,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      xpValue: data.xpValue.present ? data.xpValue.value : this.xpValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('status: $status, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('actualTriggerTime: $actualTriggerTime, ')
          ..write('snoozeCount: $snoozeCount, ')
          ..write('escalationCount: $escalationCount, ')
          ..write('confirmationMode: $confirmationMode, ')
          ..write('linkedEntityId: $linkedEntityId, ')
          ..write('linkedEntityType: $linkedEntityType, ')
          ..write('maxSnoozes: $maxSnoozes, ')
          ..write('snoozeBaseDelayMinutes: $snoozeBaseDelayMinutes, ')
          ..write('responseWindowSeconds: $responseWindowSeconds, ')
          ..write('maxEscalations: $maxEscalations, ')
          ..write('escalationIntervalSeconds: $escalationIntervalSeconds, ')
          ..write('confirmationWindowSeconds: $confirmationWindowSeconds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('cancellationReason: $cancellationReason, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('xpValue: $xpValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        profileId,
        type,
        title,
        body,
        status,
        scheduledTime,
        actualTriggerTime,
        snoozeCount,
        escalationCount,
        confirmationMode,
        linkedEntityId,
        linkedEntityType,
        maxSnoozes,
        snoozeBaseDelayMinutes,
        responseWindowSeconds,
        maxEscalations,
        escalationIntervalSeconds,
        confirmationWindowSeconds,
        createdAt,
        updatedAt,
        completedAt,
        cancellationReason,
        syncStatus,
        xpValue
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.type == this.type &&
          other.title == this.title &&
          other.body == this.body &&
          other.status == this.status &&
          other.scheduledTime == this.scheduledTime &&
          other.actualTriggerTime == this.actualTriggerTime &&
          other.snoozeCount == this.snoozeCount &&
          other.escalationCount == this.escalationCount &&
          other.confirmationMode == this.confirmationMode &&
          other.linkedEntityId == this.linkedEntityId &&
          other.linkedEntityType == this.linkedEntityType &&
          other.maxSnoozes == this.maxSnoozes &&
          other.snoozeBaseDelayMinutes == this.snoozeBaseDelayMinutes &&
          other.responseWindowSeconds == this.responseWindowSeconds &&
          other.maxEscalations == this.maxEscalations &&
          other.escalationIntervalSeconds == this.escalationIntervalSeconds &&
          other.confirmationWindowSeconds == this.confirmationWindowSeconds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt &&
          other.cancellationReason == this.cancellationReason &&
          other.syncStatus == this.syncStatus &&
          other.xpValue == this.xpValue);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> body;
  final Value<String> status;
  final Value<int> scheduledTime;
  final Value<int?> actualTriggerTime;
  final Value<int> snoozeCount;
  final Value<int> escalationCount;
  final Value<String> confirmationMode;
  final Value<String?> linkedEntityId;
  final Value<String?> linkedEntityType;
  final Value<int> maxSnoozes;
  final Value<int> snoozeBaseDelayMinutes;
  final Value<int> responseWindowSeconds;
  final Value<int> maxEscalations;
  final Value<int> escalationIntervalSeconds;
  final Value<int> confirmationWindowSeconds;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> completedAt;
  final Value<String?> cancellationReason;
  final Value<String> syncStatus;
  final Value<int> xpValue;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.status = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.actualTriggerTime = const Value.absent(),
    this.snoozeCount = const Value.absent(),
    this.escalationCount = const Value.absent(),
    this.confirmationMode = const Value.absent(),
    this.linkedEntityId = const Value.absent(),
    this.linkedEntityType = const Value.absent(),
    this.maxSnoozes = const Value.absent(),
    this.snoozeBaseDelayMinutes = const Value.absent(),
    this.responseWindowSeconds = const Value.absent(),
    this.maxEscalations = const Value.absent(),
    this.escalationIntervalSeconds = const Value.absent(),
    this.confirmationWindowSeconds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.cancellationReason = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String type,
    required String title,
    this.body = const Value.absent(),
    this.status = const Value.absent(),
    required int scheduledTime,
    this.actualTriggerTime = const Value.absent(),
    this.snoozeCount = const Value.absent(),
    this.escalationCount = const Value.absent(),
    this.confirmationMode = const Value.absent(),
    this.linkedEntityId = const Value.absent(),
    this.linkedEntityType = const Value.absent(),
    this.maxSnoozes = const Value.absent(),
    this.snoozeBaseDelayMinutes = const Value.absent(),
    this.responseWindowSeconds = const Value.absent(),
    this.maxEscalations = const Value.absent(),
    this.escalationIntervalSeconds = const Value.absent(),
    this.confirmationWindowSeconds = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.completedAt = const Value.absent(),
    this.cancellationReason = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        title = Value(title),
        scheduledTime = Value(scheduledTime),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? status,
    Expression<int>? scheduledTime,
    Expression<int>? actualTriggerTime,
    Expression<int>? snoozeCount,
    Expression<int>? escalationCount,
    Expression<String>? confirmationMode,
    Expression<String>? linkedEntityId,
    Expression<String>? linkedEntityType,
    Expression<int>? maxSnoozes,
    Expression<int>? snoozeBaseDelayMinutes,
    Expression<int>? responseWindowSeconds,
    Expression<int>? maxEscalations,
    Expression<int>? escalationIntervalSeconds,
    Expression<int>? confirmationWindowSeconds,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? completedAt,
    Expression<String>? cancellationReason,
    Expression<String>? syncStatus,
    Expression<int>? xpValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (status != null) 'status': status,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (actualTriggerTime != null) 'actual_trigger_time': actualTriggerTime,
      if (snoozeCount != null) 'snooze_count': snoozeCount,
      if (escalationCount != null) 'escalation_count': escalationCount,
      if (confirmationMode != null) 'confirmation_mode': confirmationMode,
      if (linkedEntityId != null) 'linked_entity_id': linkedEntityId,
      if (linkedEntityType != null) 'linked_entity_type': linkedEntityType,
      if (maxSnoozes != null) 'max_snoozes': maxSnoozes,
      if (snoozeBaseDelayMinutes != null)
        'snooze_base_delay_minutes': snoozeBaseDelayMinutes,
      if (responseWindowSeconds != null)
        'response_window_seconds': responseWindowSeconds,
      if (maxEscalations != null) 'max_escalations': maxEscalations,
      if (escalationIntervalSeconds != null)
        'escalation_interval_seconds': escalationIntervalSeconds,
      if (confirmationWindowSeconds != null)
        'confirmation_window_seconds': confirmationWindowSeconds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (cancellationReason != null) 'cancellation_reason': cancellationReason,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (xpValue != null) 'xp_value': xpValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? type,
      Value<String>? title,
      Value<String?>? body,
      Value<String>? status,
      Value<int>? scheduledTime,
      Value<int?>? actualTriggerTime,
      Value<int>? snoozeCount,
      Value<int>? escalationCount,
      Value<String>? confirmationMode,
      Value<String?>? linkedEntityId,
      Value<String?>? linkedEntityType,
      Value<int>? maxSnoozes,
      Value<int>? snoozeBaseDelayMinutes,
      Value<int>? responseWindowSeconds,
      Value<int>? maxEscalations,
      Value<int>? escalationIntervalSeconds,
      Value<int>? confirmationWindowSeconds,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? completedAt,
      Value<String?>? cancellationReason,
      Value<String>? syncStatus,
      Value<int>? xpValue,
      Value<int>? rowid}) {
    return RemindersCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      status: status ?? this.status,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      actualTriggerTime: actualTriggerTime ?? this.actualTriggerTime,
      snoozeCount: snoozeCount ?? this.snoozeCount,
      escalationCount: escalationCount ?? this.escalationCount,
      confirmationMode: confirmationMode ?? this.confirmationMode,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
      linkedEntityType: linkedEntityType ?? this.linkedEntityType,
      maxSnoozes: maxSnoozes ?? this.maxSnoozes,
      snoozeBaseDelayMinutes:
          snoozeBaseDelayMinutes ?? this.snoozeBaseDelayMinutes,
      responseWindowSeconds:
          responseWindowSeconds ?? this.responseWindowSeconds,
      maxEscalations: maxEscalations ?? this.maxEscalations,
      escalationIntervalSeconds:
          escalationIntervalSeconds ?? this.escalationIntervalSeconds,
      confirmationWindowSeconds:
          confirmationWindowSeconds ?? this.confirmationWindowSeconds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      syncStatus: syncStatus ?? this.syncStatus,
      xpValue: xpValue ?? this.xpValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<int>(scheduledTime.value);
    }
    if (actualTriggerTime.present) {
      map['actual_trigger_time'] = Variable<int>(actualTriggerTime.value);
    }
    if (snoozeCount.present) {
      map['snooze_count'] = Variable<int>(snoozeCount.value);
    }
    if (escalationCount.present) {
      map['escalation_count'] = Variable<int>(escalationCount.value);
    }
    if (confirmationMode.present) {
      map['confirmation_mode'] = Variable<String>(confirmationMode.value);
    }
    if (linkedEntityId.present) {
      map['linked_entity_id'] = Variable<String>(linkedEntityId.value);
    }
    if (linkedEntityType.present) {
      map['linked_entity_type'] = Variable<String>(linkedEntityType.value);
    }
    if (maxSnoozes.present) {
      map['max_snoozes'] = Variable<int>(maxSnoozes.value);
    }
    if (snoozeBaseDelayMinutes.present) {
      map['snooze_base_delay_minutes'] =
          Variable<int>(snoozeBaseDelayMinutes.value);
    }
    if (responseWindowSeconds.present) {
      map['response_window_seconds'] =
          Variable<int>(responseWindowSeconds.value);
    }
    if (maxEscalations.present) {
      map['max_escalations'] = Variable<int>(maxEscalations.value);
    }
    if (escalationIntervalSeconds.present) {
      map['escalation_interval_seconds'] =
          Variable<int>(escalationIntervalSeconds.value);
    }
    if (confirmationWindowSeconds.present) {
      map['confirmation_window_seconds'] =
          Variable<int>(confirmationWindowSeconds.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (cancellationReason.present) {
      map['cancellation_reason'] = Variable<String>(cancellationReason.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (xpValue.present) {
      map['xp_value'] = Variable<int>(xpValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('status: $status, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('actualTriggerTime: $actualTriggerTime, ')
          ..write('snoozeCount: $snoozeCount, ')
          ..write('escalationCount: $escalationCount, ')
          ..write('confirmationMode: $confirmationMode, ')
          ..write('linkedEntityId: $linkedEntityId, ')
          ..write('linkedEntityType: $linkedEntityType, ')
          ..write('maxSnoozes: $maxSnoozes, ')
          ..write('snoozeBaseDelayMinutes: $snoozeBaseDelayMinutes, ')
          ..write('responseWindowSeconds: $responseWindowSeconds, ')
          ..write('maxEscalations: $maxEscalations, ')
          ..write('escalationIntervalSeconds: $escalationIntervalSeconds, ')
          ..write('confirmationWindowSeconds: $confirmationWindowSeconds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('cancellationReason: $cancellationReason, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('xpValue: $xpValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderLogsTable extends ReminderLogs
    with TableInfo<$ReminderLogsTable, ReminderLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _reminderIdMeta =
      const VerificationMeta('reminderId');
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
      'reminder_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES reminders (id)'));
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventTimestampMeta =
      const VerificationMeta('eventTimestamp');
  @override
  late final GeneratedColumn<int> eventTimestamp = GeneratedColumn<int>(
      'event_timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        reminderId,
        eventType,
        eventTimestamp,
        metadata,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ReminderLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
          _reminderIdMeta,
          reminderId.isAcceptableOrUnknown(
              data['reminder_id']!, _reminderIdMeta));
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('event_timestamp')) {
      context.handle(
          _eventTimestampMeta,
          eventTimestamp.isAcceptableOrUnknown(
              data['event_timestamp']!, _eventTimestampMeta));
    } else if (isInserting) {
      context.missing(_eventTimestampMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      reminderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_id'])!,
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      eventTimestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}event_timestamp'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $ReminderLogsTable createAlias(String alias) {
    return $ReminderLogsTable(attachedDatabase, alias);
  }
}

class ReminderLog extends DataClass implements Insertable<ReminderLog> {
  final String id;
  final String profileId;
  final String reminderId;
  final String eventType;
  final int eventTimestamp;
  final String? metadata;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  const ReminderLog(
      {required this.id,
      required this.profileId,
      required this.reminderId,
      required this.eventType,
      required this.eventTimestamp,
      this.metadata,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['reminder_id'] = Variable<String>(reminderId);
    map['event_type'] = Variable<String>(eventType);
    map['event_timestamp'] = Variable<int>(eventTimestamp);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ReminderLogsCompanion toCompanion(bool nullToAbsent) {
    return ReminderLogsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      reminderId: Value(reminderId),
      eventType: Value(eventType),
      eventTimestamp: Value(eventTimestamp),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory ReminderLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderLog(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      reminderId: serializer.fromJson<String>(json['reminderId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      eventTimestamp: serializer.fromJson<int>(json['eventTimestamp']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'reminderId': serializer.toJson<String>(reminderId),
      'eventType': serializer.toJson<String>(eventType),
      'eventTimestamp': serializer.toJson<int>(eventTimestamp),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  ReminderLog copyWith(
          {String? id,
          String? profileId,
          String? reminderId,
          String? eventType,
          int? eventTimestamp,
          Value<String?> metadata = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          String? syncStatus}) =>
      ReminderLog(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        reminderId: reminderId ?? this.reminderId,
        eventType: eventType ?? this.eventType,
        eventTimestamp: eventTimestamp ?? this.eventTimestamp,
        metadata: metadata.present ? metadata.value : this.metadata,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  ReminderLog copyWithCompanion(ReminderLogsCompanion data) {
    return ReminderLog(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      reminderId:
          data.reminderId.present ? data.reminderId.value : this.reminderId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      eventTimestamp: data.eventTimestamp.present
          ? data.eventTimestamp.value
          : this.eventTimestamp,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderLog(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('reminderId: $reminderId, ')
          ..write('eventType: $eventType, ')
          ..write('eventTimestamp: $eventTimestamp, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, reminderId, eventType,
      eventTimestamp, metadata, createdAt, updatedAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderLog &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.reminderId == this.reminderId &&
          other.eventType == this.eventType &&
          other.eventTimestamp == this.eventTimestamp &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class ReminderLogsCompanion extends UpdateCompanion<ReminderLog> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> reminderId;
  final Value<String> eventType;
  final Value<int> eventTimestamp;
  final Value<String?> metadata;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const ReminderLogsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.eventTimestamp = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderLogsCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String reminderId,
    required String eventType,
    required int eventTimestamp,
    this.metadata = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        reminderId = Value(reminderId),
        eventType = Value(eventType),
        eventTimestamp = Value(eventTimestamp),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ReminderLog> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? reminderId,
    Expression<String>? eventType,
    Expression<int>? eventTimestamp,
    Expression<String>? metadata,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (reminderId != null) 'reminder_id': reminderId,
      if (eventType != null) 'event_type': eventType,
      if (eventTimestamp != null) 'event_timestamp': eventTimestamp,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? reminderId,
      Value<String>? eventType,
      Value<int>? eventTimestamp,
      Value<String?>? metadata,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return ReminderLogsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      reminderId: reminderId ?? this.reminderId,
      eventType: eventType ?? this.eventType,
      eventTimestamp: eventTimestamp ?? this.eventTimestamp,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (eventTimestamp.present) {
      map['event_timestamp'] = Variable<int>(eventTimestamp.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderLogsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('reminderId: $reminderId, ')
          ..write('eventType: $eventType, ')
          ..write('eventTimestamp: $eventTimestamp, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
      'dosage', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCriticalMeta =
      const VerificationMeta('isCritical');
  @override
  late final GeneratedColumn<bool> isCritical = GeneratedColumn<bool>(
      'is_critical', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_critical" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pill'));
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#4CAF50'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<int> archivedAt = GeneratedColumn<int>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  static const VerificationMeta _xpValueMeta =
      const VerificationMeta('xpValue');
  @override
  late final GeneratedColumn<int> xpValue = GeneratedColumn<int>(
      'xp_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        name,
        dosage,
        frequency,
        instructions,
        isCritical,
        iconName,
        colorHex,
        isActive,
        createdAt,
        updatedAt,
        archivedAt,
        syncStatus,
        xpValue
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(Insertable<Medication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(_dosageMeta,
          dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta));
    } else if (isInserting) {
      context.missing(_dosageMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    }
    if (data.containsKey('is_critical')) {
      context.handle(
          _isCriticalMeta,
          isCritical.isAcceptableOrUnknown(
              data['is_critical']!, _isCriticalMeta));
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('xp_value')) {
      context.handle(_xpValueMeta,
          xpValue.isAcceptableOrUnknown(data['xp_value']!, _xpValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dosage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions']),
      isCritical: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_critical'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}archived_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      xpValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_value'])!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final String id;
  final String profileId;
  final String name;
  final String dosage;
  final String frequency;
  final String? instructions;
  final bool isCritical;
  final String iconName;
  final String colorHex;
  final bool isActive;
  final int createdAt;
  final int updatedAt;
  final int? archivedAt;
  final String syncStatus;
  final int xpValue;
  const Medication(
      {required this.id,
      required this.profileId,
      required this.name,
      required this.dosage,
      required this.frequency,
      this.instructions,
      required this.isCritical,
      required this.iconName,
      required this.colorHex,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      this.archivedAt,
      required this.syncStatus,
      required this.xpValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['dosage'] = Variable<String>(dosage);
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['is_critical'] = Variable<bool>(isCritical);
    map['icon_name'] = Variable<String>(iconName);
    map['color_hex'] = Variable<String>(colorHex);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(archivedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['xp_value'] = Variable<int>(xpValue);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      dosage: Value(dosage),
      frequency: Value(frequency),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      isCritical: Value(isCritical),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      syncStatus: Value(syncStatus),
      xpValue: Value(xpValue),
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String>(json['dosage']),
      frequency: serializer.fromJson<String>(json['frequency']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      isCritical: serializer.fromJson<bool>(json['isCritical']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      archivedAt: serializer.fromJson<int?>(json['archivedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      xpValue: serializer.fromJson<int>(json['xpValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String>(dosage),
      'frequency': serializer.toJson<String>(frequency),
      'instructions': serializer.toJson<String?>(instructions),
      'isCritical': serializer.toJson<bool>(isCritical),
      'iconName': serializer.toJson<String>(iconName),
      'colorHex': serializer.toJson<String>(colorHex),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'archivedAt': serializer.toJson<int?>(archivedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'xpValue': serializer.toJson<int>(xpValue),
    };
  }

  Medication copyWith(
          {String? id,
          String? profileId,
          String? name,
          String? dosage,
          String? frequency,
          Value<String?> instructions = const Value.absent(),
          bool? isCritical,
          String? iconName,
          String? colorHex,
          bool? isActive,
          int? createdAt,
          int? updatedAt,
          Value<int?> archivedAt = const Value.absent(),
          String? syncStatus,
          int? xpValue}) =>
      Medication(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        name: name ?? this.name,
        dosage: dosage ?? this.dosage,
        frequency: frequency ?? this.frequency,
        instructions:
            instructions.present ? instructions.value : this.instructions,
        isCritical: isCritical ?? this.isCritical,
        iconName: iconName ?? this.iconName,
        colorHex: colorHex ?? this.colorHex,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        xpValue: xpValue ?? this.xpValue,
      );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      isCritical:
          data.isCritical.present ? data.isCritical.value : this.isCritical,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      xpValue: data.xpValue.present ? data.xpValue.value : this.xpValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('instructions: $instructions, ')
          ..write('isCritical: $isCritical, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('xpValue: $xpValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      name,
      dosage,
      frequency,
      instructions,
      isCritical,
      iconName,
      colorHex,
      isActive,
      createdAt,
      updatedAt,
      archivedAt,
      syncStatus,
      xpValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.frequency == this.frequency &&
          other.instructions == this.instructions &&
          other.isCritical == this.isCritical &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.syncStatus == this.syncStatus &&
          other.xpValue == this.xpValue);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> name;
  final Value<String> dosage;
  final Value<String> frequency;
  final Value<String?> instructions;
  final Value<bool> isCritical;
  final Value<String> iconName;
  final Value<String> colorHex;
  final Value<bool> isActive;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> archivedAt;
  final Value<String> syncStatus;
  final Value<int> xpValue;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.frequency = const Value.absent(),
    this.instructions = const Value.absent(),
    this.isCritical = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String name,
    required String dosage,
    required String frequency,
    this.instructions = const Value.absent(),
    this.isCritical = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isActive = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.archivedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        dosage = Value(dosage),
        frequency = Value(frequency),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Medication> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? frequency,
    Expression<String>? instructions,
    Expression<bool>? isCritical,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? archivedAt,
    Expression<String>? syncStatus,
    Expression<int>? xpValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (frequency != null) 'frequency': frequency,
      if (instructions != null) 'instructions': instructions,
      if (isCritical != null) 'is_critical': isCritical,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (xpValue != null) 'xp_value': xpValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? name,
      Value<String>? dosage,
      Value<String>? frequency,
      Value<String?>? instructions,
      Value<bool>? isCritical,
      Value<String>? iconName,
      Value<String>? colorHex,
      Value<bool>? isActive,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? archivedAt,
      Value<String>? syncStatus,
      Value<int>? xpValue,
      Value<int>? rowid}) {
    return MedicationsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      instructions: instructions ?? this.instructions,
      isCritical: isCritical ?? this.isCritical,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      xpValue: xpValue ?? this.xpValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (isCritical.present) {
      map['is_critical'] = Variable<bool>(isCritical.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(archivedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (xpValue.present) {
      map['xp_value'] = Variable<int>(xpValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('instructions: $instructions, ')
          ..write('isCritical: $isCritical, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('xpValue: $xpValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseRecordsTable extends DoseRecords
    with TableInfo<$DoseRecordsTable, DoseRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES medications (id)'));
  static const VerificationMeta _scheduledTimeMeta =
      const VerificationMeta('scheduledTime');
  @override
  late final GeneratedColumn<int> scheduledTime = GeneratedColumn<int>(
      'scheduled_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _actualTimeMeta =
      const VerificationMeta('actualTime');
  @override
  late final GeneratedColumn<int> actualTime = GeneratedColumn<int>(
      'actual_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reminderIdMeta =
      const VerificationMeta('reminderId');
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
      'reminder_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  static const VerificationMeta _xpValueMeta =
      const VerificationMeta('xpValue');
  @override
  late final GeneratedColumn<int> xpValue = GeneratedColumn<int>(
      'xp_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        medicationId,
        scheduledTime,
        actualTime,
        status,
        reminderId,
        notes,
        createdAt,
        updatedAt,
        syncStatus,
        xpValue
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_records';
  @override
  VerificationContext validateIntegrity(Insertable<DoseRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
          _scheduledTimeMeta,
          scheduledTime.isAcceptableOrUnknown(
              data['scheduled_time']!, _scheduledTimeMeta));
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('actual_time')) {
      context.handle(
          _actualTimeMeta,
          actualTime.isAcceptableOrUnknown(
              data['actual_time']!, _actualTimeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
          _reminderIdMeta,
          reminderId.isAcceptableOrUnknown(
              data['reminder_id']!, _reminderIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('xp_value')) {
      context.handle(_xpValueMeta,
          xpValue.isAcceptableOrUnknown(data['xp_value']!, _xpValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoseRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      scheduledTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheduled_time'])!,
      actualTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actual_time']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      reminderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      xpValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_value'])!,
    );
  }

  @override
  $DoseRecordsTable createAlias(String alias) {
    return $DoseRecordsTable(attachedDatabase, alias);
  }
}

class DoseRecord extends DataClass implements Insertable<DoseRecord> {
  final String id;
  final String profileId;
  final String medicationId;
  final int scheduledTime;
  final int? actualTime;
  final String status;
  final String? reminderId;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  final int xpValue;
  const DoseRecord(
      {required this.id,
      required this.profileId,
      required this.medicationId,
      required this.scheduledTime,
      this.actualTime,
      required this.status,
      this.reminderId,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      required this.xpValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['medication_id'] = Variable<String>(medicationId);
    map['scheduled_time'] = Variable<int>(scheduledTime);
    if (!nullToAbsent || actualTime != null) {
      map['actual_time'] = Variable<int>(actualTime);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reminderId != null) {
      map['reminder_id'] = Variable<String>(reminderId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    map['xp_value'] = Variable<int>(xpValue);
    return map;
  }

  DoseRecordsCompanion toCompanion(bool nullToAbsent) {
    return DoseRecordsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      medicationId: Value(medicationId),
      scheduledTime: Value(scheduledTime),
      actualTime: actualTime == null && nullToAbsent
          ? const Value.absent()
          : Value(actualTime),
      status: Value(status),
      reminderId: reminderId == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      xpValue: Value(xpValue),
    );
  }

  factory DoseRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseRecord(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduledTime: serializer.fromJson<int>(json['scheduledTime']),
      actualTime: serializer.fromJson<int?>(json['actualTime']),
      status: serializer.fromJson<String>(json['status']),
      reminderId: serializer.fromJson<String?>(json['reminderId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      xpValue: serializer.fromJson<int>(json['xpValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduledTime': serializer.toJson<int>(scheduledTime),
      'actualTime': serializer.toJson<int?>(actualTime),
      'status': serializer.toJson<String>(status),
      'reminderId': serializer.toJson<String?>(reminderId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'xpValue': serializer.toJson<int>(xpValue),
    };
  }

  DoseRecord copyWith(
          {String? id,
          String? profileId,
          String? medicationId,
          int? scheduledTime,
          Value<int?> actualTime = const Value.absent(),
          String? status,
          Value<String?> reminderId = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          String? syncStatus,
          int? xpValue}) =>
      DoseRecord(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        medicationId: medicationId ?? this.medicationId,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        actualTime: actualTime.present ? actualTime.value : this.actualTime,
        status: status ?? this.status,
        reminderId: reminderId.present ? reminderId.value : this.reminderId,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        xpValue: xpValue ?? this.xpValue,
      );
  DoseRecord copyWithCompanion(DoseRecordsCompanion data) {
    return DoseRecord(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      actualTime:
          data.actualTime.present ? data.actualTime.value : this.actualTime,
      status: data.status.present ? data.status.value : this.status,
      reminderId:
          data.reminderId.present ? data.reminderId.value : this.reminderId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      xpValue: data.xpValue.present ? data.xpValue.value : this.xpValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseRecord(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('actualTime: $actualTime, ')
          ..write('status: $status, ')
          ..write('reminderId: $reminderId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('xpValue: $xpValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      medicationId,
      scheduledTime,
      actualTime,
      status,
      reminderId,
      notes,
      createdAt,
      updatedAt,
      syncStatus,
      xpValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseRecord &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.medicationId == this.medicationId &&
          other.scheduledTime == this.scheduledTime &&
          other.actualTime == this.actualTime &&
          other.status == this.status &&
          other.reminderId == this.reminderId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.xpValue == this.xpValue);
}

class DoseRecordsCompanion extends UpdateCompanion<DoseRecord> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> medicationId;
  final Value<int> scheduledTime;
  final Value<int?> actualTime;
  final Value<String> status;
  final Value<String?> reminderId;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> xpValue;
  final Value<int> rowid;
  const DoseRecordsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.actualTime = const Value.absent(),
    this.status = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseRecordsCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String medicationId,
    required int scheduledTime,
    this.actualTime = const Value.absent(),
    required String status,
    this.reminderId = const Value.absent(),
    this.notes = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        medicationId = Value(medicationId),
        scheduledTime = Value(scheduledTime),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DoseRecord> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? medicationId,
    Expression<int>? scheduledTime,
    Expression<int>? actualTime,
    Expression<String>? status,
    Expression<String>? reminderId,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? xpValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (actualTime != null) 'actual_time': actualTime,
      if (status != null) 'status': status,
      if (reminderId != null) 'reminder_id': reminderId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (xpValue != null) 'xp_value': xpValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? medicationId,
      Value<int>? scheduledTime,
      Value<int?>? actualTime,
      Value<String>? status,
      Value<String?>? reminderId,
      Value<String?>? notes,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? xpValue,
      Value<int>? rowid}) {
    return DoseRecordsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      medicationId: medicationId ?? this.medicationId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      actualTime: actualTime ?? this.actualTime,
      status: status ?? this.status,
      reminderId: reminderId ?? this.reminderId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      xpValue: xpValue ?? this.xpValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<int>(scheduledTime.value);
    }
    if (actualTime.present) {
      map['actual_time'] = Variable<int>(actualTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (xpValue.present) {
      map['xp_value'] = Variable<int>(xpValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseRecordsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('actualTime: $actualTime, ')
          ..write('status: $status, ')
          ..write('reminderId: $reminderId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('xpValue: $xpValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CycleEntriesTable extends CycleEntries
    with TableInfo<$CycleEntriesTable, CycleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CycleEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _flowIntensityMeta =
      const VerificationMeta('flowIntensity');
  @override
  late final GeneratedColumn<String> flowIntensity = GeneratedColumn<String>(
      'flow_intensity', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _symptomsMeta =
      const VerificationMeta('symptoms');
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
      'symptoms', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPeriodDayMeta =
      const VerificationMeta('isPeriodDay');
  @override
  late final GeneratedColumn<bool> isPeriodDay = GeneratedColumn<bool>(
      'is_period_day', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_period_day" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _cycleNumberMeta =
      const VerificationMeta('cycleNumber');
  @override
  late final GeneratedColumn<int> cycleNumber = GeneratedColumn<int>(
      'cycle_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  static const VerificationMeta _xpValueMeta =
      const VerificationMeta('xpValue');
  @override
  late final GeneratedColumn<int> xpValue = GeneratedColumn<int>(
      'xp_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        date,
        flowIntensity,
        symptoms,
        notes,
        isPeriodDay,
        cycleNumber,
        createdAt,
        updatedAt,
        syncStatus,
        xpValue
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycle_entries';
  @override
  VerificationContext validateIntegrity(Insertable<CycleEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('flow_intensity')) {
      context.handle(
          _flowIntensityMeta,
          flowIntensity.isAcceptableOrUnknown(
              data['flow_intensity']!, _flowIntensityMeta));
    }
    if (data.containsKey('symptoms')) {
      context.handle(_symptomsMeta,
          symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_period_day')) {
      context.handle(
          _isPeriodDayMeta,
          isPeriodDay.isAcceptableOrUnknown(
              data['is_period_day']!, _isPeriodDayMeta));
    }
    if (data.containsKey('cycle_number')) {
      context.handle(
          _cycleNumberMeta,
          cycleNumber.isAcceptableOrUnknown(
              data['cycle_number']!, _cycleNumberMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('xp_value')) {
      context.handle(_xpValueMeta,
          xpValue.isAcceptableOrUnknown(data['xp_value']!, _xpValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {profileId, date},
      ];
  @override
  CycleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CycleEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      flowIntensity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flow_intensity']),
      symptoms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symptoms']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isPeriodDay: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_period_day'])!,
      cycleNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cycle_number']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      xpValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_value'])!,
    );
  }

  @override
  $CycleEntriesTable createAlias(String alias) {
    return $CycleEntriesTable(attachedDatabase, alias);
  }
}

class CycleEntry extends DataClass implements Insertable<CycleEntry> {
  final String id;
  final String profileId;
  final String date;
  final String? flowIntensity;
  final String? symptoms;
  final String? notes;
  final bool isPeriodDay;
  final int? cycleNumber;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  final int xpValue;
  const CycleEntry(
      {required this.id,
      required this.profileId,
      required this.date,
      this.flowIntensity,
      this.symptoms,
      this.notes,
      required this.isPeriodDay,
      this.cycleNumber,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      required this.xpValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || flowIntensity != null) {
      map['flow_intensity'] = Variable<String>(flowIntensity);
    }
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_period_day'] = Variable<bool>(isPeriodDay);
    if (!nullToAbsent || cycleNumber != null) {
      map['cycle_number'] = Variable<int>(cycleNumber);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    map['xp_value'] = Variable<int>(xpValue);
    return map;
  }

  CycleEntriesCompanion toCompanion(bool nullToAbsent) {
    return CycleEntriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      date: Value(date),
      flowIntensity: flowIntensity == null && nullToAbsent
          ? const Value.absent()
          : Value(flowIntensity),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isPeriodDay: Value(isPeriodDay),
      cycleNumber: cycleNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleNumber),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      xpValue: Value(xpValue),
    );
  }

  factory CycleEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CycleEntry(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      date: serializer.fromJson<String>(json['date']),
      flowIntensity: serializer.fromJson<String?>(json['flowIntensity']),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
      notes: serializer.fromJson<String?>(json['notes']),
      isPeriodDay: serializer.fromJson<bool>(json['isPeriodDay']),
      cycleNumber: serializer.fromJson<int?>(json['cycleNumber']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      xpValue: serializer.fromJson<int>(json['xpValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'date': serializer.toJson<String>(date),
      'flowIntensity': serializer.toJson<String?>(flowIntensity),
      'symptoms': serializer.toJson<String?>(symptoms),
      'notes': serializer.toJson<String?>(notes),
      'isPeriodDay': serializer.toJson<bool>(isPeriodDay),
      'cycleNumber': serializer.toJson<int?>(cycleNumber),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'xpValue': serializer.toJson<int>(xpValue),
    };
  }

  CycleEntry copyWith(
          {String? id,
          String? profileId,
          String? date,
          Value<String?> flowIntensity = const Value.absent(),
          Value<String?> symptoms = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isPeriodDay,
          Value<int?> cycleNumber = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          String? syncStatus,
          int? xpValue}) =>
      CycleEntry(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        date: date ?? this.date,
        flowIntensity:
            flowIntensity.present ? flowIntensity.value : this.flowIntensity,
        symptoms: symptoms.present ? symptoms.value : this.symptoms,
        notes: notes.present ? notes.value : this.notes,
        isPeriodDay: isPeriodDay ?? this.isPeriodDay,
        cycleNumber: cycleNumber.present ? cycleNumber.value : this.cycleNumber,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        xpValue: xpValue ?? this.xpValue,
      );
  CycleEntry copyWithCompanion(CycleEntriesCompanion data) {
    return CycleEntry(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      date: data.date.present ? data.date.value : this.date,
      flowIntensity: data.flowIntensity.present
          ? data.flowIntensity.value
          : this.flowIntensity,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      notes: data.notes.present ? data.notes.value : this.notes,
      isPeriodDay:
          data.isPeriodDay.present ? data.isPeriodDay.value : this.isPeriodDay,
      cycleNumber:
          data.cycleNumber.present ? data.cycleNumber.value : this.cycleNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      xpValue: data.xpValue.present ? data.xpValue.value : this.xpValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CycleEntry(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('flowIntensity: $flowIntensity, ')
          ..write('symptoms: $symptoms, ')
          ..write('notes: $notes, ')
          ..write('isPeriodDay: $isPeriodDay, ')
          ..write('cycleNumber: $cycleNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('xpValue: $xpValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      date,
      flowIntensity,
      symptoms,
      notes,
      isPeriodDay,
      cycleNumber,
      createdAt,
      updatedAt,
      syncStatus,
      xpValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CycleEntry &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.date == this.date &&
          other.flowIntensity == this.flowIntensity &&
          other.symptoms == this.symptoms &&
          other.notes == this.notes &&
          other.isPeriodDay == this.isPeriodDay &&
          other.cycleNumber == this.cycleNumber &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.xpValue == this.xpValue);
}

class CycleEntriesCompanion extends UpdateCompanion<CycleEntry> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> date;
  final Value<String?> flowIntensity;
  final Value<String?> symptoms;
  final Value<String?> notes;
  final Value<bool> isPeriodDay;
  final Value<int?> cycleNumber;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> xpValue;
  final Value<int> rowid;
  const CycleEntriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.date = const Value.absent(),
    this.flowIntensity = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.notes = const Value.absent(),
    this.isPeriodDay = const Value.absent(),
    this.cycleNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CycleEntriesCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String date,
    this.flowIntensity = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.notes = const Value.absent(),
    this.isPeriodDay = const Value.absent(),
    this.cycleNumber = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        date = Value(date),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CycleEntry> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? date,
    Expression<String>? flowIntensity,
    Expression<String>? symptoms,
    Expression<String>? notes,
    Expression<bool>? isPeriodDay,
    Expression<int>? cycleNumber,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? xpValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (date != null) 'date': date,
      if (flowIntensity != null) 'flow_intensity': flowIntensity,
      if (symptoms != null) 'symptoms': symptoms,
      if (notes != null) 'notes': notes,
      if (isPeriodDay != null) 'is_period_day': isPeriodDay,
      if (cycleNumber != null) 'cycle_number': cycleNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (xpValue != null) 'xp_value': xpValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CycleEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? date,
      Value<String?>? flowIntensity,
      Value<String?>? symptoms,
      Value<String?>? notes,
      Value<bool>? isPeriodDay,
      Value<int?>? cycleNumber,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? xpValue,
      Value<int>? rowid}) {
    return CycleEntriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      date: date ?? this.date,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      isPeriodDay: isPeriodDay ?? this.isPeriodDay,
      cycleNumber: cycleNumber ?? this.cycleNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      xpValue: xpValue ?? this.xpValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (flowIntensity.present) {
      map['flow_intensity'] = Variable<String>(flowIntensity.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isPeriodDay.present) {
      map['is_period_day'] = Variable<bool>(isPeriodDay.value);
    }
    if (cycleNumber.present) {
      map['cycle_number'] = Variable<int>(cycleNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (xpValue.present) {
      map['xp_value'] = Variable<int>(xpValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CycleEntriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('flowIntensity: $flowIntensity, ')
          ..write('symptoms: $symptoms, ')
          ..write('notes: $notes, ')
          ..write('isPeriodDay: $isPeriodDay, ')
          ..write('cycleNumber: $cycleNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('xpValue: $xpValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CyclePredictionsTable extends CyclePredictions
    with TableInfo<$CyclePredictionsTable, CyclePrediction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclePredictionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _predictedStartMeta =
      const VerificationMeta('predictedStart');
  @override
  late final GeneratedColumn<String> predictedStart = GeneratedColumn<String>(
      'predicted_start', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _predictedEndMeta =
      const VerificationMeta('predictedEnd');
  @override
  late final GeneratedColumn<String> predictedEnd = GeneratedColumn<String>(
      'predicted_end', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _algorithmVersionMeta =
      const VerificationMeta('algorithmVersion');
  @override
  late final GeneratedColumn<String> algorithmVersion = GeneratedColumn<String>(
      'algorithm_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _basedOnCyclesMeta =
      const VerificationMeta('basedOnCycles');
  @override
  late final GeneratedColumn<int> basedOnCycles = GeneratedColumn<int>(
      'based_on_cycles', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _invalidatedAtMeta =
      const VerificationMeta('invalidatedAt');
  @override
  late final GeneratedColumn<int> invalidatedAt = GeneratedColumn<int>(
      'invalidated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        predictedStart,
        predictedEnd,
        confidence,
        algorithmVersion,
        basedOnCycles,
        createdAt,
        updatedAt,
        invalidatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycle_predictions';
  @override
  VerificationContext validateIntegrity(Insertable<CyclePrediction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('predicted_start')) {
      context.handle(
          _predictedStartMeta,
          predictedStart.isAcceptableOrUnknown(
              data['predicted_start']!, _predictedStartMeta));
    } else if (isInserting) {
      context.missing(_predictedStartMeta);
    }
    if (data.containsKey('predicted_end')) {
      context.handle(
          _predictedEndMeta,
          predictedEnd.isAcceptableOrUnknown(
              data['predicted_end']!, _predictedEndMeta));
    } else if (isInserting) {
      context.missing(_predictedEndMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('algorithm_version')) {
      context.handle(
          _algorithmVersionMeta,
          algorithmVersion.isAcceptableOrUnknown(
              data['algorithm_version']!, _algorithmVersionMeta));
    } else if (isInserting) {
      context.missing(_algorithmVersionMeta);
    }
    if (data.containsKey('based_on_cycles')) {
      context.handle(
          _basedOnCyclesMeta,
          basedOnCycles.isAcceptableOrUnknown(
              data['based_on_cycles']!, _basedOnCyclesMeta));
    } else if (isInserting) {
      context.missing(_basedOnCyclesMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('invalidated_at')) {
      context.handle(
          _invalidatedAtMeta,
          invalidatedAt.isAcceptableOrUnknown(
              data['invalidated_at']!, _invalidatedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CyclePrediction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CyclePrediction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      predictedStart: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}predicted_start'])!,
      predictedEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}predicted_end'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      algorithmVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}algorithm_version'])!,
      basedOnCycles: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}based_on_cycles'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      invalidatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invalidated_at']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $CyclePredictionsTable createAlias(String alias) {
    return $CyclePredictionsTable(attachedDatabase, alias);
  }
}

class CyclePrediction extends DataClass implements Insertable<CyclePrediction> {
  final String id;
  final String profileId;
  final String predictedStart;
  final String predictedEnd;
  final double confidence;
  final String algorithmVersion;
  final int basedOnCycles;
  final int createdAt;
  final int updatedAt;
  final int? invalidatedAt;
  final String syncStatus;
  const CyclePrediction(
      {required this.id,
      required this.profileId,
      required this.predictedStart,
      required this.predictedEnd,
      required this.confidence,
      required this.algorithmVersion,
      required this.basedOnCycles,
      required this.createdAt,
      required this.updatedAt,
      this.invalidatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['predicted_start'] = Variable<String>(predictedStart);
    map['predicted_end'] = Variable<String>(predictedEnd);
    map['confidence'] = Variable<double>(confidence);
    map['algorithm_version'] = Variable<String>(algorithmVersion);
    map['based_on_cycles'] = Variable<int>(basedOnCycles);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || invalidatedAt != null) {
      map['invalidated_at'] = Variable<int>(invalidatedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  CyclePredictionsCompanion toCompanion(bool nullToAbsent) {
    return CyclePredictionsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      predictedStart: Value(predictedStart),
      predictedEnd: Value(predictedEnd),
      confidence: Value(confidence),
      algorithmVersion: Value(algorithmVersion),
      basedOnCycles: Value(basedOnCycles),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      invalidatedAt: invalidatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(invalidatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory CyclePrediction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CyclePrediction(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      predictedStart: serializer.fromJson<String>(json['predictedStart']),
      predictedEnd: serializer.fromJson<String>(json['predictedEnd']),
      confidence: serializer.fromJson<double>(json['confidence']),
      algorithmVersion: serializer.fromJson<String>(json['algorithmVersion']),
      basedOnCycles: serializer.fromJson<int>(json['basedOnCycles']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      invalidatedAt: serializer.fromJson<int?>(json['invalidatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'predictedStart': serializer.toJson<String>(predictedStart),
      'predictedEnd': serializer.toJson<String>(predictedEnd),
      'confidence': serializer.toJson<double>(confidence),
      'algorithmVersion': serializer.toJson<String>(algorithmVersion),
      'basedOnCycles': serializer.toJson<int>(basedOnCycles),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'invalidatedAt': serializer.toJson<int?>(invalidatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  CyclePrediction copyWith(
          {String? id,
          String? profileId,
          String? predictedStart,
          String? predictedEnd,
          double? confidence,
          String? algorithmVersion,
          int? basedOnCycles,
          int? createdAt,
          int? updatedAt,
          Value<int?> invalidatedAt = const Value.absent(),
          String? syncStatus}) =>
      CyclePrediction(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        predictedStart: predictedStart ?? this.predictedStart,
        predictedEnd: predictedEnd ?? this.predictedEnd,
        confidence: confidence ?? this.confidence,
        algorithmVersion: algorithmVersion ?? this.algorithmVersion,
        basedOnCycles: basedOnCycles ?? this.basedOnCycles,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        invalidatedAt:
            invalidatedAt.present ? invalidatedAt.value : this.invalidatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  CyclePrediction copyWithCompanion(CyclePredictionsCompanion data) {
    return CyclePrediction(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      predictedStart: data.predictedStart.present
          ? data.predictedStart.value
          : this.predictedStart,
      predictedEnd: data.predictedEnd.present
          ? data.predictedEnd.value
          : this.predictedEnd,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      algorithmVersion: data.algorithmVersion.present
          ? data.algorithmVersion.value
          : this.algorithmVersion,
      basedOnCycles: data.basedOnCycles.present
          ? data.basedOnCycles.value
          : this.basedOnCycles,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      invalidatedAt: data.invalidatedAt.present
          ? data.invalidatedAt.value
          : this.invalidatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CyclePrediction(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('predictedStart: $predictedStart, ')
          ..write('predictedEnd: $predictedEnd, ')
          ..write('confidence: $confidence, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('basedOnCycles: $basedOnCycles, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('invalidatedAt: $invalidatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      predictedStart,
      predictedEnd,
      confidence,
      algorithmVersion,
      basedOnCycles,
      createdAt,
      updatedAt,
      invalidatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CyclePrediction &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.predictedStart == this.predictedStart &&
          other.predictedEnd == this.predictedEnd &&
          other.confidence == this.confidence &&
          other.algorithmVersion == this.algorithmVersion &&
          other.basedOnCycles == this.basedOnCycles &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.invalidatedAt == this.invalidatedAt &&
          other.syncStatus == this.syncStatus);
}

class CyclePredictionsCompanion extends UpdateCompanion<CyclePrediction> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> predictedStart;
  final Value<String> predictedEnd;
  final Value<double> confidence;
  final Value<String> algorithmVersion;
  final Value<int> basedOnCycles;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> invalidatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const CyclePredictionsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.predictedStart = const Value.absent(),
    this.predictedEnd = const Value.absent(),
    this.confidence = const Value.absent(),
    this.algorithmVersion = const Value.absent(),
    this.basedOnCycles = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.invalidatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CyclePredictionsCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String predictedStart,
    required String predictedEnd,
    required double confidence,
    required String algorithmVersion,
    required int basedOnCycles,
    required int createdAt,
    required int updatedAt,
    this.invalidatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        predictedStart = Value(predictedStart),
        predictedEnd = Value(predictedEnd),
        confidence = Value(confidence),
        algorithmVersion = Value(algorithmVersion),
        basedOnCycles = Value(basedOnCycles),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CyclePrediction> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? predictedStart,
    Expression<String>? predictedEnd,
    Expression<double>? confidence,
    Expression<String>? algorithmVersion,
    Expression<int>? basedOnCycles,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? invalidatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (predictedStart != null) 'predicted_start': predictedStart,
      if (predictedEnd != null) 'predicted_end': predictedEnd,
      if (confidence != null) 'confidence': confidence,
      if (algorithmVersion != null) 'algorithm_version': algorithmVersion,
      if (basedOnCycles != null) 'based_on_cycles': basedOnCycles,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (invalidatedAt != null) 'invalidated_at': invalidatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CyclePredictionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? predictedStart,
      Value<String>? predictedEnd,
      Value<double>? confidence,
      Value<String>? algorithmVersion,
      Value<int>? basedOnCycles,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? invalidatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return CyclePredictionsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      predictedStart: predictedStart ?? this.predictedStart,
      predictedEnd: predictedEnd ?? this.predictedEnd,
      confidence: confidence ?? this.confidence,
      algorithmVersion: algorithmVersion ?? this.algorithmVersion,
      basedOnCycles: basedOnCycles ?? this.basedOnCycles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      invalidatedAt: invalidatedAt ?? this.invalidatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (predictedStart.present) {
      map['predicted_start'] = Variable<String>(predictedStart.value);
    }
    if (predictedEnd.present) {
      map['predicted_end'] = Variable<String>(predictedEnd.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (algorithmVersion.present) {
      map['algorithm_version'] = Variable<String>(algorithmVersion.value);
    }
    if (basedOnCycles.present) {
      map['based_on_cycles'] = Variable<int>(basedOnCycles.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (invalidatedAt.present) {
      map['invalidated_at'] = Variable<int>(invalidatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclePredictionsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('predictedStart: $predictedStart, ')
          ..write('predictedEnd: $predictedEnd, ')
          ..write('confidence: $confidence, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('basedOnCycles: $basedOnCycles, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('invalidatedAt: $invalidatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $XpEventsTable extends XpEvents with TableInfo<$XpEventsTable, XpEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _xpAmountMeta =
      const VerificationMeta('xpAmount');
  @override
  late final GeneratedColumn<int> xpAmount = GeneratedColumn<int>(
      'xp_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceEntityIdMeta =
      const VerificationMeta('sourceEntityId');
  @override
  late final GeneratedColumn<String> sourceEntityId = GeneratedColumn<String>(
      'source_entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceEntityTypeMeta =
      const VerificationMeta('sourceEntityType');
  @override
  late final GeneratedColumn<String> sourceEntityType = GeneratedColumn<String>(
      'source_entity_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        action,
        xpAmount,
        sourceEntityId,
        sourceEntityType,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_events';
  @override
  VerificationContext validateIntegrity(Insertable<XpEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('xp_amount')) {
      context.handle(_xpAmountMeta,
          xpAmount.isAcceptableOrUnknown(data['xp_amount']!, _xpAmountMeta));
    } else if (isInserting) {
      context.missing(_xpAmountMeta);
    }
    if (data.containsKey('source_entity_id')) {
      context.handle(
          _sourceEntityIdMeta,
          sourceEntityId.isAcceptableOrUnknown(
              data['source_entity_id']!, _sourceEntityIdMeta));
    }
    if (data.containsKey('source_entity_type')) {
      context.handle(
          _sourceEntityTypeMeta,
          sourceEntityType.isAcceptableOrUnknown(
              data['source_entity_type']!, _sourceEntityTypeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  XpEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      xpAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_amount'])!,
      sourceEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_entity_id']),
      sourceEntityType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_entity_type']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $XpEventsTable createAlias(String alias) {
    return $XpEventsTable(attachedDatabase, alias);
  }
}

class XpEvent extends DataClass implements Insertable<XpEvent> {
  final String id;
  final String profileId;
  final String action;
  final int xpAmount;
  final String? sourceEntityId;
  final String? sourceEntityType;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  const XpEvent(
      {required this.id,
      required this.profileId,
      required this.action,
      required this.xpAmount,
      this.sourceEntityId,
      this.sourceEntityType,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['action'] = Variable<String>(action);
    map['xp_amount'] = Variable<int>(xpAmount);
    if (!nullToAbsent || sourceEntityId != null) {
      map['source_entity_id'] = Variable<String>(sourceEntityId);
    }
    if (!nullToAbsent || sourceEntityType != null) {
      map['source_entity_type'] = Variable<String>(sourceEntityType);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  XpEventsCompanion toCompanion(bool nullToAbsent) {
    return XpEventsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      action: Value(action),
      xpAmount: Value(xpAmount),
      sourceEntityId: sourceEntityId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceEntityId),
      sourceEntityType: sourceEntityType == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceEntityType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory XpEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpEvent(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      action: serializer.fromJson<String>(json['action']),
      xpAmount: serializer.fromJson<int>(json['xpAmount']),
      sourceEntityId: serializer.fromJson<String?>(json['sourceEntityId']),
      sourceEntityType: serializer.fromJson<String?>(json['sourceEntityType']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'action': serializer.toJson<String>(action),
      'xpAmount': serializer.toJson<int>(xpAmount),
      'sourceEntityId': serializer.toJson<String?>(sourceEntityId),
      'sourceEntityType': serializer.toJson<String?>(sourceEntityType),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  XpEvent copyWith(
          {String? id,
          String? profileId,
          String? action,
          int? xpAmount,
          Value<String?> sourceEntityId = const Value.absent(),
          Value<String?> sourceEntityType = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          String? syncStatus}) =>
      XpEvent(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        action: action ?? this.action,
        xpAmount: xpAmount ?? this.xpAmount,
        sourceEntityId:
            sourceEntityId.present ? sourceEntityId.value : this.sourceEntityId,
        sourceEntityType: sourceEntityType.present
            ? sourceEntityType.value
            : this.sourceEntityType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  XpEvent copyWithCompanion(XpEventsCompanion data) {
    return XpEvent(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      action: data.action.present ? data.action.value : this.action,
      xpAmount: data.xpAmount.present ? data.xpAmount.value : this.xpAmount,
      sourceEntityId: data.sourceEntityId.present
          ? data.sourceEntityId.value
          : this.sourceEntityId,
      sourceEntityType: data.sourceEntityType.present
          ? data.sourceEntityType.value
          : this.sourceEntityType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpEvent(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('action: $action, ')
          ..write('xpAmount: $xpAmount, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('sourceEntityType: $sourceEntityType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, action, xpAmount,
      sourceEntityId, sourceEntityType, createdAt, updatedAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpEvent &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.action == this.action &&
          other.xpAmount == this.xpAmount &&
          other.sourceEntityId == this.sourceEntityId &&
          other.sourceEntityType == this.sourceEntityType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class XpEventsCompanion extends UpdateCompanion<XpEvent> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> action;
  final Value<int> xpAmount;
  final Value<String?> sourceEntityId;
  final Value<String?> sourceEntityType;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const XpEventsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.action = const Value.absent(),
    this.xpAmount = const Value.absent(),
    this.sourceEntityId = const Value.absent(),
    this.sourceEntityType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  XpEventsCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String action,
    required int xpAmount,
    this.sourceEntityId = const Value.absent(),
    this.sourceEntityType = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        action = Value(action),
        xpAmount = Value(xpAmount),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<XpEvent> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? action,
    Expression<int>? xpAmount,
    Expression<String>? sourceEntityId,
    Expression<String>? sourceEntityType,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (action != null) 'action': action,
      if (xpAmount != null) 'xp_amount': xpAmount,
      if (sourceEntityId != null) 'source_entity_id': sourceEntityId,
      if (sourceEntityType != null) 'source_entity_type': sourceEntityType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  XpEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? action,
      Value<int>? xpAmount,
      Value<String?>? sourceEntityId,
      Value<String?>? sourceEntityType,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return XpEventsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      action: action ?? this.action,
      xpAmount: xpAmount ?? this.xpAmount,
      sourceEntityId: sourceEntityId ?? this.sourceEntityId,
      sourceEntityType: sourceEntityType ?? this.sourceEntityType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (xpAmount.present) {
      map['xp_amount'] = Variable<int>(xpAmount.value);
    }
    if (sourceEntityId.present) {
      map['source_entity_id'] = Variable<String>(sourceEntityId.value);
    }
    if (sourceEntityType.present) {
      map['source_entity_type'] = Variable<String>(sourceEntityType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpEventsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('action: $action, ')
          ..write('xpAmount: $xpAmount, ')
          ..write('sourceEntityId: $sourceEntityId, ')
          ..write('sourceEntityType: $sourceEntityType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreaksTable extends Streaks with TableInfo<$StreaksTable, Streak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _streakTypeMeta =
      const VerificationMeta('streakType');
  @override
  late final GeneratedColumn<String> streakType = GeneratedColumn<String>(
      'streak_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentCountMeta =
      const VerificationMeta('currentCount');
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
      'current_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _longestCountMeta =
      const VerificationMeta('longestCount');
  @override
  late final GeneratedColumn<int> longestCount = GeneratedColumn<int>(
      'longest_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastActivityAtMeta =
      const VerificationMeta('lastActivityAt');
  @override
  late final GeneratedColumn<int> lastActivityAt = GeneratedColumn<int>(
      'last_activity_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        streakType,
        currentCount,
        longestCount,
        lastActivityAt,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks';
  @override
  VerificationContext validateIntegrity(Insertable<Streak> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('streak_type')) {
      context.handle(
          _streakTypeMeta,
          streakType.isAcceptableOrUnknown(
              data['streak_type']!, _streakTypeMeta));
    } else if (isInserting) {
      context.missing(_streakTypeMeta);
    }
    if (data.containsKey('current_count')) {
      context.handle(
          _currentCountMeta,
          currentCount.isAcceptableOrUnknown(
              data['current_count']!, _currentCountMeta));
    }
    if (data.containsKey('longest_count')) {
      context.handle(
          _longestCountMeta,
          longestCount.isAcceptableOrUnknown(
              data['longest_count']!, _longestCountMeta));
    }
    if (data.containsKey('last_activity_at')) {
      context.handle(
          _lastActivityAtMeta,
          lastActivityAt.isAcceptableOrUnknown(
              data['last_activity_at']!, _lastActivityAtMeta));
    } else if (isInserting) {
      context.missing(_lastActivityAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {profileId, streakType},
      ];
  @override
  Streak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Streak(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      streakType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}streak_type'])!,
      currentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_count'])!,
      longestCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}longest_count'])!,
      lastActivityAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_activity_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $StreaksTable createAlias(String alias) {
    return $StreaksTable(attachedDatabase, alias);
  }
}

class Streak extends DataClass implements Insertable<Streak> {
  final String id;
  final String profileId;
  final String streakType;
  final int currentCount;
  final int longestCount;
  final int lastActivityAt;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  const Streak(
      {required this.id,
      required this.profileId,
      required this.streakType,
      required this.currentCount,
      required this.longestCount,
      required this.lastActivityAt,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['streak_type'] = Variable<String>(streakType);
    map['current_count'] = Variable<int>(currentCount);
    map['longest_count'] = Variable<int>(longestCount);
    map['last_activity_at'] = Variable<int>(lastActivityAt);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  StreaksCompanion toCompanion(bool nullToAbsent) {
    return StreaksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      streakType: Value(streakType),
      currentCount: Value(currentCount),
      longestCount: Value(longestCount),
      lastActivityAt: Value(lastActivityAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Streak.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Streak(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      streakType: serializer.fromJson<String>(json['streakType']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      longestCount: serializer.fromJson<int>(json['longestCount']),
      lastActivityAt: serializer.fromJson<int>(json['lastActivityAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'streakType': serializer.toJson<String>(streakType),
      'currentCount': serializer.toJson<int>(currentCount),
      'longestCount': serializer.toJson<int>(longestCount),
      'lastActivityAt': serializer.toJson<int>(lastActivityAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Streak copyWith(
          {String? id,
          String? profileId,
          String? streakType,
          int? currentCount,
          int? longestCount,
          int? lastActivityAt,
          int? createdAt,
          int? updatedAt,
          String? syncStatus}) =>
      Streak(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        streakType: streakType ?? this.streakType,
        currentCount: currentCount ?? this.currentCount,
        longestCount: longestCount ?? this.longestCount,
        lastActivityAt: lastActivityAt ?? this.lastActivityAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Streak copyWithCompanion(StreaksCompanion data) {
    return Streak(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      streakType:
          data.streakType.present ? data.streakType.value : this.streakType,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      longestCount: data.longestCount.present
          ? data.longestCount.value
          : this.longestCount,
      lastActivityAt: data.lastActivityAt.present
          ? data.lastActivityAt.value
          : this.lastActivityAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Streak(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('streakType: $streakType, ')
          ..write('currentCount: $currentCount, ')
          ..write('longestCount: $longestCount, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, streakType, currentCount,
      longestCount, lastActivityAt, createdAt, updatedAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Streak &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.streakType == this.streakType &&
          other.currentCount == this.currentCount &&
          other.longestCount == this.longestCount &&
          other.lastActivityAt == this.lastActivityAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class StreaksCompanion extends UpdateCompanion<Streak> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> streakType;
  final Value<int> currentCount;
  final Value<int> longestCount;
  final Value<int> lastActivityAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const StreaksCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.streakType = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.longestCount = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StreaksCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String streakType,
    this.currentCount = const Value.absent(),
    this.longestCount = const Value.absent(),
    required int lastActivityAt,
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        streakType = Value(streakType),
        lastActivityAt = Value(lastActivityAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Streak> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? streakType,
    Expression<int>? currentCount,
    Expression<int>? longestCount,
    Expression<int>? lastActivityAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (streakType != null) 'streak_type': streakType,
      if (currentCount != null) 'current_count': currentCount,
      if (longestCount != null) 'longest_count': longestCount,
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StreaksCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? streakType,
      Value<int>? currentCount,
      Value<int>? longestCount,
      Value<int>? lastActivityAt,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return StreaksCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      streakType: streakType ?? this.streakType,
      currentCount: currentCount ?? this.currentCount,
      longestCount: longestCount ?? this.longestCount,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (streakType.present) {
      map['streak_type'] = Variable<String>(streakType.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (longestCount.present) {
      map['longest_count'] = Variable<int>(longestCount.value);
    }
    if (lastActivityAt.present) {
      map['last_activity_at'] = Variable<int>(lastActivityAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('streakType: $streakType, ')
          ..write('currentCount: $currentCount, ')
          ..write('longestCount: $longestCount, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _achievementKeyMeta =
      const VerificationMeta('achievementKey');
  @override
  late final GeneratedColumn<String> achievementKey = GeneratedColumn<String>(
      'achievement_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<int> unlockedAt = GeneratedColumn<int>(
      'unlocked_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('local'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        achievementKey,
        title,
        description,
        iconName,
        unlockedAt,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(Insertable<Achievement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('achievement_key')) {
      context.handle(
          _achievementKeyMeta,
          achievementKey.isAcceptableOrUnknown(
              data['achievement_key']!, _achievementKeyMeta));
    } else if (isInserting) {
      context.missing(_achievementKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {profileId, achievementKey},
      ];
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      achievementKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}achievement_key'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unlocked_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final String id;
  final String profileId;
  final String achievementKey;
  final String title;
  final String description;
  final String iconName;
  final int? unlockedAt;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  const Achievement(
      {required this.id,
      required this.profileId,
      required this.achievementKey,
      required this.title,
      required this.description,
      required this.iconName,
      this.unlockedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['achievement_key'] = Variable<String>(achievementKey);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['icon_name'] = Variable<String>(iconName);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<int>(unlockedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      achievementKey: Value(achievementKey),
      title: Value(title),
      description: Value(description),
      iconName: Value(iconName),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Achievement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      achievementKey: serializer.fromJson<String>(json['achievementKey']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      iconName: serializer.fromJson<String>(json['iconName']),
      unlockedAt: serializer.fromJson<int?>(json['unlockedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'achievementKey': serializer.toJson<String>(achievementKey),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'iconName': serializer.toJson<String>(iconName),
      'unlockedAt': serializer.toJson<int?>(unlockedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Achievement copyWith(
          {String? id,
          String? profileId,
          String? achievementKey,
          String? title,
          String? description,
          String? iconName,
          Value<int?> unlockedAt = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          String? syncStatus}) =>
      Achievement(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        achievementKey: achievementKey ?? this.achievementKey,
        title: title ?? this.title,
        description: description ?? this.description,
        iconName: iconName ?? this.iconName,
        unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      achievementKey: data.achievementKey.present
          ? data.achievementKey.value
          : this.achievementKey,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('achievementKey: $achievementKey, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('iconName: $iconName, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, achievementKey, title,
      description, iconName, unlockedAt, createdAt, updatedAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.achievementKey == this.achievementKey &&
          other.title == this.title &&
          other.description == this.description &&
          other.iconName == this.iconName &&
          other.unlockedAt == this.unlockedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> achievementKey;
  final Value<String> title;
  final Value<String> description;
  final Value<String> iconName;
  final Value<int?> unlockedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.achievementKey = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.iconName = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String achievementKey,
    required String title,
    required String description,
    required String iconName,
    this.unlockedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        achievementKey = Value(achievementKey),
        title = Value(title),
        description = Value(description),
        iconName = Value(iconName),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Achievement> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? achievementKey,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? iconName,
    Expression<int>? unlockedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (achievementKey != null) 'achievement_key': achievementKey,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (iconName != null) 'icon_name': iconName,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? profileId,
      Value<String>? achievementKey,
      Value<String>? title,
      Value<String>? description,
      Value<String>? iconName,
      Value<int?>? unlockedAt,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return AchievementsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      achievementKey: achievementKey ?? this.achievementKey,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (achievementKey.present) {
      map['achievement_key'] = Variable<String>(achievementKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<int>(unlockedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('achievementKey: $achievementKey, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('iconName: $iconName, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [key, profileId, value, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key, profileId};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String profileId;
  final String value;
  final int createdAt;
  final int updatedAt;
  const AppSetting(
      {required this.key,
      required this.profileId,
      required this.value,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['profile_id'] = Variable<String>(profileId);
    map['value'] = Variable<String>(value);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      profileId: Value(profileId),
      value: Value(value),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      profileId: serializer.fromJson<String>(json['profileId']),
      value: serializer.fromJson<String>(json['value']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'profileId': serializer.toJson<String>(profileId),
      'value': serializer.toJson<String>(value),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AppSetting copyWith(
          {String? key,
          String? profileId,
          String? value,
          int? createdAt,
          int? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        profileId: profileId ?? this.profileId,
        value: value ?? this.value,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      value: data.value.present ? data.value.value : this.value,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('profileId: $profileId, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, profileId, value, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.profileId == this.profileId &&
          other.value == this.value &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> profileId;
  final Value<String> value;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.profileId = const Value.absent(),
    this.value = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    this.profileId = const Value.absent(),
    required String value,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? profileId,
    Expression<String>? value,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (profileId != null) 'profile_id': profileId,
      if (value != null) 'value': value,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key,
      Value<String>? profileId,
      Value<String>? value,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      profileId: profileId ?? this.profileId,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
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
          ..write('profileId: $profileId, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $ReminderLogsTable reminderLogs = $ReminderLogsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $DoseRecordsTable doseRecords = $DoseRecordsTable(this);
  late final $CycleEntriesTable cycleEntries = $CycleEntriesTable(this);
  late final $CyclePredictionsTable cyclePredictions =
      $CyclePredictionsTable(this);
  late final $XpEventsTable xpEvents = $XpEventsTable(this);
  late final $StreaksTable streaks = $StreaksTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final ProfilesDao profilesDao = ProfilesDao(this as AppDatabase);
  late final ReminderDao reminderDao = ReminderDao(this as AppDatabase);
  late final MedicationDao medicationDao = MedicationDao(this as AppDatabase);
  late final CycleDao cycleDao = CycleDao(this as AppDatabase);
  late final GamificationDao gamificationDao =
      GamificationDao(this as AppDatabase);
  late final AppSettingsDao appSettingsDao =
      AppSettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        profiles,
        reminders,
        reminderLogs,
        medications,
        doseRecords,
        cycleEntries,
        cyclePredictions,
        xpEvents,
        streaks,
        achievements,
        appSettings
      ];
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String id,
  required String name,
  Value<String?> avatarIcon,
  Value<bool> isActive,
  Value<String?> pinHash,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> avatarIcon,
  Value<bool> isActive,
  Value<String?> pinHash,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarIcon => $composableBuilder(
      column: $table.avatarIcon, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarIcon => $composableBuilder(
      column: $table.avatarIcon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarIcon => $composableBuilder(
      column: $table.avatarIcon, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$ProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
    Profile,
    PrefetchHooks Function()> {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> avatarIcon = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesCompanion(
            id: id,
            name: name,
            avatarIcon: avatarIcon,
            isActive: isActive,
            pinHash: pinHash,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> avatarIcon = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesCompanion.insert(
            id: id,
            name: name,
            avatarIcon: avatarIcon,
            isActive: isActive,
            pinHash: pinHash,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
    Profile,
    PrefetchHooks Function()>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  required String id,
  Value<String> profileId,
  required String type,
  required String title,
  Value<String?> body,
  Value<String> status,
  required int scheduledTime,
  Value<int?> actualTriggerTime,
  Value<int> snoozeCount,
  Value<int> escalationCount,
  Value<String> confirmationMode,
  Value<String?> linkedEntityId,
  Value<String?> linkedEntityType,
  Value<int> maxSnoozes,
  Value<int> snoozeBaseDelayMinutes,
  Value<int> responseWindowSeconds,
  Value<int> maxEscalations,
  Value<int> escalationIntervalSeconds,
  Value<int> confirmationWindowSeconds,
  required int createdAt,
  required int updatedAt,
  Value<int?> completedAt,
  Value<String?> cancellationReason,
  Value<String> syncStatus,
  Value<int> xpValue,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> type,
  Value<String> title,
  Value<String?> body,
  Value<String> status,
  Value<int> scheduledTime,
  Value<int?> actualTriggerTime,
  Value<int> snoozeCount,
  Value<int> escalationCount,
  Value<String> confirmationMode,
  Value<String?> linkedEntityId,
  Value<String?> linkedEntityType,
  Value<int> maxSnoozes,
  Value<int> snoozeBaseDelayMinutes,
  Value<int> responseWindowSeconds,
  Value<int> maxEscalations,
  Value<int> escalationIntervalSeconds,
  Value<int> confirmationWindowSeconds,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> completedAt,
  Value<String?> cancellationReason,
  Value<String> syncStatus,
  Value<int> xpValue,
  Value<int> rowid,
});

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReminderLogsTable, List<ReminderLog>>
      _reminderLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reminderLogs,
              aliasName: $_aliasNameGenerator(
                  db.reminders.id, db.reminderLogs.reminderId));

  $$ReminderLogsTableProcessedTableManager get reminderLogsRefs {
    final manager = $$ReminderLogsTableTableManager($_db, $_db.reminderLogs)
        .filter((f) => f.reminderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reminderLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get actualTriggerTime => $composableBuilder(
      column: $table.actualTriggerTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get snoozeCount => $composableBuilder(
      column: $table.snoozeCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get escalationCount => $composableBuilder(
      column: $table.escalationCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get confirmationMode => $composableBuilder(
      column: $table.confirmationMode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedEntityId => $composableBuilder(
      column: $table.linkedEntityId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedEntityType => $composableBuilder(
      column: $table.linkedEntityType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxSnoozes => $composableBuilder(
      column: $table.maxSnoozes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get snoozeBaseDelayMinutes => $composableBuilder(
      column: $table.snoozeBaseDelayMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get responseWindowSeconds => $composableBuilder(
      column: $table.responseWindowSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxEscalations => $composableBuilder(
      column: $table.maxEscalations,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get escalationIntervalSeconds => $composableBuilder(
      column: $table.escalationIntervalSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get confirmationWindowSeconds => $composableBuilder(
      column: $table.confirmationWindowSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cancellationReason => $composableBuilder(
      column: $table.cancellationReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpValue => $composableBuilder(
      column: $table.xpValue, builder: (column) => ColumnFilters(column));

  Expression<bool> reminderLogsRefs(
      Expression<bool> Function($$ReminderLogsTableFilterComposer f) f) {
    final $$ReminderLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminderLogs,
        getReferencedColumn: (t) => t.reminderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReminderLogsTableFilterComposer(
              $db: $db,
              $table: $db.reminderLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get actualTriggerTime => $composableBuilder(
      column: $table.actualTriggerTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get snoozeCount => $composableBuilder(
      column: $table.snoozeCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get escalationCount => $composableBuilder(
      column: $table.escalationCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get confirmationMode => $composableBuilder(
      column: $table.confirmationMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedEntityId => $composableBuilder(
      column: $table.linkedEntityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedEntityType => $composableBuilder(
      column: $table.linkedEntityType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxSnoozes => $composableBuilder(
      column: $table.maxSnoozes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get snoozeBaseDelayMinutes => $composableBuilder(
      column: $table.snoozeBaseDelayMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get responseWindowSeconds => $composableBuilder(
      column: $table.responseWindowSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxEscalations => $composableBuilder(
      column: $table.maxEscalations,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get escalationIntervalSeconds => $composableBuilder(
      column: $table.escalationIntervalSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get confirmationWindowSeconds => $composableBuilder(
      column: $table.confirmationWindowSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cancellationReason => $composableBuilder(
      column: $table.cancellationReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpValue => $composableBuilder(
      column: $table.xpValue, builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => column);

  GeneratedColumn<int> get actualTriggerTime => $composableBuilder(
      column: $table.actualTriggerTime, builder: (column) => column);

  GeneratedColumn<int> get snoozeCount => $composableBuilder(
      column: $table.snoozeCount, builder: (column) => column);

  GeneratedColumn<int> get escalationCount => $composableBuilder(
      column: $table.escalationCount, builder: (column) => column);

  GeneratedColumn<String> get confirmationMode => $composableBuilder(
      column: $table.confirmationMode, builder: (column) => column);

  GeneratedColumn<String> get linkedEntityId => $composableBuilder(
      column: $table.linkedEntityId, builder: (column) => column);

  GeneratedColumn<String> get linkedEntityType => $composableBuilder(
      column: $table.linkedEntityType, builder: (column) => column);

  GeneratedColumn<int> get maxSnoozes => $composableBuilder(
      column: $table.maxSnoozes, builder: (column) => column);

  GeneratedColumn<int> get snoozeBaseDelayMinutes => $composableBuilder(
      column: $table.snoozeBaseDelayMinutes, builder: (column) => column);

  GeneratedColumn<int> get responseWindowSeconds => $composableBuilder(
      column: $table.responseWindowSeconds, builder: (column) => column);

  GeneratedColumn<int> get maxEscalations => $composableBuilder(
      column: $table.maxEscalations, builder: (column) => column);

  GeneratedColumn<int> get escalationIntervalSeconds => $composableBuilder(
      column: $table.escalationIntervalSeconds, builder: (column) => column);

  GeneratedColumn<int> get confirmationWindowSeconds => $composableBuilder(
      column: $table.confirmationWindowSeconds, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get cancellationReason => $composableBuilder(
      column: $table.cancellationReason, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get xpValue =>
      $composableBuilder(column: $table.xpValue, builder: (column) => column);

  Expression<T> reminderLogsRefs<T extends Object>(
      Expression<T> Function($$ReminderLogsTableAnnotationComposer a) f) {
    final $$ReminderLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminderLogs,
        getReferencedColumn: (t) => t.reminderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReminderLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.reminderLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool reminderLogsRefs})> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> body = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> scheduledTime = const Value.absent(),
            Value<int?> actualTriggerTime = const Value.absent(),
            Value<int> snoozeCount = const Value.absent(),
            Value<int> escalationCount = const Value.absent(),
            Value<String> confirmationMode = const Value.absent(),
            Value<String?> linkedEntityId = const Value.absent(),
            Value<String?> linkedEntityType = const Value.absent(),
            Value<int> maxSnoozes = const Value.absent(),
            Value<int> snoozeBaseDelayMinutes = const Value.absent(),
            Value<int> responseWindowSeconds = const Value.absent(),
            Value<int> maxEscalations = const Value.absent(),
            Value<int> escalationIntervalSeconds = const Value.absent(),
            Value<int> confirmationWindowSeconds = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> completedAt = const Value.absent(),
            Value<String?> cancellationReason = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> xpValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            profileId: profileId,
            type: type,
            title: title,
            body: body,
            status: status,
            scheduledTime: scheduledTime,
            actualTriggerTime: actualTriggerTime,
            snoozeCount: snoozeCount,
            escalationCount: escalationCount,
            confirmationMode: confirmationMode,
            linkedEntityId: linkedEntityId,
            linkedEntityType: linkedEntityType,
            maxSnoozes: maxSnoozes,
            snoozeBaseDelayMinutes: snoozeBaseDelayMinutes,
            responseWindowSeconds: responseWindowSeconds,
            maxEscalations: maxEscalations,
            escalationIntervalSeconds: escalationIntervalSeconds,
            confirmationWindowSeconds: confirmationWindowSeconds,
            createdAt: createdAt,
            updatedAt: updatedAt,
            completedAt: completedAt,
            cancellationReason: cancellationReason,
            syncStatus: syncStatus,
            xpValue: xpValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> profileId = const Value.absent(),
            required String type,
            required String title,
            Value<String?> body = const Value.absent(),
            Value<String> status = const Value.absent(),
            required int scheduledTime,
            Value<int?> actualTriggerTime = const Value.absent(),
            Value<int> snoozeCount = const Value.absent(),
            Value<int> escalationCount = const Value.absent(),
            Value<String> confirmationMode = const Value.absent(),
            Value<String?> linkedEntityId = const Value.absent(),
            Value<String?> linkedEntityType = const Value.absent(),
            Value<int> maxSnoozes = const Value.absent(),
            Value<int> snoozeBaseDelayMinutes = const Value.absent(),
            Value<int> responseWindowSeconds = const Value.absent(),
            Value<int> maxEscalations = const Value.absent(),
            Value<int> escalationIntervalSeconds = const Value.absent(),
            Value<int> confirmationWindowSeconds = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> completedAt = const Value.absent(),
            Value<String?> cancellationReason = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> xpValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion.insert(
            id: id,
            profileId: profileId,
            type: type,
            title: title,
            body: body,
            status: status,
            scheduledTime: scheduledTime,
            actualTriggerTime: actualTriggerTime,
            snoozeCount: snoozeCount,
            escalationCount: escalationCount,
            confirmationMode: confirmationMode,
            linkedEntityId: linkedEntityId,
            linkedEntityType: linkedEntityType,
            maxSnoozes: maxSnoozes,
            snoozeBaseDelayMinutes: snoozeBaseDelayMinutes,
            responseWindowSeconds: responseWindowSeconds,
            maxEscalations: maxEscalations,
            escalationIntervalSeconds: escalationIntervalSeconds,
            confirmationWindowSeconds: confirmationWindowSeconds,
            createdAt: createdAt,
            updatedAt: updatedAt,
            completedAt: completedAt,
            cancellationReason: cancellationReason,
            syncStatus: syncStatus,
            xpValue: xpValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RemindersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({reminderLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reminderLogsRefs) db.reminderLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reminderLogsRefs)
                    await $_getPrefetchedData<Reminder, $RemindersTable,
                            ReminderLog>(
                        currentTable: table,
                        referencedTable: $$RemindersTableReferences
                            ._reminderLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RemindersTableReferences(db, table, p0)
                                .reminderLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.reminderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool reminderLogsRefs})>;
typedef $$ReminderLogsTableCreateCompanionBuilder = ReminderLogsCompanion
    Function({
  required String id,
  Value<String> profileId,
  required String reminderId,
  required String eventType,
  required int eventTimestamp,
  Value<String?> metadata,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$ReminderLogsTableUpdateCompanionBuilder = ReminderLogsCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> reminderId,
  Value<String> eventType,
  Value<int> eventTimestamp,
  Value<String?> metadata,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

final class $$ReminderLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ReminderLogsTable, ReminderLog> {
  $$ReminderLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RemindersTable _reminderIdTable(_$AppDatabase db) =>
      db.reminders.createAlias(
          $_aliasNameGenerator(db.reminderLogs.reminderId, db.reminders.id));

  $$RemindersTableProcessedTableManager get reminderId {
    final $_column = $_itemColumn<String>('reminder_id')!;

    final manager = $$RemindersTableTableManager($_db, $_db.reminders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReminderLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderLogsTable> {
  $$ReminderLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get eventTimestamp => $composableBuilder(
      column: $table.eventTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  $$RemindersTableFilterComposer get reminderId {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reminderId,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableFilterComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderLogsTable> {
  $$ReminderLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get eventTimestamp => $composableBuilder(
      column: $table.eventTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  $$RemindersTableOrderingComposer get reminderId {
    final $$RemindersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reminderId,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableOrderingComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderLogsTable> {
  $$ReminderLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<int> get eventTimestamp => $composableBuilder(
      column: $table.eventTimestamp, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  $$RemindersTableAnnotationComposer get reminderId {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reminderId,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableAnnotationComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReminderLogsTable,
    ReminderLog,
    $$ReminderLogsTableFilterComposer,
    $$ReminderLogsTableOrderingComposer,
    $$ReminderLogsTableAnnotationComposer,
    $$ReminderLogsTableCreateCompanionBuilder,
    $$ReminderLogsTableUpdateCompanionBuilder,
    (ReminderLog, $$ReminderLogsTableReferences),
    ReminderLog,
    PrefetchHooks Function({bool reminderId})> {
  $$ReminderLogsTableTableManager(_$AppDatabase db, $ReminderLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> reminderId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<int> eventTimestamp = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderLogsCompanion(
            id: id,
            profileId: profileId,
            reminderId: reminderId,
            eventType: eventType,
            eventTimestamp: eventTimestamp,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> profileId = const Value.absent(),
            required String reminderId,
            required String eventType,
            required int eventTimestamp,
            Value<String?> metadata = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderLogsCompanion.insert(
            id: id,
            profileId: profileId,
            reminderId: reminderId,
            eventType: eventType,
            eventTimestamp: eventTimestamp,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReminderLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({reminderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (reminderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.reminderId,
                    referencedTable:
                        $$ReminderLogsTableReferences._reminderIdTable(db),
                    referencedColumn:
                        $$ReminderLogsTableReferences._reminderIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReminderLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReminderLogsTable,
    ReminderLog,
    $$ReminderLogsTableFilterComposer,
    $$ReminderLogsTableOrderingComposer,
    $$ReminderLogsTableAnnotationComposer,
    $$ReminderLogsTableCreateCompanionBuilder,
    $$ReminderLogsTableUpdateCompanionBuilder,
    (ReminderLog, $$ReminderLogsTableReferences),
    ReminderLog,
    PrefetchHooks Function({bool reminderId})>;
typedef $$MedicationsTableCreateCompanionBuilder = MedicationsCompanion
    Function({
  required String id,
  Value<String> profileId,
  required String name,
  required String dosage,
  required String frequency,
  Value<String?> instructions,
  Value<bool> isCritical,
  Value<String> iconName,
  Value<String> colorHex,
  Value<bool> isActive,
  required int createdAt,
  required int updatedAt,
  Value<int?> archivedAt,
  Value<String> syncStatus,
  Value<int> xpValue,
  Value<int> rowid,
});
typedef $$MedicationsTableUpdateCompanionBuilder = MedicationsCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> name,
  Value<String> dosage,
  Value<String> frequency,
  Value<String?> instructions,
  Value<bool> isCritical,
  Value<String> iconName,
  Value<String> colorHex,
  Value<bool> isActive,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> archivedAt,
  Value<String> syncStatus,
  Value<int> xpValue,
  Value<int> rowid,
});

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DoseRecordsTable, List<DoseRecord>>
      _doseRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.doseRecords,
              aliasName: $_aliasNameGenerator(
                  db.medications.id, db.doseRecords.medicationId));

  $$DoseRecordsTableProcessedTableManager get doseRecordsRefs {
    final manager = $$DoseRecordsTableTableManager($_db, $_db.doseRecords)
        .filter(
            (f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCritical => $composableBuilder(
      column: $table.isCritical, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpValue => $composableBuilder(
      column: $table.xpValue, builder: (column) => ColumnFilters(column));

  Expression<bool> doseRecordsRefs(
      Expression<bool> Function($$DoseRecordsTableFilterComposer f) f) {
    final $$DoseRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.doseRecords,
        getReferencedColumn: (t) => t.medicationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DoseRecordsTableFilterComposer(
              $db: $db,
              $table: $db.doseRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCritical => $composableBuilder(
      column: $table.isCritical, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpValue => $composableBuilder(
      column: $table.xpValue, builder: (column) => ColumnOrderings(column));
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<bool> get isCritical => $composableBuilder(
      column: $table.isCritical, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get xpValue =>
      $composableBuilder(column: $table.xpValue, builder: (column) => column);

  Expression<T> doseRecordsRefs<T extends Object>(
      Expression<T> Function($$DoseRecordsTableAnnotationComposer a) f) {
    final $$DoseRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.doseRecords,
        getReferencedColumn: (t) => t.medicationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DoseRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.doseRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, $$MedicationsTableReferences),
    Medication,
    PrefetchHooks Function({bool doseRecordsRefs})> {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> dosage = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<String?> instructions = const Value.absent(),
            Value<bool> isCritical = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> archivedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> xpValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion(
            id: id,
            profileId: profileId,
            name: name,
            dosage: dosage,
            frequency: frequency,
            instructions: instructions,
            isCritical: isCritical,
            iconName: iconName,
            colorHex: colorHex,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            archivedAt: archivedAt,
            syncStatus: syncStatus,
            xpValue: xpValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> profileId = const Value.absent(),
            required String name,
            required String dosage,
            required String frequency,
            Value<String?> instructions = const Value.absent(),
            Value<bool> isCritical = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> archivedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> xpValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion.insert(
            id: id,
            profileId: profileId,
            name: name,
            dosage: dosage,
            frequency: frequency,
            instructions: instructions,
            isCritical: isCritical,
            iconName: iconName,
            colorHex: colorHex,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            archivedAt: archivedAt,
            syncStatus: syncStatus,
            xpValue: xpValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({doseRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (doseRecordsRefs) db.doseRecords],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (doseRecordsRefs)
                    await $_getPrefetchedData<Medication, $MedicationsTable,
                            DoseRecord>(
                        currentTable: table,
                        referencedTable: $$MedicationsTableReferences
                            ._doseRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicationsTableReferences(db, table, p0)
                                .doseRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.medicationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MedicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, $$MedicationsTableReferences),
    Medication,
    PrefetchHooks Function({bool doseRecordsRefs})>;
typedef $$DoseRecordsTableCreateCompanionBuilder = DoseRecordsCompanion
    Function({
  required String id,
  Value<String> profileId,
  required String medicationId,
  required int scheduledTime,
  Value<int?> actualTime,
  required String status,
  Value<String?> reminderId,
  Value<String?> notes,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> xpValue,
  Value<int> rowid,
});
typedef $$DoseRecordsTableUpdateCompanionBuilder = DoseRecordsCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> medicationId,
  Value<int> scheduledTime,
  Value<int?> actualTime,
  Value<String> status,
  Value<String?> reminderId,
  Value<String?> notes,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> xpValue,
  Value<int> rowid,
});

final class $$DoseRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $DoseRecordsTable, DoseRecord> {
  $$DoseRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
          $_aliasNameGenerator(db.doseRecords.medicationId, db.medications.id));

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager($_db, $_db.medications)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DoseRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DoseRecordsTable> {
  $$DoseRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get actualTime => $composableBuilder(
      column: $table.actualTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpValue => $composableBuilder(
      column: $table.xpValue, builder: (column) => ColumnFilters(column));

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableFilterComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DoseRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseRecordsTable> {
  $$DoseRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get actualTime => $composableBuilder(
      column: $table.actualTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpValue => $composableBuilder(
      column: $table.xpValue, builder: (column) => ColumnOrderings(column));

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableOrderingComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DoseRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseRecordsTable> {
  $$DoseRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => column);

  GeneratedColumn<int> get actualTime => $composableBuilder(
      column: $table.actualTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get xpValue =>
      $composableBuilder(column: $table.xpValue, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableAnnotationComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DoseRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DoseRecordsTable,
    DoseRecord,
    $$DoseRecordsTableFilterComposer,
    $$DoseRecordsTableOrderingComposer,
    $$DoseRecordsTableAnnotationComposer,
    $$DoseRecordsTableCreateCompanionBuilder,
    $$DoseRecordsTableUpdateCompanionBuilder,
    (DoseRecord, $$DoseRecordsTableReferences),
    DoseRecord,
    PrefetchHooks Function({bool medicationId})> {
  $$DoseRecordsTableTableManager(_$AppDatabase db, $DoseRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<int> scheduledTime = const Value.absent(),
            Value<int?> actualTime = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> reminderId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> xpValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseRecordsCompanion(
            id: id,
            profileId: profileId,
            medicationId: medicationId,
            scheduledTime: scheduledTime,
            actualTime: actualTime,
            status: status,
            reminderId: reminderId,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            xpValue: xpValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> profileId = const Value.absent(),
            required String medicationId,
            required int scheduledTime,
            Value<int?> actualTime = const Value.absent(),
            required String status,
            Value<String?> reminderId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> xpValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseRecordsCompanion.insert(
            id: id,
            profileId: profileId,
            medicationId: medicationId,
            scheduledTime: scheduledTime,
            actualTime: actualTime,
            status: status,
            reminderId: reminderId,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            xpValue: xpValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DoseRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (medicationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicationId,
                    referencedTable:
                        $$DoseRecordsTableReferences._medicationIdTable(db),
                    referencedColumn:
                        $$DoseRecordsTableReferences._medicationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DoseRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DoseRecordsTable,
    DoseRecord,
    $$DoseRecordsTableFilterComposer,
    $$DoseRecordsTableOrderingComposer,
    $$DoseRecordsTableAnnotationComposer,
    $$DoseRecordsTableCreateCompanionBuilder,
    $$DoseRecordsTableUpdateCompanionBuilder,
    (DoseRecord, $$DoseRecordsTableReferences),
    DoseRecord,
    PrefetchHooks Function({bool medicationId})>;
typedef $$CycleEntriesTableCreateCompanionBuilder = CycleEntriesCompanion
    Function({
  required String id,
  Value<String> profileId,
  required String date,
  Value<String?> flowIntensity,
  Value<String?> symptoms,
  Value<String?> notes,
  Value<bool> isPeriodDay,
  Value<int?> cycleNumber,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> xpValue,
  Value<int> rowid,
});
typedef $$CycleEntriesTableUpdateCompanionBuilder = CycleEntriesCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> date,
  Value<String?> flowIntensity,
  Value<String?> symptoms,
  Value<String?> notes,
  Value<bool> isPeriodDay,
  Value<int?> cycleNumber,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> xpValue,
  Value<int> rowid,
});

class $$CycleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CycleEntriesTable> {
  $$CycleEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flowIntensity => $composableBuilder(
      column: $table.flowIntensity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPeriodDay => $composableBuilder(
      column: $table.isPeriodDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cycleNumber => $composableBuilder(
      column: $table.cycleNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpValue => $composableBuilder(
      column: $table.xpValue, builder: (column) => ColumnFilters(column));
}

class $$CycleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CycleEntriesTable> {
  $$CycleEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flowIntensity => $composableBuilder(
      column: $table.flowIntensity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPeriodDay => $composableBuilder(
      column: $table.isPeriodDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cycleNumber => $composableBuilder(
      column: $table.cycleNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpValue => $composableBuilder(
      column: $table.xpValue, builder: (column) => ColumnOrderings(column));
}

class $$CycleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CycleEntriesTable> {
  $$CycleEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get flowIntensity => $composableBuilder(
      column: $table.flowIntensity, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isPeriodDay => $composableBuilder(
      column: $table.isPeriodDay, builder: (column) => column);

  GeneratedColumn<int> get cycleNumber => $composableBuilder(
      column: $table.cycleNumber, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get xpValue =>
      $composableBuilder(column: $table.xpValue, builder: (column) => column);
}

class $$CycleEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CycleEntriesTable,
    CycleEntry,
    $$CycleEntriesTableFilterComposer,
    $$CycleEntriesTableOrderingComposer,
    $$CycleEntriesTableAnnotationComposer,
    $$CycleEntriesTableCreateCompanionBuilder,
    $$CycleEntriesTableUpdateCompanionBuilder,
    (CycleEntry, BaseReferences<_$AppDatabase, $CycleEntriesTable, CycleEntry>),
    CycleEntry,
    PrefetchHooks Function()> {
  $$CycleEntriesTableTableManager(_$AppDatabase db, $CycleEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CycleEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CycleEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CycleEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String?> flowIntensity = const Value.absent(),
            Value<String?> symptoms = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isPeriodDay = const Value.absent(),
            Value<int?> cycleNumber = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> xpValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CycleEntriesCompanion(
            id: id,
            profileId: profileId,
            date: date,
            flowIntensity: flowIntensity,
            symptoms: symptoms,
            notes: notes,
            isPeriodDay: isPeriodDay,
            cycleNumber: cycleNumber,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            xpValue: xpValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> profileId = const Value.absent(),
            required String date,
            Value<String?> flowIntensity = const Value.absent(),
            Value<String?> symptoms = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isPeriodDay = const Value.absent(),
            Value<int?> cycleNumber = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> xpValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CycleEntriesCompanion.insert(
            id: id,
            profileId: profileId,
            date: date,
            flowIntensity: flowIntensity,
            symptoms: symptoms,
            notes: notes,
            isPeriodDay: isPeriodDay,
            cycleNumber: cycleNumber,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            xpValue: xpValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CycleEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CycleEntriesTable,
    CycleEntry,
    $$CycleEntriesTableFilterComposer,
    $$CycleEntriesTableOrderingComposer,
    $$CycleEntriesTableAnnotationComposer,
    $$CycleEntriesTableCreateCompanionBuilder,
    $$CycleEntriesTableUpdateCompanionBuilder,
    (CycleEntry, BaseReferences<_$AppDatabase, $CycleEntriesTable, CycleEntry>),
    CycleEntry,
    PrefetchHooks Function()>;
typedef $$CyclePredictionsTableCreateCompanionBuilder
    = CyclePredictionsCompanion Function({
  required String id,
  Value<String> profileId,
  required String predictedStart,
  required String predictedEnd,
  required double confidence,
  required String algorithmVersion,
  required int basedOnCycles,
  required int createdAt,
  required int updatedAt,
  Value<int?> invalidatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$CyclePredictionsTableUpdateCompanionBuilder
    = CyclePredictionsCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> predictedStart,
  Value<String> predictedEnd,
  Value<double> confidence,
  Value<String> algorithmVersion,
  Value<int> basedOnCycles,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> invalidatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$CyclePredictionsTableFilterComposer
    extends Composer<_$AppDatabase, $CyclePredictionsTable> {
  $$CyclePredictionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get predictedStart => $composableBuilder(
      column: $table.predictedStart,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get predictedEnd => $composableBuilder(
      column: $table.predictedEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get algorithmVersion => $composableBuilder(
      column: $table.algorithmVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get basedOnCycles => $composableBuilder(
      column: $table.basedOnCycles, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get invalidatedAt => $composableBuilder(
      column: $table.invalidatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$CyclePredictionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CyclePredictionsTable> {
  $$CyclePredictionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get predictedStart => $composableBuilder(
      column: $table.predictedStart,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get predictedEnd => $composableBuilder(
      column: $table.predictedEnd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get algorithmVersion => $composableBuilder(
      column: $table.algorithmVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get basedOnCycles => $composableBuilder(
      column: $table.basedOnCycles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get invalidatedAt => $composableBuilder(
      column: $table.invalidatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$CyclePredictionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CyclePredictionsTable> {
  $$CyclePredictionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get predictedStart => $composableBuilder(
      column: $table.predictedStart, builder: (column) => column);

  GeneratedColumn<String> get predictedEnd => $composableBuilder(
      column: $table.predictedEnd, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get algorithmVersion => $composableBuilder(
      column: $table.algorithmVersion, builder: (column) => column);

  GeneratedColumn<int> get basedOnCycles => $composableBuilder(
      column: $table.basedOnCycles, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get invalidatedAt => $composableBuilder(
      column: $table.invalidatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$CyclePredictionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CyclePredictionsTable,
    CyclePrediction,
    $$CyclePredictionsTableFilterComposer,
    $$CyclePredictionsTableOrderingComposer,
    $$CyclePredictionsTableAnnotationComposer,
    $$CyclePredictionsTableCreateCompanionBuilder,
    $$CyclePredictionsTableUpdateCompanionBuilder,
    (
      CyclePrediction,
      BaseReferences<_$AppDatabase, $CyclePredictionsTable, CyclePrediction>
    ),
    CyclePrediction,
    PrefetchHooks Function()> {
  $$CyclePredictionsTableTableManager(
      _$AppDatabase db, $CyclePredictionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CyclePredictionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CyclePredictionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CyclePredictionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> predictedStart = const Value.absent(),
            Value<String> predictedEnd = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String> algorithmVersion = const Value.absent(),
            Value<int> basedOnCycles = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> invalidatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CyclePredictionsCompanion(
            id: id,
            profileId: profileId,
            predictedStart: predictedStart,
            predictedEnd: predictedEnd,
            confidence: confidence,
            algorithmVersion: algorithmVersion,
            basedOnCycles: basedOnCycles,
            createdAt: createdAt,
            updatedAt: updatedAt,
            invalidatedAt: invalidatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> profileId = const Value.absent(),
            required String predictedStart,
            required String predictedEnd,
            required double confidence,
            required String algorithmVersion,
            required int basedOnCycles,
            required int createdAt,
            required int updatedAt,
            Value<int?> invalidatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CyclePredictionsCompanion.insert(
            id: id,
            profileId: profileId,
            predictedStart: predictedStart,
            predictedEnd: predictedEnd,
            confidence: confidence,
            algorithmVersion: algorithmVersion,
            basedOnCycles: basedOnCycles,
            createdAt: createdAt,
            updatedAt: updatedAt,
            invalidatedAt: invalidatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CyclePredictionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CyclePredictionsTable,
    CyclePrediction,
    $$CyclePredictionsTableFilterComposer,
    $$CyclePredictionsTableOrderingComposer,
    $$CyclePredictionsTableAnnotationComposer,
    $$CyclePredictionsTableCreateCompanionBuilder,
    $$CyclePredictionsTableUpdateCompanionBuilder,
    (
      CyclePrediction,
      BaseReferences<_$AppDatabase, $CyclePredictionsTable, CyclePrediction>
    ),
    CyclePrediction,
    PrefetchHooks Function()>;
typedef $$XpEventsTableCreateCompanionBuilder = XpEventsCompanion Function({
  required String id,
  Value<String> profileId,
  required String action,
  required int xpAmount,
  Value<String?> sourceEntityId,
  Value<String?> sourceEntityType,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$XpEventsTableUpdateCompanionBuilder = XpEventsCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> action,
  Value<int> xpAmount,
  Value<String?> sourceEntityId,
  Value<String?> sourceEntityType,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$XpEventsTableFilterComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpAmount => $composableBuilder(
      column: $table.xpAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceEntityId => $composableBuilder(
      column: $table.sourceEntityId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceEntityType => $composableBuilder(
      column: $table.sourceEntityType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$XpEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpAmount => $composableBuilder(
      column: $table.xpAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceEntityId => $composableBuilder(
      column: $table.sourceEntityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceEntityType => $composableBuilder(
      column: $table.sourceEntityType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$XpEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<int> get xpAmount =>
      $composableBuilder(column: $table.xpAmount, builder: (column) => column);

  GeneratedColumn<String> get sourceEntityId => $composableBuilder(
      column: $table.sourceEntityId, builder: (column) => column);

  GeneratedColumn<String> get sourceEntityType => $composableBuilder(
      column: $table.sourceEntityType, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$XpEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $XpEventsTable,
    XpEvent,
    $$XpEventsTableFilterComposer,
    $$XpEventsTableOrderingComposer,
    $$XpEventsTableAnnotationComposer,
    $$XpEventsTableCreateCompanionBuilder,
    $$XpEventsTableUpdateCompanionBuilder,
    (XpEvent, BaseReferences<_$AppDatabase, $XpEventsTable, XpEvent>),
    XpEvent,
    PrefetchHooks Function()> {
  $$XpEventsTableTableManager(_$AppDatabase db, $XpEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<int> xpAmount = const Value.absent(),
            Value<String?> sourceEntityId = const Value.absent(),
            Value<String?> sourceEntityType = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              XpEventsCompanion(
            id: id,
            profileId: profileId,
            action: action,
            xpAmount: xpAmount,
            sourceEntityId: sourceEntityId,
            sourceEntityType: sourceEntityType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> profileId = const Value.absent(),
            required String action,
            required int xpAmount,
            Value<String?> sourceEntityId = const Value.absent(),
            Value<String?> sourceEntityType = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              XpEventsCompanion.insert(
            id: id,
            profileId: profileId,
            action: action,
            xpAmount: xpAmount,
            sourceEntityId: sourceEntityId,
            sourceEntityType: sourceEntityType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$XpEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $XpEventsTable,
    XpEvent,
    $$XpEventsTableFilterComposer,
    $$XpEventsTableOrderingComposer,
    $$XpEventsTableAnnotationComposer,
    $$XpEventsTableCreateCompanionBuilder,
    $$XpEventsTableUpdateCompanionBuilder,
    (XpEvent, BaseReferences<_$AppDatabase, $XpEventsTable, XpEvent>),
    XpEvent,
    PrefetchHooks Function()>;
typedef $$StreaksTableCreateCompanionBuilder = StreaksCompanion Function({
  required String id,
  Value<String> profileId,
  required String streakType,
  Value<int> currentCount,
  Value<int> longestCount,
  required int lastActivityAt,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$StreaksTableUpdateCompanionBuilder = StreaksCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> streakType,
  Value<int> currentCount,
  Value<int> longestCount,
  Value<int> lastActivityAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$StreaksTableFilterComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get streakType => $composableBuilder(
      column: $table.streakType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentCount => $composableBuilder(
      column: $table.currentCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longestCount => $composableBuilder(
      column: $table.longestCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$StreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get streakType => $composableBuilder(
      column: $table.streakType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentCount => $composableBuilder(
      column: $table.currentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longestCount => $composableBuilder(
      column: $table.longestCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$StreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get streakType => $composableBuilder(
      column: $table.streakType, builder: (column) => column);

  GeneratedColumn<int> get currentCount => $composableBuilder(
      column: $table.currentCount, builder: (column) => column);

  GeneratedColumn<int> get longestCount => $composableBuilder(
      column: $table.longestCount, builder: (column) => column);

  GeneratedColumn<int> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$StreaksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StreaksTable,
    Streak,
    $$StreaksTableFilterComposer,
    $$StreaksTableOrderingComposer,
    $$StreaksTableAnnotationComposer,
    $$StreaksTableCreateCompanionBuilder,
    $$StreaksTableUpdateCompanionBuilder,
    (Streak, BaseReferences<_$AppDatabase, $StreaksTable, Streak>),
    Streak,
    PrefetchHooks Function()> {
  $$StreaksTableTableManager(_$AppDatabase db, $StreaksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> streakType = const Value.absent(),
            Value<int> currentCount = const Value.absent(),
            Value<int> longestCount = const Value.absent(),
            Value<int> lastActivityAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StreaksCompanion(
            id: id,
            profileId: profileId,
            streakType: streakType,
            currentCount: currentCount,
            longestCount: longestCount,
            lastActivityAt: lastActivityAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> profileId = const Value.absent(),
            required String streakType,
            Value<int> currentCount = const Value.absent(),
            Value<int> longestCount = const Value.absent(),
            required int lastActivityAt,
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StreaksCompanion.insert(
            id: id,
            profileId: profileId,
            streakType: streakType,
            currentCount: currentCount,
            longestCount: longestCount,
            lastActivityAt: lastActivityAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StreaksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StreaksTable,
    Streak,
    $$StreaksTableFilterComposer,
    $$StreaksTableOrderingComposer,
    $$StreaksTableAnnotationComposer,
    $$StreaksTableCreateCompanionBuilder,
    $$StreaksTableUpdateCompanionBuilder,
    (Streak, BaseReferences<_$AppDatabase, $StreaksTable, Streak>),
    Streak,
    PrefetchHooks Function()>;
typedef $$AchievementsTableCreateCompanionBuilder = AchievementsCompanion
    Function({
  required String id,
  Value<String> profileId,
  required String achievementKey,
  required String title,
  required String description,
  required String iconName,
  Value<int?> unlockedAt,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$AchievementsTableUpdateCompanionBuilder = AchievementsCompanion
    Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> achievementKey,
  Value<String> title,
  Value<String> description,
  Value<String> iconName,
  Value<int?> unlockedAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get achievementKey => $composableBuilder(
      column: $table.achievementKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get achievementKey => $composableBuilder(
      column: $table.achievementKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get achievementKey => $composableBuilder(
      column: $table.achievementKey, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$AchievementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementsTable,
    Achievement,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (
      Achievement,
      BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>
    ),
    Achievement,
    PrefetchHooks Function()> {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> achievementKey = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<int?> unlockedAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsCompanion(
            id: id,
            profileId: profileId,
            achievementKey: achievementKey,
            title: title,
            description: description,
            iconName: iconName,
            unlockedAt: unlockedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> profileId = const Value.absent(),
            required String achievementKey,
            required String title,
            required String description,
            required String iconName,
            Value<int?> unlockedAt = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsCompanion.insert(
            id: id,
            profileId: profileId,
            achievementKey: achievementKey,
            title: title,
            description: description,
            iconName: iconName,
            unlockedAt: unlockedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementsTable,
    Achievement,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (
      Achievement,
      BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>
    ),
    Achievement,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  Value<String> profileId,
  required String value,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> profileId,
  Value<String> value,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
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
            Value<String> profileId = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            profileId: profileId,
            value: value,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<String> profileId = const Value.absent(),
            required String value,
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            profileId: profileId,
            value: value,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$ReminderLogsTableTableManager get reminderLogs =>
      $$ReminderLogsTableTableManager(_db, _db.reminderLogs);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$DoseRecordsTableTableManager get doseRecords =>
      $$DoseRecordsTableTableManager(_db, _db.doseRecords);
  $$CycleEntriesTableTableManager get cycleEntries =>
      $$CycleEntriesTableTableManager(_db, _db.cycleEntries);
  $$CyclePredictionsTableTableManager get cyclePredictions =>
      $$CyclePredictionsTableTableManager(_db, _db.cyclePredictions);
  $$XpEventsTableTableManager get xpEvents =>
      $$XpEventsTableTableManager(_db, _db.xpEvents);
  $$StreaksTableTableManager get streaks =>
      $$StreaksTableTableManager(_db, _db.streaks);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
