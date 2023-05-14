import 'package:flutter/material.dart';

class Mask extends CustomPainter {
  // The current drawing path.
  final List<Offset?> points;

  // Eraser paint.
  final Paint eraserPaint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..color = Colors.white
    ..blendMode = BlendMode.clear
    ..strokeWidth = 25;

  // Background mask paint.
  final maskPaint = Paint()..color = const Color.fromARGB(50, 0, 0, 0);

  Mask(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    // Save original status.
    canvas.saveLayer(Rect.largest, Paint());
    // Draw background mask.
    canvas.drawPaint(maskPaint);
    // Draw the current path (erase some part of the mask).
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!,
          points[i + 1]!,
          eraserPaint,
        );
      }
    }
    // Show the result.
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
