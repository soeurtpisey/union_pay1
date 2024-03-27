//
//  WeCloudIMClient+HistoryMessageHelper.h
//  WeCloudChatDemo
//
//  Created by mac on 2022/6/28.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WeCloudIMClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (HistoryMessageHelper)

/** 当前从数据库获取的本地消息，用于和从服务端获取的消息做比对 */
@property (nonatomic, copy) NSArray *curLocalMessageList;



#pragma mark - 拉取消息逻辑(新版)
/// 获取会话的消息列表
/// curMessage：当前消息(以该消息为标准，向前或向后查询limit条消息，返回的列表中不包含此消息，没值代表直接获取最新的消息)
/// isAscend：YES升序，NO降序
/// limit：需要获取消息的数量
/// completeBlock：完成操作的回调，返回的列表顺序和isAscend一致，应用层使用该列表需要注意顺序
- (void)getMessageListWithConversationId:(long long)conversationId
                          currentMessage:(WeCloudMessageModel *__nullable)curMessage
                                isAscend:(BOOL)isAscend
                                   limit:(int)limit
                                callback:(void (^)(NSArray *messageList))completeBlock;

@end

NS_ASSUME_NONNULL_END
