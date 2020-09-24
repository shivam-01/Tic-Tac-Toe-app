import 'package:flutter/material.dart';

enum Mark { x, o, none }
enum Winner { x, o, tie, none }

const STROKE_WIDTH = 4.5;
const HALF_STROKE_WIDTH = STROKE_WIDTH / 2.0;
const DOUBLE_STROKE_WIDTH = STROKE_WIDTH * 2.0;

class GameBoardPainter extends CustomPainter {
  static double _dividedSize;
  Map<int, Mark> _gameMarks;
  List<int> _winningLine;

  GameBoardPainter(this._gameMarks, this._winningLine);

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = STROKE_WIDTH
      ..color = Colors.white
      ..strokeCap = StrokeCap.round;

    final blueGreyThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DOUBLE_STROKE_WIDTH * 0.5
      ..color = Colors.blueGrey
      ..strokeCap = StrokeCap.round;

    final redThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DOUBLE_STROKE_WIDTH * 0.5
      ..color = Colors.redAccent;

    final whiteThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DOUBLE_STROKE_WIDTH
      ..color = Colors.white54
      ..strokeCap = StrokeCap.round;

    _dividedSize = size.width / 3.0;

    // 1st horizontal line
    canvas.drawLine(
        Offset(STROKE_WIDTH, _dividedSize - HALF_STROKE_WIDTH),
        Offset(size.width - STROKE_WIDTH, _dividedSize - HALF_STROKE_WIDTH),
        blackPaint);

    // 2nd horizontal line
    canvas.drawLine(
        Offset(STROKE_WIDTH, _dividedSize * 2 - HALF_STROKE_WIDTH),
        Offset(size.width - STROKE_WIDTH, _dividedSize * 2 - HALF_STROKE_WIDTH),
        blackPaint);

    // 1st vertical line
    canvas.drawLine(
        Offset(_dividedSize - HALF_STROKE_WIDTH, STROKE_WIDTH),
        Offset(_dividedSize - HALF_STROKE_WIDTH, size.height - STROKE_WIDTH),
        blackPaint);

    // 2nd vertical line
    canvas.drawLine(
        Offset(_dividedSize * 2 - HALF_STROKE_WIDTH, STROKE_WIDTH),
        Offset(
            _dividedSize * 2 - HALF_STROKE_WIDTH, size.height - STROKE_WIDTH),
        blackPaint);

    _gameMarks.forEach((index, mark) {
      switch (mark) {
        case Mark.o:
          drawNought(canvas, index, redThickPaint);
          break;
        case Mark.x:
          drawCross(canvas, index, blueGreyThickPaint);
          break;
        default:
          break;
      }
    });

    drawWinningLine(canvas, _winningLine, whiteThickPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  static double getDividedSize() => _dividedSize;

  void drawNought(Canvas canvas, int index, Paint paint) {
    double left = (index % 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2;
    double top = (index ~/ 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2;
    double noughtSize = _dividedSize - DOUBLE_STROKE_WIDTH * 4;

    canvas.drawOval(Rect.fromLTWH(left, top, noughtSize, noughtSize), paint);
  }

  void drawCross(Canvas canvas, int index, Paint paint) {
    double x1, y1;
    double x2, y2;

    x1 = (index % 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2.5;
    y1 = (index ~/ 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2.5;

    x2 = (index % 3 + 1.0) * _dividedSize - DOUBLE_STROKE_WIDTH * 2.5;
    y2 = (index ~/ 3 + 1.0) * _dividedSize - DOUBLE_STROKE_WIDTH * 2.5;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

    x1 = (index % 3 + 1.0) * _dividedSize - DOUBLE_STROKE_WIDTH * 2.5;
    y1 = (index ~/ 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2.5;

    x2 = (index % 3) * _dividedSize + DOUBLE_STROKE_WIDTH * 2.5;
    y2 = (index ~/ 3 + 1.0) * _dividedSize - DOUBLE_STROKE_WIDTH * 2.5;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  void drawWinningLine(Canvas canvas, List<int> winningLine, Paint paint) {
    if (winningLine == null) return;

    double x1 = 0, y1 = 0;
    double x2 = 0, y2 = 0;

    int firstIndex = winningLine.first;
    int lastIndex = winningLine.last;

    if (firstIndex % 3 == lastIndex % 3) {
      // Vertical line
      x1 = x2 = firstIndex % 3 * _dividedSize + _dividedSize / 2;
      y1 = STROKE_WIDTH;
      y2 = _dividedSize * 3 - STROKE_WIDTH;
    } else if (firstIndex ~/ 3 == lastIndex ~/ 3) {
      // Horizontal line
      x1 = STROKE_WIDTH;
      x2 = _dividedSize * 3 - STROKE_WIDTH;
      y1 = y2 = firstIndex ~/ 3 * _dividedSize + _dividedSize / 2;
    } else {
      // Diagonal line
      if (firstIndex == 0) {
        x1 = y1 = DOUBLE_STROKE_WIDTH;
        x2 = y2 = _dividedSize * 3 - DOUBLE_STROKE_WIDTH;
      } else {
        x1 = _dividedSize * 3 - DOUBLE_STROKE_WIDTH;
        y1 = DOUBLE_STROKE_WIDTH;
        x2 = DOUBLE_STROKE_WIDTH;
        y2 = _dividedSize * 3 - DOUBLE_STROKE_WIDTH;
      }
    }

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }
}
