import 'package:wecloudchatkit_flutter/src/model/we_conv_event.dart';
import 'package:wecloudchatkit_flutter/src/model/we_conversation.dart';
import 'package:wecloudchatkit_flutter/src/model/we_message.dart';
import 'package:wecloudchatkit_flutter/src/model/we_rtc_event.dart';
import 'package:wecloudchatkit_flutter/src/model/we_transpart_msg_event.dart';

abstract class SingleRTCListener {
  void processCallEvent(WeRTCEvent rtcEvent);

  void processJoinEvent(WeRTCEvent rtcEvent);

  void processLeaveEvent(WeRTCEvent rtcEvent);

  void processRejectEvent(WeRTCEvent rtcEvent);

  void processSdpEvent(WeRTCEvent rtcEvent);

  void processCandidateEvent(WeRTCEvent rtcEvent);
}

///好友事件
abstract class FriendEventListener {
  ///申请好友的事件
  void onApplyFriendEvent(String friendClientId, String requestRemark);

  ///发出请求的审批结果
  void onApproveFriendEvent(
      String friendClientId, bool agree, String rejectRemark);
}

///消息状态事件
abstract class MessageStatusListener {
  //消息状态的改变WeMessageStatus
  void onMessageStatusUpdate(WeMessage message) {}

  //消息发送失败
  void onMessageSendFail(String reqId, int errCode) {}
}

///消息事件
abstract class MessageEventListener {
  //消息状态的改变WeMessageStatus
  void onMessageEvent(WeMessageStatus status, WeMessage message) {}
}

///消息接收事件
abstract class MessageReceivedListener {
  /// 收到消息
  void onMessagesReceived(WeMessage message) {}
}

///会话事件
abstract class ConversationListener {
  void onConversationEvent(WeConvEvent convEvent) {}

  //会话添加
  void onAddConversation(WeConversation conversation) {}

  //会话删除
  void onRemoveConversation(int conversationId) {}
}

enum ConvUpdateEvent {
  WITHDRAW_LAST_MSG, //撤回最后一条消息
  REFRESH_CONVERSATION, //刷新会话
}

extension ConvUpdateEventValue on ConvUpdateEvent {
  String get value {
    String ret = "refreshConversation";
    switch (this) {
      case ConvUpdateEvent.WITHDRAW_LAST_MSG:
        ret = "withdrawLastMsg";
        break;
      case ConvUpdateEvent.REFRESH_CONVERSATION:
        ret = "refreshConversation";
        break;
    }
    return ret;
  }

  static ConvUpdateEvent eventFromString(String? event) {
    ConvUpdateEvent ret = ConvUpdateEvent.REFRESH_CONVERSATION;
    switch (event) {
      case "withdrawLastMsg":
        ret = ConvUpdateEvent.WITHDRAW_LAST_MSG;
        break;
      case "refreshConversation":
        ret = ConvUpdateEvent.REFRESH_CONVERSATION;
        break;
    }
    return ret;
  }
}

abstract class ConversationUpdateListener {
  //会话更新（未读数，是否@等服务器返回数据变化时）
  void onUpdateConversation(
      ConvUpdateEvent event, WeConversation conversation) {}
}

///消息接收事件
abstract class MessageBeforeHandler {
  /// 收到消息
  WeMessage onMessagesHandler(WeConversation conversation, WeMessage message);
}

abstract class TotalNotReadCountChangeListener {
  void onTotalNotReadCountChangeListener(int totalNotReadCount);
}

abstract class OnConvSyncStatusListener {
  void onConvSyncStatusListener();
}

abstract class OnTransparentMsgEventListener {
  void onTransparentMsgEventListener(WeTransparentEvent transparentEvent);
}

abstract class OnSDKConnEventListener {
  void onSDKConnEventListener(String status);
}
