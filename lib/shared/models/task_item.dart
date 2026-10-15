class TaskItem {
  final String id;
  final String title;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  /// Creates a copy of this task with modified properties.
  /// Immutable objects are recommended in reactive state management (Riverpod, Bloc, etc.).
  TaskItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
