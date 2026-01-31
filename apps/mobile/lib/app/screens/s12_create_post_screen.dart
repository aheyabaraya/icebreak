import 'package:flutter/material.dart';

import '../domain/models.dart';
import '../domain/repo_scope.dart';

class S12CreatePostScreen extends StatefulWidget {
  const S12CreatePostScreen({super.key});

  @override
  State<S12CreatePostScreen> createState() => _S12CreatePostScreenState();
}

class _S12CreatePostScreenState extends State<S12CreatePostScreen> {
  final _titleController = TextEditingController();
  final _introController = TextEditingController();
  final _latController = TextEditingController(text: '37.5651');
  final _lngController = TextEditingController(text: '126.9783');
  bool _isSpecial = false;
  int _step = 0;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _introController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final repo = RepoScope.of(context);
      final post = await repo.createPost(
        CreatePostInput(
          title: _titleController.text.trim(),
          intro: _introController.text.trim(),
          pinLat: double.tryParse(_latController.text.trim()) ?? 0,
          pinLng: double.tryParse(_lngController.text.trim()) ?? 0,
          isSpecial: _isSpecial,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created: ${post.title}')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Create failed: $error')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S12~S14 Create Post')),
      body: Stepper(
        currentStep: _step,
        onStepContinue: () {
          if (_step < 2) {
            setState(() => _step += 1);
          } else {
            _submit();
          }
        },
        onStepCancel: () {
          if (_step == 0) {
            Navigator.of(context).pop();
          } else {
            setState(() => _step -= 1);
          }
        },
        controlsBuilder: (context, details) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: _submitting ? null : details.onStepContinue,
                child: Text(_step < 2 ? 'Next' : 'Create'),
              ),
              const SizedBox(width: 12),
              TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
            ],
          );
        },
        steps: [
          Step(
            title: const Text('S12 Pin location'),
            content: Column(
              children: [
                TextField(
                  controller: _latController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                ),
                TextField(
                  controller: _lngController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('S13 Post details'),
            content: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _introController,
                  decoration: const InputDecoration(labelText: 'Intro'),
                ),
                SwitchListTile(
                  title: const Text('Special pass'),
                  value: _isSpecial,
                  onChanged: (value) => setState(() => _isSpecial = value),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('S14 Preview photo'),
            content: const Text('Preview capture stub (camera later).'),
          ),
        ],
      ),
    );
  }
}
