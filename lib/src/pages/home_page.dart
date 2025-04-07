import 'package:flutter/material.dart';
import 'package:my_app/src/helpers/api_helper.dart';
import 'package:my_app/src/logic/app_state.dart';
import 'package:my_app/src/pages/online_game.dart';
import 'package:my_app/src/pages/settings.dart';
import 'package:my_app/src/pages/single_game.dart';
import 'dart:developer';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AppState state;

  goToSingleplayer() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SingleGame()),
    );
  }

  goToMultiplayer() async {
    try {
      var response = await ApiHelper.getRandomRoomId(state);
      if (!mounted) return;
      Navigator.push(
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

  goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Settings()),
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
      appBar: AppBar(title: const Text('Menu główne'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: goToSingleplayer,
              child: const Text('Jeden gracz'),
            ),
            SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: goToMultiplayer,
              child: const Text('Gra online'),
            ),
            SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: goToSettings,
              child: const Text('Ustawienia'),
            ),
          ],
        ),
      ),
    );
  }
}
