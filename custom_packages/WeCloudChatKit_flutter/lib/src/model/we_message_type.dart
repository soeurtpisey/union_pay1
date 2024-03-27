enum WeMessageType {
  MSG_TXT,
  MSG_IMAGE,
  MSG_VOICE,
  MSG_VIDEO,
  MSG_FILE,
  MSG_CUSTOM,

  //会话名称字段变动   不用回执
  CONV_EVENT_NAME_CHANGE,
  //会话头像改变
  CONV_EVENT_HEAD_PORTRAIT_CHANGE,
  //会话拓展字段变动   不用回执
  CONV_EVENT_ATTR_CHANGE,
  //xx成为新群主   要回执
  CONV_EVENT_OWNER_CHANGE,
  //xx主动退出会话   要回执
  CONV_EVENT_MEMBER_EXIT,
  //xx被xx拉入新会话
  CONV_EVENT_ADD_CONV,
  // xx被xx移出会话   要回执
  CONV_EVENT_DRIVE_OUT_CONV,
  //xx邀请xx加入会话   要回执
  CONV_EVENT_MEMBER_ADD,
  //解散群聊
  CONV_EVENT_DISBAND,
  //群全体禁言
  CONV_EVENT_MUTED,
  //取消全体禁言
  CONV_EVENT_MUTED_CANCEL,
  //群成员备注名修改
  CONV_EVENT_MEMBER_NAME_MODIFY,
  //禁止群成员互加好友
  CONV_EVENT_GROUP_ADD_FRIEND_DISABLE,
  //取消禁止群成员互加好友
  CONV_EVENT_GROUP_ADD_FRIEND_ENABLE,
  //禁止群成员发图片
  CONV_EVENT_GROUP_SEND_IMG_DISABLE,
  //取消禁止群成员发图片
  CONV_EVENT_GROUP_SEND_IMG_ENABLE,
  //禁止群成员发链接
  CONV_EVENT_GROUP_SEND_LINK_DISABLE,
  //取消禁止群成员发链接
  CONV_EVENT_GROUP_SEND_LINK_ENABLE,
  //群成员禁言
  CONV_EVENT_GROUP_MEMBER_MUTED,
  //群成员取消禁言
  CONV_EVENT_GROUP_MEMBER_MUTED_CANCEL,
  //没有上传公钥
  CONV_EVENT_NO_PUBLIC_KEY_UPLOADED,

  //某消息已接收状态
  MSG_EVENT_RECEIVED,
  //某消息已读状态
  MSG_EVENT_READ,
  // 消息撤回 -1016
  MSG_EVENT_WITHDRAW,
  //消息删除 -1017
  MSG_EVENT_DELETE,

  /// 群成员开启禁止发红包
  CONV_EVENT_GROUP_SEND_RED_PACKET_DISABLE,

  /// 群成员关闭禁止发红包
  CONV_EVENT_GROUP_SEND_RED_PACKET_ENABLE,
}

extension WeMsgTypeValue on WeMessageType {
  int get value {
    int ret = 0;
    switch (this) {
      case WeMessageType.MSG_TXT:
        ret = -1;
        break;
      case WeMessageType.MSG_IMAGE:
        ret = -2;
        break;
      case WeMessageType.MSG_VOICE:
        ret = -3;
        break;
      case WeMessageType.MSG_VIDEO:
        ret = -4;
        break;
      case WeMessageType.MSG_FILE:
        ret = -5;
        break;
      case WeMessageType.MSG_CUSTOM:
        ret = 1000;
        break;
      case WeMessageType.CONV_EVENT_NAME_CHANGE:
        ret = -1015;
        break;
      case WeMessageType.CONV_EVENT_ATTR_CHANGE:
        ret = -1014;
        break;
      case WeMessageType.CONV_EVENT_OWNER_CHANGE:
        ret = -1013;
        break;
      case WeMessageType.CONV_EVENT_MEMBER_EXIT:
        ret = -1012;
        break;
      case WeMessageType.CONV_EVENT_ADD_CONV:
        ret = -1011;
        break;
      case WeMessageType.CONV_EVENT_DRIVE_OUT_CONV:
        ret = -1008;
        break;
      case WeMessageType.CONV_EVENT_MEMBER_ADD:
        ret = -1007;
        break;
      case WeMessageType.MSG_EVENT_RECEIVED:
        ret = -1009;
        break;
      case WeMessageType.MSG_EVENT_READ:
        ret = -1010;
        break;
      case WeMessageType.MSG_EVENT_WITHDRAW:
        ret = -1016;
        break;
      case WeMessageType.MSG_EVENT_DELETE:
        ret = -1017;
        break;
      case WeMessageType.CONV_EVENT_DISBAND:
        ret = -1018;
        break;
      case WeMessageType.CONV_EVENT_MUTED:
        ret = -1019;
        break;
      case WeMessageType.CONV_EVENT_MUTED_CANCEL:
        ret = -1020;
        break;
      case WeMessageType.CONV_EVENT_MEMBER_NAME_MODIFY:
        ret = -1021;
        break;
      case WeMessageType.CONV_EVENT_HEAD_PORTRAIT_CHANGE:
        ret = -1031;
        break;
      case WeMessageType.CONV_EVENT_GROUP_ADD_FRIEND_DISABLE:
        ret = -1022;
        break;
      case WeMessageType.CONV_EVENT_GROUP_ADD_FRIEND_ENABLE:
        ret = -1023;
        break;
      case WeMessageType.CONV_EVENT_GROUP_SEND_IMG_DISABLE:
        ret = -1026;
        break;
      case WeMessageType.CONV_EVENT_GROUP_SEND_IMG_ENABLE:
        ret = -1027;
        break;
      case WeMessageType.CONV_EVENT_GROUP_SEND_LINK_DISABLE:
        ret = -1028;
        break;
      case WeMessageType.CONV_EVENT_GROUP_SEND_LINK_ENABLE:
        ret = -1029;
        break;
      case WeMessageType.CONV_EVENT_GROUP_MEMBER_MUTED:
        ret = -1032;
        break;
      case WeMessageType.CONV_EVENT_GROUP_MEMBER_MUTED_CANCEL:
        ret = -1033;
        break;
      case WeMessageType.CONV_EVENT_NO_PUBLIC_KEY_UPLOADED:
        ret = -9999;
        break;
    }
    return ret;
  }

  static WeMessageType msgTypeFromInt(int? type) {
    WeMessageType ret = WeMessageType.MSG_TXT;
    switch (type) {
      case -1:
        ret = WeMessageType.MSG_TXT;
        break;
      case -2:
        ret = WeMessageType.MSG_IMAGE;
        break;
      case -3:
        ret = WeMessageType.MSG_VOICE;
        break;
      case -4:
        ret = WeMessageType.MSG_VIDEO;
        break;
      case -5:
        ret = WeMessageType.MSG_FILE;
        break;
      case 1000:
        ret = WeMessageType.MSG_CUSTOM;
        break;
      case -1015:
        ret = WeMessageType.CONV_EVENT_NAME_CHANGE;
        break;
      case -1014:
        ret = WeMessageType.CONV_EVENT_ATTR_CHANGE;
        break;
      case -1013:
        ret = WeMessageType.CONV_EVENT_OWNER_CHANGE;
        break;
      case -1012:
        ret = WeMessageType.CONV_EVENT_MEMBER_EXIT;
        break;
      case -1011:
        ret = WeMessageType.CONV_EVENT_ADD_CONV;
        break;
      case -1008:
        ret = WeMessageType.CONV_EVENT_DRIVE_OUT_CONV;
        break;
      case -1007:
        ret = WeMessageType.CONV_EVENT_MEMBER_ADD;
        break;
      case -1009:
        ret = WeMessageType.MSG_EVENT_RECEIVED;
        break;
      case -1010:
        ret = WeMessageType.MSG_EVENT_READ;
        break;
      case -1016:
        ret = WeMessageType.MSG_EVENT_WITHDRAW;
        break;
      case -1017:
        ret = WeMessageType.MSG_EVENT_DELETE;
        break;
      case -1018:
        ret = WeMessageType.CONV_EVENT_DISBAND;
        break;
      case -1019:
        ret = WeMessageType.CONV_EVENT_MUTED;
        break;
      case -1020:
        ret = WeMessageType.CONV_EVENT_MUTED_CANCEL;
        break;
      case -1021:
        ret = WeMessageType.CONV_EVENT_MEMBER_NAME_MODIFY;
        break;
      case -1031:
        ret = WeMessageType.CONV_EVENT_HEAD_PORTRAIT_CHANGE;
        break;
      case -1022:
        ret = WeMessageType.CONV_EVENT_GROUP_ADD_FRIEND_DISABLE;
        break;
      case -1023:
        ret = WeMessageType.CONV_EVENT_GROUP_ADD_FRIEND_ENABLE;
        break;
      case -1026:
        ret = WeMessageType.CONV_EVENT_GROUP_SEND_IMG_DISABLE;
        break;
      case -1027:
        ret = WeMessageType.CONV_EVENT_GROUP_SEND_IMG_ENABLE;
        break;
      case -1028:
        ret = WeMessageType.CONV_EVENT_GROUP_SEND_LINK_DISABLE;
        break;
      case -1029:
        ret = WeMessageType.CONV_EVENT_GROUP_SEND_LINK_ENABLE;
        break;
      case -1032:
        ret = WeMessageType.CONV_EVENT_GROUP_MEMBER_MUTED;
        break;
      case -1033:
        ret = WeMessageType.CONV_EVENT_GROUP_MEMBER_MUTED_CANCEL;
        break;
      case -9999:
        ret = WeMessageType.CONV_EVENT_NO_PUBLIC_KEY_UPLOADED;
        break;
    }
    return ret;
  }
}
