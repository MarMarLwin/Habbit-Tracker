import 'package:hive/hive.dart';

part 'task_state.g.dart';

@HiveType(typeId: 1)
class TaskState {
  TaskState({
    required this.taskId,
    required this.completed,
    required this.dateTime,
  });

  @HiveField(0)
  final String taskId;

  @HiveField(1)
  final bool completed;

  @HiveField(2)
  final DateTime dateTime;
}
