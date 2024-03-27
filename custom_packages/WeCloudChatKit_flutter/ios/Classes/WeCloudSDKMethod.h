//
//  WeCloudSDKMethod.h
//
//
//  Created by mac on 2022/3/23.
//

#import <Foundation/Foundation.h>

#pragma mark - WeCloudClientWrapper
/// 初始化
static NSString *const WeCloudMethodKeyInit = @"initialize";
/// 登录且开启模块
static NSString *const WeCloudMethodKeyLogin = @"loginAndOpen";
/// 模块是否已登录
static NSString *const WeCloudMethodKeyIsLogin = @"isLogin";
/// 开启模块
static NSString *const WeCloudMethodKeyOpen = @"open";

//开启模块(携带token)
static NSString *const WeCloudMethodKeyOpenModel = @"openModel";

/// 关闭模块
static NSString *const WeCloudMethodKeyLogout = @"close";
/// 添加或修改推送设备信息
static NSString *const WeCloudMethodKeyKickDevice = @"updateDeviceInfo";

/// 获取设备token
static NSString *const WeCloudMethodKeyOnDeviceToken = @"OnDeviceToken";

#pragma mark - WeCloudIMClientReceiveMessageDelegate
/// 消息事件
/// 收到消息
static NSString *const WeCloudMethodKeyOnMessagesReceived = @"onMessageReceived";
/// 消息状态更新
static NSString *const WeCloudMethodKeyOnMessagesUpdateStatus = @"onMessageStatusUpdate";
/// 消息发送失败
static NSString *const WeCloudMethodKeyOnMessagesSendFail = @"onMessageSendFail";

/// 发送消息
static NSString *const WeCloudMethodKeySendMessage = @"sendMessage";


//发送消息预处理
static NSString *const WeCloudMethodKeyOnDefaultMsgBeforeSendHandler =
     @"onDefaultMsgBeforeSendHandler";

 //接收消息预处理
static NSString *const WeCloudMethodKeyOnDefaultMsgBeforeReceiveHandler =
     @"onDefaultMsgBeforeReceiveHandler";


//总未读数改变
static NSString *const WeCloudMethodKeyOnTotalNotReadCountChangeListener = @"onTotalNotReadCountChangeListener";

//会话同步完成
static NSString *const WeCloudMethodKeySyncConversationListener = @"OnConvSyncStatusComplete";

/// 保存或更新消息(下载文件时用于保存消息的本地路径)
static NSString *const WeCloudMethodKeySaveOrUpdateMessage = @"updateMessageFileLocPath";

//更新消息的属性
static NSString *const WeCloudMethodKeyUpdateMessageAttrs  = @"updateMessageAttrs";

//插入消息到数据库
static NSString *const WeCloudMethodKeyInsertMessageDB = @"insertMessageDB";


/// 同步离线消息（进聊天页面，拉去离线个本地没有的消息的）
static NSString *const WeCloudMethodKeySyncOfflineMessages = @"syncOfflineMessages";
/// 查询历史消息（获取历史消息的）
static NSString *const WeCloudMethodKeyFindHistMsg = @"findHistMsg";
/// 查询本地所有聊天记录（用于查找聊天记录页面的日历）
static NSString *const WeCloudMethodKeyFindMessageFromHistory = @"findMessageFromHistory";
/// 通过时间查询聊天记录（聊天记录页面进入聊天页面加载数据使用）
static NSString *const WeCloudMethodKeyFindMessageFromHistoryByTime = @"findMessageFromHistoryByTime";

#pragma mark ---- 会话事件 -----
/// 会话事件
static NSString *const WeCloudMethodKeyOnConversationEvent = @"onConversationEvent";
/// 会话更新 ---未读数，是否@等服务器返回数据变化时
static NSString *const WeCloudMethodKeyOnUpdateConversation = @"onUpdateConversation";
/// 会话添加
static NSString *const WeCloudMethodKeyOnAddConversation = @"onAddConversation";
  /// 会话删除
static NSString *const WeCloudMethodKeyOnRemoveConversation = @"onRemoveConversation";
///  添加会话成员(HTTP)
static NSString *const WeCloudMethodKeyAddMemberFromServer = @"addMember";
///  删除会话成员(HTTP)
static NSString *const WeCloudMethodKeyDelMemberFromServer = @"delMember";
/// 查询本会话的成员(HTTP)
static NSString *const WeCloudMethodKeySearchConvMembersFromServer = @"searchConvMembers";
/// 修改群名字 (群主可用)（调用HTTP成功后修改数据库）
static NSString *const WeCloudMethodKeyUpdateConversationNameFromServer = @"updateConversationName";
/// 修改群中的备注名(HTTP)
static NSString *const WeCloudMethodKeyUpdateConvMemberRemarkFromServer = @"updateConvMemberRemark";
/// 设置群禁言（调用HTTP成功后修改数据库）
static NSString *const WeCloudMethodKeySetGroupMutedFromServer = @"setGroupMuted";
/// 保存草稿
static NSString *const WeCloudMethodKeySaveDraft = @"saveDraft";
/// 群解散状态（数据库需加该字段）
static NSString *const WeCloudMethodKeySetDisband = @"setDisband";

/// 更新本地会话名字
static NSString *const WeCloudMethodKeyUpdateNameFromLocal = @"updateNameFromLocal";

/// 更新本地会话头像
static NSString *const WeCloudMethodKeyUpdateHeadPortraitFromLocal =
    @"updateHeadPortraitFromLocal";

//查询会话
static NSString *const WeCloudMethodKeyFindConversationById = @"findConversationById";

//添加或修改会话的拓展字段
static NSString *const WeCloudMethodKeyUpdateConversationAttr = @"updateConversationAttr";

#pragma mark ----- Socket ----
// SDK连接事件
static NSString *const WeCloudMethodKeyOnSDKConnectEvent = @"onSDKConnEvent";

// 获取当前连接状态
static NSString *const WeCloudMethodKeyGetConnectingStatus = @"getConnectingStatus";

#pragma mark ----- 聊天室-------
//加入聊天室
static NSString *const WeCloudMethodKeyJoinChatRoom = @"joinChatRoom";
////退出聊天室
static NSString *const WeCloudMethodKeyExitChatRoom = @"exitChatRoom";
//退出聊天室
static NSString *const WeCloudMethodKeyFindChatRoomMembers = @"findChatRoomMembers";


/// 创建会话
static NSString *const WeCloudMethodKeyCreateConversationFromServer = @"createConversation";
/// 解散群聊
static NSString *const WeCloudMethodKeyDisbandConversationFromServer = @"disbandConversation";
/// 查询加入的会话
static NSString *const WeCloudMethodKeySearchConversationListFromServer = @"searchDisplayConversationList";
/// 查询会话中指定类型的消息(查询某个会话中的图片)
static NSString *const WeCloudMethodKeyFindConvMsgByTypeFromDB = @"findConvMsgByType";
/// 查询本地所有会话，包含隐藏的
static NSString *const WeCloudMethodKeySearchGroupConversationsFromDB = @"searchGroupConversations";
/// 隐藏会话(显示或隐藏)
static NSString *const WeCloudMethodKeyHiddenConversationFromDB = @"displayConversation";
/// 删除会话(逻辑删除，隐藏会话并删除会话中的所有消息)
static NSString *const WeCloudMethodKeyDeleteConversations = @"deleteConversations";

//删除会话（删除数据库中关于此会话的所有数据）
static NSString *const WeCloudMethodKeyDeleteConversationFromDB = @"deleteConversationFromDB";

/// 更新本地会话数据
static NSString *const WeCloudMethodKeyOnUpdateConversationFromDB = @"onUpdateConversationFromDB";




/// 退出会话
static NSString *const WeCloudMethodKeyLeaveConversationFromServer = @"leaveConv";
/// 设置群管理员
static NSString *const WeCloudMethodKeySetupConvAdminsFromServer = @"setupConvAdmins";
/// 群主转让
static NSString *const WeCloudMethodKeyConvTransferOwnerFromServer = @"convTransferOwner";
/// 群成员禁言
static NSString *const WeCloudMethodKeyConvMutedGroupMemberFromServer = @"convMutedGroupMenber";
/// 撤回消息
static NSString *const WeCloudMethodKeyWithdrawMsgFromServer = @"withdrawMsg";
/// 删除消息(连同服务器一起删除)
static NSString *const WeCloudMethodKeyDeleteMsgAndNetworkFromServer = @"deleteMsgAndNetwork";
/// 删除会话的所有消息(只删除本地数据库)
static NSString *const WeCloudMethodKeyDeleteAllMsgByConvIdFromDB = @"deleteAllMsgByConvId";
/// 删除会话的指定消息（只删除本地数据库）（备注：多选-删除）
static NSString *const WeCloudMethodKeyDeleteAllMsgFromDB = @"deleteAllMsg";
/// 消息已读回执
static NSString *const WeCloudMethodKeyMsgReadUpdateFromServer = @"msgReadUpdate";
/// 把会话中msgIdEnd之前所有消息更新为已读
static NSString *const WeCloudMethodKeyMsgReadAllConvUpdateFromServer = @"msgReadAllConvUpdate";
/// 查询指定消息
static NSString *const WeCloudMethodKeyFindMessageByIdFromDB = @"findMessage";
/// 拉入黑名单
static NSString *const WeCloudMethodKeyAddBlacklistFromServer = @"addBlacklist";
/// 移除黑名单
static NSString *const WeCloudMethodKeyDelBlacklistFromServer = @"delBlacklist";
/// 黑名单分页列表
static NSString *const WeCloudMethodKeyFindBlacklistFromServer = @"findBlacklist";
/// 查询群用户信息 --根据Client id获取Client的头像昵称
static NSString *const WeCloudMethodKeyGetClientInfoListFromServer = @"findGroupInfoList";

#pragma mark --- WeCloudIMClientReceiveFriendShipDelegate ---
///  好友友事件
/// 申请好友的事件
static NSString *const WeCloudMethodKeyOnFriendShipInvite = @"onApplyFriendEvent";
/// 发出请求的审批结果
static NSString *const WeCloudMethodKeyOnFriendShipVerificationResult = @"onApproveFriendEvent";
#pragma mark ----- 好友 -----
/// 申请添加好友
static NSString *const WeCloudMethodKeyApplyFriendFromServer = @"applyFriend";
/// 接受/拒绝好友申请
static NSString *const WeCloudMethodKeyApproveFriendFromServer = @"approveFriend";
 /// 删除好友
static NSString *const WeCloudMethodKeyBatchDeleteFriendFromServer = @"batchDeleteFriend";

#pragma mark ----- 单人rtc 事件-------
///接收到RTC邀请
static NSString *const WeCloudMethodKeyOnProcessCallEvent = @"onProcessCallEvent";
/// 有client加入频道
static NSString *const WeCloudMethodKeyOnProcessJoinEvent = @"onProcessJoinEvent";
/// 有Client拒绝加入频道
static NSString *const WeCloudMethodKeyOnProcessRejectEvent = @"onProcessRejectEvent";
/// 有client离开频道
static NSString *const WeCloudMethodKeyOnProcessLeaveEvent = @"onProcessLeaveEvent";
/// client SDP 下发
static NSString *const WeCloudMethodKeyOnProcessSdpEvent = @"onProcessSdpEvent";
/// client Candidate 下发
static NSString *const WeCloudMethodKeyOnProcessCandidateEvent = @"onProcessCandidateEvent";

//创建频道,并邀请客户端加入
static NSString *const WeCloudMethodKeyCreateAndCall = @"createAndCall";

  //同意进入频道
static NSString *const WeCloudMethodKeyJoinRtcChannel = @"joinRtcChannel";

  //拒接进入频道
static NSString *const WeCloudMethodKeyRejectRtcCall = @"rejectRtcCall";

  //SDP数据转发
static NSString *const WeCloudMethodKeySdpForward = @"sdpForward";

  //candidate候选者数据转发
static NSString *const WeCloudMethodKeyCandidateForward = @"candidateForward";

  //主动挂断(离开频道)
static NSString *const WeCloudMethodKeyLeaveRtcChannel = @"leaveRtcChannel";


/// 退出IM
static NSString *const WeCloudMethodKeyLeaveIMServer = @"leaveIMSDK";

#pragma mark ------ WeCloudIMClientTransparentEventDelegate ----
/// 透传消息下发事件
static NSString *const WeCloudMethodKeyOnTransparentMessageEvent = @"onTransparentMessageEvent";
