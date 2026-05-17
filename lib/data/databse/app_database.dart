import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:progress_tracker/data/database/daos/diet_dao.dart';
import 'package:progress_tracker/data/database/daos/workout_dao.dart';
import 'package:progress_tracker/data/database/daos/task_dao.dart';
import 'package:progress_tracker/data/database/tables/diet_table.dart';
import 'package:progress_tracker/data/database/tables/workout_table.dart';
import 'package:progress_tracker/data/database/tables/task_table.dart';
import 'package:progress_tracker/data/database/tables/goals_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [DietEntries, WorkoutEntries, TaskEntries, Goals],
  daos: [DietDao, WorkoutDao, TaskDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here if schema changes
      },
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'progress_tracker_db');
}
