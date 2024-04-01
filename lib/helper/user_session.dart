
import 'package:union_pay/models/user/user_info.dart';
import '../generated/json/base/json_field.dart';
import '../generated/json/user_session.g.dart';
@JsonSerializable()
class UserSession {
  int? expireSecond;
  int? expireTime;
  String? token;
  int? walletId;
  UserInfo? userInfo;

  UserSession({
    this.expireSecond,
    this.expireTime,
    this.token,
    this.walletId,
    this.userInfo
  });

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      $UserSessionFromJson(json);

  Map<String, dynamic> toJson() => $UserSessionToJson(this);

}