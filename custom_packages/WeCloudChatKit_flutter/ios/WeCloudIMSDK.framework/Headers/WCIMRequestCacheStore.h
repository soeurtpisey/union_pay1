//
//  WCIMRequestCacheStore.h
//  WeCloudChatDemo
//
//  Created by 与梦信息的Mac on 2022/4/13.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WCIMCacheStore.h"
#import "WCIMRequestCacheModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCIMRequestCacheStore : WCIMCacheStore


/// 插入或者更新请求缓存
/// @param requestCache 请求缓存模型
- (void)insertRequestCache:(WCIMRequestCacheModel *)requestCache;


/// 根据请求id删除对应缓存
/// @param reqId 请求id
- (void)deleteRequestCacheById:(NSString *)reqId;


/// 根据请求id查询对应缓存
/// @param reqId 请求id
- (WCIMRequestCacheModel *)requestCacheForId:(NSString *)reqId;


@end

NS_ASSUME_NONNULL_END
