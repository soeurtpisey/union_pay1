import 'dart:math';

import 'package:wecloudchatkit_flutter/src/model/we_file_msg_info.dart';
import 'package:wecloudchatkit_flutter/src/model/we_message_type.dart';
import 'package:wecloudchatkit_flutter/src/model/we_notify_msg.dart';
import 'package:wecloudchatkit_flutter/src/we_chat_manager.dart';
import 'package:wecloudchatkit_flutter/src/we_client.dart';
import 'package:wecloudchatkit_flutter/src/we_listeners.dart';

enum WeMessageStatus {
  MsgStatusNone,
  MsgStatusFailed, //发送失败
  MsgStatusRecalled, //撤回
  MsgStatusSending, //发送中
  MsgStatusSent, //发送成功
  MsgStatusReceipt, //已送达
  MsgStatusDelete, //已删除
  MsgStatusCleanUp, //已清除
  MsgStatusInvalid, //已失效
}

extension WeMsgStatusValue on WeMessageStatus {
  int get value {
    int ret;
    switch (this) {
      case WeMessageStatus.MsgStatusNone:
        ret = 0;
        break;
      case WeMessageStatus.MsgStatusFailed:
        ret = 1;
        break;
      case WeMessageStatus.MsgStatusRecalled:
        ret = 2;
        break;
      case WeMessageStatus.MsgStatusSending:
        ret = 3;
        break;
      case WeMessageStatus.MsgStatusSent:
        ret = 4;
        break;
      case WeMessageStatus.MsgStatusReceipt:
        ret = 5;
        break;
      case WeMessageStatus.MsgStatusDelete:
        ret = 6;
        break;
      case WeMessageStatus.MsgStatusCleanUp:
        ret = 7;
        break;
      case WeMessageStatus.MsgStatusInvalid:
        ret = 8;
        break;
    }
    return ret;
  }

  static WeMessageStatus statusFromInt(int? type) {
    WeMessageStatus ret = WeMessageStatus.MsgStatusNone;
    switch (type) {
      case 0:
        ret = WeMessageStatus.MsgStatusNone;
        break;
      case 1:
        ret = WeMessageStatus.MsgStatusFailed;
        break;
      case 2:
        ret = WeMessageStatus.MsgStatusRecalled;
        break;
      case 3:
        ret = WeMessageStatus.MsgStatusSending;
        break;
      case 4:
        ret = WeMessageStatus.MsgStatusSent;
        break;
      case 5:
        ret = WeMessageStatus.MsgStatusReceipt;
        break;
      case 6:
        ret = WeMessageStatus.MsgStatusDelete;
        break;
      case 7:
        ret = WeMessageStatus.MsgStatusCleanUp;
        break;
      case 8:
        ret = WeMessageStatus.MsgStatusInvalid;
        break;
    }
    return ret;
  }
}

class WeMessage {
  int seq = 0;
  int msgId = 0; //消息id
  int? preMessageId;
  int createTime = 0; //创建时间
  int withdrawTime = 0; //撤回时间
  bool withdraw = false; //false 未撤回; true 已撤回
  String? sender; //发送者客户端id
  WeMessageType?
      type; //消息类型（-1~-6） 消息事件 （-1009、-1010） 会话事件（-1007、-1008、-1011~-1015）
  int conversationId = 0;
  bool event = false; //false 非事件; true 为事件
  bool system = false; //false 非系统通知; true 为系统通知
  String? at; //at他人,传入客户端id数组
  int? sendState; //本地用 1 sending  2 failure  3 success  4 blocked
  //http请求离线的字段
  int notReadCount = 0; //未读人数统计,全部人已读为0
  int notReceiverCount = 0; //未接收人数统计,全部人已接收为0

  //消息字段
  Map<String, dynamic>? attrs;

  String? text;

  //会话事件和消息事件（撤回、删除）的操作人
  String? operator; //操作的client ID
  //会话事件
  String? name; //会话名字改动
  String? attributes; //会话属性改动
  String? passivityOperator; //被操作的client ID

  WeMessageStatus msgStatus =
      WeMessageStatus.MsgStatusNone; //消息状态 默认0  发送失败1 撤回2 发送中3 发送成功4 已送达5 已删除6

  String? reqId;

  WeFileMsgInfo? file;
  WeNotifyMsg? push;

  /// 阅后即焚设置的时长(单位：秒)
  int timeToBurn = 0;

  ///  是否阅后即焚消息 0否 1是
  int burn = 0;

//0普通消息 1未过期消息 2过期消息 3 未过期且未浏览（针对除文本消息外）
  int burnType = 0;

  /// //阅后即焚开始时间戳(毫秒)
  int expiresStart = 0;

  WeMessage._private({
    this.seq = 0,
    this.msgId = 0,
    this.preMessageId,
    this.createTime = 0,
    this.withdrawTime = 0,
    this.withdraw = false,
    this.sender,
    this.type,
    this.conversationId = 0,
    this.event = false,
    this.system = false,
    this.at,
    this.notReadCount = 0,
    this.notReceiverCount = 0,
    this.attrs,
    this.text,
    this.operator,
    this.name,
    this.attributes,
    this.passivityOperator,
    this.msgStatus = WeMessageStatus.MsgStatusNone,
    this.reqId,
    this.file,
    this.push,
    this.timeToBurn = 0,
    this.burn = 0,
    this.burnType = 0,
    this.expiresStart = 0,
  });

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + msgId.hashCode;
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (other is! WeMessage) return false;
    WeMessage model = other;
    // print("${model.id}      ${id}");
    if (msgId == 0) {
      return (model.reqId == reqId);
    }
    return (model.msgId == msgId);
  }

  static createSendTxtMessage(
    int conversationId,
    String content,
  ) {
    var msg =
        WeMessage._createSendMessage(conversationId, WeMessageType.MSG_TXT);
    msg.text = content;
    return msg;
  }

  static createSendImageMessage(
    int conversationId,
    WeFileMsgInfo img,
  ) {
    var msg =
        WeMessage._createSendMessage(conversationId, WeMessageType.MSG_IMAGE);
    msg.file = img;
    return msg;
  }

  static createSendVideoMessage(
    int conversationId,
    WeFileMsgInfo video,
  ) {
    var msg =
        WeMessage._createSendMessage(conversationId, WeMessageType.MSG_VIDEO);
    msg.file = video;
    return msg;
  }

  static createSendVoiceMessage(
    int conversationId,
    WeFileMsgInfo voice,
  ) {
    var msg =
        WeMessage._createSendMessage(conversationId, WeMessageType.MSG_VOICE);
    msg.file = voice;
    return msg;
  }

  static createSendFileMessage(
    int conversationId,
    WeFileMsgInfo file,
  ) {
    var msg =
        WeMessage._createSendMessage(conversationId, WeMessageType.MSG_FILE);
    msg.file = file;
    return msg;
  }

  static createSendCustomMessage(int conversationId, {ChatAttrModel? attr}) {
    var msg =
        WeMessage._createSendMessage(conversationId, WeMessageType.MSG_CUSTOM);
    if (attr != null) {
      msg.attrs = attr.toJson();
    }
    return msg;
  }

  static createCustomMessage(int conversationId, String sender,
      {ChatAttrModel? attr}) {
    var msg = WeMessage._createMessage(
        conversationId, sender, WeMessageType.MSG_CUSTOM);
    if (attr != null) {
      msg.attrs = attr.toJson();
    }
    return msg;
  }

  WeMessage._createSendMessage(int conversationId, WeMessageType messageType)
      : this.type = messageType,
        this.conversationId = conversationId,
        this.msgStatus = WeMessageStatus.MsgStatusNone,
        this.sender = WeClient.clientId,
        this.createTime = DateTime.now().millisecondsSinceEpoch,
        this.reqId = DateTime.now().millisecondsSinceEpoch.toString() +
            Random().nextInt(99999).toString();

  WeMessage._createMessage(
      int conversationId, String sender, WeMessageType messageType)
      : this.type = messageType,
        this.conversationId = conversationId,
        this.msgStatus = WeMessageStatus.MsgStatusNone,
        this.sender = sender,
        this.createTime = DateTime.now().millisecondsSinceEpoch,
        this.reqId = DateTime.now().millisecondsSinceEpoch.toString() +
            Random().nextInt(99999).toString();

  MessageStatusListener? statusListener;

  void setMessageListener(MessageStatusListener? listener) {
    this.statusListener = listener;
    if (listener != null) {
      WeChatManager.getInstance.addMsgStatusUpdateListener(this);
    } else {
      WeChatManager.getInstance.removeMsgStatusUpdateListener(this);
    }
  }

  void dispose() {
    WeChatManager.getInstance.removeMsgStatusUpdateListener(this);
  }

  factory WeMessage.fromJson(Map<String, dynamic> json) {
    return WeMessage._private(
      seq: json['seq'],
      msgId: json['msgId'],
      preMessageId: json['preMessageId'],
      createTime: json['createTime'],
      withdrawTime: json['withdrawTime'],
      withdraw: json['withdraw'],
      sender: json['sender'],
      type: WeMsgTypeValue.msgTypeFromInt(json['type']),
      conversationId: json['conversationId'],
      event: json['event'],
      system: json['system'],
      at: json['at'] == null ? null : json['at'],
      notReadCount: json['notReadCount'],
      notReceiverCount: json['notReceiverCount'],
      attrs: json['attrs'],
      text: json['text'],
      operator: json['operator'],
      name: json['name'],
      attributes: json['attributes'],
      passivityOperator: json['passivityOperator'],
      msgStatus: WeMsgStatusValue.statusFromInt(json['msgStatus']),
      reqId: json['reqId'],
      file: json['file'] == null ? null : WeFileMsgInfo.fromJson(json['file']),
      push: json['push'] == null ? null : WeNotifyMsg.fromJson(json['push']),
      timeToBurn: json['timeToBurn'] == null ? 0 : json['timeToBurn'],
      burn: json['burn'] == null ? 0 : json['burn'],
      burnType: json['burnType'] == null ? 0 : json['burnType'],
      expiresStart: json['expiresStart'] == null ? 0 : json['expiresStart'],
    );
  }

  Map<String, dynamic> toJson() => {
        'seq': seq,
        'msgId': msgId,
        'preMessageId': preMessageId,
        'createTime': createTime,
        'withdrawTime': withdrawTime,
        'withdraw': withdraw,
        'sender': sender,
        'type': type?.value,
        'conversationId': conversationId,
        'event': event,
        'system': system,
        'at': at,
        'notReadCount': notReadCount,
        'notReceiverCount': notReceiverCount,
        'attrs': attrs,
        'text': text,
        'operator': operator,
        'name': name,
        'attributes': attributes,
        'passivityOperator': passivityOperator,
        'msgStatus': msgStatus.value,
        'reqId': reqId,
        'file': file?.toJson(),
        'push': push?.toJson(),
        'timeToBurn': timeToBurn,
        'burn': burn,
        'burnType': burnType,
        'expiresStart': expiresStart,
      };
}

class ChatAttrModel {
  String? senderName; //发送者姓名
  int? senderId; //发送者id
  String? avatar; // 头像
  String? text; //内容
  int? chatType; //内容类型
  int? lastTime; //最后一条消息时间
  bool? isGroup; //是否群聊
  String? sourceId; //音视频图片的sourceId
  double? duration; //时长
  String? cover; //视频第一帧

  String? redEnvelopeSessionId; //红包发送人的会话id
  String? redEnvelopesId; //红包操作ID 用来给其他人请求红包用
  String? redEnvelopesRemark; //红包备注
  int?
      redEnvelopesStatus; //红包状态  0-已创建，1-已发送，2-已领取，3-已过期"  "群红包状态，0-已创建，1-已发送，2-已全部领取，3-已过期，4-部分领取，5-部分领取，部分过期")
  int? redEnvelopesAcceptId; //红包领取者id  //单聊的红包有，群聊的没有
  int? redEnvelopesSendId; //红包发送者id
  String? tranferAmount; //转账金额
  String? tranferCcy; //转账单位
  int? recipient; //接受者  //
  //以下群聊专用
  int? redEnvelopesType; //群红包用 0  1  2
  String? redEnvelopesDst; //专属红包领取者ID

  String? localPath;

//  分享优惠券
//  int? couponTempId;
  String? modelJson;

  ChatAttrModel(
      {this.senderName,
      this.senderId,
      this.avatar,
      this.text,
      this.chatType,
      this.isGroup,
      this.lastTime,
      this.sourceId,
      this.duration,
      this.cover,
      this.redEnvelopeSessionId,
      this.redEnvelopesId,
      this.redEnvelopesRemark,
      this.redEnvelopesStatus,
      this.redEnvelopesAcceptId,
      this.redEnvelopesSendId,
      this.tranferAmount,
      this.tranferCcy,
      this.localPath,
      this.recipient,
      this.redEnvelopesType,
      this.redEnvelopesDst,
      // this.hasReceive,
      // this.totalNum
      this.modelJson});

  ChatAttrModel.fromJson(Map<String, dynamic> json) {
    if (json['senderName'] != null) {
      senderName = json['senderName'];
    }

    if (json['senderId'] != null) {
      if (json['senderId'] is String) {
        senderId = int.parse(json['senderId']);
      } else {
        senderId = json['senderId'];
      }
    }

    if (json['avatar'] != null) {
      avatar = json['avatar'];
    }
    if (json['text'] != null) {
      text = json['text'];
    }
    if (json['chatType'] != null) {
      if (json['chatType'] is String) {
        chatType = int.parse(json['chatType']);
      } else {
        chatType = json['chatType'];
      }
    }
    if (json['lastTime'] != null) {
      if (json['lastTime'] is String) {
        lastTime = int.parse(json['lastTime']);
      } else {
        lastTime = json['lastTime'];
      }
    }
    if (json['isGroup'] != null) {
      if (json['isGroup'] is String) {
        isGroup = json['isGroup'] == 'true' ? true : false;
      } else {
        isGroup = json['isGroup'];
      }
    }
    if (json['sourceId'] != null) {
      sourceId = json['sourceId'];
    }
    if (json['cover'] != null) {
      cover = json['cover'];
    }
    if (json['redEnvelopeSessionId'] != null) {
      redEnvelopeSessionId = json['redEnvelopeSessionId'];
    }

    if (json['duration'] != null) {
      if (json['duration'] != null) {
        if (json['duration'] is String || json['duration'] is int) {
          duration = double.parse(json['duration'].toString());
        } else {
          duration = json['duration'];
        }
      }
    }
    if (json['redEnvelopesId'] != null) {
      redEnvelopesId = json['redEnvelopesId'].toString();
    }
    if (json['redEnvelopesRemark'] != null) {
      redEnvelopesRemark = json['redEnvelopesRemark'];
    }
    if (json['redEnvelopesStatus'] != null) {
      if (json['redEnvelopesStatus'] != null) {
        if (json['redEnvelopesStatus'] is String) {
          redEnvelopesStatus = int.parse(json['redEnvelopesStatus'].toString());
        } else {
          redEnvelopesStatus = json['redEnvelopesStatus'];
        }
      }
    }
    if (json['redEnvelopesAcceptId'] != null) {
      if (json['redEnvelopesAcceptId'] is String) {
        redEnvelopesAcceptId = int.parse(json['redEnvelopesAcceptId']);
      } else {
        redEnvelopesAcceptId = json['redEnvelopesAcceptId'];
      }
    }

    if (json['redEnvelopesSendId'] != null) {
      if (json['redEnvelopesSendId'] is String) {
        redEnvelopesSendId = int.parse(json['redEnvelopesSendId']);
      } else {
        redEnvelopesSendId = json['redEnvelopesSendId'];
      }
    }
    if (json['tranferAmount'] != null) {
      tranferAmount = json['tranferAmount'];
    }
    if (json['tranferCcy'] != null) {
      tranferCcy = json['tranferCcy'];
    }
    if (json['recipient'] != null) {
      if (json['recipient'] is String) {
        recipient = int.parse(json['recipient']);
      } else {
        recipient = json['recipient'];
      }
    }
    if (json['redEnvelopesType'] != null) {
      if (json['redEnvelopesType'] is String) {
        redEnvelopesType = int.parse(json['redEnvelopesType']);
      } else {
        redEnvelopesType = json['redEnvelopesType'];
      }
    }
    if (json['redEnvelopesDst'] != null) {
      redEnvelopesDst = json['redEnvelopesDst'];
    }

    // if (json['couponTempId'] != null) {
    //   if (json['couponTempId'] is String) {
    //     couponTempId = int.parse(json['couponTempId']);
    //   } else {
    //     couponTempId = json['couponTempId'];
    //   }
    // }

    if (json['modelJson'] != null) {
      modelJson = json['modelJson'];
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['senderName'] = senderName;
    data['senderId'] = senderId;
    data['avatar'] = avatar;
    data['text'] = text;
    data['chatType'] = chatType;
    data['lastTime'] = lastTime;
    data['isGroup'] = isGroup;
    data['sourceId'] = sourceId;
    data['duration'] = duration;
    data['cover'] = cover;
    data['redEnvelopeSessionId'] = redEnvelopeSessionId;
    data['redEnvelopesId'] = redEnvelopesId;
    data['redEnvelopesRemark'] = redEnvelopesRemark;
    data['redEnvelopesStatus'] = redEnvelopesStatus;
    data['redEnvelopesAcceptId'] = redEnvelopesAcceptId;
    data['redEnvelopesSendId'] = redEnvelopesSendId;
    data['tranferAmount'] = tranferAmount;
    data['tranferCcy'] = tranferCcy;
    data['recipient'] = recipient;
    data['redEnvelopesType'] = redEnvelopesType;
    data['redEnvelopesDst'] = redEnvelopesDst;
    data['modelJson'] = modelJson;
    // data['hasReceive'] = hasReceive;
    // data['totalNum'] = totalNum;
    return data;
  }
}
