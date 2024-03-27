//
//  WeCloudIMClient+Conversation.h
//  WeCloudChatDemo
//
//  Created by 与梦信息的Mac on 2022/4/14.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WeCloudIMClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (Conversation)


/// 获取会话列表(旧 z)
/// @param completionBlock 请求回调
- (void)wcim_get_conversationList:(nullable WCIMRequestCompletionBlock)completionBlock;


///分页获取的会话列表
/// @param pageSorts 页面数量
/// @param pageIndex 页数
/// @param pageSize 分页数量
/// @param keyword 关键词
/// @param completionBlock 回调
- (void)wcim_get_conversationListWithPageSorts:(NSArray *__nullable)pageSorts
                                     pageIndex:(NSInteger )pageIndex
                                      pageSize:(NSInteger)pageSize
                                       keyword:(NSString * __nullable)keyword
                               completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock ;

///查询有未读消息的会话列表
/// @param completionBlock 请求回调
- (void)wcim_get_unreadConversationList:(WCIMRequestCompletionBlock)completionBlock;



/// 会话列表批量已读
/// @param conversationAndIsMessageReadList 会话列表id和是否已读的数组
/// @param completionBlock 请求回调
- (void)wcim_post_conversationBatchRead:(NSArray *__nullable)conversationAndIsMessageReadList
                        completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 设置在当前会话的已读位置或未读标记
/// @param conversationId 会话id
/// @param lastReadMsgId 最后一条已读消息id
/// @param isNote 是否标位未读 0否1是
/// @param needCount 是否需要返回剩余未读数量 true需要 false不需要 如果传false默认返回-1
/// @param completionBlock 请求回调
- (void)wcim_post_setNoteByConversationWithConversationId:(long long )conversationId
                                            lastReadMsgId:(long long )lastReadMsgId
                                                   isNote:(BOOL)isNote
                                                needCount:(BOOL)needCount
                                          completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

///根据会话id查询指定会话信息
- (void)wcim_get_conversationInfo:(long long)conversationId
                         chatType:(int)chatType
                  completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 获取本地会话列表
/// @param completionBlock 请求回调
- (void)wcim_get_local_conversationList:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 根据会话id查询指定会话信息
/// @param conversationId 会话id
/// @param completionBlock 回调
- (void)wcim_get_conversationInfo:(long long)conversationId
                  completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 根据会话id查询指定会话信息
- (WeCloudSessionModel *)wcim_get_conversation:(long long)conversationId;

///存储会话信息
///@param sessionModel 会话信息模型
- (void)wcim_save_conversationInfo:(WeCloudSessionModel *)sessionModel ;

/// 获取会话中成员表列表
/// @param conversationId 会话id
/// @param clientIds clientId列表，传了则只查询指定入参群成员
/// @param roles 角色列表 可多选，不传则查全部
/// @param muted 禁言开关 1-未禁言 2-禁言
/// @param completionBlock 回调
- (void)wcim_get_conversationMembers:(long long)conversationId
                           clientIds:(nullable NSArray *)clientIds
                               roles:(nullable NSArray *)roles
                               muted:(nullable NSString *)muted
                     completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 添加或修改会话成员备注
/// @param conversationId 会话id
/// @param remark 备注
/// @param completionBlock 回调
- (void)wcim_update_conversationMemberRemark:(long long)conversationId
                                      remark:(nonnull NSString *)remark
                             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 修改群头像
/// @param conversationId 会话id
/// @param url 头像地址
/// @param completionBlock 回调
- (void)wcim_update_conversationHeader:(long long)conversationId
                                   url:(nonnull NSString *)url
                       completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 创建会话列表
/// @param name 会话名称 可选 对话的名字，可为群组命名
/// @param clientIds 可选 邀请加入会话的客户端,如创建单聊,则填入对方的clientId
/// @param chatType 会话属性，1：单聊，2：普通群，3：万人群  4：新增一个创建聊天室
/// @param platform  3 IOS平台
/// @param isEncrypt  是否加密
/// @param attributes 用户自定义参数
/// @param completionBlock 请求回调
- (void)wcim_post_createConversation:(nullable NSString *)name
                           clientIds:(nullable NSArray *)clientIds
                            chatType:(NSInteger)chatType
                            platform:(NSInteger)platform
                           isEncrypt:(NSInteger)isEncrypt
                          attributes:(nullable NSString *)attributes
                     completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 更新会话属性
/// @param conversationId 会话ID
/// @param attributes string格式,自定义属性，供开发者扩展使用。
/// @param completionBlock 请求回调
- (void)wcim_post_upateConversation:(long long)conversationId
                         attributes:(NSString *)attributes
                     completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 将用户添加进会话
/// @param conversationId 会话id
/// @param clientIds 要操作的clientId
/// @param completionBlock 回调
- (void)wcim_add_conversationClient:(long long)conversationId
                          clientIds:(nonnull NSArray *)clientIds
                    completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 将client从会话移除
/// @param conversationId 会话id
/// @param clientIds 要操作的clientId
/// @param completionBlock 回调
- (void)wcim_delete_conversationClient:(long long)conversationId
                             clientIds:(nonnull NSArray *)clientIds
                       completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 查询某个会话历史消息分页列表
/// @param conversationId 会话id
/// @param endMessageId 最后一条消息的ID
/// @param limit 分页数量
/// @param completionBlock 回调
- (void)wcim_get_conversationClient:(long long)conversationId
                       endMessageId:(long long)endMessageId
                              limit:(int)limit
                       completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 查询某个会话历史消息分页列表2
/// @param conversationId 会话id
/// @param msgIdStart 第一条消息的ID
/// @param msgIdEnd 最后一条消息的ID
/// @param pageSorts 页面数量
/// @param pageIndex 页数
/// @param pageSize 分页数量
/// @param keyword 关键词
/// @param completionBlock 回调
- (void)wcim_get_historyMsgWitConversationId:(NSString *)conversationId
                                  msgIdStart:(NSString *__nullable)msgIdStart
                                    msgIdEnd:(NSString *__nullable)msgIdEnd
                                   pageSorts:(NSArray *__nullable)pageSorts
                                   pageIndex:(NSInteger )pageIndex
                                    pageSize:(NSInteger)pageSize
                                     keyword:(NSString * __nullable)keyword
                             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 查询某个会话历史消息分页列表(新)
/// @param conversationId 会话id
/// @param msgIdStart 第一条消息的ID
/// @param msgIdEnd 最后一条消息的ID
/// @param pageSorts 页面数量
/// @param pageIndex 页数
/// @param pageSize 分页数量
/// @param keyword 关键词
/// @param sort 排序方式 YES正序 NO倒序
/// @param completionBlock 回调
- (void)wcim_get_historyMsgWitConversationId:(long long)conversationId
                                  msgIdStart:(long long)msgIdStart
                                    msgIdEnd:(long long)msgIdEnd
                                   pageSorts:(NSArray *__nullable)pageSorts
                                   pageIndex:(NSInteger )pageIndex
                                    pageSize:(NSInteger)pageSize
                                     keyword:(NSString * __nullable)keyword
                                        sort:(BOOL)isAscend
                             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 查询离线消息 会返回包括自己的最后一条
/// @param conversationId 会话id
/// @param msgIdStart 第一条消息的ID
/// @param msgIdEnd 最后一条消息的ID
/// @param pageSorts 页面数量
/// @param pageIndex 页数
/// @param pageSize 分页数量
/// @param keyword 关键词
/// @param completionBlock 回调
- (void)getHistoryWitConversationId:(NSString *)conversationId
                         msgIdStart:(NSString *__nullable)msgIdStart
                           msgIdEnd:(NSString *__nullable)msgIdEnd
                          pageSorts:(NSArray *__nullable)pageSorts
                          pageIndex:(NSInteger )pageIndex
                           pageSize:(NSInteger)pageSize
                               last:(int)isLast
                            keyword:(NSString * __nullable)keyword
                    completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 解散群聊
/// @param conversationId 会话id
/// @param completionBlock 回调
- (void)wcim_post_disbandConversation:(long long)conversationId
                      completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// client退出会话
/// @param conversationId 会话id
/// @param transfer 会话的创建者退出时,是否需要转移给下一个client, true为转移, false为不转移直接解散
/// @param completionBlock 回调
- (void)wcim_post_leaveConversation:(long long)conversationId
                           transfer:(BOOL)transfer
                    completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 群禁言、取消群禁言
/// @param conversationId 会话id
/// @param mutedType 禁言类型 1.取消禁言 2.禁言
/// @param completionBlock 回调
- (void)wcim_post_conversationMutedGroup:(long long)conversationId
                               mutedType:(NSInteger)mutedType
                         completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 选择禁言
/// @param conversationId 会话id
/// @param mutedType 禁言类型 1.取消禁言 2.禁言
/// @param clientIds 禁言指定群成员列表
/// @param completionBlock 回调
- (void)wcim_post_conversationMutedGroup:(long long)conversationId
                               mutedType:(NSInteger)mutedType
                               clientIds:(nonnull NSArray *)clientIds
                         completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 设置群管理员
/// @param conversationId 会话id
/// @param clientIds 要设置为群管理员的clientId列表
/// @param operateType 操作类型 1-设置管理员 2-删除管理员
/// @param completionBlock 回调
- (void)wcim_set_conversationGroupAdmins:(long long)conversationId
                               clientIds:(nonnull NSArray *)clientIds
                             operateType:(NSInteger)operateType
                         completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 群主转让
/// @param conversationId 会话id
/// @param clientId 即将成为群主的clientId
/// @param completionBlock 回调
- (void)wcim_post_conversationGroupTransferOwner:(long long)conversationId
                                        clientId:(NSString *)clientId
                                 completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 添加或修改会话名称
/// @param conversationId 会话id
/// @param name 会话名称
/// @param completionBlock 回调
- (void)wcim_update_conversationName:(long long)conversationId
                                name:(NSString *)name
                     completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 修改会话未已读
/// @param conversationId 会话id
/// @param lastMsgId  最后一条消息ID
/// @param completionBlock 回调
- (void)wcim_update_conversation_read:(long long)conversationId
                              lastMsg:(NSInteger)lastMsgId
                     completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 删除本地会话数据
- (void)deleteConversationFromDB:(long)conversationId  completionBlock:(WCIMRequestCompletionBlock)completionBlock;

/// 删除会话
/// @param conversationId 会话id
/// @param completionBlock 回调
- (void)wcim_remove_conversation:(long long)conversationId
                 completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 是否置顶
/// @param conversationId 会话id
/// @param completionBlock 回调
- (void)wcim_top_conversation:(long long)conversationId
                        isTop:(BOOL)isTop
              completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 是否免打扰
/// @param conversationId 会话id
/// @param completionBlock 回调
- (void)wcim_disturb_conversation:(long long)conversationId
                        isDisturb:(BOOL)isDisturb
               completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 更新会话消息Model
/// @param sessionModel 会话model
- (void)wcim_update_sessionModel:(WeCloudSessionModel *)sessionModel;

/// 清空聊天记录
/// @param conversationId 群组ID
/// @param completionBlock 回调
- (void)wcim_clear_messagec:(long long)conversationId
             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 更新(取消)at信息
/// @param conversationId 群组ID
/// @param completionBlock 回调
- (void)wcim_clear_at_message:(long long)conversationId
             completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 更新会话草稿
/// @param conversationId 群组ID
- (void)wcim_save_draft:(long long)conversationId
               draftStr:(NSString *)draft;

/// 获取本地所有的群聊(包括隐藏、不包括解散)
- (void)wcim_get_groups:(nullable WCIMRequestCompletionBlock)completionBlock;

/// 获取本地所有的群聊(不包括隐藏、不包括解散)
- (void)wcim_get_groupsWithOther:(nullable WCIMRequestCompletionBlock)completionBlock;

- (void)getGroupMembers:(long long)conversationId
                                 clientIds:(NSArray *)clientIds
                                     roles:(NSArray *)roles
                  muted:(NSString *)muted Callback:(void (^)(BOOL success, NSArray * members, NSError * _Nullable error, NSInteger responseCode))completeBlock;

/// 获取会话的最后一条已读消息
- (void)wcim_get_conversationLastReadMessage:(WCIMRequestCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
