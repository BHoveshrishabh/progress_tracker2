import 'package:drift/drift.dart';
import 'package:progress_tracker/data/database/app_database.dart';
import 'package:progress_tracker/data/database/tables/task_table.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [TaskEntries])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(AppDatabase db) : super(db);

  Future<int> insertTask(TaskEntriesCompanion entry) {
    return into(taskEntries).insert(entry);
  }

  Future<List<TaskEntry>> getTodayTasks(DateTime today) {
    return (select(taskEntries)
          ..where((tbl) => tbl.date.equals(today)))
        .get();
  }

  Future<List<TaskEntry>> getWeekTasks(DateTime startDate, DateTime endDate) {
    return (select(taskEntries)
          ..where((tbl) => tbl.date.isBetween(startDate, endDate)))
        .get();
  }

  Future<int> getCompletedCount(DateTime startDate, DateTime endDate) {
    return (select(taskEntries)
          ..where((tbl) =>
              tbl.date.isBetween(startDate, endDate) & tbl.completed.equals(true)))
        .get()
        .then((list) => list.length);
  }

  Future<int> getTotalHours(DateTime startDate, DateTime endDate) async {
    final entries = await getWeekTasks(startDate, endDate);
    int totalMinutes = entries.fold(0, (sum, entry) => sum + (entry.durationMinutes as int));
    return totalMinutes ~/ 60;
  }

  Future<Map<String, int>> getProductivityByCategory(DateTime startDate, DateTime endDate) async {
    final entries = await getWeekTasks(startDate, endDate);
    Map<String, int> stats = {
      'coding': 0,
      'study': 0,
      'creative': 0,
      'admin': 0,
      'other': 0,
    };

    for (var entry in entries) {
      stats[entry.category] = (stats[entry.category] ?? 0) + (entry.durationMinutes as int);
    }

    return stats;
  }

  Future<double> getAverageFocusScore(DateTime startDate, DateTime endDate) async {
    final entries = await getWeekTasks(startDate, endDate);
    if (entries.isEmpty) return 0;
    
    int totalScore = entries.fold(0, (sum, entry) => sum + (entry.focusScore as int));
    return totalScore / entries.length;
  }

  Future<int> deleteTask(int id) {
    return (delete(taskEntries)..where((tbl) => tbl.id.equals(id))).go();
  }
}
