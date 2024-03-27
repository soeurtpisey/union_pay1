//
//  WeCloudIMClient+RTCMedia.h
//  WeCloudChatDemo
//
//  Created by WeCloudIOS on 2022/4/20.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "RTCRecordModel.h"
#import "WeCloudIMClient.h"


NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (RTCMedia)

#pragma mark 
/// candidate候选者数据转发
/// @param channelId 频道id
/// @param candidateData 候选者数据
/// @param completionBlock 回调
- (void)wcimCandidateForwardRTC:(NSString *)channelId
                  candidateData:(NSString *)candidateData
                completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 创建频道,并邀请客户端加入
/// @param toClient 被邀请的客户端ID
/// @param callType 类型: 1-video或2-voice
/// @param attrs 客户端自定义数据
/// @param conversationId 绑定的会话id,可选
/// @param push 接收方展示的系统推送内容,可选
/// @param pushCall 是否需要给对方发系统通知
/// @param completionBlock 回调
- (void)wcimCreateAndCallRTC:(NSString *)toClient
                    callType:(NSInteger)callType
                       attrs:(NSString * __nullable)attrs
              conversationId:(NSString *__nullable)conversationId
                        push:(NSString * __nullable)push
                    pushCall:(BOOL)pushCall
             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 同意进入频道
/// @param channelId 频道id
/// @param completionBlock 回调

- (void)wcimJoinRTC:(NSString *)channelId
    completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 主动挂断(离开频道)
/// @param channelId 频道id
/// @param completionBlock 回调
- (void)wcimLeaveRTC:(NSString *)channelId
    completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 拒接进入频道
/// @param channelId 频道id
/// @param completionBlock 回调
- (void)wcimRejectRTC:(NSString *)channelId
    completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// SDP数据转发
/// @param channelId 频道id
/// @param sdpData sdp转发的数据
/// @param sdpType sdp类型: Offer或Answer
/// @param completionBlock 回调
- (void)wcimSdpForwardRTC:(NSString *)channelId
                  sdpData:(NSString *__nullable)sdpData
                  sdpType:(NSString *)sdpType
          completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 加入聊天室 
/// @param clientId 用户ID
/// @param chatRoomId 聊天室ID
/// @param completionBlock 回调
- (void)wcimJoinRoomWithClientId:(NSString *)clientId
                      chatRoomId:(NSInteger)chatRoomId
                        platform:(NSInteger)platform
                 completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 离开聊天室
/// @param clientId 用户ID
/// @param chatRoomId 聊天室ID
/// @param completionBlock 回调
- (void)wcimLeaveRoomWithClientId:(NSString *)clientId
                       chatRoomId:(NSInteger)chatRoomId
                         platform:(NSInteger)platform
                  completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 查询聊天室成员
/// @param chatRoomId 聊天室ID
/// @param completionBlock 回调
- (void)wcimSearchChatRoomUsers:(NSInteger)chatRoomId
                       platform:(NSInteger)platform
                completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 获取通话记录
/// @param type 0全部，1未接听
/// @param completionBlock 回调
- (void)wcimSearchCallRecordUsers:(int)type
                  completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 保存通话记录
/// @param model 通话记录的模型
/// @param completionBlock 回调
- (void)wcimSaveCallRecordUsers:(RTCRecordModel*)model
                  completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 删除通话记录
/// @param modelArr 通话记录的模型 数组
/// @param completionBlock 回调
- (void)wcimRemoveCallRecordUsers:(NSArray *)modelArr
                  completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


@end

NS_ASSUME_NONNULL_END
