import 'package:get/get.dart';
import 'package:progress_tracker/data/database/app_database.dart';
import 'package:progress_tracker/data/database/tables/task_table.dart';
import 'package:progress_tracker/domain/entities/task_entry.dart';

class TaskController extends GetxController {
  late AppDatabase db;

  final RxList<TaskEntry> todayTasks = RxList<TaskEntry>([]);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() async {
    super.onInit();
    db = AppDatabase();
    await loadTodayTasks();
  }

  Future<void> loadTodayTasks() async {
    isLoading.value = true;
    try {
      final today = DateTime.now();
      final entries = await db.taskDao.getTodayTasks(today);
      todayTasks.assignAll(entries);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logTask({
    required String taskName,
    required int durationMinutes,
    required String category,
    required int focusScore,
  }) async {
    try {
      await db.taskDao.insertTask(
        TaskEntriesCompanion(
          date: Value(DateTime.now()),
          taskName: Value(taskName),
          durationMinutes: Value(durationMinutes),
          category: Value(category),
          focusScore: Value(focusScore),
        ),
      );
      await loadTodayTasks();
      Get.snackbar('Success', '$taskName logged!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to log task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await db.taskDao.deleteTask(id);
      await loadTodayTasks();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete entry: $e');
    }
  }
}
