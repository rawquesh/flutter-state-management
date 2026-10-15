import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/models/task_item.dart';

/// [TaskCubit] demonstrates the Cubit variation of BLoC.
///
/// WHAT IS A CUBIT?
/// - A Cubit is a simplified subclass of BlocBase that eliminates the need for separate Event classes.
/// - Instead of dispatching events (`bloc.add(Event)`), the UI calls methods directly (`cubit.addTask(...)`).
/// - Inside methods, state is updated via `emit(...)`.
/// - Great for simpler workflows where full event traceability isn't strictly necessary.
class TaskCubit extends Cubit<List<TaskItem>> {
  TaskCubit()
      : super([
          const TaskItem(
            id: '1',
            title: 'Learn BLoC (Event -> State stream)',
            isCompleted: true,
          ),
          const TaskItem(
            id: '2',
            title: 'Use Cubit for direct function calls with emit()',
            isCompleted: false,
          ),
          const TaskItem(
            id: '3',
            title: 'Observe state transitions with BlocObserver',
            isCompleted: false,
          ),
        ]);

  int get completedCount => state.where((task) => task.isCompleted).length;

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    final newTask = TaskItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      isCompleted: false,
    );
    // Emit new immutable list
    emit([...state, newTask]);
  }

  void toggleTask(String id) {
    final updatedList = state.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
    emit(updatedList);
  }

  void removeTask(String id) {
    emit(state.where((task) => task.id != id).toList());
  }
}
