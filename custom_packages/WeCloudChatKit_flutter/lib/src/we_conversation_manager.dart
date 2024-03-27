import 'package:flutter/services.dart';
import 'package:wecloudchatkit_flutter/src/model/we_member_info.dart';
import 'package:wecloudchatkit_flutter/src/model/we_conv_event.dart';
import 'package:wecloudchatkit_flutter/src/model/we_conversation.dart';
import 'package:wecloudchatkit_flutter/src/model/we_error.dart';
import 'package:wecloudchatkit_flutter/src/we_listeners.dart';
import 'package:wecloudchatkit_flutter/src/we_sdk_method_key.dart';
import 'tools/we_extension.dart';

class WeConversationManager {
  static const _channelPrefix = 'cn.wecloud.im';

  static const MethodChannel _channel = const MethodChannel(
      '$_channelPrefix/conversation_manager', JSONMethodCodec());

  static WeConversationManager? _instance;

  static WeConversationManager get getInstance =>
      _instance = _instance ?? WeConversationManager._internal();

  WeConversationManager._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case WeSDKMethodKey.onConversationEvent:
          return _onConversationEvent(WeConvEvent.fromJson(call.arguments));
        case WeSDKMethodKey.onUpdateConversation:
          return _onUpdateConversation(call.arguments);
        case WeSDKMethodKey.onAddConversation:
          return _onAddConversation(WeConversation.fromJson(call.arguments));
        case WeSDKMethodKey.onRemoveConversation:
          return _onRemoveConversation(call.arguments as int);
        case WeSDKMethodKey.onTotalNotReadCountChangeListener:
          return _onTotalNotReadCountChangeListener(call.arguments as int);
      }
      return null;
    });
  }

  final List<ConversationListener> _conversationListeners = [];
  Map<int, WeConversation> cacheConversationMap = {};

  //会话事件
  Future<void> _onConversationEvent(WeConvEvent convEvent) async {
    for (var listener in _conversationListeners) {
      listener.onConversationEvent(convEvent);
    }
  }

  //会话更新（未读数，是否@等服务器返回数据变化时）
  Future<void> _onUpdateConversation(Map arg) async {
    WeConversation conversation = WeConversation.fromJson(arg["conversation"]);
    ConvUpdateEvent event = ConvUpdateEventValue.eventFromString(arg["event"]);

    WeConversation? conv = cacheConversationMap[conversation.id];
    conv?.updateListener?.onUpdateConversation(event, conversation);

    _updateListener?.onUpdateConversation(event, conversation);
  }

  ConversationUpdateListener? _updateListener;

  registConversationUpdateListener(ConversationUpdateListener listener) {
    _updateListener = listener;
  }

  unregistConversationUpdateListener() {
    _updateListener = null;
  }

  addConvUpdateListener(WeConversation conversation) {
    cacheConversationMap[conversation.id] = conversation;
  }

  removeConvUpdateListener(WeConversation conversation) {
    if (cacheConversationMap.containsKey(conversation.id)) {
      cacheConversationMap.remove(conversation.id);
    }
  }

  //会话添加
  Future<void> _onAddConversation(WeConversation conversation) async {
    for (var listener in _conversationListeners) {
      listener.onAddConversation(conversation);
    }
  }

  //会话删除
  Future<void> _onRemoveConversation(int conversationId) async {
    for (var listener in _conversationListeners) {
      listener.onRemoveConversation(conversationId);
    }
  }

  void addConversationListener(ConversationListener listener) {
    _conversationListeners.add(listener);
  }

  void removeConversationListener(ConversationListener listener) {
    if (_conversationListeners.contains(listener)) {
      _conversationListeners.remove(listener);
    }
  }

  //更新本地会话的名字
  Future<bool?> updateNameFromLocal(int conversationId, String name) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.updateNameFromLocal,
        {"conversationId": conversationId, "name": name});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.updateNameFromLocal);
    } on WeError catch (e) {
      throw e;
    }
  }

  //更新本地会话的头像
  Future<bool?> updateHeadPortraitFromLocal(
      int conversationId, String headPortrait) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.updateHeadPortraitFromLocal,
        {"conversationId": conversationId, "headPortrait": headPortrait});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.updateHeadPortraitFromLocal);
    } on WeError catch (e) {
      throw e;
    }
  }

  //添加会话成员
  Future<bool?> addMember(int conversationId, List<String> addMembers) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.addMember,
        {"conversationId": conversationId, "addMembers": addMembers});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.addMember);
    } on WeError catch (e) {
      throw e;
    }
  }

  //删除会话成员
  Future<bool?> delMember(int conversationId, List<String> delMembers) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.delMember,
        {"conversationId": conversationId, "delMembers": delMembers});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.delMember);
    } on WeError catch (e) {
      throw e;
    }
  }

  //查询本会话的成员
  Future<List<WeMemberInfo>?> searchConvMembers(int conversationId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.searchConvMembers, {"conversationId": conversationId});
    try {
      WeError.hasError(result);
      List<WeMemberInfo> list = [];
      result[WeSDKMethodKey.searchConvMembers]?.forEach((element) {
        list.add(WeMemberInfo.fromJson(element));
      });
      return list;
    } on WeError catch (e) {
      throw e;
    }
  }

  //添加或修改会话的拓展字段
  Future<bool?> updateConversationAttr(
      int conversationId, Map<String, dynamic> attributes) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.updateConversationAttr,
        {"conversationId": conversationId, "attributes": attributes});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.updateConversationAttr);
    } on WeError catch (e) {
      throw e;
    }
  }

  //修改群名字 (群主可用)
  Future<bool?> updateConversationName(
      int conversationId, String groupName) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.updateConversationName,
        {"conversationId": conversationId, "groupName": groupName});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.updateConversationName);
    } on WeError catch (e) {
      throw e;
    }
  }

  //修改群昵称
  Future<bool?> updateConvMemberRemark(
      int conversationId, String remarkName) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.updateConvMemberRemark,
        {"conversationId": conversationId, "remarkName": remarkName});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.updateConvMemberRemark);
    } on WeError catch (e) {
      throw e;
    }
  }

  //设置群禁言
  Future<bool?> setGroupMuted(int conversationId, bool isMuted) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.setGroupMuted,
        {"conversationId": conversationId, "isMuted": isMuted});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.setGroupMuted);
    } on WeError catch (e) {
      throw e;
    }
  }

  //设置群禁言
  Future<bool?> saveDraft(int conversationId, String draftJson) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.saveDraft,
        {"conversationId": conversationId, "draftJson": draftJson});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.saveDraft);
    } on WeError catch (e) {
      throw e;
    }
  }

  //群解散状态
  Future<bool?> setDisband(int conversationId, bool disband) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.setDisband,
        {"conversationId": conversationId, "disband": disband});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.setDisband);
    } on WeError catch (e) {
      throw e;
    }
  }

  Future<bool?> syncGroupMembers(int conversationId) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.syncGroupMembers, {"conversationId": conversationId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.syncGroupMembers);
    } on WeError catch (e) {
      throw e;
    }
  }

  //更新会话（更新数据库中此会话）
  Future<bool?> onUpdateConversationFromDB(WeConversation conversation) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.onUpdateConversationFromDB,
        {"conversation": conversation});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.onUpdateConversationFromDB);
    } on WeError catch (e) {
      throw e;
    }
  }

  TotalNotReadCountChangeListener? _totalNotReadCountChangeListener;

  set totalNotReadCountChangeListener(TotalNotReadCountChangeListener? value) {
    _totalNotReadCountChangeListener = value;
  }

  Future<void> _onTotalNotReadCountChangeListener(int totalNotReadCount) async {
    _totalNotReadCountChangeListener
        ?.onTotalNotReadCountChangeListener(totalNotReadCount);
  }
}
