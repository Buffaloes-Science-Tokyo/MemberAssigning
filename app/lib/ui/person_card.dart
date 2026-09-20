import 'package:flutter/material.dart';

import '../data/database.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({super.key, required this.person, this.onTap});

  final Person person;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Card(
      color: person.isOut ? theme.colorScheme.surfaceContainerHighest : null,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 96,
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

    if (person.isOut) {
      // Absent players can be inspected/edited but not dragged onto the board.
      return card;
    }

    return Draggable<Person>(
      data: person,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(4),
        child: card,
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: card),
      child: card,
    );
  }
}
