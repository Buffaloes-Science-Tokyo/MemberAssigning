# `lib/` overview

Flutter + Drift port of the kick-play lineup board originally prototyped in
Python (`test/algorithm.py`). This is an offline-first app: SQLite via Drift
for storage, a drag-and-drop board UI, and an Auto-fill search ported from
the prototype's `get_candidate_members()`.

```
lib/
├── main.dart
├── data/
│   ├── database.dart
│   ├── database.g.dart
│   └── positions.dart
├── logic/
│   └── auto_fill.dart
├── sync/
│   ├── snapshot.dart
│   └── sync_service.dart
└── ui/
    ├── lineup_board_page.dart
    ├── person_card.dart
    ├── person_settings_dialog.dart
    ├── play_settings_dialog.dart
    └── sync_button.dart
```

## `main.dart`

App entry point. Creates an `AppDatabase`, waits on `db.seedIfEmpty()` and
`SyncService.create(db)` via a `FutureBuilder` (showing a spinner until
they're done), then hands off to `LineupBoardPage`.

## `data/database.dart`

The Drift schema and all data access for the app. Defines eight tables:

- **`Persons`** — roster members, shared across every play. `id`, `name`,
  `isOut` (absent flag, mirrors `Person.status` from the Python prototype),
  `gen` (期), `guest` (guest flag).
- **`Plays`** — a single kind of play, identified by `category` (e.g.
  `"KC"`) and `name` (e.g. `"左sabel_α"`). Every play has its own 11
  position slots — a different play can use entirely different position
  labels and eligibility, without touching `Persons` at all.
- **`PlayPositions`** — a play's 11 position labels (`playId` ×
  `positionIndex` → `label`). Independent per play; unique on
  `(playId, positionIndex)`.
- **`PersonPositions`** — join table of which of a *play's* 11 positions
  (`personId` × `playId` × `positionIndex`) each person is eligible to
  play. Mirrors `Person.pos`, scoped per play. Unique on
  `(personId, playId, positionIndex)`.
- **`LineupSlots`** — the current manual (drag-and-drop) assignment of a
  person to a position for a given play. Mirrors the Python prototype's
  `fixed_list`. `personId` is nullable (empty slot) and unique on
  `(playId, positionIndex)`.
- **`MainMembers`** — same shape as `LineupSlots` (`playId` ×
  `positionIndex` → nullable `personId`), for the board's bottom-left area.
- **`SubMembers`** — the bottom-right area. Unlike the other two, a
  position can hold several people at once, so this is one row per
  `(playId, positionIndex, personId)` triple (non-nullable `personId`)
  rather than one row per position.

`AppDatabase` (generated companion class in `database.g.dart` via
`@DriftDatabase`) exposes:

| Method | Purpose |
| --- | --- |
| `watchAllPersons()` | Stream of all persons, for the roster strip. |
| `watchPositionsForPerson(id, playId)` | Stream of one person's eligible positions within one play. |
| `watchAllPersonPositions(playId)` | Stream of `personId → Set<positionIndex>` for every person within one play, used to build the whole board at once. |
| `setPersonOut(id, bool)` | Toggle a person's absent flag. |
| `setPersonPositions(id, playId, Set<int>)` | Replace a person's eligible positions within one play (delete + reinsert, in a transaction). |
| `watchAllPlays()` | Stream of every play, for the play switcher. |
| `firstPlay()` | Ensures at least one play exists (creating a default `"KC" / "左sabel_α"` with `kDefaultPositionLabels` if the table is still empty) and returns one; used only to bootstrap the first run. |
| `createPlay(category, name, positionLabels)` | Creates a new play plus its 11 `PlayPositions` rows. |
| `renamePlay(playId, category, name)` | Updates a play's category/name. |
| `deletePlay(playId)` | Deletes a play and everything scoped to it (labels, eligibility, board, templates) via cascading FKs. |
| `watchPlayPositionLabels(playId)` / `setPlayPositionLabels(playId, labels)` | Read/replace a play's 11 position labels. |
| `watchLineupSlots(playId)` | Stream of a play's `fixed_list` assignments (top board area). |
| `assignSlot(playId, positionIndex, personId?)` | Upserts a `fixed_list` slot's assignment; `personId: null` clears it. |
| `watchMainMembers(playId)` / `assignMainMember(...)` | Same, for the `main_members` area (bottom-left). |
| `watchSubMembers(playId)` / `addSubMember(...)` / `removeSubMember(...)` | For the `sub_members` area (bottom-right): add/remove one person from a position's set (positions can hold several people). |
| `applyLineup(playId, List<int?>)` | Overwrites the whole `fixed_list` in one transaction; used by Auto-fill. |
| `clearBoard(playId)` | Deletes every `LineupSlots`/`MainMembers`/`SubMembers` row for a play (the "All clear" button). |
| `watchTemplates(playId)` / `saveTemplate(...)` / `applyTemplate(...)` / `renameTemplate(...)` / `deleteTemplate(...)` | Named snapshots of a play's full board (`LineupTemplates`/`LineupTemplateSlots`), switchable from the board screen. |
| `seedIfEmpty()` | One-time import of `assets/seed/data.json` (11 persons) on first launch, attached to the default play; no-ops once any person row exists. |

`database.g.dart` is Drift's generated code (row classes, companions, query
builders) — don't hand-edit it; regenerate with `dart run build_runner build`
after changing `database.dart`.

## `data/positions.dart`

Every play has exactly 11 position slots; only the slot *count* is fixed
app-wide (which label each index shows, and who's eligible for it, is
per-play — see `Plays`/`PlayPositions`/`PersonPositions` above):

```dart
kPositionCount = 11;
kDefaultPositionLabels = ['1','2','3','4','5','6','7','8','9','10','K']; // seeds the default play
```

Index order matches `algorithm.py`'s `pos` indices exactly, so seed data and
any future ported algorithm line up without remapping.

## `logic/auto_fill.dart`

`findLineupCandidates()` is a line-by-line port of `test/algorithm.py`'s
`get_candidate_members()`: a DFS/backtracking search that, for every
position not already locked in the current Lineup, either assigns an
available IN person (scoring `kScorePerfect` if they match that position's
main member, `kScoreSubstitute` if they're one of its sub members, else 0)
or leaves it unassigned (`kScoreUnassigned`), and keeps every full
combination that scores above `kScoreThreshold`. `AutoFillInput` bundles
the search's inputs (available/main/sub members per position, the starting
Lineup, and who's currently IN) into one transferable object;
`computeLineupCandidates()` runs the search via `compute()` on a background
isolate (the search can be slow for larger rosters) and returns the results
sorted highest score first. Covered by `test/auto_fill_test.dart`.

## `ui/lineup_board_page.dart`

The main screen (`LineupBoardPage` / `_LineupBoardPageState`).

- On init, calls `db.firstPlay()` just to guarantee at least one play
  exists; the actually-displayed play is tracked as `_selectedPlayId` and
  can be changed at any time via the `_PlaySwitcher` in the `AppBar`
  (a dropdown over `db.watchAllPlays()`, plus buttons that open
  `PlaySettingsDialog` to create a new play or edit the current one's
  category/name/position labels, and a delete button hidden when it's the
  only play left).
- Nests six `StreamBuilder`s (position labels → persons → person-position
  map → lineup slots → main members → sub members), all scoped to the
  selected play, to assemble everything `_Board` needs reactively.
- The row above the board has ▲/▼ buttons, "Auto-fill", "Clear" and "All
  clear". Auto-fill runs `computeLineupCandidates()` and applies the
  highest-scoring result to the Lineup; ▲/▼ step through the sorted
  candidates (kept in `_autoFillCandidates`/`_autoFillIndex`) and re-apply
  the newly-selected one. "Clear" empties just the Lineup and forgets the
  candidate list; "All clear" (with a confirmation dialog) empties Lineup,
  Main members and Sub members via `db.clearBoard`.

`_Board` renders:
- A `Wrap` of `PersonCard`s (the draggable roster) at the top.
- Below that, the 11-position board split into three `_PositionGrid`
  areas: the top half is `fixed_list` (the manual/current lineup, 4
  columns), and the bottom half is split left/right into `main_members`
  and `sub_members` (2 columns each).

`_PositionGrid` renders one titled grid of 11 slots from a
`positionIndex -> personId` map and wires its drops to the matching
`db.assignSlot` / `assignMainMember` call. `_PositionSlot` is a
`DragTarget<Person>`: dropping a `PersonCard` calls that grid's assign
callback with the person's id; an assigned slot shows a small "×" button
that clears it. The `sub_members` grid uses `_MultiPositionSlot` instead,
which accepts drops from any person not already in that position's set
(`db.addSubMember`) and shows each assigned person as a chip with its own
delete button (`db.removeSubMember`). Tapping a `PersonCard` opens
`PersonSettingsDialog` via `_openSettings`.

## `ui/person_card.dart`

`PersonCard` — a small card showing a person's name and IN/OUT status
(green "IN" / red "OUT", with a highlighted background when out). Wrapped
in `Draggable<Person>` so it can be dropped onto a `_PositionSlot`, *unless*
`person.isOut` is true — absent players can be tapped to edit but not
dragged onto the board.

## `ui/person_settings_dialog.dart`

`PersonSettingsDialog` — modal opened by tapping a `PersonCard`. Lets the
coach:
- Edit the name and 期 (gen).
- Toggle the person's `OUT (absent)` switch and `GUEST` checkbox.
- Select eligible positions via `FilterChip`s over the current play's
  `positionLabels` (passed in by the caller — eligibility is per-play, so
  the same dialog shows different labels/selection depending on which play
  is active).

On "Save" it calls the `onSave(name, gen, isOut, guest, positions)` callback
(wired in `lineup_board_page.dart` to `db.setPersonName` /
`db.setPersonGen` / `db.setPersonOut` / `db.setPersonGuest` +
`db.setPersonPositions(personId, play.id, positions)`); "Cancel" discards
changes.

## `ui/play_settings_dialog.dart`

`PlaySettingsDialog` — modal used both to create a new play and to edit an
existing one. Lets the coach set the `category`/`name` and all 11 position
labels (11 `TextField`s, one per slot); "Save" calls
`onSave(category, name, labels)`, wired in `lineup_board_page.dart` to
`db.createPlay(...)` or `db.renamePlay(...)` + `db.setPlayPositionLabels(...)`.

## Data flow summary

```
seed/data.json → AppDatabase.seedIfEmpty() → Persons/PersonPositions tables
                                                        │
                                       watch* streams ──┘
                                                        ▼
LineupBoardPage ── drag PersonCard → _PositionSlot ── db.assignSlot()
       │                                                       │
       └── tap PersonCard → PersonSettingsDialog ── db.setPersonOut()
                                                    └ db.setPersonPositions()
```

Everything works offline: SQLite (via `drift_flutter`) is the only
persistence layer the UI talks to, seeded once from the bundled JSON asset.
The only network call is the manual Sync button (see `sync/` below).

## `sync/`

Manual, whole-database sync with the server (`/api/sync` on Vercel, stored
in Neon Postgres — see the repo root `README.md`).

- **`snapshot.dart`** — `exportSnapshot()` / `importSnapshot()` extension on
  `AppDatabase`: every table as a JSON map (`{"persons": [...], ...}`) in
  each Drift row class's `toJson()` shape; import replaces all local rows.
- **`sync_service.dart`** — `SyncService` (a `ChangeNotifier`). The server
  keeps one snapshot plus a version counter; locally we keep (in
  `shared_preferences`) the version last synced and a sha256 of the
  database as it was then. `sync()` then decides:
  only the server changed → pull; only this device → push; neither →
  up to date; both → throws `SyncConflict` and the UI asks which side to
  keep (`resolve(conflict, keepLocal: ...)`). Uploads are optimistic-locked
  on the version, so a race with another device surfaces as a 409.
  `hasLocalChanges` is kept up to date from `db.tableUpdates()`.

## `ui/sync_button.dart`

`SyncActions` — the AppBar's Sync button (dot badge = unsynced local
changes, tooltip = last sync time) and a cloud button that opens the sync
settings (sync key, and server URL for non-web builds). Shows the result
or error as a SnackBar and the conflict dialog when needed.
