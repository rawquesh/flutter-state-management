import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/concept_card.dart';
import '../providers/counter_riverpod.dart';
import '../providers/task_riverpod.dart';

/// [RiverpodView] demonstrates Riverpod state management.
///
/// NOTE: Riverpod requires a [ProviderScope] at the root of the app.
/// We will place [ProviderScope] in `main.dart`.
///
/// This widget extends [ConsumerStatefulWidget], giving it access to [ref]
/// in both `build(BuildContext context)` and lifecycle methods via `ConsumerState`.
class RiverpodView extends ConsumerStatefulWidget {
  const RiverpodView({super.key});

  @override
  ConsumerState<RiverpodView> createState() => _RiverpodViewState();
}

class _RiverpodViewState extends ConsumerState<RiverpodView> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Add Riverpod Task'),
        content: TextField(
          controller: _taskController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Try Riverpod AsyncValue',
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
    if (_taskController.text.trim().isNotEmpty) {
      // NOTE: Using `ref.read` to trigger methods on the notifier.
      // We use `.notifier` to access the methods defined on TaskRiverpodNotifier.
      ref.read(taskRiverpodProvider.notifier).addTask(_taskController.text.trim());
      _taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.teal.shade700;

    // Watching state directly with `ref.watch`
    final count = ref.watch(counterRiverpodProvider);
    final tasks = ref.watch(taskRiverpodProvider);
    final completedCount = ref.watch(completedTaskCountRiverpodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Pattern'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ConceptExplanationCard(
            title: 'Riverpod (Compile-Time Safe)',
            description:
                'Riverpod is a complete rewrite of Provider by the same author (Remi Rousselet). '
                'It is compile-time safe, does not depend on BuildContext, and supports dependency overrides and auto-dispose.',
            accentColor: primaryColor,
            icon: Icons.waves_rounded,
            bulletPoints: const [
              'ProviderScope: Root widget holding the state container.',
              'ref.watch(provider): Subscribes to provider changes and triggers rebuilds.',
              'ref.read(provider.notifier): Reads the notifier to invoke business methods without subscribing.',
              'Computed Providers: e.g. Provider<int> derived from taskRiverpodProvider.',
              'No ProviderNotFoundException: Everything is resolved at compile time!',
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 1: Counter Demo ---
          _buildCounterSection(context, primaryColor, theme, count),
          const SizedBox(height: 20),

          // --- Section 2: Task List Demo ---
          _buildTaskSection(context, primaryColor, theme, tasks, completedCount),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        onPressed: _showAddTaskDialog,
      ),
    );
  }

  Widget _buildCounterSection(
    BuildContext context,
    Color primaryColor,
    ThemeData theme,
    int count,
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
                    'Counter (ref.watch)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              '$count',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
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
                  onPressed: () =>
                      ref.read(counterRiverpodProvider.notifier).decrement(),
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                ),
                IconButton.filledTonal(
                  onPressed: () =>
                      ref.read(counterRiverpodProvider.notifier).reset(),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset',
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () =>
                      ref.read(counterRiverpodProvider.notifier).increment(),
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

  Widget _buildTaskSection(
    BuildContext context,
    Color primaryColor,
    ThemeData theme,
    List tasks,
    int completedCount,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Task List (Notifier + Computed Provider)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('$completedCount/${tasks.length} done'),
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
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
                        ref.read(taskRiverpodProvider.notifier).toggleTask(task.id);
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
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        ref.read(taskRiverpodProvider.notifier).removeTask(task.id);
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
