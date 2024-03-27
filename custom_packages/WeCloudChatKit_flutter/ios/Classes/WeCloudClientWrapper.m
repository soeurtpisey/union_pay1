//
//  WeCloudClientWrapper.m
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/3/23.
//

#import "WeCloudClientWrapper.h"
#import "WeCloudSDKMethod.h"
#import "WeCloudConversationWrapper.h"
#import "WeCloudChatManagerWrapper.h"
#import "WeCloudFriendManagerWrapper.h"
#import "WeCloudSingeRTCWrapper.h"

//#import "WeCloudIMClientHeader.h"
//#import "WeCloudHttpApi.h"
//#import "WeCloudSessionModel.h"
//#import "WCIMMessageCache.h"
//#import "WCIMConversationCache.h"
//#import "WCIMConversationMemberCache.h"
//#import "WeCloudFriendHttpApi.h"
//#import "WCExtension.h"
//#import "WeCloudOffLineMsgHandle.h"
#import <WeCloudIMSDK/WeCloudIMSDK.h>

@interface WeCloudClientWrapper()<WeCloudIMClientTransparentEventDelegate>

@end

@implementation WeCloudClientWrapper

static WeCloudClientWrapper *wrapper = nil;

+ (WeCloudClientWrapper *)sharedWrapper {
    return wrapper;
}

+ (WeCloudClientWrapper *)channelName:(NSString *)aChannelName
                       registrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wrapper = [[WeCloudClientWrapper alloc] initWithChannelName:aChannelName registrar:registrar];
    });
    return wrapper;
}

- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
        [registrar addApplicationDelegate:self];
        [WeCloudIMClient sharedWeCloudIM].transparentEventDelegate = self;
    }
    return self;
}

#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if ([WeCloudMethodKeyInit isEqualToString:call.method])
    {
        [self initialize:call.arguments
                  channelName:call.method
                       result:result];
    } else if ([WeCloudMethodKeyLogin isEqualToString:call.method]){
        [self login:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyIsLogin isEqualToString:call.method]){
        [self isLoginWithChannelName:call.method result:result];
    } else if ([WeCloudMethodKeyOpen isEqualToString:call.method]){
        [self openWithChannelName:call.method result:result];
    } else if ([WeCloudMethodKeyOpenModel isEqualToString:call.method]){
        [self openModelWithParams:call.arguments channelName:call.method result:result];
    }else if ([WeCloudMethodKeyLogout isEqualToString:call.method]){
        [self closeWithChannelName:call.method result:result];
    } else if ([WeCloudMethodKeyKickDevice isEqualToString:call.method]){
        [self updateDeviceInfo:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyCreateConversationFromServer isEqualToString:call.method]){
        [self createConversation:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyDisbandConversationFromServer isEqualToString:call.method]){
        [self disbandConversation:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeySearchConversationListFromServer isEqualToString:call.method]){
        [self searchConversationListWithchannelName:call.method result:result];
    } else if ([WeCloudMethodKeyFindConvMsgByTypeFromDB isEqualToString:call.method]){
        [self findConvMsgByType:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeySearchGroupConversationsFromDB isEqualToString:call.method]){
        [self searchGroupConversationsWithChannelName:call.method result:result];
    } else if ([WeCloudMethodKeyHiddenConversationFromDB isEqualToString:call.method]){
        [self hiddenConversation:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyDeleteConversations isEqualToString:call.method]){
        [self deleteConversations:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyLeaveConversationFromServer isEqualToString:call.method]){
        [self leaveConversation:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeySetupConvAdminsFromServer isEqualToString:call.method]){
        [self setupConvAdmins:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyConvTransferOwnerFromServer isEqualToString:call.method]){
        [self convTransferOwner:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyConvMutedGroupMemberFromServer isEqualToString:call.method]){
        [self convMutedGroupMember:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyWithdrawMsgFromServer isEqualToString:call.method]){
        [self withdrawMsg:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyDeleteMsgAndNetworkFromServer isEqualToString:call.method]){
        [self deleteMsgAndNetwork:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyDeleteAllMsgFromDB isEqualToString:call.method]){
        [self deleteAllMsg:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyDeleteAllMsgByConvIdFromDB isEqualToString:call.method]){
        [self deleteAllMsgByConvId:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyMsgReadUpdateFromServer isEqualToString:call.method]){
        [self msgReadUpdate:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyMsgReadAllConvUpdateFromServer isEqualToString:call.method]){

        [self msgReadAllConvUpdate:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyFindMessageByIdFromDB isEqualToString:call.method]){
        [self findMessage:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyAddBlacklistFromServer isEqualToString:call.method]){
        [self addBlacklist:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyDelBlacklistFromServer isEqualToString:call.method]){
        [self delBlacklist:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyFindBlacklistFromServer isEqualToString:call.method]){
        [self findBlacklist:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyGetClientInfoListFromServer isEqualToString:call.method]){
        [self getClientInfoList:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyJoinChatRoom isEqualToString:call.method]){
        [self joinRoomWithClientId:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyExitChatRoom isEqualToString:call.method]){
        [self leaveRoomWithClientId:call.arguments channelName:call.method result:result];
    }else if ([WeCloudMethodKeyFindChatRoomMembers isEqualToString:call.method]){
        [self searchChatRoomUsers:call.arguments channelName:call.method result:result];
    }else if ([WeCloudMethodKeyFindConversationById isEqualToString:call.method]){
        [self getConversationById:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyDeleteConversationFromDB isEqualToString:call.method]){
        [self deleteConversationFromDB:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyOnDeviceToken isEqualToString:call.method]){
        [self OnDeviceToken:call.arguments channelName:call.method result:result];
    } else if ([WeCloudMethodKeyGetConnectingStatus isEqualToString:call.method]) {
        NSString *socketStatus = [WeCloudIMClient sharedWeCloudIM].socketStatus;
        [self wrapperCallBack:result channelName:call.method error:nil object:socketStatus];
    } else {
        [super handleMethodCall:call result:result];
    }
}

#pragma mark - Actions

- (void)initialize:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    
    [[WeCloudIMClient sharedWeCloudIM] initServiceHttpUrl:param[@"httpUrl"] wsUrl:param[@"wsUrl"]];
    [weakSelf registerManagers];
    // 如果有证书名，说明要使用Apns
//    if (options.apnsCertName.length > 0) {
//        [self _registerAPNs];
//    }
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)
    ];
//    [self.channel invokeMethod:aChannelName arguments:@{@"channelName": aChannelName} result:result];
}
- (void)registerManagers {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"

    WeCloudConversationWrapper *conversationWrapper = [[WeCloudConversationWrapper alloc] initWithChannelName:WeCloudChannelName(@"conversation_manager") registrar:self.flutterPluginRegister];
    WeCloudChatManagerWrapper *chatManagerWrapper = [[WeCloudChatManagerWrapper alloc]initWithChannelName:WeCloudChannelName(@"chat_manager") registrar:self.flutterPluginRegister];
    
    WeCloudFriendManagerWrapper *friendManagerWrapper =[[WeCloudFriendManagerWrapper alloc]initWithChannelName:WeCloudChannelName(@"friend_manager")  registrar:self.flutterPluginRegister];
    
    WeCloudSingeRTCWrapper *rtcWrapper = [[WeCloudSingeRTCWrapper alloc]initWithChannelName:WeCloudChannelName(@"sing_rtc_manager") registrar:self.flutterPluginRegister];
    
#pragma clang diagnostic pop
}
- (void)isLoginWithChannelName:(NSString *)aChannelName result:(FlutterResult)result{
    [self wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@([WeCloudIMClient sharedWeCloudIM].isLogin)];
}
- (void)login:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *timestamp = param[@"timestamp"];
    NSString *clientIdStr = param[@"clientId"];
    NSString *appKey = param[@"appKey"];
    NSString *sign = param[@"sign"];
    
    [[WeCloudIMClient sharedWeCloudIM] login:timestamp clientId:clientIdStr appKey:appKey sign:sign callback:^(BOOL success, NSString * _Nonnull token, NSString * _Nonnull clientId, WeCloudException * _Nonnull apiResult) {
        
        if (apiResult.code == 200) {
            NSMutableDictionary * info = [[NSMutableDictionary alloc]init];
            [info setObject:token forKey:@"token"];
            [info setObject:[NSString stringWithFormat:@"%@",clientId] forKey:@"clientId"];

//            [[WeCloudIMClient sharedWeCloudIM] openWithCallback:^(BOOL isAutoOpen, NSDictionary * _Nonnull resultDic) {}];
            
            [weakSelf wrapperCallBack:result
                          channelName:aChannelName
                                error: success ?nil:apiResult
                               object: info];
           
        }else{
            NSLog(@"登入失败");
        }
        
    }];
    
}

- (void)openWithChannelName:(NSString *)aChannelName result:(FlutterResult)result{
    __weak typeof(self)weakSelf = self;
    [[WeCloudIMClient sharedWeCloudIM] openWithCallback:^(BOOL isAutoOpen, NSDictionary * _Nonnull resultDic) {
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:resultDic];
    }];
}
- (void)openModelWithParams:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result{
    __weak typeof(self)weakSelf = self;
    NSString *token = param[@"token"];
    NSString *clientId = param[@"clientId"];
    NSString *appKey = param[@"appKey"];

    [[WeCloudIMClient sharedWeCloudIM] openModel:token clientId:clientId appKey:appKey callback:^(BOOL success) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:@(success)];
    }];
}
- (void)closeWithChannelName:(NSString *)aChannelName result:(FlutterResult)result{
    __weak typeof(self)weakSelf = self;
//    [[WeCloudIMClient sharedWeCloudIM] closeWithCallback:^(BOOL isClose) {
//
//        [weakSelf wrapperCallBack:result
//                      channelName:aChannelName
//                            error:nil
//                           object:@(isClose)];
//    }];
    
    [WeCloudIMClient.sharedWeCloudIM wcimExitWithCallback:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        [self wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(error?NO:YES)];
    }];
}

- (void)updateDeviceInfo:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSInteger valid = [param[@"valid"] integerValue];
    NSString *deviceToken = param[@"deviceToken"];
    NSString *pushChannel = param[@"pushChannel"];
    
    [[WeCloudIMClient sharedWeCloudIM] updateDeviceInfoValid:valid deviceToken:deviceToken pushChannel:pushChannel callback:^(BOOL success, WeCloudException * _Nonnull apiResult) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:success ?nil :apiResult
                           object:@(success)];
    }];
}
- (void)getCurrentUserWithChannelName:(NSString *)aChannelName result:(FlutterResult)result{
    __weak typeof(self)weakSelf = self;
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:[WeCloudIMClient sharedWeCloudIM].getCurrentClientId];
}
- (void)getReqIdWithChannelName:(NSString *)aChannelName result:(FlutterResult)result{
    __weak typeof(self)weakSelf = self;
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:[WeCloudIMClient sharedWeCloudIM].getSendReqId];
    
}

- (void)getConversationById:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    int chatType = 0;
    if ([param objectForKey:@"chatType"] && ![[param objectForKey:@"chatType"] isKindOfClass:[NSNull class]]) {
        chatType = [param[@"chatType"] intValue];
    }
    long conversationId = [param[@"conversationId"] longValue];
   
    WCIMConversationCache* getConversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WeCloudSessionModel *getSessionModel = [getConversationCache conversationForId:conversationId];
    if (getSessionModel) {
       
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:[self dicFromConversation:getSessionModel]];
        return;
    }
   
    [[WeCloudIMClient sharedWeCloudIM] wcim_get_conversationInfo:conversationId chatType:chatType  completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        WeCloudSessionModel *sessionModel = [WeCloudSessionModel WC_objectWithKeyValues:responseData];
        WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
        [_conversationCache insertConversation:sessionModel];
       
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ? errorBlock:nil
                           object:error ?nil:[self dicFromConversation:sessionModel]];
    }];
    
}

- (void)createConversation:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    
    NSArray *clientIds = param[@"clientIds"];
    NSInteger chatType = [param[@"chatType"] integerValue];
    NSInteger platform = [param[@"platform"] integerValue];
    NSString *attributes;
    NSString *name;
    NSInteger isEncrypt = 0;
    for (NSString *key in param.allKeys) {
        if ([key isEqualToString:@"name"]) {
            name = param[@"name"];
        }else if ([key isEqualToString:@"attributes"]) {
            attributes = param[@"attributes"];
        }  else if ([key isEqualToString:@"isEncrypt"]) {
            isEncrypt = [param[@"isEncrypt"] integerValue];
        }
    }
    
    [[WeCloudIMClient sharedWeCloudIM]
     wcim_post_createConversation:name clientIds:clientIds chatType:chatType platform:platform isEncrypt:isEncrypt attributes:attributes completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        WeCloudSessionModel *sessionModel;
        if (responseData && ![responseData isKindOfClass:[NSNull class]]) {
            sessionModel = responseData;
            sessionModel.chatType = chatType;
            sessionModel.name = name;
            sessionModel.attributes = attributes;
            sessionModel.muted = 1;
            sessionModel.isEncrypt = isEncrypt;
            WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
            [_conversationCache insertConversation:sessionModel];
            if (chatType != WeCloudChatType_ChatRoom) {
                [[WeCloudIMClient sharedWeCloudIM].conversationDelegate onAddConversation:sessionModel];
            }
        }
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ? errorBlock:nil
                           object:error ?nil:[self dicFromConversation:sessionModel]];
    }];
    
    
}

- (void)disbandConversation:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *conversationId = param[@"conversationId"];
    WCIMConversationMemberCache* _conversationMemberCache = [[WCIMConversationMemberCache alloc]initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [[WeCloudIMClient sharedWeCloudIM] wcim_post_disbandConversation:[conversationId integerValue] completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        if (!error) {
            WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
            [_conversationCache removeConversationForId:[conversationId longLongValue]];
            [_conversationMemberCache deleteMembersByConversationId:[conversationId longLongValue]];
            
        }
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
      
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ? errorBlock:nil
                           object:@(error ?NO:YES)];
    }];
    
}

- (void)searchConversationListWithchannelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    
    NSArray *array =  [_conversationCache allConversations];
    NSMutableArray *teAry1 = [[NSMutableArray alloc]init];
    NSMutableArray *temAry = [[NSMutableArray alloc]init];

    for (WeCloudSessionModel *model in array) {
        if (model.chatType == 4) {
            continue;
        }
        
        [temAry addObject:model];
        [teAry1 addObject:[self dicFromConversation:model]];
        [[WeCloudIMClient sharedWeCloudIM].conversationDelegate onUpdateConversation:model];
    }
    
    [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:teAry1];

    NSLog(@"用户token：%@",[NSUserDefaults.standardUserDefaults objectForKey:@"WeCloudIMCSdkToken"]);
    NSLog(@"用户ClientId：%@",[NSUserDefaults.standardUserDefaults objectForKey:@"WeCloudClientId"]);

    [[WeCloudIMClient sharedWeCloudIM] wcim_get_unreadConversationList:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {

        if (error) {

            WeCloudException *errore = [[WeCloudException alloc]init];
            errore.code = responseCode;
            errore.message = error.domain;

            [weakSelf wrapperCallBack:result
                          channelName:aChannelName
                                error:errore
                               object:nil];

            return;

        }

        NSArray * conversationAry = responseData[@"result"];
        NSMutableArray *teAry = [[NSMutableArray alloc]init];
        int totalNoReadMessage = 0;
        for (NSDictionary *dic in conversationAry) {
            WeCloudSessionModel *model = [WeCloudSessionModel WC_objectWithKeyValues:dic];

            if(!model.isDoNotDisturb && model.chatType != WeCloudChatType_ChatRoom){

                totalNoReadMessage +=model.msgNotReadCount;
            }

            WeCloudSessionModel * localSessionModel  = [_conversationCache conversationForId:model.conversationId];
            if (localSessionModel.hide) {
                if (model.lastMsg.createTime) {
                    //有新消息
                    if (localSessionModel.updateTime < model.lastMsg.createTime) {
                        [_conversationCache updateConversationForHide:NO conversationId:model.conversationId];
                    }
                }
            }
            [teAry addObject:model];
        }

        [_conversationCache cacheConversations:teAry newList:^(NSArray *list) {

            for (WeCloudSessionModel *model in list) {
                if (model.chatType == 4) {
                    continue;
                }
                BOOL isAdd = YES;
                for (WeCloudSessionModel *obj in temAry) {
                    if (obj.conversationId == model.conversationId) {
                        isAdd = NO;
                    }
                }
                if(isAdd){
                    [[WeCloudIMClient sharedWeCloudIM].conversationDelegate onAddConversation:model];
                }
                [[WeCloudIMClient sharedWeCloudIM].conversationDelegate onUpdateConversation:model];
            }

        }];

        [[WeCloudIMClient sharedWeCloudIM].conversationDelegate onTotalNotReadCountChangeListener:totalNoReadMessage];
    }];
}

- (void)findConvMsgByType:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    long conversationId = [param[@"conversationId"] longLongValue];
    WeCloudIMMessageMediaType type = [param[@"types"] integerValue];
    WCIMMessageCache* _messageCache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    NSArray *msgAry = [_messageCache messagesWithTypes:@[@(type)] conversationId:conversationId isAscend:NO limit:0 currentMessageId:0];
    NSMutableArray *teAry = [[NSMutableArray alloc]init];
    for (WeCloudMessageModel *model in msgAry) {
        [teAry addObject:[self dicFrommessage:model]];
    }
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:teAry];
    
}

- (void)searchGroupConversationsWithChannelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    NSArray *conAry = [_conversationCache selectAllConversationsWithHidden];
    
    NSMutableArray *teAry = [[NSMutableArray alloc] init];
    for (WeCloudSessionModel *model in conAry) {
        if (model.chatType == WeCloudChatType_NormalGroup || model.chatType == WeCloudChatType_TenThousandGroup){

            [teAry addObject:[self dicFromConversation:model]];
        }
    }
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:teAry];
}

- (void)hiddenConversation:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSArray *conversationIds = param[@"conversationIds"];
    BOOL displayStatus = param[@"displayStatus"];
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    for (NSString *conversationId in conversationIds) {
        [_conversationCache updateConversationForHide:displayStatus conversationId:[conversationId longLongValue]];
    }
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
}

- (void)deleteConversations:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSArray *conversations = param[@"conversationIds"];
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    for (NSString *obj in conversations) {
        [_conversationCache updateConversationForHide:YES conversationId:[obj longLongValue]];
        [_conversationCache removeAllMessageOfConversationForId:[obj longLongValue]];
    }
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
}

- (void)deleteConversationFromDB:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSString *conversationId = param[@"conversationId"];
   
    [[WeCloudIMClient sharedWeCloudIM] deleteConversationFromDB:[conversationId longLongValue] completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:@(true)];
    }];
    
    
   
}



- (void)leaveConversation:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    long conversationId = [param[@"conversationId"] longValue];
//    BOOL transfer = [param[@"transfer"] boolValue];
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WCIMConversationMemberCache* _conversationMemberCache = [[WCIMConversationMemberCache alloc]initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [[WeCloudIMClient sharedWeCloudIM] wcim_post_leaveConversation:conversationId transfer:YES completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        [_conversationCache removeConversationForId:conversationId];
        [_conversationMemberCache deleteMembersByConversationId:conversationId];
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ? errorBlock:nil
                           object:@(error ?NO:YES)];
        
    }];
    
    
}

- (void)setupConvAdmins:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;

    long conversationId = [param[@"conversationId"] longValue];
    NSArray *clientIds = param[@"clientIds"];
    NSInteger operateType = [param[@"operateType"] integerValue];
    WCIMConversationMemberCache* _conversationMemberCache = [[WCIMConversationMemberCache alloc]initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    
    [[WeCloudIMClient sharedWeCloudIM] wcim_set_conversationGroupAdmins:conversationId clientIds:clientIds operateType:operateType completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        if (!error) {
            [_conversationMemberCache updateRoleMembersByConversationId:conversationId clients:clientIds role:operateType];
            
        }
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error ?NO:YES)];
    }];
    
    
}

- (void)convTransferOwner:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    long conversationId = [param[@"conversationId"] longLongValue];
    NSString *clientId = param[@"clientId"];
    WCIMConversationMemberCache* _conversationMemberCache = [[WCIMConversationMemberCache alloc]initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [[WeCloudIMClient sharedWeCloudIM] wcim_post_conversationGroupTransferOwner:conversationId clientId:clientId completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        if (!error) {
            [_conversationMemberCache updateRoleByConversationId:conversationId clientId:clientId role:3];
        }
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ? errorBlock :nil
                           object:@(error ?NO:YES)];
    }];
    
    
}

-(void)convMutedGroupMember:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    long conversationId = [param[@"conversationId"] longLongValue];
    NSArray *clientIds = param[@"clientIds"];
    BOOL mutedType = [param[@"isMuted"] boolValue];
    WCIMConversationMemberCache* _conversationMemberCache = [[WCIMConversationMemberCache alloc]initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [[WeCloudIMClient sharedWeCloudIM] wcim_post_conversationMutedGroup:conversationId mutedType:mutedType clientIds:clientIds completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        if (!error) {
            [_conversationMemberCache updateMutedMembersByConversationId:conversationId clients:clientIds muted:mutedType];
        }
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ? errorBlock :nil
                           object:@(error ?NO:YES)];
        
    }];
    
}

- (void)withdrawMsg:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    WeCloudMessageModel *model = [WeCloudMessageModel WC_objectWithKeyValues:param[@"message"]];
    [[WeCloudIMClient sharedWeCloudIM] wcim_withdrawMessage:[NSString stringWithFormat:@"%lld",model.msgId] conversationId:nil pushData:nil completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
         
         WeCloudException * errorBlock = [[WeCloudException alloc]init];
         errorBlock.error = error;

         [weakSelf wrapperCallBack:result
                       channelName:aChannelName
                             error:error ? errorBlock :nil
                            object:@(error ?NO:YES)];
     }];
     
}

- (void)deleteMsgAndNetwork:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSArray *ary =params[@"messages"];
    NSMutableArray *msgAry = [[NSMutableArray alloc]init];
    NSMutableArray *msgIds = [[NSMutableArray alloc]init];
    for (NSDictionary *obj in ary) {
        WeCloudMessageModel *model =[WeCloudMessageModel WC_objectWithKeyValues:obj];
        [msgAry addObject:model];
        [msgIds addObject:@(model.msgId)];
    }
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WCIMMessageCache* _messageCache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [[WeCloudIMClient sharedWeCloudIM] wcim_deleteMessage:msgIds conversationId:nil completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        if (!error) {
            for (WeCloudMessageModel *msg in msgAry) {
                msg.msgStatus = WeCloudIMMessageMediaTypeMessageDelete;
                [_messageCache deleteMessage:msg];
                [_conversationCache updateConversationForUpdateAt:msg.createTime conversationId:msg.conversationId];
                [[WeCloudIMClient sharedWeCloudIM].delegate didUpdateMessageStatus:WeCloudMessageStatusDelete reqId:nil msgIds:nil messageModel:msg errorCode:200];
                
            }
        }
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ? errorBlock :nil
                           object:@(error ?NO:YES)];
    }];
    
}

- (void)deleteAllMsgByConvId:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    NSInteger conversationId = [param[@"conversationId"] integerValue];
    __weak typeof(self)weakSelf = self;
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [_conversationCache removeAllMessageOfConversationForId:conversationId];
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
}

- (void)deleteAllMsg:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
   
    __weak typeof(self)weakSelf = self;
    NSArray *ary = params[@"messages"];
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WCIMMessageCache* _messageCache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    for (NSDictionary *obj in ary) {
        WeCloudMessageModel *model =[WeCloudMessageModel WC_objectWithKeyValues:obj];
        model.msgStatus = WeCloudIMMessageMediaTypeMessageDelete;
        [_messageCache deleteMessage:model];
        [_conversationCache updateConversationForUpdateAt:model.createTime conversationId:model.conversationId];
    }
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
}

- (void)msgReadUpdate:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    NSArray *msgIds = params[@"messageIds"];
    
    WCIMMessageCache *cache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WeCloudMessageModel * msgModel = [cache messageForId:[msgIds.firstObject longLongValue]];
    
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WeCloudSessionModel *session =  [_conversationCache conversationForId:msgModel.conversationId];
    session.msgNotReadCount = 0;
    [_conversationCache insertConversation:session];
    
    // 因为已读接口有做调整，iOS还没有实现单条已读，所以这里先调用全部已读的接口
    NSDictionary *dic = @{@"conversationId" : @(session.conversationId),
                          @"isMessageRead" : @(YES)};
    NSArray *conversationArray = @[dic];

    [[WeCloudIMClient sharedWeCloudIM] wcim_post_conversationBatchRead:conversationArray completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {

        WeCloudException *errorBlock = [[WeCloudException alloc] init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ? errorBlock : nil
                           object:@(error ? NO : YES)];
    }];
}

- (void)msgReadAllConvUpdate:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    long conversationId = [param[@"conversationId"] longLongValue];
    long msgIdEnd = [param[@"lastMsgId"] longLongValue];
    
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WeCloudSessionModel *session =  [_conversationCache conversationForId:conversationId];
    session.msgNotReadCount = 0;
    [_conversationCache insertConversation:session];
    
    [[WeCloudIMClient sharedWeCloudIM] wcim_readerMessage:[NSString stringWithFormat:@"%ld",msgIdEnd] conversationIds:@[@(conversationId)] completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ? errorBlock :nil
                           object:@(error ?NO:YES)];
    }];
    
}

- (void)findMessage:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
        __weak typeof(self)weakSelf = self;
    long msgId = [param[@"messageId"] longLongValue];
    WCIMMessageCache* _messageCache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WeCloudMessageModel *msgModel = [_messageCache messageForId:msgId];
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:[self dicFrommessage:msgModel]];
    
}

- (void)addBlacklist:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    
    NSString *clientId = param[@"userClientId"];
    
    [[WeCloudIMClient sharedWeCloudIM] wcimClientIdBePrevent:clientId completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ?errorBlock:nil
                           object:@(error ?NO:YES)];
    }];
    
}

- (void)delBlacklist:(NSDictionary *)param channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    
    NSString *clientId = param[@"userClientId"];
    
    [[WeCloudIMClient sharedWeCloudIM] wcimDeleteClientIdBePrevent:clientId completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ?errorBlock:nil
                           object:@(error ?NO:YES)];
    }];
    
}

- (void)findBlacklist:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    
    NSInteger pageIndex = 1;
    NSInteger pageSize = 10;
    for (NSString *key in params.allKeys) {
        if ([key isEqualToString:@"pageIndex"]) {
            pageIndex = [params[@"pageIndex"] integerValue];
        } else if ([key isEqualToString:@"pageSize"]) {
            pageSize = [params[@"pageSize"] integerValue];
        }
    }
    
    [WeCloudFriendHttpApi getClientBlacklist:pageIndex pageSorts:nil pageSize:pageSize keyword:nil callback:^(BOOL success, NSArray * _Nonnull clientIdBePreventAry, WeCloudException * _Nonnull apiResult) {
       
            [weakSelf wrapperCallBack:result
                          channelName:aChannelName
                                error:success ?nil :apiResult
                               object:clientIdBePreventAry];
    }];
    
}

- (void)getClientInfoList:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self)weakSelf = self;
    long conversationId = [params[@"conversationId"] longLongValue];
    NSString *clientIds = params[@"clientIds"];
    
    [[WeCloudIMClient sharedWeCloudIM] wcimConversation:conversationId clientId:clientIds cache:YES callback:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error ?errorBlock :nil
                           object:error ?nil:responseData];
    }];
    
}


- (void)joinRoomWithClientId:(NSDictionary *)params
                   channelName:(NSString *)aChannelName
                        result:(FlutterResult)result {
    
    NSString *channelId = params[@"clientId"];
    NSInteger chatRoomId = [params[@"chatRoomId"] integerValue];
    NSInteger platform = [params[@"platform"] integerValue];
    __weak typeof(self) weakSelf = self;
    [[WeCloudIMClient sharedWeCloudIM] wcimJoinRoomWithClientId:channelId chatRoomId:chatRoomId platform:platform completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
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


- (void)leaveRoomWithClientId:(NSDictionary *)params
                   channelName:(NSString *)aChannelName
                        result:(FlutterResult)result {
    NSString *channelId = params[@"clientId"];
    NSInteger chatRoomId = [params[@"chatRoomId"] integerValue];
    NSInteger platform = [params[@"platform"] integerValue];
    __weak typeof(self) weakSelf = self;
    [[WeCloudIMClient sharedWeCloudIM] wcimLeaveRoomWithClientId:channelId chatRoomId:chatRoomId platform:platform completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
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


- (void)searchChatRoomUsers:(NSDictionary *)params
                   channelName:(NSString *)aChannelName
                        result:(FlutterResult)result {
    NSInteger chatRoomId = [params[@"chatRoomId"] integerValue];
    NSInteger platform = [params[@"platform"] integerValue];
    __weak typeof(self) weakSelf = self;
    [[WeCloudIMClient sharedWeCloudIM] wcimSearchChatRoomUsers:chatRoomId platform:platform completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:error?nil:responseData];
        
    }];
}

- (void)OnDeviceToken:(NSDictionary *)params
          channelName:(NSString *)aChannelName
               result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString * deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeCloudDeviceToken"];
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@{@"deviceToken":deviceToken}];
}

- (NSDictionary *)dicFromConversation:(WeCloudSessionModel *)conversationModel{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:conversationModel.WC_keyValues];
    
    if ([dic objectForKey:@"lastMsg"] && ![[dic objectForKey:@"lastMsg"] isKindOfClass: NSNull.class]) {
        NSMutableDictionary * lastMsg = [[NSMutableDictionary alloc]initWithDictionary:[dic objectForKey:@"lastMsg"]];
        [lastMsg setValue:lastMsg[@"systemFlag"] forKey:@"system"];
        [lastMsg removeObjectForKey:@"systemFlag"];
        
//        [lastMsg setValue:lastMsg[@"operatorId"] forKey:@"operator"];
//        [lastMsg removeObjectForKey:@"operatorId"];
        
        [dic setValue:lastMsg forKey:@"lastMsg"];
        
        
        
    }
    
    if (conversationModel.attributes) {
        [dic setValue:conversationModel.attributes.WC_JSONString forKey:@"attributes"];
    }
    if (conversationModel.isEncrypt) {
        [dic setValue:@(conversationModel.isEncrypt) forKey:@"isEncrypt"];
    }else{
        [dic setValue:@(0) forKey:@"isEncrypt"];
    }
   

    [dic setValue:@(conversationModel.isTop) forKey:@"isTop"];
    [dic setValue:@(conversationModel.isDoNotDisturb) forKey:@"isDoNotDisturb"];
    return dic;
}

- (NSString *)getNowTimestamp {
    NSDate *datenow = [NSDate date];
    return [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil || [jsonString isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(NSDictionary *)dicFrommessage:(WeCloudMessageModel *)messageModel{
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:messageModel.WC_keyValues];
    [dic setValue:dic[@"systemFlag"] forKey:@"system"];
    [dic removeObjectForKey:@"systemFlag"];
    
    return dic;
    
}

#pragma mark ----------- WeCloudIMClientTransparentEventDelegate ---------
- (void)onTransparentMessageEvent:(WeCloudTransparentEventModel *)transparentEventModel{
    [self.channel invokeMethod:WeCloudMethodKeyOnTransparentMessageEvent arguments:transparentEventModel.WC_keyValues];
}

- (void)imClientStatusChange:(WeCloudIMClientStatus)status {
    NSString *socketStatus = [WeCloudIMClient sharedWeCloudIM].socketStatus;
    NSLog(@"当前连接状态：%@", socketStatus);
    [self.channel invokeMethod:WeCloudMethodKeyOnSDKConnectEvent arguments:socketStatus];
}

@end
