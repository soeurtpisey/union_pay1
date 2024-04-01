import '../../generated/json/base/json_field.dart';
import '../../generated/json/user_info.g.dart';

@JsonSerializable()
class UserInfo {
  int? id;
  String? email;
  String? language;
  String? phone;

  UserInfo({
    this.id,
    this.email,
    this.language,
    this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      $UserInfoFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoToJson(this);
}
