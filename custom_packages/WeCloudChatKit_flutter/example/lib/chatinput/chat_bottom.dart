import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wecloudchatkit_flutter_example/chatinput/chat_more_view.dart';
import 'package:wecloudchatkit_flutter_example/chatinput/emoji_widget.dart';
import 'package:wecloudchatkit_flutter_example/chatinput/image_button.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:wecloudchatkit_flutter_example/chatinput/record_widget.dart';
import 'package:wecloudchatkit_flutter_example/constant.dart';
import 'package:wecloudchatkit_flutter_example/utils/log_util.dart';
import 'package:wecloudchatkit_flutter_example/utils/sp_util.dart';

enum InputType {
  text,
  voice,
  emoji,
  extra,
}

typedef void OnSend(String text);
typedef void OnImageSelect(File mFile);
typedef void OnAudioCallBack(File mAudioFile, int duration);

class ChatBottomInputWidget extends StatefulWidget {
  final OnSend onSendCallBack;

  final OnAudioCallBack? onAudioCallBack;

  final Stream shouldTriggerChange;

  final List<ChatMoreViewItem> moreBtnList;

  const ChatBottomInputWidget({
    Key? key,
    required this.shouldTriggerChange,
    required this.onSendCallBack,
    this.onAudioCallBack,
    required this.moreBtnList,
  }) : super(key: key);

  @override
  _ChatBottomInputWidgetState createState() => _ChatBottomInputWidgetState();
}

class _ChatBottomInputWidgetState extends State<ChatBottomInputWidget>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  InputType mCurrentType = InputType.text;

  FocusNode focusNode = FocusNode();

  TextEditingController mEditController = TextEditingController();

  double _softKeyHeight = SpUtil.getDouble(Constant.KEY_SOFTKEY_HEIGHT, 264);

  final GlobalKey globalKey = GlobalKey();

  bool mBottomLayoutShow = false;

  bool mAddLayoutShow = false;

  StreamSubscription? streamSubscription;

  late StreamSubscription<bool> keyboardSubscription;

  @override
  void didChangeMetrics() {
    final mediaQueryData = MediaQueryData.fromWindow(ui.window);
    final keyHeight = mediaQueryData.viewInsets.bottom;
    if (keyHeight > _softKeyHeight) {
      _softKeyHeight = keyHeight;
      Log.d("键盘高度是:" + _softKeyHeight.toString());
    }
  }

  @override
  didUpdateWidget(ChatBottomInputWidget old) {
    super.didUpdateWidget(old);
    if (widget.shouldTriggerChange != old.shouldTriggerChange) {
      streamSubscription?.cancel();
      streamSubscription =
          widget.shouldTriggerChange.listen((_) => hideBottomLayout());
    }
  }

  @override
  dispose() {
    streamSubscription?.cancel();
    keyboardSubscription.cancel();
    super.dispose();
  }

  void hideBottomLayout() {
    setState(() {
      this.mCurrentType = InputType.text;
      mBottomLayoutShow = false;
      mAddLayoutShow = false;
    });
  }

  @override
  void initState() {
    super.initState();
    streamSubscription =
        widget.shouldTriggerChange.listen((_) => hideBottomLayout());
    WidgetsBinding.instance?.addObserver(this);
    mEditController.addListener(() {
      //TODO 输入内容改变  mEditController.text
    });

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        mBottomLayoutShow = true;
        if (mCurrentType == InputType.emoji) {
          this.mCurrentType = InputType.text;
        }
        setState(() {});
      } else {
        if (mBottomLayoutShow) {
          if (mAddLayoutShow) {
          } else {
            if (mCurrentType != InputType.emoji) {
              mBottomLayoutShow = false;
              setState(() {});
            }
          }
        } else {}
      }
    });
  }

  Future requestPermission() async {
    // 申请结果
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.microphone,
    ].request();
    if (statuses[Permission.storage]?.isGranted == true &&
        statuses[Permission.microphone]?.isGranted == true) {
      //  Fluttertoast.showToast(msg: "权限申请通过");
    } else {
      //Fluttertoast.showToast(msg: "权限申请被拒绝");
    }
  }

  @override
  Widget build(BuildContext context) {
    requestPermission();

    return Container(
      color: Color(0xffF8F8F8),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              buildLeftButton(),
              Expanded(child: buildInputBar()),
              buildEmojiButton(),
              buildExtraButton(),
            ],
          ),
          _buildBottomContainer(child: _buildBottomItems()),
        ],
      ),
    );
  }

  ///左侧按钮（语音和键盘切换）
  Widget buildLeftButton() {
    return mCurrentType == InputType.voice
        ? mKeyBoardButton()
        : mRecordButton();
  }

  Widget buildInputBar() {
    final voiceButton = mVoiceButton(context);
    final inputButton = Row(
      children: [
        Expanded(child: mInputBar(context)),
        buildSend(),
      ],
    );
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Stack(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Offstage(
            child: voiceButton,
            offstage: mCurrentType != InputType.voice,
          ),
          Offstage(
            child: inputButton,
            offstage: mCurrentType == InputType.voice,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(new Radius.circular(20.0)),
      ),
    );
  }

  Widget buildEmojiButton() {
    return mCurrentType != InputType.emoji
        ? mEmojiButton()
        : mEmojiKeyBoardButton();
  }

  Widget buildExtraButton() {
    return ImageButton(
        image: AssetImage("images/ic_add.png"),
        onPressed: () {
          this.mCurrentType = InputType.extra;
          if (mBottomLayoutShow) {
            if (mAddLayoutShow) {
              mAddLayoutShow = false;
              showSoftKey();
            } else {
              mAddLayoutShow = true;
              hideSoftKey();
            }
            mBottomLayoutShow = true;
            setState(() {});
          } else {
            if (focusNode.hasFocus) {
              hideSoftKey();
              Future.delayed(const Duration(milliseconds: 50), () {
                setState(() {
                  mBottomLayoutShow = true;
                  mAddLayoutShow = true;
                });
              });
            } else {
              mBottomLayoutShow = true;
              mAddLayoutShow = true;
              setState(() {});
            }
          }
        });
  }

  Widget mRecordButton() {
    return ImageButton(
      onPressed: () {
        this.mCurrentType = InputType.voice;
        hideSoftKey();
        mBottomLayoutShow = false;
        setState(() {});
      },
      image: AssetImage("images/ic_audio.png"),
    );
  }

  Widget mKeyBoardButton() {
    return ImageButton(
      onPressed: () {
        this.mCurrentType = InputType.text;
        showSoftKey();
        setState(() {});
      },
      image: AssetImage("images/ic_keyboard.png"),
    );
  }

  Widget mEmojiKeyBoardButton() {
    return ImageButton(
      onPressed: () {
        this.mCurrentType = InputType.text;
        mBottomLayoutShow = true;
        showSoftKey();
        setState(() {});
      },
      image: AssetImage("images/ic_keyboard.png"),
    );
  }

  Widget mVoiceButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RecordWidget(
        startRecord: startRecord,
        stopRecord: stopRecord,
      ),
    );
  }

  startRecord() {
    print("开始录制");
  }

  stopRecord(bool isCancel, String path, double audioTimeLength) {
    print("结束束录制 $isCancel");
    print("音频文件位置" + path);
    print("音频录制时长" + audioTimeLength.toString());
    if (!isCancel && widget.onAudioCallBack != null) {
      widget.onAudioCallBack!(File(path), (audioTimeLength * 1000).toInt());
    }
  }

  Widget mEmojiButton() {
    return ImageButton(
      onPressed: () {
        this.mCurrentType = InputType.emoji;
        setState(() {
          mBottomLayoutShow = true;
        });
        hideSoftKey();
      },
      image: AssetImage("images/ic_emoji.png"),
    );
  }

  Widget buildSend() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      width: 60,
      height: 30,
      child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all(Color(0xffFF8200)),
            overlayColor: MaterialStateProperty.all(Color(0xffFFD8AF)),
            textStyle:
                MaterialStateProperty.all(TextStyle(color: Colors.white)),
            shape: MaterialStateProperty.all(StadiumBorder())),
        onPressed: () {
          widget.onSendCallBack.call(mEditController.text.trim());
          mEditController.clear();
        },
        child: Text("发送", style: TextStyle(fontSize: 16.0)),
      ),
    );
  }

  void showSoftKey() {
    FocusScope.of(context).requestFocus(focusNode);
  }

  void hideSoftKey() {
    focusNode.unfocus();
  }

  Widget _buildBottomContainer({Widget? child}) {
    return Visibility(
      visible: mBottomLayoutShow,
      child: Container(
        key: globalKey,
        child: child,
        height: _softKeyHeight,
      ),
    );
  }

  Widget _buildBottomItems() {
    if (this.mCurrentType == InputType.extra) {
      return Visibility(
          visible: mAddLayoutShow, child: ChatMoreView(widget.moreBtnList));
    } else if (mCurrentType == InputType.emoji) {
      return Visibility(
        visible: mCurrentType == InputType.emoji,
        child: EmojiWidget(onEmojiClockBack: (value) {
          if (0 == value) {
            mEditController.clear();
          } else {
            mEditController.text =
                mEditController.text + String.fromCharCode(value);
          }
        }),
      );
    } else {
      return Container();
    }
  }

  mInputBar(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 80.0,
        minHeight: 40.0,
      ),
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        //minLines: 1,
        style: TextStyle(fontSize: 16),
        focusNode: focusNode,
        controller: mEditController,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
        ),
      ),
    );
  }
}

class ChangeChatTypeNotification extends Notification {
  final String type;

  ChangeChatTypeNotification(this.type);
}
