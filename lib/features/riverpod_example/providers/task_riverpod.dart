import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/task_item.dart';

/// [TaskRiverpodNotifier] manages task items immutably using Riverpod.
///
/// IMMUTABILITY PRINCIPLE:
/// Rather than modifying an existing list in-place, we emit a brand new list
/// instance (`state = [...]`). This guarantees fast comparisons and prevents
/// accidental state side effects.
class TaskRiverpodNotifier extends Notifier<List<TaskItem>> {
  @override
  List<TaskItem> build() {
    return [
      const TaskItem(
        id: '1',
        title: 'Declare providers as top-level globals (no context needed)',
        isCompleted: true,
      ),
      const TaskItem(
        id: '2',
        title: 'Use ConsumerWidget & WidgetRef to interact with state',
        isCompleted: false,
      ),
      const TaskItem(
        id: '3',
        title: 'Derive computed state using read-only Provider',
        isCompleted: false,
      ),
    ];
  }

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    state = [
      ...state,
      TaskItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        isCompleted: false,
      ),
    ];
  }

  void toggleTask(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isCompleted: !task.isCompleted) else task,
    ];
  }

  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }
}

/// The main provider exposing the list of tasks.
final taskRiverpodProvider =
    NotifierProvider<TaskRiverpodNotifier, List<TaskItem>>(TaskRiverpodNotifier.new);

/// A derived/computed provider.
/// Automatically recalculates ONLY when `taskRiverpodProvider` changes!
final completedTaskCountRiverpodProvider = Provider<int>((ref) {
  final tasks = ref.watch(taskRiverpodProvider);
  return tasks.where((task) => task.isCompleted).length;
});
