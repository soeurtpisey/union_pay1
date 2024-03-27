import 'dart:convert';
import 'package:union_pay/models/prepaid/enums/union_account_state.dart';
import 'package:union_pay/models/prepaid/enums/union_currency.dart';

import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_customer_res_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 19:21
/// @Description: 预付卡用户信息
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayCustomerResModel {
  //"全名 [长度最大50, 全都大写单词, 名字 - 姓名, 示例: DOE JOHN]
  String? name;

  //Account:00 正常  02 冻结 04销户
  //Card: 0:正常  1已挂失 2未激活 3已注销 5正在销卡(换卡专用)
  String? keyStatus;
  //0003 USD，0004 KHR
  String? prdtNo;

  UnionPayCustomerResModel();

  factory UnionPayCustomerResModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayCustomerResModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayCustomerResModelToJson(this);

  //账号的状态
  UnionAccountState getAccountStatus() {
    return UnionAccountStateValue.typeFromStr(keyStatus);
  }

  bool isSuccess() {
    if (isToAccount()) {
      return getAccountStatus() == UnionAccountState.NORMAL;
    } else {
      return getCardStatus() == UnionAccountState.NORMAL;
    }
  }

  UnionCurrency currency() {
    return UnionCurrencyValue.typeFromStr(prdtNo);
  }

  bool isToAccount() {
    return keyStatus?.length == 2;
  }

  //卡的状态
  UnionAccountState getCardStatus() {
    return UnionAccountStateValue.typeFromStr(keyStatus);
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
