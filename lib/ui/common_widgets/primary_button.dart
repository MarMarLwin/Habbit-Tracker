import 'package:flutter/cupertino.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../theming/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.title, this.onPressed});
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: CupertinoButton(
        color: AppTheme.of(context).settingsCta,
        pressedOpacity: 0.8,
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyles.heading.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
