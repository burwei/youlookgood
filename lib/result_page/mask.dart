import 'package:flutter/material.dart';

class Mask extends CustomPainter {
  // The current drawing path.
  final List<Offset> pointsToDraw;

  // Eraser paint.
  final Paint eraserPaint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..color = Colors.white
    ..blendMode = BlendMode.clear
    ..strokeWidth = 25;

  // Background mask paint.
  final maskPaint = Paint()..color = const Color.fromARGB(50, 0, 0, 0);

  Mask(this.pointsToDraw);

  @override
  void paint(Canvas canvas, Size size) {
    // save original status
    canvas.saveLayer(Rect.largest, Paint());
    // draw background mask
    canvas.drawPaint(maskPaint);
    // draw the current path (erase some part of the mask)
    for (int i = 0; i < pointsToDraw.length - 1; i++) {
      canvas.drawLine(
        pointsToDraw[i],
        pointsToDraw[i + 1],
        eraserPaint,
      );
    }
    // show the result
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
