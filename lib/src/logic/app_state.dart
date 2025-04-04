import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _backendBaseUrl = '10.0.2.2:5028';

  String get backendBaseUrl => _backendBaseUrl;
  String get backendRestUrl => 'http://$_backendBaseUrl';
  String get backendWssUrl => 'wss://$_backendBaseUrl/tictactoe';

  void setBackendBaseUrl(String url) {
    _backendBaseUrl = url;
    notifyListeners();
  }
}
