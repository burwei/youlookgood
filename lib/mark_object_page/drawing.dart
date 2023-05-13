import 'package:flutter/material.dart';

// These widgets are modified from samirpokharel's Drawing_board_app.
// source: https://github.com/samirpokharel/Drawing_board_app.
// Nice job samirpokharel, thank you!
// TODO: The drawing board becomes lagging after too much points. Fix it.
class DrawingBoard extends StatefulWidget {
  DrawingBoard({super.key});

  final List<Offset?> result = [];

  List<Offset?> getResult() {
    return result;
  }

  @override
  DrawingBoardState createState() => DrawingBoardState();
}

class DrawingBoardState extends State<DrawingBoard> {
  final List<Offset?> currentPoints = [];
  final _HistoryPointStack _historyStack = _HistoryPointStack();
  final Paint markingPaint = Paint()
    ..isAntiAlias = true
    ..color = Colors.pink.shade200
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 25;
  int cursor = 0; // which path is the user drawing

  @override
  void initState() {
    super.initState();

    widget.result.clear();
    currentPoints.clear();
    _historyStack.clear();
    cursor = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // history paths
        // p.s. Without RepaintBoundary the hisptory paths will repaint everytime
        // even when we alrady set the shouldRepaint to false.
        RepaintBoundary(
          child: CustomPaint(
            painter: DrawingPen(
              false,
              _historyStack.points,
              markingPaint,
              cursor,
            ),
            isComplex: true,
            willChange: true,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        // current drawing path
        CustomPaint(
          painter: DrawingPen(
            true,
            currentPoints,
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
              currentPoints.add(details.localPosition);
            });
          },
          onPanUpdate: (details) {
            setState(() {
              currentPoints.add(details.localPosition);
            });
          },
          onPanEnd: (details) {
            setState(() {
              // Check if we need to clear the obsolete items.
              if (cursor != _historyStack.size) {
                _historyStack.popPaths(
                  _historyStack.size - cursor,
                );
              }
              // Add current drawing path to history drawing path and update variables.
              currentPoints.add(null);
              _historyStack.pushPath(List<Offset?>.from(currentPoints));
              currentPoints.clear();
              cursor++;
              // Update widget result.
              widget.result.clear();
              widget.result.addAll(_historyStack.points);
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

                    if (cursor > _historyStack.size) {
                      cursor = _historyStack.size;
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

class _HistoryPointStack {
  int size = 0;
  List<Offset?> points = [];
  List<int> idxStartOfPath = [];

  void clear() {
    size = 0;
    points.clear();
    idxStartOfPath.clear();
  }

  void pushPath(List<Offset?> newPoints) {
    points.addAll(newPoints);
    idxStartOfPath.add(points.length - newPoints.length);
    size++;
  }

  void popPaths(int numToPop) {
    int target = size - numToPop;
    points.removeRange(
      idxStartOfPath[target],
      points.length,
    );
    idxStartOfPath.removeRange(target, idxStartOfPath.length);
    size = target;
  }
}

class DrawingPen extends CustomPainter {
  // Type of the points: current or histroy.
  final bool isCurrent;

  // All points that will be drawn.
  final List<Offset?> points;

  // The style of the paint.
  final Paint paintStyle;

  // The number of path to draw.
  // It'll be used in the undo/redo feature.
  int pathNum;

  DrawingPen(
    this.isCurrent,
    this.points,
    this.paintStyle,
    this.pathNum,
  );

  @override
  void paint(Canvas canvas, Size size) {
    print(
      "isCurrent: $isCurrent,  points: ${points.length}, pathNum: $pathNum",
    );

    int pathCounter = 0;

    for (int i = 0; i < points.length - 1; i++) {
      if (pathCounter == pathNum) {
        break;
      }

      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!,
          points[i + 1]!,
          paintStyle,
        );
      }

      if (points[i] == null) {
        pathCounter++;
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPen oldDelegate) {
    if (isCurrent) {
      return true;
    } else {
      return oldDelegate.pathNum != pathNum;
    }
  }
}
