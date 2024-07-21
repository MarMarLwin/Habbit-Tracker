// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:habit_tracker/constants/text_styles.dart';
import 'package:habit_tracker/extensions/extensions.dart';
import 'package:habit_tracker/ui/common_widgets/app_bar_icon_button.dart';
import 'package:habit_tracker/ui/common_widgets/center_svg_icon.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

import '../../constants/app_assets.dart';

class SelectIconPage extends StatelessWidget {
  const SelectIconPage({
    super.key,
    required this.selectedIconName,
  });
  final String selectedIconName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).primary,
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).secondary,
        leading: AppBarIconButton(
            iconName: AppAssets.navigationClose,
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          'Select Icon',
          style: TextStyles.heading
              .copyWith(color: AppTheme.of(context).settingsText),
        ),
      ),
      body: SelectIconGrid(
        selectedIconName: selectedIconName,
        onSelectedIcon: (selectedIcon) =>
            Navigator.of(context).pop(selectedIcon),
      ),
    );
  }
}

class SelectIconGrid extends StatefulWidget {
  const SelectIconGrid({
    super.key,
    required this.selectedIconName,
    this.onSelectedIcon,
  });
  final String selectedIconName;
  final ValueChanged<String>? onSelectedIcon;

  @override
  State<SelectIconGrid> createState() => _SelectIconGridState();
}

class _SelectIconGridState extends State<SelectIconGrid> {
  late String _selectedIconName = widget.selectedIconName;

  void _select(String selectedIconName) {
    if (_selectedIconName == selectedIconName) {
      widget.onSelectedIcon?.call(_selectedIconName);
    } else {
      setState(() {
        _selectedIconName = selectedIconName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, crossAxisSpacing: 20, mainAxisSpacing: 20),
      itemCount: AppAssets.allTaskIcons.length,
      padding: 10.allPadding,
      itemBuilder: (context, index) {
        final iconName = AppAssets.allTaskIcons[index];
        return SelectTaskIcon(
          isSelected: _selectedIconName == iconName,
          iconName: iconName,
          onPressed: () => _select(iconName),
        );
      },
    );
  }
}

class SelectTaskIcon extends StatelessWidget {
  const SelectTaskIcon({
    super.key,
    required this.isSelected,
    required this.iconName,
    required this.onPressed,
  });
  final bool isSelected;
  final String iconName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? AppTheme.of(context).accent
                : AppTheme.of(context).settingsInactiveIconBackground),
        child: CenterSvgIcon(
            iconName: iconName,
            color: isSelected
                ? AppTheme.of(context).accentNegative
                : Colors.white),
      ),
    );
  }
}
