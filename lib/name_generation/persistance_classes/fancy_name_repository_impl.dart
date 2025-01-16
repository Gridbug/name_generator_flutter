import 'package:english_words/english_words.dart';
import 'package:flutter_application_1/name_generation/domain_model/fancy_name.dart';
import 'package:flutter_application_1/name_generation/domain_model/fancy_name_repository.dart';

class FancyNameMemoryRepository extends FancyNameRepository {
  List<FancyName> _namesHistory = [];
  int _nextObjectId = 1;
  FancyName? _lastGeneratedName;

  @override
  List<FancyName> getFavoriteNames() {
    return _namesHistory.where((name) => name.isFavorite).toList();
  }

  @override
  FancyName generateNewName() {
    if (_lastGeneratedName != null) {
      _namesHistory.add(_lastGeneratedName!);
    }

    _lastGeneratedName = FancyName(_nextObjectId, WordPair.random(), false);
    _nextObjectId++;

    return _lastGeneratedName!;
  }

  @override
  bool toggleFavoriteStatus(int fancyNameId) {
    FancyName name = _namesHistory.firstWhere((name) => name.id == fancyNameId);
    name.isFavorite = !name.isFavorite;

    return true;
  }

  @override
  List<FancyName> getHistory() {
    if (_namesHistory.length <= 1) {
      return [];
    }

    return _namesHistory.getRange(1, _namesHistory.length).toList();
  }

  @override
  bool isFancyNameFavorite(int fancyNameId) {
    if (_lastGeneratedName == null) {
      return false;
    }
    if (_namesHistory.isEmpty) {
      return false;
    }

    FancyName fancyName;
    try {
      fancyName = _namesHistory.firstWhere((name) => name.id == fancyNameId);
    } catch (e) {
      return false;
    }

    return fancyName.isFavorite;
  }
}
