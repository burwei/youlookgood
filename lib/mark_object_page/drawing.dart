import 'package:flutter/material.dart';

// These widgets are modified from samirpokharel's Drawing_board_app.
// source: https://github.com/samirpokharel/Drawing_board_app.
// Nice job samirpokharel, thank you!
// TODO: The drawing board becomes lagging after too much points. Fix it.
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
  final Paint markingPaint = Paint()
    ..isAntiAlias = true
    ..color = Colors.pink.shade200
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 25;
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
        // history paths
        CustomPaint(
          painter: DrawingPen([], historyDrawingPaths, markingPaint, cursor),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        // current drawing path
        CustomPaint(
          painter: DrawingPen(
            currentDrawingPath,
            [],
            markingPaint,
            1,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        // full screen gesture detector
        // (it grows to fit the parent if no child)
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
        ),
        // edit bar: undo and redo button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // pen icon
            Container(
              decoration: BoxDecoration(
                color: Colors.pink,
                border: Border.all(
                  color: Colors.pink,
                  width: 3,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: IconButton(
                onPressed: () {
                  // do nothing at this point
                },
                icon: const Icon(
                  Icons.draw,
                  color: Colors.white,
                ),
                iconSize: 40,
              ),
            ),
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
  // Single path to draw. One path contains multiple points.
  List<Offset> pointsToDraw;
  // Multiple paths to draw.
  List<List<Offset>> pathsToDraw;

  // The style of the paint.
  final Paint paintStyle;

  // The number of path to draw.
  // It'll be used in the undo/redo feature.
  int pathNum;

  DrawingPen(
    this.pointsToDraw,
    this.pathsToDraw,
    this.paintStyle,
    this.pathNum,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // Concat all the points.
    if (pointsToDraw.isNotEmpty) {
      if (pointsToDraw.length % 2 == 1) {
        pointsToDraw.add(pointsToDraw.last);
      }
    }
    if (pathsToDraw.isNotEmpty) {
      for (int i = 0; i < pathNum; i++) {
        for (int j = 0; j < pathsToDraw[i].length; j++) {
          pointsToDraw.add(pathsToDraw[i][j]);
        }
        if (pathsToDraw[i].length % 2 == 1) {
          pointsToDraw.add(pointsToDraw.last);
        }
      }
    }

    // Draw the lines bwtween each points in the same path.
    for (int i = 0; i < pointsToDraw.length - 1; i += 2) {
      canvas.drawLine(
        pointsToDraw[i],
        pointsToDraw[i + 1],
        paintStyle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
