import 'package:flutter/material.dart';

// These widgets are modified from samirpokharel's Drawing_board_app.
// source: https://github.com/samirpokharel/Drawing_board_app.
// Nice job samirpokharel, thank you!
class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  DrawingBoardState createState() => DrawingBoardState();
}

class DrawingBoardState extends State<DrawingBoard> {
  final List<DrawingPoint> currentDrawingPath = [];
  final List<List<DrawingPoint>> drawingPaths = [];
  Paint paintStyle = Paint();
  int cursor = 0;

  @override
  void initState() {
    super.initState();

    paintStyle = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..color = const Color.fromARGB(100, 233, 30, 99) // pink
      ..strokeWidth = 25;

    cursor = 0; // start from the first path
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          currentDrawingPath
              .add(DrawingPoint(details.localPosition, paintStyle));
        });
      },
      onPanUpdate: (details) {
        setState(() {
          currentDrawingPath
              .add(DrawingPoint(details.localPosition, paintStyle));
        });
      },
      onPanEnd: (details) {
        setState(() {
          drawingPaths.add(List<DrawingPoint>.from(currentDrawingPath));
          currentDrawingPath.clear();
          cursor++;
        });
      },
      child: CustomPaint(
        painter: DrawingPen(currentDrawingPath, drawingPaths, cursor),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

class DrawingPen extends CustomPainter {
  // The current drawing path.
  final List<DrawingPoint> currentDrawingPath;

  // A stack to store multiple drawing paths.
  // A drawing paths contains multiple drawing points.
  final List<List<DrawingPoint>> drawingPaths;

  // The index of the current drawing path.
  // It'll be used in the undo/redo feature.
  int cursor;

  DrawingPen(this.currentDrawingPath, this.drawingPaths, this.cursor);

  @override
  void paint(Canvas canvas, Size size) {
    // draw the current path
    for (int i = 0; i < currentDrawingPath.length - 1; i++) {
      canvas.drawLine(
        currentDrawingPath[i].offset,
        currentDrawingPath[i + 1].offset,
        currentDrawingPath[i].paint,
      );
    }
    // draw the drawn path
    for (int i = 0; i < cursor; i++) {
      var drawingPoints = drawingPaths[i];
      for (int j = 0; j < drawingPoints.length - 1; j++) {
        canvas.drawLine(
          drawingPoints[j].offset,
          drawingPoints[j + 1].offset,
          drawingPoints[j].paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
