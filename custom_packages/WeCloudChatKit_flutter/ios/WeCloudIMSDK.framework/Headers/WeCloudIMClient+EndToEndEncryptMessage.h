//
//  WeCloudIMClient+EndToEndEncryptMessage.h
//  WeCloudChatDemo
//
//  Created by yumeng on 25/7/2022.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import "WeCloudIMClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudIMClient (EndToEndEncryptMessage)

- (void)receiveOnlineEncryptMessage:(id)messageData;

- (void)sendEncryptFileMessage:(WeCloudMessageModel *)message
                 action:(NSString *)sendChatType
            pushContent:(NSDictionary *__nullable)pushContent
                         attrs:(NSDictionary *__nullable)attrs;

- (void)sendEncryptMessage:(WeCloudMessageModel *)message
             action:(NSString *)sendChatType
        pushContent:(NSDictionary * __nullable)pushContent
                     attrs:(NSDictionary * __nullable)attrs;

- (void)getEncryptConversationInfoAfterBeInvited:(long long)conversationId
                                         message:(WeCloudMessageModel*)model
                                    isNewMessage:(BOOL)newMessage
                                        callBack:(void (^)(void))callback;

/// 获取本地数据加密key
- (NSString *)getLocalMessageEncryptKeyWithMessage:(WeCloudMessageModel *)messageModel ;

/// 加密本地消息
- (WeCloudMessageModel *)aesEncryptLocalMessage:(WeCloudMessageModel *)message ;

/// 解密本地消息
- (WeCloudMessageModel *)aesDecryptLocalMessage:(WeCloudMessageModel *)message ;


///本地是否有该用户的公钥相关信息
- (BOOL)isHaveTheUserRecipientIdentityWithUserId:(NSString *)userId ;


@end

NS_ASSUME_NONNULL_END
