import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/positions.dart';
import '../logic/auto_complete_stub.dart';
import 'person_card.dart';
import 'person_settings_dialog.dart';

class LineupBoardPage extends StatefulWidget {
  const LineupBoardPage({super.key, required this.db});

  final AppDatabase db;

  @override
  State<LineupBoardPage> createState() => _LineupBoardPageState();
}

class _LineupBoardPageState extends State<LineupBoardPage> {
  Play? _play;

  @override
  void initState() {
    super.initState();
    widget.db.firstPlay().then((play) => setState(() => _play = play));
  }

  @override
  Widget build(BuildContext context) {
    final play = _play;
    return Scaffold(
      appBar: AppBar(
        title: Text(play == null ? 'Kick Members' : '${play.category} / ${play.name}'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await stubAutoComplete();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Auto-fill: not implemented yet')),
                );
              }
            },
            icon: const Icon(Icons.auto_fix_high, color: Colors.white),
            label: const Text('Auto-fill', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: play == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Person>>(
              stream: widget.db.watchAllPersons(),
              builder: (context, personsSnapshot) {
                final people = personsSnapshot.data ?? const [];
                return StreamBuilder<Map<int, Set<int>>>(
                  stream: widget.db.watchAllPersonPositions(),
                  builder: (context, positionsSnapshot) {
                    final positionsByPerson = positionsSnapshot.data ?? const {};
                    return StreamBuilder<List<LineupSlot>>(
                      stream: widget.db.watchLineupSlots(play.id),
                      builder: (context, slotsSnapshot) {
                        final slots = slotsSnapshot.data ?? const [];
                        final slotByPosition = {
                          for (final slot in slots) slot.positionIndex: slot,
                        };
                        final peopleById = {
                          for (final person in people) person.id: person,
                        };
                        return _Board(
                          db: widget.db,
                          play: play,
                          people: people,
                          positionsByPerson: positionsByPerson,
                          slotByPosition: slotByPosition,
                          peopleById: peopleById,
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({
    required this.db,
    required this.play,
    required this.people,
    required this.positionsByPerson,
    required this.slotByPosition,
    required this.peopleById,
  });

  final AppDatabase db;
  final Play play;
  final List<Person> people;
  final Map<int, Set<int>> positionsByPerson;
  final Map<int, LineupSlot> slotByPosition;
  final Map<int, Person> peopleById;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final person in people)
                PersonCard(
                  person: person,
                  onTap: () => _openSettings(context, person),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                for (var index = 0; index < kPositionCount; index++)
                  _PositionSlot(
                    label: kPositionLabels[index],
                    assigned: slotByPosition[index]?.personId != null
                        ? peopleById[slotByPosition[index]!.personId]
                        : null,
                    onAccept: (person) =>
                        db.assignSlot(play.id, index, person.id),
                    onClear: slotByPosition[index]?.personId == null
                        ? null
                        : () => db.assignSlot(play.id, index, null),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openSettings(BuildContext context, Person person) {
    showDialog<void>(
      context: context,
      builder: (context) => PersonSettingsDialog(
        person: person,
        initialPositions: positionsByPerson[person.id] ?? const {},
        onSave: (isOut, positions) {
          db.setPersonOut(person.id, isOut);
          db.setPersonPositions(person.id, positions);
        },
      ),
    );
  }
}

class _PositionSlot extends StatelessWidget {
  const _PositionSlot({
    required this.label,
    required this.assigned,
    required this.onAccept,
    required this.onClear,
  });

  final String label;
  final Person? assigned;
  final void Function(Person person) onAccept;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Person>(
      onWillAcceptWithDetails: (details) => true,
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
              Align(
                alignment: Alignment.topLeft,
                child: Text(label, style: Theme.of(context).textTheme.labelMedium),
              ),
              Center(
                child: Text(
                  assigned?.name ?? '—',
                  style: Theme.of(context).textTheme.titleSmall,
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
