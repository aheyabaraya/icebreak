import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/repo_scope.dart';

class S27CountdownScreen extends StatefulWidget {
  const S27CountdownScreen({super.key, this.sessionId});

  final String? sessionId;

  @override
  State<S27CountdownScreen> createState() => _S27CountdownScreenState();
}

class _S27CountdownScreenState extends State<S27CountdownScreen> {
  final _sessionIdController = TextEditingController();
  Timer? _timer;
  int _secondsLeft = 300;
  bool _running = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.sessionId != null) {
      _sessionIdController.text = widget.sessionId!;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sessionIdController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => _loading = true);
    try {
      await RepoScope.of(context).startCountdown(_sessionIdController.text.trim());
      if (!mounted) return;
      _timer?.cancel();
      _secondsLeft = 300;
      _running = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_secondsLeft <= 1) {
          timer.cancel();
          setState(() {
            _secondsLeft = 0;
            _running = false;
          });
        } else {
          setState(() => _secondsLeft -= 1);
        }
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Start failed: $error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _record(String outcome) async {
    setState(() => _loading = true);
    try {
      await RepoScope.of(context).recordOutcome(_sessionIdController.text.trim(), outcome);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Outcome recorded: $outcome')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record failed: $error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S27 Arrival Countdown')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(labelText: 'Session ID'),
            ),
            const SizedBox(height: 12),
            Text('Remaining: ${_secondsLeft ~/ 60}:${(_secondsLeft % 60).toString().padLeft(2, '0')}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _start,
              child: Text(_running ? 'Restart countdown' : 'Start countdown'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : () => _record('meet'),
                  child: const Text('Record meet'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _loading ? null : () => _record('no_show'),
                  child: const Text('Record no-show'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
