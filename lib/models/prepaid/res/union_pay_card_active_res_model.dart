import 'dart:convert';
import 'package:union_pay/models/prepaid/enums/union_card_type.dart';

import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_card_active_res_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/19 19:21
/// @Description: 预付卡激活响应
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayCardActiveResModel {
  //品牌ID [长度4位]:- 0002: 实体卡- 0003: 虚拟卡
  String? brandId;
  //卡号
  String? cardId;
  //卡号后4位数
  String? cardId4;
  //创建时间
  String? createTime;
  //	用户id
  int? cusId;
  //卡映射ID [每个卡都是独特]
  String? extCardId;
  //外部客户ID [最大15位, 每个用户都是独特]
  String? extCustId;
  //是否已上传头像：- Y: 已上传- N: 未上传
  String? headPicUrlFlag;
  int? id;
  //审核备注 [最大长度256]
  String? note;
  //Uploaded Document Photo Flag:- Y: 已上传- N: 未上传
  String? pidNoUrlFlag;
  //响应参数
  String? repParams;
  //	请求参数
  String? reqParams;
  //银联卡平台：申请单流水号 [最长32]
  String? serialId;
  //	排序
  int? sort;
  //状态：01-未审核,06-审核通过, 07-审核拒绝, 08-制卡中, 09-制卡完成
  String? status;
  String? updateTime;

  //卡的类型
  UnionCardType cardType() {
    return UnionCardTypeValue.typeFromStr(brandId);
  }


  UnionPayCardActiveResModel();

  factory UnionPayCardActiveResModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayCardActiveResModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayCardActiveResModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
