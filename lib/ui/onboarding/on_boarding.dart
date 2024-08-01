import 'package:flutter/material.dart';
import 'package:habit_tracker/extensions/extensions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../models/task.dart';
import '../add_task/add_task_navigator.dart';
import '../task/task_with_name.dart';
import '../theming/app_theme.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    const defaultColorSwatch = AppColors.red;
    final defaultAppThemeVariants = AppThemeVariants(defaultColorSwatch);
    final appThemeData = defaultAppThemeVariants.themes[0];

    return AppTheme(
        data: appThemeData,
        child: Scaffold(
          backgroundColor: defaultColorSwatch[0],
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add a task to begin",
                    style: TextStyles.heading.copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                  30.height,
                  Padding(
                    padding: 70.allPadding,
                    child: TaskWithName(
                      task: Task(
                          id: '',
                          name: 'Tap and hold\nto add a task',
                          iconName: AppAssets.plus,
                          createDate: DateTime.now()),
                      completed: false,
                      onCompleted: (complete) =>
                          _addTask(context, appThemeData),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _addTask(BuildContext context, AppThemeData appThemeData) async {
    await showCupertinoModalBottomSheet<void>(
      context: context,
      barrierColor: AppColors.black50,
      builder: (_) => AppTheme(
        data: appThemeData,
        child: const AddTaskNavigator(),
      ),
    );
  }
}
