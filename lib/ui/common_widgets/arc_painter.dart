import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 246, 246, 246)
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2.5 - 19.5, 0)
      ..arcToPoint(
        Offset(size.width / 2.5 + 19.5, 0),
        radius: const Radius.circular(20),
        clockwise: false,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2.5 + 19.5, size.height)
      ..arcToPoint(
        Offset(size.width / 2.5 - 19.5, size.height),
        radius: const Radius.circular(20),
        clockwise: false,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);

    // Paint for the dotted lines
    Paint dottedLinePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;
    // Define the step for the dotted line segments
    double lineLength = 5.0;
    double gapLength = 5.0;
    double startY = 20; // Starting position below the top arc
    double endY = size.height - 20; // Ending position above the bottom arc

    // Draw dotted lines from top to bottom arc
    for (double y = startY; y < endY; y += lineLength + gapLength) {
      canvas.drawLine(
        Offset(size.width / 2.5, y),
        Offset(size.width / 2.5, y + lineLength),
        dottedLinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


// Container(
//                     height: 100,
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(20),
//                           topRight: Radius.circular(20)),
//                       boxShadow: [
//                         BoxShadow(
//                           offset: Offset(0, 8),
//                           blurRadius: 14,
//                           spreadRadius: 2,
//                           color: Color.fromARGB(39, 0, 0, 0),
//                           blurStyle: BlurStyle.normal,
//                         ),
//                       ],
//                     ),
//                     child: CustomPaint(
//                       painter: ArcPainter(),
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 100,
//                             color: Colors.blue,
//                           ),
//                           Container(
//                             height: 100,
//                             color: Colors.red,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),