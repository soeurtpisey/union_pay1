import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/constant.dart';
import 'package:wecloudchatkit_flutter_example/utils/sp_util.dart';

String getSystemMsg(WeMessage message) {
  String? hint = "未知消息";
  String clientId = SpUtil.getString(Constant.KEY_CLIENT_ID);
  if (message.withdraw) {
    //被操作者
    String? pOperatorName =
        message.passivityOperator == clientId ? "你" : message.passivityOperator;
    //操作者
    String? operatorName =
        message.operator == clientId ? "你" : message.operator;

    if (pOperatorName == operatorName) {
      hint = "$operatorName 撤回了一条消息";
    } else {
      hint = "$operatorName 撤回了$pOperatorName 的一条消息";
    }
  }

  if (message.event) {
    switch (message.type) {
      case WeMessageType.CONV_EVENT_NAME_CHANGE:
        //会话名称字段变动   不用回执
        hint = "${message.sender}修改会话名称改为${message.name}";
        break;
      case WeMessageType.CONV_EVENT_ATTR_CHANGE:
        //会话拓展字段变动   不用回执
        hint = "会话属性改变：${message.attributes}";
        break;
      case WeMessageType.CONV_EVENT_OWNER_CHANGE:
        //xx成为新群主   要回执
        hint = "${message.sender}成为新群主";
        break;
      case WeMessageType.CONV_EVENT_MEMBER_EXIT:
        //xx主动退出会话   要回执
        hint = "${message.sender}主动退出会话";
        break;
      case WeMessageType.CONV_EVENT_ADD_CONV:
        //xx被xx拉入新会话
        //被操作者
        String? pOperatorName = message.passivityOperator == clientId
            ? "你"
            : message.passivityOperator;
        //操作者
        String? operatorName =
            message.operator == clientId ? "你" : message.operator;
        hint = "${pOperatorName}被${operatorName}拉入新会话";
        break;
      case WeMessageType.CONV_EVENT_DRIVE_OUT_CONV:
        // xx被xx移出会话   要回执
        hint = "${message.passivityOperator}被${message.operator}移出会话";
        break;
      case WeMessageType.CONV_EVENT_MEMBER_ADD:
        //xx邀请xx加入会话   要回执
        hint = "${message.operator}邀请${message.passivityOperator}加入会话";
        break;
      case WeMessageType.CONV_EVENT_DISBAND:
        //解散群聊
        hint = "${message.operator}解散了群聊";
        break;
      case WeMessageType.CONV_EVENT_MUTED:
        //群全体禁言
        hint = "${message.operator}开启了全体禁言";
        break;
      case WeMessageType.CONV_EVENT_MUTED_CANCEL:
        //取消全体禁言
        hint = "${message.operator}取消了全体禁言";
        break;
      default:
        break;
    }
  }
  return hint;
}
