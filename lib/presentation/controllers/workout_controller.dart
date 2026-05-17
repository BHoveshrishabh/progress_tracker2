import 'package:get/get.dart';
import 'package:progress_tracker/data/database/app_database.dart';
import 'package:progress_tracker/data/database/tables/workout_table.dart';
import 'package:progress_tracker/domain/entities/workout_entry.dart';

class WorkoutController extends GetxController {
  late AppDatabase db;

  final RxList<WorkoutEntry> todayWorkouts = RxList<WorkoutEntry>([]);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() async {
    super.onInit();
    db = AppDatabase();
    await loadTodayWorkouts();
  }

  Future<void> loadTodayWorkouts() async {
    isLoading.value = true;
    try {
      final today = DateTime.now();
      final entries = await db.workoutDao.getTodayWorkouts(today);
      todayWorkouts.assignAll(entries);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logWorkout({
    required String exerciseName,
    required int sets,
    required int reps,
    required double? weight,
    required int durationMinutes,
    required String muscleGroups,
    required String intensity,
  }) async {
    try {
      await db.workoutDao.insertWorkout(
        WorkoutEntriesCompanion(
          date: Value(DateTime.now()),
          exerciseName: Value(exerciseName),
          sets: Value(sets),
          reps: Value(reps),
          weight: Value(weight),
          durationMinutes: Value(durationMinutes),
          muscleGroups: Value(muscleGroups),
          intensity: Value(intensity),
        ),
      );
      await loadTodayWorkouts();
      Get.snackbar('Success', '$exerciseName logged!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to log workout: $e');
    }
  }

  Future<void> deleteWorkout(int id) async {
    try {
      await db.workoutDao.deleteWorkout(id);
      await loadTodayWorkouts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete entry: $e');
    }
  }
}
