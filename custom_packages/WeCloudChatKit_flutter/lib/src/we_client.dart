import 'package:flutter/services.dart';
import 'package:wecloudchatkit_flutter/src/model/we_chat_room_member.dart';
import 'package:wecloudchatkit_flutter/src/model/we_client_info.dart';
import 'package:wecloudchatkit_flutter/src/model/we_conversation.dart';
import 'package:wecloudchatkit_flutter/src/model/we_message.dart';
import 'package:wecloudchatkit_flutter/src/model/we_transpart_msg_event.dart';
import 'package:wecloudchatkit_flutter/src/we_chat_manager.dart';
import 'package:wecloudchatkit_flutter/src/we_friend_manager.dart';
import 'package:wecloudchatkit_flutter/src/we_conversation_manager.dart';
import 'package:wecloudchatkit_flutter/src/we_sdk_method_key.dart';
import 'package:wecloudchatkit_flutter/src/we_single_rtc_manager.dart';
import 'model/we_push_channel.dart';
import 'tools/we_extension.dart';

import 'package:wecloudchatkit_flutter/src/we_listeners.dart';

import 'model/we_error.dart';

class WeClient {
  static String clientId = "";
  static String token = "";
  static const _channelPrefix = 'cn.wecloud.im';

  static const MethodChannel _channel =
      const MethodChannel('$_channelPrefix/chat_client', JSONMethodCodec());

  static WeClient? _instance;

  static WeClient get getInstance =>
      _instance = _instance ?? WeClient._internal();

  WeClient._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      print("method:" + call.method);
      print("onSDKConnEventListener:" + call.arguments);
      switch (call.method) {
        case WeSDKMethodKey.onTransparentMessageEvent:
          return _onTransparentEvent(
              WeTransparentEvent.fromJson(call.arguments));
        case WeSDKMethodKey.onSDKConnEvent:
          print("onSDKConnEventListener:" + call.arguments);
          return _onSDKConnEvent(call.arguments as String);
      }
      return null;
    });
  }

  final List<OnSDKConnEventListener> _onSDKConnEventListener = [];

  void addOnSDKConnEventListener(OnSDKConnEventListener listener) {
    _onSDKConnEventListener.add(listener);
  }

  void removeOnSDKConnEventListener(OnSDKConnEventListener listener) {
    if (_onSDKConnEventListener.contains(listener)) {
      _onSDKConnEventListener.remove(listener);
    }
  }

  final List<OnTransparentMsgEventListener> _onTransparentMsgEventListener = [];

  void addOnTransparentMsgEventListener(
      OnTransparentMsgEventListener listener) {
    _onTransparentMsgEventListener.add(listener);
  }

  void removeOnTransparentMsgEventListener(
      OnTransparentMsgEventListener listener) {
    if (_onTransparentMsgEventListener.contains(listener)) {
      _onTransparentMsgEventListener.remove(listener);
    }
  }

  WeFriendManager get friendManager {
    return WeFriendManager.getInstance;
  }

  WeConversationManager get conversationManager {
    return WeConversationManager.getInstance;
  }

  WeChatManager get chatManager {
    return WeChatManager.getInstance;
  }

  WeSingRtcManager get singleRtcManager {
    return WeSingRtcManager.getInstance;
  }

  Future<dynamic> _onTransparentEvent(
      WeTransparentEvent transparentEvent) async {
    // if (weMessage.sender == WeClient.clientId)
    //   return;
    for (var listener in _onTransparentMsgEventListener) {
      try {
        listener.onTransparentMsgEventListener(transparentEvent);
      } catch (e) {
        print(e);
      }
    }
  }

  //初始化
  Future<bool?> initialize(String httpUrl, String wsUrl) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.initialize, {"httpUrl": httpUrl, "wsUrl": wsUrl});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.initialize);
    } on WeError catch (e) {
      throw e;
    }
  }

  //模块是否已登录
  Future<bool?> isLogin() async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.isLogin);
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.isLogin);
    } on WeError catch (e) {
      throw e;
    }
  }

  //登录且开启模块
  Future<String?> loginAndOpen(String clientId, String appKey, String timestamp,
      String sign, int platform) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.loginAndOpen, {
      "clientId": clientId,
      "appKey": appKey,
      "timestamp": timestamp,
      "sign": sign,
      "platform": platform
    });
    try {
      WeError.hasError(result);
      if (result[WeSDKMethodKey.loginAndOpen] != null) {
        var map = result[WeSDKMethodKey.loginAndOpen];
        WeClient.token = map["token"];
        WeClient.clientId = map["clientId"];
      }
      return WeClient.token;
    } on WeError catch (e) {
      throw e;
    }
  }

  //开启模块
  Future<String?> open() async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.open);
    try {
      WeError.hasError(result);
      if (result[WeSDKMethodKey.open] != null) {
        var map = result[WeSDKMethodKey.open];
        WeClient.token = map["token"];
        WeClient.clientId = map["clientId"];
      }
      return WeClient.token;
    } on WeError catch (e) {
      throw e;
    }
  }

  //开启模块
  Future<bool?> openModel(String clientId, String appKey, String token) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.openModel, {
      "clientId": clientId,
      "appKey": appKey,
      "token": token,
    });
    try {
      WeError.hasError(result);
      WeClient.token = token;
      WeClient.clientId = clientId;
      return result.boolValue(WeSDKMethodKey.openModel);
    } on WeError catch (e) {
      throw e;
    }
  }

  //关闭模块
  Future<bool?> close() async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.close);
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.close);
    } on WeError catch (e) {
      throw e;
    }
  }

  //添加或修改推送设备信息
  Future<bool?> updateDeviceInfo(
      PushChannel pushChannel, int valid, String deviceToken) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.updateDeviceInfo, {
      "pushChannel": pushChannel.value,
      "valid": valid,
      "deviceToken": deviceToken
    });
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.updateDeviceInfo);
    } on WeError catch (e) {
      throw e;
    }
  }

  Future<String?> onDeviceToken() async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.onDeviceToken);
    try {
      WeError.hasError(result);
      if (result[WeSDKMethodKey.onDeviceToken] != null) {
        var map = result[WeSDKMethodKey.onDeviceToken];
        return map['deviceToken'];
      }
      return '';
    } on WeError catch (e) {
      throw e;
    }
  }

  //创建会话
  //如果创建聊天室，platform参数为必传
  Future<WeConversation?> createConversation(List<String>? clientIds,
      String? name, String? attributes, WeConversationType chatType,
      {int? platform, bool isEncrypt = false}) async {
    Map result =
        await _channel.invokeMethod(WeSDKMethodKey.createConversation, {
      if (clientIds != null) "clientIds": clientIds,
      if (name != null) "name": name,
      if (attributes != null) "attributes": attributes,
      if (platform != null) "platform": platform,
      "chatType": chatType.value,
      "isEncrypt": isEncrypt
    });
    try {
      WeError.hasError(result);
      WeConversation? ret;
      if (result[WeSDKMethodKey.createConversation] != null) {
        ret =
            WeConversation.fromJson(result[WeSDKMethodKey.createConversation]);
      }
      return ret;
    } on WeError catch (e) {
      throw e;
    }
  }

  //加入聊天室
  Future<bool?> joinChatRoom(
      int chatRoomId, String clientId, int platform) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.joinChatRoom,
        {"chatRoomId": chatRoomId, "clientId": clientId, "platform": platform});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.joinChatRoom);
    } on WeError catch (e) {
      throw e;
    }
  }

  //退出聊天室
  Future<bool?> exitChatRoom(
      int chatRoomId, String clientId, int platform) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.exitChatRoom,
        {"chatRoomId": chatRoomId, "clientId": clientId, "platform": platform});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.exitChatRoom);
    } on WeError catch (e) {
      throw e;
    }
  }

  //查询聊天室成员
  Future<List<WeChatRoomMember>?> findChatRoomMembers(int chatRoomId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.findChatRoomMembers, {"chatRoomId": chatRoomId});
    try {
      WeError.hasError(result);
      List<WeChatRoomMember> list = [];
      result[WeSDKMethodKey.findChatRoomMembers]?.forEach((element) {
        list.add(WeChatRoomMember.fromJson(element));
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  Future<WeConversation?> findConversationById(int conversationId,
      {int? chatType}) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.findConversationById,
        {"conversationId": conversationId, 'chatType': chatType});
    try {
      WeError.hasError(result);
      WeConversation? ret;
      if (result[WeSDKMethodKey.findConversationById] != null) {
        ret = WeConversation.fromJson(
            result[WeSDKMethodKey.findConversationById]);
      }
      return ret;
    } on WeError catch (e) {
      throw e;
    }
  }

  //解散群聊
  Future<bool?> disbandConversation(int conversationId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.disbandConversation, {"conversationId": conversationId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.disbandConversation);
    } on WeError catch (e) {
      throw e;
    }
  }

  //询加入的会话
  Future<List<WeConversation>?> searchDisplayConversationList() async {
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.searchDisplayConversationList);
    try {
      WeError.hasError(result);
      List<WeConversation> list = [];
      var res = result[WeSDKMethodKey.searchDisplayConversationList];
      res?.forEach((element) {
        list.add(WeConversation.fromJson(element));
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  //查询会话中指定类型的消息
  Future<List<WeMessage>?> findConvMsgByType(
      int conversationId, List<int> types) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.findConvMsgByType,
        {"conversationId": conversationId, "types": types});
    try {
      WeError.hasError(result);
      List<WeMessage> list = [];
      result[WeSDKMethodKey.findConvMsgByType]?.forEach((element) {
        list.add(WeMessage.fromJson(element));
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  //查询本地所有会话，包含隐藏的
  Future<List<WeConversation>?> searchGroupConversations() async {
    Map result =
        await _channel.invokeMethod(WeSDKMethodKey.searchGroupConversations);
    try {
      WeError.hasError(result);
      List<WeConversation> list = [];
      result[WeSDKMethodKey.searchGroupConversations]?.forEach((element) {
        list.add(WeConversation.fromJson(element));
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  //显示或隐藏会话
  Future<bool?> displayConversation(
      List<int> conversationIds, bool displayStatus) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.displayConversation,
        {"conversationIds": conversationIds, "displayStatus": displayStatus});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.displayConversation);
    } on WeError catch (e) {
      throw e;
    }
  }

  //删除会话(逻辑删除，隐藏会话并删除会话中的所有消息)
  Future<bool?> deleteConversations(List<int> conversationIds) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.deleteConversations,
        {"conversationIds": conversationIds});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.deleteConversations);
    } on WeError catch (e) {
      throw e;
    }
  }

  //删除会话（删除数据库中关于此会话的所有数据）
  Future<bool?> deleteConversationFromDB(int conversationIds) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.deleteConversationFromDB,
        {"conversationId": conversationIds});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.deleteConversationFromDB);
    } on WeError catch (e) {
      throw e;
    }
  }

  //退出会话
  Future<bool?> leaveConv(int conversationId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.leaveConv, {"conversationId": conversationId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.leaveConv);
    } on WeError catch (e) {
      throw e;
    }
  }

  //设置群管理员
  Future<bool?> setupConvAdmins(int conversationId, List<String> clientIds,
      ConvAdminType operateType) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.setupConvAdmins, {
      "conversationId": conversationId,
      "clientIds": clientIds,
      "operateType": operateType.value
    });
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.setupConvAdmins);
    } on WeError catch (e) {
      throw e;
    }
  }

  //群主转让
  Future<bool?> convTransferOwner(int conversationId, String clientId) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.convTransferOwner, {
      "conversationId": conversationId,
      "clientId": clientId,
    });
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.convTransferOwner);
    } on WeError catch (e) {
      throw e;
    }
  }

  //群成员禁言
  Future<bool?> convMutedGroupMenber(
      int conversationId, List<String> clientIds, bool isMuted) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.convMutedGroupMenber, {
      "conversationId": conversationId,
      "clientIds": clientIds,
      "isMuted": isMuted
    });
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.convMutedGroupMenber);
    } on WeError catch (e) {
      throw e;
    }
  }

  //撤回消息
  Future<bool?> withdrawMsg(WeMessage message) async {
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.withdrawMsg, {"message": message});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.withdrawMsg);
    } on WeError catch (e) {
      throw e;
    }
  }

  //撤回消息
  Future<bool?> deleteMsgAndNetwork(List<WeMessage> messages) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.deleteMsgAndNetwork, {"messages": messages});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.deleteMsgAndNetwork);
    } on WeError catch (e) {
      throw e;
    }
  }

  //删除会话的所有消息(只删除本地数据库)
  Future<bool?> deleteAllMsgByConvId(int conversationId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.deleteAllMsgByConvId,
        {"conversationId": conversationId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.deleteAllMsgByConvId);
    } on WeError catch (e) {
      throw e;
    }
  }

  //删除指定的消息
  Future<bool?> deleteAllMsg(List<WeMessage> messages) async {
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.deleteAllMsg, {"messages": messages});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.deleteAllMsg);
    } on WeError catch (e) {
      throw e;
    }
  }

  /// 设置在当前会话的已读位置和已接收位置标记
  ///
  /// @param conversationId 会话id
  /// @param lastReadMsgId  会话消息改为已读的最后一条消息Id
  /// @param isUnread       是否吧会话标记为未读 false 改为已读  true改为未读
  /// @param needCount      是否需要返回未读数据（尽量传false）
  /// @param isMessageRead  是否需要下发已读透传，根据个人的已读回执设置决定，true下发，false不下发
  /// @param callback
  Future<bool?> msgReadUpdate2(
    int conversationId,
    int lastReadMsgId,
    bool isUnread,
    bool needCount,
    bool isMessageRead,
  ) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.msgReadUpdate, {
      "conversationId": conversationId,
      "lastReadMsgId": lastReadMsgId,
      "isUnread": isUnread,
      "needCount": needCount,
      "isMessageRead": isMessageRead
    });
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.msgReadUpdate);
    } on WeError catch (e) {
      throw e;
    }
  }

  //消息已读回执
  Future<bool?> msgReadUpdate(List<int> messageIds) async {
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.msgReadUpdate, {"messageIds": messageIds});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.msgReadUpdate);
    } on WeError catch (e) {
      throw e;
    }
  }

  //把会话中msgIdEnd之前所有消息更新为已读
  Future<bool?> msgReadAllConvUpdate(int conversationId, int lastMsgId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.msgReadAllConvUpdate,
        {"conversationId": conversationId, "lastMsgId": lastMsgId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.msgReadAllConvUpdate);
    } on WeError catch (e) {
      throw e;
    }
  }

  //把会话中msgIdEnd之前所有消息更新为已读
  Future<WeMessage?> findMessage(int messageId) async {
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.findMessage, {"messageId": messageId});
    try {
      WeError.hasError(result);
      WeMessage? ret;
      if (result[WeSDKMethodKey.findMessage] != null) {
        ret = WeMessage.fromJson(result[WeSDKMethodKey.findMessage]);
      }
      return ret;
    } on WeError catch (e) {
      throw e;
    }
  }

  //拉入黑名单
  Future<bool?> addBlacklist(String userClientId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.addBlacklist, {"userClientId": userClientId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.addBlacklist);
    } on WeError catch (e) {
      throw e;
    }
  }

  //移除黑名单
  Future<bool?> delBlacklist(String userClientId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.delBlacklist, {"userClientId": userClientId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.delBlacklist);
    } on WeError catch (e) {
      throw e;
    }
  }

  //黑名单分页列表
  Future<List<String>?> findBlacklist(int pageIndex, int pageSize) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.findBlacklist,
        {"pageIndex": pageIndex, "pageSize": pageSize});
    try {
      WeError.hasError(result);
      List<String> list = [];
      result[WeSDKMethodKey.findBlacklist]?.forEach((element) {
        list.add(element as String);
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  //查询群用户信息
  Future<List<WeGroupUserInfo>?> findGroupInfoList(
      int conversationId, List<String> clientInfos) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.findGroupInfoList,
        {"conversationId": conversationId, "clientInfos": clientInfos});
    try {
      WeError.hasError(result);
      List<WeGroupUserInfo> list = [];
      result[WeSDKMethodKey.findGroupInfoList]?.forEach((element) {
        list.add(WeGroupUserInfo.fromJson(element));
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  Future<dynamic> _onSDKConnEvent(String status) async {
    for (var listener in _onSDKConnEventListener) {
      try {
        listener.onSDKConnEventListener(status);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String?> getConnectingStatus() async {
    Map result =
        await _channel.invokeMethod(WeSDKMethodKey.getConnectingStatus);
    try {
      WeError.hasError(result);
      String status = result[WeSDKMethodKey.getConnectingStatus] as String;
      return status;
    } on WeError catch (e) {
      throw e;
    }
  }
}
