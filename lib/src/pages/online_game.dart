import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/tic_tac_toe_board.dart';

class OnlineGame extends StatefulWidget {
  const OnlineGame({super.key, required this.roomId});
  final String roomId;

  @override
  OnlineGameState createState() => OnlineGameState();
}

class OnlineGameState extends State<OnlineGame> {
  List<String> board = List.filled(9, '');
  String gameStatus = 'Czekam na ruch';
  bool isGameOver = false;
  late String roomId;

  @override
  void initState() {
    super.initState();
    roomId = widget.roomId;
  }

  void moveX(int index) {
    if (board[index].isEmpty && !isGameOver) {
      setState(() {
        board[index] = 'X';
        checkGameState('X');
      });
    }
  }

  void moveO(int index) {
    if (board[index].isEmpty && !isGameOver) {
      setState(() {
        board[index] = 'O';
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
        if (board[i].isEmpty) i,
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

  void finishGame() {
    setState(() {
      board = List.filled(9, '');
      gameStatus = 'Czekam na ruch';
      isGameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gra online: $roomId'), centerTitle: true),
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
          ElevatedButton(
            onPressed: finishGame,
            child: const Text('Zakończ grę'),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
