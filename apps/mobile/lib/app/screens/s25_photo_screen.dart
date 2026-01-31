import 'package:flutter/material.dart';

import '../domain/repo_scope.dart';

class S25PhotoScreen extends StatefulWidget {
  const S25PhotoScreen({super.key, this.sessionId});

  final String? sessionId;

  @override
  State<S25PhotoScreen> createState() => _S25PhotoScreenState();
}

class _S25PhotoScreenState extends State<S25PhotoScreen> {
  final _sessionIdController = TextEditingController();
  final _pathController = TextEditingController(text: 'photos/session_demo.jpg');
  String? _lastPath;
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
    _pathController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await RepoScope.of(context).submitNormalPhoto(
        _sessionIdController.text.trim(),
        _pathController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo submitted')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submit failed: $error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _view() async {
    setState(() => _loading = true);
    try {
      final path = await RepoScope.of(context).viewPhoto(_sessionIdController.text.trim());
      if (!mounted) return;
      setState(() => _lastPath = path);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('View failed: $error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S25 Normal Photo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(labelText: 'Session ID'),
            ),
            TextField(
              controller: _pathController,
              decoration: const InputDecoration(labelText: 'Storage path'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: const Text('Submit photo'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _loading ? null : _view,
                  child: const Text('View photo'),
                ),
              ],
            ),
            if (_lastPath != null) ...[
              const SizedBox(height: 12),
              Text('Latest path: $_lastPath'),
            ],
            const SizedBox(height: 12),
            const Text('Camera capture stub only.'),
          ],
        ),
      ),
    );
  }
}
