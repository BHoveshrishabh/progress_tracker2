import 'package:drift/drift.dart';

class WorkoutEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get exerciseName => text()();
  IntColumn get sets => integer()();
  IntColumn get reps => integer()();
  RealColumn get weight => real().nullable()();
  IntColumn get durationMinutes => integer()();
  TextColumn get muscleGroups => text()();
  TextColumn get intensity => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}
