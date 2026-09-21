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

  /// 期 (cohort/generation number), e.g. 1, 2, 3.
  IntColumn get gen => integer().nullable()();

  /// Whether this person is a guest rather than a regular member.
  BoolColumn get guest => boolean().withDefault(const Constant(false))();
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

/// Left-bottom board area: the algorithm/coach-picked starting lineup.
/// Same shape as [LineupSlots] (one row per position per play).
class MainMembers extends Table {
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

/// Right-bottom board area: substitutes lined up behind each position.
/// Unlike [LineupSlots]/[MainMembers], a position can hold several people
/// at once, so this is one row per (play, position, person) triple rather
/// than one row per position.
class SubMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playId =>
      integer().references(Plays, #id, onDelete: KeyAction.cascade)();
  IntColumn get positionIndex => integer()();
  IntColumn get personId =>
      integer().references(Persons, #id, onDelete: KeyAction.cascade)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {playId, positionIndex, personId},
      ];
}

/// A named snapshot of a play's full board (lineup + main + sub), e.g.
/// "通常" or "緊急用", switchable from the board screen.
class LineupTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playId =>
      integer().references(Plays, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {playId, name},
      ];
}

/// One position's assignment within a [LineupTemplates] snapshot, for one
/// of the three board areas ('fixed', 'main', 'sub'). 'fixed'/'main' store
/// exactly one row per position (`personId` null means "unassigned"); 'sub'
/// may store several rows for the same position, one per assigned person.
class LineupTemplateSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateId =>
      integer().references(LineupTemplates, #id, onDelete: KeyAction.cascade)();
  TextColumn get area => text()();
  IntColumn get positionIndex => integer()();
  IntColumn get personId =>
      integer().nullable().references(Persons, #id, onDelete: KeyAction.setNull)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {templateId, area, positionIndex, personId},
      ];
}

@DriftDatabase(tables: [
  Persons,
  PersonPositions,
  Plays,
  LineupSlots,
  MainMembers,
  SubMembers,
  LineupTemplates,
  LineupTemplateSlots,
])
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
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(persons, persons.gen);
          }
          if (from < 3) {
            await m.createTable(mainMembers);
            await m.createTable(subMembers);
          }
          if (from < 4) {
            await m.createTable(lineupTemplates);
            await m.createTable(lineupTemplateSlots);
          }
          if (from < 5) {
            // sub_members now allows several rows per position (personId
            // is no longer nullable, and the unique key now includes it),
            // and lineup_template_slots needs the same relaxed uniqueness
            // for the 'sub' area — recreate both from scratch.
            await m.deleteTable(subMembers.actualTableName);
            await m.createTable(subMembers);
            await m.deleteTable(lineupTemplateSlots.actualTableName);
            await m.createTable(lineupTemplateSlots);
          }
          if (from < 6) {
            await m.addColumn(persons, persons.guest);
          }
        },
      );

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

  Future<int> addPerson(String name) {
    return into(persons).insert(PersonsCompanion.insert(name: name));
  }

  /// Deletes a person and all data that depends on them: their
  /// `PersonPositions` rows cascade-delete, and any `LineupSlots` they
  /// occupy are cleared (personId set to null) via the table's FK actions.
  Future<void> deletePerson(int personId) {
    return (delete(persons)..where((t) => t.id.equals(personId))).go();
  }

  Future<void> setPersonOut(int personId, bool isOut) {
    return (update(persons)..where((t) => t.id.equals(personId)))
        .write(PersonsCompanion(isOut: Value(isOut)));
  }

  Future<void> setPersonName(int personId, String name) {
    return (update(persons)..where((t) => t.id.equals(personId)))
        .write(PersonsCompanion(name: Value(name)));
  }

  Future<void> setPersonGen(int personId, int? gen) {
    return (update(persons)..where((t) => t.id.equals(personId)))
        .write(PersonsCompanion(gen: Value(gen)));
  }

  Future<void> setPersonGuest(int personId, bool guest) {
    return (update(persons)..where((t) => t.id.equals(personId)))
        .write(PersonsCompanion(guest: Value(guest)));
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

  Stream<List<MainMember>> watchMainMembers(int playId) {
    final query = select(mainMembers)
      ..where((t) => t.playId.equals(playId));
    return query.watch();
  }

  Future<void> assignMainMember(int playId, int positionIndex, int? personId) {
    final companion = MainMembersCompanion.insert(
      playId: playId,
      positionIndex: positionIndex,
      personId: Value(personId),
    );
    return into(mainMembers).insert(
      companion,
      onConflict: DoUpdate(
        (_) => companion,
        target: [mainMembers.playId, mainMembers.positionIndex],
      ),
    );
  }

  Stream<List<SubMember>> watchSubMembers(int playId) {
    final query = select(subMembers)
      ..where((t) => t.playId.equals(playId));
    return query.watch();
  }

  /// Adds a person to a sub-members position's set. A no-op if that person
  /// is already assigned there.
  Future<void> addSubMember(int playId, int positionIndex, int personId) {
    return into(subMembers).insert(
      SubMembersCompanion.insert(
        playId: playId,
        positionIndex: positionIndex,
        personId: personId,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  /// Removes one person from a sub-members position's set.
  Future<void> removeSubMember(int playId, int positionIndex, int personId) {
    return (delete(subMembers)
          ..where((t) =>
              t.playId.equals(playId) &
              t.positionIndex.equals(positionIndex) &
              t.personId.equals(personId)))
        .go();
  }

  Stream<List<LineupTemplate>> watchTemplates(int playId) {
    final query = select(lineupTemplates)
      ..where((t) => t.playId.equals(playId));
    return query.watch();
  }

  /// Saves (or overwrites, if [name] already exists for this play) the
  /// given board snapshot as a named template. [fixed]/[main] should cover
  /// every position index for their area, with `null` meaning "unassigned".
  /// [sub] maps position index to the (possibly empty) set of assigned
  /// person ids.
  Future<void> saveTemplate(
    int playId,
    String name, {
    required Map<int, int?> fixed,
    required Map<int, int?> main,
    required Map<int, Set<int>> sub,
  }) async {
    await transaction(() async {
      final existing = await (select(lineupTemplates)
            ..where((t) => t.playId.equals(playId) & t.name.equals(name)))
          .getSingleOrNull();
      final templateId = existing?.id ??
          await into(lineupTemplates).insert(
            LineupTemplatesCompanion.insert(playId: playId, name: name),
          );
      if (existing != null) {
        await (delete(lineupTemplateSlots)
              ..where((t) => t.templateId.equals(templateId)))
            .go();
      }

      for (final entry in fixed.entries) {
        await into(lineupTemplateSlots).insert(
          LineupTemplateSlotsCompanion.insert(
            templateId: templateId,
            area: 'fixed',
            positionIndex: entry.key,
            personId: Value(entry.value),
          ),
        );
      }
      for (final entry in main.entries) {
        await into(lineupTemplateSlots).insert(
          LineupTemplateSlotsCompanion.insert(
            templateId: templateId,
            area: 'main',
            positionIndex: entry.key,
            personId: Value(entry.value),
          ),
        );
      }
      for (final entry in sub.entries) {
        for (final personId in entry.value) {
          await into(lineupTemplateSlots).insert(
            LineupTemplateSlotsCompanion.insert(
              templateId: templateId,
              area: 'sub',
              positionIndex: entry.key,
              personId: Value(personId),
            ),
          );
        }
      }
    });
  }

  /// Overwrites the play's current board with a previously saved template.
  Future<void> applyTemplate(int playId, int templateId) async {
    final slots = await (select(lineupTemplateSlots)
          ..where((t) => t.templateId.equals(templateId)))
        .get();
    await transaction(() async {
      // Sub members allow several people per position, so a plain upsert
      // per slot can't clear people the template doesn't include; start
      // from a clean slate for that area instead.
      await (delete(subMembers)..where((t) => t.playId.equals(playId))).go();
      for (final slot in slots) {
        switch (slot.area) {
          case 'fixed':
            await assignSlot(playId, slot.positionIndex, slot.personId);
            break;
          case 'main':
            await assignMainMember(playId, slot.positionIndex, slot.personId);
            break;
          case 'sub':
            if (slot.personId != null) {
              await addSubMember(playId, slot.positionIndex, slot.personId!);
            }
            break;
        }
      }
    });
  }

  /// Renames a saved template. Throws if [newName] collides with another
  /// template already saved for the same play.
  Future<void> renameTemplate(int templateId, String newName) {
    return (update(lineupTemplates)..where((t) => t.id.equals(templateId)))
        .write(LineupTemplatesCompanion(name: Value(newName)));
  }

  /// Deletes a template; its [LineupTemplateSlots] rows cascade-delete.
  Future<void> deleteTemplate(int templateId) {
    return (delete(lineupTemplates)..where((t) => t.id.equals(templateId))).go();
  }

  /// Clears every assignment on the board (Lineup, Main members and Sub
  /// members) for a play.
  Future<void> clearBoard(int playId) async {
    await transaction(() async {
      await (delete(lineupSlots)..where((t) => t.playId.equals(playId))).go();
      await (delete(mainMembers)..where((t) => t.playId.equals(playId))).go();
      await (delete(subMembers)..where((t) => t.playId.equals(playId))).go();
    });
  }

  /// Overwrites the whole Lineup (fixed_list) with [lineup], one personId
  /// (or `null` for unassigned) per position index.
  Future<void> applyLineup(int playId, List<int?> lineup) async {
    await transaction(() async {
      for (var i = 0; i < lineup.length; i++) {
        await assignSlot(playId, i, lineup[i]);
      }
    });
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
