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
    final fullHistory = fancyNameRepository.getHistory();

    return fullHistory.getRange(1, fullHistory.length).toList();
  }

  List<FancyName> getFavoriteFancyNames() {
    return fancyNameRepository.getFavoriteNames();
  }

  void toggleCurrentFavoriteStatus() {
    var animatedFavoritesList =
        favoritesListKey.currentState as AnimatedListState?;

    bool wasFavorite = fancyNameRepository.isFancyNameFavorite(current.id);

    fancyNameRepository.toggleFavoriteStatus(current.id);

    if (wasFavorite) {
      if (removedItemBuilder != null) {
        animatedFavoritesList?.removeItem(
          fancyNameRepository.getFavoriteNames().length - 1,
          (BuildContext context, Animation<double> animation) {
            return removedItemBuilder!(current.pair, context, animation);
          },
        );
      } else {
        //TODO: Process the error, maybe :)
      }
    } else {
      animatedFavoritesList
          ?.insertItem(fancyNameRepository.getFavoriteNames().length - 1);
    }

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

  void removeFromFavorites(final int fancyNameId) {
    final FancyName? targetFancyName =
        fancyNameRepository.getBy(id: fancyNameId);

    if (targetFancyName == null) {
      return;
    }

    final removedItemPositionalIndex =
        fancyNameRepository.getFavoriteNames().indexOf(targetFancyName);

    if (removedItemPositionalIndex < 0) {
      //TODO: Maybe handle the error?)
      return;
    }

    fancyNameRepository.setFavoriteStatus(fancyNameId, false);

    var animatedList = favoritesListKey.currentState as AnimatedListState?;

    if (removedItemBuilder != null) {
      animatedList?.removeItem(
        removedItemPositionalIndex,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder!(targetFancyName.pair, context, animation);
        },
      );
    } else {
      //Process the error, maybe :)
    }

    notifyListeners();
  }
}
