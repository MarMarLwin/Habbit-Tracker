import 'package:flutter/material.dart';
import 'package:habit_tracker/constants/text_styles.dart';
import 'package:habit_tracker/ui/add_task/custom_text_field.dart';
import 'package:habit_tracker/ui/common_widgets/app_bar_icon_button.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

import '../../constants/app_assets.dart';
import '../../models/task_preset.dart';
import 'add_task_navigator.dart';
import 'task_preset_list_tile.dart';
import 'text_field_header.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task',
            style: TextStyles.heading
                .copyWith(color: AppTheme.of(context).settingsText)),
        backgroundColor: AppTheme.of(context).secondary,
        leading: AppBarIconButton(
          iconName: AppAssets.navigationClose,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      backgroundColor: AppTheme.of(context).primary,
      body: const AddTaskContent(),
    );
  }
}

class AddTaskContent extends StatelessWidget {
  const AddTaskContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 32),
              const TextFieldHeader('CREATE YOUR OWN:'),
              CustomTextField(
                hintText: 'Enter task title...',
                showChevron: true,
                onSubmit: (value) => Navigator.of(context).pushNamed(
                  AddTaskRoutes.confirmTask,
                  arguments: TaskPreset(
                      iconName: value.substring(0, 1).toUpperCase(),
                      name: value),
                ),
              ),
              const SizedBox(height: 32),
              const TextFieldHeader('OR CHOOSE A PRESET:'),
            ],
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return TaskPresetListTile(
              taskPreset: TaskPreset.allPresets[index],
              onPressed: (taskPreset) => Navigator.of(context).pushNamed(
                AddTaskRoutes.confirmTask,
                arguments: taskPreset,
              ),
            );
          },
          childCount: TaskPreset.allPresets.length,
        ))
      ],
    );
  }
}
