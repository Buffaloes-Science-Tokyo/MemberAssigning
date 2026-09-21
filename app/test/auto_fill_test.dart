import 'package:flutter_test/flutter_test.dart';
import 'package:kick_members/data/positions.dart';
import 'package:kick_members/logic/auto_fill.dart';

void main() {
  // personId == positionIndex, each eligible for exactly their own
  // position and a perfect match for it, so the unique full lineup
  // (0..10 in order) is strictly the best combination.
  final availableByPosition = [
    for (var i = 0; i < kPositionCount; i++) [i],
  ];
  final mainByPosition = [for (var i = 0; i < kPositionCount; i++) i];
  final subByPosition = [for (var i = 0; i < kPositionCount; i++) <int>[]];
  final fixedByPosition = List<int?>.filled(kPositionCount, null);
  final inPersonIds = {for (var i = 0; i < kPositionCount; i++) i};

  AutoFillInput freshInput() => AutoFillInput(
        availableByPosition: availableByPosition,
        mainByPosition: mainByPosition,
        subByPosition: subByPosition,
        fixedByPosition: fixedByPosition,
        inPersonIds: inPersonIds,
      );

  test('the full perfect-match lineup wins with the max possible score', () {
    final candidates = findLineupCandidates(freshInput());
    expect(candidates, isNotEmpty);

    final best = candidates.reduce((a, b) => a.score >= b.score ? a : b);
    expect(best.score, kPositionCount * kScorePerfect);
    expect(best.lineup, [for (var i = 0; i < kPositionCount; i++) i]);
  });

  test('a person already OUT is never picked', () {
    final input = AutoFillInput(
      availableByPosition: availableByPosition,
      mainByPosition: mainByPosition,
      subByPosition: subByPosition,
      fixedByPosition: fixedByPosition,
      inPersonIds: inPersonIds.difference({0}),
    );
    final candidates = findLineupCandidates(input);
    for (final candidate in candidates) {
      expect(candidate.lineup[0], isNot(0));
    }
  });

  test('a locked (already-fixed) position is kept and not re-decided', () {
    final locked = List<int?>.from(fixedByPosition)..[3] = 3;
    final input = AutoFillInput(
      availableByPosition: availableByPosition,
      mainByPosition: mainByPosition,
      subByPosition: subByPosition,
      fixedByPosition: locked,
      inPersonIds: inPersonIds,
    );
    final candidates = findLineupCandidates(input);
    for (final candidate in candidates) {
      expect(candidate.lineup[3], 3);
    }
  });

  test(
    'computeLineupCandidates runs the search on an isolate and sorts '
    'highest score first',
    () async {
      final candidates = await computeLineupCandidates(freshInput());
      expect(candidates, isNotEmpty);
      expect(candidates.first.score, kPositionCount * kScorePerfect);
      for (var i = 1; i < candidates.length; i++) {
        expect(candidates[i - 1].score, greaterThanOrEqualTo(candidates[i].score));
      }
    },
  );
}
