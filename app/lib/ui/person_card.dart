import 'package:flutter/material.dart';

import '../data/database.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({
    super.key,
    required this.person,
    this.onTap,
    this.onDragStarted,
    this.onDragEnd,
  });

  final Person person;
  final VoidCallback? onTap;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Card(
      color: person.isOut ? theme.colorScheme.surfaceContainerHighest : null,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                person.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                person.isOut ? 'OUT' : 'IN',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: person.isOut ? theme.colorScheme.error : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Draggable<Person>(
      data: person,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(4),
        child: card,
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: card),
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd == null ? null : (_) => onDragEnd!(),
      child: card,
    );
  }
}
