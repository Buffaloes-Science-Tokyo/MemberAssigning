import 'package:flutter/material.dart';

import 'data/database.dart';
import 'ui/lineup_board_page.dart';

void main() {
  runApp(KickMembersApp(db: AppDatabase()));
}

class KickMembersApp extends StatelessWidget {
  const KickMembersApp({super.key, required this.db});

  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kick Members',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: FutureBuilder<void>(
        future: db.seedIfEmpty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return LineupBoardPage(db: db);
        },
      ),
    );
  }
}
