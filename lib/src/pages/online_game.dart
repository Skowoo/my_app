import 'package:flutter/material.dart';
import 'package:my_app/src/helpers/signalr_helper.dart';
import 'package:my_app/src/helpers/api_helper.dart';
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
  String board = '         ';
  bool moveSend = false;
  bool moveConfirmed = false;
  bool gameConcluded = false;
  late bool oponentMoveReceived = playerCharacter == 'O' ? true : false;
  late String gameStatus =
      playerCharacter == 'O'
          ? 'Oczekiwanie na Twój ruch...'
          : 'Oczekiwanie na dołączenie przeciwnika...';
  late AppState state;
  late String roomId;
  late String playerCharacter;
  late String opponentCharacter = playerCharacter == 'O' ? 'X' : 'O';
  late final SignalRHelper signalR;

  @override
  void initState() {
    super.initState();
    roomId = widget.roomId;
    playerCharacter = widget.playerCharacter;
    state = Provider.of<AppState>(context, listen: false);
    signalR = SignalRHelper();
    signalR.connect(state.backendUrl, roomId, handleBoardUpdate);
  }

  Future<void> makeMove(int index) async {
    if (board[index] == ' ' &&
        !moveSend &&
        oponentMoveReceived &&
        !gameConcluded) {
      moveSend = true;
      gameStatus = 'Wykonałeś ruch, oczekiwanie na serwer';
      await ApiHelper.sendMove(state, roomId, index, playerCharacter);
    }
  }

  void handleBoardUpdate(String boardState) {
    setState(() {
      if (moveSend) {
        moveSend = false;
        oponentMoveReceived = false;
        gameStatus = 'Oczekiwanie na ruch przeciwnika...';
      } else {
        oponentMoveReceived = true;
        gameStatus = 'Oczekiwanie na Twój ruch...';
      }
      board = boardState;
      if (checkWin(playerCharacter)) {
        gameConcluded = true;
        gameStatus = 'Zwycięstwo!';
      } else if (checkWin(opponentCharacter)) {
        gameConcluded = true;
        gameStatus = 'Porażka!';
      }
    });
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
          TicTacToeBoard(board: board, onMove: makeMove),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Grasz jako $playerCharacter',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              gameStatus,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
