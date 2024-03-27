//
//  WeCloudFriendManagerWrapper.m
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/3/27.
//

#import "WeCloudFriendManagerWrapper.h"
#import "WeCloudSDKMethod.h"

//#import "WeCloudIMClient.h"
//#import "WeCloudFriendHttpApi.h"
#import <WeCloudIMSDK/WeCloudIMSDK.h>


@interface WeCloudFriendManagerWrapper ()<WeCloudIMClientReceiveFriendShipDelegate>

@end

@implementation WeCloudFriendManagerWrapper

- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
        [registrar addApplicationDelegate:self];
        
        [WeCloudIMClient sharedWeCloudIM].friendShipDelegate = self;
    }
    return self;
}

#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([WeCloudMethodKeyApplyFriendFromServer isEqualToString:call.method]){
       [self applyFriend:call.arguments channelName:call.method result:result];
   } else if ([WeCloudMethodKeyApproveFriendFromServer isEqualToString:call.method]){
       [self approveFriend:call.arguments channelName:call.method result:result];
   } else if ([WeCloudMethodKeyBatchDeleteFriendFromServer isEqualToString:call.method]){
       [self batchDeleteFriend:call.arguments channelName:call.method result:result];
   }
}

- (void)applyFriend:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;

    NSString *friendClientId = param[@"friendClientId"];
    NSString *friendName;
    NSString *requestRemark;
    for (NSString *key in param.allKeys) {
        if ([key isEqualToString:@"friendName"]) {
            friendName = param[@"friendName"];
        } else if ([key isEqualToString:@"remark"]) {
            requestRemark = param[@"requestRemark"];
        }
    }
    
    [WeCloudFriendHttpApi applyFriend:friendClientId friendName:friendName requestRemark:requestRemark callback:^(BOOL success, WeCloudException * _Nonnull apiResult) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:success ?nil :apiResult
                           object:@(success)];
        
    }];
}

- (void)approveFriend:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;

    NSString *friendClientId = param[@"friendClientId"];
    BOOL agree = [param[@"agree"] boolValue];
    NSString *rejectRemark;
    for (NSString *key in param.allKeys) {
        if ([key isEqualToString:@"rejectRemark"]) {
            rejectRemark = param[@"rejectRemark"];
        }
    }
    [WeCloudFriendHttpApi approveFriend:agree friendClientId:friendClientId rejectRemark:rejectRemark callback:^(BOOL success, WeCloudException * _Nonnull apiResult) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:success ?nil :apiResult
                           object:@(success)];
    }];
}

- (void)batchDeleteFriend:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSArray *friendClientIds = params[@"friendClientIds"];
    [WeCloudFriendHttpApi batchDeleteFriend:friendClientIds callback:^(BOOL success, WeCloudException * _Nonnull apiResult) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:success ?nil :apiResult
                           object:@(success)];
    }];
}

#pragma mark --- WeCloudIMClientReceiveFriendShipDelegate ---
- (void)friendShipInviteByFriend:(WeCloudFriendModel *)friendModel {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:friendModel.friendClientId forKey:@"friendClientId"];
    if (friendModel.requestRemark) {
        [params setValue:friendModel.requestRemark forKey:@"requestRemark"];
    }else{
        [params setValue:@"" forKey:@"requestRemark"];
    }
    [self.channel invokeMethod:WeCloudMethodKeyOnFriendShipInvite arguments:params];
}

- (void)friendShipVerificationResult:(WeCloudFriendModel *)friendModel {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:friendModel.claimerClientId forKey:@"friendClientId"];
    [params setValue:@(friendModel.agree) forKey:@"agree"];
    if (friendModel.rejectRemark) {
        [params setValue:friendModel.rejectRemark forKey:@"rejectRemark"];
    }else {
        [params setValue:@"" forKey:@"rejectRemark"];
    }
   
    [self.channel invokeMethod:WeCloudMethodKeyOnFriendShipVerificationResult arguments:params];
}

@end
