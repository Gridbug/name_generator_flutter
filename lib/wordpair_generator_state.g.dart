// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wordpair_generator_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FancyName _$FancyNameFromJson(Map<String, dynamic> json) => FancyName(
      FancyName._wordpairFromJson(json['pair'] as List<String>),
      json['isFavorite'] as bool,
    );

Map<String, dynamic> _$FancyNameToJson(FancyName instance) => <String, dynamic>{
      'pair': FancyName._wordpairToJson(instance.pair),
      'isFavorite': instance.isFavorite,
    };
