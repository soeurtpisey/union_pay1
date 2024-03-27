import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:union_pay/extensions/string_extension.dart';
import 'package:union_pay/models/prepaid/enums/union_card_state.dart';
import 'package:union_pay/models/prepaid/enums/union_card_type.dart';
import 'package:union_pay/res/images_res.dart';
import '../../../app/config/app_config.dart';
import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_card_res_model.g.dart';
import '../../../generated/l10n.dart';
import '../../../helper/colors.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/19 15:04
/// @Description: 预付卡卡信息接口
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayCardResModel {
  //账户余额
  double? accountAmount;

  //可用余额
  double? availableAmount;

  //账号
  String? blAccountId;

  //账户状态:- 00: 正常- 02: 冻结- 04: 销户
  String? blAccountStatus;

  //bong loy 系统客户id
  String? blCustId;

  //品牌ID [长度4位]:- 0014: 实体卡- 0013: 虚拟卡"
  String? brandId;

  //银联卡号：PAN（16 位
  String? cardId;

  String? getCardBankFormat() {
    if (cardId != 'U-PAY') {
      return cardId?.formatBankCard();
    } else {
      return cardId ?? '';
    }
  }

  //卡号后4位数
  String? cardId4;

  //卡状态：0-正常, 1-已冻结, 2-未激活, 3-已注销, 5-正在销卡 [换卡专用]"
  int? cardStatus;

  //消费日限额
  double? consumeDayMax;

  //消费日次数
  int? consumeDayMaxNum;

  //单笔消费限额
  double? consumeSingleMax;

  //创建时间
  String? createTime;

  //银联卡申请id
  int? cucaId;

  //账户类型:- 0003: 美元- 0004: 瑞尔
  String? currencyType;

  //用户id
  int? cusId;

  //卡CVV [3 位数]
  String? cvn2;

  //卡有效期 [格式: yyyyMMdd]
  String? endDate;

  //bong loy系统卡号映射id
  String? extCardId;

  //主键id
  int? id;

  //冻结余额
  double? lockAmount;

  //起始时间:[格式: yyyyMMdd]
  String? startDate;

  //更新时间
  String? updateTime;

  //"开通移动支付状态:- 0: 未开通- 1: 已开通"
  String? upiStatus;

  //提现日限额
  double? withdrawDayMax;

  //提现日次数
  int? withdrawDayMaxNum;

  //单笔提现限额
  double? withdrawSingleMax;

  //账户名
  String? accountName;

  //持卡人姓名
  String? cardCusName;

  UnionPayCardResModel();

  String currency() {
    return currencyType == '0003' ? 'USD' : 'KHR';
  }

  // String getAvailableBalance() {
  //   if (cardId != 'U-PAY') {
  //     return '${availableAmount.toString().formatCurrency()} ${currency()}';
  //   } else {
  //     return Application.balance.value.getUsdAccount()?.getBalance() ?? '';
  //   }
  // }

  // bool isInsufficient(double amount){
  //   double? balance;
  //   if (cardId != 'U-PAY') {
  //     balance= availableAmount;
  //   } else {
  //     balance= Application.balance.value.getUsdAccount()?.balance;
  //   }
  //   if(balance==0||balance==null){
  //     return false;
  //   }
  //   return (balance??0)>=amount;
  // }

  String getCardUI() {
    if (Env.appEnv == EnvName.prod) {
      if (brandId == '0006') {
        return ImagesRes.IC_PREPAID_CARD;
      }
    }
    if (cardType() == UnionCardType.virtualCard) {
      return ImagesRes.ICON_PREPAID_VIRTUAL_V2;
    } else {
      return ImagesRes.IC_PREPAID_PHYSICAL;
    }
  }

  Color getCardTextColor() {
    if (Env.appEnv == EnvName.prod) {
      if (brandId == '0006') {
        return AppColors.colorE3C26E;
      }
    }

    return AppColors.colorC0C0C0;
    // return Colors.white;
  }

  //账户名
  String getAccountName() {
    if(accountName?.isNotEmpty==true){
      return accountName??'';
    }else{
      return cardCusName??'';
    }
  }

  //银行卡
  String cardNumber() {
    return cardId?.formatBankCard() ?? '';
  }

  String endDateMonth() {
    return endDate?.substring(4, 6) ?? '';
  }

  String endDateYear() {
    return endDate?.substring(2, 4) ?? '';
  }

  //银行卡
  List<String> cardNumberSplit() {
    var bankCard = cardId?.formatBankCard() ?? '';
    return bankCard.split(' ');
  }

  //卡的类型
  UnionCardType cardType() {
    return UnionCardTypeValue.typeFromStr(brandId);
  }

  //卡状态类型
  UnionCardState cardState() {
    // return UnionCardState.INACTIVATED;
    return UnionCardStateValue.typeFromStr(cardStatus.toString());
  }

  bool isFrozen(){
    return UnionCardState.FREEZE==cardState();
  }

  bool isVirtual() {
    return cardType() == UnionCardType.virtualCard;
  }

  String cardTypeTitle() {
    return cardType() == UnionCardType.virtualCard
        ? S.current.unionpay_virtual_card
        : S.current.ic_card;
  }

  bool hasCard() {
    var state = cardState();
    return state == UnionCardState.FREEZE || state == UnionCardState.NORMAL;
    // return false;
  }

  factory UnionPayCardResModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayCardResModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayCardResModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  bool operator ==(Object other) {
    if (other is! UnionPayCardResModel) return false;
    var model = other;
    // print("${model.id}      ${id}");
    return (model.id == id);
  }
}
