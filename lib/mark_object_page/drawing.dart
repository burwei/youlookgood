import 'package:flutter/material.dart';

// These widgets are modified from samirpokharel's Drawing_board_app.
// source: https://github.com/samirpokharel/Drawing_board_app.
// Nice job samirpokharel, thank you!
class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key, required this.callback});

  final Function(List<Offset?>) callback;

  @override
  DrawingBoardState createState() => DrawingBoardState();
}

class DrawingBoardState extends State<DrawingBoard> {
  final List<Offset?> _currentPoints = [];
  final _HistoryPointStack _historyStack = _HistoryPointStack();
  final int _samplingNum = 5;
  final Paint _markingPaint = Paint()
    ..isAntiAlias = true
    ..color = Colors.pink.shade200
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 25;
  int _cursor = 0; // which path is the user drawing
  int _samplingCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // history paths
        // We don't want to repaint history paths everytime.
        // p.s. Without RepaintBoundary the hisptory paths will repaint everytime
        // even when we alrady set the shouldRepaint to false.
        RepaintBoundary(
          child: CustomPaint(
            painter: DrawingPen(
              false,
              _historyStack.points,
              _markingPaint,
              _cursor,
            ),
            isComplex: true,
            willChange: false,
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
            _currentPoints,
            _markingPaint,
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
              _currentPoints.add(details.localPosition);
            });
          },
          onPanUpdate: (details) {
            // Batch update improve the performance significantly.
            if (_samplingCounter == _samplingNum) {
              setState(() {
                _currentPoints.add(details.localPosition);
                _samplingCounter = 0;
              });
            } else {
              _samplingCounter++;
            }
          },
          onPanEnd: (details) {
            setState(() {
              // Check if we need to clear the obsolete items.
              if (_cursor != _historyStack.size) {
                _historyStack.popPaths(
                  _historyStack.size - _cursor,
                );
              }
              // Add current drawing path to history drawing path and update variables.
              _currentPoints.add(null);
              _historyStack.pushPath(List<Offset?>.from(_currentPoints));
              _currentPoints.clear();
              _cursor++;
              // Update widget result.
              widget.callback(_historyStack.points);
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
                    _cursor--;

                    if (_cursor < 0) {
                      _cursor = 0;
                    }

                    widget.callback(_historyStack.getCurrentResult(_cursor));
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
                    _cursor++;

                    if (_cursor > _historyStack.size) {
                      _cursor = _historyStack.size;
                    }

                    widget.callback(_historyStack.getCurrentResult(_cursor));
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

  List<Offset?> getCurrentResult(int cursor) {
    var result = List<Offset?>.from(points);
    if (cursor == idxStartOfPath.length) {
      cursor--;
    }

    result.removeRange(
      idxStartOfPath[cursor],
      points.length,
    );

    return result;
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
