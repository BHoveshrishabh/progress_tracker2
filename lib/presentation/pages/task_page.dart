import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_tracker/presentation/controllers/task_controller.dart';
import 'package:progress_tracker/presentation/widgets/common/bottom_nav.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TaskController controller;
  int _selectedIndex = 3;

  final _taskController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedCategory = 'coding';
  int _focusScore = 7;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TaskController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Tracker')),
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
              Text('Log Task', style: Theme.of(context).textTheme.titleLarge),
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(hintText: 'Task name'),
              ),
              TextField(
                controller: _durationController,
                decoration: const InputDecoration(hintText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                items: ['coding', 'study', 'creative', 'admin', 'other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Focus Score: ${_focusScore.toInt()}/10'),
                  Slider(
                    value: _focusScore.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => setState(() => _focusScore = v.toInt()),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _logTask,
                child: const Text('Log Task'),
              ),
              const Divider(),
              Text('Today\'s Tasks', style: Theme.of(context).textTheme.titleLarge),
              if (controller.todayTasks.isEmpty)
                Text('No tasks logged', style: Theme.of(context).textTheme.bodyMedium)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.todayTasks.length,
                  itemBuilder: (context, index) {
                    final entry = controller.todayTasks[index];
                    return Card(
                      child: ListTile(
                        title: Text(entry.taskName),
                        subtitle: Text('${entry.durationMinutes}m | Focus: ${entry.focusScore}/10'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.deleteTask(entry.id),
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

  void _logTask() {
    if (_taskController.text.isEmpty || _durationController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    controller.logTask(
      taskName: _taskController.text,
      durationMinutes: int.parse(_durationController.text),
      category: _selectedCategory,
      focusScore: _focusScore,
    );

    _taskController.clear();
    _durationController.clear();
    _focusScore = 7;
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
        Get.toNamed('/workout');
        break;
      case 3:
        break;
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
