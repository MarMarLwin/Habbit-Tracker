// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/task_state.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/home/home_page.dart';
import 'package:habit_tracker/ui/task/task_with_name.dart';
import 'package:hive/hive.dart';

import '../../models/task.dart';

//Reactive
class TaskWithNameLoader extends ConsumerWidget {
  const TaskWithNameLoader({
    super.key,
    required this.task,
    this.editTaskBuilder,
  });
  final Task task;
  final WidgetBuilder? editTaskBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeKey = GlobalKey<HomePageState>();
    final dataStore = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
        valueListenable: dataStore.taskStateListenable(task: task),
        builder: (context, Box<TaskState> box, child) {
          final taskState = dataStore.taskState(task: task, box);
          return TaskWithName(
            key: homeKey,
            task: task,
            completed: taskState.completed,
            onCompleted: (completed) => dataStore.setTaskState(
                completed: completed,
                task: task,
                updatedDate:
                    homeKey.currentState?.selectedDate ?? DateTime.now()),
            editTaskBuilder: editTaskBuilder,
          );
        });
  }
}
