import 'dart:convert';
import '../../../generated/json/base/json_field.dart';
import '../../../generated/json/union_pay_apply_res_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 15:04
/// @Description: 预付卡新客户老客户response
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayApplyResModel {
  //主键id
  int? id;
  //用户id
  int? cusId;
  //银联卡平台：申请单流水号 [最长32]
  String? serialId;
  //请求参数
  String? reqParams;
  //响应参数
  String? repParams;
  //状态：01-未审核,06-审核通过, 07-审核拒绝, 08-制卡中, 09-制卡完成
  String? status;
  //卡映射ID [每个卡都是独特]
  String? extCardId;
  //审核备注 [最大长度256]
  String? note;
  //品牌ID [长度4位]:- 0002: 实体卡- 0003: 虚拟卡
  String? brandId;
  //外部客户ID [最大15位, 每个用户都是独特]
  String? extCustId;
  //是否已上传头像：- Y: 已上传- N: 未上传
  String? headPicUrlFlag;
  //Uploaded Document Photo Flag:- Y: 已上传- N: 未上传
  String? pidNoUrlFlag;
  //卡号
  String? cardId;
  //创建时间
  String? createTime;
  //更新时间
  String? updateTime;
  //排序
  int? sort;
  //卡号后4位数
  String? cardId4;

  UnionPayApplyResModel();

  factory UnionPayApplyResModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayApplyResModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayApplyResModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
