import 'dart:collection';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class WordPairGeneratorState extends ChangeNotifier {
  WordPair current = WordPair.random();
  bool currentIsFavorite = false;

  List<WordPair> favoritePairs = [];

  List<WordPair> history = [];
  HashMap<int, int> favoriteIdByHistoryId = HashMap();
  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);

    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);

    HashMap<int, int> newMap = HashMap();

    for (final key in favoriteIdByHistoryId.keys) {
      newMap[key + 1] = favoriteIdByHistoryId[key]!;
    }

    favoriteIdByHistoryId = newMap;

    if (currentIsFavorite) {
      favoriteIdByHistoryId[0] = favoritePairs.length - 1;
    }

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

  void toggleHistoryPairFavoriteStatus(final int historyPairId) {
    if (favoriteIdByHistoryId.containsKey(historyPairId)) {
      final int favoriteId = favoriteIdByHistoryId[historyPairId]!;

      favoritePairs.removeAt(favoriteId);
      favoriteIdByHistoryId.remove(historyPairId);

      if (favoriteId < favoritePairs.length) {
        for (final key in favoriteIdByHistoryId.keys) {
          if (favoriteIdByHistoryId[key]! > favoriteId) {
            favoriteIdByHistoryId[key] = favoriteIdByHistoryId[key]! - 1;
          }
        }
      }
    } else {
      favoritePairs.add(history[historyPairId]);
      favoriteIdByHistoryId[historyPairId] = favoritePairs.length - 1;
    }

    notifyListeners();
  }

  bool isCurrentFavorite() {
    return currentIsFavorite;
  }

  bool isHistoryPairFavorite(int historyPairId) {
    return favoriteIdByHistoryId.containsKey(historyPairId);
  }

  void removeFromFavorites(final int favoritePairId) {
    if (favoritePairs[favoritePairId] == current && currentIsFavorite) {
      currentIsFavorite = false;
    }

    favoritePairs.removeAt(favoritePairId);

    favoriteIdByHistoryId.removeWhere((k, v) => v == favoritePairId);

    if (favoritePairId < favoritePairs.length) {
      for (final key in favoriteIdByHistoryId.keys) {
        if (favoriteIdByHistoryId[key]! > favoritePairId) {
          favoriteIdByHistoryId[key] = favoriteIdByHistoryId[key]! - 1;
        }
      }
    }

    notifyListeners();
  }
}
