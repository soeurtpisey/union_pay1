// import 'dart:html';

import 'dart:async';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:oktoast/oktoast.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/single_rtc/signaling.dart';
import 'dart:core';
import 'signaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';



class CallSample extends StatefulWidget {
  static String tag = 'call_sample';
  final String toClient;
  final String channelId;
  final CallRtcRole rtcRole;
  final WeRTCType rtcType;

  CallSample({required this.toClient,required this.channelId,required this.rtcRole,required this.rtcType});//required this.host,

  @override
  _CallSampleState createState() => _CallSampleState();
}

class _CallSampleState extends State<CallSample>  implements SingleRTCListener {
  Signaling? _signaling;
  List<dynamic> _peers = [];
  // String? _selfId;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  Session? _session;

  WeRTCType ? currentRtcType;

  bool _waitAccept = false;
  String tip = '等待接听';
  CallState? callState;

  StreamSubscription? _playerSubscription;
  String _playerTxt = '00:00:00';
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();

  String playAssetsPath = 'assets/videoCall.wav';



  // ignore: unused_element
  _CallSampleState();

  @override
  initState() {
    super.initState();
    _initializeExample();
    initRenderers();
    _connect();
    WeClient.getInstance.singleRtcManager.addRTCListener(this);
    currentRtcType = widget.rtcType;

  }

  void dispose() {
    cancelPlayerSubscriptions();
    WeClient.getInstance.singleRtcManager.removeRTCListener(this);
    super.dispose();
  }

  Future<void> _initializeExample() async {
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    await playerModule.setSubscriptionDuration(Duration(milliseconds: 10));
    await initializeDateFormatting();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

  }


  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    _signaling?.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }


  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
  }
  void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = playerModule.onProgress!.listen((e) async {

      var date =  DateTime.fromMillisecondsSinceEpoch(e.position.inMilliseconds,
          isUtc: false);
      var txt = await DateFormat('mm:ss:SS', 'zh_CN').format(date);
      setState(() {
        _playerTxt = txt.substring(0,8);
      });
    });
  }
  Future<Uint8List> getAssetData(String path) async {
    var asset = await rootBundle.load(path);
    return asset.buffer.asUint8List();
  }

  Future<void> startPlayer() async {
    try {
      Uint8List? dataBuffer;

      dataBuffer =
          (await rootBundle.load(playAssetsPath)).buffer.asUint8List();

      dataBuffer = await flutterSoundHelper.pcmToWaveBuffer(
        inputBuffer: dataBuffer,
        numChannels: 1,
        sampleRate:  44000,
      );

      await playerModule.startPlayer(
              fromDataBuffer: dataBuffer,
              sampleRate:  44000,
              codec: Codec.pcm16WAV,
              whenFinished: () {
                playerModule.logger.d('Play finished');
                startPlayer();
                setState(() {});
              });
        // }


      setState(() {});
      playerModule.logger.d('<--- startPlayer');
    } on Exception catch (err) {
      playerModule.logger.e('error: $err');
    }
  }

  Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      playerModule.logger.d('stopPlayer');

    } on Exception catch (err) {
      playerModule.logger.d('error: $err');
    }
    setState(() {});
  }

  void _connect() async {
    _signaling ??= Signaling(widget.rtcRole,widget.rtcType)..connect();
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
          break;
      }
    };
    _invitePeer(context,widget.channelId,widget.toClient, false);


    _signaling?.onCallStateChange = (Session session, CallState state) async {
      callState = state;
      switch (state) {
        case CallState.CallStateNew:
          setState(() {
            _session = session;
            startPlayer();
          });
          break;
        case CallState.CallStateRinging:

          setState(() {
            if(widget.rtcRole == CallRtcRole.CallRtcRoleCaller){
              tip = '连接中....';
            }else{
              tip = '等待接听....';
            }

          });
          break;
        case CallState.CallStateBye:
          if (_waitAccept) {
            print('peer reject');
            _waitAccept = false;
            Navigator.of(context).pop(false);
            stopPlayer();
          }
          setState(() {
            _localRenderer.srcObject = null;
            _remoteRenderer.srcObject = null;
            _inCalling = false;
            _session = null;
          });
          break;
        case CallState.CallStateInvite:
          _waitAccept = true;
          break;
        case CallState.CallStateConnected:
          if (_waitAccept) {
            stopPlayer();
            _waitAccept = false;
            if(widget.rtcRole == CallRtcRole.CallRtcRoleCallee){
              Navigator.of(context).pop(false);
            }
          }

          setState(() {
            tip= '正在通话...';
            _addListeners();
            _inCalling = true;
          });

          break;
        case CallState.CallStateRinging:
      }
    };

    _signaling?.onPeersUpdate = ((event) {
      setState(() {
        _peers = event['peers'];
      });
    });

    _signaling?.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = stream;
    });

    _signaling?.onRemoveRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = null;
    });
  }
  _invitePeer(BuildContext context,String? channelId, String? peerId, bool? useScreen) async {

    if (_signaling != null ) {//&& peerId != _selfId
      if(widget.rtcRole == CallRtcRole.CallRtcRoleCaller){
        _signaling?.invite(channelId!,peerId!, widget.rtcType == WeRTCType.VIDEO?'video':'voice', useScreen!);
      }else {
        _signaling?.acceptAction(channelId!,peerId!, widget.rtcType == WeRTCType.VIDEO?'video':'voice', useScreen!);
      }
    }
  }

  _accept() async {
    if (_session != null) {

      if(widget.rtcRole == CallRtcRole.CallRtcRoleCallee){
        try{
          var success = await WeSingRtcManager.getInstance.joinRtcChannel( int.parse(_session!.sid) )?? false;
          if(success){
            // _signaling?.accept(_session!.sid);
            setState(() {
              _inCalling = true;
            });
          }
        } catch(e){
          showToast("加入频道失败");
          throw e;
        }
      }

    }
  }

  _reject() async {
    print('拒接');
    stopPlayer();
    if (_session != null) {
      try{
        bool success = await WeSingRtcManager.getInstance.rejectRtcCall(int.parse(_session!.sid))??false;
        if(success){
          _signaling?.reject(_session!.sid);
          Navigator.of(context).pop();
        }
      }catch(e){

      }
    }
  }

  _hangUp() async {
    print('主动挂断');

    if (_session != null) {
      if(widget.rtcRole == CallRtcRole.CallRtcRoleCaller) {
        stopPlayer();
        try {
          bool success = await WeSingRtcManager.getInstance.leaveRtcChannel(
              int.parse(_session!.sid)) ?? false;
          if (success) {
            _signaling?.bye(_session!.sid);
            Navigator.of(context).pop();
          }
        } catch (e) {
          throw e;
        }
      } else {
       if(callState == CallState.CallStateConnected){
         try {
           bool success = await WeSingRtcManager.getInstance.leaveRtcChannel(
               int.parse(_session!.sid)) ?? false;
           if (success) {
             _signaling?.bye(_session!.sid);
             Navigator.of(context).pop();
           }
         } catch (e) {
           throw e;
         }
       }else{
         _reject();
       }

      }
    }
  }

  _switchCamera() {
    _signaling?.switchCamera();
  }

  /// 视频切语音
  _switchVoice(){
    setState(() {
      currentRtcType =  WeRTCType.VOICE;
    });
  }

  _muteMic() {
    _signaling?.muteMic();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _inCalling
          ? (currentRtcType == WeRTCType.VIDEO? SizedBox(
              width: 200.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      child: const Icon(Icons.switch_camera),
                      onPressed: _switchCamera,
                    ),
                    FloatingActionButton(
                      onPressed: _hangUp,
                      tooltip: 'Hangup',
                      child: Icon(Icons.call_end),
                      backgroundColor: Colors.pink,
                    ),
                    FloatingActionButton(
                      child: const Icon(Icons.mic_off),
                      onPressed: _muteMic,
                    ),
                  ])):null)
          : _buildConnectView(),
      body: _inCalling
          ?  (currentRtcType == WeRTCType.VIDEO? OrientationBuilder(builder: (context, orientation) {
              return Container(
                child: Stack(children: <Widget>[
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: RTCVideoView(_remoteRenderer),
                        decoration: BoxDecoration(color: Colors.black54),
                      )),
                  Positioned(
                    left: 20.0,
                    top: 100.0,
                    child: Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      child: RTCVideoView(_localRenderer, mirror: true),
                      decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                  Positioned(
                    bottom: 220,
                    height:20,
                    width: MediaQuery.of(context).size.width,
                    child:Text(_playerTxt,textAlign: TextAlign.center,),
                  ),
                ]),
              );
            }):_buildVoiceView())
          : Container(),
    );
  }
/// 连接中视图
  _buildConnectView(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height:MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
              top: 200.0,
              left: (MediaQuery.of(context).size.width-100)/2,
              width: 100,
              height: 100,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset("images/create_group.png",fit: BoxFit.fill,),
                decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(50)),
              ),),
          Positioned(
            top: 320,
              height:20,
              width: MediaQuery.of(context).size.width,
              child:Text(tip,textAlign: TextAlign.center,),
          ),
          Positioned(
            left: 100,
           width: MediaQuery.of(context).size.width-200,
              bottom: 50,
              child: Row(
                mainAxisAlignment: widget.rtcRole == CallRtcRole.CallRtcRoleCaller? MainAxisAlignment.center:MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: _hangUp,
                    tooltip:  'HangUp',
                    child: Icon(Icons.call_end),
                    backgroundColor: Colors.pink,
                  ),
                  widget.rtcRole == CallRtcRole.CallRtcRoleCaller? Container(): FloatingActionButton(
                    onPressed: _accept,
                    tooltip: 'Accept',
                    child: Icon(Icons.call_sharp),
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }

  /// 语音通话视图
  _buildVoiceView(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height:MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: 200.0,
            left: (MediaQuery.of(context).size.width-100)/2,
            width: 100,
            height: 100,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset("images/create_group.png",fit: BoxFit.fill,),
              decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(50)),
            ),),
          Positioned(
            top: 320,
            height:20,
            width: MediaQuery.of(context).size.width,
            child:Text('正在通话中...',textAlign: TextAlign.center,),
          ),
          Positioned(
            bottom: 220,
            height:20,
            width: MediaQuery.of(context).size.width,
            child:Text(_playerTxt,textAlign: TextAlign.center,),
          ),
          Positioned(
            left: 100,
            width: MediaQuery.of(context).size.width-200,
            bottom: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: _hangUp,
                  tooltip: 'Hangup',
                  child: Icon(Icons.call_end),
                  backgroundColor: Colors.pink,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.mic_off),
                  onPressed: _muteMic,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  @override
  Future<void> processCallEvent(WeRTCEvent rtcEvent) async {
    // TODO: implement processCallEvent
    // _showAcceptDialog();
    print('接收rtc邀请');
    _signaling?.onMessage(rtcEvent);
  }

  @override
  void processCandidateEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processCandidateEvent
    print('CandidateCand转发');
    // rtcEvent.channelId = int.parse( widget.channelId);
    _signaling?.onMessage(rtcEvent);
  }

  @override
  void processJoinEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processJoinEvent
    print('用户加入频道');
    // _accept();
    setState(() {
      _inCalling = false;
    });
    _signaling?.onMessage(rtcEvent);

  }

  @override
  void processLeaveEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processLeaveEvent
    print('用户退出频道');
    Navigator.of(context).pop();
    _signaling?.onMessage(rtcEvent);
    stopPlayer();
  }

  @override
  void processRejectEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processRejectEvent
    print('用户拒绝加入');
    Navigator.of(context).pop();
    _signaling?.onMessage(rtcEvent);
    stopPlayer();
  }

  @override
  void processSdpEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processSdpEvent
    print('SdpEvent转发:'+'${rtcEvent.channelId}');
    // rtcEvent.channelId = int.parse( widget.channelId);

    _signaling?.onMessage(rtcEvent);
  }
}
