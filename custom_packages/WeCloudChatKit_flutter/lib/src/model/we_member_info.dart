///成员角色
enum MemberRole {
  normal, //群员
  admin, //管理员
  owner, //群组
}

extension MemberRoleValue on MemberRole {
  int get value {
    int ret = 1;
    switch (this) {
      case MemberRole.normal:
        ret = 1;
        break;
      case MemberRole.admin:
        ret = 2;
        break;
      case MemberRole.owner:
        ret = 3;
        break;
    }
    return ret;
  }

  static MemberRole roleFromInt(int? type) {
    MemberRole ret = MemberRole.normal;
    switch (type) {
      case 1:
        ret = MemberRole.normal;
        break;
      case 2:
        ret = MemberRole.admin;
        break;
      case 3:
        ret = MemberRole.owner;
        break;
    }
    return ret;
  }
}

//成员禁言
enum MemberMuted {
  disable, //关闭
  enable, //开启
}

extension MemberMutedValue on MemberMuted {
  int get value {
    int ret = 1;
    switch (this) {
      case MemberMuted.disable:
        ret = 1;
        break;
      case MemberMuted.enable:
        ret = 2;
        break;
    }
    return ret;
  }

  static MemberMuted mutedFromInt(int? type) {
    MemberMuted ret = MemberMuted.disable;
    switch (type) {
      case 1:
        ret = MemberMuted.disable;
        break;
      case 2:
        ret = MemberMuted.enable;
        break;
    }
    return ret;
  }
}

class WeMemberInfo {
  String? clientRemarkName;
  String? headPortrait;
  String? nickname;
  String? clientId;
  String? clientAttribute;

  String? memberAttributes;
  MemberRole role = MemberRole.normal;
  MemberMuted muted = MemberMuted.disable;

  WeMemberInfo(
      {this.clientRemarkName,
      this.headPortrait,
      this.nickname,
      this.clientId,
      this.clientAttribute,
      this.memberAttributes,
      this.role = MemberRole.normal,
      this.muted = MemberMuted.disable});

  factory WeMemberInfo.fromJson(Map<String, dynamic> json) {
    return WeMemberInfo(
      clientRemarkName: json['clientRemarkName'],
      headPortrait: json['headPortrait'],
      nickname: json['nickname'],
      clientId: json['clientId'],
      clientAttribute: json['clientAttribute'],
      memberAttributes: json['memberAttributes'],
      role: MemberRoleValue.roleFromInt(json['role']),
      muted: MemberMutedValue.mutedFromInt(json['muted']),
    );
  }

  Map<String, dynamic> toJson() => {
        'clientRemarkName': clientRemarkName,
        'headPortrait': headPortrait,
        'nickname': nickname,
        'clientId': clientId,
        'clientAttribute': clientAttribute,
        'memberAttributes': memberAttributes,
        'role': role.value,
        'muted': muted.value,
      };
}
