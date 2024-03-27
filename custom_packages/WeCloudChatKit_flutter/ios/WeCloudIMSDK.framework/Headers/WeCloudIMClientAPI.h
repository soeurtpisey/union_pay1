//
//  WeCloudIMClientAPI.h
//  WeCloudChatDemo
//
//  Created by 与梦信息的Mac on 2022/4/13.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#ifndef WeCloudIMClientAPI_h
#define WeCloudIMClientAPI_h



#pragma mark - <会话相关API>

//查询加入的会话列表(旧z)
static NSString * _Nonnull const WCIMAPI_GET_CONVERSATIONLIST = @"/im/conversation/getList";

//分页获取所有的会话列表(新)
static NSString * _Nonnull const WCIMAPI_GET_CONVERSATIONPAGELIST = @"/im/conversation/getPageList";

//查询有未读消息的会话列表
static NSString * _Nonnull const WCIMAPI_GET_UNREADCONVERSATIONLIST = @"/im/conversation/getUnreadList";

//会话列表批量已读
static NSString * _Nonnull const WCIMAPI_POST_CONVERSATIONBATCHREAD = @"/im/memberMsgNote/conversationBatchRead";

//设置在当前会话的已读位置或未读标记
static NSString * _Nonnull const WCIMAPI_POST_SETNOTEBYCONVERSATION = @"/im/memberMsgNote/setNoteByConversation";

//根据会话id查询指定会话信息
static NSString * _Nonnull const WCIMAPI_GET_CONVERSATIONINFO = @"/im/conversation/info";

//获取会话中成员表列表
static NSString * _Nonnull const WCIMAPI_GET_CONVERSATIONMEMBERS = @"/im/conversationMembers/getList";

//添加或修改会话成员备注
static NSString * _Nonnull const WCIMAPI_UPDATE_CONVERSATIONMEMBER_REMARK = @"/im/conversationMembers/updateClientRemarkName";

//修改会话头像
static NSString * _Nonnull const WCIMAPI_UPDATE_CONVERSATIONMEMBER_HEADER = @"/im/conversation/setGroupPortrait";

//创建会话
static NSString * _Nonnull const WCIMAPI_CREATE_CONVERSATION = @"/im/conversation/create";

//修改或更新会话的自定义属性
static NSString * _Nonnull const WCIMAPI_UPDATE_CONVERSATION_ATTRIBUTES = @"/im/conversation/saveOrUpdateAttr";

//将用户添加进会话
static NSString * _Nonnull const WCIMAPI_ADD_CONVERSATIONCLIENT = @"/im/conversation/addClient";

//将client从会话移除
static NSString * _Nonnull const WCIMAPI_DELETE_CONVERSATIONCLIENT = @"/im/conversation/delClient";

//查询某个会话历史消息分页列表
static NSString * _Nonnull const WCIMAPI_GET_CONVERSATIONCLIENT = @"/im/message/getHistoryMsg";

//查询某个会话历史消息分页列表包括最后一条新消息
static NSString * _Nonnull const WCIMAPI_GET_CONVERSATIONC_MSG_All_LIENT = @"/im/message/getHistoryMsgNew";

//解散群聊
static NSString * _Nonnull const WCIMAPI_DISBAND_CONVERSATION = @"/im/conversation/disband";

//client退出会话
static NSString * _Nonnull const WCIMAPI_LEAVE_CONVERSATION = @"/im/conversation/leave";

//群禁言、取消群禁言
static NSString * _Nonnull const WCIMAPI_CONVERSATION_MUTED_GROUP = @"/im/conversation/mutedGroup";

//选择禁言
static NSString * _Nonnull const WCIMAPI_CONVERSATION_MUTED_GROUP_MEMBER = @"/im/conversation/mutedGroupMember";

//设置群管理员
static NSString * _Nonnull const WCIMAPI_CONVERSATION_GROUP_SETADMINS = @"/im/conversation/setAdmins";

//群主转让
static NSString * _Nonnull const WCIMAPI_CONVERSATION_GROUP_TRANSFEROWNER = @"/im/conversation/transferOwner";

//添加或修改会话名称
static NSString * _Nonnull const WCIMAPI_UPDATE_CONVERSATION_NAME = @"/im/conversation/saveOrUpdateName";

//会话消息修改为已读状态
static NSString * _Nonnull const WCIMAPI_UPDATE_CONVERSATION_READSTATUS = @"/im/inbox/updateMsgReadStatusByConversation";

//进入聊天室
static NSString * _Nonnull const WCIMAPI_JION_ROOM_CHAT = @"/im/conversation/intoChatRoom";

//离开聊天室
static NSString * _Nonnull const WCIMAPI_LEAVE_ROOM_CHAT = @"/im/conversation/exitRoom";

//查询聊天室成员
static NSString * _Nonnull const WCIMAPI_SEARCH_ROOM_CHAT = @"/im/conversation/listChatRoomMember";

// 获取会话的最后一条已读消息
static NSString * _Nonnull const WCIMAPI_GET_CONVERSATION_LAST_READ_MESSAGE = @"/im/message/getLastReadMsgId";

#pragma mark - <消息相关API>

//获取置顶消息
static NSString * _Nonnull const WCIMAPI_GETINFOTOP_MESSAGE = @"/im/message/getTopMessage";

//移除置顶消息
static NSString * _Nonnull const WCIMAPI_REMOVETOP_MESSAGE= @"/im/message/removeTopMessage";

//设置置顶消息
static NSString * _Nonnull const WCIMAPI_ADDTOP_MESSAGE = @"/im/message/setTopMessage";

//删除消息内容
static NSString * _Nonnull const WCIMAPI_DELETE_MESSAGE = @"/im/message/delete";

//消息撤回
static NSString * _Nonnull const WCIMAPI_WITHDRAW_MESSAGE = @"/im/message/withdraw";

//消息修改为已读状态
static NSString * _Nonnull const WCIMAPI_REDAER_MESSAGE = @"/im/inbox/msgReadUpdate";

//修改某个会话为已读状态(旧z)
static NSString * _Nonnull const WCIMAPI_REDAER_ALL_MESSAGE = @"/im/inbox/updateMsgReadStatusByConversation";


//消息修改为已接收状态
static NSString * _Nonnull const WCIMAPI_RECEIVE_MESSAGE = @"/im/inbox/msgReceivedUpdate";

#pragma mark - <个人相关API>

//查询我的信息
static NSString * _Nonnull const WCIMAPI_MINE_INFO =
    @"/im/client/myInfo";

//查询用户信息 用户可能是好友、陌生人、被拉黑名单的人
static NSString * _Nonnull const WCIMAPI_OTHER_INFO =
    @"/im/client/clientInfo";

//查询用户信息
static NSString * _Nonnull const WCIMAPI_USER_INFO =
@"/im/client/infoList";

//退出登陆 清除推送token等
static NSString * _Nonnull const WCIMAPI_MINE_EXIT =
    @"/im/client/logout";

//添加或修改主昵称
static NSString * _Nonnull const WCIMAPI_MINE_MODIFYNAME = @"/im/client/updateNickname";

#pragma mark - <单人音视频API>

//candidate候选者数据转发
static NSString * _Nonnull const WCIMAPI_RTC_FORWARD = @"/im/rtc/candidateForward";

//创建频道,并邀请客户端加入
static NSString * _Nonnull const WCIMAPI_RTC_CREATE =
    @"/im/rtc/createAndCall";

//同意进入频道
static NSString * _Nonnull const WCIMAPI_RTC_JOIN =
    @"/im/rtc/join";

//同意进入频道
static NSString * _Nonnull const WCIMAPI_RTC_LEAVE =
    @"/im/rtc/leave";

//拒接进入频道
static NSString * _Nonnull const WCIMAPI_RTC_REJECT =
    @"/im/rtc/reject";

//SDP数据转发
static NSString * _Nonnull const WCIMAPI_RTC_SDP_FORWARD =
    @"/im/rtc/sdpForward";

#pragma mark - <多人音视频API>

//同意进入会议
static NSString * _Nonnull const WCIMAPI_TRTC_AGREE = @"/im/multiMeet/agree";

//发送心跳
static NSString * _Nonnull const WCIMAPI_TRTC_HEART = @"/im/multiMeet/heartbeat";

//邀请加入多人音视频会议
static NSString * _Nonnull const WCIMAPI_TRTC_INVITE = @"/im/multiMeet/invite";

//主动挂断(离开会议)
static NSString * _Nonnull const WCIMAPI_TRTC_LEAVEE = @"/im/multiMeet/leave";

//是否正在被呼叫
static NSString * _Nonnull const WCIMAPI_TRTC_BUSY = @"/im/multiMeet/isBeCalling";

//未接听
static NSString * _Nonnull const WCIMAPI_TRTC_NO_ANSWERED = @"/im/multiMeet/notAnswered";

//拒接进入会议
static NSString * _Nonnull const WCIMAPI_TRTC_REJECT = @"/im/multiMeet/reject";


#pragma mark - <关系链API>

//拉入黑名单
static NSString * _Nonnull const WCIMAPI_RELATION_BLACK =
    @"/im/blacklist/add";

//移出黑名单
static NSString * _Nonnull const WCIMAPI_RELATION_BLACK_DELETE = @"/im/blacklist/delete";

//黑名单分页列表
static NSString * _Nonnull const WCIMAPI_RELATION_BLACK_LIST = @"/im/blacklist/getPageList";

#pragma mark ------ 端对端加密相关 --------
///发起加密聊天，获取加密的房间号以及对方的3个公钥
static NSString * _Nonnull const WCIMAPI_ENCRYPT_BEFORE_END_TO_END_CHAT = @"/im/publicKey/getUsersPublicKey";

///向服务端保存自己的三个公钥
static NSString * _Nonnull const WCIMAPI_ENCRYPT_SAVE_USER_PUBLICKEY = @"/im/publicKey/saveUserPublicKey";

///查询自己还有多少个一次性密钥
static NSString * _Nonnull const WCIMAPI_ENCRYPT_GET_ONE_TIME_KEY_COUNT = @"/im/publicKey/countOneTimeKey";

///补充自己的一次性密钥
static NSString * _Nonnull const WCIMAPI_ENCRYPT_INCREMENT_ONE_TIME_KEY = @"/im/publicKey/incrementOneTimeKey";

///批量获取群内用户公钥
static NSString * _Nonnull const WCIMAPI_ENCRYPT_GET_GROUP_USER_KEYS = @"/im/publicKey/getGroupUserKeys";

/// 是否可用端对端加密
static NSString * _Nonnull const WCIMAPI_ENCRYPT_ENCRYPTED_ENABLED = @"/im/publicKey/encryptedEnabled";

/// 获取用户专属盐值
static NSString * _Nonnull const WCIMAPI_ENCRYPT_GET_KEY_SALT = @"/im/client/getKeySalt";

#endif /* WeCloudIMClientAPI_h */
