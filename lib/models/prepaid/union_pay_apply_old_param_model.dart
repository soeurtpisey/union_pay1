import 'dart:convert';
import 'package:union_pay/models/prepaid/enums/union_card_type.dart';

import '../../generated/json/base/json_field.dart';
import '../../generated/json/union_pay_apply_old_param_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 15:04
/// @Description: 预付卡老客户申请入参
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayApplyOldParamModel {
  //品牌ID [长度4位]:- 0002: 实体卡- 0003: 虚拟卡
  String? brandId;
  //证件号 [长度最大32]
  String? pidNo;
  //证件类型: 01-身份证，02-护照
  String? pidType;

  UnionPayApplyOldParamModel();

  //卡的类型
  UnionCardType cardType() {
    return UnionCardTypeValue.typeFromStr(brandId);
  }


  bool isVirtual() {
    return cardType() == UnionCardType.virtualCard;
  }

  factory UnionPayApplyOldParamModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayApplyOldParamModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayApplyOldParamModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
