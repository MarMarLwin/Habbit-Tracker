// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:habit_tracker/ui/common_widgets/center_svg_icon.dart';
import 'package:habit_tracker/ui/task/task_completion_ring.dart';

import '../../constants/app_assets.dart';
import '../theming/app_theme.dart';

class TaskAnimated extends StatefulWidget {
  const TaskAnimated({
    super.key,
    required this.iconName,
    required this.completed,
    this.onCompleted,
  });

  final String iconName;
  final bool completed;
  final ValueChanged<bool>? onCompleted;
  @override
  State<TaskAnimated> createState() => _TaskAnimatedState();
}

class _TaskAnimatedState extends State<TaskAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _curvedAnimation;
  bool _showCheckIcon = false;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _animationController.addStatusListener(_checkStatusUpdates);
    _curvedAnimation =
        _animationController.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_checkStatusUpdates);
    _animationController.dispose();
    super.dispose();
  }

  void _checkStatusUpdates(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onCompleted?.call(true);
      // if (widget.completed) {
      setState(() {
        _showCheckIcon = true;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _showCheckIcon = false;
        });
      });
      // } else {
      //   _animationController.value = 0.0;
      // }
    }
  }

  void _handleTapDown(TapDownDetails tapDetails) {
    if (!widget.completed &&
        _animationController.status != AnimationStatus.completed) {
      _animationController.forward();
    } else if (!_showCheckIcon) {
      widget.onCompleted?.call(false);
      _animationController.value = 0.0;
    }
  }

  void _handleTapCancel() {
    if (_animationController.status != AnimationStatus.completed) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final themeData = AppTheme.of(context);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (_) => _handleTapCancel(),
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _curvedAnimation,
        builder: (BuildContext context, Widget? child) {
          final progress = widget.completed ? 1.0 : _curvedAnimation.value;
          final hasCompleted = progress == 1.0;
          return Stack(children: [
            TaskCompletionRing(progress: progress),
            Positioned.fill(
                child: CenterSvgIcon(
                    iconName:
                        _showCheckIcon ? AppAssets.check : widget.iconName,
                    color: hasCompleted
                        ? AppTheme.of(context).primary
                        : Colors.white))
          ]);
        },
      ),
    );
  }
}
