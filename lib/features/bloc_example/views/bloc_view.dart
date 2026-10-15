import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/models/task_item.dart';
import '../../../shared/widgets/concept_card.dart';
import '../counter_bloc/counter_bloc.dart';
import '../counter_bloc/counter_event.dart';
import '../counter_bloc/counter_state.dart';
import '../task_cubit/task_cubit.dart';

/// [BlocView] demonstrates BLoC and Cubit state management.
///
/// It uses [MultiBlocProvider] to provide both the event-driven [CounterBloc]
/// and the function-driven [TaskCubit] to the subtree.
class BlocView extends StatelessWidget {
  const BlocView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => TaskCubit()),
      ],
      child: const _BlocContent(),
    );
  }
}

class _BlocContent extends StatefulWidget {
  const _BlocContent();

  @override
  State<_BlocContent> createState() => _BlocContentState();
}

class _BlocContentState extends State<_BlocContent> {
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
        title: const Text('Add BLoC/Cubit Task'),
        content: TextField(
          controller: _taskController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Test BlocListener snackbar',
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
      // NOTE: For Cubit, we call the method directly on the Cubit instance
      context.read<TaskCubit>().addTask(_taskController.text.trim());
      _taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.purple.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC & Cubit Pattern'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ConceptExplanationCard(
            title: 'BLoC (Business Logic Component)',
            description:
                'BLoC separates presentation from business logic using unidirectional data flow. '
                'State changes are strictly predictable and event-driven.',
            accentColor: primaryColor,
            icon: Icons.alt_route_outlined,
            bulletPoints: const [
              'Bloc (Events -> States): Counter example uses Events (CounterIncrementPressed) handled by on<Event>.',
              'Cubit (Functions -> States): Task example uses Cubit where methods directly call emit().',
              'BlocBuilder: Rebuilds UI widgets in response to new states.',
              'BlocListener: Used for one-time side effects (snackbars, navigation) without rebuilding UI.',
              'BlocProvider: Dependency injection widget that scopes the Bloc/Cubit to the widget tree.',
            ],
          ),
          const SizedBox(height: 20),

          // --- Section 1: Counter Demo (Full BLoC with Events) ---
          _buildCounterSection(context, primaryColor, theme),
          const SizedBox(height: 20),

          // --- Section 2: Task List Demo (Cubit) ---
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
                    'Counter (BlocBuilder + Events)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // BlocBuilder rebuilds ONLY when CounterBloc emits a new CounterState
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text(
                  '${state.count}',
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
                  onPressed: () {
                    // Dispatching Event via context.read<Bloc>().add(Event)
                    context.read<CounterBloc>().add(const CounterDecrementPressed());
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                ),
                IconButton.filledTonal(
                  onPressed: () {
                    context.read<CounterBloc>().add(const CounterResetPressed());
                  },
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset',
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    context.read<CounterBloc>().add(const CounterIncrementPressed());
                  },
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BlocBuilder listens to TaskCubit state transitions
            BlocBuilder<TaskCubit, List<TaskItem>>(
              builder: (context, tasks) {
                final completedCount =
                    context.read<TaskCubit>().completedCount;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.checklist, color: primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Task List (TaskCubit)',
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
                                context.read<TaskCubit>().toggleTask(task.id);
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
                                context.read<TaskCubit>().removeTask(task.id);
                              },
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
