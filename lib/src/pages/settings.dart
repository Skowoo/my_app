import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/app_state.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late AppState state;
  late TextEditingController _backendController;
  late TextEditingController _delayController;

  void saveSettings() {
    state.setBackendBaseUrl(_backendController.text);

    final newDelay = int.tryParse(_delayController.text);
    if (newDelay != null) {
      state.setSingleplayerBotDelay(newDelay);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Zapisano ustawienia')));

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    state = Provider.of<AppState>(context, listen: false);
    _backendController = TextEditingController(text: state.backendUrl);
    _delayController = TextEditingController(
      text: state.singleplayerBotDelay.toString(),
    );
  }

  @override
  void dispose() {
    _backendController.dispose();
    _delayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Adres bazowy backendu:'),
            TextField(controller: _backendController),
            const SizedBox(height: 40),
            const Text('Opóźnienie bota (w millisekundach):'),
            TextField(
              controller: _delayController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: saveSettings,
                child: const Text('Zapisz zmiany'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
