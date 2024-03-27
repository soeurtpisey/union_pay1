//
//  WeCloudSingeRTCWrapper.m
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/4/21.
//

#import "WeCloudSingeRTCWrapper.h"
#import "WeCloudSDKMethod.h"

//#import "WeCloudIMClientHeader.h"
//#import "WeCloudHttpApi.h"
//#import "WCExtension.h"
#import <WeCloudIMSDK/WeCloudIMSDK.h>

@interface WeCloudSingeRTCWrapper()<WeCloudIMClientRTCEventDelegate>

@end

@implementation WeCloudSingeRTCWrapper


static WeCloudSingeRTCWrapper *wrapper = nil;

- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
        [registrar addApplicationDelegate:self];
        [WeCloudIMClient sharedWeCloudIM].rtcEventDelegate = self;
        
    }
    return self;
}


#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
     if([WeCloudMethodKeyCreateAndCall isEqualToString:call.method]){
         [self createAndCallRtc:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyJoinRtcChannel isEqualToString:call.method]){
        [self joinRtcChannelRtc:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyRejectRtcCall isEqualToString:call.method]){
        [self rejectRtcCallRtc:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeySdpForward isEqualToString:call.method]){
        [self sdpForwardRtc:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyCandidateForward isEqualToString:call.method]){
        [self candidateForwardRtc:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyLeaveRtcChannel isEqualToString:call.method]){
        [self leaveRtcChannelRtc:call.arguments channelName:call.method result:result];
    } else {
        [super handleMethodCall:call result:result];
    }
}

#pragma mark ---- actions
- (void)createAndCallRtc:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    
    NSString *toClient = params[@"toClient"];
    NSString *attrs = params[@"attrs"];
    WeCloudWeRTCType callType = [params[@"callType"] integerValue];
    NSString *conversationId = params[@"conversationId"] ;
    NSString *push = params[@"push"];
    BOOL pushCall = [params[@"pushCall"] boolValue];
    
    [[WeCloudIMClient sharedWeCloudIM] wcimCreateAndCallRTC:toClient callType:callType attrs:attrs conversationId:conversationId push:push pushCall:pushCall completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:error?nil:responseData[@"channelId"]];
    }];
    
}
- (void)joinRtcChannelRtc:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    
    NSString *channelId = params[@"channelId"];
    
    [[WeCloudIMClient sharedWeCloudIM] wcimJoinRTC:channelId completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error? 0:1)];
        
    }];
    
    
}
- (void)rejectRtcCallRtc:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    
    NSString *channelId = params[@"channelId"];
    
    [[WeCloudIMClient sharedWeCloudIM]  wcimRejectRTC:channelId completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error? 0:1)];
    }];
}
- (void)leaveRtcChannelRtc:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *channelId = params[@"channelId"];
    
    [[WeCloudIMClient sharedWeCloudIM] wcimLeaveRTC:channelId completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error? 0:1)];
        
    }];
}
- (void)sdpForwardRtc:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *channelId = params[@"channelId"];
    NSString *sdpData = params[@"sdpData"];
    NSString *sdpType = params[@"sdpType"];
    
    [[WeCloudIMClient sharedWeCloudIM] wcimSdpForwardRTC:channelId sdpData:sdpData sdpType:sdpType completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error? 0:1)];
        
    }];
    
}
- (void)candidateForwardRtc:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *channelId = params[@"channelId"];
    NSString *candidateData = params[@"candidateData"];
    
    [[WeCloudIMClient sharedWeCloudIM] wcimCandidateForwardRTC:channelId candidateData:candidateData completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error? 0:1)];
    }];
    
}



#pragma mark ------- WeCloudIMClientRTCEventDelegate ----
/// 接收到RTC邀请
/// @param rtcModel rtc事件数据
- (void)onProcessCallEvent:(WeCloudRTCEventModel *)rtcModel {
    [self.channel invokeMethod:WeCloudMethodKeyOnProcessCallEvent
                               arguments:rtcModel.WC_keyValues];
}


/// 有client加入频道
/// @param rtcModel rtc事件数据
- (void)onProcessJoinEvent:(WeCloudRTCEventModel *)rtcModel {
    [self.channel invokeMethod:WeCloudMethodKeyOnProcessJoinEvent arguments:rtcModel.WC_keyValues];
}

/// 有Client拒绝加入频道
/// @param rtcModel rtc事件数据
- (void)onProcessRejectEvent:(WeCloudRTCEventModel *)rtcModel {
    [self.channel invokeMethod:WeCloudMethodKeyOnProcessRejectEvent arguments:rtcModel.WC_keyValues];
}

/// 有client离开频道
/// @param rtcModel rtc事件数据
- (void)onProcessLeaveEvent:(WeCloudRTCEventModel *)rtcModel {
    [self.channel invokeMethod:WeCloudMethodKeyOnProcessLeaveEvent arguments:rtcModel.WC_keyValues];
}

/// client SDP 下发
/// @param rtcModel rtc事件数据
- (void)onProcessSdpEvent:(WeCloudRTCEventModel *)rtcModel {
    [self.channel invokeMethod:WeCloudMethodKeyOnProcessSdpEvent arguments:rtcModel.WC_keyValues];
}

/// client Candidate 下发
/// @param rtcModel rtc事件数据
- (void)onProcessCandidateEvent:(WeCloudRTCEventModel *)rtcModel {
    [self.channel invokeMethod:WeCloudMethodKeyOnProcessCandidateEvent arguments:rtcModel.WC_keyValues];
}

@end
