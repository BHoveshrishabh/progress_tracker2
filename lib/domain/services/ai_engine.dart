import 'package:progress_tracker/domain/entities/progress_summary.dart';

class AIEngine {
  static String generateWeeklySummary({
    required DietStats currentWeek,
    required DietStats lastWeek,
    required WorkoutStats workoutCurrent,
    required WorkoutStats workoutLast,
    required TaskStats taskCurrent,
    required TaskStats taskLast,
  }) {
    List<String> insights = [];

    insights.addAll(_generateDietInsights(currentWeek, lastWeek));
    insights.addAll(_generateWorkoutInsights(workoutCurrent, workoutLast));
    insights.addAll(_generateTaskInsights(taskCurrent, taskLast));

    return insights.join('\n\n');
  }

  static List<String> _generateDietInsights(DietStats current, DietStats last) {
    List<String> insights = [];

    int calorieChange = current.totalCalories - last.totalCalories;
    if (calorieChange.abs() > 200) {
      String direction = calorieChange > 0 ? "increased" : "decreased";
      insights.add(
        "Calorie intake $direction by ${calorieChange.abs()} kcal this week. "
        "Current: ${current.totalCalories} kcal",
      );
    }

    double proteinPercent = (current.totalProtein / current.proteinTarget * 100);
    if (proteinPercent < 90) {
      double shortfall = current.proteinTarget - current.totalProtein;
      insights.add(
        "Protein intake ${proteinPercent.toStringAsFixed(0)}% of target. "
        "Add ${shortfall.toStringAsFixed(0)}g more protein daily.",
      );
    } else if (proteinPercent >= 100) {
      insights.add(
        "Strong week! Protein intake at ${proteinPercent.toStringAsFixed(0)}% of target. 💪",
      );
    }

    if (current.daysLogged >= 6) {
      insights.add("Diet logging: ${current.daysLogged}/7 days ✓");
    }

    return insights;
  }

  static List<String> _generateWorkoutInsights(
      WorkoutStats current, WorkoutStats last) {
    List<String> insights = [];

    int volumeChange = current.totalVolume - last.totalVolume;
    if (volumeChange != 0) {
      double progressPercent = (volumeChange / (last.totalVolume + 1) * 100);
      String direction = volumeChange > 0 ? "increased" : "decreased";
      insights.add(
        "Total volume $direction by ${progressPercent.abs().toStringAsFixed(1)}%. "
        "Progressive overload: ${volumeChange > 0 ? '✓' : '⚠️'}",
      );
    }

    if (current.workoutsLogged < current.targetWorkoutsPerWeek) {
      int deficit = current.targetWorkoutsPerWeek - current.workoutsLogged;
      insights.add(
        "You're $deficit workouts short of your target. Schedule more sessions!",
      );
    }

    return insights;
  }

  static List<String> _generateTaskInsights(TaskStats current, TaskStats last) {
    List<String> insights = [];

    int hourChange = current.totalHours - last.totalHours;
    if (hourChange != 0) {
      String direction = hourChange > 0 ? "increased" : "decreased";
      insights.add(
        "Productive hours $direction by ${hourChange.abs()}h. "
        "Total: ${current.totalHours}h vs target ${current.targetHoursPerWeek}h.",
      );
    }

    double completionRate = current.getCompletionRate();
    if (completionRate >= 90) {
      insights.add("Task completion: ${completionRate.toStringAsFixed(0)}% 🎯");
    } else if (completionRate >= 70) {
      insights.add("Task completion: ${completionRate.toStringAsFixed(0)}%. Room to improve.");
    }

    if (current.averageFocusScore >= 8) {
      insights.add("Average focus: ${current.averageFocusScore.toStringAsFixed(1)}/10 🧠");
    }

    return insights;
  }
}
