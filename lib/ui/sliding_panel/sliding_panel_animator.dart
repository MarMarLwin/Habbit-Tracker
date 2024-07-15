// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:habit_tracker/ui/sliding_panel/sliding_panel.dart';

class SlidingPanelAnimator extends StatefulWidget {
  const SlidingPanelAnimator({
    super.key,
    required this.direction,
    required this.child,
  });
  final SlideDirection direction;
  final Widget child;

  @override
  State<SlidingPanelAnimator> createState() => SlidingPanelAnimatorState();
}

class SlidingPanelAnimatorState extends State<SlidingPanelAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void slideIn() {
    _animationController.forward();
  }

  void slideOut() {
    _animationController.reverse();
  }

  double _getOffset(double screenWidth, double animationValue) {
    final startPixelValue = widget.direction == SlideDirection.rightToLeft
        ? screenWidth - SlidingPanel.leftPanelFixedWidth
        : -SlidingPanel.leftPanelFixedWidth;

    return startPixelValue * (1 - animationValue);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: SlidingPanel(direction: widget.direction, child: widget.child),
      builder: (BuildContext context, Widget? child) {
        final animationValue = _animationController.value;
        final screenWidth = MediaQuery.sizeOf(context).width;
        final offsetX = _getOffset(screenWidth, animationValue);
        return Transform.translate(offset: Offset(offsetX, 0), child: child);
      },
    );
  }
}
