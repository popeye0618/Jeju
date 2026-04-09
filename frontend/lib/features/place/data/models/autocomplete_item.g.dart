// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autocomplete_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AutocompleteItemImpl _$$AutocompleteItemImplFromJson(
        Map<String, dynamic> json) =>
    _$AutocompleteItemImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$$AutocompleteItemImplToJson(
        _$AutocompleteItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
    };
