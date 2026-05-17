class DietEntry {
  final int id;
  final DateTime date;
  final String foodName;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final String mealType;
  final DateTime timestamp;

  DietEntry({
    required this.id,
    required this.date,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.mealType,
    required this.timestamp,
  });
}
