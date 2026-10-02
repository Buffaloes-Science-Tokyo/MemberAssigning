import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/positions.dart';
import '../logic/auto_fill.dart';
import '../sync/sync_service.dart';
import 'person_card.dart';
import 'person_settings_dialog.dart';
import 'play_settings_dialog.dart';
import 'sync_button.dart';

class LineupBoardPage extends StatefulWidget {
  const LineupBoardPage({super.key, required this.db, required this.sync});

  final AppDatabase db;
  final SyncService sync;

  @override
  State<LineupBoardPage> createState() => _LineupBoardPageState();
}

class _LineupBoardPageState extends State<LineupBoardPage> {
  int? _selectedPlayId;

  @override
  void initState() {
    super.initState();
    widget.db.firstPlay().then((play) {
      if (mounted) setState(() => _selectedPlayId = play.id);
    });
  }

  Play? _resolvePlay(List<Play> plays) {
    if (plays.isEmpty) return null;
    for (final play in plays) {
      if (play.id == _selectedPlayId) return play;
    }
    return plays.first;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Play>>(
      stream: widget.db.watchAllPlays(),
      builder: (context, playsSnapshot) {
        final plays = playsSnapshot.data ?? const <Play>[];
        final play = _resolvePlay(plays);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Kick Members'),
            actions: [SyncActions(sync: widget.sync)],
          ),
          body: play == null
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<List<String>>(
                  stream: widget.db.watchPlayPositionLabels(play.id),
                  builder: (context, labelsSnapshot) {
                    final positionLabels = labelsSnapshot.data;
                    if (positionLabels == null || positionLabels.length != kPositionCount) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return StreamBuilder<List<Person>>(
                      stream: widget.db.watchAllPersons(),
                      builder: (context, personsSnapshot) {
                        final people = [...personsSnapshot.data ?? const <Person>[]]
                          ..sort((a, b) {
                            if (a.gen == null || b.gen == null) {
                              return (a.gen == null ? 1 : 0) - (b.gen == null ? 1 : 0);
                            }
                            return a.gen!.compareTo(b.gen!);
                          });
                        return StreamBuilder<Map<int, Set<int>>>(
                          stream: widget.db.watchAllPersonPositions(play.id),
                          builder: (context, positionsSnapshot) {
                            final positionsByPerson = positionsSnapshot.data ?? const {};
                            return StreamBuilder<List<LineupSlot>>(
                              stream: widget.db.watchLineupSlots(play.id),
                              builder: (context, slotsSnapshot) {
                                final slots = slotsSnapshot.data ?? const <LineupSlot>[];
                                final slotByPosition = {
                                  for (final slot in slots)
                                    slot.positionIndex: slot.personId,
                                };
                                return StreamBuilder<List<MainMember>>(
                                  stream: widget.db.watchMainMembers(play.id),
                                  builder: (context, mainSnapshot) {
                                    final mainMembers =
                                        mainSnapshot.data ?? const <MainMember>[];
                                    final mainByPosition = {
                                      for (final row in mainMembers)
                                        row.positionIndex: row.personId,
                                    };
                                    return StreamBuilder<List<SubMember>>(
                                      stream: widget.db.watchSubMembers(play.id),
                                      builder: (context, subSnapshot) {
                                        final subMembers =
                                            subSnapshot.data ?? const <SubMember>[];
                                        final subByPosition = <int, Set<int>>{};
                                        for (final row in subMembers) {
                                          subByPosition
                                              .putIfAbsent(row.positionIndex, () => {})
                                              .add(row.personId);
                                        }
                                        final peopleById = {
                                          for (final person in people) person.id: person,
                                        };
                                        return _Board(
                                          db: widget.db,
                                          play: play,
                                          plays: plays,
                                          positionLabels: positionLabels,
                                          people: people,
                                          positionsByPerson: positionsByPerson,
                                          fixedByPosition: slotByPosition,
                                          mainByPosition: mainByPosition,
                                          subByPosition: subByPosition,
                                          peopleById: peopleById,
                                          onSelectPlay: (id) =>
                                              setState(() => _selectedPlayId = id),
                                          onCreatePlay: () => _createPlay(context, play),
                                          onEditPlay: () => _editPlay(context, play),
                                          onDeletePlay: plays.length > 1
                                              ? () => _deletePlay(context, play)
                                              : null,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }

  Future<void> _createPlay(BuildContext context, Play? current) async {
    await showDialog<void>(
      context: context,
      builder: (context) => PlaySettingsDialog(
        title: 'New play',
        initialCategory: current?.category ?? 'KC',
        initialLabels: kDefaultPositionLabels,
        onSave: (category, name, labels) async {
          final play = await widget.db.createPlay(category, name, labels);
          if (mounted) setState(() => _selectedPlayId = play.id);
        },
      ),
    );
  }

  Future<void> _editPlay(BuildContext context, Play play) async {
    final labels = await widget.db.watchPlayPositionLabels(play.id).first;
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => PlaySettingsDialog(
        title: 'Edit play',
        initialCategory: play.category,
        initialName: play.name,
        initialLabels: labels,
        onSave: (category, name, newLabels) async {
          await widget.db.renamePlay(play.id, category, name);
          await widget.db.setPlayPositionLabels(play.id, newLabels);
        },
      ),
    );
  }

  Future<void> _deletePlay(BuildContext context, Play play) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete play'),
        content: Text(
          'Delete "${play.category} / ${play.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      if (_selectedPlayId == play.id) {
        setState(() => _selectedPlayId = null);
      }
      await widget.db.deletePlay(play.id);
    }
  }
}

/// A dropdown to switch between plays, plus buttons to add a new one, edit
/// the current one's category/name/position labels, or delete it (hidden
/// when it's the only remaining play). Sits between the roster and the
/// board's Auto-fill/Clear/Save row.
class _PlaySwitcher extends StatelessWidget {
  const _PlaySwitcher({
    required this.plays,
    required this.selected,
    required this.onSelect,
    required this.onCreate,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Play> plays;
  final Play selected;
  final void Function(int playId) onSelect;
  final VoidCallback onCreate;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selected.id,
              isExpanded: false,
              items: [
                for (final play in plays)
                  DropdownMenuItem(
                    value: play.id,
                    child: Text(
                      '${play.category} / ${play.name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) onSelect(value);
              },
            ),
          ),
        ),
        IconButton(
          tooltip: 'New play',
          icon: const Icon(Icons.add),
          onPressed: onCreate,
        ),
        IconButton(
          tooltip: 'Edit play',
          icon: const Icon(Icons.edit_outlined),
          onPressed: onEdit,
        ),
        if (onDelete != null)
          IconButton(
            tooltip: 'Delete play',
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
      ],
    );
  }
}

/// The board is split into a member-cards area on top and the assign area
/// (position table) below; these flex values give the member-cards area
/// roughly 30-40% of the total height and the assign area the rest.
const int _kRosterAreaFlex = 35;
const int _kAssignAreaFlex = 65;

/// Roster grid: shows at most 2 rows × 5 columns (10) of cards per page;
/// beyond that, cards live on further pages reachable via the arrow buttons
/// or page dots in [_RosterPager]. Card size is derived from the space
/// available in the member-cards area, not fixed, so the grid always fills
/// it exactly.
const int _kRosterRows = 2;
const int _kRosterCols = 5;
const double _kRosterSpacing = 8;
const int _kRosterPageSize = _kRosterRows * _kRosterCols;

/// Which roster cards `_RosterPager` shows.
enum _RosterFilter {
  all('ALL'),
  in_('IN'),
  roster('ROSTER'),
  active('ACTIVE'),
  guest('GUEST');

  const _RosterFilter(this.label);

  final String label;
}

class _Board extends StatefulWidget {
  const _Board({
    required this.db,
    required this.play,
    required this.plays,
    required this.positionLabels,
    required this.people,
    required this.positionsByPerson,
    required this.fixedByPosition,
    required this.mainByPosition,
    required this.subByPosition,
    required this.peopleById,
    required this.onSelectPlay,
    required this.onCreatePlay,
    required this.onEditPlay,
    required this.onDeletePlay,
  });

  final AppDatabase db;
  final Play play;

  /// Every play, for the play switcher dropdown.
  final List<Play> plays;

  /// The current play's 11 position labels, in index order.
  final List<String> positionLabels;
  final List<Person> people;
  final Map<int, Set<int>> positionsByPerson;

  /// personId assigned to each position index, for the single-assignment
  /// board areas.
  final Map<int, int?> fixedByPosition;
  final Map<int, int?> mainByPosition;

  /// personIds assigned to each position index for Sub members, which
  /// allows several people per position.
  final Map<int, Set<int>> subByPosition;
  final Map<int, Person> peopleById;

  final void Function(int playId) onSelectPlay;
  final VoidCallback onCreatePlay;
  final VoidCallback onEditPlay;
  final VoidCallback? onDeletePlay;

  @override
  State<_Board> createState() => _BoardState();
}

class _BoardState extends State<_Board> {
  Person? _draggingPerson;
  _RosterFilter _rosterFilter = _RosterFilter.all;

  /// Candidates from the last Auto-fill run, sorted highest score first,
  /// and which one is currently applied to the Lineup.
  List<AutoFillCandidate>? _autoFillCandidates;
  int _autoFillIndex = 0;
  bool _autoFillBusy = false;

  bool get _canShiftAutoFillUp =>
      (_autoFillCandidates?.isNotEmpty ?? false) && _autoFillIndex > 0;
  bool get _canShiftAutoFillDown =>
      (_autoFillCandidates?.isNotEmpty ?? false) &&
      _autoFillIndex < _autoFillCandidates!.length - 1;

  AppDatabase get db => widget.db;
  Play get play => widget.play;
  List<Play> get plays => widget.plays;
  List<String> get positionLabels => widget.positionLabels;
  List<Person> get people => widget.people;
  Map<int, Set<int>> get positionsByPerson => widget.positionsByPerson;
  Map<int, int?> get fixedByPosition => widget.fixedByPosition;
  Map<int, int?> get mainByPosition => widget.mainByPosition;
  Map<int, Set<int>> get subByPosition => widget.subByPosition;
  Map<int, Person> get peopleById => widget.peopleById;

  /// The roster cards to show for the current [_rosterFilter]: everyone,
  /// non-guests who are IN and eligible for at least one position, non-guests
  /// eligible for at least one position, all non-guests, or only guests.
  List<Person> get _filteredPeople {
    bool hasPositions(Person person) =>
        positionsByPerson[person.id]?.isNotEmpty ?? false;

    switch (_rosterFilter) {
      case _RosterFilter.all:
        return people;
      case _RosterFilter.in_:
        return [
          for (final person in people)
            if (!person.isOut && !person.guest && hasPositions(person)) person,
        ];
      case _RosterFilter.roster:
        return [
          for (final person in people)
            if (!person.guest && hasPositions(person)) person,
        ];
      case _RosterFilter.active:
        return [for (final person in people) if (!person.guest) person];
      case _RosterFilter.guest:
        return [for (final person in people) if (person.guest) person];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Member cards area: ~30-40% of the board's height, the rest below
        // goes to the assign area (position table).
        Expanded(
          flex: _kRosterAreaFlex,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<_RosterFilter>(
                          value: _rosterFilter,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color:
                                Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                          dropdownColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          items: [
                            for (final filter in _RosterFilter.values)
                              DropdownMenuItem(
                                value: filter,
                                child: Text(filter.label),
                              ),
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _rosterFilter = value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Visibility(
                      visible: _rosterFilter == _RosterFilter.all,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: FilledButton.icon(
                        onPressed: () => _addPerson(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add person'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Visibility(
                      visible: _rosterFilter == _RosterFilter.all,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: _DeletePersonZone(
                        onAccept: (person) => _deletePerson(context, person),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: _RosterPager(
                    people: _filteredPeople,
                    onTapPerson: (person) => _openSettings(context, person),
                    onDragStarted: (person) =>
                        setState(() => _draggingPerson = person),
                    onDragEnd: () => setState(() => _draggingPerson = null),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Assign area: the rest of the board's height.
        Expanded(
          flex: _kAssignAreaFlex,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: _PlaySwitcher(
                  plays: plays,
                  selected: play,
                  onSelect: widget.onSelectPlay,
                  onCreate: widget.onCreatePlay,
                  onEdit: widget.onEditPlay,
                  onDelete: widget.onDeletePlay,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Higher-scoring combination',
                      onPressed: _canShiftAutoFillUp
                          ? () => _shiftAutoFillCandidate(-1)
                          : null,
                      icon: const Icon(Icons.keyboard_arrow_up),
                    ),
                    IconButton(
                      tooltip: 'Lower-scoring combination',
                      onPressed: _canShiftAutoFillDown
                          ? () => _shiftAutoFillCandidate(1)
                          : null,
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                    if (_autoFillCandidates != null &&
                        _autoFillCandidates!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '${_autoFillIndex + 1}/${_autoFillCandidates!.length} '
                          '(score ${_autoFillCandidates![_autoFillIndex].score})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    TextButton.icon(
                      onPressed: _autoFillBusy ? null : () => _autoFill(context),
                      icon: _autoFillBusy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.auto_fix_high),
                      label: const Text('Auto-fill'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _clearAutoFill(),
                      icon: const Icon(Icons.backspace_outlined),
                      label: const Text('Clear'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _allClear(context),
                      icon: const Icon(Icons.clear_all),
                      label: const Text('All clear'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => _saveTemplate(context),
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: _PositionTable(
                        positionLabels: positionLabels,
                        draggingPersonPositions: _draggingPerson == null
                            ? null
                            : positionsByPerson[_draggingPerson!.id] ??
                                const <int>{},
                        rows: [
                          _BoardRow(
                            title: 'Lineup',
                            cellBuilder: (index) => _PositionSlot(
                              assigned: peopleById[fixedByPosition[index]],
                              onWillAccept: (person) => !person.isOut,
                              onAccept: (person) =>
                                  db.assignSlot(play.id, index, person.id),
                              onClear: fixedByPosition[index] == null
                                  ? null
                                  : () => db.assignSlot(play.id, index, null),
                            ),
                          ),
                          _BoardRow(
                            title: 'Main members',
                            cellBuilder: (index) => _PositionSlot(
                              assigned: peopleById[mainByPosition[index]],
                              onWillAccept: (person) => !person.isOut,
                              onAccept: (person) =>
                                  db.assignMainMember(play.id, index, person.id),
                              onClear: mainByPosition[index] == null
                                  ? null
                                  : () =>
                                      db.assignMainMember(play.id, index, null),
                            ),
                          ),
                          _BoardRow(
                            title: 'Sub members',
                            cellBuilder: (index) {
                              final assignedIds =
                                  subByPosition[index] ?? const <int>{};
                              return _MultiPositionSlot(
                                assigned: [
                                  for (final id in assignedIds)
                                    if (peopleById[id] != null) peopleById[id]!,
                                ],
                                onWillAccept: (person) =>
                                    !person.isOut &&
                                    !assignedIds.contains(person.id),
                                onAccept: (person) =>
                                    db.addSubMember(play.id, index, person.id),
                                onRemove: (personId) =>
                                    db.removeSubMember(play.id, index, personId),
                              );
                            },
                          ),
                        ],
                        peopleById: peopleById,
                      ),
                    ),
                  ),
                ),
              ),
              StreamBuilder<List<LineupTemplate>>(
                stream: db.watchTemplates(play.id),
                builder: (context, snapshot) {
                  final templates = snapshot.data ?? const <LineupTemplate>[];
                  if (templates.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: templates.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final template = templates[index];
                          return Tooltip(
                            message: 'Long-press to rename',
                            child: OutlinedButton(
                              onPressed: () =>
                                  db.applyTemplate(play.id, template.id),
                              onLongPress: () => _renameTemplate(context, template),
                              child: Text(template.name),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Runs the ported `get_candidate_members()` search (see
  /// `logic/auto_fill.dart`) over the current roster and applies the
  /// highest-scoring combination to the Lineup. Positions already filled in
  /// the Lineup are treated as locked and left alone; the search only
  /// decides the rest.
  Future<void> _autoFill(BuildContext context) async {
    setState(() => _autoFillBusy = true);
    try {
      final availableByPosition = [
        for (var i = 0; i < kPositionCount; i++) <int>[],
      ];
      for (final person in people) {
        for (final pos in positionsByPerson[person.id] ?? const <int>{}) {
          availableByPosition[pos].add(person.id);
        }
      }
      final mainList = [
        for (var i = 0; i < kPositionCount; i++) mainByPosition[i],
      ];
      final subList = [
        for (var i = 0; i < kPositionCount; i++)
          (subByPosition[i] ?? const <int>{}).toList(),
      ];
      final fixedList = [
        for (var i = 0; i < kPositionCount; i++) fixedByPosition[i],
      ];
      final inPersonIds = {
        for (final person in people)
          if (!person.isOut) person.id,
      };

      final candidates = await computeLineupCandidates(
        AutoFillInput(
          availableByPosition: availableByPosition,
          mainByPosition: mainList,
          subByPosition: subList,
          fixedByPosition: fixedList,
          inPersonIds: inPersonIds,
        ),
      );

      if (candidates.isEmpty) {
        setState(() {
          _autoFillCandidates = null;
          _autoFillIndex = 0;
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid combination found')),
          );
        }
        return;
      }

      setState(() {
        _autoFillCandidates = candidates;
        _autoFillIndex = 0;
      });
      await db.applyLineup(play.id, candidates.first.lineup);
    } finally {
      if (mounted) setState(() => _autoFillBusy = false);
    }
  }

  /// Moves to the next candidate up ([delta] `-1`, higher score) or down
  /// ([delta] `1`, lower score) and applies it to the Lineup.
  Future<void> _shiftAutoFillCandidate(int delta) async {
    final candidates = _autoFillCandidates;
    if (candidates == null) return;
    final nextIndex = (_autoFillIndex + delta).clamp(0, candidates.length - 1);
    if (nextIndex == _autoFillIndex) return;
    setState(() => _autoFillIndex = nextIndex);
    await db.applyLineup(play.id, candidates[nextIndex].lineup);
  }

  /// Clears the Lineup and forgets the last Auto-fill run.
  Future<void> _clearAutoFill() async {
    setState(() {
      _autoFillCandidates = null;
      _autoFillIndex = 0;
    });
    await db.applyLineup(play.id, List<int?>.filled(kPositionCount, null));
  }

  Future<void> _allClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all'),
        content: const Text(
          'Clear every assignment in Lineup, Main members and Sub members? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await db.clearBoard(play.id);
    }
  }

  Future<void> _saveTemplate(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save as template'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Template name'),
          onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;

    Map<int, int?> fullMap(Map<int, int?> byPosition) => {
          for (var i = 0; i < kPositionCount; i++) i: byPosition[i],
        };
    Map<int, Set<int>> fullSetMap(Map<int, Set<int>> byPosition) => {
          for (var i = 0; i < kPositionCount; i++)
            i: byPosition[i] ?? const <int>{},
        };
    await db.saveTemplate(
      play.id,
      name,
      fixed: fullMap(fixedByPosition),
      main: fullMap(mainByPosition),
      sub: fullSetMap(subByPosition),
    );
  }

  Future<void> _renameTemplate(
    BuildContext context,
    LineupTemplate template,
  ) async {
    final controller = TextEditingController(text: template.name);
    final result = await showDialog<({bool delete, String? name})>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rename template'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Template name'),
          onSubmitted: (value) =>
              Navigator.of(dialogContext).pop((delete: false, name: value.trim())),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop((delete: true, name: null)),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext)
                .pop((delete: false, name: controller.text.trim())),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
    if (result == null) return;
    if (!context.mounted) return;

    if (result.delete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete template'),
          content: Text('Delete "${template.name}"? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed ?? false) {
        await db.deleteTemplate(template.id);
      }
      return;
    }

    final name = result.name;
    if (name == null || name.isEmpty || name == template.name) return;

    try {
      await db.renameTemplate(template.id, name);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('A template named "$name" already exists')),
        );
      }
    }
  }

  Future<void> _addPerson(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add person'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await db.addPerson(name);
    }
  }

  Future<void> _deletePerson(BuildContext context, Person person) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete person'),
        content: Text('Delete ${person.name}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await db.deletePerson(person.id);
    }
  }

  void _openSettings(BuildContext context, Person person) {
    showDialog<void>(
      context: context,
      builder: (context) => PersonSettingsDialog(
        person: person,
        positionLabels: positionLabels,
        initialPositions: positionsByPerson[person.id] ?? const {},
        onSave: (name, gen, isOut, guest, positions) {
          db.setPersonName(person.id, name);
          db.setPersonGen(person.id, gen);
          db.setPersonOut(person.id, isOut);
          db.setPersonGuest(person.id, guest);
          db.setPersonPositions(person.id, play.id, positions);
        },
      ),
    );
  }
}

class _DeletePersonZone extends StatelessWidget {
  const _DeletePersonZone({required this.onAccept});

  final void Function(Person person) onAccept;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Person>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final highlighted = candidateData.isNotEmpty;
        return Container(
          width: 96,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: highlighted ? Theme.of(context).colorScheme.error : Colors.grey,
              width: highlighted ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
            color: highlighted ? Theme.of(context).colorScheme.errorContainer : null,
          ),
          child: Icon(
            Icons.delete_outline,
            color: highlighted ? Theme.of(context).colorScheme.error : null,
          ),
        );
      },
    );
  }
}

/// Pages the roster 12 cards at a time (3 rows × 4 columns), with arrow
/// buttons and tappable dots to jump between pages.
class _RosterPager extends StatefulWidget {
  const _RosterPager({
    required this.people,
    required this.onTapPerson,
    this.onDragStarted,
    this.onDragEnd,
  });

  final List<Person> people;
  final void Function(Person person) onTapPerson;
  final void Function(Person person)? onDragStarted;
  final VoidCallback? onDragEnd;

  @override
  State<_RosterPager> createState() => _RosterPagerState();
}

class _RosterPagerState extends State<_RosterPager> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    setState(() => _page = page);
    if (_controller.hasClients) {
      _controller.animateToPage(
        page,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageCount =
        widget.people.isEmpty ? 1 : (widget.people.length / _kRosterPageSize).ceil();
    final page = _page.clamp(0, pageCount - 1);
    if (page != _page) {
      // The roster shrank (e.g. a delete) and our old page no longer
      // exists; snap back onto the new last page after this build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _page = page);
      });
    }

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: page > 0 ? () => _goToPage(page - 1) : null,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pageCount,
                  onPageChanged: (value) => setState(() => _page = value),
                  itemBuilder: (context, pageIndex) {
                    final start = pageIndex * _kRosterPageSize;
                    final end =
                        (start + _kRosterPageSize).clamp(0, widget.people.length);
                    final pagePeople = widget.people.sublist(start, end);
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Size cells so the grid fills exactly the space
                        // the member-cards area was given, with no leftover
                        // gap or overflow.
                        final cellWidth = (constraints.maxWidth -
                                (_kRosterCols - 1) * _kRosterSpacing) /
                            _kRosterCols;
                        final cellHeight = (constraints.maxHeight -
                                (_kRosterRows - 1) * _kRosterSpacing) /
                            _kRosterRows;
                        return GridView.count(
                          crossAxisCount: _kRosterCols,
                          childAspectRatio: cellWidth / cellHeight,
                          mainAxisSpacing: _kRosterSpacing,
                          crossAxisSpacing: _kRosterSpacing,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (final person in pagePeople)
                              PersonCard(
                                person: person,
                                onTap: () => widget.onTapPerson(person),
                                onDragStarted: widget.onDragStarted == null
                                    ? null
                                    : () => widget.onDragStarted!(person),
                                onDragEnd: widget.onDragEnd,
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: page < pageCount - 1 ? () => _goToPage(page + 1) : null,
              ),
            ],
          ),
        ),
        if (pageCount > 1)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < pageCount; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () => _goToPage(i),
                      child: Container(
                        width: i == page ? 10 : 8,
                        height: i == page ? 10 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == page
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// One row of the board table (`fixed_list`, `main_members` or
/// `sub_members`). [cellBuilder] renders that row's cell for a given
/// position index, so single-assignment areas (Lineup, Main members) and
/// the multi-assignment Sub members area can share the same table layout.
class _BoardRow {
  const _BoardRow({required this.title, required this.cellBuilder});

  final String title;
  final Widget Function(int positionIndex) cellBuilder;
}

const double _kTableLabelColWidth = 108;
const double _kTableHeaderHeight = 28;
const double _kTableRowHeight = 72;

/// The board as a table: one column per position (matching
/// [positionLabels]) and one row per [_BoardRow] (Lineup, Main members,
/// Sub members), so a person's slot in each list lines up under the same
/// position header. Columns are flex-sized so the table always spans the
/// full available width instead of overflowing or leaving space unused.
class _PositionTable extends StatelessWidget {
  const _PositionTable({
    required this.positionLabels,
    required this.rows,
    required this.peopleById,
    this.draggingPersonPositions,
  });

  /// The current play's 11 position labels, in index order.
  final List<String> positionLabels;
  final List<_BoardRow> rows;
  final Map<int, Person> peopleById;

  /// Position indices the currently-dragged person is IN for, or null when
  /// no card is being dragged. Drives the header row's IN/OUT highlight.
  final Set<int>? draggingPersonPositions;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      columnWidths: {
        0: const FixedColumnWidth(_kTableLabelColWidth),
        for (var i = 1; i <= kPositionCount; i++) i: const FlexColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            const SizedBox(height: _kTableHeaderHeight),
            for (var index = 0; index < kPositionCount; index++)
              SizedBox(
                height: _kTableHeaderHeight,
                child: Container(
                  color: draggingPersonPositions == null
                      ? null
                      : (draggingPersonPositions!.contains(index)
                          ? Colors.green.shade100
                          : Colors.red.shade100),
                  child: Center(
                    child: Text(
                      positionLabels[index],
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
          ],
        ),
        for (final row in rows)
          TableRow(
            children: [
              SizedBox(
                height: _kTableRowHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      row.title,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
              for (var index = 0; index < kPositionCount; index++)
                SizedBox(
                  height: _kTableRowHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: row.cellBuilder(index),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _PositionSlot extends StatelessWidget {
  const _PositionSlot({
    required this.assigned,
    required this.onWillAccept,
    required this.onAccept,
    required this.onClear,
  });

  final Person? assigned;
  final bool Function(Person person) onWillAccept;
  final void Function(Person person) onAccept;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Person>(
      onWillAcceptWithDetails: (details) => onWillAccept(details.data),
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final highlighted = candidateData.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: highlighted
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              width: highlighted ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(6),
            color: assigned == null ? null : Theme.of(context).colorScheme.primaryContainer,
          ),
          padding: const EdgeInsets.all(6),
          child: Stack(
            children: [
              Center(
                child: Text(
                  assigned?.name ?? '—',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              if (onClear != null)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 16,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close),
                    onPressed: onClear,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// A drop target that, unlike [_PositionSlot], accepts several people at
/// once (used for Sub members). Each assigned person shows as a chip with
/// its own delete button; the chips wrap and scroll if they overflow.
class _MultiPositionSlot extends StatelessWidget {
  const _MultiPositionSlot({
    required this.assigned,
    required this.onWillAccept,
    required this.onAccept,
    required this.onRemove,
  });

  final List<Person> assigned;
  final bool Function(Person person) onWillAccept;
  final void Function(Person person) onAccept;
  final void Function(int personId) onRemove;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Person>(
      onWillAcceptWithDetails: (details) => onWillAccept(details.data),
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final highlighted = candidateData.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: highlighted
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              width: highlighted ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(6),
            color: assigned.isEmpty
                ? null
                : Theme.of(context).colorScheme.primaryContainer,
          ),
          padding: const EdgeInsets.all(4),
          child: assigned.isEmpty
              ? const Center(child: Text('—'))
              : SingleChildScrollView(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (final person in assigned)
                        Chip(
                          label: Text(
                            person.name,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                          deleteIcon: const Icon(Icons.close, size: 14),
                          onDeleted: () => onRemove(person.id),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
