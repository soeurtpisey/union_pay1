//
//  WeCloudIMClient+Relation.h
//  WeCloudChatDemo
//
//  关系链相关 例如：黑名单等
//  Created by WeCloudIOS on 2022/4/20.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WeCloudIMClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (Relation)


/// 拉入黑名单
/// @param clientIdBePrevent 被拉黑者id
/// @param completionBlock 回调
- (void)wcimClientIdBePrevent:(NSString *)clientIdBePrevent
              completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 移出黑名单
/// @param clientIdBePrevent 被拉黑者id
/// @param completionBlock 回调
- (void)wcimDeleteClientIdBePrevent:(NSString *)clientIdBePrevent
                    completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;



/// 黑名单分页列表
/// @param pageIndex 页码,默认为1
/// @param pageSorts 排序
/// @param clientId 主动拉黑的用户
/// @param pageSize 页大小,默认为10
/// @param keyword 搜索字符串
/// @param completionBlock 回调
- (void)wcimClientBlacklist:(NSInteger)pageIndex
                   clientId:(NSString *)clientId
                  pageSorts:(NSArray *__nullable)pageSorts
                   pageSize:(NSInteger)pageSize
                    keyword:(NSString *__nullable)keyword
            completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;



@end

NS_ASSUME_NONNULL_END
