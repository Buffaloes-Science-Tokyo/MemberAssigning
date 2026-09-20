import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kick_members/data/database.dart';

// Drift's stream cleanup schedules a timer that flutter_test's strict
// "no pending timers after dispose" check flags when a live query stream is
// torn down inside a testWidgets tree, so the DB layer is exercised here
// directly instead of through a widget pump; the UI is checked by hand via
// `flutter run -d chrome` (see docs/functions.md / plan notes).
void main() {
  test('firstPlay seeds the single KC / 左sabel_α play', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final play = await db.firstPlay();
    expect(play.category, 'KC');
    expect(play.name, '左sabel_α');

    // Calling it again must not create a second row.
    final again = await db.firstPlay();
    expect(again.id, play.id);
  });

  test('assignSlot updates a play\'s lineup', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final personId = await db.into(db.persons).insert(
          PersonsCompanion.insert(name: 'Kevin'),
        );
    final play = await db.firstPlay();

    await db.assignSlot(play.id, 0, personId);
    var slots = await db.watchLineupSlots(play.id).first;
    expect(slots.singleWhere((s) => s.positionIndex == 0).personId, personId);

    await db.assignSlot(play.id, 0, null);
    slots = await db.watchLineupSlots(play.id).first;
    expect(slots.singleWhere((s) => s.positionIndex == 0).personId, isNull);
  });

  test('setPersonPositions replaces the eligible-position set', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final personId = await db.into(db.persons).insert(
          PersonsCompanion.insert(name: 'Kevin'),
        );

    await db.setPersonPositions(personId, {2, 5, 8});
    var positions = await db.watchPositionsForPerson(personId).first;
    expect(positions.toSet(), {2, 5, 8});

    await db.setPersonPositions(personId, {10});
    positions = await db.watchPositionsForPerson(personId).first;
    expect(positions.toSet(), {10});
  });
}
