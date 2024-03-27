//
//  WCIMConversationMemberCache.h
//  WeCloudChatDemo
//
//  Created by mac on 2022/3/8.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCIMConversationMemberCache : NSObject

@property (readonly) NSString *clientId;
- (instancetype)initWithClientId:(NSString *)clientId;

- (void)cacheMembers:(NSArray *)members;

- (void)insertMember:(WeCloudMemberModel *)memberModel;

- (void)deleteMemberByConversationId:(long)conversationId withClientId:(NSString *)clientId;

- (void)deleteMembersByConversationId:(long)conversationId;

- (void)updateClientRemarkNameByConversationId:(long)conversationId clientId:(NSString *)clientId clientRemarkName:(NSString *)clientRemarkName;

- (void)updateRoleByConversationId:(long)conversationId clientId:(NSString *)clientId role:(NSInteger)role;

- (void)updateRoleMembersByConversationId:(long)conversationId clients:(NSArray *)clients role:(NSInteger)role;

- (void)updateMutedMembersByConversationId:(long)conversationId clients:(NSArray *)clients muted:(NSInteger)muted ;

- (void)updateMutedByConversationId:(long)conversationId clientId:(NSString *)clientId muted:(NSInteger)muted;

- (void)updateRelationByConversationId:(long)conversationId clientId:(NSString *)clientId relation:(NSInteger)relation;

#pragma mark 查
- (NSArray *)membersByConversationId:(long)conversationId;

- (NSArray *)membersByConversationId:(long)conversationId role:(NSInteger)role;

- (NSArray *)membersByConversationId:(long)conversationId muted:(NSInteger)muted;
- (NSArray *)membersByConversationId:(long)conversationId role:(NSInteger)role muted:(NSInteger)muted;
- (WeCloudMemberModel *)memberByConversationId:(long)conversationId clientId:(NSString *)clientId;
- (BOOL)containMemberByConversationId:(long)conversationId clientId:(NSString *)clientId;
@end

NS_ASSUME_NONNULL_END
