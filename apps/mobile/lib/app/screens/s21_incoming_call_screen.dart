import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/models.dart';
import '../domain/repo_scope.dart';
import 's22_timer_screen.dart';

class S21IncomingCallScreen extends StatefulWidget {
  const S21IncomingCallScreen({super.key, this.session});

  final CallSession? session;

  @override
  State<S21IncomingCallScreen> createState() => _S21IncomingCallScreenState();
}

class _S21IncomingCallScreenState extends State<S21IncomingCallScreen> {
  final _sessionIdController = TextEditingController();
  Timer? _timer;
  int _secondsLeft = 20;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.session != null) {
      _sessionIdController.text = widget.session!.id;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sessionIdController.dispose();
    super.dispose();
  }

  Future<void> _accept() async {
    setState(() => _loading = true);
    try {
      final repo = RepoScope.of(context);
      final sessionId = _sessionIdController.text.trim();
      final session = await repo.acceptCall(sessionId);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => S22TimerScreen(session: session)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Accept failed: $error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _decline() async {
    setState(() => _loading = true);
    try {
      final repo = RepoScope.of(context);
      await repo.endCall(_sessionIdController.text.trim(), reasonFlags: {'declined': true});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Declined call')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Decline failed: $error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S21 Incoming Call')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time left: $_secondsLeft s'),
            const SizedBox(height: 12),
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(labelText: 'Session ID'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : _accept,
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _loading ? null : _decline,
                  child: const Text('Decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
