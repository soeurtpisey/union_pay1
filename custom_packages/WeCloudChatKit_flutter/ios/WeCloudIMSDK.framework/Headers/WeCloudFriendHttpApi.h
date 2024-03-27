//
//  WeCloudFriendHttpApi.h
//  WeCloudChatDemo
//
//  Created by mac on 2022/1/28.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudException.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudFriendHttpApi : NSObject

/// 申请添加好友
/// @param friendClientId 好友的client-id
/// @param friendName 备注好友名称
/// @param requestRemark 请求备注
/// @param completeBlock 结果回调
+ (void)applyFriend:(NSString *)friendClientId friendName:(NSString *__nullable)friendName requestRemark:(NSString *__nullable)requestRemark callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 接受/拒绝好友申请
/// @param agree 是否同意接受好友，true同意，false拒绝
/// @param friendClientId 好友的client-id
/// @param rejectRemark 拒绝理由，如果是同意就不用填啦
/// @param completeBlock 结果回调
+ (void)approveFriend:(BOOL)agree friendClientId:(NSString *)friendClientId rejectRemark:(NSString *__nullable)rejectRemark callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 删除好友
/// @param friendClientIds 好友clientId组
/// @param completeBlock 结果回调
+ (void)batchDeleteFriend:(NSArray *)friendClientIds callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 好友分页列表
/// @param pageIndex 页码,默认为1
/// @param pageSorts 排序
/// @param pageSize 页大小,默认为10
/// @param keyword 搜索字符串
/// @param completeBlock 结果回调，返回好友数据
+ (void)getPageFriendList:(NSInteger)pageIndex pageSorts:(NSArray *__nullable)pageSorts pageSize:(NSInteger)pageSize keyword:(NSString *__nullable)keyword callback:(void (^)(BOOL success,NSArray *friendAry, WeCloudException * apiResult))completeBlock;

/// 查询好友信息，只有自己的好友才查得到
/// @param friendClientId 好友clientId
/// @param completeBlock 结果回调，返回好友信息
+ (void)searchFriendInfo:(NSString *)friendClientId callback:(void (^)(BOOL success,NSDictionary *friendInfo, WeCloudException * apiResult))completeBlock;

/// 批量创建好友推荐
/// @param recommendFriends 好友列表 组 ，
/// 好友信息：{"friendClientId": "","source": 0,"delFlag": true}
/// friendClientId 好友的clientId
/// source 好友推荐来源，1：通讯录，2：二度人脉，3：附近的人，4：同类标签
/// delFlag 是否删除
/// @param completeBlock 结果回调
+ (void)recommendBatchCreate:(NSArray *)recommendFriends callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 删除好友推荐
/// @param friendClientIds 好友clientId组
/// @param completeBlock 结果回调
+ (void)recommendBatchDelete:(NSArray *)friendClientIds callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 好友推荐分页列表
/// @param pageIndex 页码,默认为1
/// @param pageSorts 排序
/// @param pageSize 页大小,默认为10
/// @param keyword 搜索字符串
/// @param completeBlock 结果回调，返回好友数据
+ (void)recommendGetPageFriendList:(NSInteger)pageIndex pageSorts:(NSArray *__nullable)pageSorts pageSize:(NSInteger)pageSize keyword:(NSString *__nullable)keyword callback:(void (^)(BOOL success,NSArray *friendAry, WeCloudException * apiResult))completeBlock;

/// 待接受的好友请求列表，最多只返回1000个
/// @param completeBlock 结果回调，返回好友列表
+ (void)unsureFriendsCallback:(void (^)(BOOL success,NSArray *friendAry, WeCloudException * apiResult))completeBlock;

/// 全量获取好友列表
/// @param completeBlock 结果回调，返回好友列表
+ (void)getFriendsWithCallback:(void (^)(BOOL success,NSArray *friendAry, WeCloudException * apiResult))completeBlock;

#pragma mark ------ 黑名单 ------

/// 拉入黑名单
/// @param clientIdBePrevent 被拉黑者id
/// @param completeBlock 结果回调
+ (void)addClientBlacklistWithClientIdBePrevent:(NSString *)clientIdBePrevent callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 移出黑名单
/// @param clientIdBePrevent 被拉黑者id
/// @param completeBlock 结果回调
+ (void)deleteClientBlacklistWithClientIdBePrevent:(NSString *)clientIdBePrevent callback:(void (^)(BOOL success, WeCloudException * apiResult))completeBlock;

/// 黑名单分页列表
/// @param pageIndex 页码,默认为1
/// @param pageSorts 排序
/// @param pageSize 页大小,默认为10
/// @param keyword 搜索字符串
/// @param completeBlock 结果回调，返回好友数据
+ (void)getClientBlacklist:(NSInteger)pageIndex pageSorts:(NSArray *__nullable)pageSorts pageSize:(NSInteger)pageSize keyword:(NSString *__nullable)keyword callback:(void (^)(BOOL success,NSArray *clientIdBePreventAry, WeCloudException * apiResult))completeBlock;

@end

NS_ASSUME_NONNULL_END
