import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/ui/add_task/task_detail_page.dart';

import '../../models/task.dart';
import '../../models/task_preset.dart';
import 'add_task_page.dart';

class AddTaskRoutes {
  static const root = '/';
  static const confirmTask = '/confirmTask';
}

class AddTaskNavigator extends ConsumerStatefulWidget {
  const AddTaskNavigator({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEditTaskState();
}

class _AddEditTaskState extends ConsumerState<AddTaskNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
        initialRoute: AddTaskRoutes.root,
        onGenerateRoute: (routeSettings) => MaterialPageRoute(
              builder: (context) {
                switch (routeSettings.name) {
                  case AddTaskRoutes.root:
                    return const AddTaskPage();

                  case AddTaskRoutes.confirmTask:
                    final taskPreset = routeSettings.arguments as TaskPreset;
                    final task = Task.create(
                      name: taskPreset.name,
                      iconName: taskPreset.iconName,
                    );
                    return TaskDetailsPage(
                      task: task,
                      isNewTask: true,
                    );

                  default:
                    throw UnimplementedError();
                }
              },
            ));
  }
}
