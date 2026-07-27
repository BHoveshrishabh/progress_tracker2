import 'package:drift/drift.dart';
import 'package:progress_tracker/data/database/app_database.dart';
import 'package:progress_tracker/data/database/tables/diet_table.dart';

part 'diet_dao.g.dart';

@DriftAccessor(tables: [DietEntries])
class DietDao extends DatabaseAccessor<AppDatabase> with _$DietDaoMixin {
  DietDao(AppDatabase db) : super(db);

  Future<int> insertFood(DietEntriesCompanion entry) {
    return into(dietEntries).insert(entry);
  }

  Future<List<DietEntry>> getTodayDiet(DateTime today) {
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return (select(dietEntries)
          ..where((tbl) => tbl.date.isBetween(Variable<DateTime>(todayStart), Variable<DateTime>(todayEnd))))
        .get();
  }

  Future<List<DietEntry>> getWeekDiet(DateTime startDate, DateTime endDate) {
    return (select(dietEntries)
          ..where((tbl) => tbl.date.isBetween(Variable<DateTime>(startDate), Variable<DateTime>(endDate))))
        .get();
  }

  Future<int> deleteFood(int id) {
    return (delete(dietEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Map<String, double>> getDayMacros(DateTime date) async {
    final entries = await getTodayDiet(date);
    double totalProtein = 0, totalCarbs = 0, totalFat = 0, totalCalories = 0;
    
    for (var entry in entries) {
      totalProtein += entry.protein;
      totalCarbs += entry.carbs;
      totalFat += entry.fat;
      totalCalories += entry.calories;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
    };
  }
}
