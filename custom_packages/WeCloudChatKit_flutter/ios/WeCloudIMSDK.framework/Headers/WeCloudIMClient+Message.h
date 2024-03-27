//
//  WeCloudIMClient+Message.h
//  WeCloudChatDemo
//
//  Created by 与梦信息的Mac on 2022/4/13.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WeCloudIMClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (Message)

#pragma mark - 发送消息
- (void)sendData:(id)data
          action:(NSString *)sendChatType
           reqId:(NSString *)reqId
  conversationId:(NSString *)conversationId;
//新  上面需要替换成这个
- (void)sendData:(id)data
          action:(NSString *)sendChatType
           reqId:(NSString *)reqId
  conversationId:(NSString *)conversationId
     pushContent:(NSDictionary * __nullable)push
           attrs:(NSDictionary * __nullable)attrs;

/// 发送位置消息
/// @param sendChatType 发送类型
/// @param conversationId 会话id
/// @param content 消息内容
/// @param attrs 用来给开发者存储拓展的自定义属性字段
/// @param pushContent 客户端自定义系统推送内容
- (void)sendLocationMessage:(NSString *)sendChatType
                      reqId:(NSString *)reqId
             conversationId:(NSString *)conversationId
                    content:(NSDictionary *)content
                      attrs:(NSDictionary * __nullable)attrs
                pushContent:(NSDictionary * __nullable)pushContent;

/// 自定义类型消息
/// @param message 公共消息体
/// @param sendChatType 自定义消息类型
/// @param customContent 自定义消息体
/// @param pushContent 客户端自定义系统推送内容
- (void)sendCustomMessage:(WeCloudMessageModel *)message
                   action:(NSString *)sendChatType
            customContent:(NSDictionary *__nullable)customContent
              pushContent:(NSDictionary * __nullable)pushContent
                    attrs:(NSDictionary *__nullable)attrs;

/// 发送文本消息
/// @param message 消息体
/// @param sendChatType 发送聊天类型
/// @param pushContent  客户端自定义系统推送内容
/// @param attrs 用来给开发者存储拓展的自定义属性字段
- (void)sendMessage:(WeCloudMessageModel *)message
             action:(NSString *)sendChatType
        pushContent:(NSDictionary *__nullable)pushContent
              attrs:(NSDictionary *__nullable)attrs;

/// 发送文件消息
/// @param message 消息体
/// @param sendChatType 发送聊天类型
/// @param pushContent  客户端自定义系统推送内容
/// @param attrs 用来给开发者存储拓展的自定义属性字段
- (void)sendFileMessage:(WeCloudMessageModel *)message
                 action:(NSString *)sendChatType
            pushContent:(NSDictionary *__nullable)pushContent
                  attrs:(NSDictionary *__nullable)attrs;

#pragma mark - 消息处理相关接口
/// 获取置顶消息
/// @param conversationId 会话id
/// @param completionBlock 回调
- (void)wcim_topMessageInfoWithConversationId:(long long)conversationId
                              completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 设置置顶消息
/// @param conversationId 会话id
/// @param messageId 消息Id
/// @param preMessageId 上一条消息Id
/// @param content 内容
/// @param msgType 消息类型
/// @param completionBlock 回调
- (void)wcim_addTopMessageWithConversationId:(long long)conversationId
                                   messageId:(NSString *)messageId
                                preMessageId:(NSString *)preMessageId
                                     content:(NSString *)content
                                     msgType:(int )msgType
                             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 移除置顶消息
/// @param conversationId 会话id
/// @param topMessageId 置顶消息Id
/// @param completionBlock 回调
- (void)wcim_removeTopMessageWithConversationId:(long long)conversationId
                                   topMessageId:(NSString *)topMessageId
                                completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 删除消息内容
/// @param msgIds 消息id列表
/// @param conversationId 会话id
/// @param completionBlock 回调
- (void)wcim_deleteMessage:(nonnull NSArray *)msgIds
            conversationId:(NSString *)conversationId
           completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;



/// 消息撤回
/// @param msgId 消息id
/// @param conversationId 会话id
/// @param pushData 自定义推送字段(包含title,subTitle,data{})
/// @param completionBlock 回调
- (void)wcim_withdrawMessage:(nonnull NSString *)msgId
              conversationId:(NSString *)conversationId
                    pushData:(nullable NSDictionary *)pushData
             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 消息修改为已读状态
/// @param msgIds 消息id
/// @param completionBlock 回调
- (void)wcim_readerMessage:(NSArray *)msgIds
           completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 修改某个会话的消息为已读状态(旧 z)
/// @param endMsgIds 消息id
/// @param conversationIds 会话id数组
/// @param completionBlock 回调
- (void)wcim_readerMessage:(NSString *)endMsgIds
           conversationIds:(NSArray *)conversationIds
           completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 消息修改为已接收状态
/// @param msgIds 消息id
/// @param readStatus 是否同时修改为已读状态
/// @param completionBlock 回调
- (void)wcim_receiveMessage:(NSArray *)msgIds
                 readStatus:(BOOL)readStatus
             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 获取消息记录
/// @param msgTime 查找时间
/// @param completionBlock 回调
- (void)wcim_get_history_message:(long long)msgTime
                  conversationId:(long long)conversationId
             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 获取指定时间最早的一条消息记录
/// @param msgTime 查找时间
/// @param completionBlock 回调
- (void)wcim_get_history_time_message:(long long)msgTime
                       conversationId:(long long)conversationId
                      completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;



/// 删除聊天记录
/// @param msgs 消息ID
/// @param completionBlock 回调
- (void)wcim_delete_message:(NSArray *)msgs
             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 获取指定会话的所有历史记录信息
/// @param conversationId 会话ID
/// @param completionBlock 回调
- (void)wcim_history_date_message:(long long)conversationId
             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 获取指定会话的所有历史记录信息(只能获取单个文件的url)
/// @param message 消息实例
- (NSString *)wcim_get_file_url:(WeCloudMessageModel *)message;

#pragma 在线收到发送消息回执
- (void)receiveOnlineSendMessageCallBack:(id)response reqId:(NSString *)reqId;


/**
 附件加密，使用AES256加密

 @param data 文件数据
 @param keyIv 消息附带的key，逗号前一半为key，后一半为iv
 @return 加密完的文件数据

 */
- (nullable NSData*)aesEncryptAttachment:(NSData*)data withKeyIv:(nullable NSString*)keyIv;

/**
 附件解密，使用AES256解密

 @param data 服务端下载到的文件数据
 @param keyIv 消息附带的key，逗号前一半为key，后一半为iv
 @return  解密完的文件数据
 */
- (nullable NSData*)aesDecryptAttachment:(NSData*)data withKeyIv:(nullable NSString*)keyIv;

/// 更新消息
- (void)updateCacheMessage:(WeCloudMessageModel *)messageModel;
/// needEncrypt: 是否需要加密
- (void)updateCacheMessage:(WeCloudMessageModel *)messageModel needEncrypt:(BOOL)needEncrypt;

/// 更新消息发送状态
- (void)updateMessageSendStatusWithReqId:(NSString *)reqId Status:(WeCloudMessageStatus)status;


/// 检测该文件是否已本地存储，已存储无需下载
- (BOOL)containCacheNoTextMesaage:(WeCloudMessageModel *)messageModel;

/// 删除指定会话的文件数据
- (void)deleteConversationAllFile:(long)conversationId;

/// 根据消息类型列表，获取会话的消息
/// conversationId:会话id
/// isAscend:是否升序(根据消息的createTime排序)
/// limit:数量限制(如果要查找所有的，传0)
/// curMsgId:当前消息id（根据这个id向前或向后查找limit条数据）
- (NSArray<WeCloudMessageModel *> *)getMessageWithMessageTypeList:(NSArray *)fileTypeList
                                                   conversationId:(long long)conversationId
                                                         isAscend:(BOOL)isAscend
                                                            limit:(NSUInteger)limit
                                                 currentMessageId:(long long)curMsgId;

/// 获取本地会话的消息
/// startTime:开始消息时间(代表想要获取的消息的createTime大于这个时间)
/// endTime:结束消息时间(代表想要获取的消息的createTime小于这个时间)
/// isAscend:是否升序(根据消息的createTime排序)
/// limit:数量限制
/// validMsgId:返回的消息，消息id是否有效(YES：发送失败的消息不要)
/// 注意：
/// 1、如果要获取开始消息和结束消息之间的所有消息，则limit传0，isAscend设置为升序或降序皆可；
/// 2、如果要获取结束消息之前的limit条消息，则startTime传0，isAscend设置为降序；
/// 3、如果要获取开始消息之后的limit条消息，则endTime传0，isAscend设置为升序;
- (NSArray<WeCloudMessageModel *> *)getLocalMessageListWithConversationId:(long long)conversationId
                                                                startTime:(long long)startTime
                                                                  endTime:(long long)endTime
                                                                 isAscend:(BOOL)isAscend
                                                                    limit:(NSUInteger)limit
                                                               validMsgId:(BOOL)validMsgId;

#pragma mark - 消息表更新
/// 更新阅后即焚倒计时
- (void)updateMessageBurnTypeAndBurnRemainTime:(WeCloudMessageModel *)msgModel;

@end

NS_ASSUME_NONNULL_END
