import 'package:flutter/material.dart';

import '../services/supabase_stub.dart';
import 's10_post_list_screen.dart';
import 's12_create_post_screen.dart';
import 's21_incoming_call_screen.dart';
import 's22_timer_screen.dart';
import 's23_branch_screen.dart';
import 's24_memo_screen.dart';
import 's25_photo_screen.dart';
import 's26_meet_decision_screen.dart';
import 's27_countdown_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Icebreak Mobile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            SupabaseStub.isInitialized
                ? 'Supabase connected (using real repo).'
                : 'Supabase disabled (using FakeRepo).',
          ),
          const SizedBox(height: 16),
          _NavTile(
            label: 'S10 Nearby posts',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const S10PostListScreen()),
            ),
          ),
          _NavTile(
            label: 'S12~S14 Create post flow',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const S12CreatePostScreen()),
            ),
          ),
          const Divider(height: 32),
          _NavTile(
            label: 'S21 Incoming call (host)',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const S21IncomingCallScreen()),
            ),
          ),
          _NavTile(
            label: 'S22 30s timer',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const S22TimerScreen()),
            ),
          ),
          _NavTile(
            label: 'S23 Branch screen',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const S23BranchScreen()),
            ),
          ),
          _NavTile(
            label: 'S24 Missed-call memo',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const S24MemoScreen()),
            ),
          ),
          _NavTile(
            label: 'S25 Normal photo',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const S25PhotoScreen()),
            ),
          ),
          _NavTile(
            label: 'S26 Meet decision',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const S26MeetDecisionScreen()),
            ),
          ),
          _NavTile(
            label: 'S27 Arrival countdown',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const S27CountdownScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
