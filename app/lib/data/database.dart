import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'database.g.dart';

/// Mirrors `Person.status` from the Python prototype (`algorithm.py`).
class Persons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isOut => boolean().withDefault(const Constant(false))();
}

/// Mirrors `Person.pos` (which positions a person is eligible for).
class PersonPositions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId =>
      integer().references(Persons, #id, onDelete: KeyAction.cascade)();
  IntColumn get positionIndex => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {personId, positionIndex},
      ];
}

/// A single kick play, e.g. category "KC", name "左sabel_α".
class Plays extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  TextColumn get name => text()();
}

/// Current manual (drag-and-drop) lineup assignment per play.
/// Mirrors the Python prototype's `fixed_list`.
class LineupSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playId =>
      integer().references(Plays, #id, onDelete: KeyAction.cascade)();
  IntColumn get positionIndex => integer()();
  IntColumn get personId =>
      integer().nullable().references(Persons, #id, onDelete: KeyAction.setNull)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {playId, positionIndex},
      ];
}

@DriftDatabase(tables: [Persons, PersonPositions, Plays, LineupSlots])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(driftDatabase(
          name: 'kick_members',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ));
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  Stream<List<Person>> watchAllPersons() => select(persons).watch();

  Stream<List<int>> watchPositionsForPerson(int personId) {
    final query = select(personPositions)
      ..where((t) => t.personId.equals(personId));
    return query
        .watch()
        .map((rows) => rows.map((r) => r.positionIndex).toList());
  }

  /// All persons' eligible positions at once, keyed by personId, for
  /// screens that need to render the whole roster together.
  Stream<Map<int, Set<int>>> watchAllPersonPositions() {
    return select(personPositions).watch().map((rows) {
      final map = <int, Set<int>>{};
      for (final row in rows) {
        map.putIfAbsent(row.personId, () => {}).add(row.positionIndex);
      }
      return map;
    });
  }

  Future<void> setPersonOut(int personId, bool isOut) {
    return (update(persons)..where((t) => t.id.equals(personId)))
        .write(PersonsCompanion(isOut: Value(isOut)));
  }

  /// Replaces the full set of eligible positions for a person.
  Future<void> setPersonPositions(int personId, Set<int> positionIndexes) {
    return transaction(() async {
      await (delete(personPositions)
            ..where((t) => t.personId.equals(personId)))
          .go();
      for (final pos in positionIndexes) {
        await into(personPositions).insert(
          PersonPositionsCompanion.insert(personId: personId, positionIndex: pos),
        );
      }
    });
  }

  Future<Play> firstPlay() async {
    final existing = await select(plays).getSingleOrNull();
    if (existing != null) return existing;
    final id = await into(plays).insert(
      PlaysCompanion.insert(category: 'KC', name: '左sabel_α'),
    );
    return (select(plays)..where((t) => t.id.equals(id))).getSingle();
  }

  Stream<List<LineupSlot>> watchLineupSlots(int playId) {
    final query = select(lineupSlots)
      ..where((t) => t.playId.equals(playId));
    return query.watch();
  }

  Future<void> assignSlot(int playId, int positionIndex, int? personId) {
    final companion = LineupSlotsCompanion.insert(
      playId: playId,
      positionIndex: positionIndex,
      personId: Value(personId),
    );
    return into(lineupSlots).insert(
      companion,
      onConflict: DoUpdate(
        (_) => companion,
        target: [lineupSlots.playId, lineupSlots.positionIndex],
      ),
    );
  }

  /// Loads the bundled `data.json` seed roster (11 persons matching the
  /// 11 positions) the first time the database is empty. Safe to call on
  /// every app start; it no-ops once persons already exist.
  Future<void> seedIfEmpty() async {
    final hasAny = await select(persons).get().then((rows) => rows.isNotEmpty);
    if (hasAny) return;

    final raw = await rootBundle.loadString('assets/seed/data.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final personsJson = data['Persons'] as Map<String, dynamic>;

    await transaction(() async {
      for (final entry in personsJson.entries) {
        final name = entry.key;
        final info = entry.value as Map<String, dynamic>;
        final isOut = !(info['status'] as bool);
        final posList = (info['pos'] as List<dynamic>).cast<int>();

        final personId = await into(persons).insert(
          PersonsCompanion.insert(name: name, isOut: Value(isOut)),
        );
        for (final pos in posList) {
          await into(personPositions).insert(
            PersonPositionsCompanion.insert(
              personId: personId,
              positionIndex: pos,
            ),
          );
        }
      }
    });
  }
}
