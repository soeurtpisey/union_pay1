import 'dart:convert';
import '../../generated/json/base/json_field.dart';
import '../../generated/json/union_pay_custom_param_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 19:21
/// @Description: 预付卡持卡用户请求参数
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayCustomParamModel {
  //卡/账号 [长度1-20]
  String? keyId;

  UnionPayCustomParamModel();

  factory UnionPayCustomParamModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayCustomParamModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayCustomParamModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
