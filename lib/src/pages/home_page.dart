import 'package:flutter/material.dart';
import 'package:my_app/src/pages/choose_room.dart';
import 'package:my_app/src/pages/single_game.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SingleGame()),
                );
              },
              child: const Text('Jeden gracz'),
            ),
            SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChooseRoom()),
                );
              },
              child: const Text('Gra online'),
            ),
          ],
        ),
      ),
    );
  }
}
