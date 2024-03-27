//
//  WeCloudIMClientProtocol.h
//  WeCloudChatDemo
//
//  Created by mac on 2022/1/29.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudMessageModel.h"
#import "WeCloudFriendModel.h"
#import "WeCloudConversationEventModel.h"
#import "WeCloudSessionModel.h"
#import "WeCloudRTCEventModel.h"
#import "WeCloudTransparentEventModel.h"
#import "AddFriendsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WeCloudIMClientDelegate <NSObject>

@optional
/*
 * imClient 连接状态的改变
 * status 最新的连接状态
 */
- (void)imClientStatusChange:(WeCloudIMClientStatus)status;


/// 会话全部同步完成
- (void)onConversationSyncComplete;

@end


@protocol WeCloudIMClientReceiveMessageDelegate <NSObject>

@optional

/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 */
- (void)onReceived:(WeCloudMessageModel *)message;

/// 消息状态改变时回调方法
/// @param sendStatus 消息状态
/// @param reqId 发送此条消息时的请求id
/// @param msgIds 消息id组
/// @param messageModel 消息体
/// @param errorCode 错误码
- (void)didUpdateMessageStatus:(WeCloudMessageStatus)sendStatus reqId:(NSString * __nullable)reqId msgIds:(NSArray * __nullable)msgIds messageModel:(WeCloudMessageModel *  __nullable)messageModel errorCode:(NSInteger)errorCode;

/*!
 消息已投递给对方。
 @param message - 具体的消息
 */
- (void)messageDelivered:(WeCloudMessageModel *)message;

/*
 消息已被对方读取
 @param message - 具体的消息
 */
- (void)messageReaded:(WeCloudMessageModel *)message;

@end

@protocol WeCloudIMClientConversationDelegate <NSObject>

@optional
#pragma mark ------- 会话相关事件 --------

/// 会话事件
/// @param convEvent 会话事件信息model
- (void)onConversationEvent:(WeCloudConversationEventModel *)convEvent;


/// 会话更新 ---未读数，是否@等服务器返回数据变化时
/// @param conversationModel 会话model
- (void)onUpdateConversation:(WeCloudSessionModel *)conversationModel;

/// 会话添加
/// @param conversationModel 会话model
- (void)onAddConversation:(WeCloudSessionModel *)conversationModel;

/// 会话删除
/// @param conversationId 会话id
- (void)onRemoveConversation:(long)conversationId;

/// 会话全部同步完成
- (void)onConversationListSyncComplete:(NSArray<WeCloudSessionModel *>*)sessionArray;

/// 会话未读消息总数
/// @param totalNotReadCount 未读消息总数
- (void)onTotalNotReadCountChangeListener:(int )totalNotReadCount;

@end



@protocol WeCloudIMClientReceiveFriendShipDelegate <NSObject>

@optional

#pragma mark ------- 好友相关 --------
/*!
 收到好友申请
 @param friendModel --- 申请者信息体
 */
- (void)friendShipInviteByFriend:(WeCloudFriendModel *)friendModel;
/*!
 好友验证结果
 @param friendModel --- 被邀请者信息体，包含验证结果
 */
- (void)friendShipVerificationResult:(WeCloudFriendModel *)friendModel;

/*!
 好友资料更新
 @param friendModel --- 被邀请者信息体，包含验证结果
 */
- (void)friendShipUpdate:(AddFriendsModel *)friendModel;

@end


#pragma mark ------- WeCloudIMClientTRTCDelegate --------

@protocol WeCloudIMClientTRTCDelegate <NSObject>

@required

/*!
 收到邀请
 @param data --- 邀请信息
 */

-(void)receiveTRTC:(NSDictionary *)data;
/*!
 用户进入
 @param data --- 进入信息
 */
-(void)joinTRTC:(NSDictionary *)data;
/*!
 用户拒绝
 @param data --- 拒绝信息
 */
-(void)refuseTRTC:(NSDictionary *)data;
/*!
 用户离开
 @param data --- 离开信息
 */
-(void)leaveTRTC:(NSDictionary *)data;
/*!
 用户占线
 @param data --- 占线信息
 */
-(void)busyTRTC:(NSDictionary *)data;
/*!
 用户超时无响应
 @param data --- 占线信息
 */
-(void)timeOutCancel:(NSDictionary *)data;

@end

#pragma mark ------- WeCloudIMTRTCCallDelegate --------

@protocol WeCloudIMTRTCCallDelegate <NSObject>

@optional

/*!
 是否开启自定义的弹窗视图 非必要继承
 @param viewController --- 展示的视图
 */
-(void)customTRTCCallView:(UIViewController * _Nullable) viewController;

/*!
 返回需要数组{视图控制器、房间ID、用户token}
 */
-(NSArray *)customViewController;

@end

@protocol WeCloudIMClientRTCEventDelegate <NSObject>

@optional
#pragma mark ------- 单人RTC相关事件 --------

/// 接收到RTC邀请
/// @param rtcModel rtc事件数据
- (void)onProcessCallEvent:(WeCloudRTCEventModel *)rtcModel;


/// 有client加入频道
/// @param rtcModel rtc事件数据
- (void)onProcessJoinEvent:(WeCloudRTCEventModel *)rtcModel;

/// 有Client拒绝加入频道
/// @param rtcModel rtc事件数据
- (void)onProcessRejectEvent:(WeCloudRTCEventModel *)rtcModel;

/// 有client离开频道
/// @param rtcModel rtc事件数据
- (void)onProcessLeaveEvent:(WeCloudRTCEventModel *)rtcModel;

/// client SDP 下发
/// @param rtcModel rtc事件数据
- (void)onProcessSdpEvent:(WeCloudRTCEventModel *)rtcModel;

/// client Candidate 下发
/// @param rtcModel rtc事件数据
- (void)onProcessCandidateEvent:(WeCloudRTCEventModel *)rtcModel;

@end


@protocol WeCloudIMClientTransparentEventDelegate <NSObject>

@optional

#pragma mark ------- 透传消息相关事件 --------

- (void)onTransparentMessageEvent:(WeCloudTransparentEventModel *)transparentEventModel;

/*
 * imClient 连接状态的改变
 * status 最新的连接状态
 */
- (void)imClientStatusChange:(WeCloudIMClientStatus)status;

@end

NS_ASSUME_NONNULL_END
