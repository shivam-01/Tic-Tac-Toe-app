import 'package:TicTacToe/gameboard.dart';
import 'package:flutter/material.dart';

import 'helper.dart';
import 'minimax.dart';

const AI = Mark.x;
const HUMAN = Mark.o;

class TicTacToe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TicTacToeState();
}

class _TicTacToeState extends State {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<int, Mark> _gameMarks = Map();
  Mark _currentMark = Mark.o;
  List<int> _winningLine;
  MiniMaxAI ai = MiniMaxAI();
  Winner _winner = Winner.none;

  void showSnackBar(String message, IconData icon) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(icon),
          SizedBox(width: 20.0),
          Expanded(child: Text(message)),
        ],
      ),
      duration: Duration(milliseconds: 600),
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.redAccent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: GestureDetector(
              onTapUp: (TapUpDetails details) {
                setState(() {
                  if (_addMark(
                      x: details.localPosition.dx,
                      y: details.localPosition.dy)) {
                    if (_winner == Winner.none || _winner == Winner.tie) {
                      _addMark(index: ai.move(_gameMarks));
                    }
                  }
                });
              },
              child: AspectRatio(
                aspectRatio: 1.0,
                child: CustomPaint(
                  painter: GameBoardPainter(_gameMarks, _winningLine),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _addMark({int index = -1, double x = -1.0, double y = -1.0}) {
    bool isAbsent = false;

    if (_gameMarks.length >= 9 || _winningLine != null) {
      if (index == -1) {
        _gameMarks = Map<int, Mark>();
        _currentMark = Mark.o;
        _winningLine = null;
        showSnackBar('New Game!', Icons.golf_course);
      }
    } else {
      double _dividedSize = GameBoardPainter.getDividedSize();

      if (index == -1) {
        index = (x ~/ _dividedSize + (y ~/ _dividedSize) * 3).toInt();
      }

      _gameMarks.putIfAbsent(index, () {
        isAbsent = true;
        return _currentMark;
      });

      _winningLine = getWinner(_gameMarks)['winningLine'];
      _winner = getWinner(_gameMarks)['winner'];
      if (_winner == Winner.x) {
        showSnackBar('You Lost!', Icons.sentiment_dissatisfied);
      } else if (_winner == Winner.tie) {
        showSnackBar('Game Tied!', Icons.sentiment_neutral);
      }

      if (isAbsent) _currentMark = _currentMark == Mark.o ? Mark.x : Mark.o;
    }
    return isAbsent;
  }
}
