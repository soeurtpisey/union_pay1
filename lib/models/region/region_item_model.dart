import 'dart:convert';
import '../../generated/json/base/json_field.dart';
import '../../generated/json/region_item_model.g.dart';

@JsonSerializable()
class RegionItemModel {
  String? item;
  int? id;


  RegionItemModel({this.item, this.id});


  factory RegionItemModel.fromJson(Map<String, dynamic> json) =>
      $RegionItemModelFromJson(json);

  Map<String, dynamic> toJson() => $RegionItemModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (other is! RegionItemModel) return false;
    var model = other;
    return (model.id == id);
  }

}
