import 'dart:convert';
import '../../generated/json/base/json_field.dart';
import '../../generated/json/union_pay_card_pwd_modify_model.g.dart';

/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/19 20:22
/// @Description: 预付卡修改ATM 密码
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayCardPwdModifyModel {
  //upay卡表主键id
  int? id;
  //卡ATM新密码[6位数]
  String? newPinEnc;
  //卡ATM密码[6位数]
  String? pinEnc;


  UnionPayCardPwdModifyModel();

  factory UnionPayCardPwdModifyModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayCardPwdModifyModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayCardPwdModifyModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
