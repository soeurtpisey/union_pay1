import 'dart:convert';
import 'package:union_pay/models/prepaid/enums/union_card_type.dart';

import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_card_config_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/19 15:04
/// @Description: 预付卡卡信息接口
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayCardConfigModel {
  //年费
  double? annualFee;

  //品牌ID [长度4位]:- 0002: 实体卡- 0003: 虚拟卡
  String? brandId;
  String? createTime;

  //消费日限额
  double? consumeDayMax;

  //消费日次数
  int? consumeDayMaxNum;

  //单笔消费限额
  double? consumeSingleMax;
  String? eMail;
  int? id;

  //发行费
  double? issueFee;

  //手机号
  String? phone;
  String? updateTime;

  //提现日限额
  double? withdrawDayMax;

  //提现日次数
  int? withdrawDayMaxNum;

  //单笔提现限额
  double? withdrawSingleMax;

  //有效期，单位：年
  int? validTime;

  //免年费字段
  int? noAnnualFeePeriod;

  bool isPay() {
    return payAmount() > 0;
  }

  double payAmount() {
    if ((noAnnualFeePeriod ?? 0) > 0) {
      return (issueFee ?? 0);
    } else {
      return (issueFee ?? 0) + (annualFee ?? 0);
    }
  }

  //卡的类型
  UnionCardType cardType() {
    return UnionCardTypeValue.typeFromStr(brandId);
  }

  UnionPayCardConfigModel();

  factory UnionPayCardConfigModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayCardConfigModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayCardConfigModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
