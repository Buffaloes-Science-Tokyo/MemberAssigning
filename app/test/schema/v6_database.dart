import 'package:drift/drift.dart';
import 'package:kick_members/data/database.dart';

part 'v6_database.g.dart';

/// `PersonPositions` as it was at schema v6, before the `playId` column was
/// added. Reuses [Persons]/[Plays]/etc. from the real schema (unchanged
/// since v6) so the migration test below exercises the real v6→v7 upgrade
/// path against a database that actually has that shape, instead of
/// guessing at hand-written DDL.
class PersonPositionsV6 extends Table {
  @override
  String get tableName => 'person_positions';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId =>
      integer().references(Persons, #id, onDelete: KeyAction.cascade)();
  IntColumn get positionIndex => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {personId, positionIndex},
      ];
}

@DriftDatabase(tables: [
  Persons,
  PersonPositionsV6,
  Plays,
  LineupSlots,
  MainMembers,
  SubMembers,
  LineupTemplates,
  LineupTemplateSlots,
])
class V6Database extends _$V6Database {
  V6Database(super.executor);

  @override
  int get schemaVersion => 6;
}
