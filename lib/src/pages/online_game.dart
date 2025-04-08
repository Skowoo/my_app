import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_app/src/helpers/signalr_helper.dart';
import 'package:my_app/src/helpers/api_helper.dart';
import 'package:my_app/src/logic/app_state.dart';
import 'package:my_app/src/logic/tic_tac_toe_game.dart';
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
  String makeMoveText = 'Wykonaj swój ruch!';
  String waitingForOponentText = 'Czekam na przeciwnika...';
  String board = '         ';
  bool moveSend = false;
  bool moveConfirmed = false;
  bool gameConcluded = false;
  late bool oponentMoveReceived = playerCharacter == 'O' ? true : false;
  late String gameStatusDescription =
      playerCharacter == 'O' ? makeMoveText : waitingForOponentText;
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
      gameStatusDescription = 'Wykonałeś ruch, oczekiwanie na serwer';
      await ApiHelper.sendMove(state, roomId, index, playerCharacter);
    }
  }

  void handleBoardUpdate(String boardState) {
    setState(() {
      if (moveSend) {
        moveSend = false;
        oponentMoveReceived = false;
        gameStatusDescription = waitingForOponentText;
      } else {
        oponentMoveReceived = true;
        gameStatusDescription = makeMoveText;
      }
      board = boardState;
      checkIfGameIsConcluded();
    });
  }

  void checkIfGameIsConcluded() {
    if (TicTacToeGame.checkWin(board, playerCharacter)) {
      gameConcluded = true;
      gameStatusDescription = 'Zwycięstwo!';
    } else if (TicTacToeGame.checkWin(board, opponentCharacter)) {
      gameConcluded = true;
      gameStatusDescription = 'Porażka!';
    } else if (TicTacToeGame.checkDraw(board)) {
      gameConcluded = true;
      gameStatusDescription = 'Remis!';
    }
  }

  void finishGame() {
    Navigator.pop(context);
  }

  Future<void> startNewOnlineGame() async {
    try {
      var response = await ApiHelper.getRandomRoomId(state);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => OnlineGame(
                roomId: response.roomId,
                playerCharacter: response.playerCharacter,
              ),
        ),
      );
    } on Exception catch (e) {
      log(e.toString());
    }
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
              'Twój znak to $playerCharacter',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              gameStatusDescription,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 25),
          if (gameConcluded)
            FilledButton.tonal(
              onPressed: startNewOnlineGame,
              child: const Text('Następna gra!'),
            ),
        ],
      ),
    );
  }
}
