import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/concept_card.dart';
import '../controllers/counter_controller.dart';
import '../controllers/task_controller.dart';

/// [GetXView] demonstrates GetX reactive and simple state management.
///
/// CONTROLLER LIFECYCLE:
/// Controllers are injected into memory using `Get.put()`.
/// They can be retrieved anywhere in the app without passing context using `Get.find()`.
class GetXView extends StatefulWidget {
  const GetXView({super.key});

  @override
  State<GetXView> createState() => _GetXViewState();
}

class _GetXViewState extends State<GetXView> {
  // Inject the controllers into Get's dependency container
  final CounterController counterController = Get.put(CounterController());
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    // Optional cleanup: Get.delete<CounterController>() if you want to remove on back navigation
    super.dispose();
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Add GetX Task'),
        content: TextField(
          controller: textEditingController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Test GetX Obx update',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            _submitTask();
            Navigator.pop(dialogCtx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              _submitTask();
              Navigator.pop(dialogCtx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submitTask() {
    if (textEditingController.text.trim().isNotEmpty) {
      taskController.addTask(textEditingController.text.trim());
      textEditingController.clear();
      // Demonstrate GetX snackbar (no context required)
      Get.snackbar(
        'Task Added',
        'New task has been added reactively!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.orange.shade800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Pattern'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ConceptExplanationCard(
            title: 'GetX (Micro-Framework)',
            description:
                'GetX is a high-performance framework combining reactive state management, '
                'intelligent dependency injection, and context-free route management.',
            accentColor: primaryColor,
            icon: Icons.flash_on_rounded,
            bulletPoints: const [
              '.obs: Turns any variable into an observable stream (RxInt, RxString, RxList).',
              'Obx(() => Widget): Automatically listens to all .obs variables used inside its builder.',
              'GetBuilder: Simple non-reactive manager that rebuilds only when update() is invoked.',
              'Get.put() / Get.find(): Context-free dependency injection.',
              'Get.snackbar() / Get.to(): Context-free utilities (requires GetMaterialApp).',
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 1: Reactive Counter (.obs + Obx) ---
          _buildCounterSection(context, primaryColor, theme),
          const SizedBox(height: 20),

          // --- Section 2: Simple GetBuilder Counter ---
          _buildGetBuilderSection(context, primaryColor, theme),
          const SizedBox(height: 20),

          // --- Section 3: Reactive Task List ---
          _buildTaskSection(context, primaryColor, theme),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  Widget _buildCounterSection(
    BuildContext context,
    Color primaryColor,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.numbers, color: primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '1. Reactive Counter (Obx + .obs)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Obx rebuilds when counterController.count (.obs) changes
            Obx(
              () => Text(
                '${counterController.count}',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: counterController.decrement,
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                ),
                IconButton.filledTonal(
                  onPressed: counterController.reset,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset',
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: counterController.increment,
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetBuilderSection(
    BuildContext context,
    Color primaryColor,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2. Simple Counter (GetBuilder + update)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GetBuilder<CounterController>(
                    builder: (ctrl) => Text(
                      'Manual value: ${ctrl.manualCount}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: counterController.incrementManual,
              child: const Text('update()'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSection(
    BuildContext context,
    Color primaryColor,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            final tasks = taskController.tasks;
            final completedCount = taskController.completedCount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.checklist, color: primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Task List (RxList.obs)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text('$completedCount/${tasks.length} done'),
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      labelStyle: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (tasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Text('No tasks yet. Tap "+ New Task" to add one!'),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    separatorBuilder: (_, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Checkbox(
                          value: task.isCompleted,
                          activeColor: primaryColor,
                          onChanged: (_) {
                            taskController.toggleTask(task.id);
                          },
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: task.isCompleted ? Colors.grey : Colors.black87,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            taskController.removeTask(task.id);
                          },
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
