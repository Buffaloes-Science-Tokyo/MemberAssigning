import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kick_members/data/database.dart' show AppDatabase;
import 'package:path/path.dart' as p;

import 'schema/v6_database.dart';

void main() {
  test(
    'upgrading from schema v6 preserves eligible positions and seeds the '
    'existing play with the original default position labels',
    () async {
      final dir = await Directory.systemTemp.createTemp('kick_members_migration_test');
      final file = File(p.join(dir.path, 'test.sqlite'));
      addTearDown(() => dir.delete(recursive: true));

      final v6 = V6Database(NativeDatabase(file));
      final personId = await v6.into(v6.persons).insert(
            PersonsCompanion.insert(name: 'Kevin'),
          );
      final playId = await v6.into(v6.plays).insert(
            PlaysCompanion.insert(category: 'KC', name: '左sabel_α'),
          );
      await v6.into(v6.personPositionsV6).insert(
            PersonPositionsV6Companion.insert(personId: personId, positionIndex: 3),
          );
      await v6.close();

      final db = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(db.close);

      final plays = await db.watchAllPlays().first;
      expect(plays, hasLength(1));
      expect(plays.single.id, playId);

      final positions = await db.watchPositionsForPerson(personId, playId).first;
      expect(positions.toSet(), {3});

      final labels = await db.watchPlayPositionLabels(playId).first;
      expect(labels, ['10', '9', '8', '7', '6', '5', '4', '3', '2', '1', 'K']);
    },
  );
}
