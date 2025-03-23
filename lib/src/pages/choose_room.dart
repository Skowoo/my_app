import 'package:flutter/material.dart';
import 'package:my_app/src/pages/online_game.dart';

class ChooseRoom extends StatefulWidget {
  const ChooseRoom({super.key});

  @override
  State<ChooseRoom> createState() => ChooseRoomState();
}

class ChooseRoomState extends State<ChooseRoom> {
  void chooseRandomRoom() {
    String roomId = "random";
    _pushToRoom(roomId);
  }

  void createNewRoom() {
    String roomId = "new";
    _pushToRoom(roomId);
  }

  void _pushToRoom(String roomId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OnlineGame(roomId: roomId)),
    );
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
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () {
                createNewRoom();
              },
              child: const Text('Stwórz nowy pokój'),
            ),
          ],
        ),
      ),
    );
  }
}
