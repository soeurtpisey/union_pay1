//
//  WeCloudStatusDefine.h
//  ChatSDK
//
//  Created by mac on 2022/1/7.
//  Copyright © 2022 wecloud .Icn. All rights reserved.
//

#ifndef WeCloudStatusDefine_h
#define WeCloudStatusDefine_h

typedef NS_ENUM(NSUInteger, WCIMClientPlatformType) {
    WCIMClientPlatformType_iOS         = 1,
    WCIMClientPlatformType_android     = 2,
    WCIMClientPlatformType_web         = 3,
    WCIMClientPlatformType_win         = 4,
    WCIMClientPlatformType_mac         = 5,
};

/// client status
typedef NS_ENUM(NSUInteger, WeCloudIMClientStatus) {
    WeCloudIMClientStatusNone        = 0,
    WeCloudIMClientStatusOpening     = 1,
    WeCloudIMClientStatusOpened      = 2,
    WeCloudIMClientStatusPaused      = 3,
    WeCloudIMClientStatusResuming    = 4,
    WeCloudIMClientStatusClosing     = 5,
    WeCloudIMClientStatusClosed      = 6,
};
//typedef NS_ENUM(NSInteger, AVIMSendCommandType) {
//  AVIMSendCommandType_Session = 1,//发送IM消息请求
//  AVIMSendCommandType_SingleWebRTC = 3//单人WebRTC请求
//};


//通过websocket发起的请求类型，用于回调判断
typedef NS_ENUM(NSUInteger, WCIMClientRequestType) {
    WCIMClientRequestTypeMsg     = 1,
    WCIMClientRequestTypeReq     = 2,
};

typedef NS_ENUM(NSInteger, AVIMReceiveCommandType) {
    AVIMReceiveCommandType_RespondIM = 1,//响应请求(用于im聊天)
    AVIMReceiveCommandType_OnlineMessage = 2,//下发在线用户消息
    AVIMReceiveCommandType_OnlineMessageType = 3,//下发在线消息事件类型
    AVIMReceiveCommandType_SingleOnlineRTCMessageType = 4,//下发单人在线RTC事件通知
    AVIMReceiveCommandType_SessionEvents = 5,//会话中的事件
    AVIMReceiveCommandType_TransparentMessage = 6,//下发透传消息
    AVIMReceiveCommandType_FriendMessage = 7,//下发好友相关事件通知
    AVIMReceiveCommandType_TRTC = 8,//多人音视频通知
};



typedef NS_OPTIONS(NSInteger, AVFriendShipEventType) {
    /// 申请成为好友
    AVFriendShipEventType_Add = 1,
    /// 好友申请验证结果
    AVFriendShipEventType_RerificationResult = 2,
};



typedef NS_ENUM(NSInteger, WeCloudSocketConnectionStatus) {
    
    /**
     * 未知状态。
     */
    ConnectionStatus_UNKNOWN = -1, //"Unknown error."

    /**
     *  开始发起连接
     */
    ConnectionStatus_Connecting = 0,
    
    /**
     * 连接成功。
     */
    ConnectionStatus_Connected = 1,

    /**
     *  连接失败和未连接
     */
    ConnectionStatus_CLOSING = 2,
    
    /*
     * 连接关闭
     */
    ConnectionStatus_CLOSED = 3,

};
/*!
 会话类型
 */
typedef NS_ENUM(NSInteger,WeCloudChatType) {
    /*
     * 单聊
     */
    WeCloudChatType_Single = 1,
    /*
     * 普通群聊
     */
    WeCloudChatType_NormalGroup = 2,
    /*
     * 万人群
     */
    WeCloudChatType_TenThousandGroup = 3,
    /*
     * 聊天房
     */
    WeCloudChatType_ChatRoom = 4,
    
};



#pragma mark WeCloudErrorCode - 具体业务错误码
/*!
 具体业务错误码
 */
typedef NS_ENUM(NSInteger, WeCloudErrorCode) {
    /*!
     未知错误
     */
    ERRORCODE_UNKNOWN = -1,
    
    /*!
     已被对方加入黑名单
     */
    IS_BE_BLACK = 6012,
    
    /*!
     你把对方拉黑
     */
    IS_TO_BLACK = 6013,
    
    /*!
     已被踢出会话
     */
    IS_BE_KICK_OUT = 6014,
    
    /*!
     已被禁言
     */
    IS_BE_MUTED = 6015,
    
    /*
     群聊已解散
     */
    IS_BE_DISBAND = 6016,
    
    /*
     群聊已禁言
     */
    IS_BE_ALL_MUTED = 7001,
    
};


typedef NS_ENUM(NSUInteger, WeCloudIMConversationMemberRole) {
    /// Privilege: Owner > Manager > Member
    WeCloudIMConversationMemberRoleMember    = 0,
    WeCloudIMConversationMemberRoleManager   = 1,
    WeCloudIMConversationMemberRoleOwner     = 2,
};


#define dispatch_main_async_safe(block)                                                                            \
    if ([NSThread isMainThread]) {                                                                                     \
        block();                                                                                                       \
    } else {                                                                                                           \
        dispatch_async(dispatch_get_main_queue(), block);                                                              \
    }


#endif /* WeCloudStatusDefine_h */
