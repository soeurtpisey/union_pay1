//
//  WeCloudWrapper.m
//  
//
//  Created by mac on 2022/3/23.
//

#import "WeCloudWrapper.h"
#define easemob_dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }


@implementation WeCloudWrapper

- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super init]) {
        self.flutterPluginRegister = registrar;
        FlutterJSONMethodCodec *codec = [FlutterJSONMethodCodec sharedInstance];
        FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:aChannelName
                                                                    binaryMessenger:[registrar messenger]
                                                                              codec:codec];
        self.channel = channel;
        [registrar addMethodCallDelegate:self channel:channel];
    }
    return self;
}


- (void)wrapperCallBack:(FlutterResult)result
            channelName:(NSString *)aChannelName
                  error:(WeCloudException *)error
                 object:(NSObject *)aObj
{
    if (result) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"error"] = [error toJson];
        if (aObj) {
            dic[aChannelName] = aObj;
        }
        
        easemob_dispatch_main_async_safe(^(){
            result(dic);
        });
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(FlutterMethodNotImplemented);
}


+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    
}

@end
