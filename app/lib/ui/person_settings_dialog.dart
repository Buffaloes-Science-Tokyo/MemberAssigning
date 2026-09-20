import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/positions.dart';

/// Lets the coach toggle a person's IN/OUT status and which of the 11
/// positions they're eligible to play.
class PersonSettingsDialog extends StatefulWidget {
  const PersonSettingsDialog({
    super.key,
    required this.person,
    required this.initialPositions,
    required this.onSave,
  });

  final Person person;
  final Set<int> initialPositions;
  final void Function(bool isOut, Set<int> positions) onSave;

  @override
  State<PersonSettingsDialog> createState() => _PersonSettingsDialogState();
}

class _PersonSettingsDialogState extends State<PersonSettingsDialog> {
  late bool _isOut = widget.person.isOut;
  final Set<int> _positions = {};

  @override
  void initState() {
    super.initState();
    _positions.addAll(widget.initialPositions);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.person.name),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('OUT (absent)'),
              value: _isOut,
              onChanged: (value) => setState(() => _isOut = value),
            ),
            const Divider(),
            const Text('Eligible positions'),
            Wrap(
              spacing: 8,
              children: [
                for (var i = 0; i < kPositionCount; i++)
                  FilterChip(
                    label: Text(kPositionLabels[i]),
                    selected: _positions.contains(i),
                    onSelected: (selected) => setState(() {
                      if (selected) {
                        _positions.add(i);
                      } else {
                        _positions.remove(i);
                      }
                    }),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(_isOut, _positions);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
