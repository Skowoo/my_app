import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _backendBaseUrl = 'http://10.0.2.2:5028';

  String get backendUrl => _backendBaseUrl;

  void setBackendBaseUrl(String url) {
    _backendBaseUrl = url;
    notifyListeners();
  }
}
