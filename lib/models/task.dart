import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  Task(
      {required this.id,
      required this.name,
      required this.iconName,
      required this.createDate});

  factory Task.create(
      {required String name,
      required String iconName,
      required DateTime createDate}) {
    final id = const Uuid().v1();
    return Task(id: id, name: name, iconName: iconName, createDate: createDate);
  }

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String iconName;

  @HiveField(3)
  final DateTime createDate;
}
