import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _backendUrl = 'placeholder';

  String get backendUrl => _backendUrl;

  void setBackendUrl(String url) {
    _backendUrl = url;
    notifyListeners();
  }
}
