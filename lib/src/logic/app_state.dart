import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _backendBaseUrl = 'http://10.0.2.2:5028';
  int _singleplayerBotDelay = 500;

  String get backendUrl => _backendBaseUrl;
  int get singleplayerBotDelay => _singleplayerBotDelay;

  void setBackendBaseUrl(String url) {
    _backendBaseUrl = url;
    notifyListeners();
  }

  void setSingleplayerBotDelay(int value) {
    _singleplayerBotDelay = value;
    notifyListeners();
  }
}
