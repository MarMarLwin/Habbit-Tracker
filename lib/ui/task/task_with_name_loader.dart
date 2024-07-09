// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habbit_tracker/models/task_state.dart';
import 'package:habbit_tracker/persistence/hive_data_store.dart';
import 'package:habbit_tracker/ui/task/task_with_name.dart';
import 'package:hive/hive.dart';

import '../../models/task.dart';

//Reactive
class TaskWithNameLoader extends ConsumerWidget {
  const TaskWithNameLoader({
    super.key,
    required this.task,
  });
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
        valueListenable: dataStore.taskStateListenable(task: task),
        builder: (context, Box<TaskState> box, child) {
          final taskState = dataStore.taskState(task: task, box);
          return TaskWithName(
            task: task,
            completed: taskState.completed,
            onCompleted: (completed) => dataStore.setTaskState(
              completed: completed,
              task: task,
            ),
          );
        });
  }
}
