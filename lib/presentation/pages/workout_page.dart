import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_tracker/presentation/controllers/workout_controller.dart';
import 'package:progress_tracker/presentation/widgets/common/bottom_nav.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late WorkoutController controller;
  int _selectedIndex = 2;

  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedIntensity = 'moderate';

  @override
  void initState() {
    super.initState();
    controller = Get.find<WorkoutController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Tracker')),
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
              Text('Log Workout', style: Theme.of(context).textTheme.titleLarge),
              TextField(
                controller: _exerciseController,
                decoration: const InputDecoration(hintText: 'Exercise name'),
              ),
              TextField(
                controller: _setsController,
                decoration: const InputDecoration(hintText: 'Sets'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _repsController,
                decoration: const InputDecoration(hintText: 'Reps'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(hintText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _durationController,
                decoration: const InputDecoration(hintText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _selectedIntensity,
                items: ['light', 'moderate', 'heavy']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedIntensity = v!),
              ),
              ElevatedButton(
                onPressed: _logWorkout,
                child: const Text('Log Workout'),
              ),
              const Divider(),
              Text('Today\'s Workouts', style: Theme.of(context).textTheme.titleLarge),
              if (controller.todayWorkouts.isEmpty)
                Text('No workouts logged', style: Theme.of(context).textTheme.bodyMedium)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.todayWorkouts.length,
                  itemBuilder: (context, index) {
                    final entry = controller.todayWorkouts[index];
                    return Card(
                      child: ListTile(
                        title: Text(entry.exerciseName),
                        subtitle: Text('${entry.sets}x${entry.reps} | ${entry.durationMinutes}m'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.deleteWorkout(entry.id),
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

  void _logWorkout() {
    if (_exerciseController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _repsController.text.isEmpty ||
        _durationController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill required fields');
      return;
    }

    controller.logWorkout(
      exerciseName: _exerciseController.text,
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
      weight: _weightController.text.isNotEmpty ? double.parse(_weightController.text) : null,
      durationMinutes: int.parse(_durationController.text),
      muscleGroups: 'chest,back',
      intensity: _selectedIntensity,
    );

    _exerciseController.clear();
    _setsController.clear();
    _repsController.clear();
    _weightController.clear();
    _durationController.clear();
  }

  void _navigate(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/home');
        break;
      case 1:
        Get.toNamed('/diet');
        break;
      case 2:
        break;
      case 3:
        Get.toNamed('/task');
        break;
    }
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
