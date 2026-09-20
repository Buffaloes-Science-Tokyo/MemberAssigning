// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PersonsTable extends Persons with TableInfo<$PersonsTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOutMeta = const VerificationMeta('isOut');
  @override
  late final GeneratedColumn<bool> isOut = GeneratedColumn<bool>(
    'is_out',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_out" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isOut];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Person> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_out')) {
      context.handle(
        _isOutMeta,
        isOut.isAcceptableOrUnknown(data['is_out']!, _isOutMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isOut: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_out'],
      )!,
    );
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String name;
  final bool isOut;
  const Person({required this.id, required this.name, required this.isOut});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_out'] = Variable<bool>(isOut);
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      id: Value(id),
      name: Value(name),
      isOut: Value(isOut),
    );
  }

  factory Person.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isOut: serializer.fromJson<bool>(json['isOut']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isOut': serializer.toJson<bool>(isOut),
    };
  }

  Person copyWith({int? id, String? name, bool? isOut}) => Person(
    id: id ?? this.id,
    name: name ?? this.name,
    isOut: isOut ?? this.isOut,
  );
  Person copyWithCompanion(PersonsCompanion data) {
    return Person(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isOut: data.isOut.present ? data.isOut.value : this.isOut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isOut: $isOut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isOut);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.name == this.name &&
          other.isOut == this.isOut);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isOut;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isOut = const Value.absent(),
  });
  PersonsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isOut = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Person> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isOut,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isOut != null) 'is_out': isOut,
    });
  }

  PersonsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isOut,
  }) {
    return PersonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isOut: isOut ?? this.isOut,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isOut.present) {
      map['is_out'] = Variable<bool>(isOut.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isOut: $isOut')
          ..write(')'))
        .toString();
  }
}

class $PersonPositionsTable extends PersonPositions
    with TableInfo<$PersonPositionsTable, PersonPosition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonPositionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionIndexMeta = const VerificationMeta(
    'positionIndex',
  );
  @override
  late final GeneratedColumn<int> positionIndex = GeneratedColumn<int>(
    'position_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, personId, positionIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'person_positions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonPosition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('position_index')) {
      context.handle(
        _positionIndexMeta,
        positionIndex.isAcceptableOrUnknown(
          data['position_index']!,
          _positionIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positionIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {personId, positionIndex},
  ];
  @override
  PersonPosition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonPosition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      )!,
      positionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_index'],
      )!,
    );
  }

  @override
  $PersonPositionsTable createAlias(String alias) {
    return $PersonPositionsTable(attachedDatabase, alias);
  }
}

class PersonPosition extends DataClass implements Insertable<PersonPosition> {
  final int id;
  final int personId;
  final int positionIndex;
  const PersonPosition({
    required this.id,
    required this.personId,
    required this.positionIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    map['position_index'] = Variable<int>(positionIndex);
    return map;
  }

  PersonPositionsCompanion toCompanion(bool nullToAbsent) {
    return PersonPositionsCompanion(
      id: Value(id),
      personId: Value(personId),
      positionIndex: Value(positionIndex),
    );
  }

  factory PersonPosition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonPosition(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['personId']),
      positionIndex: serializer.fromJson<int>(json['positionIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int>(personId),
      'positionIndex': serializer.toJson<int>(positionIndex),
    };
  }

  PersonPosition copyWith({int? id, int? personId, int? positionIndex}) =>
      PersonPosition(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        positionIndex: positionIndex ?? this.positionIndex,
      );
  PersonPosition copyWithCompanion(PersonPositionsCompanion data) {
    return PersonPosition(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      positionIndex: data.positionIndex.present
          ? data.positionIndex.value
          : this.positionIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonPosition(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('positionIndex: $positionIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, personId, positionIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonPosition &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.positionIndex == this.positionIndex);
}

class PersonPositionsCompanion extends UpdateCompanion<PersonPosition> {
  final Value<int> id;
  final Value<int> personId;
  final Value<int> positionIndex;
  const PersonPositionsCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.positionIndex = const Value.absent(),
  });
  PersonPositionsCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required int positionIndex,
  }) : personId = Value(personId),
       positionIndex = Value(positionIndex);
  static Insertable<PersonPosition> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<int>? positionIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (positionIndex != null) 'position_index': positionIndex,
    });
  }

  PersonPositionsCompanion copyWith({
    Value<int>? id,
    Value<int>? personId,
    Value<int>? positionIndex,
  }) {
    return PersonPositionsCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      positionIndex: positionIndex ?? this.positionIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (positionIndex.present) {
      map['position_index'] = Variable<int>(positionIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonPositionsCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('positionIndex: $positionIndex')
          ..write(')'))
        .toString();
  }
}

class $PlaysTable extends Plays with TableInfo<$PlaysTable, Play> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaysTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
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
  @override
  List<GeneratedColumn> get $columns => [id, category, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plays';
  @override
  VerificationContext validateIntegrity(
    Insertable<Play> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Play map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Play(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $PlaysTable createAlias(String alias) {
    return $PlaysTable(attachedDatabase, alias);
  }
}

class Play extends DataClass implements Insertable<Play> {
  final int id;
  final String category;
  final String name;
  const Play({required this.id, required this.category, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['name'] = Variable<String>(name);
    return map;
  }

  PlaysCompanion toCompanion(bool nullToAbsent) {
    return PlaysCompanion(
      id: Value(id),
      category: Value(category),
      name: Value(name),
    );
  }

  factory Play.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Play(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'name': serializer.toJson<String>(name),
    };
  }

  Play copyWith({int? id, String? category, String? name}) => Play(
    id: id ?? this.id,
    category: category ?? this.category,
    name: name ?? this.name,
  );
  Play copyWithCompanion(PlaysCompanion data) {
    return Play(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Play(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Play &&
          other.id == this.id &&
          other.category == this.category &&
          other.name == this.name);
}

class PlaysCompanion extends UpdateCompanion<Play> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> name;
  const PlaysCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
  });
  PlaysCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String name,
  }) : category = Value(category),
       name = Value(name);
  static Insertable<Play> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (name != null) 'name': name,
    });
  }

  PlaysCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<String>? name,
  }) {
    return PlaysCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaysCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $LineupSlotsTable extends LineupSlots
    with TableInfo<$LineupSlotsTable, LineupSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LineupSlotsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _playIdMeta = const VerificationMeta('playId');
  @override
  late final GeneratedColumn<int> playId = GeneratedColumn<int>(
    'play_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plays (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionIndexMeta = const VerificationMeta(
    'positionIndex',
  );
  @override
  late final GeneratedColumn<int> positionIndex = GeneratedColumn<int>(
    'position_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, playId, positionIndex, personId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lineup_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LineupSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('play_id')) {
      context.handle(
        _playIdMeta,
        playId.isAcceptableOrUnknown(data['play_id']!, _playIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playIdMeta);
    }
    if (data.containsKey('position_index')) {
      context.handle(
        _positionIndexMeta,
        positionIndex.isAcceptableOrUnknown(
          data['position_index']!,
          _positionIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positionIndexMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {playId, positionIndex},
  ];
  @override
  LineupSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LineupSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}play_id'],
      )!,
      positionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_index'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      ),
    );
  }

  @override
  $LineupSlotsTable createAlias(String alias) {
    return $LineupSlotsTable(attachedDatabase, alias);
  }
}

class LineupSlot extends DataClass implements Insertable<LineupSlot> {
  final int id;
  final int playId;
  final int positionIndex;
  final int? personId;
  const LineupSlot({
    required this.id,
    required this.playId,
    required this.positionIndex,
    this.personId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['play_id'] = Variable<int>(playId);
    map['position_index'] = Variable<int>(positionIndex);
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<int>(personId);
    }
    return map;
  }

  LineupSlotsCompanion toCompanion(bool nullToAbsent) {
    return LineupSlotsCompanion(
      id: Value(id),
      playId: Value(playId),
      positionIndex: Value(positionIndex),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
    );
  }

  factory LineupSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LineupSlot(
      id: serializer.fromJson<int>(json['id']),
      playId: serializer.fromJson<int>(json['playId']),
      positionIndex: serializer.fromJson<int>(json['positionIndex']),
      personId: serializer.fromJson<int?>(json['personId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playId': serializer.toJson<int>(playId),
      'positionIndex': serializer.toJson<int>(positionIndex),
      'personId': serializer.toJson<int?>(personId),
    };
  }

  LineupSlot copyWith({
    int? id,
    int? playId,
    int? positionIndex,
    Value<int?> personId = const Value.absent(),
  }) => LineupSlot(
    id: id ?? this.id,
    playId: playId ?? this.playId,
    positionIndex: positionIndex ?? this.positionIndex,
    personId: personId.present ? personId.value : this.personId,
  );
  LineupSlot copyWithCompanion(LineupSlotsCompanion data) {
    return LineupSlot(
      id: data.id.present ? data.id.value : this.id,
      playId: data.playId.present ? data.playId.value : this.playId,
      positionIndex: data.positionIndex.present
          ? data.positionIndex.value
          : this.positionIndex,
      personId: data.personId.present ? data.personId.value : this.personId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LineupSlot(')
          ..write('id: $id, ')
          ..write('playId: $playId, ')
          ..write('positionIndex: $positionIndex, ')
          ..write('personId: $personId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playId, positionIndex, personId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineupSlot &&
          other.id == this.id &&
          other.playId == this.playId &&
          other.positionIndex == this.positionIndex &&
          other.personId == this.personId);
}

class LineupSlotsCompanion extends UpdateCompanion<LineupSlot> {
  final Value<int> id;
  final Value<int> playId;
  final Value<int> positionIndex;
  final Value<int?> personId;
  const LineupSlotsCompanion({
    this.id = const Value.absent(),
    this.playId = const Value.absent(),
    this.positionIndex = const Value.absent(),
    this.personId = const Value.absent(),
  });
  LineupSlotsCompanion.insert({
    this.id = const Value.absent(),
    required int playId,
    required int positionIndex,
    this.personId = const Value.absent(),
  }) : playId = Value(playId),
       positionIndex = Value(positionIndex);
  static Insertable<LineupSlot> custom({
    Expression<int>? id,
    Expression<int>? playId,
    Expression<int>? positionIndex,
    Expression<int>? personId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playId != null) 'play_id': playId,
      if (positionIndex != null) 'position_index': positionIndex,
      if (personId != null) 'person_id': personId,
    });
  }

  LineupSlotsCompanion copyWith({
    Value<int>? id,
    Value<int>? playId,
    Value<int>? positionIndex,
    Value<int?>? personId,
  }) {
    return LineupSlotsCompanion(
      id: id ?? this.id,
      playId: playId ?? this.playId,
      positionIndex: positionIndex ?? this.positionIndex,
      personId: personId ?? this.personId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playId.present) {
      map['play_id'] = Variable<int>(playId.value);
    }
    if (positionIndex.present) {
      map['position_index'] = Variable<int>(positionIndex.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LineupSlotsCompanion(')
          ..write('id: $id, ')
          ..write('playId: $playId, ')
          ..write('positionIndex: $positionIndex, ')
          ..write('personId: $personId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $PersonPositionsTable personPositions = $PersonPositionsTable(
    this,
  );
  late final $PlaysTable plays = $PlaysTable(this);
  late final $LineupSlotsTable lineupSlots = $LineupSlotsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    persons,
    personPositions,
    plays,
    lineupSlots,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'persons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('person_positions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plays',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lineup_slots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'persons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lineup_slots', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$PersonsTableCreateCompanionBuilder = PersonsCompanion Function({
  Value<int> id,
  required String name,
  Value<bool> isOut,
});
typedef $$PersonsTableUpdateCompanionBuilder = PersonsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<bool> isOut,
});

final class $$PersonsTableReferences
    extends BaseReferences<_$AppDatabase, $PersonsTable, Person> {
  $$PersonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PersonPositionsTable, List<PersonPosition>>
  _personPositionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personPositions,
    aliasName: 'persons__id__person_positions__person_id',
  );

  $$PersonPositionsTableProcessedTableManager get personPositionsRefs {
    final manager = $$PersonPositionsTableTableManager(
      $_db,
      $_db.personPositions,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _personPositionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LineupSlotsTable, List<LineupSlot>>
  _lineupSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lineupSlots,
    aliasName: 'persons__id__lineup_slots__person_id',
  );

  $$LineupSlotsTableProcessedTableManager get lineupSlotsRefs {
    final manager = $$LineupSlotsTableTableManager(
      $_db,
      $_db.lineupSlots,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lineupSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersonsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOut => $composableBuilder(
    column: $table.isOut,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personPositionsRefs(
    Expression<bool> Function($$PersonPositionsTableFilterComposer f) f,
  ) {
    final $$PersonPositionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personPositions,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonPositionsTableFilterComposer(
            $db: $db,
            $table: $db.personPositions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lineupSlotsRefs(
    Expression<bool> Function($$LineupSlotsTableFilterComposer f) f,
  ) {
    final $$LineupSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupSlots,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupSlotsTableFilterComposer(
            $db: $db,
            $table: $db.lineupSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOut => $composableBuilder(
    column: $table.isOut,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isOut =>
      $composableBuilder(column: $table.isOut, builder: (column) => column);

  Expression<T> personPositionsRefs<T extends Object>(
    Expression<T> Function($$PersonPositionsTableAnnotationComposer a) f,
  ) {
    final $$PersonPositionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personPositions,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonPositionsTableAnnotationComposer(
            $db: $db,
            $table: $db.personPositions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lineupSlotsRefs<T extends Object>(
    Expression<T> Function($$LineupSlotsTableAnnotationComposer a) f,
  ) {
    final $$LineupSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupSlots,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.lineupSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonsTable,
          Person,
          $$PersonsTableFilterComposer,
          $$PersonsTableOrderingComposer,
          $$PersonsTableAnnotationComposer,
          $$PersonsTableCreateCompanionBuilder,
          $$PersonsTableUpdateCompanionBuilder,
          (Person, $$PersonsTableReferences),
          Person,
          PrefetchHooks Function({
            bool personPositionsRefs,
            bool lineupSlotsRefs,
          })
        > {
  $$PersonsTableTableManager(_$AppDatabase db, $PersonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isOut = const Value.absent(),
          }) => PersonsCompanion(id: id, name: name, isOut: isOut),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<bool> isOut = const Value.absent(),
          }) => PersonsCompanion.insert(id: id, name: name, isOut: isOut),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonsTable, Person>(table),
                  $$PersonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({personPositionsRefs = false, lineupSlotsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (personPositionsRefs) db.personPositions,
                    if (lineupSlotsRefs) db.lineupSlots,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (personPositionsRefs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          PersonPosition
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._personPositionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).personPositionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lineupSlotsRefs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          LineupSlot
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._lineupSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).lineupSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PersonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonsTable,
      Person,
      $$PersonsTableFilterComposer,
      $$PersonsTableOrderingComposer,
      $$PersonsTableAnnotationComposer,
      $$PersonsTableCreateCompanionBuilder,
      $$PersonsTableUpdateCompanionBuilder,
      (Person, $$PersonsTableReferences),
      Person,
      PrefetchHooks Function({bool personPositionsRefs, bool lineupSlotsRefs})
    >;
typedef $$PersonPositionsTableCreateCompanionBuilder =
    PersonPositionsCompanion Function({
      Value<int> id,
      required int personId,
      required int positionIndex,
    });
typedef $$PersonPositionsTableUpdateCompanionBuilder =
    PersonPositionsCompanion Function({
      Value<int> id,
      Value<int> personId,
      Value<int> positionIndex,
    });

final class $$PersonPositionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PersonPositionsTable, PersonPosition> {
  $$PersonPositionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersonsTable _personIdTable(_$AppDatabase db) =>
      db.persons.createAlias('person_positions__person_id__persons__id');

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<int>('person_id')!;

    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PersonPositionsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonPositionsTable> {
  $$PersonPositionsTableFilterComposer({
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

  ColumnFilters<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonPositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonPositionsTable> {
  $$PersonPositionsTableOrderingComposer({
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

  ColumnOrderings<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonPositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonPositionsTable> {
  $$PersonPositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => column,
  );

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonPositionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonPositionsTable,
          PersonPosition,
          $$PersonPositionsTableFilterComposer,
          $$PersonPositionsTableOrderingComposer,
          $$PersonPositionsTableAnnotationComposer,
          $$PersonPositionsTableCreateCompanionBuilder,
          $$PersonPositionsTableUpdateCompanionBuilder,
          (PersonPosition, $$PersonPositionsTableReferences),
          PersonPosition,
          PrefetchHooks Function({bool personId})
        > {
  $$PersonPositionsTableTableManager(
    _$AppDatabase db,
    $PersonPositionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonPositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonPositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonPositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> personId = const Value.absent(),
                Value<int> positionIndex = const Value.absent(),
              }) => PersonPositionsCompanion(
                id: id,
                personId: personId,
                positionIndex: positionIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int personId,
                required int positionIndex,
              }) => PersonPositionsCompanion.insert(
                id: id,
                personId: personId,
                positionIndex: positionIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonPositionsTable, PersonPosition>(table),
                  $$PersonPositionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$PersonPositionsTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$PersonPositionsTableReferences
                            ._personIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PersonPositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonPositionsTable,
      PersonPosition,
      $$PersonPositionsTableFilterComposer,
      $$PersonPositionsTableOrderingComposer,
      $$PersonPositionsTableAnnotationComposer,
      $$PersonPositionsTableCreateCompanionBuilder,
      $$PersonPositionsTableUpdateCompanionBuilder,
      (PersonPosition, $$PersonPositionsTableReferences),
      PersonPosition,
      PrefetchHooks Function({bool personId})
    >;
typedef $$PlaysTableCreateCompanionBuilder = PlaysCompanion Function({
  Value<int> id,
  required String category,
  required String name,
});
typedef $$PlaysTableUpdateCompanionBuilder = PlaysCompanion Function({
  Value<int> id,
  Value<String> category,
  Value<String> name,
});

final class $$PlaysTableReferences
    extends BaseReferences<_$AppDatabase, $PlaysTable, Play> {
  $$PlaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LineupSlotsTable, List<LineupSlot>>
  _lineupSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lineupSlots,
    aliasName: 'plays__id__lineup_slots__play_id',
  );

  $$LineupSlotsTableProcessedTableManager get lineupSlotsRefs {
    final manager = $$LineupSlotsTableTableManager(
      $_db,
      $_db.lineupSlots,
    ).filter((f) => f.playId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lineupSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlaysTableFilterComposer extends Composer<_$AppDatabase, $PlaysTable> {
  $$PlaysTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lineupSlotsRefs(
    Expression<bool> Function($$LineupSlotsTableFilterComposer f) f,
  ) {
    final $$LineupSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupSlots,
      getReferencedColumn: (t) => t.playId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupSlotsTableFilterComposer(
            $db: $db,
            $table: $db.lineupSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaysTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaysTable> {
  $$PlaysTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaysTable> {
  $$PlaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> lineupSlotsRefs<T extends Object>(
    Expression<T> Function($$LineupSlotsTableAnnotationComposer a) f,
  ) {
    final $$LineupSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupSlots,
      getReferencedColumn: (t) => t.playId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.lineupSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaysTable,
          Play,
          $$PlaysTableFilterComposer,
          $$PlaysTableOrderingComposer,
          $$PlaysTableAnnotationComposer,
          $$PlaysTableCreateCompanionBuilder,
          $$PlaysTableUpdateCompanionBuilder,
          (Play, $$PlaysTableReferences),
          Play,
          PrefetchHooks Function({bool lineupSlotsRefs})
        > {
  $$PlaysTableTableManager(_$AppDatabase db, $PlaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => PlaysCompanion(id: id, category: category, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String category,
            required String name,
          }) => PlaysCompanion.insert(id: id, category: category, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaysTable, Play>(table),
                  $$PlaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lineupSlotsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (lineupSlotsRefs) db.lineupSlots],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lineupSlotsRefs)
                    await $_getPrefetchedData<Play, $PlaysTable, LineupSlot>(
                      currentTable: table,
                      referencedTable: $$PlaysTableReferences
                          ._lineupSlotsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlaysTableReferences(db, table, p0).lineupSlotsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaysTable,
      Play,
      $$PlaysTableFilterComposer,
      $$PlaysTableOrderingComposer,
      $$PlaysTableAnnotationComposer,
      $$PlaysTableCreateCompanionBuilder,
      $$PlaysTableUpdateCompanionBuilder,
      (Play, $$PlaysTableReferences),
      Play,
      PrefetchHooks Function({bool lineupSlotsRefs})
    >;
typedef $$LineupSlotsTableCreateCompanionBuilder =
    LineupSlotsCompanion Function({
      Value<int> id,
      required int playId,
      required int positionIndex,
      Value<int?> personId,
    });
typedef $$LineupSlotsTableUpdateCompanionBuilder =
    LineupSlotsCompanion Function({
      Value<int> id,
      Value<int> playId,
      Value<int> positionIndex,
      Value<int?> personId,
    });

final class $$LineupSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $LineupSlotsTable, LineupSlot> {
  $$LineupSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlaysTable _playIdTable(_$AppDatabase db) =>
      db.plays.createAlias('lineup_slots__play_id__plays__id');

  $$PlaysTableProcessedTableManager get playId {
    final $_column = $_itemColumn<int>('play_id')!;

    final manager = $$PlaysTableTableManager(
      $_db,
      $_db.plays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersonsTable _personIdTable(_$AppDatabase db) =>
      db.persons.createAlias('lineup_slots__person_id__persons__id');

  $$PersonsTableProcessedTableManager? get personId {
    final $_column = $_itemColumn<int>('person_id');
    if ($_column == null) return null;
    final manager = $$PersonsTableTableManager(
      $_db,
      $_db.persons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LineupSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $LineupSlotsTable> {
  $$LineupSlotsTableFilterComposer({
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

  ColumnFilters<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$PlaysTableFilterComposer get playId {
    final $$PlaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playId,
      referencedTable: $db.plays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaysTableFilterComposer(
            $db: $db,
            $table: $db.plays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineupSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $LineupSlotsTable> {
  $$LineupSlotsTableOrderingComposer({
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

  ColumnOrderings<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlaysTableOrderingComposer get playId {
    final $$PlaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playId,
      referencedTable: $db.plays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaysTableOrderingComposer(
            $db: $db,
            $table: $db.plays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableOrderingComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineupSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LineupSlotsTable> {
  $$LineupSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => column,
  );

  $$PlaysTableAnnotationComposer get playId {
    final $$PlaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playId,
      referencedTable: $db.plays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaysTableAnnotationComposer(
            $db: $db,
            $table: $db.plays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personId,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LineupSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LineupSlotsTable,
          LineupSlot,
          $$LineupSlotsTableFilterComposer,
          $$LineupSlotsTableOrderingComposer,
          $$LineupSlotsTableAnnotationComposer,
          $$LineupSlotsTableCreateCompanionBuilder,
          $$LineupSlotsTableUpdateCompanionBuilder,
          (LineupSlot, $$LineupSlotsTableReferences),
          LineupSlot,
          PrefetchHooks Function({bool playId, bool personId})
        > {
  $$LineupSlotsTableTableManager(_$AppDatabase db, $LineupSlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LineupSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LineupSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LineupSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playId = const Value.absent(),
                Value<int> positionIndex = const Value.absent(),
                Value<int?> personId = const Value.absent(),
              }) => LineupSlotsCompanion(
                id: id,
                playId: playId,
                positionIndex: positionIndex,
                personId: personId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int playId,
                required int positionIndex,
                Value<int?> personId = const Value.absent(),
              }) => LineupSlotsCompanion.insert(
                id: id,
                playId: playId,
                positionIndex: positionIndex,
                personId: personId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LineupSlotsTable, LineupSlot>(table),
                  $$LineupSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playId = false, personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (playId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.playId,
                        referencedTable: $$LineupSlotsTableReferences
                            ._playIdTable(db),
                        referencedColumn: $$LineupSlotsTableReferences
                            ._playIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$LineupSlotsTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$LineupSlotsTableReferences
                            ._personIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LineupSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LineupSlotsTable,
      LineupSlot,
      $$LineupSlotsTableFilterComposer,
      $$LineupSlotsTableOrderingComposer,
      $$LineupSlotsTableAnnotationComposer,
      $$LineupSlotsTableCreateCompanionBuilder,
      $$LineupSlotsTableUpdateCompanionBuilder,
      (LineupSlot, $$LineupSlotsTableReferences),
      LineupSlot,
      PrefetchHooks Function({bool playId, bool personId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
  $$PersonPositionsTableTableManager get personPositions =>
      $$PersonPositionsTableTableManager(_db, _db.personPositions);
  $$PlaysTableTableManager get plays =>
      $$PlaysTableTableManager(_db, _db.plays);
  $$LineupSlotsTableTableManager get lineupSlots =>
      $$LineupSlotsTableTableManager(_db, _db.lineupSlots);
}
