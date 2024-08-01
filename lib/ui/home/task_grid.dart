// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_theme_settings.dart';
import 'package:habit_tracker/ui/animations/custom_fade_transition.dart';
import 'package:habit_tracker/ui/common_widgets/edit_task_button.dart';
import 'package:habit_tracker/ui/theming/animated_app_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../constants/app_colors.dart';
import '../../models/task.dart';
import '../add_task/task_detail_page.dart';
import '../task/task_with_name_loader.dart';
import '../theming/app_theme.dart';

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

  Future<void> _editTask(Task task, AppThemeData appThemeData) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      await showCupertinoModalBottomSheet<void>(
          context: context,
          barrierColor: AppColors.black50,
          builder: (_) => AppTheme(
              data: appThemeData,
              child: TaskDetailsPage(
                task: task,
                isNewTask: false,
              )));
    }
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
        padding: const EdgeInsets.all(10),
        itemCount: widget.tasks.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.9),
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          return TaskWithNameLoader(
            task: task,
            editTaskBuilder: (context) => CustomFadeTransition(
              animation: _animationController,
              child: EditTaskButton(
                onPressed: () => _editTask(task, widget.appSetting.themeData),
              ),
            ),
          );
        },
      ),
    );
  }
}
