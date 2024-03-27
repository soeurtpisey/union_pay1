import 'dart:convert';
import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_top_res_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 19:21
/// @Description: 预付卡充值res
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayTopResModel {
  //金额 [单位分, 大小1-2147483646]
  String? amt;
  //充值工单号
  String? rechargeId;
  //总手续费
  String? totFee;

  UnionPayTopResModel();

  factory UnionPayTopResModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayTopResModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayTopResModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
