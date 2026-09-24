import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kick_members/data/database.dart';
import 'package:kick_members/sync/snapshot.dart';
import 'package:kick_members/sync/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory stand-in for `api/sync.js`: one snapshot + a version counter,
/// with the same 401/409 rules.
http.Response _res(Object body, int status) =>
    http.Response.bytes(utf8.encode(jsonEncode(body)), status);

class FakeServer {
  int version = 0;
  Map<String, dynamic>? data;

  late final client = MockClient((req) async {
    if (req.headers['Authorization'] != 'Bearer secret') {
      return _res({'error': 'unauthorized'}, 401);
    }
    if (req.method == 'GET') {
      return _res({'version': version, 'updatedAt': null, 'data': data}, 200);
    }
    final body = jsonDecode(req.body) as Map<String, dynamic>;
    if (body['baseVersion'] != version) {
      return _res({'version': version}, 409);
    }
    version++;
    data = jsonDecode(jsonEncode(body['data'])) as Map<String, dynamic>;
    return _res({'version': version}, 200);
  });
}

Future<(AppDatabase, SyncService)> device(FakeServer server) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  // getInstance() caches a singleton; reset it so each simulated device
  // gets its own preferences.
  SharedPreferences.setMockInitialValues({});
  SharedPreferences.resetStatic();
  final prefs = await SharedPreferences.getInstance();
  final sync = SyncService(db, prefs, client: server.client);
  await sync.saveSettings(token: 'secret', serverUrl: 'https://example.test');
  addTearDown(() async {
    sync.dispose();
    await db.close();
  });
  return (db, sync);
}

void main() {
  test('export → import round-trips every table', () async {
    final a = AppDatabase.forTesting(NativeDatabase.memory());
    final b = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(a.close);
    addTearDown(b.close);

    final play = await a.firstPlay();
    final kevin = await a.addPerson('Kevin');
    await a.setPersonGen(kevin, 3);
    await a.setPersonPositions(kevin, play.id, {0, 10});
    await a.assignSlot(play.id, 0, kevin);
    await a.assignMainMember(play.id, 1, null);
    await a.addSubMember(play.id, 2, kevin);
    await a.saveTemplate(play.id, '通常',
        fixed: {0: kevin}, main: {1: null}, sub: {2: {kevin}});

    // b starts with its own unrelated data that must be wiped.
    await b.addPerson('Someone else');

    final snapshot = await a.exportSnapshot();
    await b.importSnapshot(jsonDecode(jsonEncode(snapshot)) as Map<String, dynamic>);

    expect(await b.exportSnapshot(), snapshot);
    // Autoincrement continues past imported ids.
    final next = await b.addPerson('New');
    expect(next, greaterThan(kevin));
  });

  test('first device pushes, second device pulls', () async {
    final server = FakeServer();
    final (dbA, syncA) = await device(server);
    await dbA.firstPlay();
    await dbA.addPerson('Kevin');

    expect(await syncA.sync(), SyncOutcome.pushed);
    expect(server.version, 1);
    expect(await syncA.sync(), SyncOutcome.upToDate);

    final (dbB, syncB) = await device(server);
    await dbB.firstPlay(); // B's own seed data
    final conflict = await syncB.sync().then<SyncConflict?>((_) => null,
        onError: (Object e) => e as SyncConflict);
    expect(conflict!.neverSynced, isTrue);
    expect(await syncB.resolve(conflict, keepLocal: false), SyncOutcome.pulled);

    final names = (await dbB.select(dbB.persons).get()).map((p) => p.name);
    expect(names, ['Kevin']);
    expect(await syncB.sync(), SyncOutcome.upToDate);
  });

  test('local-only change pushes, remote-only change pulls, both conflict',
      () async {
    final server = FakeServer();
    final (dbA, syncA) = await device(server);
    await dbA.firstPlay();
    await syncA.sync();

    // Simulate another device having pushed version 2.
    final (dbB, syncB) = await device(server);
    await syncB.resolve(
      SyncConflict(RemoteState(version: 1, data: server.data), neverSynced: true),
      keepLocal: false,
    );
    await dbB.addPerson('From B');
    expect(await syncB.sync(), SyncOutcome.pushed);
    expect(server.version, 2);

    // A is unchanged → pulls B's person.
    expect(await syncA.sync(), SyncOutcome.pulled);
    expect((await dbA.select(dbA.persons).get()).single.name, 'From B');

    // Both change → conflict; keeping local overwrites the server.
    await dbA.addPerson('A edit');
    await dbB.addPerson('B edit');
    expect(await syncB.sync(), SyncOutcome.pushed);
    SyncConflict? conflict;
    try {
      await syncA.sync();
    } on SyncConflict catch (e) {
      conflict = e;
    }
    expect(conflict, isNotNull);
    expect(conflict!.neverSynced, isFalse);
    expect(await syncA.resolve(conflict, keepLocal: true), SyncOutcome.pushed);
    final serverNames = [
      for (final p in server.data!['persons'] as List) (p as Map)['name'],
    ];
    expect(serverNames, ['From B', 'A edit']);
  });

  test('wrong key is reported', () async {
    final server = FakeServer();
    final (_, sync) = await device(server);
    await sync.saveSettings(token: 'nope', serverUrl: 'https://example.test');
    expect(sync.sync(), throwsA(isA<SyncException>()));
  });

  test('hasLocalChanges tracks edits after a sync', () async {
    final server = FakeServer();
    final (db, sync) = await device(server);
    await db.firstPlay();
    await sync.sync();
    expect(sync.hasLocalChanges, isFalse);

    await db.addPerson('Kevin');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    expect(sync.hasLocalChanges, isTrue);
  });
}
