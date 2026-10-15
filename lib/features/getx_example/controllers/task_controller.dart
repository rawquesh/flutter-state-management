import 'package:get/get.dart';
import '../../../shared/models/task_item.dart';

/// [TaskController] demonstrates reactive collections in GetX.
///
/// Notice how `<TaskItem>[...].obs` makes the entire list observable.
/// Methods like `.add()`, `.removeWhere()`, and index reassignments
/// automatically notify any [Obx] observing the list!
class TaskController extends GetxController {
  final RxList<TaskItem> tasks = <TaskItem>[
    const TaskItem(
      id: '1',
      title: 'Make variables reactive with .obs (e.g. 0.obs, [].obs)',
      isCompleted: true,
    ),
    const TaskItem(
      id: '2',
      title: 'Wrap reactive UI widgets with Obx(() => ...)',
      isCompleted: false,
    ),
    const TaskItem(
      id: '3',
      title: 'Inject controllers anywhere using Get.put() or Get.find()',
      isCompleted: false,
    ),
  ].obs;

  int get completedCount => tasks.where((t) => t.isCompleted).length;

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    tasks.add(
      TaskItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        isCompleted: false,
      ),
    );
  }

  void toggleTask(String id) {
    final index = tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      tasks[index] = tasks[index].copyWith(
        isCompleted: !tasks[index].isCompleted,
      );
    }
  }

  void removeTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }
}
