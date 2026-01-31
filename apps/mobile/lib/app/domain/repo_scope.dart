import 'package:flutter/widgets.dart';

import 'repository.dart';

class RepoScope extends InheritedWidget {
  const RepoScope({super.key, required this.repo, required super.child});

  final ContractRepository repo;

  static ContractRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RepoScope>();
    if (scope == null) {
      throw StateError('RepoScope not found in widget tree');
    }
    return scope.repo;
  }

  @override
  bool updateShouldNotify(RepoScope oldWidget) => repo != oldWidget.repo;
}
