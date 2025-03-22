import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/app_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    if (appState.favorites.isEmpty) {
      return Center(child: Text('No favorites yet.'));
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'You have '
                '${appState.favorites.length} favorites:',
              ),
            ),
            for (var pair in appState.favorites)
              ListTile(leading: Icon(Icons.favorite), title: Text(pair)),
          ],
        ),
      ),
    );
  }
}
