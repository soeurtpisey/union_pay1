//
//  WeCloudIMClient+EndToEndEncrypt.h
//  WeCloudChatDemo
//
//  Created by yumeng on 25/7/2022.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WeCloudIMClient.h"


NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (EndToEndEncrypt)

- (void)wcim_beforeEndToEndChatWithParams:(NSDictionary *)params
                          completionBlock:(WCIMRequestCompletionBlock)completionBlock;

- (void)wcim_saveUserPublicKeyWithParams:(NSDictionary *)params
                         completionBlock:(WCIMRequestCompletionBlock)completionBlock;

- (void)wcim_getOneTimeKeyCountWithParams:(NSDictionary *)params
                          completionBlock:(WCIMRequestCompletionBlock)completionBlock;

- (void)wcim_incrementOneTimeKeyWithParams:(NSDictionary *)params
                           completionBlock:(WCIMRequestCompletionBlock)completionBlock;

- (void)wcim_getGroupUserKeysWithParams:(NSDictionary *)params
                        completionBlock:(WCIMRequestCompletionBlock)completionBlock;

- (void)wcim_encryptedEnabledWithParams:(NSDictionary *)params
                        completionBlock:(WCIMRequestCompletionBlock)completionBlock;

- (void)wcim_encryptedGetKeySaltompletionBlock:(WCIMRequestCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
