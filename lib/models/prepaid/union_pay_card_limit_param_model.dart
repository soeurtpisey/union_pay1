import 'dart:convert';
import '../../generated/json/base/json_field.dart';
import '../../generated/json/union_pay_card_limit_param_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/24 10:56
/// @Description: 预付卡限额入参
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayCardLimitParamModel {
  //upay卡表主键id
  int? id;
  //消费日限额
  double? consumeDayMax;
  //消费日次数
  int? consumeDayMaxNum;
  //单笔消费限额
  double? consumeSingleMax;
  //提现日限额
  double? withdrawDayMax;
  //提现日次数
  int? withdrawDayMaxNum;
  //单笔提现限额
  double? withdrawSingleMax;

  UnionPayCardLimitParamModel();

  factory UnionPayCardLimitParamModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayCardLimitParamModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayCardLimitParamModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
