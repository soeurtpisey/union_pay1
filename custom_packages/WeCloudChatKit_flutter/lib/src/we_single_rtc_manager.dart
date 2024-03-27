import 'package:flutter/services.dart';
import 'package:wecloudchatkit_flutter/src/model/we_error.dart';
import 'package:wecloudchatkit_flutter/src/model/we_rtc_event.dart';
import 'package:wecloudchatkit_flutter/src/tools/we_extension.dart';
import 'package:wecloudchatkit_flutter/src/we_listeners.dart';
import 'package:wecloudchatkit_flutter/src/we_sdk_method_key.dart';

class WeSingRtcManager {
  static const _channelPrefix = 'cn.wecloud.im';

  static const MethodChannel _channel = const MethodChannel(
      '$_channelPrefix/sing_rtc_manager', JSONMethodCodec());

  static WeSingRtcManager? _instance;

  static WeSingRtcManager get getInstance =>
      _instance = _instance ?? WeSingRtcManager._internal();

  WeSingRtcManager._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case WeSDKMethodKey.onProcessCallEvent:
          return _onProcessCallEvent(WeRTCEvent.fromJson(call.arguments));
        case WeSDKMethodKey.onProcessJoinEvent:
          return _onProcessJoinEvent(WeRTCEvent.fromJson(call.arguments));
        case WeSDKMethodKey.onProcessLeaveEvent:
          return _onProcessLeaveEvent(WeRTCEvent.fromJson(call.arguments));
        case WeSDKMethodKey.onProcessRejectEvent:
          return _onProcessRejectEvent(WeRTCEvent.fromJson(call.arguments));
        case WeSDKMethodKey.onProcessSdpEvent:
          return _onProcessSdpEvent(WeRTCEvent.fromJson(call.arguments));
        case WeSDKMethodKey.onProcessCandidateEvent:
          return _onProcessCandidateEvent(WeRTCEvent.fromJson(call.arguments));
      }
      return null;
    });
  }

  final List<SingleRTCListener> _singleRTCListeners = [];

  /// 设置RTC监听器 [rtcListener]
  void addRTCListener(SingleRTCListener rtcListener) {
    _singleRTCListeners.add(rtcListener);
  }

  /// 移除RTC监听器  [rtcListener]
  void removeRTCListener(SingleRTCListener rtcListener) {
    if (_singleRTCListeners.contains(rtcListener)) {
      _singleRTCListeners.remove(rtcListener);
    }
  }

  Future<void> _onProcessCallEvent(WeRTCEvent rtcEvent) async {
    for (var listener in _singleRTCListeners) {
      listener.processCallEvent(rtcEvent);
    }
  }

  Future<void> _onProcessJoinEvent(WeRTCEvent rtcEvent) async {
    for (var listener in _singleRTCListeners) {
      listener.processJoinEvent(rtcEvent);
    }
  }

  Future<void> _onProcessLeaveEvent(WeRTCEvent rtcEvent) async {
    for (var listener in _singleRTCListeners) {
      listener.processLeaveEvent(rtcEvent);
    }
  }

  Future<void> _onProcessRejectEvent(WeRTCEvent rtcEvent) async {
    for (var listener in _singleRTCListeners) {
      listener.processRejectEvent(rtcEvent);
    }
  }

  Future<void> _onProcessSdpEvent(WeRTCEvent rtcEvent) async {
    for (var listener in _singleRTCListeners) {
      listener.processSdpEvent(rtcEvent);
    }
  }

  Future<void> _onProcessCandidateEvent(WeRTCEvent rtcEvent) async {
    for (var listener in _singleRTCListeners) {
      listener.processCandidateEvent(rtcEvent);
    }
  }

  //创建频道,并邀请客户端加入
  Future<int?> createAndCall(String toClient, WeRTCType callType, int conversationId,
      {Map<String, String>? attrs, String? push, bool pushCall = false}) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.createAndCall, {
      "toClient": toClient,
      "attrs": attrs,
      "callType": callType.value,
      "conversationId": conversationId,
      "push": push,
      "pushCall": pushCall,
    });
    try {
      WeError.hasError(result);
      return result[WeSDKMethodKey.createAndCall];
    } on WeError catch (e) {
      throw e;
    }
  }

  //创建频道,并邀请客户端加入
  Future<bool?> joinRtcChannel(int channelId) async {
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.joinRtcChannel, {"channelId": channelId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.joinRtcChannel);
    } on WeError catch (e) {
      throw e;
    }
  }

  //创建频道,并邀请客户端加入
  Future<bool?> rejectRtcCall(int channelId) async {
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.rejectRtcCall, {"channelId": channelId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.rejectRtcCall);
    } on WeError catch (e) {
      throw e;
    }
  }

  //创建频道,并邀请客户端加入
  Future<bool?> sdpForward(
      int channelId, String sdpData, String sdpType) async {
    print('sdp发送数据操作：'+'${sdpType}');
    Map result = await _channel.invokeMethod(WeSDKMethodKey.sdpForward,
        {"channelId": channelId, "sdpData": sdpData, "sdpType": sdpType});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.sdpForward);
    } on WeError catch (e) {
      throw e;
    }
  }

  //创建频道,并邀请客户端加入
  Future<bool?> candidateForward(int channelId, String candidateData) async {
    Map result = await _channel.invokeMethod(WeSDKMethodKey.candidateForward,
        {"channelId": channelId, "candidateData": candidateData});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.candidateForward);
    } on WeError catch (e) {
      throw e;
    }
  }

  //创建频道,并邀请客户端加入
  Future<bool?> leaveRtcChannel(int channelId) async {
    Map result = await _channel
        .invokeMethod(WeSDKMethodKey.leaveRtcChannel, {"channelId": channelId});
    try {
      WeError.hasError(result);
      return result.boolValue(WeSDKMethodKey.leaveRtcChannel);
    } on WeError catch (e) {
      throw e;
    }
  }
}
