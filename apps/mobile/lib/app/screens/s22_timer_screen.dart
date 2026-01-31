import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/models.dart';
import '../domain/repo_scope.dart';
import 's23_branch_screen.dart';

class S22TimerScreen extends StatefulWidget {
  const S22TimerScreen({super.key, this.session});

  final CallSession? session;

  @override
  State<S22TimerScreen> createState() => _S22TimerScreenState();
}

class _S22TimerScreenState extends State<S22TimerScreen> {
  Timer? _timer;
  int _secondsLeft = 30;
  final _sessionIdController = TextEditingController();

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

  Future<void> _endCall() async {
    try {
      await RepoScope.of(context).endCall(
        _sessionIdController.text.trim(),
        reasonFlags: {'ended_after_timer': true},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Call ended')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('End failed: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S22 30s Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remaining: $_secondsLeft s'),
            const SizedBox(height: 12),
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(labelText: 'Session ID'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => S23BranchScreen(sessionId: _sessionIdController.text.trim()),
                ),
              ),
              child: const Text('Continue to S23'),
            ),
            TextButton(onPressed: _endCall, child: const Text('End call')),
          ],
        ),
      ),
    );
  }
}
