class DietStats {
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final int calorieTarget;
  final double proteinTarget;
  final int daysLogged;
  final double consistencyScore;

  DietStats({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.calorieTarget,
    required this.proteinTarget,
    required this.daysLogged,
    required this.consistencyScore,
  });

  Map<String, double> getMacroPercentages() {
    double totalCals = (totalProtein * 4) + (totalCarbs * 4) + (totalFat * 9);
    if (totalCals == 0) return {'protein': 0, 'carbs': 0, 'fat': 0};

    return {
      'protein': (totalProtein * 4) / totalCals * 100,
      'carbs': (totalCarbs * 4) / totalCals * 100,
      'fat': (totalFat * 9) / totalCals * 100,
    };
  }
}

class WorkoutStats {
  final int totalVolume;
  final int totalDuration;
  final int workoutsLogged;
  final int targetWorkoutsPerWeek;
  final Map<String, int> muscleGroupDistribution;
  final double progressivOverloadPercent;
  final double consistencyScore;

  WorkoutStats({
    required this.totalVolume,
    required this.totalDuration,
    required this.workoutsLogged,
    required this.targetWorkoutsPerWeek,
    required this.muscleGroupDistribution,
    required this.progressivOverloadPercent,
    required this.consistencyScore,
  });
}

class TaskStats {
  final int totalHours;
  final int completedTasks;
  final int totalTasks;
  final int targetHoursPerWeek;
  final Map<String, int> productivityByCategory;
  final double averageFocusScore;
  final double consistencyScore;

  TaskStats({
    required this.totalHours,
    required this.completedTasks,
    required this.totalTasks,
    required this.targetHoursPerWeek,
    required this.productivityByCategory,
    required this.averageFocusScore,
    required this.consistencyScore,
  });

  double getCompletionRate() {
    if (totalTasks == 0) return 0;
    return (completedTasks / totalTasks * 100).clamp(0, 100);
  }
}
