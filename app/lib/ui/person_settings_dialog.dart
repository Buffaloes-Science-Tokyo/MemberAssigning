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
  final void Function(
    String name,
    int? gen,
    bool isOut,
    bool guest,
    Set<int> positions,
  ) onSave;

  @override
  State<PersonSettingsDialog> createState() => _PersonSettingsDialogState();
}

class _PersonSettingsDialogState extends State<PersonSettingsDialog> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.person.name);
  late final TextEditingController _genController =
      TextEditingController(text: widget.person.gen?.toString() ?? '');
  late bool _isOut = widget.person.isOut;
  late bool _guest = widget.person.guest;
  final Set<int> _positions = {};

  @override
  void initState() {
    super.initState();
    _positions.addAll(widget.initialPositions);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit person'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _genController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '期 (gen)'),
                  ),
                ),
                const SizedBox(width: 8),
                Checkbox(
                  value: _guest,
                  onChanged: (value) =>
                      setState(() => _guest = value ?? false),
                ),
                const Text('GUEST'),
              ],
            ),
            const SizedBox(height: 8),
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
            final gen = int.tryParse(_genController.text.trim());
            widget.onSave(
              _nameController.text.trim(),
              gen,
              _isOut,
              _guest,
              _positions,
            );
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
