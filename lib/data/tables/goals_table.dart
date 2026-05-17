import 'package:drift/drift.dart';

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get calorieTarget => integer().withDefault(Constant(2500))();
  RealColumn get proteinTarget => real().withDefault(Constant(150.0))();
  IntColumn get workoutDaysPerWeek => integer().withDefault(Constant(5))();
  IntColumn get productiveHoursPerWeek => integer().withDefault(Constant(40))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
