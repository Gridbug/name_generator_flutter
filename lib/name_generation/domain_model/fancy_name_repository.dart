import 'package:flutter_application_1/name_generation/domain_model/fancy_name.dart';

abstract class FancyNameRepository {
  FancyName generateNewName();

  List<FancyName> getHistory();

  List<FancyName> getFavoriteNames();

  bool toggleFavoriteStatus(final int fancyNameId);

  bool isFancyNameFavorite(final int fancyNameId);
}
