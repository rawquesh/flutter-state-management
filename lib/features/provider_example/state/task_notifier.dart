import 'package:flutter/foundation.dart';
import '../../../shared/models/task_item.dart';

/// [TaskNotifier] demonstrates managing a list of items with [ChangeNotifier].
///
/// KEY TAKEAWAYS:
/// - [UnmodifiableListView] prevents direct manipulation of the list from the outside.
/// - Any add, toggle, or delete operation triggers [notifyListeners].
class TaskNotifier extends ChangeNotifier {
  final List<TaskItem> _tasks = [
    const TaskItem(id: '1', title: 'Learn ChangeNotifier & Provider', isCompleted: true),
    const TaskItem(id: '2', title: 'Understand context.watch vs context.read', isCompleted: false),
    const TaskItem(id: '3', title: 'Use Consumer widget for scoped rebuilds', isCompleted: false),
  ];

  /// Exposes tasks as an unmodifiable list so consumers cannot do `tasks.add(...)` without calling notifyListeners.
  List<TaskItem> get tasks => List.unmodifiable(_tasks);

  int get completedCount => _tasks.where((t) => t.isCompleted).length;

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    _tasks.add(
      TaskItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        isCompleted: false,
      ),
    );
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
