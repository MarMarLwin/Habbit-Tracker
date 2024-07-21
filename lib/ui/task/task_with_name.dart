// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/common_widgets/edit_task_button.dart';
import 'package:habit_tracker/ui/task/animated_task.dart';

import '../../models/task.dart';
import '../theming/app_theme.dart';

//Non Reactive
class TaskWithName extends StatelessWidget {
  const TaskWithName({
    super.key,
    required this.task,
    required this.completed,
    this.onCompleted,
    this.editTaskBuilder,
  });
  final Task task;
  final bool completed;
  final ValueChanged<bool>? onCompleted;
  final WidgetBuilder? editTaskBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TaskAnimated(
                iconName: task.iconName,
                completed: completed,
                onCompleted: onCompleted,
              ),
            ),
            if (editTaskBuilder != null)
              Positioned.fill(
                  child: FractionallySizedBox(
                widthFactor: EditTaskButton.scaleFactor,
                heightFactor: EditTaskButton.scaleFactor,
                alignment: Alignment.bottomRight,
                child: editTaskBuilder!(context),
              ))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          task.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.of(context).accent, fontSize: 18),
        )
      ],
    );
  }
}
