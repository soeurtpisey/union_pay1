
import 'package:union_pay/models/user/user_info.dart';
import '../generated/json/base/json_field.dart';
import '../generated/json/user_session.g.dart';

@JsonSerializable()
class UserSession {
  int? expiredIn;
  int? expiredTime;
  String? token;
  String? refreshToken;
  String? tokenType;
  int? walletId;
  UserInfo? userInfo;

  UserSession({
    this.expiredIn,
    this.expiredTime,
    this.token,
    this.refreshToken,
    this.tokenType,
    this.walletId,
    this.userInfo
  });

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      $UserSessionFromJson(json);

  Map<String, dynamic> toJson() => $UserSessionToJson(this);

}