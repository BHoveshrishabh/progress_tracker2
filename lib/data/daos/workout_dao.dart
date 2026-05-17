import 'package:drift/drift.dart';
import 'package:progress_tracker/data/database/app_database.dart';
import 'package:progress_tracker/data/database/tables/workout_table.dart';

part 'workout_dao.g.dart';

@DriftAccessor(include: {'workout_entries'})
class WorkoutDao extends DatabaseAccessor<AppDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(AppDatabase db) : super(db);

  Future<int> insertWorkout(WorkoutEntriesCompanion entry) {
    return into(workoutEntries).insert(entry);
  }

  Future<List<WorkoutEntry>> getTodayWorkouts(DateTime today) {
    return (select(workoutEntries)
          ..where((tbl) => tbl.date.equals(today)))
        .get();
  }

  Future<List<WorkoutEntry>> getWeekWorkouts(DateTime startDate, DateTime endDate) {
    return (select(workoutEntries)
          ..where((tbl) => tbl.date.isBetween(startDate, endDate)))
        .get();
  }

  Future<List<WorkoutEntry>> getExerciseHistory(String exerciseName, {int days = 30}) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    return (select(workoutEntries)
          ..where((tbl) => tbl.exerciseName.equals(exerciseName) & tbl.date.isAfter(startDate))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.date)]))
        .get();
  }

  Future<double> getTotalVolume(DateTime startDate, DateTime endDate) async {
    final entries = await getWeekWorkouts(startDate, endDate);
    double totalVolume = 0;

    for (var entry in entries) {
      double weight = entry.weight ?? 1.0;
      totalVolume += entry.sets * entry.reps * weight;
    }

    return totalVolume;
  }

  Future<Map<String, int>> getMuscleGroupStats(DateTime startDate, DateTime endDate) async {
    final entries = await getWeekWorkouts(startDate, endDate);
    Map<String, int> stats = {
      'chest': 0,
      'back': 0,
      'legs': 0,
      'arms': 0,
      'shoulders': 0,
      'core': 0,
    };

    for (var entry in entries) {
      final groups = entry.muscleGroups.split(',');
      for (var group in groups) {
        stats[group.trim()] = (stats[group.trim()] ?? 0) + 1;
      }
    }

    return stats;
  }

  Future<bool> deleteWorkout(int id) {
    return (delete(workoutEntries)..where((tbl) => tbl.id.equals(id))).go();
  }
}
