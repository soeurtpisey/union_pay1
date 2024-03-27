// 红包气泡

import 'package:flutter/material.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';

class RedEnvelopeBubble extends StatelessWidget {
  RedEnvelopeBubble(
    this.message, [
    this.isSend = false,
  ]);

  final WeMessage message;
  final bool isSend;

  /// 最大长度
  final double maxSize = 200;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? attrs = message.attrs ?? {};
    int redType = int.parse(attrs["redEnvelopeType"] ?? "0"); //红包类型
    String? redId = attrs["redEnvelopeId"]; //红包id
    String? receiverAccount;
    if (attrs["receiverAccountCode"] != null)
      receiverAccount = attrs["receiverAccountCode"]; //接收人账户编码 可空
    bool isReceive = attrs["isReceive"]?.toLowerCase() == 'true'; //是否可领取
    return Container(
      color: isSend ? Color(0xFF5C6EEA) : Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        "恭喜发财-$redType",
        style: TextStyle(
          color: isSend ? Colors.white : Color(0xFF151736),
          fontSize: 13,
        ),
      ),
    );
  }
}
