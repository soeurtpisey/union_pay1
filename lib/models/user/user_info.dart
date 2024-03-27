import '../../generated/json/base/json_field.dart';
import '../../generated/json/user_info.g.dart';

@JsonSerializable()
class UserInfo {
  int? id;
  String? avatar;
  String? name;
  String? phone;
  String? username;
  bool? showPersonalPerformanceTab;
  bool? showTeamPerformanceTab;

  UserInfo({
    this.id,
    this.avatar,
    this.name,
    this.phone,
    this.username,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      $UserInfoFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoToJson(this);
}
