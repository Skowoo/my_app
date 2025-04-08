import 'package:flutter/material.dart';
import 'package:my_app/src/logic/app_state.dart';
import 'package:my_app/src/logic/tic_tac_toe_game.dart';
import 'package:provider/provider.dart';
import '../widgets/tic_tac_toe_board.dart';

class SingleGame extends StatefulWidget {
  const SingleGame({super.key});

  @override
  SingleGameState createState() => SingleGameState();
}

class SingleGameState extends State<SingleGame> {
  String makeMoveText = 'Wykonaj swój ruch!';
  String waitingForOponentText = 'Czekam na ruch przeciwnika...';
  String board = '         ';
  late AppState state;
  late String gameStatusDescription = makeMoveText;
  bool isGameConcluded = false;
  bool waitingForOponent = false;

  void moveX(int index) {
    if (board[index] == ' ' && !isGameConcluded && !waitingForOponent) {
      setState(() {
        board = '${board.substring(0, index)}X${board.substring(index + 1)}';
        waitingForOponent = true;
        checkIfGameIsConcluded('X');
      });
    }
  }

  void makeAutoMove(String player) {
    Future.delayed(Duration(milliseconds: state.singleplayerBotDelay), () {
      setState(() {
        board = TicTacToeGame.makeMove(board, player);
        checkIfGameIsConcluded(player);
        waitingForOponent = false;
      });
    });
  }

  void checkIfGameIsConcluded(String player) {
    if (TicTacToeGame.checkWin(board, player)) {
      gameStatusDescription = player == 'X' ? 'Wygrana!' : 'Porażka!';
      isGameConcluded = true;
    } else if (TicTacToeGame.checkDraw(board)) {
      gameStatusDescription = 'Remis!';
      isGameConcluded = true;
    } else {
      gameStatusDescription =
          player == 'X' ? waitingForOponentText : makeMoveText;
      if (player == 'X') makeAutoMove('O');
    }
  }

  void restartGame() {
    setState(() {
      board = '         ';
      gameStatusDescription = makeMoveText;
      isGameConcluded = false;
      waitingForOponent = false;
    });
  }

  void finishGame() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
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
              gameStatusDescription,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 25),
          if (isGameConcluded)
            FilledButton.tonal(
              onPressed: restartGame,
              child: const Text('Następna gra!'),
            ),
        ],
      ),
    );
  }
}
