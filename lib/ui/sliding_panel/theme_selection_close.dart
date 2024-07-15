import 'package:flutter/material.dart';

import '../theming/app_theme.dart';

class ThemeSelectionClose extends StatelessWidget {
  const ThemeSelectionClose({super.key, this.onClose});
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClose,
      icon: Icon(
        Icons.close,
        color: AppTheme.of(context).accentNegative,
      ),
    );
  }
}
