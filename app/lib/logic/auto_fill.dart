import 'package:flutter/foundation.dart';

import '../data/positions.dart';

/// Ported from `test/algorithm.py`'s `SCORE_*` constants.
const int kScorePerfect = 2;
const int kScoreSubstitute = 1;
const int kScoreUnassigned = -1;
const int kScoreThreshold = 0;

/// One full-Lineup candidate produced by [findLineupCandidates]: a personId
/// (or `null` for "left unassigned") per position, and its total score.
class AutoFillCandidate {
  const AutoFillCandidate({required this.lineup, required this.score});

  final List<int?> lineup;
  final int score;
}

/// Everything [findLineupCandidates] needs, bundled into one object so it
/// can be handed to [computeLineupCandidates] and run on a background
/// isolate — the search below is a full DFS/backtracking enumeration and
/// can be slow for larger rosters.
class AutoFillInput {
  const AutoFillInput({
    required this.availableByPosition,
    required this.mainByPosition,
    required this.subByPosition,
    required this.fixedByPosition,
    required this.inPersonIds,
  });

  /// personIds eligible for each position (regardless of IN/OUT status),
  /// one list per position index.
  final List<List<int>> availableByPosition;

  /// The "perfect" pick for each position, or null.
  final List<int?> mainByPosition;

  /// The "substitute" picks for each position.
  final List<List<int>> subByPosition;

  /// The currently-assigned Lineup, used as a starting point: positions
  /// that are already filled here are treated as locked and are not
  /// revisited by the search.
  final List<int?> fixedByPosition;

  /// personIds currently IN (not marked OUT); only these can be picked.
  final Set<int> inPersonIds;
}

/// Ported from `test/algorithm.py`'s `get_candidate_members()`: a
/// backtracking search over every position that isn't already locked in
/// [AutoFillInput.fixedByPosition]. Placing a person scores "perfect" if
/// they're that position's main member, "substitute" if they're one of its
/// sub members, or neutral otherwise; leaving a position unassigned (either
/// because nobody is available for it, or by choice) is penalized. Returns
/// every combination that scores above [kScoreThreshold], unsorted.
List<AutoFillCandidate> findLineupCandidates(AutoFillInput input) {
  final availableByPosition = input.availableByPosition;
  final mainByPosition = input.mainByPosition;
  final subByPosition = input.subByPosition;

  var score = 0;
  final assigned = <int>{};
  final unassigned = <int>{};
  final startingLineup = List<int?>.of(input.fixedByPosition);
  final allEmpty = startingLineup.every((personId) => personId == null);
  if (allEmpty) {
    unassigned.addAll(List.generate(kPositionCount, (i) => i));
  } else {
    for (var i = 0; i < kPositionCount; i++) {
      final personId = startingLineup[i];
      if (personId == null) {
        unassigned.add(i);
      } else {
        assigned.add(personId);
        if (mainByPosition[i] == personId) {
          score += kScorePerfect;
        } else if (subByPosition[i].contains(personId)) {
          score += kScoreSubstitute;
        }
      }
    }
  }

  final candidates = <AutoFillCandidate>[];

  void dfs(
    List<int?> currentLineup,
    Set<int> assignedSoFar,
    Set<int> stillUnassigned,
    int currentScore,
  ) {
    final removeSet = <int>{};
    var i = -1;
    for (final j in stillUnassigned) {
      i = j;
      if (availableByPosition[i].isNotEmpty) {
        break;
      } else {
        removeSet.add(i);
        currentScore += kScoreUnassigned;
      }
    }
    if (stillUnassigned.isEmpty) {
      if (currentScore > kScoreThreshold) {
        candidates.add(
          AutoFillCandidate(
            lineup: List.of(currentLineup),
            score: currentScore,
          ),
        );
      }
      return;
    }
    removeSet.add(i);
    final restUnassigned = stillUnassigned.difference(removeSet);
    for (final possibleMember in availableByPosition[i]) {
      if (!assignedSoFar.contains(possibleMember) &&
          input.inPersonIds.contains(possibleMember)) {
        final nextLineup = List<int?>.of(currentLineup);
        nextLineup[i] = possibleMember;
        final bonus = mainByPosition[i] == possibleMember
            ? kScorePerfect
            : (subByPosition[i].contains(possibleMember)
                ? kScoreSubstitute
                : 0);
        dfs(
          nextLineup,
          {...assignedSoFar, possibleMember},
          restUnassigned,
          currentScore + bonus,
        );
      }
    }
    dfs(
      currentLineup,
      assignedSoFar,
      restUnassigned,
      currentScore + kScoreUnassigned,
    );
  }

  dfs(startingLineup, assigned, unassigned, score);
  return candidates;
}

/// Runs [findLineupCandidates] on a background isolate (so the DFS search
/// doesn't block the UI) and returns the results sorted from highest to
/// lowest score.
Future<List<AutoFillCandidate>> computeLineupCandidates(
  AutoFillInput input,
) async {
  final candidates = await compute(findLineupCandidates, input);
  candidates.sort((a, b) => b.score.compareTo(a.score));
  return candidates;
}
