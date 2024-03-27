//
//  WeCloudTRTCApi.h
//  WeCloudChatDemo
//
//  Created by WeCloudIOS on 2022/4/8.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudException.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudTRTCApi : NSObject
/// 获取用户sign
/// @param clientId client用户ID
/// @param appKey  appKey
/// @param timestamp  时间戳 可有可无
/// @param appSecret  密钥
/// @param completeBlock 结果回调
+ (void)getSign:(NSString *)clientId  appKey:(NSString *)appKey timestamp:(NSString * __nullable)timestamp appSecret:(NSString *)appSecret callback:(void (^)(BOOL success,NSString *sign,NSString *timestamp, WeCloudException * apiResult))completeBlock;

/// 获取token
/// @param clientId  用户ID
/// @param appKey  appkey,需与生成sign时的值一致
/// @param sign 签名sign
/// @param completeBlock 获取结果回调
+ (void)getTokenWithClientId:(NSString *)clientId timestamp:(NSString *)timestamp appKey:(NSString *)appKey sign:(NSString *)sign callback:(void (^)(BOOL success, NSString *token, NSString *roomId, WeCloudException *apiResult))completeBlock;

/// 邀请用户
/// @param clientIds  用户列表
/// @param roomId  房间号
/// @param completeBlock 获取结果回调
+ (void)inviteWithClientIds:(NSArray *)clientIds
                     roomId:(NSString *)roomId
             conversationId:(NSInteger)conversationId
                   callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 被邀请用户获取token
/// @param roomId  房间ID
/// @param appKey  appkey,需与生成sign时的值一致
/// @param sign 签名sign
/// @param clientId 签名用户ID
/// @param timestamp 时间戳
/// @param completeBlock 获取结果回调
+ (void)inviterWithClientId:(NSString *)clientId timestamp:(NSString *)timestamp appKey:(NSString *)appKey sign:(NSString *)sign roomId:(NSString *)roomId callback:(void (^)(BOOL success, NSString *token, WeCloudException *apiResult))completeBlock;


/// 被邀请用户接听
/// @param roomId  房间ID
/// @param completeBlock 获取结果回调
+ (void)acceptWithRoomId:(NSString *)roomId
          conversationId:(NSInteger)conversationId
                callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;


/// 被邀请用户拒绝
/// @param roomId  房间ID
+ (void)refuseWithRoomId:(NSString *)roomId
          conversationId:(NSInteger)conversationId
                callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 用户超时 可能是自己 也可能是对方
/// @param roomId  client客户端id,需与生成sign时的值一致
+ (void)timeOutRoomId:(NSString *)roomId
       conversationId:(NSInteger)conversationId
             callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 用户离开(主动离开)
/// @param roomId  client客户端id,需与生成sign时的值一致
+ (void)leaveRoomId:(NSString *)roomId
     conversationId:(NSInteger)conversationId
           callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 连接后的心跳
/// @param roomId  client客户端id
+ (void)sendHeartbeat:(NSString *)roomId
       conversationId:(NSInteger)conversationId
             callback:(void (^)(BOOL success, WeCloudException *apiResult))completeBlock;

/// 是否被呼叫
+ (void)IsBusy;
@end

NS_ASSUME_NONNULL_END
