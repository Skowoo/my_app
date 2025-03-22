import 'package:flutter/material.dart';
import 'dart:math';

class SingleGame extends StatefulWidget {
  const SingleGame({super.key});

  @override
  SingleGameState createState() => SingleGameState();
}

class SingleGameState extends State<SingleGame> {
  List<String> board = List.filled(9, '');
  bool isX = true;
  String? gameResult;

  void handleCommand(int index) {
    if (board[index].isEmpty && gameResult == null) {
      setState(() {
        board[index] = 'X';
        if (checkWin('X')) {
          gameResult = 'Zwycięstwo!';
        } else if (!board.contains('')) {
          gameResult = 'Remis!';
        } else {
          makeAutoMove();
        }
      });
    }
  }

  void makeAutoMove() {
    var emptyIndexes = [
      for (int i = 0; i < board.length; i++)
        if (board[i].isEmpty) i,
    ];
    if (emptyIndexes.isNotEmpty) {
      int move = emptyIndexes[Random().nextInt(emptyIndexes.length)];
      setState(() {
        board[move] = 'O';
        if (checkWin('O')) {
          gameResult = 'Porażka!';
        } else if (!board.contains('')) {
          gameResult = 'Remis!';
        }
      });
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

  void restartGame() {
    setState(() {
      board = List.filled(9, '');
      gameResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('Gra jednoosobowa'), centerTitle: true),
      body: Column(
        children: [
          drawGameField(theme),
          drawReultInfoBar(),
          ElevatedButton(onPressed: restartGame, child: const Text('Restart')),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Expanded drawReultInfoBar() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            gameResult ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Padding gameResultInfoBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        gameResult ?? '',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container drawGameField(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => handleCommand(index),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    board[index],
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
