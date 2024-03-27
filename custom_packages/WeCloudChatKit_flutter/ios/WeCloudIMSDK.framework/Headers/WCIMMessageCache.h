//
//  WCIMMessageCache.h
//  WeCloudChatDemo
//
//  Created by 与梦信息的Mac on 2022/2/18.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudMessageModel.h"

@interface WCIMMessageCache : NSObject

@property (readonly) NSString *clientId;

+ (instancetype)cacheWithClientId:(NSString *)clientId;

- (NSArray *)messagesOrderedByTimestampDescending:(NSArray *)messages;

- (void)insertMessage:(WeCloudMessageModel *)message;

- (void)insertMessageNew:(WeCloudMessageModel *)message callback:(void (^)(BOOL isOK))callback;

- (void)insertMessageWithConversation:(WeCloudMessageModel *)message;

- (void)addContinuousMessages:(NSArray *)messages;

/// 分页加载本地所有消息
- (NSArray *)messagesLocalAllBeforeTimestamp:(double)timestamp
                      conversationId:(long long)conversationId
                                       limit:(NSUInteger)limit;
/// 分页加载消息（不包含删除的）
- (NSArray *)messagesBeforeTimestamp:(double)timestamp
                      conversationId:(long long)conversationId
                               limit:(NSUInteger)limit;

- (void)deleteMessages:(NSArray *)messages;

- (void)deleteMessage:(WeCloudMessageModel *)message;

- (void)deleteMessageBySeq:(NSInteger)seq;

- (void)deleteMessageByMsgId:(long long)msgId;

- (void)deleteMessageByReqId:(NSString *)reqId;

//当重新连接后，更新所有的发送中消息为发送失败
- (void)updateMessageIdWithOffLine;

- (void)updateMessageId:(WeCloudMessageModel *)message;

- (void)updateMessage:(WeCloudMessageModel *)message;

- (void)updateMessageId:(long long)msgId reqId:(NSString *)reqId;

- (void)updateMessageIdWhenSendSuccess:(long long)msgId reqId:(NSString *)reqId;

- (void)updateMessageStatus:(WeCloudMessageModel *)message;

/// 根据msgId更新消息状态
/// @param msgStatus 消息状态
/// @param msgId 消息id
- (void)updateMessageStatus:(WeCloudMessageStatus)msgStatus msgId:(long long)msgId;

- (void)updateMessageAttrs:(NSDictionary *)attrs msgId:(long long)msgId;

- (void)updateMessageNoReadCount:(WeCloudMessageModel *)message;

- (void)updateMessageNoReceiveCount:(WeCloudMessageModel *)message;

/// 更新阅后即焚消息的状态
- (void)updateMessageBurnTypeAndBurnRemainTime:(WeCloudMessageModel *)msgModel;

- (WeCloudMessageModel *)messageAfterTimestamp:(double)timestamp conversationId:(long long)conversationId;

- (NSArray *)latestAllMessagesWithLimit:(NSUInteger)limit forConversation:(long long)conversationId;

- (NSArray *)messagesAfterTimestamp:(double)timestamp conversationId:(long long)conversationId;

- (NSArray *)messagesBeforeTimestamp:(double)timestamp conversationId:(long long)conversationId;

- (int)messagesCountWithConversationId:(long long)conversationId;

- (WeCloudMessageModel *)nextMessageForMessage:(WeCloudMessageModel *)message;

- (WeCloudMessageModel *)beforeMessageForMessage:(WeCloudMessageModel *)message;

- (NSArray *)latestMessagesWithLimit:(NSUInteger)limit forConversation:(long long)conversationId;

- (WeCloudMessageModel *)latestMessageForConversation:(long long)conversationId isSucc:(BOOL)isSucc;

- (WeCloudMessageModel *)earliestMessageForConversation:(long long)conversationId;

- (WeCloudMessageModel *)realEarliestMessageForConversation:(long long)conversationId;

- (WeCloudMessageModel *)messageForId:(long long)msgId;

/// 查询本地所拥有的记录天数
- (void)getHistoryDayForConversation:(long long)conversationId
                            callBack:(void (^)(NSArray *dateList))callBack;

/// 根据msgID获取消息
- (void)getHistoryForMsgId:(long long)msgId
            conversationId:(long long)conversationId
                     limit:(NSUInteger)limit
                  callBack:(void (^)(NSArray *dateList))callBack;

/// 根据req_id取消息
/// @param reqId req_id
- (WeCloudMessageModel *)messageForReqId:(NSString *)reqId;

- (BOOL)isHadMsgForConversation:(long long)conversationId dayTimeStamp:(long)dayTimeStamp;

- (BOOL)isHadMsgForConversation:(long long)conversationId beforeDate:(long)beforeDate;

- (BOOL)isHadMsgForConversation:(long long)conversationId afterDate:(long)afterDate;

- (BOOL)containMessage:(WeCloudMessageModel *)message;

//消息真正存在本地
- (BOOL)containMessageToReal:(WeCloudMessageModel *)message;

/// 获取会话的文件列表
/// types:文件类型列表
/// conversationId:会话id
/// /// isAscend:是否升序(根据消息的createTime排序)
/// limit:数量限制
/// curMsgId:当前消息id（根据这个id向前或向后查找limit条数据）
- (NSArray *)messagesWithTypes:(NSArray *)types
                conversationId:(long long)conversationId
                      isAscend:(BOOL)isAscend
                         limit:(NSUInteger)limit
              currentMessageId:(long long)curMsgId;

/// 获取本地会话的消息
/// startTime:开始消息时间(代表想要获取的消息的createTime大于这个时间)
/// endTime:结束消息时间(代表想要获取的消息的createTime小于这个时间)
/// isAscend:是否升序(根据消息的createTime排序)
/// limit:数量限制
/// validMsgId:返回的消息，消息id是否有效(大于0，发送失败的消息不要)
/// 注意：
/// 1、如果要获取开始消息和结束消息之间的所有消息，则limit传0，isAscend设置为升序或降序皆可；
/// 2、如果要获取结束消息之前的limit条消息，则startTime传0，isAscend设置为降序；
/// 3、如果要获取开始消息之后的limit条消息，则endTime传0，isAscend设置为升序;
- (NSArray *)getLocalMessageListWithConversationId:(long long)conversationId
                                         startTime:(long long)startTime
                                           endTime:(long long)endTime
                                          isAscend:(BOOL)isAscend
                                             limit:(NSUInteger)limit
                                        validMsgId:(BOOL)validMsgId;

/// 根据会话id和消息id，获取消息
- (WeCloudMessageModel *)messageForConversation:(long long)conversationId msgId:(long long)msgId;

@end

