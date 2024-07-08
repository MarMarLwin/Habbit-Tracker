// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:habbit_tracker/models/task_preset.dart';
import 'package:habbit_tracker/ui/task/animated_task.dart';

class TaskWithName extends StatelessWidget {
  const TaskWithName({
    super.key,
    required this.task,
  });
  final TaskPreset task;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TaskAnimated(iconName: task.iconName),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          task.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        )
      ],
    );
  }
}
