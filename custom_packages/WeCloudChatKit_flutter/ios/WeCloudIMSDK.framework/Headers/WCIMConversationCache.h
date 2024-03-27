//
//  WCIMConversationCache.h
//  WeCloudChatDemo
//
//  Created by 与梦信息的Mac on 2022/2/17.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WeCloudSessionModel;

@interface WCIMConversationCache : NSObject

@property (nonatomic, copy, readonly) NSString *clientId;

- (instancetype)initWithClientId:(NSString *)clientId;

- (void)cacheConversations:(NSArray *)conversations newList:( void (^ _Nullable )(NSArray *list))list;

- (void)cacheConversations:(NSArray *)conversations ;

- (void)insertConversation:(WeCloudSessionModel *)conversation;

- (NSArray *)allConversations;

- (NSArray *)selectAllConversationsWithHidden;

- (WeCloudSessionModel *)conversationForId:(long long)conversationId;

- (WeCloudSessionModel *)conversationForMember:(NSArray *) menberArray;

/// 清空会话的本地所有数据
/// @param conversationId 会话id
- (void)removeAllLocalMessageOfConversationForId:(long long)conversationId;


- (void)removeConversationForId:(long long)conversationId;

- (void)removeConversationAndItsMessagesForId:(long long)conversationId;

- (void)removeAllMessageOfConversationForId:(long long)conversationId;

- (void)updateConversationForUpdateAt:(double)updateAt conversationId:(long long)conversationId;

- (void)updateConversationWithConversation:(WeCloudSessionModel *)conversation;

- (void)updateUnreadForConversationId:(long long)conversationId;

/// 更新会话
/// @param conversation 会话model
- (void)updateConversationWithConversation:(WeCloudSessionModel *)conversation;


/// 更新会话隐藏状态
/// @param conversation 会话model
- (void)updateConversationForHideWithConversation:(WeCloudSessionModel *)conversation;


/// 更新会话隐藏状态
/// @param hide YES:隐藏，NO:显示
/// @param conversationId 会话id
- (void)updateConversationForHide:(BOOL)hide conversationId:(long long)conversationId;


/// 更新会话禁言状态
/// @param conversation 会话model
- (void)updateConversationForMutedWithConversation:(WeCloudSessionModel *)conversation;


/// 更新会话禁言状态
/// @param muted 1:未禁言 2:禁言
/// @param conversationId 会话id
- (void)updateConversationForMuted:(NSInteger)muted conversationId:(long long)conversationId;

/// 更新会话草稿
/// @param conversation 会话model
- (void)updateConversationForDraftWithConversation:(WeCloudSessionModel *)conversation;

/// 更新会话草稿
/// @param draft 草稿信息
/// @param conversationId 会话id
- (void)updateConversationForDraft:(NSString *)draft conversationId:(long long)conversationId;

/// 更新会话是否解散
/// @param conversation 会话model
- (void)updateConversationForDisbandWithConversation:(WeCloudSessionModel *)conversation;

/// 更新会话是否解散
/// @param disband 是否解散
/// @param conversationId 会话id
- (void)updateConversationForDisband:(BOOL)disband conversationId:(long long)conversationId;

/// 更新当前是否在会话
/// @param isDriveOut 是否再会话
/// @param conversationId 会话id
- (void)updateConversationForDriveOut:(BOOL)isDriveOut conversationId:(long long)conversationId;

/// 更新会话头像 (本地)
/// @param conversation 会话model
- (void)updateConversationForHeadPortrait:(WeCloudSessionModel *)conversation;

/// 更新会话置顶
/// @param top 是否置顶
/// @param conversationId 会话ID
- (void)updateConversationForDisbandTop:(BOOL)top
                         conversationId:(long long)conversationId;

/// 更新会话免打扰
/// @param disturbing 是否免打扰
/// @param conversationId 会话ID
- (void)updateConversationForDisbandDisturbing:(BOOL)disturbing conversationId:(long long)conversationId;

/// 设置所有会话为断开连接状态
- (void)updateConversationFordisconnect;

/// 更新指定会话是否已重新连接
/// @param disconnect 是否重新连接
/// @param conversationId 会话id
- (void)updateConversationFordisconnect:(BOOL)disconnect conversationId:(long long)conversationId;

/// 设置会话全部已读
/// @param conversationId 会话id
- (void)updateReadForConversationId:(long long)conversationId;

/// 更新群会话的群成员人数
- (void)updateConversationMemberCount:(WeCloudSessionModel *)conversation;

/*!
 * Clean all expired conversations.
 */
- (void)cleanAllExpiredConversations;

@end

NS_ASSUME_NONNULL_END
