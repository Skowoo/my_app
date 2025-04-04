import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_app/src/helpers/api_helper.dart';
import 'package:my_app/src/logic/app_state.dart';
import 'package:my_app/src/pages/online_game.dart';
import 'package:provider/provider.dart';

class ChooseRoom extends StatefulWidget {
  const ChooseRoom({super.key});

  @override
  State<ChooseRoom> createState() => ChooseRoomState();
}

class ChooseRoomState extends State<ChooseRoom> {
  late AppState state;

  Future<void> chooseRandomRoom() async {
    try {
      var response = await ApiHelper.getRandomRoomId(state);
      _pushToRoom(response.roomId, response.playerCharacter);
    } on Exception catch (e) {
      log(e.toString());
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _pushToRoom(String roomId, String playerCharacter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                OnlineGame(roomId: roomId, playerCharacter: playerCharacter),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wybierz pokój'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () {
                chooseRandomRoom();
              },
              child: const Text('Wybierz losowy pokój'),
            ),
          ],
        ),
      ),
    );
  }
}
