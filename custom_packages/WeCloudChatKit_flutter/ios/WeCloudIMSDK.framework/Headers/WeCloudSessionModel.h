//
//  WeCloudSessionModel.h
//  ChatSDK
//
//  Created by mac on 2022/1/14.
//  Copyright © 2022 wecloud .Icn. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WeCloudMessageModel.h"

NS_ASSUME_NONNULL_BEGIN
@class WeCloudSessionLastMsgModel;
@interface WeCloudSessionModel : NSObject
@property (assign, nonatomic) long conversationId;//会话id
@property (assign, nonatomic) long createTime; //创建时间
@property (assign, nonatomic) long updateTime; //创建时间
@property (copy, nonatomic) NSString *creator;//创建者客户端id
@property (copy, nonatomic) NSString *name;//可选 对话的名字，可为群组命名
@property (copy, nonatomic) NSString *attributes; //可选 自定义属性，供开发者扩展使用。
@property (assign, nonatomic) BOOL systemFlag;//可选 对话类型标志，是否是系统对话，后面会说明
@property (assign, nonatomic) NSInteger msgNotReadCount;//未读消息条数
@property (assign, nonatomic) long lastReadMessageId; // 最后一条已读消息id
//成员
@property (copy, nonatomic) NSString *members;
//会话头像
@property (copy, nonatomic) NSString *headPortrait;
//是否仍在当前会话
@property (assign, nonatomic) BOOL isDriveOut;
//是否加密
@property (assign, nonatomic) NSInteger isEncrypt;
//是否免打扰
@property (assign, nonatomic) BOOL isDoNotDisturb;
//是否置顶
@property (assign, nonatomic) BOOL isTop;
//会话属性，1：单聊，2：普通群，3：万人群 4聊天室
@property (assign, nonatomic) WeCloudChatType chatType;
//是否有@ 信息
@property (nonatomic,assign) BOOL isBeAt;
//群成员数
@property (assign, nonatomic) NSInteger memberCount;
@property (strong, nonatomic) WeCloudMessageModel *lastMsg;

@property (nonatomic, assign) BOOL isCrypt; //是否加密聊天

@property (nonatomic, assign) BOOL isSelected;  //在编辑时是否已被选
@property (nonatomic, assign) BOOL hide;//隐藏会话

@property (nonatomic, assign) NSInteger muted;//禁言开关 1-未禁言 2-禁言

/// 草稿
@property (nonatomic, copy) NSString *draft;

/// 群是否解散
@property (nonatomic,assign) BOOL isDisband;//isDisband

/// 阅后即焚 设置的时长(秒）
@property (nonatomic, assign) NSInteger timeToBurn;

/// 群备注）
@property (nonatomic, copy) NSString *groupRemark;

/// 成员变动时间
@property (assign, nonatomic) long memberChangeTime;

@end

@interface WeCloudSessionLastMsgModel : NSObject
/*
 * 消息类型
 */
@property (assign, nonatomic) NSInteger type;

/// 消息id
@property (copy, nonatomic) NSString *msgId;

/*
 * 上一条消息id
 */
@property (nonatomic, assign) long long preMessageId;


/// 创建时间
@property (copy, nonatomic) NSString *createTime;

/// 撤回时间
@property (copy, nonatomic) NSString *withdrawTime;

/// 发送者客户端id
@property (copy, nonatomic) NSString *sender;

/// 内容
@property (copy, nonatomic) NSString *content;

/// 0未撤回; 1已撤回
@property (assign, nonatomic) BOOL withdraw;

/// 1未删除 2已删除
@property (nonatomic, assign) int deleted;

/// 0非事件; 1为事件
@property (assign ,nonatomic) BOOL event;

/// 0非系统通知; 1为系统通知
@property (assign, nonatomic) BOOL systemFlag;

/// at他人,传入客户端id数组
@property (copy, nonatomic) NSString *at;


/// 未读人数统计,全部人已读为0
@property (assign, nonatomic) NSInteger notReadCount;

/// 未接收人数统计,全部人已接收为0
@property (assign, nonatomic) NSInteger notReceiverCount;

@end

NS_ASSUME_NONNULL_END
