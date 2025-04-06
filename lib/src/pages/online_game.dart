import 'package:flutter/material.dart';
import 'package:my_app/src/helpers/signalr_helper.dart';
import 'package:my_app/src/logic/app_state.dart';
import 'package:provider/provider.dart';
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
  late String backendWssUrl;
  late String playerCharacter;
  late final SignalRHelper signalR;

  @override
  void initState() {
    super.initState();
    roomId = widget.roomId;
    playerCharacter = widget.playerCharacter;
    backendWssUrl = Provider.of<AppState>(context, listen: false).backendUrl;

    signalR = SignalRHelper();
    signalR.connect(backendWssUrl, roomId, handleBoardUpdate);
  }

  void makeMove(int index) {
    if (board[index].isEmpty && !isGameOver) {
      setState(() {
        board[index] = playerCharacter;
        checkGameState(playerCharacter);
      });
    }
  }

  void checkGameState(String player) {
    if (checkWin(player)) {
      gameStatus = player == playerCharacter ? 'Wygrana!' : 'Porażka!';
      isGameOver = true;
    } else if (!board.contains('')) {
      gameStatus = 'Remis!';
      isGameOver = true;
    } else {
      gameStatus =
          player == playerCharacter
              ? 'Czekaj na ruch przeciwnika'
              : 'Czekam na ruch';
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

  void handleBoardUpdate(String boardState) {
    setState(() {
      board = boardState.split('');
      checkGameState(playerCharacter == 'X' ? 'O' : 'X');
    });
  }

  void finishGame() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    signalR.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gra online'), centerTitle: true),
      body: Column(
        children: [
          Text(
            'Room: [ $roomId ] on [ $backendWssUrl ] playing as [ $playerCharacter ]',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.red,
            ),
          ),
          TicTacToeBoard(board: board, onMove: makeMove),
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
