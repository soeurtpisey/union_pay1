package cn.wecloud.im.wecloudchatkit_flutter

object WeSDKMethod {
    //初始化
    const val initialize = "initialize";

    //登录且开启模块
    const val loginAndOpen = "loginAndOpen"

    //模块是否已登录
    const val isLogin = "isLogin"

    //开启模块
    const val open = "open"

    //开启模块
    const val openModel = "openModel"

    //关闭模块
    const val close = "close"

    //添加或修改推送设备信息
    const val updateDeviceInfo = "updateDeviceInfo"

    //创建会话
    const val createConversation = "createConversation"

    //加入聊天室
    const val joinChatRoom = "joinChatRoom"

    //退出聊天室
    const val exitChatRoom = "exitChatRoom"

    //查询聊天室成员
    const val findChatRoomMembers = "findChatRoomMembers"

    //查询会话
    const val findConversationById = "findConversationById";

    //解散群聊
    const val disbandConversation = "disbandConversation"

    //询加入的会话
    const val searchDisplayConversationList = "searchDisplayConversationList"

    //查询会话中指定类型的消息
    const val findConvMsgByType = "findConvMsgByType"

    //查询本地所有会话，包含隐藏的
    const val searchGroupConversations = "searchGroupConversations"

    //显示或隐藏会话
    const val displayConversation = "displayConversation"

    //删除会话(逻辑删除，隐藏会话并删除会话中的所有消息)
    const val deleteConversations = "deleteConversations"

    //删除会话（删除数据库中关于此会话的所有数据）
    const val deleteConversationFromDB = "deleteConversationFromDB"

    //退出会话
    const val leaveConv = "leaveConv"

    //设置群管理员
    const val setupConvAdmins = "setupConvAdmins"

    //群主转让
    const val convTransferOwner = "convTransferOwner"

    //群成员禁言
    const val convMutedGroupMenber = "convMutedGroupMenber"

    //撤回消息
    const val withdrawMsg = "withdrawMsg"

    //删除消息(连同服务器一起删除)
    const val deleteMsgAndNetwork = "deleteMsgAndNetwork"

    //删除会话的所有消息(只删除本地数据库)
    const val deleteAllMsgByConvId = "deleteAllMsgByConvId"

    //删除指定的消息
    const val deleteAllMsg = "deleteAllMsg"

    //消息已读回执
    const val msgReadUpdate = "msgReadUpdate"

    //把会话中msgIdEnd之前所有消息更新为已读
    const val msgReadAllConvUpdate = "msgReadAllConvUpdate"

    //查询指定消息
    const val findMessage = "findMessage"

    //拉入黑名单
    const val addBlacklist = "addBlacklist"

    //移除黑名单
    const val delBlacklist = "delBlacklist"

    // 黑名单分页列表
    const val findBlacklist = "findBlacklist"

    //查询群用户信息
    const val findGroupInfoList = "findGroupInfoList"


    ///好友事件
    //申请好友的事件
    const val onApplyFriendEvent = "onApplyFriendEvent"

    //发出请求的审批结果
    const val onApproveFriendEvent = "onApproveFriendEvent"

    //申请添加好友
    const val applyFriend = "applyFriend"

    //接受/拒绝好友申请
    const val approveFriend = "approveFriend"

    //删除好友
    const val batchDeleteFriend = "batchDeleteFriend"

    //总未读数改变
    const val onTotalNotReadCountChangeListener = "onTotalNotReadCountChangeListener"
    ///消息事件
    //消息状态更新
    const val onMessageStatusUpdate = "onMessageStatusUpdate"

    //消息发送失败
    const val onMessageSendFail = "onMessageSendFail"

    //收到消息
    const val onMessageReceived = "onMessageReceived"

    //会话同步完成
    const val OnConvSyncStatusComplete = "OnConvSyncStatusComplete"

    //发送消息预处理
    const val onDefaultMsgBeforeSendHandler = "onDefaultMsgBeforeSendHandler"

    //接收消息预处理
    const val onDefaultMsgBeforeReceiveHandler = "onDefaultMsgBeforeReceiveHandler"

    //发送消息
    const val sendMessage = "sendMessage"

    //插入消息到数据库
    const val insertMessageDB = "insertMessageDB"

    //更新文件本地路径
    const val updateMessageFileLocPath = "updateMessageFileLocPath"

    //更新消息的属性
    const val updateMessageAttrs = "updateMessageAttrs"

    //同步离线消息
    const val syncOfflineMessages = "syncOfflineMessages"

    //查询历史消息
    const val findHistMsg = "findHistMsg"

    //查询本地所有聊天记录
    const val findMessageFromHistory = "findMessageFromHistory"

    //通过时间查询聊天记录
    const val findMessageFromHistoryByTime = "findMessageFromHistoryByTime"

    ///会话事件
    //会话属性改变
    const val onConversationEvent = "onConversationEvent"

    //会话更新（未读数，是否@等服务器返回数据变化时）
    const val onUpdateConversation = "onUpdateConversation"

    //会话添加
    const val onAddConversation = "onAddConversation"

    //会话删除
    const val onRemoveConversation = "onRemoveConversation"

    //添加会话成员
    const val addMember = "addMember"

    //更新本地会话名字
    const val updateNameFromLocal = "updateNameFromLocal"

    //更新本地会话头像
    const val updateHeadPortraitFromLocal = "updateHeadPortraitFromLocal"

    //删除会话成员
    const val delMember = "delMember"

    //查询本会话的成员
    const val searchConvMembers = "searchConvMembers"

    //添加或修改会话的拓展字段
    const val updateConversationAttr = "updateConversationAttr";

    //修改群名字 (群主可用)
    const val updateConversationName = "updateConversationName"

    //修改群昵称
    const val updateConvMemberRemark = "updateConvMemberRemark"

    //设置群禁言
    const val setGroupMuted = "setGroupMuted"

    //草稿
    const val saveDraft = "saveDraft"

    //群解散状态
    const val setDisband = "setDisband"

    //同步群会话成员
    const val syncGroupMembers = "syncGroupMembers";

    // 更新本地会话数据
    const val onUpdateConversationFromDB = "onUpdateConversationFromDB";

    ///单人RTC事件
    //接收到RTC邀请
    const val onProcessCallEvent = "onProcessCallEvent"

    //有client加入频道
    const val onProcessJoinEvent = "onProcessJoinEvent"

    //有client离开频道
    const val onProcessLeaveEvent = "onProcessLeaveEvent"

    //有Client拒绝加入频道
    const val onProcessRejectEvent = "onProcessRejectEvent"

    //client SDP 下发
    const val onProcessSdpEvent = "onProcessSdpEvent"

    // client Candidate 下发
    const val onProcessCandidateEvent = "onProcessCandidateEvent"


    //创建频道,并邀请客户端加入
    const val createAndCall = "createAndCall"

    //同意进入频道
    const val joinRtcChannel = "joinRtcChannel"

    //拒接进入频道
    const val rejectRtcCall = "rejectRtcCall"

    //SDP数据转发
    const val sdpForward = "sdpForward"

    //candidate候选者数据转发
    const val candidateForward = "candidateForward"

    //主动挂断(离开频道)
    const val leaveRtcChannel = "leaveRtcChannel"

    //透传消息事件下发
    const val onTransparentMessageEvent = "onTransparentMessageEvent"

    //SDK连接事件
    const val onSDKConnEvent = "onSDKConnEvent"

    //获取当前连接状态
    const val getConnectingStatus = "getConnectingStatus"
}