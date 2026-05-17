import 'package:drift/drift.dart';

class TaskEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get taskName => text()();
  IntColumn get durationMinutes => integer()();
  TextColumn get category => text()();
  BoolColumn get completed => boolean().withDefault(Constant(true))();
  IntColumn get focusScore => integer()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}
