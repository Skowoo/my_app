import 'package:flutter/material.dart';
import 'package:my_app/src/logic/app_state.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../widgets/tic_tac_toe_board.dart';

class OnlineGame extends StatefulWidget {
  const OnlineGame({
    super.key,
    required this.roomId,
    required this.playerCharacter,
  });
  final String roomId;
  final String playerCharacter;

  @override
  OnlineGameState createState() => OnlineGameState();
}

class OnlineGameState extends State<OnlineGame> {
  List<String> board = List.filled(9, '');
  String gameStatus = 'Czekam na ruch';
  bool isGameOver = false;
  late String roomId;
  late String backendUrl;
  late String playerCharacter;

  @override
  void initState() {
    super.initState();
    roomId = widget.roomId;
    playerCharacter = widget.playerCharacter;
    backendUrl = Provider.of<AppState>(context, listen: false).backendRestUrl;
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gra online'), centerTitle: true),
      body: Column(
        children: [
          Text(
            'Room: [ $roomId ] on [ $backendUrl ] playing as [ $playerCharacter ]',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.red,
            ),
          ),
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
