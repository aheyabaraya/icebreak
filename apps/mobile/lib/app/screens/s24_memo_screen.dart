import 'package:flutter/material.dart';

import '../domain/repo_scope.dart';

class S24MemoScreen extends StatefulWidget {
  const S24MemoScreen({super.key, this.sessionId});

  final String? sessionId;

  @override
  State<S24MemoScreen> createState() => _S24MemoScreenState();
}

class _S24MemoScreenState extends State<S24MemoScreen> {
  final _sessionIdController = TextEditingController();
  final _textController = TextEditingController();
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
    _textController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _loading = true);
    try {
      await RepoScope.of(context).sendMissedCallMemo(
        _sessionIdController.text.trim(),
        _textController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Memo sent')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Send failed: $error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S24 Missed-call Memo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(labelText: 'Session ID'),
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Memo text'),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _send,
              child: Text(_loading ? 'Sending...' : 'Send memo (+100 credits)'),
            ),
          ],
        ),
      ),
    );
  }
}
