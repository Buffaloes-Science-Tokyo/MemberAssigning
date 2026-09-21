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
    final play = await db.firstPlay();

    await db.setPersonPositions(personId, play.id, {2, 5, 8});
    var positions = await db.watchPositionsForPerson(personId, play.id).first;
    expect(positions.toSet(), {2, 5, 8});

    await db.setPersonPositions(personId, play.id, {10});
    positions = await db.watchPositionsForPerson(personId, play.id).first;
    expect(positions.toSet(), {10});
  });

  test('each play keeps its own independent position labels and eligibility',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final personId = await db.into(db.persons).insert(
          PersonsCompanion.insert(name: 'Kevin'),
        );
    final kc = await db.firstPlay();
    final other = await db.createPlay(
      'Other',
      'Formation B',
      ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'],
    );

    await db.setPersonPositions(personId, kc.id, {0, 1});
    await db.setPersonPositions(personId, other.id, {9});

    final kcPositions = await db.watchPositionsForPerson(personId, kc.id).first;
    final otherPositions =
        await db.watchPositionsForPerson(personId, other.id).first;
    expect(kcPositions.toSet(), {0, 1});
    expect(otherPositions.toSet(), {9});

    final kcLabels = await db.watchPlayPositionLabels(kc.id).first;
    final otherLabels = await db.watchPlayPositionLabels(other.id).first;
    expect(kcLabels, ['10', '9', '8', '7', '6', '5', '4', '3', '2', '1', 'K']);
    expect(otherLabels, ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K']);
  });
}
