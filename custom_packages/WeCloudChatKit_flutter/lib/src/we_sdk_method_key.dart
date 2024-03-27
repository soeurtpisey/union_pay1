class WeSDKMethodKey {
  //初始化
  static const String initialize = "initialize";

  //登录且开启模块
  static const String loginAndOpen = "loginAndOpen";

  //模块是否已登录
  static const String isLogin = "isLogin";

  //开启模块
  static const String open = "open";

  //开启模块
  static const String openModel = "openModel";

  //关闭模块
  static const String close = "close";

  //添加或修改推送设备信息
  static const updateDeviceInfo = "updateDeviceInfo";

  /// 获取设备token
  static const onDeviceToken = "OnDeviceToken";

  //创建会话
  static const String createConversation = "createConversation";

  //加入聊天室
  static const String joinChatRoom = "joinChatRoom";

  //退出聊天室
  static const String exitChatRoom = "exitChatRoom";

  //查询聊天室成员
  static const String findChatRoomMembers = "findChatRoomMembers";

  //查询会话
  static const String findConversationById = "findConversationById";

  //解散群聊
  static const String disbandConversation = "disbandConversation";

  //询加入的会话
  static const String searchDisplayConversationList =
      "searchDisplayConversationList";

  //查询会话中指定类型的消息
  static const String findConvMsgByType = "findConvMsgByType";

  //查询本地所有会话，包含隐藏的
  static const String searchGroupConversations = "searchGroupConversations";

  //显示或隐藏会话
  static const String displayConversation = "displayConversation";

  //删除会话(逻辑删除，隐藏会话并删除会话中的所有消息)
  static const String deleteConversations = "deleteConversations";

  //删除会话（删除数据库中关于此会话的所有数据）
  static const String deleteConversationFromDB = "deleteConversationFromDB";

  //退出会话
  static const String leaveConv = "leaveConv";

  //设置群管理员
  static const String setupConvAdmins = "setupConvAdmins";

  //群主转让
  static const String convTransferOwner = "convTransferOwner";

  //群成员禁言
  static const String convMutedGroupMenber = "convMutedGroupMenber";

  //撤回消息
  static const String withdrawMsg = "withdrawMsg";

  //删除消息(连同服务器一起删除)
  static const String deleteMsgAndNetwork = "deleteMsgAndNetwork";

  //删除会话的所有消息(只删除本地数据库)
  static const String deleteAllMsgByConvId = "deleteAllMsgByConvId";

  //删除指定的消息
  static const String deleteAllMsg = "deleteAllMsg";

  //消息已读回执
  static const String msgReadUpdate = "msgReadUpdate";

  //把会话中msgIdEnd之前所有消息更新为已读
  static const String msgReadAllConvUpdate = "msgReadAllConvUpdate";

  //查询指定消息
  static const String findMessage = "findMessage";

  //拉入黑名单
  static const String addBlacklist = "addBlacklist";

  //移除黑名单
  static const String delBlacklist = "delBlacklist";

  // 黑名单分页列表
  static const String findBlacklist = "findBlacklist";

  //查询群用户信息
  static const String findGroupInfoList = "findGroupInfoList";

  ///好友事件
  //申请好友的事件
  static const String onApplyFriendEvent = "onApplyFriendEvent";

  //发出请求的审批结果
  static const String onApproveFriendEvent = "onApproveFriendEvent";

  //申请添加好友
  static const String applyFriend = "applyFriend";

  //接受/拒绝好友申请
  static const String approveFriend = "approveFriend";

  //删除好友
  static const String batchDeleteFriend = "batchDeleteFriend";

  //总未读数改变
  static const String onTotalNotReadCountChangeListener =
      "onTotalNotReadCountChangeListener";

  ///消息事件
  //消息状态更新
  static const String onMessageStatusUpdate = "onMessageStatusUpdate";

  //消息发送失败
  static const String onMessageSendFail = "onMessageSendFail";

  //收到消息
  static const String onMessageReceived = "onMessageReceived";

  //会话同步完成
  static const String OnConvSyncStatusComplete = "OnConvSyncStatusComplete";

  //发送消息预处理
  static const String onDefaultMsgBeforeSendHandler =
      "onDefaultMsgBeforeSendHandler";

  //接收消息预处理
  static const String onDefaultMsgBeforeReceiveHandler =
      "onDefaultMsgBeforeReceiveHandler";

  //发送消息
  static const String sendMessage = "sendMessage";

  //插入消息到数据库
  static const String insertMessageDB = "insertMessageDB";

  //更新消息的文件的本地路径
  static const String updateMessageFileLocPath = "updateMessageFileLocPath";

  //更新消息的属性
  static const String updateMessageAttrs = "updateMessageAttrs";

  //同步离线消息
  static const String syncOfflineMessages = "syncOfflineMessages";

  //查询历史消息(分页)
  static const String findHistMsg = "findHistMsg";

  //查询本地所有聊天记录
  static const String findMessageFromHistory = "findMessageFromHistory";

  //通过时间查询聊天记录
  static const String findMessageFromHistoryByTime =
      "findMessageFromHistoryByTime";

  ///会话事件
  //会话事件
  static const String onConversationEvent = "onConversationEvent";

  //会话更新（未读数，是否@等服务器返回数据变化时）
  static const String onUpdateConversation = "onUpdateConversation";

  //会话添加
  static const String onAddConversation = "onAddConversation";

  //会话删除
  static const String onRemoveConversation = "onRemoveConversation";

  //添加会话成员
  static const String addMember = "addMember";

  //更新本地会话名字
  static const String updateNameFromLocal = "updateNameFromLocal";

  //更新本地会话头像
  static const String updateHeadPortraitFromLocal =
      "updateHeadPortraitFromLocal";

  //删除会话成员
  static const String delMember = "delMember";

  //查询本会话的成员
  static const String searchConvMembers = "searchConvMembers";

  //添加或修改会话的拓展字段
  static const String updateConversationAttr = "updateConversationAttr";

  //修改群名字 (群主可用)
  static const String updateConversationName = "updateConversationName";

  //修改群昵称
  static const String updateConvMemberRemark = "updateConvMemberRemark";

  //设置群禁言
  static const String setGroupMuted = "setGroupMuted";

  //草稿
  static const String saveDraft = "saveDraft";

  //群解散状态
  static const String setDisband = "setDisband";

  //同步群会话成员
  static const String syncGroupMembers = "syncGroupMembers";

// 更新本地会话数据
  static const String onUpdateConversationFromDB = "onUpdateConversationFromDB";

  ///单人RTC事件
  //接收到RTC邀请
  static const String onProcessCallEvent = "onProcessCallEvent";

  //有client加入频道
  static const String onProcessJoinEvent = "onProcessJoinEvent";

  //有client离开频道
  static const String onProcessLeaveEvent = "onProcessLeaveEvent";

  //有Client拒绝加入频道
  static const String onProcessRejectEvent = "onProcessRejectEvent";

  //client SDP 下发
  static const String onProcessSdpEvent = "onProcessSdpEvent";

  // client Candidate 下发
  static const String onProcessCandidateEvent = "onProcessCandidateEvent";

  //创建频道,并邀请客户端加入
  static const String createAndCall = "createAndCall";

  //同意进入频道
  static const String joinRtcChannel = "joinRtcChannel";

  //拒接进入频道
  static const String rejectRtcCall = "rejectRtcCall";

  //SDP数据转发
  static const String sdpForward = "sdpForward";

  //candidate候选者数据转发
  static const String candidateForward = "candidateForward";

  //主动挂断(离开频道)
  static const String leaveRtcChannel = "leaveRtcChannel";

  //透传消息事件下发
  static const String onTransparentMessageEvent = "onTransparentMessageEvent";


  //SDK连接事件
  static const String onSDKConnEvent = "onSDKConnEvent";

  //获取当前连接状态
  static const String getConnectingStatus = "getConnectingStatus";
}
