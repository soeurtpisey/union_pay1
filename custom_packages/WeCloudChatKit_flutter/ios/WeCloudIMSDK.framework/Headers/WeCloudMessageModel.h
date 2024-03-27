//
//  WeCloudMessageModel.h
//  ChatSDK
//
//  Created by mac on 2022/1/8.
//  Copyright © 2022 wecloud .Icn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudStatusDefine.h"
#import "WeCloudGeneralModel.h"
#import <UIKit/UIKit.h>

#pragma mark -----消息类型 ---- 
/*
 * 消息类型
 */
typedef NS_OPTIONS(NSInteger, WeCloudIMMessageMediaType) {
   
    WeCloudIMMessageMediaTypeNone = 0,
    /// 文本消息
    WeCloudIMMessageMediaTypeText = -1,
    /// 图像消息
    WeCloudIMMessageMediaTypeImage = -2,
    /// 音频消息
    WeCloudIMMessageMediaTypeAudio = -3,
    /// 视频消息
    WeCloudIMMessageMediaTypeVideo = -4,
    /// 文件消息
    WeCloudIMMessageMediaTypeFile = -5,
    /// 自定义消息 flutter 固定有
    WeCloudIMMessageMediaTypecustom = 1000,
    /// 邀请xx加入会话
    WeCloudIMMessageMediaTypeAdd = -1007,
    /// xx被xx移出会话
    WeCloudIMMessageMediaTypeDelete = -1008,
    /// xx已接收某消息
    WeCloudIMMessageMediaTypeReceiveMessage = -1009,
    /// xx已读某条消息
    WeCloudIMMessageMediaTypeReadedMessage = -1010,
    /// 你被xx拉入新会话
    WeCloudIMMessageMediaTypePullNewSession = -1011,
    /// 主动退出会话
    WeCloudIMMessageMediaTypeExitSession = -1012,
    /// 成为新群主
    WeCloudIMMessageMediaTypeBecomeNewGroupLeader = -1013,
    /// 群拓展字段变动事件
    WeCloudIMMessageMediaTypeGroupExpansionFieldChange = -1014,
    /// 会话名称字段变动事件
    WeCloudIMMessageMediaTypeSessionNameFieldChange = -1015,
    /// 消息撤回事件
    WeCloudIMMessageMediaTypeMessageWithdraw = -1016,
    /// 消息删除事件
    WeCloudIMMessageMediaTypeMessageDelete = -1017,
    /// 解散群聊
    WeCloudIMMessageMediaTypeConversationDisband = -1018,
    /// 群聊禁言
    WeCloudIMMessageMediaTypeConversationMuted = -1019,
    /// 群聊禁言取消
    WeCloudIMMessageMediaTypeConversationMutedCancel = -1020,
    /// 群成员备注名修改
    WeCloudIMMessageMediaTypeConversationMenmberNameModify = -1021,
    /// 禁止群成员互加好友
    WeCloudIMMessageMediaTypeConversationNoAddUser = -1022,
    /// 取消禁止群成员互加好友
    WeCloudIMMessageMediaTypeConversationCanAddUser = -1023,
    /// 禁止群成员发图片
    WeCloudIMMessageMediaTypeConversationNoSendIMG = -1026,
    /// 取消禁止群成员发图片
    WeCloudIMMessageMediaTypeConversationCanSendIMG = -1027,
    /// 禁止群成员发链接
    WeCloudIMMessageMediaTypeConversationNoSendLine = -1028,
    /// 取消禁止群成员发链接
    WeCloudIMMessageMediaTypeConversationCanSendLine = -1029,
    /// 修改群头像
    WeCloudIMMessageMediaTypeConversationModify = -1031,
    /// 群成员禁言
    WeCloudIMMessageMediaTypeGrouperMute = -1032,
    /// 群成员解禁
    WeCloudIMMessageMediaTypeGrouperNoMute = -1033,
    /// 公钥未上传
    WeCloudIMMessageMediaTypeConversationRemoteIdentityKeyNotUpload = -9999,
};

/*!
 消息的发送状态
 */
typedef NS_ENUM(NSUInteger, WeCloudMessageStatus) {
    /// 默认
    WeCloudMessageStatusNone = 0,
    /*!
     发送失败
     */
    WeCloudMessageStatusFailed = 1,
    /*!
     撤回
     */
    WeCloudMessageStatusWithdraw = 2,
    /*!
     发送中
     */
    WeCloudMessageStatusSending = 3,
    
    /*!
     已发送成功
     */
    WeCloudMessageStatusSent = 4,
    
    /*!
     对方已送达
     */
    WeCloudMessageStatusDelivered = 5,
    /*!
     消息已删除
     */
    WeCloudMessageStatusDelete = 6,
    
    /*!
     消息本地已清空
     */
    WeCloudMessageStatusLocalDelete = 7,
    /*!
     消息已失效 定为8
     */
    WeCloudMessageStatusLocalose = 8,
};


NS_ASSUME_NONNULL_BEGIN

@class WeCloudMessageFileContentModel,WeCloudMemberModel;

@interface WeCloudMessageModel : NSObject<NSCopying>

/* 本地数据库中的主键. */
@property (nonatomic, assign) NSInteger seq;

//发送消息时的请求id，此id必须通过[[WeCloudIMClient sharedWeCloudIM] getSendReqId]方法获取
@property (nonatomic, strong) NSString *reqId;

/*
 * 消息id
 */
@property (nonatomic, assign) long long msgId;

/*
 * 上一条消息id
 */
@property (nonatomic, assign) long long preMessageId;


/*!
 * 发送时间（精确到毫秒）
 */
@property (nonatomic, assign) double createTime;

/// 撤回时间
@property (nonatomic, assign) double withdrawTime;

/// 0未撤回 1已撤回
@property (nonatomic, assign) BOOL withdraw;

/// 1未删除 2已删除
@property (nonatomic, assign) int deleted;

//是否有@ 信息 -1 为全体 其余是个人
@property (nonatomic,copy) NSString * isBeAt;

/*
 * 发送者的用户id
 */
@property (nonatomic, copy) NSString * sender;

/*
 * 消息类型
 */
@property (nonatomic, assign) WeCloudIMMessageMediaType type;
/*!
 * 消息的状态
 */
@property (nonatomic, assign) WeCloudMessageStatus msgStatus;

/*!
 * 会话ID
 */
@property (nonatomic, assign) long long conversationId;

/// 0非事件; 1为事件
@property (nonatomic, assign) BOOL event;
/// 0非系统通知; 1为系统通知
@property (nonatomic, assign) BOOL systemFlag;

/// 0非系统通知; 1为系统通知
@property (nonatomic, assign) BOOL system;

/// at他人,传入客户端id数组
@property (nonatomic, copy) NSString *at;

/// 未读人数统计,全部人已读为0
@property (nonatomic, assign) NSInteger notReadCount;
/// 未接收人数统计,全部人已接收为0
@property (nonatomic, assign) NSInteger notReceiverCount;

/// 原始内容
@property (copy, nonatomic) NSString *content;

///  会话事件
@property (nonatomic, copy) NSString *name;///会话名字改动

@property (nonatomic, copy) NSString *attributes;/// 会话属性改动

//@property (nonatomic, copy) NSString *operator;/// //操作的client ID

@property (nonatomic, copy) NSString *operatorId; //操作的client ID

@property (nonatomic, copy) NSString *passivityOperator;/// //被操作的client ID

//撤回消息的数据
@property (nonatomic, strong) WeCloudGeneralModel *operatorData;

//自定义数据
@property (nonatomic, strong) NSDictionary *attrs;

//推送数据
@property (nonatomic, strong) NSDictionary *pushContent;

@property (nonatomic, copy) NSString *text; //文本


/*
 * 多文件类型
 */
@property (nonatomic, strong) NSArray<WeCloudMessageFileContentModel *>*files;

//阅后即焚设置的时长(单位：秒)
@property (nonatomic, assign) NSInteger timeToBurn;
/// 是否阅后即焚消息 0否 1是
@property (nonatomic, assign) NSInteger burn;

//@property (nonatomic, assign) WeCloudChatType chatType;  //聊天类型 , 群聊,单聊、万人群


//0普通消息 1未过期消息 2过期消息 3 未过期且未浏览（针对除文本消息外）
@property (nonatomic, assign) NSInteger burnType;
//阅后即焚开始时间戳(毫秒)
@property (nonatomic, assign) long long expiresStart;
// 阅后即焚剩余时间(秒)
@property (nonatomic, assign) NSInteger burnRemainTime;

/*!
 消息内容的原始json数据
 
 @discussion 此字段存放消息内容中未编码的json数据。
 SDK内置的消息，如果消息解码失败，默认会将消息的内容存放到此字段；如果编码和解码正常，此字段会置为nil。
 */
//@property(nonatomic, strong, setter=setRawJSONData:) NSData *rawJSONData;



#pragma mark - 额外需要部分属性
@property (nonatomic , assign) CGFloat messageHeight; //消息高度
@property (nonatomic, assign,getter=shouldShowTime) BOOL showTime; // 是否展示时间

@property (nonatomic, assign) BOOL isMulSelected;
/*
 * 是否下载中 YES 是  No 不是
 */
@property(nonatomic) BOOL downloading;
/*
 * 是否播放中 YES 是  No 不是
 */
@property(nonatomic) BOOL audioPlaying;

@end

@interface WeCloudMessageFileContentModel :NSObject

/// 文件主键id
@property (nonatomic,assign) NSInteger fileId;

/// 对应消息id
@property (nonatomic,assign) long long msgKeyId;

/// 对应消息seq（之前文件表设计的有问题，把消息的主键seq赋值给了文件主键，为了兼容旧数据，用这个消息ID字段接收seq）
@property (nonatomic,assign) long long msgId;

/// 所属会话id
@property (nonatomic,assign) long long conversationId;

/*
 * 文件url
 */
@property (nonatomic, copy) NSString *url;
///  本地路径
@property (nonatomic, copy) NSString *locPath;

@property (nonatomic, copy) NSString *fileKey;//加密消息的文件的AES256的key，以逗号隔开的字符串，逗号前面是key，逗号后面是iv

/// 文件名称
@property (nonatomic, strong) NSString *name;
/// MIME类型
@property (nonatomic, copy) NSString *type;

/// 大小 单位：b
@property (nonatomic, assign) NSInteger size;


// 文件的扩展信息json 图片视频的width、height，音视频的duration等
@property (nonatomic, copy) NSString *fileInfo;

@end

typedef NS_ENUM(NSUInteger, WeCloudMemberRelation) {
    /// 陌生人
    WeCloudMemberRelation_Stranger = 1,
    /// 好友
    WeCloudMemberRelation_Friend = 2,
    /// 被我拉黑
    WeCloudMemberRelation_BlackByMe = 3
    
};
typedef NS_ENUM(NSUInteger, WeCloudMemberRole) {
    /// 普通群成员
    WeCloudMemberRole_Normal = 1,
    /// 群管理员
    WeCloudMemberRole_Admins = 2,
    /// 群主
    WeCloudMemberRole_Owner = 3
    
};

@interface WeCloudMemberModel :NSObject
/// 成员主键id
@property (nonatomic,assign) NSInteger memberId;

//所属会话id
@property (nonatomic,assign) long long conversationId;

/// 会话中client的备注名
@property (nonatomic,copy) NSString *clientRemarkName;
/// 头像
@property (nonatomic,copy) NSString *headPortrait;
/// 主昵称
@property (nonatomic,copy) NSString *nickname;
/// 会话中client的id
@property (nonatomic,copy) NSString *clientId;
/// client自己的自定义扩展属性
@property (nonatomic,copy) NSString *clientAttributes;
/// 会话成员列表的自定义扩展属性
@property (nonatomic,copy) NSString *memberAttributes;
/// 角色
@property (nonatomic,assign) WeCloudMemberRole role;

/// 禁言开关 1-未禁言 2-禁言
@property (nonatomic, assign) NSInteger muted;

/// 与我关系 1-陌生人 2-好友 3-被我拉黑
@property (nonatomic,assign) WeCloudMemberRelation relation;

@end

NS_ASSUME_NONNULL_END
