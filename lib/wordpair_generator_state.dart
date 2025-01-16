import 'dart:collection';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wordpair_generator_state.g.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

@JsonSerializable()
class FancyName {
  @JsonKey(
    toJson: _wordpairToJson,
    fromJson: _wordpairFromJson,
  )
  final WordPair pair;

  final bool isFavorite;

  FancyName(this.pair, this.isFavorite);

  static List<String> _wordpairToJson(final WordPair pair) =>
      [pair.first, pair.second];
  static WordPair _wordpairFromJson(final List<String> json) =>
      WordPair(json.first, json.last);
}

class WordPairGeneratorState extends ChangeNotifier {
  WordPair current = WordPair.random();
  bool currentIsFavorite = false;

  List<WordPair> favoriteWordpairsRepository = [];

  List<WordPair> wordpairsHistoryRepository = [];

  GlobalKey favoritesListKey = GlobalKey();
  RemovedItemBuilder<WordPair>? removedItemBuilder;

  HashMap<int, int> favoriteIdByHistoryId = HashMap();
  GlobalKey historyListKey = GlobalKey();

  void getNext() {
    wordpairsHistoryRepository.insert(0, current);

    var animatedList = historyListKey.currentState as AnimatedListState?;
    animatedList?.insertItem(0);

    HashMap<int, int> newMap = HashMap();
    for (final key in favoriteIdByHistoryId.keys) {
      newMap[key + 1] = favoriteIdByHistoryId[key]!;
    }
    favoriteIdByHistoryId = newMap;

    if (currentIsFavorite) {
      favoriteIdByHistoryId[0] = favoriteWordpairsRepository.length - 1;
    }

    current = WordPair.random();
    currentIsFavorite = false;

    notifyListeners();
  }

  void toggleCurrentFavoriteStatus() {
    var animatedFavoritesList =
        favoritesListKey.currentState as AnimatedListState?;

    if (currentIsFavorite) {
      favoriteWordpairsRepository.remove(current);

      if (removedItemBuilder != null) {
        animatedFavoritesList?.removeItem(
          favoriteWordpairsRepository.length - 1,
          (BuildContext context, Animation<double> animation) {
            return removedItemBuilder!(current, context, animation);
          },
        );
      } else {
        //Process the error, maybe :)
      }
    } else {
      favoriteWordpairsRepository.add(current);

      animatedFavoritesList?.insertItem(favoriteWordpairsRepository.length - 1);
    }

    currentIsFavorite = !currentIsFavorite;

    notifyListeners();
  }

  void toggleHistoryPairFavoriteStatus(final int historyPairId) {
    if (favoriteIdByHistoryId.containsKey(historyPairId)) {
      final int favoriteId = favoriteIdByHistoryId[historyPairId]!;

      favoriteWordpairsRepository.removeAt(favoriteId);
      favoriteIdByHistoryId.remove(historyPairId);

      if (favoriteId < favoriteWordpairsRepository.length) {
        for (final key in favoriteIdByHistoryId.keys) {
          if (favoriteIdByHistoryId[key]! > favoriteId) {
            favoriteIdByHistoryId[key] = favoriteIdByHistoryId[key]! - 1;
          }
        }
      }
    } else {
      favoriteWordpairsRepository
          .add(wordpairsHistoryRepository[historyPairId]);
      favoriteIdByHistoryId[historyPairId] =
          favoriteWordpairsRepository.length - 1;
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
    if (favoriteWordpairsRepository[favoritePairId] == current &&
        currentIsFavorite) {
      currentIsFavorite = false;
    }

    final removedWordPair =
        favoriteWordpairsRepository.removeAt(favoritePairId);

    var animatedList = favoritesListKey.currentState as AnimatedListState?;

    if (removedItemBuilder != null) {
      animatedList?.removeItem(
        favoritePairId,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder!(removedWordPair, context, animation);
        },
      );
    } else {
      //Process the error, maybe :)
    }

    favoriteIdByHistoryId.removeWhere((k, v) => v == favoritePairId);

    if (favoritePairId < favoriteWordpairsRepository.length) {
      for (final key in favoriteIdByHistoryId.keys) {
        if (favoriteIdByHistoryId[key]! > favoritePairId) {
          favoriteIdByHistoryId[key] = favoriteIdByHistoryId[key]! - 1;
        }
      }
    }

    notifyListeners();
  }
}
