import 'dart:convert';
import 'package:union_pay/res/images_res.dart';
import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_template_model.g.dart';

@JsonSerializable()
class UnionPayTemplateModel {
  String? createTime;
  int? cusId;
  int? id;
  String? keyId;
  int? keyIdType;
  String? name;

  String? updateTime;

  String getIcon() {
    return ImagesRes.IC_PREPAID_UNIONPAY_BIG;
  }

  UnionPayTemplateModel();

  factory UnionPayTemplateModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayTemplateModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayTemplateModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  bool operator ==(Object other) {
    if (other is! UnionPayTemplateModel) return false;
    var model = other;
    // print("${model.id}      ${id}");
    return (model.id == id);
  }
}
