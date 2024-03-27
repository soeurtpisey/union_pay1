import 'dart:convert';
import 'dart:core';

import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter/src/model/we_message.dart';
import 'package:wecloudchatkit_flutter/src/we_listeners.dart';

enum WeConversationType {
  CONV_TYPE_SINGLE, // 单聊会话
  CONV_TYPE_GROUP, // 群聊会话
  CONV_TYPE_THOUSAND, // 千人群
  CONV_TYPE_CHAT_ROOM, // 聊天室
  CONV_TYPE_SYSTEN_MESSAGE, // 系统消息
}

extension WeConvTypeValue on WeConversationType {
  int get value {
    int ret = 0;
    switch (this) {
      case WeConversationType.CONV_TYPE_SINGLE:
        ret = 1;
        break;
      case WeConversationType.CONV_TYPE_GROUP:
        ret = 2;
        break;
      case WeConversationType.CONV_TYPE_THOUSAND:
        ret = 3;
        break;
      case WeConversationType.CONV_TYPE_CHAT_ROOM:
        ret = 4;
        break;
      case WeConversationType.CONV_TYPE_SYSTEN_MESSAGE:
        ret = 6;
        break;
    }
    return ret;
  }

  static WeConversationType typeFromInt(int? type) {
    WeConversationType ret = WeConversationType.CONV_TYPE_SINGLE;
    switch (type) {
      case 1:
        ret = WeConversationType.CONV_TYPE_SINGLE;
        break;
      case 2:
        ret = WeConversationType.CONV_TYPE_GROUP;
        break;
      case 3:
        ret = WeConversationType.CONV_TYPE_THOUSAND;
        break;
      case 4:
        ret = WeConversationType.CONV_TYPE_CHAT_ROOM;
        break;
      case 6:
        ret = WeConversationType.CONV_TYPE_SYSTEN_MESSAGE;
        break;
    }
    return ret;
  }
}

//操作类型 1-设置管理员 2-删除管理员
enum ConvAdminType { ADD_ADMIN, DEL_ADMIN }

extension ConvAdminsOperTypeValue on ConvAdminType {
  int get value {
    int ret = 0;
    switch (this) {
      case ConvAdminType.ADD_ADMIN:
        ret = 1;
        break;
      case ConvAdminType.DEL_ADMIN:
        ret = 2;
        break;
    }
    return ret;
  }
}

class WeConversation {
  int id = 0; //会话id
  int createTime = 0; //创建时间
  String? creator; //创建者客户端id
  String? name; //	可选 对话的名字，可为群组命名
  String? attributes; //	可选 自定义属性，供开发者扩展使用。
  bool systemFlag = false; //	可选 对话类型标志，是否是系统对话，后面会说明。
  int msgNotReadCount = 0; //	未读消息条数
  String? members; //成员
  WeConversationType? chatType;
  int memberCount = 0;
  int muted = 1; //群禁言开关 1-未禁言 2-禁言
  bool hide = false;
  int updateTime = 0; //更新时间
  String? draft; //草稿
  String? headPortrait; //头像
  bool isDisband = false; //是否解散
  bool isBeAt = false;
  bool? isTop; //置顶
  bool? isDoNotDisturb; //免打扰
  bool? isDriveOut; //是否被T
  int? isEncrypt; //是否加密会话
  WeMessage? lastMsg; //会话最后一条消息
  int timeToBurn = 0; //阅后即焚设置时长
  ConversationAttrs? attrs;

  bool? select;

  ConversationUpdateListener? updateListener;

  void setConversationUpdateListener(ConversationUpdateListener? listener) {
    this.updateListener = listener;
    if (listener != null) {
      WeConversationManager.getInstance.addConvUpdateListener(this);
    } else {
      WeConversationManager.getInstance.removeConvUpdateListener(this);
    }
  }

  bool isMore() {
    return id == -1;
  }

  void dispose() {
    WeConversationManager.getInstance.removeConvUpdateListener(this);
  }

  WeConversation({
    this.id = 0,
    this.createTime = 0,
    this.creator,
    this.name,
    this.attributes,
    this.systemFlag = false,
    this.msgNotReadCount = 0,
    this.members = "",
    this.chatType,
    this.memberCount = 0,
    this.muted = 1,
    this.hide = false,
    this.updateTime = 0,
    this.draft,
    this.isDisband = false,
    this.isBeAt = false,
    this.isTop,
    this.isDoNotDisturb,
    this.isDriveOut,
    this.isEncrypt,
    this.headPortrait,
    this.lastMsg,
    this.attrs,
    this.timeToBurn = 0,
  });

  factory WeConversation.fromJson(Map<String, dynamic> json) {
    var attrs;
    if (json['attributes'] != null && json['attributes'] != 'null') {
      if (json['attributes'] is String) {
        attrs = ConversationAttrs.fromJson(jsonDecode(json['attributes']));
      } else {
        attrs = ConversationAttrs.fromJson(json['attributes']);
      }
    }

    var memberCount = json['memberCount'];
    if (attrs == null) {
      attrs = ConversationAttrs(isGroup: (memberCount ?? 0) > 3);
    }

    return WeConversation(
      id: json['id'],
      createTime: json['createTime'],
      creator: json['creator'],
      name: json['name'],
      attributes: json['attributes'],
      systemFlag: json['systemFlag'],
      msgNotReadCount: json['msgNotReadCount'],
      members: json['members'],
      chatType: WeConvTypeValue.typeFromInt(json['chatType']),
      memberCount: memberCount,
      muted: json['muted'],
      hide: json['hide'],
      updateTime: json['updateTime'],
      draft: json['draft'],
      attrs: attrs,
      isDisband: json['isDisband'],
      isBeAt: json['isBeAt'],
      isTop: json['isTop'],
      isDoNotDisturb: json['isDoNotDisturb'],
      isDriveOut: json['isDriveOut'],
      isEncrypt: json['isEncrypt'],
      headPortrait: json['headPortrait'],
      lastMsg:
          json['lastMsg'] == null ? null : WeMessage.fromJson(json['lastMsg']),
      timeToBurn: json['timeToBurn'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createTime': createTime,
        'creator': creator,
        'name': name,
        'attributes': attrs == null ? attributes : attrs?.toJson(),
        'systemFlag': systemFlag,
        'msgNotReadCount': msgNotReadCount,
        'members': members,
        'chatType': chatType?.value,
        'memberCount': memberCount,
        'muted': muted,
        'hide': hide,
        'updateTime': updateTime,
        'draft': draft,
        'isDisband': isDisband,
        'isBeAt': isBeAt,
        'isDoNotDisturb': isDoNotDisturb,
        'isTop': isTop,
        'isDriveOut': isDriveOut,
        'isEncrypt': isEncrypt,
        'headPortrait': headPortrait,
        'lastMsg': lastMsg?.toJson(),
        'timeToBurn': timeToBurn,
      };

  void update(WeConversation conversation) {
    name = conversation.name; //	可选 对话的名字，可为群组命名
    attributes = conversation.attributes; //	可选 自定义属性，供开发者扩展使用。
    msgNotReadCount = conversation.msgNotReadCount; //	未读消息条数
    muted = conversation.muted; //群禁言开关 1-未禁言 2-禁言
    hide = conversation.hide;
    updateTime = conversation.updateTime; //更新时间
    draft = conversation.draft; //草稿
    isDisband = conversation.isDisband; //是否解散
    isBeAt = conversation.isBeAt;
    isDriveOut = conversation.isDriveOut;
    isEncrypt = conversation.isEncrypt;
    if (lastMsg?.msgId == conversation.lastMsg?.msgId &&
        lastMsg?.msgStatus == WeMessageStatus.MsgStatusDelete) {
      //同一条消息，且本地是删除状态就不更新lashMsg
    } else if ((lastMsg?.createTime ?? 0) <=
        (conversation.lastMsg?.createTime ?? 0)) {
      lastMsg = conversation.lastMsg; //会话最后一条消息
    }
    headPortrait = conversation.headPortrait;
    isTop = conversation.isTop;
    isDoNotDisturb = conversation.isDoNotDisturb;
    timeToBurn = conversation.timeToBurn;
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + id.hashCode;
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (other is! WeConversation) return false;
    WeConversation model = other;
    // print("${model.id}      ${id}");
    return (model.id == id);
  }
}

class ConversationAttrs {
  String? groupHeadUrl;
  bool? isGroup;

  ConversationAttrs({this.groupHeadUrl, this.isGroup});

  ConversationAttrs.fromJson(Map<String, dynamic> jsonMap) {
    if (jsonMap['groupHeadUrl'] != null) {
      groupHeadUrl = jsonMap['groupHeadUrl'];
    } else {
      groupHeadUrl = '';
    }
    // ownId = jsonMap['ownId'];
    // manageIds = json.decode(jsonMap['manageIds']).cast<String>();
    if (jsonMap['isGroup'] != null) {
      isGroup = jsonMap['isGroup'] ?? false;
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['groupHeadUrl'] = groupHeadUrl;
    data['isGroup'] = isGroup;
    return data;
  }
}
