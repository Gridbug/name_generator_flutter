import 'package:english_words/english_words.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fancy_name.g.dart';

@JsonSerializable()
class FancyName {
  int id;

  @JsonKey(
    toJson: _wordpairToJson,
    fromJson: _wordpairFromJson,
  )
  WordPair pair;

  bool isFavorite;

  FancyName(this.id, this.pair, this.isFavorite);

  factory FancyName.fromJson(Map<String, dynamic> json) =>
      _$FancyNameFromJson(json);

  Map<String, dynamic> toJson() => _$FancyNameToJson(this);

  static List<String> _wordpairToJson(final WordPair pair) =>
      [pair.first, pair.second];
  static WordPair _wordpairFromJson(final List<String> json) =>
      WordPair(json.first, json.last);
}
