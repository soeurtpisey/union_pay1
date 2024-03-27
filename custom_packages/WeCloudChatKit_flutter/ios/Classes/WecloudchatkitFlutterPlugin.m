#import "WecloudchatkitFlutterPlugin.h"
#import "WeCloudClientWrapper.h"

@implementation WecloudchatkitFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wunused-variable"
     [WeCloudClientWrapper channelName:WeCloudChannelName(@"chat_client")  registrar:registrar];
    
 #pragma clang diagnostic pop
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
