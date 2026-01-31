import 'package:flutter/material.dart';

import '../domain/models.dart';
import '../domain/repo_scope.dart';
import 's20_request_call_screen.dart';

class S10PostListScreen extends StatefulWidget {
  const S10PostListScreen({super.key});

  @override
  State<S10PostListScreen> createState() => _S10PostListScreenState();
}

class _S10PostListScreenState extends State<S10PostListScreen> {
  Future<List<Post>>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= RepoScope.of(context).getNearbyPosts(lat: 37.5651, lng: 126.9783, radiusM: 500);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S10 Nearby Posts')),
      body: FutureBuilder<List<Post>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(child: Text('No posts nearby.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.intro ?? 'No intro'),
                trailing: Text(post.distanceM == null ? '' : '${post.distanceM!.toStringAsFixed(0)}m'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => S20RequestCallScreen(post: post)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
