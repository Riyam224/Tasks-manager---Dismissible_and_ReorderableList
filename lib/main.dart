import 'package:flutter/material.dart';
import 'package:task_manager/home_view.dart';

void main() {
  runApp(const TasksManagerApp());
}

class TasksManagerApp extends StatelessWidget {
  const TasksManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasks Manager',
      home: HomeView(),
    );
  }
}
