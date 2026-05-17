import 'package:get/get.dart';
import 'package:progress_tracker/data/database/app_database.dart';
import 'package:progress_tracker/data/database/tables/diet_table.dart';
import 'package:progress_tracker/domain/entities/diet_entry.dart';

class DietController extends GetxController {
  late AppDatabase db;

  final RxList<DietEntry> todayDiet = RxList<DietEntry>([]);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() async {
    super.onInit();
    db = AppDatabase();
    await loadTodayDiet();
  }

  Future<void> loadTodayDiet() async {
    isLoading.value = true;
    try {
      final today = DateTime.now();
      final entries = await db.dietDao.getTodayDiet(today);
      todayDiet.assignAll(entries);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logFood({
    required String foodName,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    required double fiber,
    required String mealType,
  }) async {
    try {
      await db.dietDao.insertFood(
        DietEntriesCompanion(
          date: Value(DateTime.now()),
          foodName: Value(foodName),
          calories: Value(calories),
          protein: Value(protein),
          carbs: Value(carbs),
          fat: Value(fat),
          fiber: Value(fiber),
          mealType: Value(mealType),
        ),
      );
      await loadTodayDiet();
      Get.snackbar('Success', '$foodName logged!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to log food: $e');
    }
  }

  Future<void> deleteFood(int id) async {
    try {
      await db.dietDao.deleteFood(id);
      await loadTodayDiet();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete entry: $e');
    }
  }
}
