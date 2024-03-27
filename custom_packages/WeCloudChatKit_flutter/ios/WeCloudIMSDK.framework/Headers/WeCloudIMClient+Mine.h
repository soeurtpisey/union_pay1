//
//  WeCloudIMClient+Mine.h
//  WeCloudChatDemo
//
//  个人资料相关
//  Created by WeCloudIOS on 2022/4/20.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WeCloudIMClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (Mine)


/// 获取自己的信息
/// @param completionBlock 回调
- (void)wcimGetSelfWithCallback:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 查询用户信息 用户可能是好友、陌生人、被拉黑名单的人
/// @param conversationId 会话ID
/// @param clientId 用户ID
/// @param isCache 是否取缓存
/// @param completionBlock 回调
- (void)wcimConversation:(NSInteger)conversationId
                clientId:(NSString *)clientId
                   cache:(BOOL)isCache
                callback:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 查询用户信息 用户可能是好友、陌生人、被拉黑名单的人
/// @param conversationId 会话ID
/// @param clientIds 用户ID
/// @param completionBlock 回调
- (void)wcimConversationInfo:(NSInteger)conversationId
                clientId:(NSArray *)clientIds
                callback:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 查询好友列表
- (void)wcimGetFriendListCallback:(nullable WCIMRequestCompletionBlock)completionBlock;



/// 退出登陆
/// @param completionBlock 回调
- (void)wcimExitWithCallback:(nullable WCIMRequestCompletionBlock)completionBlock;



/// 添加或修改主昵称
/// @param nikeName 昵称
/// @param completionBlock 回调
- (void)wcimUpNickname:(NSString *)nikeName
              Callback:(nullable WCIMRequestCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
