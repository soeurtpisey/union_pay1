import 'dart:convert';
import '../../generated/json/base/json_field.dart';
import '../../generated/json/union_pay_transfer_param_model.g.dart';
import 'package:union_pay/models/prepaid/enums/union_currency.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 19:21
/// @Description: 预付卡转账请求参数
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayTransferParamModel {
  //交易id
  @JSONField(name: 'trf_id')
  String? trfId;
  //转账金额
  double? amt;
  //upay卡表主键id
  int? id;
  //转入卡号/账户号
  String? keyIdIN;
  //转入类型- 0: 卡号- 1: 账户号
  int? keyIdINType;

  //转账币种
  String? prdtNoIN;

  String? name;

  UnionCurrency currency() {
    return UnionCurrencyValue.typeFromStr(prdtNoIN);
  }

  UnionPayTransferParamModel();

  factory UnionPayTransferParamModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayTransferParamModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayTransferParamModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
