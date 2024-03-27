//
//  WeCloudHttpApi.h
//  ChatSDK
//
//  Created by mac on 2022/1/11.
//  Copyright © 2022 wecloud .Icn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudException.h"


NS_ASSUME_NONNULL_BEGIN

@interface WeCloudHttpApi : NSObject

/// 获取服务器当前时间
+ (void)getServerTimeCallback:(void (^)(BOOL success, NSString *, WeCloudException * apiResult))completeBlock;


+ (void)getSignWithTimestamp:(NSString *)timestamp
                    clientId:(NSString *)clientId
                      appKey:(NSString *)appKey
                   appSecret:(NSString *)appSecret
                    callback:(void (^)(BOOL success, NSString *sign, WeCloudException * apiResult))completeBlock;

/// 退出登陆 清除推送token等
/// @param completeBlock 结果回调
+ (void)logoutCallback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 添加或修改推送设备信息(每次请求都会覆盖之前的数据)
/// @param valid 设备不想收到推送提醒, 1想, 0不想
/// @param deviceToken 设备推送token
/// @param completeBlock 结果回调
+ (void)addDeviceInfoValid:(NSInteger)valid
               deviceToken:(NSString *)deviceToken
               pushChannel:(NSString *)pushChannel
                  callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 获取token
/// @param timestamp 时间戳,需与生成sign时的值一致
/// @param clientId  client客户端id,需与生成sign时的值一致
/// @param appKey  appkey,需与生成sign时的值一致
/// @param sign 签名sign
/// @param completeBlock 获取结果回调
+ (void)getTokenWithTimestamp:(NSString *)timestamp
                     clientId:(NSString *)clientId
                       appKey:(NSString *)appKey
                         sign:(NSString *)sign
                     platform:(NSInteger)platform
                     callback:(void (^)(BOOL success, NSString *token, NSString *clientId, WeCloudException *apiResult))completeBlock;

/// 查询加入的会话列表
/// @param completeBlock 获取结果回调
+ (void)getConversationListWithCallback:(void (^)(BOOL success,NSArray *conversationAry, WeCloudException *apiResult))completeBlock;


/// 分页获取的会话列表
/// @param pageSorts 排序 如： [ {"column": "","asc": true}],
/// @param pageIndex 页码
/// @param pageSize 页大小,默认为10
/// @param keyword 搜索字符串
/// @param completeBlock 结果回调
///
+ (void)getConversationPageListWithPageSorts:(NSArray *__nullable)pageSorts
                                   pageIndex:(NSInteger )pageIndex
                                    pageSize:(NSInteger)pageSize
                                     keyword:(NSString * __nullable)keyword
                                    callback:(void (^)(BOOL success,NSArray *messageAry, WeCloudException * apiResult))completeBlock;



/// 查询有未读消息的会话列表
/// @param completeBlock 获取结果回调
+ (void)getUnreadConversationListWithCallback:(void (^)(BOOL success,NSArray *conversationAry, WeCloudException * apiResult))completeBlock;

/// 会话列表 批量已读
/// @param conversationIds 会话列表数组
/// @param completeBlock 结果的回调
+ (void)postconversationBatchReadWithConversationIds:(NSArray *)conversationIds callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;


/// 设置在当前会话的已读位置或未读标记
/// @param conversationId  会话id
/// @param lastReadMsgId 最后一条已读消息id
/// @param isNote 是否标位未读 0否1是
/// @param needCount 是否需要返回剩余未读数量 true需要 false不需要 如果传false默认返回-1    
/// @param completeBlock 结果的回调
+ (void)postSetNoteByConversationWithConversationId:(long long )conversationId
                                      lastReadMsgId:(long long )lastReadMsgId
                                              sNote:(BOOL)isNote
                                          needCount:(BOOL)needCount
                                           callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 创建会话
/// @param name  可选 对话的名字，可为群组命名。
/// @param attributes json格式,可选 自定义属性，供开发者扩展使用。
/// @param clientIds 可选 邀请加入会话的客户端,如创建单聊,则填入对方的clientId
/// @param completeBlock 结果的回调
+ (void)createConversationWithName:(NSString *)name
                        attributes:(NSString * __nullable)attributes
                         clientIds:(NSArray *)clientIds
                          platform:(NSInteger)platform
                          chatType:(NSInteger)chatType
                          callback:(void (^)(BOOL success, NSString *conversationId, WeCloudException *apiResult))completeBlock;

/// 将用户添加进会话
/// @param conversationId 会话id
/// @param clientIds 要操作的clientId
/// @param completeBlock 结果返回
+ (void)conversationAddClient:(NSString *)conversationId
                    clientIds:(NSArray *)clientIds
                     callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 将client从会话移除
/// @param conversationId 会话id
/// @param clientIds 要操作的clientId
/// @param completeBlock 结果返回
+ (void)conversationDelClient:(NSString *)conversationId
                    clientIds:(NSArray *)clientIds
                     callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// client退出会话
/// @param conversationId 会话id
/// @param transfer 会话的创建者退出时,是否需要转移给下一个client, true为转移, false为不转移直接解散
/// @param completeBlock 结果回调
+ (void)conversationLeaveClient:(NSString *)conversationId
                       transfer:(BOOL )transfer
                       callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 群主转让
/// @param conversationId 会话id
/// @param clientId 即将成为群主的clientId
/// @param completeBlock 结果回调
+ (void)conversationTransferOwner:(NSInteger)conversationId
                         clientId:(NSString *)clientId
                         callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 设置群管理员
/// @param conversationId 会话id
/// @param clientIds 要设置为群管理员的clientId列表
/// @Param operateType 操作类型 1-设置管理员 2-删除管理员
/// @param completeBlock 结果回调
+ (void)conversationSetAdmins:(NSInteger)conversationId
                    clientIds:(NSArray *)clientIds
                  operateType:(NSInteger)operateType
                     callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 解散群聊
/// @param conversationId 会话id
/// @param completeBlock 结果回调
+ (void)conversationDisband:(NSInteger)conversationId
                   callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 消息修改为已接收状态
/// @param msgIds 消息id数组,可以传入单个或多个, 如接收离线消息列表时可以批量修改 则传入多个
/// @param readStatus 是否同时修改为已读状态
/// @param completeBlock 结果的回调
+ (void)msgReceivedUpdateWithMsgIds:(NSArray *)msgIds
                         readStatus:(BOOL)readStatus
                           callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 消息修改为已读状态
/// @param msgIds 消息id数组,可以传入单个或多个, 如接收离线消息列表时可以批量修改 则传入多个
/// @param completeBlock 结果的回调
+ (void)msgReadUpdateWithMsgIds:(NSArray *)msgIds
                       callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 修改某个会话的消息为已读状态
/// @param endMsgIds 消息id数组, 截止这条消息以上的数据为已读
/// @param conversationIds 会话ID数组
/// @param completeBlock 结果的回调
+ (void)msgReadUpdateWithLastMsgIds:(NSString *)endMsgIds
                    conversationIds:(NSArray *)conversationIds
                       callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;


/// 消息撤回
/// @param msgId 消息id
/// @param conversationId 会话id
/// @param push 自定义推送字段
/// @param completeBlock 结果回调
+ (void)withdrawImMessageWithMsgId:(NSString *)msgId
                    conversationId:(NSString *)conversationId
                              push:(NSDictionary *)push
                          callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 获取置顶消息
/// @param conversationId 会话id
/// @param completeBlock 结果回调
+ (void)topMessageInfoWithConversationId:(long long)conversationId
                                callback:(void (^)(BOOL success,NSDictionary * topMessageInfo ,WeCloudException * apiResult))completeBlock;

/// 设置置顶消息
/// @param conversationId 会话id
/// @param messageId 消息Id
/// @param preMessageId 上一条消息Id
/// @param content 内容
/// @param msgType 消息类型
/// @param completeBlock 结果回调
+ (void)addTopMessageWithConversationId:(long long)conversationId
                              messageId:(NSString *)messageId
                           preMessageId:(NSString *)preMessageId
                                content:(NSString *)content
                                msgType:(int )msgType
                               callback:(void (^)(BOOL success,NSDictionary * topMessageInfo ,WeCloudException * apiResult))completeBlock;

/// 移除置顶消息
/// @param conversationId 会话id
/// @param topMessageId 置顶消息Id
/// @param completeBlock 结果回调
+ (void)removeTopMessageWithConversationId:(long long)conversationId
                              topMessageId:(NSString *)topMessageId
                                  callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock ;



/// 删除消息(单条消息与批量消息删除共用)
/// @param msgIds 消息id列表
/// @param conversationId 会话id
/// @param completeBlock 结果回调
+ (void)deleteImMessageWithMsgId:(NSArray *)msgIds
                  conversationId:(NSString *)conversationId
                        callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 获取离线数据列表
/// @param completeBlock 结果回调
+ (void)getOfflineListWithCallback:(void (^)(BOOL success,NSArray *messageAry, WeCloudException * apiResult))completeBlock;

/// 查询某个会话历史消息分页列表
/// @param conversationId 会话id
/// @param msgIdStart 起始的消息id
/// @param msgIdEnd 结束的消息的id
/// @param pageSorts 排序 如： [ {"column": "","asc": true}],
/// @param pageIndex 页码
/// @param pageSize 页大小,默认为10
/// @param keyword 搜索字符串
/// @param completeBlock 结果回调
///
+ (void)getHistoryMsgWitConversationId:(NSString *)conversationId
                            msgIdStart:(NSString *__nullable)msgIdStart
                              msgIdEnd:(NSString *__nullable)msgIdEnd
                             pageSorts:(NSArray *__nullable)pageSorts
                             pageIndex:(NSInteger )pageIndex
                              pageSize:(NSInteger)pageSize
                               keyword:(NSString * __nullable)keyword
                              callback:(void (^)(BOOL success,NSArray *messageAry, WeCloudException * apiResult))completeBlock;

/// 查询某个会话历史消息分页列表(新)
/// @param conversationId 会话id
/// @param msgIdStart 起始的消息id
/// @param msgIdEnd 结束的消息的id
/// @param pageSorts 排序 如： [ {"column": "","asc": true}],
/// @param pageIndex 页码
/// @param pageSize 页大小,默认为10
/// @param keyword 搜索字符串
/// @param isAscend 排序方式 YES正序 NO倒序
/// @param completeBlock 结果回调
///
+ (void)getHistoryMsgWitConversationId:(long long)conversationId
                            msgIdStart:(long long)msgIdStart
                              msgIdEnd:(long long)msgIdEnd
                             pageSorts:(NSArray *__nullable)pageSorts
                             pageIndex:(NSInteger )pageIndex
                              pageSize:(NSInteger)pageSize
                               keyword:(NSString * __nullable)keyword
                                  sort:(BOOL)isAscend
                              callback:(void (^)(BOOL success,NSArray *messageAry, WeCloudException * apiResult))completeBlock;


/// 查询离线消息 会返回包括自己的最后一条
/// @param conversationId 会话id
/// @param msgIdStart 起始的消息id
/// @param msgIdEnd 结束的消息的id
/// @param pageSorts 排序 如： [ {"column": "","asc": true}],
/// @param pageIndex 页码
/// @param pageSize 页大小,默认为10
/// @param keyword 搜索字符串
/// @param completeBlock 结果回调
///
+ (void)getHistoryWitConversationId:(NSString *)conversationId
                         msgIdStart:(NSString *__nullable)msgIdStart
                           msgIdEnd:(NSString *__nullable)msgIdEnd
                          pageSorts:(NSArray *__nullable)pageSorts
                          pageIndex:(NSInteger )pageIndex
                           pageSize:(NSInteger)pageSize
                            keyword:(NSString * __nullable)keyword
                           callback:(void (^)(BOOL success,NSArray *messageAry, WeCloudException * apiResult))completeBlock;



/// 获取远程历史消息数据
/// @param conversationId 会话id
/// @param endMessageId 当前本地最早的那条消息
/// @param limit 页大小,默认为10
/// @param completeBlock 结果回调
+ (void)getRemoteMessagesForConversationId:(long long)conversationId
                              endMessageId:(long long)endMessageId
                                     limit:(int)limit
                                  callback:(void (^)(BOOL success,NSArray *messageAry, WeCloudException * apiResult))completeBlock;

/// 获取会话中成员表列表
/// @param conversationId 会话id
/// @param roles 角色列表
/// @param clientIds clientId列表，传了则只查询指定入参群成员
/// @param muted 禁言开关 1-未禁言 2-禁言
/// @param completeBlock 结果回调，返回成员数据
+ (void)getImConversationMembersList:(NSString *)conversationId
                               roles:(NSArray *__nullable)roles
                           clientIds:(NSArray *__nullable)clientIds muted:(NSString *__nullable)muted
                            callback:(void (^)(BOOL success,NSArray *members, WeCloudException * apiResult))completeBlock;

/// 群禁言
/// @param conversationId 会话id
/// @param clientIds 禁言指定群成员列表 - 群禁言无需入参
/// @param mutedType 禁言类型 1-取消禁言 2-禁言
/// @param completeBlock 结果回调
+ (void)conversationMutedGroup:(NSInteger)conversationId
                     clientIds:(NSArray *__nullable)clientIds
                     mutedType:(NSInteger)mutedType
                      callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 选择禁言
/// @param conversationId 会话id
/// @param clientIds 禁言指定群成员列表 - 群禁言无需入参
/// @param mutedType 禁言类型 1-取消禁言 2-禁言
/// @param completeBlock 结果回调
+ (void)conversationMutedGroupMember:(NSInteger)conversationId
                           clientIds:(NSArray *__nullable)clientIds
                           mutedType:(NSInteger)mutedType
                            callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 根据会话id查询指定会话信息
/// @param conversationId 会话id
/// @param completeBlock 结果回调，返回会话信息
+ (void)getConversationInfo:(NSInteger)conversationId
                   callback:(void (^)(BOOL success,NSDictionary *conversationDic, WeCloudException * apiResult))completeBlock;

/// 根据会话id查询指定会话信息
/// @param conversationId 会话id
/// @param chatType 会话类型
/// @param completeBlock 结果回调，返回会话信息
+ (void)getConversationInfo:(NSInteger)conversationId
                   chatType:(int)chatType
                   callback:(void (^)(BOOL success,NSDictionary *conversationDic, WeCloudException * apiResult))completeBlock;

/// 添加或修改会话成员备注
/// @param clientRemarkName 会话中的client备注,展示给会话中其他client查看的
/// @param conversationId 会话表id
/// @param completeBlock 结果回调
+ (void)updateConversationClientRemarkName:(NSString *)clientRemarkName
                            conversationId:(NSInteger)conversationId
                                  callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;
/// 修改会话头像
/// @param url 头像地址
/// @param conversationId 会话表id
/// @param completeBlock 结果回调
+ (void)updateConversationHeader:(NSString *)url
                            conversationId:(NSInteger)conversationId
                                  callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;


/// 修改会话备注
/// @param attributes string格式,自定义属性，供开发者扩展使用。
/// @param conversationId 会话表id
/// @param completeBlock 结果回调
+ (void)updateConversationAttributes:(NSString *)attributes
                      conversationId:(NSInteger)conversationId
                            callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 添加或修改会话名称
/// @param name 对话的名字，可为群组命名
/// @param conversationId 会话表id
/// @param completeBlock 结果回调
+ (void)saveOrUpdateConversationName:(NSString *)name
                      conversationId:(NSInteger)conversationId
                            callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 查询会话中用户信息 用户可能是好友、陌生人、被拉黑名单的人
/// @param conversationId 会话id
/// @param clientId 被查的clientId
/// @param completeBlock 结果回调
+ (void)imClientInfoConversation:(NSInteger)conversationId
                        clientId:(NSString *)clientId
                        callback:(void (^)(BOOL success,NSDictionary *clientInfo, WeCloudException * apiResult))completeBlock;

/// 会话修改为已读
/// @param conversationId 会话表id
/// @param completeBlock 结果回调
+ (void)updateConversationReadId:(NSInteger)conversationId
                         lastMsg:(NSInteger)lastMsgId
                        callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

#pragma mark --------- rtcXI相关 ---------

/// 创建频道,并邀请客户端加入
/// @param toClient 被邀请的客户端ID
/// @param callType 类型: 1-video或2-voice
/// @param attrs 客户端自定义数据
/// @param conversationId 绑定的会话id,可选
/// @param push 接收方展示的系统推送内容,可选
/// @param pushCall 是否需要给对方发系统通知
/// @param completeBlock 结果回调，返回频道id
+ (void)createAndCallRTC:(NSString *)toClient
                callType:(NSInteger)callType
                   attrs:(NSString * __nullable)attrs
          conversationId:(NSString *__nullable)conversationId
                    push:(NSString * __nullable)push
                pushCall:(BOOL)pushCall
                callback:(void (^)(BOOL success,NSString *channelId, WeCloudException * apiResult, NSString *message))completeBlock;

/// candidate候选者数据转发
/// @param channelId 频道id
/// @param candidateData 候选者数据
/// @param completeBlock 结果回调
+ (void)candidateForwardRTC:(NSString *)channelId
              candidateData:(NSString *)candidateData
                   callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 同意进入频道
/// @param channelId 频道id
/// @param completeBlock 结果回调
+ (void)joinRTC:(NSString *)channelId
       callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 主动挂断(离开频道)
/// @param channelId 频道id
/// @param completeBlock 结果回调
+ (void)leaveRTC:(NSString *)channelId
        callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 拒接进入频道
/// @param channelId 频道id
/// @param completeBlock 结果回调
+ (void)rejectRTC:(NSString *)channelId
         callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// SDP数据转发
/// @param channelId 频道id
/// @param sdpData sdp转发的数据
/// @param sdpType sdp类型: Offer或Answer
/// @param completeBlock 结果回调
+ (void)sdpForwardRTC:(NSString *)channelId
              sdpData:(NSString * __nullable)sdpData sdpType:(NSString *)sdpType
             callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 进入房间
/// @param clientId 用户ID
/// @param chatRoomId 房间ID
/// @param completeBlock 结果回调
+ (void)joinRoomWithClientId:(NSString *)clientId
                  chatRoomId:(NSInteger)chatRoomId
                    platform:(NSInteger)platform
                    callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 离开房间
/// @param clientId 用户ID
/// @param chatRoomId 房间ID
/// @param completeBlock 结果回调
+ (void)leaveRoomWithClientId:(NSString *)clientId
                   chatRoomId:(NSInteger)chatRoomId
                     platform:(NSInteger)platform
                    callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 查询聊天室成员
/// @param chatRoomId 会话表id
/// @param completeBlock 结果回调
+ (void)searchChatRoomUsers:(NSInteger)chatRoomId
                   platform:(NSInteger)platform
                   callback:(void (^)(BOOL success,NSArray *members, WeCloudException * apiResult))completeBlock;

/// 获取会话的最后一条已读消息
+ (void)getConversationLastReadMessageWithCallback:(void (^)(BOOL success, id msgId, WeCloudException * apiResult))completeBlock;

#pragma mark ------- 端对端加密 -------

/// 发起加密聊天，获取加密的房间号以及对方的3个公钥
+ (void)beforeEndToEndChatWithParams:(NSDictionary *)params
                            callback:(void (^)(BOOL success,NSDictionary *data ,WeCloudException * apiResult))completeBlock;


/// ///向服务端保存自己的三个公钥
+ (void)saveUserPublicKeyWithParams:(NSDictionary *)params
                           callback:(void (^)(BOOL success,NSDictionary *data, WeCloudException * apiResult))completeBlock;

/// 查询自己还有多少个一次性密钥
+ (void)getOneTimeKeyCountWithParams:(NSDictionary *)params
                            callback:(void (^)(BOOL success,NSDictionary *data, WeCloudException * apiResult))completeBlock;


/// 补充自己的一次性密钥
+ (void)incrementOneTimeKeyWithParams:(NSDictionary *)params
                             callback:(void (^)(BOOL success,NSDictionary *data, WeCloudException * apiResult))completeBlock;

/// 批量获取群内用户公钥
+ (void)getGroupUserKeysWithParams:(NSDictionary *)params
                          callback:(void (^)(BOOL success, NSArray *data, WeCloudException * apiResult))completeBlock;

/// 是否可用端对端加密
+ (void)encryptedEnabledWithParams:(NSDictionary *)params
                          callback:(void (^)(BOOL success, BOOL data, WeCloudException * apiResult))completeBlock;
+ (void)getKeySaltCallback:(void (^)(BOOL success, NSString *keySalt, WeCloudException * apiResult))completeBlock;
@end

NS_ASSUME_NONNULL_END
