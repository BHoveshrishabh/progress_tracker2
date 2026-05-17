import 'package:drift/drift.dart';

class DietEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get foodName => text()();
  IntColumn get calories => integer()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  RealColumn get fiber => real()();
  TextColumn get mealType => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}
