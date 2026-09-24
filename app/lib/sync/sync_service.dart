import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database.dart';
import 'snapshot.dart';

/// What the server holds, as returned by `GET /api/sync`.
class RemoteState {
  const RemoteState({required this.version, this.updatedAt, this.data});

  /// 0 means nothing has ever been uploaded.
  final int version;
  final DateTime? updatedAt;
  final Map<String, dynamic>? data;
}

enum SyncOutcome { upToDate, pushed, pulled }

/// Both this device and the server changed since the last sync; the caller
/// must pick a side via [SyncService.resolve].
class SyncConflict implements Exception {
  const SyncConflict(this.remote, {required this.neverSynced});

  final RemoteState remote;

  /// This device has never synced (so its "changes" may just be the seed
  /// roster from first launch).
  final bool neverSynced;
}

class SyncException implements Exception {
  const SyncException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Manual, whole-database sync against `/api/sync` (Vercel + Neon).
///
/// The server keeps one snapshot plus a version counter. Locally we remember
/// the version we last synced with and a hash of the database as it was
/// then, so a sync can tell who changed:
/// - only the server → pull, only this device → push, neither → no-op;
/// - both → [SyncConflict], and the user picks which side wins.
class SyncService extends ChangeNotifier {
  SyncService(this.db, this._prefs, {http.Client? client})
      : _client = client ?? http.Client() {
    _updatesSub = db.tableUpdates().listen((_) => _scheduleDirtyCheck());
    _scheduleDirtyCheck();
  }

  static Future<SyncService> create(AppDatabase db) async {
    return SyncService(db, await SharedPreferences.getInstance());
  }

  static const _kToken = 'sync.token';
  static const _kServerUrl = 'sync.serverUrl';
  static const _kVersion = 'sync.version';
  static const _kHash = 'sync.hash';
  static const _kSyncedAt = 'sync.syncedAt';

  /// Build-time default for non-web builds, e.g.
  /// `--dart-define=SYNC_SERVER_URL=https://kick-members.vercel.app`.
  static const _defaultServerUrl = String.fromEnvironment('SYNC_SERVER_URL');

  final AppDatabase db;
  final SharedPreferences _prefs;
  final http.Client _client;
  late final StreamSubscription<void> _updatesSub;
  Timer? _dirtyTimer;

  bool _busy = false;
  bool _hasLocalChanges = false;

  bool get busy => _busy;

  /// Whether the local database differs from what was last synced.
  bool get hasLocalChanges => _hasLocalChanges;

  String get token => _prefs.getString(_kToken) ?? '';

  /// Empty means "the site this web app is served from".
  String get serverUrl => _prefs.getString(_kServerUrl) ?? _defaultServerUrl;

  bool get isConfigured => token.isNotEmpty && (kIsWeb || serverUrl.isNotEmpty);

  DateTime? get lastSyncedAt {
    final raw = _prefs.getString(_kSyncedAt);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  int? get _lastVersion => _prefs.getInt(_kVersion);

  Future<void> saveSettings({required String token, required String serverUrl}) async {
    await _prefs.setString(_kToken, token.trim());
    await _prefs.setString(_kServerUrl, serverUrl.trim());
    notifyListeners();
  }

  /// Runs one sync. Throws [SyncConflict] when both sides changed, and
  /// [SyncException] for network/auth/server problems.
  Future<SyncOutcome> sync() {
    return _run(() async {
      final local = await db.exportSnapshot();
      final dirty = _hash(local) != _prefs.getString(_kHash);
      final remote = await _fetch();
      final base = _lastVersion;

      if (remote.version == 0) {
        await _push(local, baseVersion: 0);
        return SyncOutcome.pushed;
      }
      if (remote.version == base) {
        if (!dirty) return SyncOutcome.upToDate;
        await _push(local, baseVersion: base!);
        return SyncOutcome.pushed;
      }
      if (!dirty && base != null) {
        await _pull(remote);
        return SyncOutcome.pulled;
      }
      throw SyncConflict(remote, neverSynced: base == null);
    });
  }

  /// Settles a [SyncConflict]: `keepLocal` overwrites the server with this
  /// device's data, otherwise the server's data replaces this device's.
  Future<SyncOutcome> resolve(SyncConflict conflict, {required bool keepLocal}) {
    return _run(() async {
      if (keepLocal) {
        await _push(await db.exportSnapshot(), baseVersion: conflict.remote.version);
        return SyncOutcome.pushed;
      }
      await _pull(conflict.remote);
      return SyncOutcome.pulled;
    });
  }

  Future<T> _run<T>(Future<T> Function() body) async {
    if (_busy) throw const SyncException('Sync is already running.');
    if (!isConfigured) throw const SyncException('Set the sync key first.');
    _busy = true;
    notifyListeners();
    try {
      return await body();
    } finally {
      _busy = false;
      await _checkDirty();
    }
  }

  Future<RemoteState> _fetch() async {
    final res = await _send(() => _client.get(_endpoint, headers: _headers));
    final body = _json(res);
    final updatedAt = body['updatedAt'] as String?;
    return RemoteState(
      version: body['version'] as int,
      updatedAt: updatedAt == null ? null : DateTime.tryParse(updatedAt),
      data: body['data'] as Map<String, dynamic>?,
    );
  }

  Future<void> _push(Map<String, dynamic> local, {required int baseVersion}) async {
    final res = await _send(() => _client.put(
          _endpoint,
          headers: {..._headers, 'Content-Type': 'application/json'},
          body: jsonEncode({
            'baseVersion': baseVersion,
            'schemaVersion': db.schemaVersion,
            'data': local,
          }),
        ));
    final body = _json(res);
    await _markSynced(body['version'] as int, local);
  }

  Future<void> _pull(RemoteState remote) async {
    await db.importSnapshot(remote.data ?? const {});
    // Hash what actually landed locally, not the server's JSON, so the next
    // dirty check compares like with like.
    await _markSynced(remote.version, await db.exportSnapshot());
  }

  Future<void> _markSynced(int version, Map<String, dynamic> snapshot) async {
    await _prefs.setInt(_kVersion, version);
    await _prefs.setString(_kHash, _hash(snapshot));
    await _prefs.setString(_kSyncedAt, DateTime.now().toIso8601String());
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    final http.Response res;
    try {
      res = await request().timeout(const Duration(seconds: 20));
    } catch (_) {
      throw const SyncException("Couldn't reach the server. Are you online?");
    }
    switch (res.statusCode) {
      case >= 200 && < 300:
        return res;
      case 401:
        throw const SyncException('The sync key is wrong.');
      case 409:
        throw const SyncException(
          'The server changed while syncing. Please sync again.',
        );
      default:
        throw SyncException(
          'Server error (${res.statusCode}): ${utf8.decode(res.bodyBytes)}',
        );
    }
  }

  /// Decodes as UTF-8 regardless of the response's declared charset (the
  /// http package falls back to Latin-1, which would mangle Japanese names).
  static Map<String, dynamic> _json(http.Response res) =>
      jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

  Uri get _endpoint {
    final base = serverUrl.isEmpty ? Uri.base : Uri.parse(serverUrl);
    return base.resolve('/api/sync');
  }

  Map<String, String> get _headers => {'Authorization': 'Bearer $token'};

  static String _hash(Map<String, dynamic> snapshot) =>
      sha256.convert(utf8.encode(jsonEncode(snapshot))).toString();

  void _scheduleDirtyCheck() {
    _dirtyTimer?.cancel();
    _dirtyTimer = Timer(const Duration(milliseconds: 300), _checkDirty);
  }

  Future<void> _checkDirty() async {
    final hash = _hash(await db.exportSnapshot());
    _hasLocalChanges = hash != _prefs.getString(_kHash);
    notifyListeners();
  }

  @override
  void dispose() {
    _dirtyTimer?.cancel();
    _updatesSub.cancel();
    super.dispose();
  }
}
