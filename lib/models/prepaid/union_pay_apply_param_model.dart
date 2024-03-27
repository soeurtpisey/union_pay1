import 'dart:convert';

import 'package:union_pay/models/prepaid/enums/union_card_type.dart';

import '../../generated/json/base/json_field.dart';
import '../../generated/json/union_pay_apply_param_model.g.dart';
import '../../generated/l10n.dart';
import '../../utils/date_util.dart';


/// ////////////////////////////////////////////
/// @author: DJW
/// @Date: 2022/12/15 15:04
/// @Description: 预付卡新客户申请入参
/// /////////////////////////////////////////////
@JsonSerializable()
class UnionPayApplyParamModel {
  //地址
  String? addr;

  //省份
  int? provincesId;

  @JSONField(serialize: false, deserialize: false)
  String? province;


  @JSONField(serialize: false, deserialize: false)
  bool? isEdit;

  //市/区
  int? districtsId;

  @JSONField(serialize: false, deserialize: false)
  String? districts;

  //直辖市
  int? communesId;

  @JSONField(serialize: false, deserialize: false)
  String? communes;

  //品牌ID [长度4位]:- 0002: 实体卡- 0003: 虚拟卡
  String? brandId;

  //出生日期 [yyyyMMdd]
  String? dob;

  //电子邮箱 [长度最大50]
  String? email;

  //柬埔寨姓名 [姓 + 空格 + 名]
  String? khName;

  //会员注册日期
  String? memberEnrolledDate;

  //会员ID
  String? memberId;

  //手机号 [最大长度30, 格式: 区号-电话号码]
  String? mobile;




  //全名 [长度最大50, 全都大写单词, 名字 - 姓名, 示例: DOE JOHN]
  String? name;

  String? fName;
  String? lName;

  String getFirstName(){
    return fName??'';
  }

  String getLastName(){
    return lName??'';
  }

  //国籍编码 [使用电话号码扩展扩展至4位数，示例: 柬埔寨: 0855，中国: 0086]
  String? nationalityCode;

  @JSONField(serialize:false,deserialize:false)
  String? nationality;


  //组织名称
  String? organizationName;

  //证件号 [长度最大32]
  String? pidNo;

  //证件类型: 1-身份证，3-护照
  String? pidType;

  //file -> base64
  //证件照正面
  String? idPhotoFront;

  //证件照背面
  String? idPhotoObverse;

  //自拍
  String? headPhoto;

  UnionPayApplyParamModel();

  String getPidDesc() {
    return pidType == '1'
        ? S.current.kycDocType_IdCard
        : S.current.kycDocType_Passport;
  }

  String? parseDob(){
    if(dob!=null){
      var parse = DateTime.parse(dob!);
      return DateUtil.formatDateMs(parse.millisecondsSinceEpoch, format: 'yyyy-MM-dd');
    }else{
      return '';
    }
  }

  bool isVirtual() {
    return getCardType() == UnionCardType.virtualCard;
  }

  UnionCardType getCardType(){
    return UnionCardTypeValue.typeFromStr(brandId);
  }

  factory UnionPayApplyParamModel.fromJson(Map<String, dynamic> json) =>
      $UnionPayApplyParamModelFromJson(json);

  Map<String, dynamic> toJson() => $UnionPayApplyParamModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
