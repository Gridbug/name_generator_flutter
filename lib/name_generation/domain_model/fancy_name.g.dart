// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fancy_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FancyName _$FancyNameFromJson(Map<String, dynamic> json) => FancyName(
      (json['id'] as num).toInt(),
      FancyName._wordpairFromJson(json['pair'] as List<String>),
      json['isFavorite'] as bool,
    );

Map<String, dynamic> _$FancyNameToJson(FancyName instance) => <String, dynamic>{
      'id': instance.id,
      'pair': FancyName._wordpairToJson(instance.pair),
      'isFavorite': instance.isFavorite,
    };
