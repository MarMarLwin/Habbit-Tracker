// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_theme_settings.dart';
import 'package:habit_tracker/ui/animations/staggered_scale_transition.dart';
import 'package:habit_tracker/ui/common_widgets/edit_task_button.dart';
import 'package:habit_tracker/ui/theming/animated_app_theme.dart';

import '../../models/task.dart';
import '../task/task_with_name_loader.dart';

class TaskGrid extends StatefulWidget {
  const TaskGrid({
    super.key,
    required this.tasks,
    required this.appSetting,
    this.onEditTask,
  });

  final List<Task> tasks;
  final AppThemeSettings appSetting;
  final VoidCallback? onEditTask;

  @override
  State<TaskGrid> createState() => TaskGridState();
}

class TaskGridState extends State<TaskGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 170));
  }

  void enterAnimated() {
    _animationController.forward();
  }

  void exitAnimated() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAppTheme(
      data: widget.appSetting.themeData,
      duration: const Duration(milliseconds: 150),
      child: GridView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: widget.tasks.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.8),
        itemBuilder: (context, index) {
          return TaskWithNameLoader(
            task: widget.tasks[index],
            editTaskBuilder: (context) => StaggeredScaleTransition(
                animation: _animationController,
                index: index,
                child: EditTaskButton(
                  onPressed: widget.onEditTask,
                )),
          );
        },
      ),
    );
  }
}
