

import 'package:union_pay/extensions/int_extension.dart';
import 'package:union_pay/generated/json/kyc_info_model.g.dart';
import 'package:union_pay/models/prepaid/enums/doc_type.dart';
import '../generated/json/base/json_field.dart';

@JsonSerializable()
class KycInfoModel {
  KycInfoModel();

  factory KycInfoModel.fromJson(Map<String, dynamic> json) =>
      $KycInfoModelFromJson(json);

  Map<String, dynamic> toJson() => $KycInfoModelToJson(this);

  String? verificationId;
  String? fname;
  String? lname;

  //M|F
  String? gender;
  String? birthday;

  //docType(sumsub): ID_CARD(本地身份证),DRIVERS(本地驾照)，PASSPORT(护照)
  String? docType;

  //证件ID
  String? docId;

  //国籍
  String? country;
  bool? isVerified;

  // //是否已部分kyc认证
  // bool? isPartKyc;
  //是否已全部kyc认证
  bool? isFullKyc;

  String birthYear() {
    return DateTime.parse(birthday!).year.addZero();
  }

  String birthMonth() {
    return DateTime.parse(birthday!).month.addZero();
  }

  String birthDay() {
    return DateTime.parse(birthday!).day.addZero();
  }

  DocType getType() {
    return DocTypeValue.typeFromStr(docType);
  }

  bool isPartKyc() {
    if (isFullKyc == true) {
      return false;
    }
    return isVerified == true;
  }

  bool isBasicKyc() {
    return isVerified != true && isFullKyc != true;
  }

  bool isEmpty() {
    return isVerified == null;
  }
}
