import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../sync/sync_service.dart';

/// AppBar actions for manual sync: a "Sync" button (with a dot when this
/// device has unsynced changes) and a button for the sync settings.
class SyncActions extends StatelessWidget {
  const SyncActions({super.key, required this.sync});

  final SyncService sync;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sync,
      builder: (context, _) {
        final lastSyncedAt = sync.lastSyncedAt;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: lastSyncedAt == null
                  ? 'Sync (never synced)'
                  : 'Sync (last: ${_formatTime(lastSyncedAt)})',
              onPressed: sync.busy ? null : () => _sync(context),
              icon: sync.busy
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Badge(
                      isLabelVisible: sync.hasLocalChanges,
                      smallSize: 8,
                      child: const Icon(Icons.sync),
                    ),
            ),
            IconButton(
              tooltip: 'Sync settings',
              onPressed: () => _openSettings(context),
              icon: const Icon(Icons.cloud_outlined),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sync(BuildContext context) async {
    if (!sync.isConfigured) {
      final saved = await _openSettings(context);
      if (!saved || !context.mounted) return;
    }
    try {
      final outcome = await sync.sync();
      if (context.mounted) _report(context, outcome);
    } on SyncConflict catch (conflict) {
      if (!context.mounted) return;
      final keepLocal = await _askConflict(context, conflict);
      if (keepLocal == null || !context.mounted) return;
      try {
        final outcome = await sync.resolve(conflict, keepLocal: keepLocal);
        if (context.mounted) _report(context, outcome);
      } on SyncException catch (e) {
        if (context.mounted) _snack(context, e.message);
      }
    } on SyncException catch (e) {
      if (context.mounted) _snack(context, e.message);
    }
  }

  void _report(BuildContext context, SyncOutcome outcome) {
    _snack(context, switch (outcome) {
      SyncOutcome.upToDate => 'Already up to date.',
      SyncOutcome.pushed => 'Uploaded this device\'s data to the server.',
      SyncOutcome.pulled => 'Downloaded the latest data from the server.',
    });
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Returns true to keep this device's data, false to take the server's,
  /// null if cancelled.
  Future<bool?> _askConflict(BuildContext context, SyncConflict conflict) {
    final updatedAt = conflict.remote.updatedAt;
    final serverWhen = updatedAt == null ? '' : ' (updated ${_formatTime(updatedAt)})';
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync conflict'),
        content: Text(
          conflict.neverSynced
              ? 'The server already has data$serverWhen, and this device has '
                  'never synced.\n\nUsually you want to use the server\'s data. '
                  'Whichever side you don\'t pick is overwritten.'
              : 'Both this device and the server$serverWhen changed since '
                  'the last sync.\n\nPick which one to keep. The other side is '
                  'overwritten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keep this device'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Use server'),
          ),
        ],
      ),
    );
  }

  Future<bool> _openSettings(BuildContext context) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => _SyncSettingsDialog(sync: sync),
    );
    return saved ?? false;
  }

  static String _formatTime(DateTime t) {
    final local = t.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.month}/${local.day} ${two(local.hour)}:${two(local.minute)}';
  }
}

class _SyncSettingsDialog extends StatefulWidget {
  const _SyncSettingsDialog({required this.sync});

  final SyncService sync;

  @override
  State<_SyncSettingsDialog> createState() => _SyncSettingsDialogState();
}

class _SyncSettingsDialogState extends State<_SyncSettingsDialog> {
  late final _token = TextEditingController(text: widget.sync.token);
  late final _serverUrl = TextEditingController(text: widget.sync.serverUrl);
  bool _obscure = true;

  @override
  void dispose() {
    _token.dispose();
    _serverUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sync settings'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _token,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Sync key',
                helperText: 'The SYNC_TOKEN set on Vercel',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _serverUrl,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: 'Server URL',
                hintText: 'https://….vercel.app',
                helperText: kIsWeb ? 'Leave empty to use this site' : null,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            await widget.sync.saveSettings(
              token: _token.text,
              serverUrl: _serverUrl.text,
            );
            if (context.mounted) Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
