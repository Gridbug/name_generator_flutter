import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/name_generation/domain_model/fancy_name.dart';
import 'package:flutter_application_1/name_generation/domain_model/fancy_name_repository.dart';

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class WordPairGeneratorState extends ChangeNotifier {
  final FancyNameRepository fancyNameRepository;

  FancyName current;

  GlobalKey favoritesListKey = GlobalKey();
  RemovedItemBuilder<WordPair>? removedItemBuilder;

  GlobalKey historyListKey = GlobalKey();

  WordPairGeneratorState(this.fancyNameRepository)
      : current = fancyNameRepository.generateNewName();

  void getNext() {
    current = fancyNameRepository.generateNewName();

    var animatedHistoryList = historyListKey.currentState as AnimatedListState?;
    animatedHistoryList?.insertItem(0);

    notifyListeners();
  }

  List<FancyName> getFancyNamesHistory() {
    return fancyNameRepository.getHistory();
  }

  List<FancyName> getFavoriteFancyNames() {
    return fancyNameRepository.getFavoriteNames();
  }

  void toggleCurrentFavoriteStatus() {
    var animatedFavoritesList =
        favoritesListKey.currentState as AnimatedListState?;

    if (fancyNameRepository.isFancyNameFavorite(current.id)) {
      if (removedItemBuilder != null) {
        animatedFavoritesList?.removeItem(
          fancyNameRepository.getFavoriteNames().length - 1,
          (BuildContext context, Animation<double> animation) {
            return removedItemBuilder!(current.pair, context, animation);
          },
        );
      } else {
        //Process the error, maybe :)
      }
    } else {
      animatedFavoritesList
          ?.insertItem(fancyNameRepository.getFavoriteNames().length - 1);
    }

    fancyNameRepository.toggleFavoriteStatus(current.id);

    notifyListeners();
  }

  void toggleHistoryPairFavoriteStatus(final int fancyNameId) {
    fancyNameRepository.toggleFavoriteStatus(fancyNameId);

    notifyListeners();
  }

  bool isCurrentFavorite() {
    return fancyNameRepository.isFancyNameFavorite(current.id);
  }

  bool isFancyNameFavorite(int fancyNameId) {
    return fancyNameRepository.isFancyNameFavorite(fancyNameId);
  }

  void removeFromFavorites(final int favoritePairId) {
    var animatedList = favoritesListKey.currentState as AnimatedListState?;

    final removedFancyName = fancyNameRepository
        .getFavoriteNames()
        .firstWhere((name) => name.id == favoritePairId);

    final removedItemPositionalIndex =
        fancyNameRepository.getFavoriteNames().indexOf(removedFancyName);

    if (removedItemBuilder != null) {
      animatedList?.removeItem(
        removedItemPositionalIndex,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder!(removedFancyName.pair, context, animation);
        },
      );
    } else {
      //Process the error, maybe :)
    }

    notifyListeners();
  }
}
