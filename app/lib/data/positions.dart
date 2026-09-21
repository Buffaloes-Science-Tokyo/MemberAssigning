/// Every play has exactly 11 position slots, indexed 0-10. Which label each
/// index shows (and which positions a person is eligible for) is defined
/// per-play (see `Plays`/`PlayPositions` in `database.dart`); only the slot
/// *count* is fixed app-wide, matching `algorithm.py`'s `pos` indices so
/// seed data and any future ported algorithm line up without remapping.
const int kPositionCount = 11;

/// The original "KC" / 左sabel_α labels, used to seed the default play and
/// as a starting point when creating a new one.
const List<String> kDefaultPositionLabels = [
  '10',
  '9',
  '8',
  '7',
  '6',
  '5',
  '4',
  '3',
  '2',
  '1',
  'K',
];
