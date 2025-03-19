import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  var current = WordPair.random().asLowerCase;

  void getNext() {
    current = WordPair.random().asLowerCase;
    notifyListeners();
  }

  var favorites = <String>{};

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
