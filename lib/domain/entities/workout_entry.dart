class WorkoutEntry {
  final int id;
  final DateTime date;
  final String exerciseName;
  final int sets;
  final int reps;
  final double? weight;
  final int durationMinutes;
  final String muscleGroups;
  final String intensity;
  final DateTime timestamp;

  WorkoutEntry({
    required this.id,
    required this.date,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    this.weight,
    required this.durationMinutes,
    required this.muscleGroups,
    required this.intensity,
    required this.timestamp,
  });

  List<String> getMuscleGroupsList() {
    return muscleGroups.split(',').map((g) => g.trim()).toList();
  }

  double getVolume() {
    return sets * reps * (weight ?? 1.0);
  }
}
