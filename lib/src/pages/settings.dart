import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/app_state.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Adres backendu:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: TextEditingController(text: appState.backendUrl),
              decoration: const InputDecoration(
                hintText: 'Wpisz adres backendu',
              ),
              onChanged: (value) => appState.setBackendUrl(value),
            ),
          ],
        ),
      ),
    );
  }
}
