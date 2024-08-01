import '../constants/app_assets.dart';

class TaskPreset {
  const TaskPreset({required this.name, required this.iconName});
  final String name;
  final String iconName;

  @override
  String toString() => 'TaskPreset($name, $iconName)';

  static const List<TaskPreset> allPresets = [
    TaskPreset(name: 'Eat a Healthy Meal', iconName: AppAssets.carrot),
    TaskPreset(name: 'Do Some Coding', iconName: AppAssets.html),
    TaskPreset(name: 'Meditate', iconName: AppAssets.meditation),
    TaskPreset(name: 'Sleep 8 Hours', iconName: AppAssets.rest),
    TaskPreset(name: 'Take Vitamins', iconName: AppAssets.vitamins),
    TaskPreset(name: 'Wash Your Hands', iconName: AppAssets.washHands),
    TaskPreset(name: 'Drink Water', iconName: AppAssets.water),
    TaskPreset(name: 'Practice Instrument', iconName: AppAssets.guitar),
    TaskPreset(name: 'Read for 10 Minutes', iconName: AppAssets.book),
    TaskPreset(name: 'Decrease Screen Time', iconName: AppAssets.phone),
    TaskPreset(name: 'Do a Workout', iconName: AppAssets.dumbell),
    TaskPreset(name: 'Go Running', iconName: AppAssets.run),
    TaskPreset(name: 'Go Swimming', iconName: AppAssets.swimmer),
    TaskPreset(name: 'Do Some Stretches', iconName: AppAssets.stretching),
    TaskPreset(name: 'Play Sports', iconName: AppAssets.basketball),
  ];
}
