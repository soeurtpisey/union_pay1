import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/chatinput/chat_bottom.dart';
import 'package:wecloudchatkit_flutter_example/chatinput/chat_more_view.dart';
import 'package:wecloudchatkit_flutter_example/single_rtc/call_sample.dart';
import 'package:wecloudchatkit_flutter_example/single_rtc/signaling.dart';
import 'package:wecloudchatkit_flutter_example/utils/StringUtils.dart';
import 'package:wecloudchatkit_flutter_example/utils/conversation_helper.dart';
import 'package:wecloudchatkit_flutter_example/utils/log_util.dart';
import 'package:wecloudchatkit_flutter_example/utils/minio_util.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/chat_message_item.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/custom_msg_helper.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/expanded_viewport.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/pop_menu.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(this.conversation, {Key? key}) : super(key: key);

  final WeConversation conversation;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    implements MessageReceivedListener,OnConvSyncStatusListener {
  final WeChatManager chatManager = WeClient.getInstance.chatManager;
  final ScrollController listScrollController = new ScrollController();
  final changeNotifier = new StreamController.broadcast();
  bool isShowLoading = false;
  List<WeMessage> mlistMessage = [];

  /// 时间显示间隔为1分钟
  final int _timeInterval = 60 * 1000;

  @override
  void initState() {
    super.initState();
    chatManager.addReceivedListener(this);
    listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        _loadMessages(moveBottom: false);
      }
    });

    _loadMessages();

    // Map<String, dynamic> attributes =
    //     jsonDecode(widget.conversation.attributes ?? "{}");
    // int count = attributes["count"] ?? 0;
    // WeClient.getInstance.conversationManager.updateConversationAttr(
    //     widget.conversation.id,
    //     {"count": 1}).then((value) => Log.e("updateConversationAttr:$value"));
    chatManager.addOnConvSyncStatusListener(this);
  }

  //从新连接上WS时回去同步会话列表，同步完成会回调此方法
  @override
  void onConvSyncStatusListener() {
    _loadMessages();
  }

  @override
  void dispose() {
    chatManager.removeReceivedListener(this);
    chatManager.removeOnConvSyncStatusListener(this);
    changeNotifier.close();
    super.dispose();
  }

  /// 下拉加载更多消息
  _loadMessages({int count = 20, bool moveBottom = true}) async {
    isShowLoading = true;
    setState(() {});
    try {
      var conversation = widget.conversation;
      var lastMsg = mlistMessage.length > 0 ? mlistMessage.last : null;
      List<WeMessage> msgs =
          await chatManager.findHistMsg(conversation.id, lastMsg, count) ?? [];
      Log.e(
          "msgs size:${msgs.length} lastMsg:${lastMsg?.msgId} moveBottom:$moveBottom");
      mlistMessage.addAll(msgs);
    } on Error {
    } finally {
      isShowLoading = false;
      setState(() {});
    }
  }

  @override
  void onMessagesReceived(WeMessage message) {
    mlistMessage.insert(0, message);
    listScrollController.animateTo(0.00,
        duration: Duration(milliseconds: 1), curve: Curves.easeOut);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          changeNotifier.sink.add(null);
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.conversation.getConvName()),
            actions: [
              if (!widget.conversation.isSingleChat())
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => PopMenu.show(
                    context,
                    [
                      PopMenuItem('添加成员'),
                    ],
                    callback: (index) {
                      if (index == 0) {
                        _appMemberDialog(context);
                      }
                    },
                  ),
                )
            ],
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xffEDEDED),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          //  点击顶部空白处触摸收起键盘
                          FocusScope.of(context).requestFocus(FocusNode());
                          changeNotifier.sink.add(null);
                        },
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: Scrollable(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: listScrollController,
                              axisDirection: AxisDirection.up,
                              viewportBuilder: _builderMsgList),
                        ))),
                Container(height: 10),
                ChatBottomInputWidget(
                  shouldTriggerChange: changeNotifier.stream,
                  moreBtnList: [
                    ChatMoreViewItem('images/chat_input_more_photo.png', '相册',
                        () {
                      _moreViewPhotoBtnOnTap();
                    }),
                    ChatMoreViewItem('images/chat_input_more_camera.png', '相机',
                        () {
                      _moreViewCameraBtnOnTap();
                    }),
                    ChatMoreViewItem('images/chat_input_more_loc.png', '自定义消息',
                        () {
                      _moreViewCustomBtnOnTap();
                    }),
                    // ChatMoreViewItem('images/chat_input_more_file.png', '文件',
                    //     () {
                    //   //TODO 文件
                    //   Log.e("文件");
                    // }),

                    if (widget.conversation.isSingleChat())
                      ChatMoreViewItem('images/chat_input_more_video.png', '视频',
                          () {
                        _moreViewVideoBtnOnTap(context, WeRTCType.VIDEO);
                      }),
                    if (widget.conversation.isSingleChat())
                      ChatMoreViewItem('images/chat_input_more_call.png', '语音',
                          () {
                        //TODO 语音
                        Log.e("语音");
                        _moreViewVideoBtnOnTap(context, WeRTCType.VOICE);
                      }),
                  ],
                  onSendCallBack: (text) {
                    var msg = WeMessage.createSendTxtMessage(
                        widget.conversation.id, text);
                    _sendMessage(msg);
                  },
                  onAudioCallBack: (audioFile, duration) {
                    //TODO 语音
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 刷新View并滑动到最底部
  _setStateAndMoreToListViewEnd() {
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      listScrollController
          .jumpTo(listScrollController.position.minScrollExtent);
    });
  }

  Widget _builderMsgList(context, offset) {
    return ExpandedViewport(
      offset: offset,
      axisDirection: AxisDirection.up,
      slivers: [
        SliverExpanded(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _builderMsgItem(context, index, mlistMessage[index]);
            },
            childCount: mlistMessage.length,
          ),
        ),
        SliverToBoxAdapter(
          child: isShowLoading ? _builderLoadMoreView() : new Container(),
        )
      ],
    );
  }

  Widget _builderMsgItem(BuildContext context, int index, WeMessage msg) {
    bool needShowTime = false;
    int adjacentTime = 0;
    if (index + 1 < mlistMessage.length) {
      adjacentTime = mlistMessage[index + 1].createTime;
    }
    if ((msg.createTime - adjacentTime).abs() > _timeInterval) {
      needShowTime = true;
    }

    List<Widget> widgetsList = [];
    if (needShowTime) {
      widgetsList.add(Container(
        margin: EdgeInsets.only(top: 10),
        child: Center(
            child: Text(
          timeStrByMs(msg.createTime, showTime: true),
          style: TextStyle(color: Colors.grey),
        )),
      ));
    }
    widgetsList.add(ChatMessageItem(
      message: msg,
      onTap: (msg) {
        Log.e("onTap:${msg.reqId}");
        //TODO 点击消息bubble
        if (msg.type == WeMessageType.MSG_CUSTOM) {
          Map<String, dynamic>? attrs = msg.attrs ?? {};
          if (attrs["CustomType"] == CustMessageType.redEnvelope.value) {
            int redType = int.parse(attrs["redEnvelopeType"] ?? "0"); //红包类型
            attrs["redEnvelopeType"] = (redType + 1).toString();
            msg.attrs = attrs;
            WeClient.getInstance.chatManager
                .updateMessageAttrs(msg.msgId, attrs)
                .then((value) {
              if (value == true) setState(() {});
            });
          }
        }
      },
      onLongPress: (msg) {
        Log.e("onLongPress:${msg.reqId}");
        //TODO 长按消息bubble
      },
      onErrorBtnTap: (msg) {
        //重发按钮点击
        _resendMessage(msg);
      },
      onAvatarTap: (cid) {
        Log.e("onAvatarTap:${cid}");
        //TODO 头像按钮点击
      },
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgetsList,
    );
  }

  _builderLoadMoreView() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      height: 50,
      child: Center(
        child: SizedBox(
          width: 25.0,
          height: 25.0,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  _moreViewPhotoBtnOnTap() async {
    XFile? pf = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pf != null) {
      _sendImageMessage(pf.path);
    }
  }

  _moreViewCameraBtnOnTap() async {
    XFile? pf = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (pf != null) {
      _sendVideoMessage(pf.path);
    }
  }

  _moreViewCustomBtnOnTap() async {
    WeMessage msg = CustomMsgHelper.createRedEnvelopeMsg(
        widget.conversation.id, 1, "123456");
    _sendMessage(msg);
  }

  _moreViewVideoBtnOnTap(BuildContext context, WeRTCType rtcType) async {
    var singleRtcManager = WeClient.getInstance.singleRtcManager;
    var toClient = widget.conversation.getSingleOtherPartyCID();
    var conversationId = widget.conversation.id;
    var role = CallRtcRole.CallRtcRoleCaller;
    if (toClient != null) {
      singleRtcManager
          .createAndCall(toClient, rtcType, conversationId)
          .then((value) {
        Log.e("channelId:$value");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CallSample(
                      channelId: value.toString(),
                      toClient: toClient,
                      rtcRole: role,
                      rtcType: rtcType,
                    )));
      });
    }
  }

  _sendImageMessage(String imagePath) {
    var imgFile = File(imagePath);
    String? mimeType = lookupMimeType(imagePath);
    int fileSize = imgFile.readAsBytesSync().lengthInBytes;
    Image.file(imgFile, fit: BoxFit.contain)
        .image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      var image = WeFileMsgInfo()
        ..locPath = imagePath
        ..name = basename(imagePath)
        ..type = mimeType ?? ""
        ..size = fileSize
        ..fileInfo = {"width": info.image.width, "height": info.image.height};
      var msg = WeMessage.createSendImageMessage(widget.conversation.id, image);
      _sendFileMessage(msg);
    }));
  }

  _sendVideoMessage(String videoPath) async {
    var videoFile = File(videoPath);
    VideoPlayerController controller =
        new VideoPlayerController.file(videoFile);
    await controller.initialize();
    int duration = controller.value.duration.inMilliseconds;
    String? mimeType = lookupMimeType(videoPath);
    int fileSize = videoFile.readAsBytesSync().lengthInBytes;
    double width = controller.value.size.width;
    double height = controller.value.size.height;
    controller.dispose();
    Log.e(
        "mimeType:$mimeType,width:$width,height:$height,fileSize:$fileSize,duration:$duration");
    var video = WeFileMsgInfo()
      ..locPath = videoPath
      ..name = basename(videoPath)
      ..type = mimeType ?? ""
      ..size = fileSize
      ..fileInfo = {"width": width, "height": height, "duration": duration};
    var msg = WeMessage.createSendVideoMessage(widget.conversation.id, video);
    _sendFileMessage(msg);
  }

  _sendMessage(WeMessage msg) {
    chatManager.sendMessage(msg);
    mlistMessage.insert(0, msg);
    _setStateAndMoreToListViewEnd();
  }

  _sendFileMessage(WeMessage msg) {
    WeFileMsgInfo? file = msg.file;
    if (file == null || file.locPath == null) return;
    mlistMessage.insert(0, msg);
    _setStateAndMoreToListViewEnd();
    //上传文件
    msg.msgStatus = WeMessageStatus.MsgStatusSending;
    msg.statusListener?.onMessageStatusUpdate(msg);
    chatManager.sendMessage(msg);
    // MinioUtil.getInstance()
    //     .uploadMsgFile(WeClient.clientId, file.name??"", file.locPath!)
    //     .then((value) {
    //   if (value.isNotEmpty) {
    //     msg.file!.url = value;
    //     chatManager.sendMessage(msg);
    //   } else {
    //     msg.msgStatus = WeMessageStatus.MsgStatusFailed;
    //     msg.statusListener?.onMessageStatusUpdate(msg);
    //   }
    // });
  }

  _resendMessage(WeMessage msg) {
    chatManager.sendMessage(msg);
  }

  void _appMemberDialog(BuildContext context) {
    showTextInputDialog(
      context: context,
      title: "邀请成员",
      textFields: [
        DialogTextField(hintText: "请输入对方的clientId"),
      ],
    ).then((value) {
      if (value == null) return;
      String clientId = value[0];
      _appMember(clientId);
    });
  }

  void _appMember(String clientId) async {
    try {
      await WeClient.getInstance.conversationManager
          .addMember(widget.conversation.id, [clientId]);
    } on WeError catch (e) {
      showToast(e.description);
    }
  }

}


class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return buildViewportChrome(context, child, axisDirection);
      // return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}

