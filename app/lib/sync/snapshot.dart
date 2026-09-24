import 'package:drift/drift.dart';

import '../data/database.dart';

/// One table's worth of rows in a sync snapshot, keyed by its JSON name.
class _SyncTable<T extends Table, D extends DataClass> {
  const _SyncTable(this.key, this.table, this.fromJson);

  final String key;
  final TableInfo<T, D> table;
  final D Function(Map<String, dynamic>) fromJson;

  Future<List<Map<String, dynamic>>> dump(AppDatabase db) async {
    final rows = [
      for (final row in await db.select(table).get()) row.toJson(),
    ]..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
    return rows;
  }

  void restore(Batch batch, List<dynamic> rows) {
    batch.insertAll(
      table,
      [for (final row in rows) fromJson(row as Map<String, dynamic>) as Insertable<D>],
    );
  }
}

/// Whole-database export/import used by [SyncService]. The snapshot is a
/// plain JSON map (`{"persons": [...], "plays": [...], ...}`) using each
/// Drift row class's own `toJson()` shape, and it's exactly what the
/// `/api/sync` endpoint stores in Neon.
extension SnapshotIO on AppDatabase {
  /// Parents before children, so a restore never references a missing row.
  List<_SyncTable> get _syncTables => [
        _SyncTable('persons', persons, Person.fromJson),
        _SyncTable('plays', plays, Play.fromJson),
        _SyncTable('playPositions', playPositions, PlayPosition.fromJson),
        _SyncTable('personPositions', personPositions, PersonPosition.fromJson),
        _SyncTable('lineupSlots', lineupSlots, LineupSlot.fromJson),
        _SyncTable('mainMembers', mainMembers, MainMember.fromJson),
        _SyncTable('subMembers', subMembers, SubMember.fromJson),
        _SyncTable('lineupTemplates', lineupTemplates, LineupTemplate.fromJson),
        _SyncTable(
          'lineupTemplateSlots',
          lineupTemplateSlots,
          LineupTemplateSlot.fromJson,
        ),
      ];

  Future<Map<String, dynamic>> exportSnapshot() async {
    return {
      for (final t in _syncTables) t.key: await t.dump(this),
    };
  }

  /// Replaces every row in the local database with [snapshot]'s contents.
  Future<void> importSnapshot(Map<String, dynamic> snapshot) {
    final tables = _syncTables;
    return transaction(() async {
      for (final t in tables.reversed) {
        await delete(t.table).go();
      }
      await batch((batch) {
        for (final t in tables) {
          t.restore(batch, snapshot[t.key] as List<dynamic>? ?? const []);
        }
      });
    });
  }
}
