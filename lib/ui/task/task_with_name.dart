// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:habbit_tracker/ui/task/animated_task.dart';

import '../../models/task.dart';

//Non Reactive
class TaskWithName extends StatelessWidget {
  const TaskWithName({
    super.key,
    required this.task,
    this.completed = false,
    this.onCompleted,
  });
  final Task task;
  final bool completed;
  final ValueChanged<bool>? onCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TaskAnimated(
            iconName: task.iconName,
            completed: completed,
            onCompleted: onCompleted,
          ),
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
