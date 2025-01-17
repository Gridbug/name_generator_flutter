import 'package:english_words/english_words.dart';
import 'package:flutter_application_1/name_generation/domain_model/fancy_name.dart';
import 'package:flutter_application_1/name_generation/domain_model/fancy_name_repository.dart';

class FancyNameMemoryRepository extends FancyNameRepository {
  List<FancyName> _namesHistory = [];
  int _nextObjectId = 1;

  @override
  List<FancyName> getFavoriteNames() {
    return _namesHistory.where((name) => name.isFavorite).toList();
  }

  @override
  FancyName generateNewName() {
    final newGeneratedName = FancyName(_nextObjectId, WordPair.random(), false);
    _nextObjectId++;

    _namesHistory.insert(0, newGeneratedName);

    return newGeneratedName;
  }

  @override
  bool toggleFavoriteStatus(int fancyNameId) {
    try {
      FancyName name =
          _namesHistory.firstWhere((name) => name.id == fancyNameId);
      name.isFavorite = !name.isFavorite;
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  List<FancyName> getHistory() {
    return _namesHistory;
  }

  @override
  bool isFancyNameFavorite(int fancyNameId) {
    try {
      final fancyName =
          _namesHistory.firstWhere((name) => name.id == fancyNameId);
      return fancyName.isFavorite;
    } catch (e) {
      return false;
    }
  }

  @override
  bool setFavoriteStatus(int fancyNameId, bool newFavoriteStatus) {
    try {
      FancyName name =
          _namesHistory.firstWhere((name) => name.id == fancyNameId);

      name.isFavorite = newFavoriteStatus;

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  FancyName? getBy({required int id}) {
    try {
      FancyName name = _namesHistory.firstWhere((name) => name.id == id);

      return name;
    } catch (e) {
      return null;
    }
  }
}
