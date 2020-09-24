import 'dart:math';

import 'gameboard.dart';
import 'helper.dart';
import 'tictactoe.dart';

class MiniMaxAI {
  int _miniMax(Map<int, Mark> board, int depth, bool isMaximizing) {
    Winner winner = getWinner(board)['winner'];

    // End state
    if (winner == Winner.tie) {
      return 0;
    } else if (winner != Winner.none) {
      return winner == Winner.x ? 100 : -100;
    }

    // Intermediate state
    int bestScore = isMaximizing ? -999 : 999;

    for (int i = 0; i < 9; i++) {
      if (!board.containsKey(i)) {
        board[i] = isMaximizing ? AI : HUMAN;

        bestScore = isMaximizing
            ? max(bestScore, _miniMax(board, depth + 1, false))
            : min(bestScore, _miniMax(board, depth + 1, true));

        board.remove(i);
      }
    }

    return isMaximizing ? bestScore - depth : bestScore + depth;
  }

  int move(Map<int, Mark> board) {
    int bestScore = -999;
    int bestMove;

    for (int i = 0; i < 9; i++) {
      if (!board.containsKey(i)) {
        board[i] = AI;
        int score = _miniMax(board, 0, false);

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
        board.remove(i);
      }
    }

    return bestMove;
  }
}
