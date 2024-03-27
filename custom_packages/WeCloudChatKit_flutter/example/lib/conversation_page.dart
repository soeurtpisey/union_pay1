import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wecloudchatkit_flutter/im_flutter_sdk.dart';
import 'package:wecloudchatkit_flutter_example/single_rtc/call_sample.dart';
import 'package:wecloudchatkit_flutter_example/single_rtc/signaling.dart';
import 'package:wecloudchatkit_flutter_example/utils/log_util.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/conversation_item.dart';
import 'package:wecloudchatkit_flutter_example/wdigets/pop_menu.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    implements
        MessageReceivedListener,
        ConversationListener,
        SingleRTCListener {
  List<WeConversation> _conversationsList = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    WeClient.getInstance.conversationManager.addConversationListener(this);
    WeClient.getInstance.chatManager.addReceivedListener(this);
    WeClient.getInstance.singleRtcManager.addRTCListener(this);
    _loadAllConversations();
  }

  void dispose() {
    _refreshController.dispose();
    WeClient.getInstance.conversationManager.removeConversationListener(this);
    WeClient.getInstance.chatManager.removeReceivedListener(this);
    WeClient.getInstance.singleRtcManager.removeRTCListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('会话列表'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => PopMenu.show(
              context,
              [
                PopMenuItem('创建群组'),
                PopMenuItem('发起聊天'),
                PopMenuItem('发起加密聊天'),
                PopMenuItem('创建聊天室'),
                PopMenuItem('加入聊天室'),
                PopMenuItem('退出登录'),
              ],
              callback: (index) {
                if (index == 0) {
                  //创建群组
                  _createGroupChatDialog(context);
                } else if (index == 1) {
                  //发起聊天
                  _createChatDialog(context,false);
                } else if (index == 2) {
                  //发起加密聊天
                  _createChatDialog(context,true);
                } else if (index == 3) {
                  //创建聊天室
                  _createChatRoomDialog(context);
                } else if (index == 4) {
                  //加入聊天室

                } else if (index == 5) {
                  //退出登录
                  _logout(context);
                }
              },
            ),
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        onRefresh: () => _loadAllConversations(),
        controller: _refreshController,
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildConvWidgetForIndex(index);
              },
              childCount: _conversationsList.length,
            ))
          ],
        ),
      ),
    );
  }

  @override
  void onMessagesReceived(WeMessage message) {
    var conv = _conversationsList
        .where((element) => element.id == message.conversationId)
        .first;
    conv.lastMsg = message;
    conv.updateListener
        ?.onUpdateConversation(ConvUpdateEvent.REFRESH_CONVERSATION, conv);
  }

  void _loadAllConversations() async {
    try {
      List<WeConversation> list =
          await WeClient.getInstance.searchDisplayConversationList() ?? [];

      _conversationsList.clear();
      _conversationsList.addAll(list);
      _refreshController.refreshCompleted();
      int count = 0;
      for (var conversation in _conversationsList) {
        count += conversation.msgNotReadCount;
      }
      //更新总未读数
    } on Error {
      _refreshController.refreshFailed();
    } finally {
      setState(() {});
    }
  }

  Widget _buildConvWidgetForIndex(int index) {
    var conv = _conversationsList[index];
    return ConversationItem(
      key: Key(conv.id.toString()),
      conversation: conv,
      onTap: () => {_openChatPage(_conversationsList[index])},
    );
  }

  /// 会话被点击
  _openChatPage(WeConversation con) async {
    Navigator.of(context).pushNamed(
      '/chat',
      arguments: [con],
    ).then((value) {
      // 返回时刷新页面
      _loadAllConversations();
    });
  }

  @override
  void onAddConversation(WeConversation conversation) {
    Log.e(conversation.name ?? conversation.id);
    _conversationsList.insert(0, conversation);
    setState(() {});
  }

  @override
  void onConversationEvent(WeConvEvent convEvent) {
    Log.e(convEvent.type);
    _loadAllConversations();
  }

  @override
  void onRemoveConversation(int conversationId) {
    WeConversation conv = _conversationsList
        .where((element) => element.id == conversationId)
        .first;
    _conversationsList.remove(conv);
  }

  void _logout(BuildContext context) {
    showOkCancelAlertDialog(context: context, title: "确定要退出吗？")
        .then((value) => {
              if (OkCancelResult.ok == value)
                {
                  WeClient.getInstance.close().then((value) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (route) => false);
                  })
                }
            });
  }

  void _createGroupChatDialog(BuildContext context) {
    showTextInputDialog(
      context: context,
      title: "创建群聊",
      textFields: [
        DialogTextField(hintText: "请输入群名称"),
        DialogTextField(hintText: "请输入邀请的clientId用‘,’分割"),
      ],
    ).then((value) {
      if (value == null) return;
      String name = value[0];
      List<String> clientIds = value[1].split(",");
      if (clientIds.length < 2) {
        showToast("最少邀请2个人");
        return;
      }
      _createGroupChat(name, clientIds);
    });
  }

  void _createGroupChat(String name, List<String> clientIds) async {
    try {
      WeConversation? conv = await WeClient.getInstance.createConversation(
          clientIds, name, null, WeConversationType.CONV_TYPE_GROUP);
      if (conv != null) _openChatPage(conv);
    } on WeError catch (e) {
      showToast(e.description);
    }
  }

  void _createChatDialog(BuildContext context, bool isEncrypt) {
    showTextInputDialog(
      context: context,
      title: isEncrypt ? "创建加密单聊" : "创建单聊",
      textFields: [
        DialogTextField(hintText: "请输入对方的clientId"),
      ],
    ).then((value) {
      if (value == null) return;
      String clientId = value[0];
      _createChat(clientId, isEncrypt);
    });
  }

  void _createChatRoomDialog(BuildContext context) {
    showTextInputDialog(
      context: context,
      title: "创建聊天室",
      textFields: [
        DialogTextField(hintText: "请输入聊天室名称"),
      ],
    ).then((value) {
      if (value == null) return;
      String name = value[0];
      _createChatRoom(name);
    });
  }

  void _createChat(String clientId, bool isEncrypt) async {
    try {
      WeConversation? conv = await WeClient.getInstance.createConversation(
          [clientId], null, null, WeConversationType.CONV_TYPE_SINGLE,
          isEncrypt: isEncrypt);
      if (conv != null) _openChatPage(conv);
    } on WeError catch (e) {
      showToast(e.description);
    }
  }

  void _createChatRoom(String name) async {
    try {
      WeConversation? conv = await WeClient.getInstance.createConversation(
          null, name, null, WeConversationType.CONV_TYPE_CHAT_ROOM);
      if (conv != null) _openChatPage(conv);
    } on WeError catch (e) {
      showToast(e.description);
    }
  }

  @override
  void processCallEvent(WeRTCEvent rtcEvent) {
    // WeRTCType rtcType = rtcEvent.callType == 1 ?WeRTCType.VIDEO:WeRTCType.VOICE;
    // TODO: implement processCallEvent
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CallSample(
                  channelId: rtcEvent.channelId.toString(),
                  toClient: rtcEvent.clientId.toString(),
                  rtcRole: CallRtcRole.CallRtcRoleCallee,
                  rtcType: rtcEvent.callType!,
                )));
  }

  @override
  void processCandidateEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processCandidateEvent
  }

  @override
  void processJoinEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processJoinEvent
  }

  @override
  void processLeaveEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processLeaveEvent
  }

  @override
  void processRejectEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processRejectEvent
  }

  @override
  void processSdpEvent(WeRTCEvent rtcEvent) {
    // TODO: implement processSdpEvent
  }
}
