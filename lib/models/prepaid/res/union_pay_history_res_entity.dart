import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_history_res_entity.g.dart';
import '../../../generated/l10n.dart';

@JsonSerializable()
class UnionPayHistoryResEntity {
  List<BongLoyCardOrderDto>? bongLoyCardOrderDtoList;
  double? topUpNum;
  double? transferNum;

  UnionPayHistoryResEntity();

  factory UnionPayHistoryResEntity.fromJson(Map<String, dynamic> json) =>
      $UnionPayHistoryResEntityFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayHistoryResEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class BongLoyCardOrderDto {
  //
  double? amount;
  //
  String? ccy;
  //
  String? createTime;

  String parseDate() {
    var date=DateTime.parse(createTime??'');
    var format = DateFormat('MM/yyyy').format(date);
    return format;
  }
  String parseDate2() {
    var date=DateTime.parse(createTime??'');
    var format = DateFormat('yyyy-MM-dd').format(date);
    return format;
  }
  //
  int? cucId;
  //
  int? cucoType;
  //
  String? dstCard;
  //
  String? dstCardName;
  int? dstCardType;
  int? id;
  String? inParams;
  //
  String? intTxnRefId;
  //
  String? intTxnSeqId;
  String? outParams;
  //
  String? srcCard;
  int? srcCardType;
  //
  int? status;
  String? updateTime;
  //
  int? way; //0：转入  1：转出
  BongLoyCardOrderDto();

  factory BongLoyCardOrderDto.fromJson(Map<String, dynamic> json) =>
      $BongLoyCardOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => $BongLoyCardOrderDtoToJson(this);

  String getTransferSuccessType() {
    if (cucoType == 0) {
      return S.current.top_up_successful;
    } else if (cucoType == 1) {
      return S.current.prepaid_transfer_success;
    }
    return S.current.other;
  }

  String getTransferType() {
    if (cucoType == 0) {
      return S.current.recharge;
    } else if (cucoType == 1) {
      return S.current.transfer_title;
    }
    return S.current.other;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
