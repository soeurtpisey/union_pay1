//
//  WeCloudIMClient+TRTC.h
//  WeCloudChatDemo
//
//  Created by WeCloudIOS on 2022/4/26.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WeCloudIMClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (TRTC)

/// 同意进入会议
/// @param roomId 房间id
/// @param completionBlock 回调
- (void)wcimAcceptWithRoomId:(NSString *)roomId
              conversationId:(NSInteger)conversationId
                    callback:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 发送心跳
/// @param roomId 频道id
/// @param completionBlock 回调
///
- (void)wcimSendHeartbeat:(NSString *)roomId
           conversationId:(NSInteger)conversationId
             callback:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 邀请加入多人音视频会议
/// @param clientIds 频道id
/// @param roomId 候选者数据
/// @param completionBlock 回调
- (void)wcimInviteWithClientIds:(NSArray *)clientIds
                     roomId:(NSString *)roomId
                 conversationId:(NSInteger)conversationId
                   callback:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 主动挂断(离开会议)
/// @param roomId 频道id
/// @param completionBlock 回调

- (void)wcimLeaveRoomId:(NSString *)roomId
         conversationId:(NSInteger)conversationId
           callback:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 是否正在被呼叫
/// 用于重连打开时是否正在被呼叫的处理

- (void)wcimIsBusy;

/// 未接听（超时）
/// @param roomId 频道id
/// @param completionBlock 回调

- (void)wcimTimeOutRoomId:(NSString *)roomId
           conversationId:(NSInteger)conversationId
             callback:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 拒接进入会议
/// @param roomId 频道id
/// @param completionBlock 回调

- (void)wcimRefuseWithRoomId:(NSString *)roomId
              conversationId:(NSInteger)conversationId
                callback:(nullable WCIMRequestCompletionBlock)completionBlock;


@end

NS_ASSUME_NONNULL_END
