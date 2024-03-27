//
//  WeCloudWrapper.h
//
//
//  Created by mac on 2022/3/23.
//

#import <Flutter/Flutter.h>
#import "WeCloudException+Flutter.h"

NS_ASSUME_NONNULL_BEGIN

#define WeCloudChannelName(name) [NSString stringWithFormat:@"cn.wecloud.im/%@", name]


@interface WeCloudWrapper : NSObject <FlutterPlugin>
@property(nonatomic, strong) FlutterMethodChannel *channel;
@property(nonatomic, strong) NSObject<FlutterPluginRegistrar> *flutterPluginRegister;

- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar> *)registrar;


- (void)wrapperCallBack:(FlutterResult)result
            channelName:(NSString *)aChannelName
                  error:(WeCloudException *__nullable)error
                 object:(NSObject *__nullable)aObj;



@end

NS_ASSUME_NONNULL_END
