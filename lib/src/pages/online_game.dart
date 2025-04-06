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
  String gameStatus = 'Status gry';
  bool isGameOver = false;
  late AppState state;
  late String roomId;
  late String playerCharacter;
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
    if (board[index] == ' ') {
      await ApiHelper.sendMove(state, roomId, index, playerCharacter);
    }
  }

  void handleBoardUpdate(String boardState) {
    setState(() {
      board = boardState;
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
