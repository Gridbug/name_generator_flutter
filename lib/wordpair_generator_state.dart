import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class WordPairGeneratorState extends ChangeNotifier {
  WordPair current = WordPair.random();
  bool currentIsFavorite = false;

  List<WordPair> favoritePairs = [];

  List<WordPair> history = [];
  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);

    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);

    current = WordPair.random();
    currentIsFavorite = false;

    notifyListeners();
  }

  void toggleCurrentFavoriteStatus() {
    if (currentIsFavorite) {
      favoritePairs.remove(current);
    } else {
      favoritePairs.add(current);
    }

    currentIsFavorite = !currentIsFavorite;

    notifyListeners();
  }

  void toggleHistoryFavoriteStatus() {}

  bool isCurrentFavorite() {
    return currentIsFavorite;
  }

  void removeFromFavorites(final int id) {
    if (favoritePairs[id] == current && currentIsFavorite) {
      currentIsFavorite = false;
    }

    favoritePairs.removeAt(id);
    notifyListeners();
  }
}
