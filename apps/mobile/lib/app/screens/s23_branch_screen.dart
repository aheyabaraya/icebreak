import 'package:flutter/material.dart';

import 's24_memo_screen.dart';
import 's25_photo_screen.dart';
import 's26_meet_decision_screen.dart';
import 's27_countdown_screen.dart';

class S23BranchScreen extends StatefulWidget {
  const S23BranchScreen({super.key, this.sessionId});

  final String? sessionId;

  @override
  State<S23BranchScreen> createState() => _S23BranchScreenState();
}

class _S23BranchScreenState extends State<S23BranchScreen> {
  final _sessionIdController = TextEditingController();

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

  String get _sessionId => _sessionIdController.text.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S23 Branch')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(labelText: 'Session ID'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => S25PhotoScreen(sessionId: _sessionId)),
              ),
              child: const Text('S25 Normal photo'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => S24MemoScreen(sessionId: _sessionId)),
              ),
              child: const Text('S24 Missed-call memo'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => S26MeetDecisionScreen(sessionId: _sessionId)),
              ),
              child: const Text('S26 Meet decision'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => S27CountdownScreen(sessionId: _sessionId)),
              ),
              child: const Text('S27 Arrival countdown'),
            ),
          ],
        ),
      ),
    );
  }
}
