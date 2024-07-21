// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habit_tracker/extensions/extensions.dart';
import 'package:habit_tracker/models/task_preset.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/add_task/custom_text_field.dart';
import 'package:habit_tracker/ui/add_task/select_icon_page.dart';
import 'package:habit_tracker/ui/add_task/task_preset_list_tile.dart';
import 'package:habit_tracker/ui/add_task/task_ring_with_image.dart';
import 'package:habit_tracker/ui/add_task/text_field_header.dart';
import 'package:habit_tracker/ui/common_widgets/app_bar_icon_button.dart';
import 'package:habit_tracker/ui/common_widgets/edit_task_button.dart';
import 'package:habit_tracker/ui/common_widgets/primary_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../models/task.dart';
import '../theming/app_theme.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({
    super.key,
    required this.task,
    required this.isNewTask,
  });

  final Task task;
  final bool isNewTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).secondary,
        title: Text(
          isNewTask ? 'Create Task' : 'Edit Task',
          style: TextStyles.heading
              .copyWith(color: AppTheme.of(context).settingsText),
        ),
        leading: AppBarIconButton(
            iconName: isNewTask
                ? AppAssets.navigationBack
                : AppAssets.navigationClose,
            onPressed: () => Navigator.of(context).pop()),
        elevation: 0,
      ),
      backgroundColor: AppTheme.of(context).primary,
      body: ConfirmTaskContent(
        task: task,
        isNewTask: isNewTask,
      ),
    );
  }
}

class ConfirmTaskContent extends ConsumerStatefulWidget {
  const ConfirmTaskContent({
    super.key,
    required this.task,
    required this.isNewTask,
  });
  final Task task;
  final bool isNewTask;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmTaskContentState();
}

class _ConfirmTaskContentState extends ConsumerState<ConfirmTaskContent> {
  final _textFieldKey = GlobalKey<CustomTextFieldState>();

  late String _iconName = widget.task.iconName;

  Future<void> _saveTask() async {
    final textFieldState = _textFieldKey.currentState;
    if (textFieldState != null) {
      final task = Task(
        iconName: _iconName,
        id: widget.task.id,
        name: textFieldState.text,
      );

      try {
        final navigator = Navigator.of(context, rootNavigator: true);
        final dataStore = ref.read<HiveDataStore>(dataStoreProvider);
        await dataStore.setDidAddFirstTask(true);
        await dataStore.saveTask(task);
        navigator.pop();
      } catch (e) {
        debugPrint('Save Exception $e');
      }
    }
  }

  Future<void> _deleteTask() async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final didConfirm = await showAdaptiveActionSheet<bool?>(
      context: context,
      title: const Text('Are you sure?'),
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: const Text('Delete'),
            onPressed: (context) => Navigator.of(context).pop(true)),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ),
    );

    if (didConfirm == true) {
      try {
        final dataStore = ref.read<HiveDataStore>(dataStoreProvider);
        await dataStore.setAlwaysShowAddTask(false);
        await dataStore.deleteTask(widget.task);
        navigator.pop();
      } catch (e) {
        debugPrint('Delete Exception $e');
      }
    }
  }

  Future<void> _changeIcon() async {
    final appThemeData = AppTheme.of(context);
    final iconName = await showCupertinoModalBottomSheet<String>(
      context: context,
      barrierColor: AppColors.black50,
      builder: (_) => AppTheme(
        data: appThemeData,
        child: SelectIconPage(selectedIconName: _iconName),
      ),
    );
    if (iconName != null) {
      setState(() {
        _iconName = iconName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              ConfirmTaskHeader(
                iconName: _iconName,
                onChangeIcon: _changeIcon,
              ),
              48.height,
              const TextFieldHeader('TITLE:'),
              CustomTextField(
                initialValue: widget.task.name,
                key: _textFieldKey,
                hintText: 'Enter task title...',
              ),
              if (!widget.isNewTask) ...[
                48.height,
                TaskPresetListTile(
                  taskPreset: const TaskPreset(
                      iconName: AppAssets.delete, name: 'Delete Task'),
                  onPressed: (_) => _deleteTask(),
                )
              ]
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PrimaryButton(
            title: 'Save Task',
            onPressed: () => _saveTask(),
          ),
        ),
        25.height
      ],
    );
  }
}

class ConfirmTaskHeader extends StatelessWidget {
  final String iconName;
  final VoidCallback? onChangeIcon;
  const ConfirmTaskHeader({
    super.key,
    required this.iconName,
    this.onChangeIcon,
  });

  @override
  Widget build(BuildContext context) {
    const size = 150.0;
    final padding = (MediaQuery.sizeOf(context).width - size) / 2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Stack(children: [
        TaskRingWithImage(iconName: iconName),
        Positioned.fill(
            child: FractionallySizedBox(
          alignment: Alignment.bottomRight,
          heightFactor: EditTaskButton.scaleFactor,
          widthFactor: EditTaskButton.scaleFactor,
          child: EditTaskButton(onPressed: onChangeIcon),
        ))
      ]),
    );
  }
}
