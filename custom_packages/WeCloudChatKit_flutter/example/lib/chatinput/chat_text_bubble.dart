import 'package:flutter/material.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';

class ChatTextBubble extends StatelessWidget {
  final WeMessage msg;
  final bool isSend;

  const ChatTextBubble(this.msg, {Key? key, this.isSend = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSend ? Color(0xFF5C6EEA) : Colors.white,
      padding: EdgeInsets.symmetric(
          vertical: 8, horizontal: 12),
      child: Text(
        msg.text ?? "",
        style: TextStyle(
          color: isSend ? Colors.white : Color(0xFF151736),
          fontSize: 13,
        ),
      ),
    );
  }
}