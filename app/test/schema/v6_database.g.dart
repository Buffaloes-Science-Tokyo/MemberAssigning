// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v6_database.dart';

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
  static const VerificationMeta _genMeta = const VerificationMeta('gen');
  @override
  late final GeneratedColumn<int> gen = GeneratedColumn<int>(
    'gen',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guestMeta = const VerificationMeta('guest');
  @override
  late final GeneratedColumn<bool> guest = GeneratedColumn<bool>(
    'guest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("guest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isOut, gen, guest];
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
    if (data.containsKey('gen')) {
      context.handle(
        _genMeta,
        gen.isAcceptableOrUnknown(data['gen']!, _genMeta),
      );
    }
    if (data.containsKey('guest')) {
      context.handle(
        _guestMeta,
        guest.isAcceptableOrUnknown(data['guest']!, _guestMeta),
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
      gen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gen'],
      ),
      guest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}guest'],
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

  /// 期 (cohort/generation number), e.g. 1, 2, 3.
  final int? gen;

  /// Whether this person is a guest rather than a regular member.
  final bool guest;
  const Person({
    required this.id,
    required this.name,
    required this.isOut,
    this.gen,
    required this.guest,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_out'] = Variable<bool>(isOut);
    if (!nullToAbsent || gen != null) {
      map['gen'] = Variable<int>(gen);
    }
    map['guest'] = Variable<bool>(guest);
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      id: Value(id),
      name: Value(name),
      isOut: Value(isOut),
      gen: gen == null && nullToAbsent ? const Value.absent() : Value(gen),
      guest: Value(guest),
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
      gen: serializer.fromJson<int?>(json['gen']),
      guest: serializer.fromJson<bool>(json['guest']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isOut': serializer.toJson<bool>(isOut),
      'gen': serializer.toJson<int?>(gen),
      'guest': serializer.toJson<bool>(guest),
    };
  }

  Person copyWith({
    int? id,
    String? name,
    bool? isOut,
    Value<int?> gen = const Value.absent(),
    bool? guest,
  }) => Person(
    id: id ?? this.id,
    name: name ?? this.name,
    isOut: isOut ?? this.isOut,
    gen: gen.present ? gen.value : this.gen,
    guest: guest ?? this.guest,
  );
  Person copyWithCompanion(PersonsCompanion data) {
    return Person(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isOut: data.isOut.present ? data.isOut.value : this.isOut,
      gen: data.gen.present ? data.gen.value : this.gen,
      guest: data.guest.present ? data.guest.value : this.guest,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isOut: $isOut, ')
          ..write('gen: $gen, ')
          ..write('guest: $guest')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isOut, gen, guest);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.name == this.name &&
          other.isOut == this.isOut &&
          other.gen == this.gen &&
          other.guest == this.guest);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isOut;
  final Value<int?> gen;
  final Value<bool> guest;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isOut = const Value.absent(),
    this.gen = const Value.absent(),
    this.guest = const Value.absent(),
  });
  PersonsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isOut = const Value.absent(),
    this.gen = const Value.absent(),
    this.guest = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Person> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isOut,
    Expression<int>? gen,
    Expression<bool>? guest,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isOut != null) 'is_out': isOut,
      if (gen != null) 'gen': gen,
      if (guest != null) 'guest': guest,
    });
  }

  PersonsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isOut,
    Value<int?>? gen,
    Value<bool>? guest,
  }) {
    return PersonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isOut: isOut ?? this.isOut,
      gen: gen ?? this.gen,
      guest: guest ?? this.guest,
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
    if (gen.present) {
      map['gen'] = Variable<int>(gen.value);
    }
    if (guest.present) {
      map['guest'] = Variable<bool>(guest.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isOut: $isOut, ')
          ..write('gen: $gen, ')
          ..write('guest: $guest')
          ..write(')'))
        .toString();
  }
}

class $PersonPositionsV6Table extends PersonPositionsV6
    with TableInfo<$PersonPositionsV6Table, PersonPositionsV6Data> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonPositionsV6Table(this.attachedDatabase, [this._alias]);
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
    Insertable<PersonPositionsV6Data> instance, {
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
  PersonPositionsV6Data map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonPositionsV6Data(
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
  $PersonPositionsV6Table createAlias(String alias) {
    return $PersonPositionsV6Table(attachedDatabase, alias);
  }
}

class PersonPositionsV6Data extends DataClass
    implements Insertable<PersonPositionsV6Data> {
  final int id;
  final int personId;
  final int positionIndex;
  const PersonPositionsV6Data({
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

  PersonPositionsV6Companion toCompanion(bool nullToAbsent) {
    return PersonPositionsV6Companion(
      id: Value(id),
      personId: Value(personId),
      positionIndex: Value(positionIndex),
    );
  }

  factory PersonPositionsV6Data.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonPositionsV6Data(
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

  PersonPositionsV6Data copyWith({
    int? id,
    int? personId,
    int? positionIndex,
  }) => PersonPositionsV6Data(
    id: id ?? this.id,
    personId: personId ?? this.personId,
    positionIndex: positionIndex ?? this.positionIndex,
  );
  PersonPositionsV6Data copyWithCompanion(PersonPositionsV6Companion data) {
    return PersonPositionsV6Data(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      positionIndex: data.positionIndex.present
          ? data.positionIndex.value
          : this.positionIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonPositionsV6Data(')
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
      (other is PersonPositionsV6Data &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.positionIndex == this.positionIndex);
}

class PersonPositionsV6Companion
    extends UpdateCompanion<PersonPositionsV6Data> {
  final Value<int> id;
  final Value<int> personId;
  final Value<int> positionIndex;
  const PersonPositionsV6Companion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.positionIndex = const Value.absent(),
  });
  PersonPositionsV6Companion.insert({
    this.id = const Value.absent(),
    required int personId,
    required int positionIndex,
  }) : personId = Value(personId),
       positionIndex = Value(positionIndex);
  static Insertable<PersonPositionsV6Data> custom({
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

  PersonPositionsV6Companion copyWith({
    Value<int>? id,
    Value<int>? personId,
    Value<int>? positionIndex,
  }) {
    return PersonPositionsV6Companion(
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
    return (StringBuffer('PersonPositionsV6Companion(')
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

class $MainMembersTable extends MainMembers
    with TableInfo<$MainMembersTable, MainMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MainMembersTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'main_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<MainMember> instance, {
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
  MainMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MainMember(
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
  $MainMembersTable createAlias(String alias) {
    return $MainMembersTable(attachedDatabase, alias);
  }
}

class MainMember extends DataClass implements Insertable<MainMember> {
  final int id;
  final int playId;
  final int positionIndex;
  final int? personId;
  const MainMember({
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

  MainMembersCompanion toCompanion(bool nullToAbsent) {
    return MainMembersCompanion(
      id: Value(id),
      playId: Value(playId),
      positionIndex: Value(positionIndex),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
    );
  }

  factory MainMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MainMember(
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

  MainMember copyWith({
    int? id,
    int? playId,
    int? positionIndex,
    Value<int?> personId = const Value.absent(),
  }) => MainMember(
    id: id ?? this.id,
    playId: playId ?? this.playId,
    positionIndex: positionIndex ?? this.positionIndex,
    personId: personId.present ? personId.value : this.personId,
  );
  MainMember copyWithCompanion(MainMembersCompanion data) {
    return MainMember(
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
    return (StringBuffer('MainMember(')
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
      (other is MainMember &&
          other.id == this.id &&
          other.playId == this.playId &&
          other.positionIndex == this.positionIndex &&
          other.personId == this.personId);
}

class MainMembersCompanion extends UpdateCompanion<MainMember> {
  final Value<int> id;
  final Value<int> playId;
  final Value<int> positionIndex;
  final Value<int?> personId;
  const MainMembersCompanion({
    this.id = const Value.absent(),
    this.playId = const Value.absent(),
    this.positionIndex = const Value.absent(),
    this.personId = const Value.absent(),
  });
  MainMembersCompanion.insert({
    this.id = const Value.absent(),
    required int playId,
    required int positionIndex,
    this.personId = const Value.absent(),
  }) : playId = Value(playId),
       positionIndex = Value(positionIndex);
  static Insertable<MainMember> custom({
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

  MainMembersCompanion copyWith({
    Value<int>? id,
    Value<int>? playId,
    Value<int>? positionIndex,
    Value<int?>? personId,
  }) {
    return MainMembersCompanion(
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
    return (StringBuffer('MainMembersCompanion(')
          ..write('id: $id, ')
          ..write('playId: $playId, ')
          ..write('positionIndex: $positionIndex, ')
          ..write('personId: $personId')
          ..write(')'))
        .toString();
  }
}

class $SubMembersTable extends SubMembers
    with TableInfo<$SubMembersTable, SubMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubMembersTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES persons (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, playId, positionIndex, personId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sub_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubMember> instance, {
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
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {playId, positionIndex, personId},
  ];
  @override
  SubMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubMember(
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
      )!,
    );
  }

  @override
  $SubMembersTable createAlias(String alias) {
    return $SubMembersTable(attachedDatabase, alias);
  }
}

class SubMember extends DataClass implements Insertable<SubMember> {
  final int id;
  final int playId;
  final int positionIndex;
  final int personId;
  const SubMember({
    required this.id,
    required this.playId,
    required this.positionIndex,
    required this.personId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['play_id'] = Variable<int>(playId);
    map['position_index'] = Variable<int>(positionIndex);
    map['person_id'] = Variable<int>(personId);
    return map;
  }

  SubMembersCompanion toCompanion(bool nullToAbsent) {
    return SubMembersCompanion(
      id: Value(id),
      playId: Value(playId),
      positionIndex: Value(positionIndex),
      personId: Value(personId),
    );
  }

  factory SubMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubMember(
      id: serializer.fromJson<int>(json['id']),
      playId: serializer.fromJson<int>(json['playId']),
      positionIndex: serializer.fromJson<int>(json['positionIndex']),
      personId: serializer.fromJson<int>(json['personId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playId': serializer.toJson<int>(playId),
      'positionIndex': serializer.toJson<int>(positionIndex),
      'personId': serializer.toJson<int>(personId),
    };
  }

  SubMember copyWith({
    int? id,
    int? playId,
    int? positionIndex,
    int? personId,
  }) => SubMember(
    id: id ?? this.id,
    playId: playId ?? this.playId,
    positionIndex: positionIndex ?? this.positionIndex,
    personId: personId ?? this.personId,
  );
  SubMember copyWithCompanion(SubMembersCompanion data) {
    return SubMember(
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
    return (StringBuffer('SubMember(')
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
      (other is SubMember &&
          other.id == this.id &&
          other.playId == this.playId &&
          other.positionIndex == this.positionIndex &&
          other.personId == this.personId);
}

class SubMembersCompanion extends UpdateCompanion<SubMember> {
  final Value<int> id;
  final Value<int> playId;
  final Value<int> positionIndex;
  final Value<int> personId;
  const SubMembersCompanion({
    this.id = const Value.absent(),
    this.playId = const Value.absent(),
    this.positionIndex = const Value.absent(),
    this.personId = const Value.absent(),
  });
  SubMembersCompanion.insert({
    this.id = const Value.absent(),
    required int playId,
    required int positionIndex,
    required int personId,
  }) : playId = Value(playId),
       positionIndex = Value(positionIndex),
       personId = Value(personId);
  static Insertable<SubMember> custom({
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

  SubMembersCompanion copyWith({
    Value<int>? id,
    Value<int>? playId,
    Value<int>? positionIndex,
    Value<int>? personId,
  }) {
    return SubMembersCompanion(
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
    return (StringBuffer('SubMembersCompanion(')
          ..write('id: $id, ')
          ..write('playId: $playId, ')
          ..write('positionIndex: $positionIndex, ')
          ..write('personId: $personId')
          ..write(')'))
        .toString();
  }
}

class $LineupTemplatesTable extends LineupTemplates
    with TableInfo<$LineupTemplatesTable, LineupTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LineupTemplatesTable(this.attachedDatabase, [this._alias]);
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
  List<GeneratedColumn> get $columns => [id, playId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lineup_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<LineupTemplate> instance, {
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {playId, name},
  ];
  @override
  LineupTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LineupTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}play_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $LineupTemplatesTable createAlias(String alias) {
    return $LineupTemplatesTable(attachedDatabase, alias);
  }
}

class LineupTemplate extends DataClass implements Insertable<LineupTemplate> {
  final int id;
  final int playId;
  final String name;
  const LineupTemplate({
    required this.id,
    required this.playId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['play_id'] = Variable<int>(playId);
    map['name'] = Variable<String>(name);
    return map;
  }

  LineupTemplatesCompanion toCompanion(bool nullToAbsent) {
    return LineupTemplatesCompanion(
      id: Value(id),
      playId: Value(playId),
      name: Value(name),
    );
  }

  factory LineupTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LineupTemplate(
      id: serializer.fromJson<int>(json['id']),
      playId: serializer.fromJson<int>(json['playId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playId': serializer.toJson<int>(playId),
      'name': serializer.toJson<String>(name),
    };
  }

  LineupTemplate copyWith({int? id, int? playId, String? name}) =>
      LineupTemplate(
        id: id ?? this.id,
        playId: playId ?? this.playId,
        name: name ?? this.name,
      );
  LineupTemplate copyWithCompanion(LineupTemplatesCompanion data) {
    return LineupTemplate(
      id: data.id.present ? data.id.value : this.id,
      playId: data.playId.present ? data.playId.value : this.playId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LineupTemplate(')
          ..write('id: $id, ')
          ..write('playId: $playId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineupTemplate &&
          other.id == this.id &&
          other.playId == this.playId &&
          other.name == this.name);
}

class LineupTemplatesCompanion extends UpdateCompanion<LineupTemplate> {
  final Value<int> id;
  final Value<int> playId;
  final Value<String> name;
  const LineupTemplatesCompanion({
    this.id = const Value.absent(),
    this.playId = const Value.absent(),
    this.name = const Value.absent(),
  });
  LineupTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required int playId,
    required String name,
  }) : playId = Value(playId),
       name = Value(name);
  static Insertable<LineupTemplate> custom({
    Expression<int>? id,
    Expression<int>? playId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playId != null) 'play_id': playId,
      if (name != null) 'name': name,
    });
  }

  LineupTemplatesCompanion copyWith({
    Value<int>? id,
    Value<int>? playId,
    Value<String>? name,
  }) {
    return LineupTemplatesCompanion(
      id: id ?? this.id,
      playId: playId ?? this.playId,
      name: name ?? this.name,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LineupTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('playId: $playId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $LineupTemplateSlotsTable extends LineupTemplateSlots
    with TableInfo<$LineupTemplateSlotsTable, LineupTemplateSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LineupTemplateSlotsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lineup_templates (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    area,
    positionIndex,
    personId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lineup_template_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LineupTemplateSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaMeta);
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
    {templateId, area, positionIndex, personId},
  ];
  @override
  LineupTemplateSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LineupTemplateSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
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
  $LineupTemplateSlotsTable createAlias(String alias) {
    return $LineupTemplateSlotsTable(attachedDatabase, alias);
  }
}

class LineupTemplateSlot extends DataClass
    implements Insertable<LineupTemplateSlot> {
  final int id;
  final int templateId;
  final String area;
  final int positionIndex;
  final int? personId;
  const LineupTemplateSlot({
    required this.id,
    required this.templateId,
    required this.area,
    required this.positionIndex,
    this.personId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_id'] = Variable<int>(templateId);
    map['area'] = Variable<String>(area);
    map['position_index'] = Variable<int>(positionIndex);
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<int>(personId);
    }
    return map;
  }

  LineupTemplateSlotsCompanion toCompanion(bool nullToAbsent) {
    return LineupTemplateSlotsCompanion(
      id: Value(id),
      templateId: Value(templateId),
      area: Value(area),
      positionIndex: Value(positionIndex),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
    );
  }

  factory LineupTemplateSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LineupTemplateSlot(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<int>(json['templateId']),
      area: serializer.fromJson<String>(json['area']),
      positionIndex: serializer.fromJson<int>(json['positionIndex']),
      personId: serializer.fromJson<int?>(json['personId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateId': serializer.toJson<int>(templateId),
      'area': serializer.toJson<String>(area),
      'positionIndex': serializer.toJson<int>(positionIndex),
      'personId': serializer.toJson<int?>(personId),
    };
  }

  LineupTemplateSlot copyWith({
    int? id,
    int? templateId,
    String? area,
    int? positionIndex,
    Value<int?> personId = const Value.absent(),
  }) => LineupTemplateSlot(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    area: area ?? this.area,
    positionIndex: positionIndex ?? this.positionIndex,
    personId: personId.present ? personId.value : this.personId,
  );
  LineupTemplateSlot copyWithCompanion(LineupTemplateSlotsCompanion data) {
    return LineupTemplateSlot(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      area: data.area.present ? data.area.value : this.area,
      positionIndex: data.positionIndex.present
          ? data.positionIndex.value
          : this.positionIndex,
      personId: data.personId.present ? data.personId.value : this.personId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LineupTemplateSlot(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('area: $area, ')
          ..write('positionIndex: $positionIndex, ')
          ..write('personId: $personId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, templateId, area, positionIndex, personId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LineupTemplateSlot &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.area == this.area &&
          other.positionIndex == this.positionIndex &&
          other.personId == this.personId);
}

class LineupTemplateSlotsCompanion extends UpdateCompanion<LineupTemplateSlot> {
  final Value<int> id;
  final Value<int> templateId;
  final Value<String> area;
  final Value<int> positionIndex;
  final Value<int?> personId;
  const LineupTemplateSlotsCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.area = const Value.absent(),
    this.positionIndex = const Value.absent(),
    this.personId = const Value.absent(),
  });
  LineupTemplateSlotsCompanion.insert({
    this.id = const Value.absent(),
    required int templateId,
    required String area,
    required int positionIndex,
    this.personId = const Value.absent(),
  }) : templateId = Value(templateId),
       area = Value(area),
       positionIndex = Value(positionIndex);
  static Insertable<LineupTemplateSlot> custom({
    Expression<int>? id,
    Expression<int>? templateId,
    Expression<String>? area,
    Expression<int>? positionIndex,
    Expression<int>? personId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (area != null) 'area': area,
      if (positionIndex != null) 'position_index': positionIndex,
      if (personId != null) 'person_id': personId,
    });
  }

  LineupTemplateSlotsCompanion copyWith({
    Value<int>? id,
    Value<int>? templateId,
    Value<String>? area,
    Value<int>? positionIndex,
    Value<int?>? personId,
  }) {
    return LineupTemplateSlotsCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      area: area ?? this.area,
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
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
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
    return (StringBuffer('LineupTemplateSlotsCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('area: $area, ')
          ..write('positionIndex: $positionIndex, ')
          ..write('personId: $personId')
          ..write(')'))
        .toString();
  }
}

abstract class _$V6Database extends GeneratedDatabase {
  _$V6Database(QueryExecutor e) : super(e);
  $V6DatabaseManager get managers => $V6DatabaseManager(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $PersonPositionsV6Table personPositionsV6 =
      $PersonPositionsV6Table(this);
  late final $PlaysTable plays = $PlaysTable(this);
  late final $LineupSlotsTable lineupSlots = $LineupSlotsTable(this);
  late final $MainMembersTable mainMembers = $MainMembersTable(this);
  late final $SubMembersTable subMembers = $SubMembersTable(this);
  late final $LineupTemplatesTable lineupTemplates = $LineupTemplatesTable(
    this,
  );
  late final $LineupTemplateSlotsTable lineupTemplateSlots =
      $LineupTemplateSlotsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    persons,
    personPositionsV6,
    plays,
    lineupSlots,
    mainMembers,
    subMembers,
    lineupTemplates,
    lineupTemplateSlots,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plays',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('main_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'persons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('main_members', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plays',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sub_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'persons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sub_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plays',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lineup_templates', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lineup_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lineup_template_slots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'persons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lineup_template_slots', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$PersonsTableCreateCompanionBuilder = PersonsCompanion Function({
  Value<int> id,
  required String name,
  Value<bool> isOut,
  Value<int?> gen,
  Value<bool> guest,
});
typedef $$PersonsTableUpdateCompanionBuilder = PersonsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<bool> isOut,
  Value<int?> gen,
  Value<bool> guest,
});

final class $$PersonsTableReferences
    extends BaseReferences<_$V6Database, $PersonsTable, Person> {
  $$PersonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $PersonPositionsV6Table,
    List<PersonPositionsV6Data>
  >
  _personPositionsV6RefsTable(_$V6Database db) => MultiTypedResultKey.fromTable(
    db.personPositionsV6,
    aliasName: 'persons__id__person_positions__person_id',
  );

  $$PersonPositionsV6TableProcessedTableManager get personPositionsV6Refs {
    final manager = $$PersonPositionsV6TableTableManager(
      $_db,
      $_db.personPositionsV6,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _personPositionsV6RefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LineupSlotsTable, List<LineupSlot>>
  _lineupSlotsRefsTable(_$V6Database db) => MultiTypedResultKey.fromTable(
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

  static MultiTypedResultKey<$MainMembersTable, List<MainMember>>
  _mainMembersRefsTable(_$V6Database db) => MultiTypedResultKey.fromTable(
    db.mainMembers,
    aliasName: 'persons__id__main_members__person_id',
  );

  $$MainMembersTableProcessedTableManager get mainMembersRefs {
    final manager = $$MainMembersTableTableManager(
      $_db,
      $_db.mainMembers,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mainMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubMembersTable, List<SubMember>>
  _subMembersRefsTable(_$V6Database db) => MultiTypedResultKey.fromTable(
    db.subMembers,
    aliasName: 'persons__id__sub_members__person_id',
  );

  $$SubMembersTableProcessedTableManager get subMembersRefs {
    final manager = $$SubMembersTableTableManager(
      $_db,
      $_db.subMembers,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_subMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LineupTemplateSlotsTable,
    List<LineupTemplateSlot>
  >
  _lineupTemplateSlotsRefsTable(_$V6Database db) =>
      MultiTypedResultKey.fromTable(
        db.lineupTemplateSlots,
        aliasName: 'persons__id__lineup_template_slots__person_id',
      );

  $$LineupTemplateSlotsTableProcessedTableManager get lineupTemplateSlotsRefs {
    final manager = $$LineupTemplateSlotsTableTableManager(
      $_db,
      $_db.lineupTemplateSlots,
    ).filter((f) => f.personId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _lineupTemplateSlotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersonsTableFilterComposer
    extends Composer<_$V6Database, $PersonsTable> {
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

  ColumnFilters<int> get gen => $composableBuilder(
    column: $table.gen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get guest => $composableBuilder(
    column: $table.guest,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personPositionsV6Refs(
    Expression<bool> Function($$PersonPositionsV6TableFilterComposer f) f,
  ) {
    final $$PersonPositionsV6TableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personPositionsV6,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonPositionsV6TableFilterComposer(
            $db: $db,
            $table: $db.personPositionsV6,
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

  Expression<bool> mainMembersRefs(
    Expression<bool> Function($$MainMembersTableFilterComposer f) f,
  ) {
    final $$MainMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mainMembers,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MainMembersTableFilterComposer(
            $db: $db,
            $table: $db.mainMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> subMembersRefs(
    Expression<bool> Function($$SubMembersTableFilterComposer f) f,
  ) {
    final $$SubMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subMembers,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubMembersTableFilterComposer(
            $db: $db,
            $table: $db.subMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lineupTemplateSlotsRefs(
    Expression<bool> Function($$LineupTemplateSlotsTableFilterComposer f) f,
  ) {
    final $$LineupTemplateSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupTemplateSlots,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupTemplateSlotsTableFilterComposer(
            $db: $db,
            $table: $db.lineupTemplateSlots,
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
    extends Composer<_$V6Database, $PersonsTable> {
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

  ColumnOrderings<int> get gen => $composableBuilder(
    column: $table.gen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get guest => $composableBuilder(
    column: $table.guest,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$V6Database, $PersonsTable> {
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

  GeneratedColumn<int> get gen =>
      $composableBuilder(column: $table.gen, builder: (column) => column);

  GeneratedColumn<bool> get guest =>
      $composableBuilder(column: $table.guest, builder: (column) => column);

  Expression<T> personPositionsV6Refs<T extends Object>(
    Expression<T> Function($$PersonPositionsV6TableAnnotationComposer a) f,
  ) {
    final $$PersonPositionsV6TableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.personPositionsV6,
          getReferencedColumn: (t) => t.personId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersonPositionsV6TableAnnotationComposer(
                $db: $db,
                $table: $db.personPositionsV6,
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

  Expression<T> mainMembersRefs<T extends Object>(
    Expression<T> Function($$MainMembersTableAnnotationComposer a) f,
  ) {
    final $$MainMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mainMembers,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MainMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.mainMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> subMembersRefs<T extends Object>(
    Expression<T> Function($$SubMembersTableAnnotationComposer a) f,
  ) {
    final $$SubMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subMembers,
      getReferencedColumn: (t) => t.personId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.subMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lineupTemplateSlotsRefs<T extends Object>(
    Expression<T> Function($$LineupTemplateSlotsTableAnnotationComposer a) f,
  ) {
    final $$LineupTemplateSlotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.lineupTemplateSlots,
          getReferencedColumn: (t) => t.personId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LineupTemplateSlotsTableAnnotationComposer(
                $db: $db,
                $table: $db.lineupTemplateSlots,
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
          _$V6Database,
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
            bool personPositionsV6Refs,
            bool lineupSlotsRefs,
            bool mainMembersRefs,
            bool subMembersRefs,
            bool lineupTemplateSlotsRefs,
          })
        > {
  $$PersonsTableTableManager(_$V6Database db, $PersonsTable table)
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
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isOut = const Value.absent(),
                Value<int?> gen = const Value.absent(),
                Value<bool> guest = const Value.absent(),
              }) => PersonsCompanion(
                id: id,
                name: name,
                isOut: isOut,
                gen: gen,
                guest: guest,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isOut = const Value.absent(),
                Value<int?> gen = const Value.absent(),
                Value<bool> guest = const Value.absent(),
              }) => PersonsCompanion.insert(
                id: id,
                name: name,
                isOut: isOut,
                gen: gen,
                guest: guest,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonsTable, Person>(table),
                  $$PersonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                personPositionsV6Refs = false,
                lineupSlotsRefs = false,
                mainMembersRefs = false,
                subMembersRefs = false,
                lineupTemplateSlotsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (personPositionsV6Refs) db.personPositionsV6,
                    if (lineupSlotsRefs) db.lineupSlots,
                    if (mainMembersRefs) db.mainMembers,
                    if (subMembersRefs) db.subMembers,
                    if (lineupTemplateSlotsRefs) db.lineupTemplateSlots,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (personPositionsV6Refs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          PersonPositionsV6Data
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._personPositionsV6RefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).personPositionsV6Refs,
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
                      if (mainMembersRefs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          MainMember
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._mainMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).mainMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (subMembersRefs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          SubMember
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._subMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).subMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lineupTemplateSlotsRefs)
                        await $_getPrefetchedData<
                          Person,
                          $PersonsTable,
                          LineupTemplateSlot
                        >(
                          currentTable: table,
                          referencedTable: $$PersonsTableReferences
                              ._lineupTemplateSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonsTableReferences(
                                db,
                                table,
                                p0,
                              ).lineupTemplateSlotsRefs,
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
      _$V6Database,
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
        bool personPositionsV6Refs,
        bool lineupSlotsRefs,
        bool mainMembersRefs,
        bool subMembersRefs,
        bool lineupTemplateSlotsRefs,
      })
    >;
typedef $$PersonPositionsV6TableCreateCompanionBuilder =
    PersonPositionsV6Companion Function({
      Value<int> id,
      required int personId,
      required int positionIndex,
    });
typedef $$PersonPositionsV6TableUpdateCompanionBuilder =
    PersonPositionsV6Companion Function({
      Value<int> id,
      Value<int> personId,
      Value<int> positionIndex,
    });

final class $$PersonPositionsV6TableReferences
    extends
        BaseReferences<
          _$V6Database,
          $PersonPositionsV6Table,
          PersonPositionsV6Data
        > {
  $$PersonPositionsV6TableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersonsTable _personIdTable(_$V6Database db) =>
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

class $$PersonPositionsV6TableFilterComposer
    extends Composer<_$V6Database, $PersonPositionsV6Table> {
  $$PersonPositionsV6TableFilterComposer({
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

class $$PersonPositionsV6TableOrderingComposer
    extends Composer<_$V6Database, $PersonPositionsV6Table> {
  $$PersonPositionsV6TableOrderingComposer({
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

class $$PersonPositionsV6TableAnnotationComposer
    extends Composer<_$V6Database, $PersonPositionsV6Table> {
  $$PersonPositionsV6TableAnnotationComposer({
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

class $$PersonPositionsV6TableTableManager
    extends
        RootTableManager<
          _$V6Database,
          $PersonPositionsV6Table,
          PersonPositionsV6Data,
          $$PersonPositionsV6TableFilterComposer,
          $$PersonPositionsV6TableOrderingComposer,
          $$PersonPositionsV6TableAnnotationComposer,
          $$PersonPositionsV6TableCreateCompanionBuilder,
          $$PersonPositionsV6TableUpdateCompanionBuilder,
          (PersonPositionsV6Data, $$PersonPositionsV6TableReferences),
          PersonPositionsV6Data,
          PrefetchHooks Function({bool personId})
        > {
  $$PersonPositionsV6TableTableManager(
    _$V6Database db,
    $PersonPositionsV6Table table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonPositionsV6TableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonPositionsV6TableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonPositionsV6TableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> personId = const Value.absent(),
                Value<int> positionIndex = const Value.absent(),
              }) => PersonPositionsV6Companion(
                id: id,
                personId: personId,
                positionIndex: positionIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int personId,
                required int positionIndex,
              }) => PersonPositionsV6Companion.insert(
                id: id,
                personId: personId,
                positionIndex: positionIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonPositionsV6Table, PersonPositionsV6Data>(
                    table,
                  ),
                  $$PersonPositionsV6TableReferences(db, table, e),
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
                        referencedTable: $$PersonPositionsV6TableReferences
                            ._personIdTable(db),
                        referencedColumn: $$PersonPositionsV6TableReferences
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

typedef $$PersonPositionsV6TableProcessedTableManager =
    ProcessedTableManager<
      _$V6Database,
      $PersonPositionsV6Table,
      PersonPositionsV6Data,
      $$PersonPositionsV6TableFilterComposer,
      $$PersonPositionsV6TableOrderingComposer,
      $$PersonPositionsV6TableAnnotationComposer,
      $$PersonPositionsV6TableCreateCompanionBuilder,
      $$PersonPositionsV6TableUpdateCompanionBuilder,
      (PersonPositionsV6Data, $$PersonPositionsV6TableReferences),
      PersonPositionsV6Data,
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
    extends BaseReferences<_$V6Database, $PlaysTable, Play> {
  $$PlaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LineupSlotsTable, List<LineupSlot>>
  _lineupSlotsRefsTable(_$V6Database db) => MultiTypedResultKey.fromTable(
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

  static MultiTypedResultKey<$MainMembersTable, List<MainMember>>
  _mainMembersRefsTable(_$V6Database db) => MultiTypedResultKey.fromTable(
    db.mainMembers,
    aliasName: 'plays__id__main_members__play_id',
  );

  $$MainMembersTableProcessedTableManager get mainMembersRefs {
    final manager = $$MainMembersTableTableManager(
      $_db,
      $_db.mainMembers,
    ).filter((f) => f.playId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mainMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubMembersTable, List<SubMember>>
  _subMembersRefsTable(_$V6Database db) => MultiTypedResultKey.fromTable(
    db.subMembers,
    aliasName: 'plays__id__sub_members__play_id',
  );

  $$SubMembersTableProcessedTableManager get subMembersRefs {
    final manager = $$SubMembersTableTableManager(
      $_db,
      $_db.subMembers,
    ).filter((f) => f.playId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_subMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LineupTemplatesTable, List<LineupTemplate>>
  _lineupTemplatesRefsTable(_$V6Database db) => MultiTypedResultKey.fromTable(
    db.lineupTemplates,
    aliasName: 'plays__id__lineup_templates__play_id',
  );

  $$LineupTemplatesTableProcessedTableManager get lineupTemplatesRefs {
    final manager = $$LineupTemplatesTableTableManager(
      $_db,
      $_db.lineupTemplates,
    ).filter((f) => f.playId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _lineupTemplatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlaysTableFilterComposer extends Composer<_$V6Database, $PlaysTable> {
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

  Expression<bool> mainMembersRefs(
    Expression<bool> Function($$MainMembersTableFilterComposer f) f,
  ) {
    final $$MainMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mainMembers,
      getReferencedColumn: (t) => t.playId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MainMembersTableFilterComposer(
            $db: $db,
            $table: $db.mainMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> subMembersRefs(
    Expression<bool> Function($$SubMembersTableFilterComposer f) f,
  ) {
    final $$SubMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subMembers,
      getReferencedColumn: (t) => t.playId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubMembersTableFilterComposer(
            $db: $db,
            $table: $db.subMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lineupTemplatesRefs(
    Expression<bool> Function($$LineupTemplatesTableFilterComposer f) f,
  ) {
    final $$LineupTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupTemplates,
      getReferencedColumn: (t) => t.playId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.lineupTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaysTableOrderingComposer extends Composer<_$V6Database, $PlaysTable> {
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
    extends Composer<_$V6Database, $PlaysTable> {
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

  Expression<T> mainMembersRefs<T extends Object>(
    Expression<T> Function($$MainMembersTableAnnotationComposer a) f,
  ) {
    final $$MainMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mainMembers,
      getReferencedColumn: (t) => t.playId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MainMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.mainMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> subMembersRefs<T extends Object>(
    Expression<T> Function($$SubMembersTableAnnotationComposer a) f,
  ) {
    final $$SubMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subMembers,
      getReferencedColumn: (t) => t.playId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.subMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lineupTemplatesRefs<T extends Object>(
    Expression<T> Function($$LineupTemplatesTableAnnotationComposer a) f,
  ) {
    final $$LineupTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupTemplates,
      getReferencedColumn: (t) => t.playId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.lineupTemplates,
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
          _$V6Database,
          $PlaysTable,
          Play,
          $$PlaysTableFilterComposer,
          $$PlaysTableOrderingComposer,
          $$PlaysTableAnnotationComposer,
          $$PlaysTableCreateCompanionBuilder,
          $$PlaysTableUpdateCompanionBuilder,
          (Play, $$PlaysTableReferences),
          Play,
          PrefetchHooks Function({
            bool lineupSlotsRefs,
            bool mainMembersRefs,
            bool subMembersRefs,
            bool lineupTemplatesRefs,
          })
        > {
  $$PlaysTableTableManager(_$V6Database db, $PlaysTable table)
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
          prefetchHooksCallback:
              ({
                lineupSlotsRefs = false,
                mainMembersRefs = false,
                subMembersRefs = false,
                lineupTemplatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lineupSlotsRefs) db.lineupSlots,
                    if (mainMembersRefs) db.mainMembers,
                    if (subMembersRefs) db.subMembers,
                    if (lineupTemplatesRefs) db.lineupTemplates,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lineupSlotsRefs)
                        await $_getPrefetchedData<
                          Play,
                          $PlaysTable,
                          LineupSlot
                        >(
                          currentTable: table,
                          referencedTable: $$PlaysTableReferences
                              ._lineupSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlaysTableReferences(
                                db,
                                table,
                                p0,
                              ).lineupSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mainMembersRefs)
                        await $_getPrefetchedData<
                          Play,
                          $PlaysTable,
                          MainMember
                        >(
                          currentTable: table,
                          referencedTable: $$PlaysTableReferences
                              ._mainMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlaysTableReferences(
                                db,
                                table,
                                p0,
                              ).mainMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (subMembersRefs)
                        await $_getPrefetchedData<Play, $PlaysTable, SubMember>(
                          currentTable: table,
                          referencedTable: $$PlaysTableReferences
                              ._subMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlaysTableReferences(
                                db,
                                table,
                                p0,
                              ).subMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lineupTemplatesRefs)
                        await $_getPrefetchedData<
                          Play,
                          $PlaysTable,
                          LineupTemplate
                        >(
                          currentTable: table,
                          referencedTable: $$PlaysTableReferences
                              ._lineupTemplatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlaysTableReferences(
                                db,
                                table,
                                p0,
                              ).lineupTemplatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playId == item.id,
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

typedef $$PlaysTableProcessedTableManager =
    ProcessedTableManager<
      _$V6Database,
      $PlaysTable,
      Play,
      $$PlaysTableFilterComposer,
      $$PlaysTableOrderingComposer,
      $$PlaysTableAnnotationComposer,
      $$PlaysTableCreateCompanionBuilder,
      $$PlaysTableUpdateCompanionBuilder,
      (Play, $$PlaysTableReferences),
      Play,
      PrefetchHooks Function({
        bool lineupSlotsRefs,
        bool mainMembersRefs,
        bool subMembersRefs,
        bool lineupTemplatesRefs,
      })
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
    extends BaseReferences<_$V6Database, $LineupSlotsTable, LineupSlot> {
  $$LineupSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlaysTable _playIdTable(_$V6Database db) =>
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

  static $PersonsTable _personIdTable(_$V6Database db) =>
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
    extends Composer<_$V6Database, $LineupSlotsTable> {
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
    extends Composer<_$V6Database, $LineupSlotsTable> {
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
    extends Composer<_$V6Database, $LineupSlotsTable> {
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
          _$V6Database,
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
  $$LineupSlotsTableTableManager(_$V6Database db, $LineupSlotsTable table)
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
      _$V6Database,
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
typedef $$MainMembersTableCreateCompanionBuilder =
    MainMembersCompanion Function({
      Value<int> id,
      required int playId,
      required int positionIndex,
      Value<int?> personId,
    });
typedef $$MainMembersTableUpdateCompanionBuilder =
    MainMembersCompanion Function({
      Value<int> id,
      Value<int> playId,
      Value<int> positionIndex,
      Value<int?> personId,
    });

final class $$MainMembersTableReferences
    extends BaseReferences<_$V6Database, $MainMembersTable, MainMember> {
  $$MainMembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlaysTable _playIdTable(_$V6Database db) =>
      db.plays.createAlias('main_members__play_id__plays__id');

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

  static $PersonsTable _personIdTable(_$V6Database db) =>
      db.persons.createAlias('main_members__person_id__persons__id');

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

class $$MainMembersTableFilterComposer
    extends Composer<_$V6Database, $MainMembersTable> {
  $$MainMembersTableFilterComposer({
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

class $$MainMembersTableOrderingComposer
    extends Composer<_$V6Database, $MainMembersTable> {
  $$MainMembersTableOrderingComposer({
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

class $$MainMembersTableAnnotationComposer
    extends Composer<_$V6Database, $MainMembersTable> {
  $$MainMembersTableAnnotationComposer({
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

class $$MainMembersTableTableManager
    extends
        RootTableManager<
          _$V6Database,
          $MainMembersTable,
          MainMember,
          $$MainMembersTableFilterComposer,
          $$MainMembersTableOrderingComposer,
          $$MainMembersTableAnnotationComposer,
          $$MainMembersTableCreateCompanionBuilder,
          $$MainMembersTableUpdateCompanionBuilder,
          (MainMember, $$MainMembersTableReferences),
          MainMember,
          PrefetchHooks Function({bool playId, bool personId})
        > {
  $$MainMembersTableTableManager(_$V6Database db, $MainMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MainMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MainMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MainMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playId = const Value.absent(),
                Value<int> positionIndex = const Value.absent(),
                Value<int?> personId = const Value.absent(),
              }) => MainMembersCompanion(
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
              }) => MainMembersCompanion.insert(
                id: id,
                playId: playId,
                positionIndex: positionIndex,
                personId: personId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MainMembersTable, MainMember>(table),
                  $$MainMembersTableReferences(db, table, e),
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
                        referencedTable: $$MainMembersTableReferences
                            ._playIdTable(db),
                        referencedColumn: $$MainMembersTableReferences
                            ._playIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$MainMembersTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$MainMembersTableReferences
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

typedef $$MainMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$V6Database,
      $MainMembersTable,
      MainMember,
      $$MainMembersTableFilterComposer,
      $$MainMembersTableOrderingComposer,
      $$MainMembersTableAnnotationComposer,
      $$MainMembersTableCreateCompanionBuilder,
      $$MainMembersTableUpdateCompanionBuilder,
      (MainMember, $$MainMembersTableReferences),
      MainMember,
      PrefetchHooks Function({bool playId, bool personId})
    >;
typedef $$SubMembersTableCreateCompanionBuilder = SubMembersCompanion Function({
  Value<int> id,
  required int playId,
  required int positionIndex,
  required int personId,
});
typedef $$SubMembersTableUpdateCompanionBuilder = SubMembersCompanion Function({
  Value<int> id,
  Value<int> playId,
  Value<int> positionIndex,
  Value<int> personId,
});

final class $$SubMembersTableReferences
    extends BaseReferences<_$V6Database, $SubMembersTable, SubMember> {
  $$SubMembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlaysTable _playIdTable(_$V6Database db) =>
      db.plays.createAlias('sub_members__play_id__plays__id');

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

  static $PersonsTable _personIdTable(_$V6Database db) =>
      db.persons.createAlias('sub_members__person_id__persons__id');

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

class $$SubMembersTableFilterComposer
    extends Composer<_$V6Database, $SubMembersTable> {
  $$SubMembersTableFilterComposer({
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

class $$SubMembersTableOrderingComposer
    extends Composer<_$V6Database, $SubMembersTable> {
  $$SubMembersTableOrderingComposer({
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

class $$SubMembersTableAnnotationComposer
    extends Composer<_$V6Database, $SubMembersTable> {
  $$SubMembersTableAnnotationComposer({
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

class $$SubMembersTableTableManager
    extends
        RootTableManager<
          _$V6Database,
          $SubMembersTable,
          SubMember,
          $$SubMembersTableFilterComposer,
          $$SubMembersTableOrderingComposer,
          $$SubMembersTableAnnotationComposer,
          $$SubMembersTableCreateCompanionBuilder,
          $$SubMembersTableUpdateCompanionBuilder,
          (SubMember, $$SubMembersTableReferences),
          SubMember,
          PrefetchHooks Function({bool playId, bool personId})
        > {
  $$SubMembersTableTableManager(_$V6Database db, $SubMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playId = const Value.absent(),
                Value<int> positionIndex = const Value.absent(),
                Value<int> personId = const Value.absent(),
              }) => SubMembersCompanion(
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
                required int personId,
              }) => SubMembersCompanion.insert(
                id: id,
                playId: playId,
                positionIndex: positionIndex,
                personId: personId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubMembersTable, SubMember>(table),
                  $$SubMembersTableReferences(db, table, e),
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
                        referencedTable: $$SubMembersTableReferences
                            ._playIdTable(db),
                        referencedColumn: $$SubMembersTableReferences
                            ._playIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$SubMembersTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$SubMembersTableReferences
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

typedef $$SubMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$V6Database,
      $SubMembersTable,
      SubMember,
      $$SubMembersTableFilterComposer,
      $$SubMembersTableOrderingComposer,
      $$SubMembersTableAnnotationComposer,
      $$SubMembersTableCreateCompanionBuilder,
      $$SubMembersTableUpdateCompanionBuilder,
      (SubMember, $$SubMembersTableReferences),
      SubMember,
      PrefetchHooks Function({bool playId, bool personId})
    >;
typedef $$LineupTemplatesTableCreateCompanionBuilder =
    LineupTemplatesCompanion Function({
      Value<int> id,
      required int playId,
      required String name,
    });
typedef $$LineupTemplatesTableUpdateCompanionBuilder =
    LineupTemplatesCompanion Function({
      Value<int> id,
      Value<int> playId,
      Value<String> name,
    });

final class $$LineupTemplatesTableReferences
    extends
        BaseReferences<_$V6Database, $LineupTemplatesTable, LineupTemplate> {
  $$LineupTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlaysTable _playIdTable(_$V6Database db) =>
      db.plays.createAlias('lineup_templates__play_id__plays__id');

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

  static MultiTypedResultKey<
    $LineupTemplateSlotsTable,
    List<LineupTemplateSlot>
  >
  _lineupTemplateSlotsRefsTable(_$V6Database db) =>
      MultiTypedResultKey.fromTable(
        db.lineupTemplateSlots,
        aliasName: 'lineup_templates__id__lineup_template_slots__template_id',
      );

  $$LineupTemplateSlotsTableProcessedTableManager get lineupTemplateSlotsRefs {
    final manager = $$LineupTemplateSlotsTableTableManager(
      $_db,
      $_db.lineupTemplateSlots,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _lineupTemplateSlotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LineupTemplatesTableFilterComposer
    extends Composer<_$V6Database, $LineupTemplatesTable> {
  $$LineupTemplatesTableFilterComposer({
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

  Expression<bool> lineupTemplateSlotsRefs(
    Expression<bool> Function($$LineupTemplateSlotsTableFilterComposer f) f,
  ) {
    final $$LineupTemplateSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lineupTemplateSlots,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupTemplateSlotsTableFilterComposer(
            $db: $db,
            $table: $db.lineupTemplateSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LineupTemplatesTableOrderingComposer
    extends Composer<_$V6Database, $LineupTemplatesTable> {
  $$LineupTemplatesTableOrderingComposer({
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
}

class $$LineupTemplatesTableAnnotationComposer
    extends Composer<_$V6Database, $LineupTemplatesTable> {
  $$LineupTemplatesTableAnnotationComposer({
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

  Expression<T> lineupTemplateSlotsRefs<T extends Object>(
    Expression<T> Function($$LineupTemplateSlotsTableAnnotationComposer a) f,
  ) {
    final $$LineupTemplateSlotsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.lineupTemplateSlots,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LineupTemplateSlotsTableAnnotationComposer(
                $db: $db,
                $table: $db.lineupTemplateSlots,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LineupTemplatesTableTableManager
    extends
        RootTableManager<
          _$V6Database,
          $LineupTemplatesTable,
          LineupTemplate,
          $$LineupTemplatesTableFilterComposer,
          $$LineupTemplatesTableOrderingComposer,
          $$LineupTemplatesTableAnnotationComposer,
          $$LineupTemplatesTableCreateCompanionBuilder,
          $$LineupTemplatesTableUpdateCompanionBuilder,
          (LineupTemplate, $$LineupTemplatesTableReferences),
          LineupTemplate,
          PrefetchHooks Function({bool playId, bool lineupTemplateSlotsRefs})
        > {
  $$LineupTemplatesTableTableManager(
    _$V6Database db,
    $LineupTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LineupTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LineupTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LineupTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> playId = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => LineupTemplatesCompanion(id: id, playId: playId, name: name),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int playId,
                required String name,
              }) => LineupTemplatesCompanion.insert(
                id: id,
                playId: playId,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LineupTemplatesTable, LineupTemplate>(table),
                  $$LineupTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({playId = false, lineupTemplateSlotsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lineupTemplateSlotsRefs) db.lineupTemplateSlots,
                  ],
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
                            referencedTable: $$LineupTemplatesTableReferences
                                ._playIdTable(db),
                            referencedColumn: $$LineupTemplatesTableReferences
                                ._playIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lineupTemplateSlotsRefs)
                        await $_getPrefetchedData<
                          LineupTemplate,
                          $LineupTemplatesTable,
                          LineupTemplateSlot
                        >(
                          currentTable: table,
                          referencedTable: $$LineupTemplatesTableReferences
                              ._lineupTemplateSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LineupTemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).lineupTemplateSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateId == item.id,
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

typedef $$LineupTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$V6Database,
      $LineupTemplatesTable,
      LineupTemplate,
      $$LineupTemplatesTableFilterComposer,
      $$LineupTemplatesTableOrderingComposer,
      $$LineupTemplatesTableAnnotationComposer,
      $$LineupTemplatesTableCreateCompanionBuilder,
      $$LineupTemplatesTableUpdateCompanionBuilder,
      (LineupTemplate, $$LineupTemplatesTableReferences),
      LineupTemplate,
      PrefetchHooks Function({bool playId, bool lineupTemplateSlotsRefs})
    >;
typedef $$LineupTemplateSlotsTableCreateCompanionBuilder =
    LineupTemplateSlotsCompanion Function({
      Value<int> id,
      required int templateId,
      required String area,
      required int positionIndex,
      Value<int?> personId,
    });
typedef $$LineupTemplateSlotsTableUpdateCompanionBuilder =
    LineupTemplateSlotsCompanion Function({
      Value<int> id,
      Value<int> templateId,
      Value<String> area,
      Value<int> positionIndex,
      Value<int?> personId,
    });

final class $$LineupTemplateSlotsTableReferences
    extends
        BaseReferences<
          _$V6Database,
          $LineupTemplateSlotsTable,
          LineupTemplateSlot
        > {
  $$LineupTemplateSlotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LineupTemplatesTable _templateIdTable(_$V6Database db) => db
      .lineupTemplates
      .createAlias('lineup_template_slots__template_id__lineup_templates__id');

  $$LineupTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<int>('template_id')!;

    final manager = $$LineupTemplatesTableTableManager(
      $_db,
      $_db.lineupTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersonsTable _personIdTable(_$V6Database db) =>
      db.persons.createAlias('lineup_template_slots__person_id__persons__id');

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

class $$LineupTemplateSlotsTableFilterComposer
    extends Composer<_$V6Database, $LineupTemplateSlotsTable> {
  $$LineupTemplateSlotsTableFilterComposer({
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

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$LineupTemplatesTableFilterComposer get templateId {
    final $$LineupTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.lineupTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.lineupTemplates,
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

class $$LineupTemplateSlotsTableOrderingComposer
    extends Composer<_$V6Database, $LineupTemplateSlotsTable> {
  $$LineupTemplateSlotsTableOrderingComposer({
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

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$LineupTemplatesTableOrderingComposer get templateId {
    final $$LineupTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.lineupTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.lineupTemplates,
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

class $$LineupTemplateSlotsTableAnnotationComposer
    extends Composer<_$V6Database, $LineupTemplateSlotsTable> {
  $$LineupTemplateSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<int> get positionIndex => $composableBuilder(
    column: $table.positionIndex,
    builder: (column) => column,
  );

  $$LineupTemplatesTableAnnotationComposer get templateId {
    final $$LineupTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.lineupTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LineupTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.lineupTemplates,
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

class $$LineupTemplateSlotsTableTableManager
    extends
        RootTableManager<
          _$V6Database,
          $LineupTemplateSlotsTable,
          LineupTemplateSlot,
          $$LineupTemplateSlotsTableFilterComposer,
          $$LineupTemplateSlotsTableOrderingComposer,
          $$LineupTemplateSlotsTableAnnotationComposer,
          $$LineupTemplateSlotsTableCreateCompanionBuilder,
          $$LineupTemplateSlotsTableUpdateCompanionBuilder,
          (LineupTemplateSlot, $$LineupTemplateSlotsTableReferences),
          LineupTemplateSlot,
          PrefetchHooks Function({bool templateId, bool personId})
        > {
  $$LineupTemplateSlotsTableTableManager(
    _$V6Database db,
    $LineupTemplateSlotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LineupTemplateSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LineupTemplateSlotsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LineupTemplateSlotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> templateId = const Value.absent(),
                Value<String> area = const Value.absent(),
                Value<int> positionIndex = const Value.absent(),
                Value<int?> personId = const Value.absent(),
              }) => LineupTemplateSlotsCompanion(
                id: id,
                templateId: templateId,
                area: area,
                positionIndex: positionIndex,
                personId: personId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int templateId,
                required String area,
                required int positionIndex,
                Value<int?> personId = const Value.absent(),
              }) => LineupTemplateSlotsCompanion.insert(
                id: id,
                templateId: templateId,
                area: area,
                positionIndex: positionIndex,
                personId: personId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LineupTemplateSlotsTable, LineupTemplateSlot>(
                    table,
                  ),
                  $$LineupTemplateSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false, personId = false}) {
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
                    if (templateId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.templateId,
                        referencedTable: $$LineupTemplateSlotsTableReferences
                            ._templateIdTable(db),
                        referencedColumn: $$LineupTemplateSlotsTableReferences
                            ._templateIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (personId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.personId,
                        referencedTable: $$LineupTemplateSlotsTableReferences
                            ._personIdTable(db),
                        referencedColumn: $$LineupTemplateSlotsTableReferences
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

typedef $$LineupTemplateSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$V6Database,
      $LineupTemplateSlotsTable,
      LineupTemplateSlot,
      $$LineupTemplateSlotsTableFilterComposer,
      $$LineupTemplateSlotsTableOrderingComposer,
      $$LineupTemplateSlotsTableAnnotationComposer,
      $$LineupTemplateSlotsTableCreateCompanionBuilder,
      $$LineupTemplateSlotsTableUpdateCompanionBuilder,
      (LineupTemplateSlot, $$LineupTemplateSlotsTableReferences),
      LineupTemplateSlot,
      PrefetchHooks Function({bool templateId, bool personId})
    >;

class $V6DatabaseManager {
  final _$V6Database _db;
  $V6DatabaseManager(this._db);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
  $$PersonPositionsV6TableTableManager get personPositionsV6 =>
      $$PersonPositionsV6TableTableManager(_db, _db.personPositionsV6);
  $$PlaysTableTableManager get plays =>
      $$PlaysTableTableManager(_db, _db.plays);
  $$LineupSlotsTableTableManager get lineupSlots =>
      $$LineupSlotsTableTableManager(_db, _db.lineupSlots);
  $$MainMembersTableTableManager get mainMembers =>
      $$MainMembersTableTableManager(_db, _db.mainMembers);
  $$SubMembersTableTableManager get subMembers =>
      $$SubMembersTableTableManager(_db, _db.subMembers);
  $$LineupTemplatesTableTableManager get lineupTemplates =>
      $$LineupTemplatesTableTableManager(_db, _db.lineupTemplates);
  $$LineupTemplateSlotsTableTableManager get lineupTemplateSlots =>
      $$LineupTemplateSlotsTableTableManager(_db, _db.lineupTemplateSlots);
}
