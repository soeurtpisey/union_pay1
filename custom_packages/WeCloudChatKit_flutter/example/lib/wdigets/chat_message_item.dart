import 'package:flutter/material.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/chatinput/chat_image_bubble.dart';
import 'package:wecloudchatkit_flutter_example/constant.dart';
import 'package:wecloudchatkit_flutter_example/chatinput/chat_text_bubble.dart';
import 'package:wecloudchatkit_flutter_example/utils/log_util.dart';
import 'package:wecloudchatkit_flutter_example/utils/sp_util.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/chat_video_bubble.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/custom_msg_helper.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/message_helper.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/red_envelope_bubble.dart';

typedef OnErrorMessageTap = Function(WeMessage msg);
typedef OnMessageLongPress = Function(WeMessage msg);
typedef OnMessageTap = Function(WeMessage msg);

class ChatMessageItem extends StatefulWidget {
  WeMessage message;

  ChatMessageItem({
    required this.message,
    this.onTap,
    this.onLongPress,
    this.onErrorBtnTap,
    this.onAvatarTap,
  });

  /// 长按消息bubble
  final OnMessageLongPress? onLongPress;

  /// 点击消息bubble
  final OnMessageTap? onTap;

  /// 重发按钮点击
  final OnErrorMessageTap? onErrorBtnTap;

  /// 头像按钮点击
  final Function(String cid)? onAvatarTap;

  @override
  State<ChatMessageItem> createState() => ChatMessageItemState();
}

class ChatMessageItemState extends State<ChatMessageItem>
    implements MessageStatusListener {
  @override
  void initState() {
    super.initState();
    widget.message.setMessageListener(this);
  }

  @override
  void didUpdateWidget(covariant ChatMessageItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.message.setMessageListener(null);
    widget.message.setMessageListener(this);
  }

  void dispose() {
    widget.message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String clientId = SpUtil.getString(Constant.KEY_CLIENT_ID);
    bool isRecv = widget.message.sender != clientId;
    Widget message = Container();
    if (widget.message.system ||
        widget.message.event ||
        widget.message.withdraw) {
      String hint = getSystemMsg(widget.message);
      message = Container(
          child: Center(
              child: Text(hint,
                  style: TextStyle(fontSize: 10, color: Color(0xFF9E9EA5)))));
    } else {
      message = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        textDirection: isRecv ? TextDirection.ltr : TextDirection.rtl,
        children: [
          Container(
            height: 33,
            width: 33,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.only(
              left: isRecv ? 16 : 8,
              right: !isRecv ? 16 : 8,
            ),
            child: _avatarWidget(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isRecv)
                Container(
                  margin: EdgeInsets.only(bottom: 3),
                  child: Text(
                    widget.message.sender!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9E9EA5),
                    ),
                  ),
                ),
              _messageWidget(isRecv),
            ],
          )
        ],
      );
    }
    return Builder(builder: (_) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: message,
      );
    });
  }

  /// 头像 widget
  _avatarWidget() {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      onPressed: () {
        widget.onAvatarTap?.call(widget.message.sender!);
      },
      child: Icon(Icons.account_circle, size: 40),
    );
  }

  /// 消息 widget
  _messageWidget(bool isRecv) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            widget.onTap?.call(widget.message);
          },
          onLongPress: () {
            if (widget.onLongPress != null) {
              widget.onLongPress?.call(widget.message);
            }
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 220,
            ),
            margin: EdgeInsets.only(top: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(!isRecv ? 10 : 0),
                topRight: Radius.circular(isRecv ? 10 : 0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: _messageBubble(),
            ),
          ),
        );
      },
    );
  }

  _messageStateWidget(bool isRecv) {
    // 发出的消息
    if (!isRecv) {
      // 对方已读
      return Builder(
        builder: (_) {
          if (widget.message.msgStatus == WeMessageStatus.MsgStatusSending ||
              widget.message.msgStatus == WeMessageStatus.MsgStatusNone) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 1),
              ),
            );
          } else if (widget.message.msgStatus ==
              WeMessageStatus.MsgStatusFailed) {
            return IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.error, color: Colors.red, size: 30),
              onPressed: () {
                if (widget.onErrorBtnTap != null) {
                  widget.onErrorBtnTap?.call(widget.message);
                }
              },
            );
          }
          return Container();
        },
      );
    }
    return Container();
  }

  @override
  void onMessageSendFail(String reqId, int errCode) {
    widget.message.msgStatus = WeMessageStatus.MsgStatusFailed;
    setState(() {});
  }

  @override
  void onMessageStatusUpdate(WeMessage message) {
    widget.message.msgStatus = message.msgStatus;
    setState(() {});
  }

  _messageBubble() {
    WeMessage msg = widget.message;
    String clientId = SpUtil.getString(Constant.KEY_CLIENT_ID);
    bool isSend = msg.sender == clientId;
    return Builder(builder: (_) {
      Widget bubble;
      switch (msg.type) {
        case WeMessageType.MSG_TXT:
          bubble = ChatTextBubble(msg, isSend: isSend);
          break;
        case WeMessageType.MSG_IMAGE:
          bubble = ChatImageBubble(msg, isSend);
          break;
        case WeMessageType.MSG_VIDEO:
          bubble = ChatVideoBubble(msg, isSend);
          break;
        case WeMessageType.MSG_CUSTOM:
          var attrs = msg.attrs ?? {};
          if (attrs["CustomType"] == CustMessageType.redEnvelope.value) {
            bubble = RedEnvelopeBubble(msg, isSend);
          } else {
            bubble = Container(
              color: isSend ? Color(0xFF5C6EEA) : Colors.white,
            );
          }
          break;
        default:
          bubble = Container(
            color: isSend ? Color(0xFF5C6EEA) : Colors.white,
          );
          break;
      }
      return bubble;
    });
  }
}
