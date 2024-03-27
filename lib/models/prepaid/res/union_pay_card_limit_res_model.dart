
import 'package:json_annotation/json_annotation.dart';
import '../../../generated/json/union_pay_card_limit_res_model.g.dart';

@JsonSerializable()
class UnionPayCardLimitResModel {
  String? cardBrhId;
  String? cardBrhNm;
  String? cardId4;
  //提现日限额
  String? consumeDayMax;
  //提现日次数
  String? consumeDayMaxNum;
  //单笔消费限额
  String? consumeSingleMax;

  //系统允许设置的最大消费日限额
  String? sysConsumeDayMax;
  //系统允许设置的最大消费日次数
  String? sysConsumeDayMaxNum;
  //系统允许设置的最大单笔消费限额
  String? sysConsumeSingleMax;

  //系统允许设置的最大提现日限额
  String? sysWithdrawDayMax;
  //系统允许设置的最大提现日次数
  String? sysWithdrawDayMaxNum;
  //系统允许设置的最大单笔提现限额
  String? sysWithdrawSingleMax;

  //提现日限额
  String? withdrawDayMax;
  //提现日次数
  String? withdrawDayMaxNum;
  //单笔提现限额
  String? withdrawSingleMax;

  UnionPayCardLimitResModel({
    this.cardBrhId,
    this.cardBrhNm,
    this.cardId4,
    this.consumeDayMax,
    this.consumeDayMaxNum,
    this.consumeSingleMax,
    this.sysConsumeDayMax,
    this.sysConsumeDayMaxNum,
    this.sysConsumeSingleMax,
    this.sysWithdrawDayMax,
    this.sysWithdrawDayMaxNum,
    this.sysWithdrawSingleMax,
    this.withdrawDayMax,
    this.withdrawDayMaxNum,
    this.withdrawSingleMax,
  });

  factory UnionPayCardLimitResModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayCardLimitResModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayCardLimitResModelToJson(this);
}
