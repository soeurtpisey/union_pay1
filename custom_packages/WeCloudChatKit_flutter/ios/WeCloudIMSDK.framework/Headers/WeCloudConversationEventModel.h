//
//  WeCloudConversationEventModel.h
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/3/28.
//

#import <Foundation/Foundation.h>
#import "WeCloudMessageModel.h"
#import "WeCloudSessionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WeCloudConversationEventModel : NSObject

@property (assign, nonatomic) long conversationId;//会话id
/// 消息id
@property (nonatomic, assign) long  msgId;

/*
 * 发送者的用户id
 */
@property (nonatomic) NSString * sender;

/*
 * 消息类型
 */
@property (nonatomic, assign) WeCloudIMMessageMediaType type;

//@property (nonatomic, copy) NSString *operator;/// //操作的client ID
///
///
@property (nonatomic, copy) NSString *operatorId;/// //操作的client ID

@property (nonatomic, assign) BOOL muted; //是否被禁言

///
@property (nonatomic, copy) NSString *passivityOperator;/// //被操作的client ID

@property (copy, nonatomic) NSString *name;//可选 对话的名字，可为群组命名

@property (strong, nonatomic) NSString *attributes; // 会话属性改动

@property (copy, nonatomic) NSString *remarkName; // 成员名字改动

@property (copy, nonatomic) NSString *headPortrait; // 群头像变动

@property (strong ,nonatomic) WeCloudMessageModel *message;

@property (strong ,nonatomic) WeCloudSessionModel *session;
 
@end

NS_ASSUME_NONNULL_END
