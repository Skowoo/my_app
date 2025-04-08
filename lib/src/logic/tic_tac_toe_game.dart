import 'dart:math';

class TicTacToeGame {
  static bool checkWin(String board, String player) {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    return winPatterns.any(
      (pattern) => pattern.every((index) => board[index] == player),
    );
  }

  static bool checkDraw(String board) => !board.contains(' ');

  static String makeMove(String board, String player) {
    var emptyIndexes = [
      for (int i = 0; i < board.length; i++)
        if (board[i] == ' ') i,
    ];
    if (emptyIndexes.isNotEmpty) {
      int move = emptyIndexes[Random().nextInt(emptyIndexes.length)];
      return '${board.substring(0, move)}O${board.substring(move + 1)}';
    }
    return board;
  }
}
