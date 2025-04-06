import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/tic_tac_toe_board.dart';

class SingleGame extends StatefulWidget {
  const SingleGame({super.key});

  @override
  SingleGameState createState() => SingleGameState();
}

class SingleGameState extends State<SingleGame> {
  String board = '         ';
  String gameStatus = 'Czekam na ruch';
  bool isGameOver = false;

  void moveX(int index) {
    if (board[index] == ' ' && !isGameOver) {
      setState(() {
        board = '${board.substring(0, index)}X${board.substring(index + 1)}';
        checkGameState('X');
      });
    }
  }

  void moveO(int index) {
    if (board[index] == ' ' && !isGameOver) {
      setState(() {
        board = '${board.substring(0, index)}O${board.substring(index + 1)}';
        checkGameState('O');
      });
    }
  }

  void checkGameState(String player) {
    if (checkWin(player)) {
      gameStatus = player == 'X' ? 'Wygrana!' : 'Porażka!';
      isGameOver = true;
    } else if (!board.contains('')) {
      gameStatus = 'Remis!';
      isGameOver = true;
    } else {
      gameStatus =
          player == 'X' ? 'Czekaj na ruch przeciwnika' : 'Czekam na ruch';
      if (player == 'X') makeAutoMove();
    }
  }

  void makeAutoMove() {
    var emptyIndexes = [
      for (int i = 0; i < board.length; i++)
        if (board[i] == ' ') i,
    ];
    if (emptyIndexes.isNotEmpty) {
      int move = emptyIndexes[Random().nextInt(emptyIndexes.length)];
      moveO(move);
    }
  }

  bool checkWin(String player) {
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

  void restartGame() {
    setState(() {
      board = '         ';
      gameStatus = 'Czekam na ruch';
      isGameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gra jednoosobowa'), centerTitle: true),
      body: Column(
        children: [
          TicTacToeBoard(board: board, onMove: moveX),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              gameStatus,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(onPressed: restartGame, child: const Text('Restart')),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
