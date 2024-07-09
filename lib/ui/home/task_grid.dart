import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../task/task_with_name_loader.dart';

class TaskGrid extends StatelessWidget {
  const TaskGrid({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: tasks.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.8),
      itemBuilder: (context, index) {
        return TaskWithNameLoader(
          task: tasks[index],
        );
      },
    );
  }
}
