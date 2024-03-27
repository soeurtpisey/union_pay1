import 'dart:convert';
import '../../generated/json/base/json_field.dart';
import '../../generated/json/union_pay_card_active_param_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 15:04
/// @Description: 预付卡卡激活入参
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayCardActiveParamModel {
  //卡表主键
  String? id;
  //卡号 必填
  String? cardId;
  //卡CVV [3 位数] 选填
  String? cvn2;
  //卡有效期 [格式: yyyyMMdd]
  String? endDate;
  //卡 ATM 新密码 [6位数] 必填
  String? newPin;
  //证件号 [长度最大32]
  String? pidNo;
  //证件类型: 01-身份证，02-护照
  int? pidType;

  UnionPayCardActiveParamModel();

  factory UnionPayCardActiveParamModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayCardActiveParamModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayCardActiveParamModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
