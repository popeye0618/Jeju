import 'package:freezed_annotation/freezed_annotation.dart';

part 'autocomplete_item.freezed.dart';
part 'autocomplete_item.g.dart';

@freezed
class AutocompleteItem with _$AutocompleteItem {
  const factory AutocompleteItem({
    required int id,
    required String name,
    required String category,
  }) = _AutocompleteItem;

  factory AutocompleteItem.fromJson(Map<String, dynamic> json) =>
      _$AutocompleteItemFromJson(json);
}
