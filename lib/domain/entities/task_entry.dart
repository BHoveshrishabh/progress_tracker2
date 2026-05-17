class TaskEntry {
  final int id;
  final DateTime date;
  final String taskName;
  final int durationMinutes;
  final String category;
  final bool completed;
  final int focusScore;
  final DateTime timestamp;

  TaskEntry({
    required this.id,
    required this.date,
    required this.taskName,
    required this.durationMinutes,
    required this.category,
    required this.completed,
    required this.focusScore,
    required this.timestamp,
  });
}
