import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/app_theme_settings.dart';
import '../models/front_or_back_side.dart';
import '../models/task.dart';
import '../models/task_state.dart';

class HiveDataStore {
  static const tasksBoxName = 'Tasks';

  static const tasksStateBoxName = 'tasksState';
  static const flagsBoxName = 'flags';
  static String taskStateKey(String key) => 'tasksState/$key';
  static const appThemeBoxName = 'aAppTheme';

  static const alwaysShowAddTaskKey = 'alwaysShowAddTask';
  static const didAddFirstTaskKey = 'didAddFirstTask';

  Future<void> init() async {
    await Hive.initFlutter();
    // register adapters
    Hive.registerAdapter<Task>(TaskAdapter());
    Hive.registerAdapter<TaskState>(TaskStateAdapter());
    Hive.registerAdapter<AppThemeSettings>(AppThemeSettingsAdapter());
    // open boxes
    // task lists
    await Hive.openBox<Task>(tasksBoxName);

    // task states
    await Hive.openBox<TaskState>(tasksStateBoxName);
    // theming

    await Hive.openBox<AppThemeSettings>(appThemeBoxName);
    // flags
    await Hive.openBox<bool>(flagsBoxName);
  }

  Future<void> createDemoTasks({
    required List<Task> frontTasks,
    required List<Task> backTasks,
    bool force = false,
  }) async {
    final frontBox = Hive.box<Task>(tasksBoxName);
    if (frontBox.isEmpty || force == true) {
      await frontBox.clear();
      await frontBox.addAll(frontTasks);
    } else {
      debugPrint('Box already has ${frontBox.length} items');
    }
  }

  ValueListenable<Box<Task>> tasksListenable() {
    return Hive.box<Task>(tasksBoxName).listenable();
  }

  // TaskState methods
  Future<void> setTaskState(
      {required Task task,
      required bool completed,
      required DateTime updatedDate}) async {
    final box = Hive.box<TaskState>(tasksStateBoxName);
    final taskState =
        TaskState(taskId: task.id, completed: completed, dateTime: updatedDate);
    await box.put(taskStateKey(task.id), taskState);
  }

  ValueListenable<Box<TaskState>> taskStateListenable({required Task task}) {
    final box = Hive.box<TaskState>(tasksStateBoxName);
    final key = taskStateKey(task.id);
    return box.listenable(keys: <String>[key]);
  }

  TaskState taskState(Box<TaskState> box, {required Task task}) {
    final key = taskStateKey(task.id);
    return box.get(key) ??
        TaskState(taskId: task.id, completed: false, dateTime: DateTime.now());
  }

  // App Theme Settings
  Future<void> setAppThemeSettings(
      {required AppThemeSettings settings,
      required FrontOrBackSide side}) async {
    const themeKey = appThemeBoxName;
    final box = Hive.box<AppThemeSettings>(themeKey);
    await box.put(themeKey, settings);
  }

  Future<AppThemeSettings> appThemeSettings() async {
    const themeKey = appThemeBoxName;
    final box = Hive.box<AppThemeSettings>(themeKey);
    final settings = box.get(themeKey);
    return settings ?? AppThemeSettings.defaults();
  }

  // Save and delete tasks
  Future<void> saveTask(Task task) async {
    final box = Hive.box<Task>(tasksBoxName);
    if (box.values.isEmpty) {
      await box.add(task);
    } else {
      final index = box.values
          .toList()
          .indexWhere((taskAtIndex) => taskAtIndex.id == task.id);
      if (index >= 0) {
        await box.putAt(index, task);
      } else {
        await box.add(task);
      }
    }
  }

  Future<void> deleteTask(Task task) async {
    final box = Hive.box<Task>(tasksBoxName);
    if (box.isNotEmpty) {
      final index = box.values
          .toList()
          .indexWhere((taskAtIndex) => taskAtIndex.id == task.id);
      if (index >= 0) {
        await box.deleteAt(index);
      }
    }
  }

  // Did Add First Task
  Future<void> setDidAddFirstTask(bool value) async {
    final box = Hive.box<bool>(flagsBoxName);
    await box.put(didAddFirstTaskKey, value);
  }

  ValueListenable<Box<bool>> didAddFirstTaskListenable() {
    return Hive.box<bool>(flagsBoxName)
        .listenable(keys: <String>[didAddFirstTaskKey]);
  }

  bool didAddFirstTask(Box<bool> box) {
    final value = box.get(didAddFirstTaskKey);
    return value ?? false;
  }

  // Always Show Add Task
  Future<void> setAlwaysShowAddTask(bool value) async {
    final box = Hive.box<bool>(flagsBoxName);
    await box.put(alwaysShowAddTaskKey, value);
  }

  ValueListenable<Box<bool>> alwaysShowAddTaskListenable() {
    return Hive.box<bool>(flagsBoxName)
        .listenable(keys: <String>[alwaysShowAddTaskKey]);
  }

  bool alwaysShowAddTask(Box<bool> box) {
    final value = box.get(alwaysShowAddTaskKey);
    return value ?? true;
  }
}

final dataStoreProvider = Provider<HiveDataStore>((ref) {
  throw UnimplementedError(); // override in main.dart ProviderScope
});
