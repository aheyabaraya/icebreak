import 'package:flutter/material.dart';

import '../domain/repo_scope.dart';

class S26MeetDecisionScreen extends StatefulWidget {
  const S26MeetDecisionScreen({super.key, this.sessionId});

  final String? sessionId;

  @override
  State<S26MeetDecisionScreen> createState() => _S26MeetDecisionScreenState();
}

class _S26MeetDecisionScreenState extends State<S26MeetDecisionScreen> {
  final _sessionIdController = TextEditingController();
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
    _sessionIdController.dispose();
    super.dispose();
  }

  Future<void> _setDecision(bool decision) async {
    setState(() => _loading = true);
    try {
      await RepoScope.of(context).meetDecision(_sessionIdController.text.trim(), decision);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Decision recorded: ${decision ? 'yes' : 'no'}')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Decision failed: $error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S26 Meet Decision')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(labelText: 'Session ID'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : () => _setDecision(true),
                  child: const Text('Yes'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _loading ? null : () => _setDecision(false),
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
