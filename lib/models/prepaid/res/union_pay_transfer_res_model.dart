import 'dart:convert';
import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_transfer_res_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 19:21
/// @Description: 预付卡转账res
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayTransferResModel {
  //转入账号ID
  String? acctIdIN;
  //转出账号ID
  String? acctIdOUT;
  //转入账号姓名
  String? acctNmIN;
  //转出账号姓名
  String? acctNmOUT;
  //转入发卡机构号
  String? cardBrhIdIN;
  //转出发卡机构号
  String? cardBrhIdOUT;
  //转入卡机构名称
  String? cardBrhNmIN;
  //转出卡机构名称
  String? cardBrhNmOUT;
  //转入卡号后4
  String? cardIdIN4;
  //转出卡号后4
  String? cardIdOUT4;
  //转出卡可用余额
  String? currAvailAtOUT;
  //转出卡账户余额
  String? currBalAtOUT;
  //转出卡卡有效期
  String? endDtOUT;
  //交易参考号
  String? intTxnRefId;
  //交易流水号
  String? intTxnSeqId;
  //转出卡冻结余额
  String? lockAtOUT;
  //审核备注 [最大长度256]
  String? note;
  //转账金额 [单位：分]
  String? txnAt;
  //交易日期
  String? txnDt;
  //交易时间
  String? txnTm;

  UnionPayTransferResModel();

  factory UnionPayTransferResModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayTransferResModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayTransferResModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
