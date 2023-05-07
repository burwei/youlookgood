import 'package:flutter/material.dart';

// These widgets are modified from samirpokharel's Drawing_board_app.
// source: https://github.com/samirpokharel/Drawing_board_app.
// Nice job samirpokharel, thank you!
class DrawingBoard extends StatefulWidget {
  DrawingBoard({super.key});

  final List<Offset> result = [];

  List<Offset> getResult() {
    return result;
  }

  @override
  DrawingBoardState createState() => DrawingBoardState();
}

class DrawingBoardState extends State<DrawingBoard> {
  final List<Offset> currentDrawingPath = [];
  final List<List<Offset>> historyDrawingPaths = [];

  int cursor = 0;

  @override
  void initState() {
    super.initState();

    widget.result.clear();
    currentDrawingPath.clear();
    historyDrawingPaths.clear();
    cursor = 0; // start from the first path
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanStart: (details) {
            setState(() {
              currentDrawingPath.add(details.localPosition);
            });
          },
          onPanUpdate: (details) {
            setState(() {
              currentDrawingPath.add(details.localPosition);
            });
          },
          onPanEnd: (details) {
            setState(() {
              // Complete the path.
              if (currentDrawingPath.length % 2 == 1) {
                currentDrawingPath.add(currentDrawingPath.last);
              }
              // Check if we need to clear the obsolete items.
              if (cursor != historyDrawingPaths.length) {
                int removeItemNum = historyDrawingPaths.length - cursor;
                for (int i = 0; i < removeItemNum; i++) {
                  historyDrawingPaths.removeAt(cursor);
                }
              }
              // Add current drawing path to history drawing path and update variables.
              historyDrawingPaths.add(List<Offset>.from(currentDrawingPath));
              currentDrawingPath.clear();
              cursor++;
              // Update widget result.
              widget.result.clear();
              for (int i = 0; i < historyDrawingPaths.length; i++) {
                widget.result.addAll(historyDrawingPaths[i]);
              }
            });
          },
          child: CustomPaint(
            painter:
                DrawingPen(currentDrawingPath, historyDrawingPaths, cursor),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // undo button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.pink,
                  width: 3,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    cursor--;

                    if (cursor < 0) {
                      cursor = 0;
                    }
                  });
                },
                icon: const Icon(
                  Icons.undo,
                  color: Colors.pink,
                ),
                iconSize: 40,
              ),
            ),
            // redo button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.pink,
                  width: 3,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    cursor++;

                    if (cursor > historyDrawingPaths.length) {
                      cursor = historyDrawingPaths.length;
                    }
                  });
                },
                icon: const Icon(
                  Icons.redo,
                  color: Colors.pink,
                ),
                iconSize: 40,
              ),
            )
          ],
        )
      ],
    );
  }
}

class DrawingPen extends CustomPainter {
  // The current drawing path.
  final List<Offset> currentDrawingPath;

  // A stack to store multiple drawing paths.
  // A drawing paths contains multiple drawing points.
  final List<List<Offset>> historyDrawingPaths;

  // Eraser paint.
  final Paint eraserPaint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..color = const Color.fromARGB(50, 255, 255, 255)
    ..blendMode = BlendMode.clear
    ..strokeWidth = 25;

  // Background mask paint.
  final maskPaint = Paint()..color = const Color.fromARGB(100, 0, 0, 0);

  // The index of the current drawing path.
  // It'll be used in the undo/redo feature.
  int cursor;

  DrawingPen(this.currentDrawingPath, this.historyDrawingPaths, this.cursor);

  @override
  void paint(Canvas canvas, Size size) {
    // save original status
    canvas.saveLayer(Rect.largest, Paint());
    // draw background mask
    canvas.drawPaint(maskPaint);
    // draw the current path (erase some part of the mask)
    for (int i = 0; i < currentDrawingPath.length - 1; i++) {
      canvas.drawLine(
        currentDrawingPath[i],
        currentDrawingPath[i + 1],
        eraserPaint,
      );
    }
    // draw the history path (erase some part of the mask)
    for (int i = 0; i < cursor; i++) {
      for (int j = 0; j < historyDrawingPaths[i].length - 1; j++) {
        canvas.drawLine(
          historyDrawingPaths[i][j],
          historyDrawingPaths[i][j + 1],
          eraserPaint,
        );
      }
    }
    // show the result
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
