import 'dart:convert';
import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/constant.dart';
import 'package:wecloudchatkit_flutter_example/utils/sp_util.dart';
// import 'package:wecloudchatkit_flutter_example/single_rtc/websocket.dart';


// import '../utils/device_info.dart'
//     if (dart.library.js) '../utils/device_info_web.dart';
// import '../utils/websocket.dart'
//     if (dart.library.js) '../utils/websocket_web.dart';
// import '../utils/turn.dart' if (dart.library.js) '../utils/turn_web.dart';

enum SignalingState {
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

enum CallState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
}

enum CallRtcRole {
  ///1-发起者
    CallRtcRoleCaller,
  ///  2-接收者
  CallRtcRoleCallee ,
}


class Session {
  Session({required this.sid, required this.pid});
  String pid;
  String sid;

  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  List<RTCIceCandidate> remoteCandidates = [];
}

class Signaling {
  Signaling( this.rtcRole,this.rtcType);//this._host,
  CallRtcRole rtcRole;
  WeRTCType rtcType;
  // JsonEncoder _encoder = JsonEncoder();
  // JsonDecoder _decoder = JsonDecoder();
  // String _selfId = SpUtil.getString(Constant.KEY_CLIENT_ID);

  // var _turnCredential;
  Map<String, Session> _sessions = {};
  MediaStream? _localStream;
  List<MediaStream> _remoteStreams = <MediaStream>[];

  Function(SignalingState state)? onSignalingStateChange;
  Function(Session session, CallState state)? onCallStateChange;
  Function(MediaStream stream)? onLocalStream;
  Function(Session session, MediaStream stream)? onAddRemoteStream;
  Function(Session session, MediaStream stream)? onRemoveRemoteStream;
  Function(dynamic event)? onPeersUpdate;
  Function(Session session, RTCDataChannel dc, RTCDataChannelMessage data)?
      onDataChannelMessage;
  Function(Session session, RTCDataChannel dc)? onDataChannel;


  String get sdpSemantics =>
      WebRTC.platformIsWindows ? 'plan-b' :'unified-plan' ;

  Map<String, dynamic> _iceServers = {
    'iceServers': [
      // {'url': 'stun:stun.l.google.com:19302'},
      {
        'url': 'turn:120.55.49.33',
        'username': 'xiaolandou',
        'credential': 'xiaolandou'
      },
      {
        'url': 'stun:120.55.49.33',
      },
      {
        'url': 'stun:139.9.216.85',
      },
      {
        'url': 'turn:139.9.216.85',
        'username': 'xiaolandou',
        'credential': 'xiaolandou'
      },
      /*
       * turn server configuration example.
      {
        'url': 'turn:123.45.67.89:3478',
        'username': 'change_to_real_user',
        'credential': 'change_to_real_secret'
      },
      */
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  close() async {
    await _cleanSessions();
    // _socket?.close();
  }

  void switchCamera() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  void muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
    }
  }

  void invite(String channelId,String peerId, String media, bool useScreen) async {
    var sessionId = channelId;
    Session session = await _createSession(null,
        peerId: peerId,
        sessionId: sessionId,
        media: media,
        screenSharing: useScreen);
    _sessions[sessionId.toString()] = session;
    if (media == 'data') {
      _createDataChannel(session);
    }
    print('invite');
    onCallStateChange?.call(session, CallState.CallStateNew);
    onCallStateChange?.call(session, CallState.CallStateInvite);
  }


  void acceptAction(String channelId,String peerId, String media, bool useScreen) async {
    var sessionId = channelId;
    Session session = await _createSession(null,
        peerId: peerId,
        sessionId: sessionId,
        media: media,
        screenSharing: useScreen);
    _sessions[sessionId.toString()] = session;
    if (media == 'data') {
      _createDataChannel(session);
    }
    print('acceptAction');
    await Future.delayed(
        const Duration(seconds: 1),
            () => {
            onCallStateChange?.call(session, CallState.CallStateNew),
          onCallStateChange?.call(session, CallState.CallStateRinging),

            });

  }

  void bye(String sessionId) {

    var sess = _sessions[sessionId];
    if (sess != null) {
      _closeSession(sess);
    }
  }

  void accept(String sessionId) {
    var session = _sessions[sessionId.toString()];
    if (session == null) {
      return;
    }
    _createAnswer(session, rtcType == WeRTCType.VIDEO?'video':'voice');

  }

  void reject(String sessionId) {
    var session = _sessions[sessionId];
    if (session == null) {
      return;
    }
    bye(session.sid);
  }

  void onMessage(message) async {
    WeRTCEvent rtcEvent = message;
    // var data = mapData['data'];

    switch (rtcEvent.subCmd) {
      case 1:///接收到RTC邀请
        {
        }
        break;
      case 2:// (用户加入频道
        {
          var sessionId = rtcEvent.channelId;
          Session session = await _createSession(null,
              peerId: rtcEvent.clientId.toString(),
              sessionId: sessionId.toString(),
              media: rtcType == WeRTCType.VIDEO?'video':'voice',
              screenSharing: false);
          _sessions[sessionId.toString()] = session;

          print('用户加入的频道id：'+'${rtcEvent.channelId}');
          if(rtcRole == CallRtcRole.CallRtcRoleCaller){
            _createOffer(session, rtcType == WeRTCType.VIDEO?'video':'voice');
          }

        }
        break;
      case 3:// (用户退出频道
        {
          var peerId = rtcEvent.clientId;
          _closeSessionByPeerId(peerId.toString());
        }
        break;
      case 4:// (用户拒接邀请,不同意进入频道
        {
          var sessionId = rtcEvent.channelId;
                print('bye: ' + sessionId.toString());
                var session = _sessions.remove(sessionId.toString());
                if (session != null) {
                  onCallStateChange?.call(session, CallState.CallStateBye);
                  _closeSession(session);
                }
        }
        break;
      case 5:// (SDP数据转发
        {
          print('收到sdp数据：'+'${rtcEvent.sdpType}'=="频道sdp："+'${rtcEvent.sdpData}');
          if(rtcEvent.sdpType == 'offer'){
                  var peerId = rtcEvent.clientId;
                  var sdpData = rtcEvent.sdpData;
                  var sessionId = rtcEvent.channelId;
                  var session = _sessions[sessionId.toString()];
                  var newSession = await _createSession(session,
                      peerId: peerId.toString(),
                      sessionId: rtcEvent.channelId.toString(),
                      media: '',
                      screenSharing: false);

                  await newSession.pc?.setRemoteDescription(
                      RTCSessionDescription(sdpData, rtcEvent.sdpType));

                  if (newSession.remoteCandidates.length > 0) {
                    newSession.remoteCandidates.forEach((candidate) async {
                      await newSession.pc?.addCandidate(candidate);
                    });
                    newSession.remoteCandidates.clear();
                  }
                  _sessions[sessionId.toString()] = newSession;
                   _createAnswer(newSession, rtcType == WeRTCType.VIDEO?'video':'voice');


          }else{
                 var sdpData = rtcEvent.sdpData;
                  var sessionId = rtcEvent.channelId;
                  var session =  _sessions[sessionId.toString()];
                 session?.pc?.setRemoteDescription(
                     RTCSessionDescription(sdpData, rtcEvent.sdpType));
                  // onCallStateChange?.call(session!, CallState.CallStateConnected);
          }
        }
        break;
      case 6:// (candidate候选者数据转发
        {
            var peerId = rtcEvent.channelId;
                Map candidateMap = JsonDecoder().convert(rtcEvent.candidateData!);
                print('candidateMap值：'+'${candidateMap}');
                var sessionId = rtcEvent.channelId;
                var session = _sessions[sessionId.toString()];
                RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
                    candidateMap['sdpMid'].toString(), candidateMap['sdpMLineIndex']);
                if (session != null) {
                  if (session.pc != null) {
                    await session.pc?.addCandidate(candidate);
                  } else {
                    session.remoteCandidates.add(candidate);
                  }
                } else {
                  _sessions[sessionId.toString()] = Session(pid: peerId.toString(), sid: sessionId.toString())
                    ..remoteCandidates.add(candidate);
                }
            onCallStateChange?.call(session!, CallState.CallStateConnected);
        }
        break;
      default:
        break;
    }
  }


  Future<void> connect() async {
    // var url = 'https://$_host:$_port/ws';
    // _socket = SimpleWebSocket(url);

    // print('connect to $url');

    // if (_turnCredential == null) {
    //   try {
        // _turnCredential = await getTurnCredential('imapitest.wecloud.cn');
        /*{
            "username": "1584195784:mbzrxpgjys",
            "password": "isyl6FF6nqMTB9/ig5MrMRUXqZg",
            "ttl": 86400,
            "uris": ["turn:127.0.0.1:19302?transport=udp"]
          }
        */
        // _iceServers;
        // _iceServers = {
        //   'iceServers': [
        //     {
        //       'urls': _turnCredential['uris'][0],
        //       'username': _turnCredential['username'],
        //       'credential': _turnCredential['password']
        //     },
        //   ]
        // };
      // } catch (e) {}
    // }


      onSignalingStateChange?.call(SignalingState.ConnectionOpen);

  }

  Future<MediaStream> createStream(String media, bool userScreen) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': userScreen ? false : true,
      'video': userScreen
          ? true
          : {
              'mandatory': {
                'minWidth':
                    '640', // Provide your own width, height and frame rate here
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            }
    };

    MediaStream stream = userScreen
        ? await navigator.mediaDevices.getDisplayMedia(mediaConstraints)
        : await navigator.mediaDevices.getUserMedia(mediaConstraints);
    onLocalStream?.call(stream);
    return stream;
  }

  Future<Session> _createSession(Session? session,
      {required String peerId,
      required String sessionId,
      required String media,
      required bool screenSharing}) async {
    var newSession = session ?? Session(sid: sessionId, pid: peerId);
    if (media != 'data')
      _localStream = await createStream(media, screenSharing);
    print(_iceServers);
    RTCPeerConnection pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);
    if (media != 'data') {
      switch (sdpSemantics) {
        case 'plan-b':
          pc.onAddStream = (MediaStream stream) {
            onAddRemoteStream?.call(newSession, stream);
            print('进来的流类型b：${stream}');
            _remoteStreams.add(stream);
          };
          await pc.addStream(_localStream!);
          break;
        case 'unified-plan':
          // Unified-Plan
          pc.onTrack = (event) {
            print('进来的流类型plan：${event.track.kind}');
            if (event.track.kind == 'video') {
              onAddRemoteStream?.call(newSession, event.streams[0]);
            }
          };
          _localStream!.getTracks().forEach((track) {
            pc.addTrack(track, _localStream!);
          });
          break;
      }

      // Unified-Plan: Simuclast
      /*
      await pc.addTransceiver(
        track: _localStream.getAudioTracks()[0],
        init: RTCRtpTransceiverInit(
            direction: TransceiverDirection.SendOnly, streams: [_localStream]),
      );

      await pc.addTransceiver(
        track: _localStream.getVideoTracks()[0],
        init: RTCRtpTransceiverInit(
            direction: TransceiverDirection.SendOnly,
            streams: [
              _localStream
            ],
            sendEncodings: [
              RTCRtpEncoding(rid: 'f', active: true),
              RTCRtpEncoding(
                rid: 'h',
                active: true,
                scaleResolutionDownBy: 2.0,
                maxBitrate: 150000,
              ),
              RTCRtpEncoding(
                rid: 'q',
                active: true,
                scaleResolutionDownBy: 4.0,
                maxBitrate: 100000,
              ),
            ]),
      );*/
      /*
        var sender = pc.getSenders().find(s => s.track.kind == "video");
        var parameters = sender.getParameters();
        if(!parameters)
          parameters = {};
        parameters.encodings = [
          { rid: "h", active: true, maxBitrate: 900000 },
          { rid: "m", active: true, maxBitrate: 300000, scaleResolutionDownBy: 2 },
          { rid: "l", active: true, maxBitrate: 100000, scaleResolutionDownBy: 4 }
        ];
        sender.setParameters(parameters);
      */
    }
    pc.onIceCandidate = (candidate) async {
      if (candidate == null) {
        print('onIceCandidate: complete!');
        return;
      }
      // This delay is needed to allow enough time to try an ICE candidate
      // before skipping to the next one. 1 second is just an heuristic value
      // and should be thoroughly tested in your own environment.
      await Future.delayed(
          const Duration(seconds: 1),
          () => candidateForwardRTCAction({
                'sdpMLineIndex': candidate.sdpMLineIndex,
                'sdpMid': candidate.sdpMid.toString(),
                'candidate': candidate.candidate,
              },sessionId));

    };

    pc.onIceConnectionState = (state) {
      print('state值：'+'${state}');
    };

    pc.onRemoveStream = (stream) {
      onRemoveRemoteStream?.call(newSession, stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    pc.onDataChannel = (channel) {
      _addDataChannel(newSession, channel);
    };

    newSession.pc = pc;
    return newSession;
  }
  Future<void> candidateForwardRTCAction(Map candidateInfo,String channelId) async {
    try {
     bool success =await  WeClient.getInstance.singleRtcManager.candidateForward(int.parse(channelId), JsonEncoder().convert(candidateInfo))??false;
      if(success){

      }
    } catch(e){
      throw(e);
    }
  }

  void _addDataChannel(Session session, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      onDataChannelMessage?.call(session, channel, data);
    };
    session.dc = channel;
    onDataChannel?.call(session, channel);
  }

  Future<void> _createDataChannel(Session session,
      {label: 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
      ..maxRetransmits = 30;
    RTCDataChannel channel =
        await session.pc!.createDataChannel(label, dataChannelDict);
    _addDataChannel(session, channel);
  }

  Future<void> _createOffer(Session session, String media) async {
    try {
      RTCSessionDescription s =
          await session.pc!.createOffer(media == 'data' ? _dcConstraints : {
            'mandatory': {
            'OfferToReceiveAudio': true,
            'OfferToReceiveVideo': true,
            'iceRestart':true
          },
            'optional': [],});
      await session.pc!.setLocalDescription(s);
      print('创建offer是pc?.signalingState的值：'+'${(session.pc?.signalingState)}');
      sdpForwardRTCAction(int.parse(session.sid),s.sdp!, 'offer');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sdpForwardRTCAction(int channelId, String sdpData, String sdpType) async {
    print('转发的sdp的id：'+'${channelId}');
    try {
      bool success =await  WeClient.getInstance.singleRtcManager.sdpForward(channelId,sdpData,sdpType)??false;
      if(success){
        print('sdpForwardRTC成功：'+'${sdpType}');
      }
    } catch(e){
      throw(e);
    }
  }

  Future<void> _createAnswer(Session session, String media) async {
    try {

      RTCSessionDescription s =
          await session.pc!.createAnswer(media == 'data' ? _dcConstraints : {
            'mandatory': {
              'OfferToReceiveAudio': true,
              'OfferToReceiveVideo': true,
          'iceRestart':true
            },
            'optional': [],
          });
      print('创建answer是pc?.signalingState的值：'+'${(session.pc?.signalingState)}');
      await session.pc!.setLocalDescription(s);
      // _send('answer', {
      //   'to': session.pid,
      //   'from': _selfId,
      //   'description': {'sdp': s.sdp, 'type': s.type},
      //   'session_id': session.sid,
      // });
      sdpForwardRTCAction(int.parse(session.sid),s.sdp!, 'answer');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _cleanSessions() async {
    if (_localStream != null) {
      _localStream!.getTracks().forEach((element) async {
        await element.stop();
      });
      await _localStream!.dispose();
      _localStream = null;
    }
    _sessions.forEach((key, sess) async {
      await sess.pc?.close();
      await sess.dc?.close();
    });
    _sessions.clear();
  }

  void _closeSessionByPeerId(String peerId) {
    var session;
    _sessions.removeWhere((String key, Session sess) {
      var ids = key.split('-');
      session = sess;
      return peerId == sess.pid;
    });
    if (session != null) {
      _closeSession(session);
      onCallStateChange?.call(session, CallState.CallStateBye);
    }
  }

  Future<void> _closeSession(Session session) async {
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await _localStream?.dispose();
    _localStream = null;

    await session.pc?.close();
    await session.dc?.close();
  }
}
