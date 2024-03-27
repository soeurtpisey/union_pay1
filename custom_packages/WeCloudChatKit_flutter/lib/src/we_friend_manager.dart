import 'package:flutter/services.dart';
import 'package:wecloudchatkit_flutter/src/model/we_error.dart';
import 'package:wecloudchatkit_flutter/src/we_listeners.dart';
import 'package:wecloudchatkit_flutter/src/we_sdk_method_key.dart';
import 'tools/we_extension.dart';

class WeFriendManager {
  static const _channelPrefix = 'cn.wecloud.im';

  static const MethodChannel _channel =
      const MethodChannel('$_channelPrefix/friend_manager', JSONMethodCodec());

  static WeFriendManager? _instance;

  static WeFriendManager get getInstance =>
      _instance = _instance ?? WeFriendManager._internal();

  WeFriendManager._internal(){
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case WeSDKMethodKey.onApplyFriendEvent:
          return _onApplyFriend(call.arguments);
        case WeSDKMethodKey.onApproveFriendEvent:
          return _onApproveFriend(call.arguments);
      }
      return null;
    });
  }

  final List<FriendEventListener> _friendEventListeners = [];

  Future<void> _onApplyFriend(Map arg) async {
    String friendClientId = arg["friendClientId"] as String;
    String requestRemark = arg["requestRemark"] as String;
    //事件下发

    for (var listener in _friendEventListeners) {
      listener.onApplyFriendEvent(friendClientId, requestRemark);
    }
  }

  Future<void> _onApproveFriend(Map arg) async {
    String friendClientId = arg["friendClientId"] as String;
    bool agree = arg["agree"] as bool;
    String rejectRemark = '';
    if(!agree) rejectRemark = arg["rejectRemark"] as String;
    //事件下发
    for (var listener in _friendEventListeners) {
      listener.onApproveFriendEvent(friendClientId, agree, rejectRemark);
    }
  }

  /// 设置好友监听器 [contactListener]
  void addFriendListener(FriendEventListener friendListener) {
    _friendEventListeners.add(friendListener);
  }

  /// 移除好友监听器  [contactListener]
  void removeFriendListener(FriendEventListener friendListener) {
    if (_friendEventListeners.contains(friendListener)) {
      _friendEventListeners.remove(friendListener);
    }
  }

  //申请添加好友
  Future<bool?> applyFriend(String friendClientId, String remark) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.applyFriend,
        {"friendClientId": friendClientId, "remark": remark});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.applyFriend);
    } on WeError catch (e) {
      throw e;
    }
  }

  //申请添加好友
  Future<bool?> approveFriend(
      String friendClientId, bool agree, String rejectRemark) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.approveFriend, {
      "friendClientId": friendClientId,
      "agree": agree,
      "rejectRemark": rejectRemark
    });
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.approveFriend);
    } on WeError catch (e) {
      throw e;
    }
  }

  //删除好友
  Future<bool?> batchDeleteFriend(List<String> friendClientIds) async {
    Map result = await _channel.invokeMethod(
        WeSDKMethodKey.batchDeleteFriend, {"friendClientIds": friendClientIds});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.batchDeleteFriend);
    } on WeError catch (e) {
      throw e;
    }
  }
}
