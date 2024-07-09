// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

class TaskCompletionRing extends StatelessWidget {
  const TaskCompletionRing({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    // final themeData = AppTheme.of(context);
    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(
        painter:
            RingPainter(progress, Colors.black.withOpacity(0.6), Colors.white),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color completedColor;

  RingPainter(this.progress, this.progressColor, this.completedColor);
  @override
  void paint(Canvas canvas, Size size) {
    final notCompleted = progress < 1.0;
    final strokeWidth = (size.width) / 15.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        notCompleted ? (size.width - strokeWidth) / 2 : size.width / 2;

    if (notCompleted) {
      final backgroundPaint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..color = progressColor
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, backgroundPaint);
    }

    final foregroundPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..color = completedColor
      ..style = notCompleted ? PaintingStyle.stroke : PaintingStyle.fill;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        2 * pi * progress, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
