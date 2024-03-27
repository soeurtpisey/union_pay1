import 'package:flutter/material.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/constant.dart';
import 'package:wecloudchatkit_flutter_example/utils/StringUtils.dart';
import 'package:wecloudchatkit_flutter_example/utils/conversation_helper.dart';
import 'package:wecloudchatkit_flutter_example/utils/sp_util.dart';

class ConversationItem extends StatefulWidget {
  const ConversationItem({Key? key, required this.conversation, this.onTap})
      : super(key: key);

  final WeConversation conversation;
  final VoidCallback? onTap;

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem>
    implements ConversationUpdateListener {
  @override
  void initState() {
    super.initState();
    widget.conversation.setConversationUpdateListener(this);
  }

  @override
  void didUpdateWidget(covariant ConversationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    //setState时更新事件防止注册事件被新数据替换为null
    oldWidget.conversation.setConversationUpdateListener(null);
    widget.conversation.setConversationUpdateListener(this);
  }

  @override
  void dispose() {
    widget.conversation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => this.widget.onTap?.call(),
      child: Container(
        height: 65,
        padding: EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _builderAvatar(widget.conversation),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _builderTitle(widget.conversation),
                      Spacer(),
                      _builderTime(widget.conversation),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Row(
                      children: <Widget>[
                        _builderContent(widget.conversation),
                        Spacer(),
                        _builderBadge(widget.conversation),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 0.5,
                        color: Color(0xffE5E5E5),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _builderAvatar(WeConversation conv) {
    Widget avatar;
    if (conv.isSingleChat()) {
      String clientId = SpUtil.getString(Constant.KEY_CLIENT_ID);
      var members = conv.members?.split(",")??[];
      var otherPartyCID = members.where((element) => element != clientId).first;
      //TODO 单聊头像 通过otherPartyCID获取
      avatar = CircleAvatar(
        backgroundImage: NetworkImage(
            "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg"),
        radius: 20.0,
      );
    } else {
      //TODO 默认群聊头像
      avatar = CircleAvatar(
        backgroundImage: AssetImage("images/create_group.png",),
        radius: 20.0,
      );
    }
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: avatar,
    );
  }

  _builderTitle(WeConversation conv) {
    return Text(
      conv.getConvName(),
      style: TextStyle(fontSize: 15, color: Colors.black),
    );
  }

  _builderTime(WeConversation conv) {
    return Container(
      child: Text(
        conv.updateTime == 0 ? "" : timeStrByMs(conv.updateTime),
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      margin: EdgeInsets.only(right: 15),
    );
  }

  _builderContent(WeConversation conv) {
    return Text(
      conv.lastMsg?.text ?? "",
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  _builderBadge(WeConversation conv) {
    if (conv.msgNotReadCount == 0) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(right: 15),
      width: 15,
      height: 15,
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.red, width: 0.5),
        color: Colors.red,
        shape: BoxShape.circle, // 默认值也是矩形
      ),
      child: Center(
        child: Text(
          conv.msgNotReadCount.toString(),
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  @override
  void onUpdateConversation(ConvUpdateEvent event,WeConversation conversation) {
    widget.conversation.update(conversation);
    setState(() {});
  }
}
