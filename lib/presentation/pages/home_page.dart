import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_tracker/config/theme.dart';
import 'package:progress_tracker/presentation/controllers/home_controller.dart';
import 'package:progress_tracker/presentation/widgets/common/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracker'),
        elevation: 1,
        shadowColor: AppTheme.border.withOpacity(0.3),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Calories',
                      value: '${controller.todayDietStats.value?.totalCalories ?? 0}',
                      unit: 'kcal',
                      target: '2500',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Protein',
                      value: '${(controller.todayDietStats.value?.totalProtein ?? 0).toStringAsFixed(0)}',
                      unit: 'g',
                      target: '150g',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Workouts',
                      value: '${controller.todayWorkoutStats.value?.workoutsLogged ?? 0}',
                      unit: 'done',
                      target: '5/week',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Productive',
                      value: '${controller.todayTaskStats.value?.totalHours ?? 0}',
                      unit: 'hours',
                      target: '40/week',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Weekly Summary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    controller.weeklyAISummary.value.isEmpty
                        ? 'Start logging to see insights'
                        : controller.weeklyAISummary.value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
          _navigateToPage(index);
        },
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Get.toNamed('/diet');
        break;
      case 2:
        Get.toNamed('/workout');
        break;
      case 3:
        Get.toNamed('/task');
        break;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String target;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            Text(
              '$value $unit',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Target: $target',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
