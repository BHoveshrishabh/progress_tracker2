import 'package:get/get.dart';
import 'package:progress_tracker/data/database/app_database.dart';
import 'package:progress_tracker/domain/entities/progress_summary.dart';
import 'package:progress_tracker/domain/services/ai_engine.dart';

class HomeController extends GetxController {
  late AppDatabase db;

  final Rx<DietStats?> todayDietStats = Rx<DietStats?>(null);
  final Rx<WorkoutStats?> todayWorkoutStats = Rx<WorkoutStats?>(null);
  final Rx<TaskStats?> todayTaskStats = Rx<TaskStats?>(null);
  final Rx<String> weeklyAISummary = Rx<String>('');
  final RxDouble overallConsistency = RxDouble(0.0);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() async {
    super.onInit();
    db = AppDatabase();
    await refreshDashboard();
  }

  Future<void> refreshDashboard() async {
    isLoading.value = true;
    try {
      final today = DateTime.now();
      
      // Calculate today's stats
      final macros = await db.dietDao.getDayMacros(today);
      todayDietStats.value = DietStats(
        totalCalories: macros['calories']?.toInt() ?? 0,
        totalProtein: macros['protein'] ?? 0,
        totalCarbs: macros['carbs'] ?? 0,
        totalFat: macros['fat'] ?? 0,
        calorieTarget: 2500,
        proteinTarget: 150,
        daysLogged: 1,
        consistencyScore: 80,
      );

      final workouts = await db.workoutDao.getTodayWorkouts(today);
      double volume = 0;
      for (var w in workouts) {
        volume += w.getVolume();
      }
      todayWorkoutStats.value = WorkoutStats(
        totalVolume: volume.toInt(),
        totalDuration: workouts.fold(0, (sum, w) => sum + w.durationMinutes),
        workoutsLogged: workouts.length,
        targetWorkoutsPerWeek: 5,
        muscleGroupDistribution: {},
        progressivOverloadPercent: 0,
        consistencyScore: 75,
      );

      final tasks = await db.taskDao.getTodayTasks(today);
      int totalMinutes = tasks.fold(0, (sum, t) => sum + t.durationMinutes);
      todayTaskStats.value = TaskStats(
        totalHours: totalMinutes ~/ 60,
        completedTasks: tasks.where((t) => t.completed).length,
        totalTasks: tasks.length,
        targetHoursPerWeek: 40,
        productivityByCategory: {},
        averageFocusScore: tasks.isNotEmpty
            ? tasks.fold(0, (sum, t) => sum + t.focusScore) / tasks.length
            : 0,
        consistencyScore: 70,
      );

      // Generate AI summary
      weeklyAISummary.value = AIEngine.generateWeeklySummary(
        currentWeek: todayDietStats.value ?? _emptyDietStats(),
        lastWeek: _emptyDietStats(),
        workoutCurrent: todayWorkoutStats.value ?? _emptyWorkoutStats(),
        workoutLast: _emptyWorkoutStats(),
        taskCurrent: todayTaskStats.value ?? _emptyTaskStats(),
        taskLast: _emptyTaskStats(),
      );

      _updateOverallConsistency();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateOverallConsistency() {
    double avg = (
        (todayDietStats.value?.consistencyScore ?? 0) +
        (todayWorkoutStats.value?.consistencyScore ?? 0) +
        (todayTaskStats.value?.consistencyScore ?? 0)
    ) / 3;
    overallConsistency.value = avg;
  }

  DietStats _emptyDietStats() {
    return DietStats(
      totalCalories: 0,
      totalProtein: 0,
      totalCarbs: 0,
      totalFat: 0,
      calorieTarget: 2500,
      proteinTarget: 150,
      daysLogged: 0,
      consistencyScore: 0,
    );
  }

  WorkoutStats _emptyWorkoutStats() {
    return WorkoutStats(
      totalVolume: 0,
      totalDuration: 0,
      workoutsLogged: 0,
      targetWorkoutsPerWeek: 5,
      muscleGroupDistribution: {},
      progressivOverloadPercent: 0,
      consistencyScore: 0,
    );
  }

  TaskStats _emptyTaskStats() {
    return TaskStats(
      totalHours: 0,
      completedTasks: 0,
      totalTasks: 0,
      targetHoursPerWeek: 40,
      productivityByCategory: {},
      averageFocusScore: 0,
      consistencyScore: 0,
    );
  }
}
