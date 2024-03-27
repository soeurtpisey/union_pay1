import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/constant.dart';
import 'package:wecloudchatkit_flutter_example/utils/sp_util.dart';

extension WeConversationExtension on WeConversation {
  getConvName() {
    String name = "";
    if (isSingleChat()) {
      String clientId = SpUtil.getString(Constant.KEY_CLIENT_ID);
      var members = this.members?.split(",")??[];
      var otherPartyCID = members.where((element) => element != clientId).first;
      name = otherPartyCID;
    } else {
      name = this.name ?? "";
    }
    return name;
  }

  String? getSingleOtherPartyCID() {
    if (isSingleChat()) {
      String clientId = SpUtil.getString(Constant.KEY_CLIENT_ID);
      var members = this.members?.split(",")??[];
      var otherPartyCID = members.where((element) => element != clientId).first;
      return otherPartyCID;
    }
    return null;
  }

  isSingleChat() => chatType == WeConversationType.CONV_TYPE_SINGLE;
}
