//
//  WeCloudMediaFileManage.h
//  TLiFang
//
//  Created by WeCloudIOS on 2022/6/29.
//  Copyright © 2022 TLF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeCloudMessageModel.h>
typedef void(^WCMediaUpLoadBlock)(BOOL success, _Nullable id responseData, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudMediaFileManage : NSObject

/// 加密文件上传
/// @param message 文件的本地地址
/// @param completionBlock 回调
+(void)uploadFile:(WeCloudMessageModel *)message conversationId:(long long)conversationId callback:(WCMediaUpLoadBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
