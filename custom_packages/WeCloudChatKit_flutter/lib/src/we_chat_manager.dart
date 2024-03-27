import 'package:flutter/services.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter/src/model/we_error.dart';
import 'package:wecloudchatkit_flutter/src/model/we_message.dart';
import 'package:wecloudchatkit_flutter/src/we_listeners.dart';
import 'package:wecloudchatkit_flutter/src/we_sdk_method_key.dart';

import 'tools/we_extension.dart';

class WeChatManager implements MessageStatusListener {
  static const _channelPrefix = 'cn.wecloud.im';

  static const MethodChannel _channel =
      const MethodChannel('$_channelPrefix/chat_manager', JSONMethodCodec());

  static WeChatManager? _instance;

  static WeChatManager get getInstance =>
      _instance = _instance ?? WeChatManager._internal();

  WeChatManager._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case WeSDKMethodKey.onMessageSendFail:
          return _onMessageSendFail(call.arguments);
        case WeSDKMethodKey.onMessageStatusUpdate:
          return _onMessageStatusUpdate(WeMessage.fromJson(call.arguments));
        case WeSDKMethodKey.onMessageReceived:
          return _onMessageReceived(WeMessage.fromJson(call.arguments));
        case WeSDKMethodKey.OnConvSyncStatusComplete:
          return _onConvSyncComplete();
        // case WeSDKMethodKey.onDefaultMsgBeforeSendHandler:
        //   return _onDefaultMsgBeforeSendHandler(call.arguments);
        // case WeSDKMethodKey.onDefaultMsgBeforeReceiveHandler:
        //   return _onDefaultMsgBeforeReceiveHandler(call.arguments);
      }
      return null;
    });
  }

  final List<MessageReceivedListener> _messageReceivedListeners = [];
  Map<String, WeMessage> cacheMessageMap = {};

  ///发送消息
  Future<bool?> sendMessage(WeMessage message) async {
    if (message.statusListener == null) {
      message.statusListener = this;
    }
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.sendMessage, {"message": message});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.sendMessage);
    } on WeError catch (e) {
      throw e;
    }
  }

  ///插入消息到数据库
  Future<bool?> insertMessageDB(WeMessage message) async {
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.insertMessageDB, {"message": message});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.insertMessageDB);
    } on WeError catch (e) {
      throw e;
    }
  }

  ///更新消息的文件的本地路径
  Future<bool?> updateMessageFileLocPath(int msgId, String localPath) async {
    Map result =
        await _channel.invokeMethod(WeSDKMethodKey.updateMessageFileLocPath, {
      "msgId": msgId,
      "localPath": localPath,
    });
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.updateMessageFileLocPath);
    } on WeError catch (e) {
      throw e;
    }
  }

  ///更新消息的属性
  Future<bool?> updateMessageAttrs(
      int msgId, Map<String, dynamic>? attrs) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.updateMessageAttrs, {"msgId": msgId, "attrs": attrs});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.updateMessageAttrs);
    } on WeError catch (e) {
      throw e;
    }
  }

  ///同步离线消息
  @Deprecated("Use `testUpgrade()` method instead")
  Future<bool?> syncOfflineMessages(int conversationId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.syncOfflineMessages, {"conversationId": conversationId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.syncOfflineMessages);
    } on WeError catch (e) {
      throw e;
    }
  }

  ///查询历史消息
  Future<List<WeMessage>?> findHistMsg(
      int conversationId, WeMessage? lastMsg, int pageSize) async {
    //lastMsg.attrModel 只能赋值为null 否则报IllegalStateException
    Map result = await _channel.invokeMethod(WeSDKMethodKey.findHistMsg, {
      "conversationId": conversationId,
      "lastMsg": lastMsg,
      "pageSize": pageSize
    });
    try {
      WeError.hasError(result);
      List<WeMessage> list = [];
      result[WeSDKMethodKey.findHistMsg]?.forEach((element) {
        // print('findHistMsgItem: ${jsonEncode(element)}');
        list.add(WeMessage.fromJson(element));
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  ///查询本地所有聊天记录
  Future<List<WeMessage>?> findMessageFromHistory(int conversationId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.findMessageFromHistory,
        {"conversationId": conversationId});
    try {
      WeError.hasError(result);
      List<WeMessage> list = [];
      result[WeSDKMethodKey.findMessageFromHistory]?.forEach((element) {
        list.add(WeMessage.fromJson(element));
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  ///通过时间查询聊天记录
  Future<List<WeMessage>?> findMessageFromHistoryByTime(
      int conversationId, int endTime) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.findMessageFromHistoryByTime,
        {"conversationId": conversationId, "endTime": endTime});
    try {
      WeError.hasError(result);
      List<WeMessage> list = [];
      result[WeSDKMethodKey.findMessageFromHistoryByTime]?.forEach((element) {
        list.add(WeMessage.fromJson(element));
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  Future<dynamic> _onMessageSendFail(Map arg) async {
    String reqId = arg["reqId"] as String;
    int errCode = arg["errCode"] as int;
    WeMessage? msg = cacheMessageMap[reqId];
    msg?.statusListener?.onMessageSendFail(reqId, errCode);
  }

  MessageEventListener? _onMessageEventListener;

  registMessageEventListener(MessageEventListener listener) {
    _onMessageEventListener = listener;
  }

  unregistMessageEventListener() {
    _onMessageEventListener = null;
  }

  Future<dynamic> _onMessageStatusUpdate(WeMessage weMessage) async {
    WeMessage? msg = cacheMessageMap[weMessage.reqId];
    msg?.statusListener?.onMessageStatusUpdate(weMessage);

    _onMessageEventListener?.onMessageEvent(weMessage.msgStatus, weMessage);
  }

  Future<dynamic> _onMessageReceived(WeMessage weMessage) async {
    // if (weMessage.sender == WeClient.clientId)
    //   return;
    for (var listener in _messageReceivedListeners) {
      try {
        listener.onMessagesReceived(weMessage);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<dynamic> _onConvSyncComplete() async {
    for (var listener in _convSyncStatusListeners) {
      try {
        listener.onConvSyncStatusListener();
      } catch (e) {
        print(e);
      }
    }
  }

  // MessageBeforeHandler? _msgBeforeSendHandler;
  // MessageBeforeHandler? _msgBeforeReceiveHandler;

  // set msgBeforeReceiveHandler(MessageBeforeHandler value) {
  //   _msgBeforeReceiveHandler = value;
  // }

  // set msgBeforeSendHandler(MessageBeforeHandler value) {
  //   _msgBeforeSendHandler = value;
  // }

  // Future<Map> _onDefaultMsgBeforeSendHandler(Map arg) async {
  //   WeConversation conversation = WeConversation.fromJson(arg["conversation"]);
  //   WeMessage message = WeMessage.fromJson(arg["message"]);
  //   WeMessage newMsg =
  //       _msgBeforeSendHandler?.onMessagesHandler(conversation, message) ??
  //           message;
  //   return {"message": newMsg};
  // }
  //
  // Future<Map> _onDefaultMsgBeforeReceiveHandler(Map arg) async {
  //   WeConversation conversation = WeConversation.fromJson(arg["conversation"]);
  //   WeMessage message = WeMessage.fromJson(arg["message"]);
  //   WeMessage newMsg =
  //       _msgBeforeReceiveHandler?.onMessagesHandler(conversation, message) ??
  //           message;
  //   return {"message": newMsg};
  // }

  /// 添加接收消息监听 [listener]
  void addReceivedListener(MessageReceivedListener listener) {
    _messageReceivedListeners.add(listener);
  }

  void removeReceivedListener(MessageReceivedListener listener) {
    if (_messageReceivedListeners.contains(listener)) {
      _messageReceivedListeners.remove(listener);
    }
  }

  addMsgStatusUpdateListener(WeMessage message) {
    cacheMessageMap[message.reqId ?? ""] = message;
  }

  removeMsgStatusUpdateListener(WeMessage message) {
    if (cacheMessageMap.containsKey(message.reqId ?? "")) {
      cacheMessageMap.remove(message.reqId ?? "");
    }
  }

  @override
  void onMessageStatusUpdate(WeMessage message) {}

  @override
  void onMessageSendFail(String reqId, int errCode) {}

  final List<OnConvSyncStatusListener> _convSyncStatusListeners = [];

  void addOnConvSyncStatusListener(OnConvSyncStatusListener listener) {
    _convSyncStatusListeners.add(listener);
  }

  void removeOnConvSyncStatusListener(OnConvSyncStatusListener listener) {
    if (_convSyncStatusListeners.contains(listener)) {
      _convSyncStatusListeners.remove(listener);
    }
  }
}
