import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_tracker/presentation/controllers/diet_controller.dart';
import 'package:progress_tracker/presentation/widgets/common/bottom_nav.dart';

class DietPage extends StatefulWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  late DietController controller;
  int _selectedIndex = 1;

  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  String _selectedMealType = 'breakfast';

  @override
  void initState() {
    super.initState();
    controller = Get.find<DietController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diet Tracker')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Food', style: Theme.of(context).textTheme.titleLarge),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Food name'),
              ),
              TextField(
                controller: _caloriesController,
                decoration: const InputDecoration(hintText: 'Calories'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _proteinController,
                decoration: const InputDecoration(hintText: 'Protein (g)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _carbsController,
                decoration: const InputDecoration(hintText: 'Carbs (g)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _fatController,
                decoration: const InputDecoration(hintText: 'Fat (g)'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _selectedMealType,
                items: ['breakfast', 'lunch', 'dinner', 'snacks']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedMealType = v!),
              ),
              ElevatedButton(
                onPressed: _logFood,
                child: const Text('Log Food'),
              ),
              const Divider(),
              Text('Today\'s Meals', style: Theme.of(context).textTheme.titleLarge),
              if (controller.todayDiet.isEmpty)
                Text('No meals logged', style: Theme.of(context).textTheme.bodyMedium)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.todayDiet.length,
                  itemBuilder: (context, index) {
                    final entry = controller.todayDiet[index];
                    return Card(
                      child: ListTile(
                        title: Text(entry.foodName),
                        subtitle: Text('${entry.calories} kcal | Protein: ${entry.protein}g'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.deleteFood(entry.id),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
          _navigate(index);
        },
      ),
    );
  }

  void _logFood() {
    if (_nameController.text.isEmpty ||
        _caloriesController.text.isEmpty ||
        _proteinController.text.isEmpty ||
        _carbsController.text.isEmpty ||
        _fatController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    controller.logFood(
      foodName: _nameController.text,
      calories: int.parse(_caloriesController.text),
      protein: double.parse(_proteinController.text),
      carbs: double.parse(_carbsController.text),
      fat: double.parse(_fatController.text),
      fiber: 0,
      mealType: _selectedMealType,
    );

    _nameController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _carbsController.clear();
    _fatController.clear();
  }

  void _navigate(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/home');
        break;
      case 1:
        break;
      case 2:
        Get.toNamed('/workout');
        break;
      case 3:
        Get.toNamed('/task');
        break;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }
}
