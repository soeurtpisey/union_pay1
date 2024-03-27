import 'dart:convert';
import '../../generated/json/base/json_field.dart';
import '../../generated/json/union_pay_top_param_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 19:21
/// @Description: 预付卡持卡充值请求参数
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayTopParamModel {
  //交易id
  @JSONField(name: 'trf_id')
  String? trfId;
  //充值金额
  double? amt;
  //upay卡表主键id
  int? id;

  String? currency;

  UnionPayTopParamModel();

  factory UnionPayTopParamModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayTopParamModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayTopParamModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
