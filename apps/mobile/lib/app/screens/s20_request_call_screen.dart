import 'package:flutter/material.dart';

import '../domain/models.dart';
import '../domain/repo_scope.dart';
import 's21_incoming_call_screen.dart';
import 's22_timer_screen.dart';

class S20RequestCallScreen extends StatefulWidget {
  const S20RequestCallScreen({super.key, required this.post});

  final Post post;

  @override
  State<S20RequestCallScreen> createState() => _S20RequestCallScreenState();
}

class _S20RequestCallScreenState extends State<S20RequestCallScreen> {
  CallSession? _session;
  bool _loading = false;

  Future<void> _requestCall() async {
    setState(() => _loading = true);
    try {
      final repo = RepoScope.of(context);
      final session = await repo.requestCall(widget.post.id);
      if (!mounted) return;
      setState(() => _session = session);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request failed: $error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    return Scaffold(
      appBar: AppBar(title: const Text('S20 Request Call')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.post.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(widget.post.intro ?? 'No intro'),
            const SizedBox(height: 16),
            if (session == null)
              ElevatedButton(
                onPressed: _loading ? null : _requestCall,
                child: Text(_loading ? 'Requesting...' : 'Request call (hold 500 credits)'),
              )
            else ...[
              Text('Session created: ${session.id}'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => S22TimerScreen(session: session)),
                ),
                child: const Text('Proceed to S22 timer'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => S21IncomingCallScreen(session: session)),
                ),
                child: const Text('Simulate host incoming (S21)'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
