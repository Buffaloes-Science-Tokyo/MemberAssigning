import 'package:flutter/material.dart';

import '../data/positions.dart';

/// Lets the coach create a new play or edit an existing one: its category,
/// name, and its 11 position labels (independent of any other play's).
class PlaySettingsDialog extends StatefulWidget {
  const PlaySettingsDialog({
    super.key,
    required this.title,
    this.initialCategory = '',
    this.initialName = '',
    required this.initialLabels,
    required this.onSave,
  });

  final String title;
  final String initialCategory;
  final String initialName;

  /// The starting position labels, exactly [kPositionCount] entries.
  final List<String> initialLabels;

  final void Function(String category, String name, List<String> labels) onSave;

  @override
  State<PlaySettingsDialog> createState() => _PlaySettingsDialogState();
}

class _PlaySettingsDialogState extends State<PlaySettingsDialog> {
  late final TextEditingController _categoryController =
      TextEditingController(text: widget.initialCategory);
  late final TextEditingController _nameController =
      TextEditingController(text: widget.initialName);
  late final List<TextEditingController> _labelControllers = [
    for (var i = 0; i < kPositionCount; i++)
      TextEditingController(text: widget.initialLabels[i]),
  ];

  @override
  void dispose() {
    _categoryController.dispose();
    _nameController.dispose();
    for (final controller in _labelControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              const Text('Position labels'),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < kPositionCount; i++)
                    SizedBox(
                      width: 72,
                      child: TextField(
                        controller: _labelControllers[i],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: '#${i + 1}'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final category = _categoryController.text.trim();
            final name = _nameController.text.trim();
            if (category.isEmpty || name.isEmpty) return;
            final labels = [
              for (final controller in _labelControllers) controller.text.trim(),
            ];
            widget.onSave(category, name, labels);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
