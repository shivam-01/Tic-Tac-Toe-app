import 'gameboard.dart';

Map<String, dynamic> getWinner(Map<int, Mark> board) {
  final winningLines = [
    [0, 1, 2], // Horizontal
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6], // Vertical
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8], // Diagonal
    [2, 4, 6]
  ];

  List<int> winningLineFound;
  Winner winner = Winner.none;

  winningLines.forEach((winningLine) {
    int countNoughts = 0;
    int countCrosses = 0;

    winningLine.forEach((index) {
      if (board[index] == Mark.o) {
        ++countNoughts;
      } else if (board[index] == Mark.x) {
        ++countCrosses;
      }
    });

    if (countNoughts >= 3 || countCrosses >= 3) {
      winningLineFound = winningLine;
      winner = countNoughts >= 3 ? Winner.o : Winner.x;
    }
  });

  if (board.length >= 9 && winner == Winner.none) {
    winner = Winner.tie;
  }

  return {'winningLine': winningLineFound, 'winner': winner};
}
