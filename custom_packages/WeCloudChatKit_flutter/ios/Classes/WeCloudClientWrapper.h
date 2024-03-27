//
//  WeCloudClientWrapper.h
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/3/23.
//

#import "WeCloudWrapper.h"

NS_ASSUME_NONNULL_BEGIN


@interface WeCloudClientWrapper : WeCloudWrapper

+ (WeCloudClientWrapper *)channelName:(NSString *)aChannelName
                       registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

+ (WeCloudClientWrapper *)sharedWrapper;

@end

NS_ASSUME_NONNULL_END
