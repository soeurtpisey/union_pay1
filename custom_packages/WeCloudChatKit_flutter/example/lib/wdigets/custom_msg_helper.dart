import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';

enum CustMessageType {
  redEnvelope,
}

extension CustMessageTypeValue on CustMessageType {
  String get value {
    String ret;
    switch (this) {
      case CustMessageType.redEnvelope:
        ret = "redEnvelope";
        break;
    }
    return ret;
  }

  static CustMessageType typeFromStr(String? type) {
    CustMessageType ret = CustMessageType.redEnvelope;
    switch (type) {
      case "redEnvelope":
        ret = CustMessageType.redEnvelope;
        break;
    }
    return ret;
  }
}

class CustomMsgHelper {
  static WeMessage createRedEnvelopeMsg(
      int conversationId, int redType, String redId,
      {String? receiverAccount}) {
    WeMessage msg = WeMessage.createSendCustomMessage(conversationId);
    Map<String, String> attrs = Map();
    attrs["CustomType"] = CustMessageType.redEnvelope.value; //自定义类型
    attrs["redEnvelopeType"] = redType.toString(); //红包类型
    attrs["redEnvelopeId"] = redId; //红包id
    if (receiverAccount != null)
      attrs["receiverAccountCode"] = receiverAccount; //接收人账户编码 可空
    attrs["isReceive"] = true.toString(); //是否可领取
    msg.attrs = attrs;
    return msg;
  }
}
