import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_tracker/config/theme.dart';
import 'package:progress_tracker/presentation/controllers/home_controller.dart';
import 'package:progress_tracker/presentation/controllers/diet_controller.dart';
import 'package:progress_tracker/presentation/controllers/workout_controller.dart';
import 'package:progress_tracker/presentation/controllers/task_controller.dart';
import 'package:progress_tracker/presentation/pages/home_page.dart';
import 'package:progress_tracker/presentation/pages/diet_page.dart';
import 'package:progress_tracker/presentation/pages/workout_page.dart';
import 'package:progress_tracker/presentation/pages/task_page.dart';
import 'package:progress_tracker/domain/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  NotificationService();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Progress Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/diet': (context) => const DietPage(),
        '/workout': (context) => const WorkoutPage(),
        '/task': (context) => const TaskPage(),
      },

      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => DietController());
        Get.lazyPut(() => WorkoutController());
        Get.lazyPut(() => TaskController());
      }),

      home: const HomePage(),
    );
  }
}
