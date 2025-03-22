import 'package:flutter/material.dart';

class TicTacToeBoard extends StatelessWidget {
  final List<String> board;
  final Function(int) onMove;

  const TicTacToeBoard({super.key, required this.board, required this.onMove});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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
              onTap: () => onMove(index),
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
