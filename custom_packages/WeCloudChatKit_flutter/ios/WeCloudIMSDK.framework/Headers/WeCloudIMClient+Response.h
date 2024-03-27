//
//  WeCloudIMClient+Response.h
//  WeCloudChatDemo
//
//  Created by 与梦信息的Mac on 2022/4/14.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WCIMRequestCache.h"
#import "WeCloudIMClient.h"
#import "WeCloudGroupModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (Response)

@property (nonatomic, strong) WCIMRequestCache *requestCache;

- (void)receiveOnlineRequestResponse:(id)response reqId:(NSString *)reqId;

/// 请求超时处理
/// @param reqId 请求id
/// @param delayTime 超时时间，默认10秒
- (void)dealOvertimeRequestWithReqId:(NSString *)reqId delayTime:(NSInteger)delayTime;

/// 退出登录
- (void)signOut;

@end

NS_ASSUME_NONNULL_END
