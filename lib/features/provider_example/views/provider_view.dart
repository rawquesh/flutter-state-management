import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/concept_card.dart';
import '../state/counter_notifier.dart';
import '../state/task_notifier.dart';

/// [ProviderView] demonstrates the complete usage of Provider in Flutter.
///
/// MultiProvider is used here to scope both [CounterNotifier] and [TaskNotifier]
/// to this screen or its subtree.
class ProviderView extends StatelessWidget {
  const ProviderView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterNotifier()),
        ChangeNotifierProvider(create: (_) => TaskNotifier()),
      ],
      child: const _ProviderContent(),
    );
  }
}

class _ProviderContent extends StatefulWidget {
  const _ProviderContent();

  @override
  State<_ProviderContent> createState() => _ProviderContentState();
}

class _ProviderContentState extends State<_ProviderContent> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Add Provider Task'),
        content: TextField(
          controller: _taskController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Test ChangeNotifier',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            _submitTask(context);
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
              _submitTask(context);
              Navigator.pop(dialogCtx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submitTask(BuildContext context) {
    if (_taskController.text.trim().isNotEmpty) {
      // NOTE: Using `context.read<T>()` inside callbacks because we DO NOT want to rebuild this widget when tasks change.
      context.read<TaskNotifier>().addTask(_taskController.text.trim());
      _taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.blue.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Pattern'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ConceptExplanationCard(
            title: 'Provider (ChangeNotifier)',
            description:
                'Provider is an InheritedWidget wrapper endorsed by the Flutter team. '
                'State classes extend ChangeNotifier and invoke notifyListeners() on mutation.',
            accentColor: primaryColor,
            icon: Icons.alt_route_rounded,
            bulletPoints: const [
              'ChangeNotifierProvider: Creates and provides the notifier down the tree.',
              'context.watch<T>(): Subscribes the widget to changes. Rebuilds when notifyListeners() is called.',
              'context.read<T>(): Accesses the notifier without subscribing. Ideal for button callbacks (onPressed).',
              'Consumer<T>: Granular widget wrapper for rebuilding only a sub-tree of the build method.',
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 1: Counter Demo ---
          _buildCounterSection(context, primaryColor, theme),
          const SizedBox(height: 20),

          // --- Section 2: Task List Demo ---
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
                    'Counter (Granular Rebuild via Consumer)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Consumer rebuilds ONLY this text widget when CounterNotifier changes
            Consumer<CounterNotifier>(
              builder: (context, counterNotifier, child) {
                return Text(
                  '${counterNotifier.count}',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.read<CounterNotifier>().decrement(),
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                ),
                IconButton.filledTonal(
                  onPressed: () => context.read<CounterNotifier>().reset(),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset',
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () => context.read<CounterNotifier>().increment(),
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
  ) {
    // Reading taskNotifier with watch to demonstrate context.watch
    final taskNotifier = context.watch<TaskNotifier>();
    final tasks = taskNotifier.tasks;

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
                    'Task List (context.watch)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('${taskNotifier.completedCount}/${tasks.length} done'),
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
                        context.read<TaskNotifier>().toggleTask(task.id);
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
                        context.read<TaskNotifier>().removeTask(task.id);
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
