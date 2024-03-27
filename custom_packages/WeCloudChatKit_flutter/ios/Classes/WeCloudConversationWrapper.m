//
//  WeCloudConversationWrapper.m
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/3/23.
//

#import "WeCloudConversationWrapper.h"
#import "WeCloudSDKMethod.h"

//#import "WeCloudMessageModel.h"
//#import "WeCloudSessionModel.h"
//#import "WeCloudIMClientHeader.h"
//#import "WCIMMessageCache.h"
//#import "WCIMConversationCache.h"
//#import "WCIMConversationMemberCache.h"
//#import "WeCloudHttpApi.h"
//#import "WCExtension.h"
#import <WeCloudIMSDK/WeCloudIMSDK.h>

@interface WeCloudConversationWrapper ()<WeCloudIMClientConversationDelegate>


@end

@implementation WeCloudConversationWrapper

static WeCloudConversationWrapper *wrapper = nil;

- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
        [registrar addApplicationDelegate:self];
        [WeCloudIMClient sharedWeCloudIM].conversationDelegate = self;
        
    }
    return self;
}

#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if([WeCloudMethodKeyAddMemberFromServer isEqualToString:call.method]){
        [self addMemberFromServer:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyDelMemberFromServer isEqualToString:call.method]){
        [self delMemberFromServer:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeySearchConvMembersFromServer isEqualToString:call.method]){
        [self searchConvMembersFromServer:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyUpdateConversationNameFromServer isEqualToString:call.method]){
        [self updateConversationNameFromServer:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyUpdateConvMemberRemarkFromServer isEqualToString:call.method]){
        [self updateConvMemberRemarkFromServer:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeySetGroupMutedFromServer isEqualToString:call.method]){
        [self setGroupMutedFromServer:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeySaveDraft isEqualToString:call.method]){
        [self saveDraft:call.arguments channelName:call.method result:result];
    }else if([WeCloudMethodKeySetDisband isEqualToString:call.method]){
        [self setDisband:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyUpdateNameFromLocal isEqualToString:call.method]){
        [self updateNameFromLocal:call.arguments channelName:call.method result:result];
    }else if([WeCloudMethodKeyUpdateHeadPortraitFromLocal isEqualToString:call.method]){
        [self updateHeadPortraitFromLocal:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyUpdateConversationAttr isEqualToString:call.method]){
        [self updateConversationAttr:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyOnUpdateConversationFromDB isEqualToString:call.method]){
        [self onUpdateConversationFromDB:call.arguments channelName:call.method result:result];
    } else {
        [super handleMethodCall:call result:result];
    }
}

#pragma mark ---- actions

- (void)addMemberFromServer:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    long conversationId = [params[@"conversationId"] longValue];
    NSArray *clientIds =params[@"addMembers"];
    __weak typeof(self) weakSelf = self;
    
    [[WeCloudIMClient sharedWeCloudIM] wcim_add_conversationClient:conversationId clientIds:clientIds completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        [[WeCloudIMClient sharedWeCloudIM] getGroupMembers:conversationId clientIds:nil roles:nil muted:nil Callback:^(BOOL success, NSArray * _Nonnull members, NSError * _Nullable error, NSInteger responseCode) {
            WeCloudException * errorBlock = [[WeCloudException alloc]init];
            errorBlock.error = error;
            errorBlock.code = responseCode;
            errorBlock.message = error.domain;
            
            [weakSelf wrapperCallBack:result
                          channelName:aChannelName
                                error:error ? errorBlock:nil
                               object:@(error ? 0:1)];
        }];
    }];
    
}
- (void)delMemberFromServer:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    long conversationId = [params[@"conversationId"] longValue];
    NSArray *clientIds =params[@"delMembers"];
    __weak typeof(self) weakSelf = self;
    
    [[WeCloudIMClient sharedWeCloudIM] wcim_delete_conversationClient:conversationId clientIds:clientIds completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error ? 0:1)];
    }];
}

- (void)searchConvMembersFromServer:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    long conversationId = [params[@"conversationId"] longValue];
    NSArray *roles;
    NSArray *clientIds;
    NSString *muted ;
    for (NSString * key in params.allKeys) {
        if ([key isEqualToString:@"roles"]) {
            roles = params[@"roles"];
        }else if ([key isEqualToString:@"clientIds"]){
            clientIds = params[@"clientIds"];
        }else if ([key isEqualToString:@"muted"]) {
            muted = params[@"muted"];
        }
    }
    
    [[WeCloudIMClient sharedWeCloudIM] wcim_get_conversationMembers:conversationId clientIds:clientIds roles:roles muted:muted completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        NSArray *members;
        if ([responseData isKindOfClass:[NSArray class]]) {
            members = responseData;
        } else {
            members = responseData[@"result"];
        }

        if (members.count > 0) {
            NSMutableArray *list = [NSMutableArray array];
            for (WeCloudMemberModel *member in members) {
                [list addObject:member.WC_keyValues];
            }
            
            WeCloudException * errorBlock = [[WeCloudException alloc]init];
            errorBlock.error = error;
            
            [weakSelf wrapperCallBack:result
                          channelName:aChannelName
                                error:error?errorBlock:nil
                               object:list];
        }
    }];
}

- (void)updateConversationNameFromServer:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    long conversationId = [params[@"conversationId"] longValue];
    NSString *name = params[@"groupName"];
    
    [[WeCloudIMClient sharedWeCloudIM] wcim_update_conversationName:conversationId name:name completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error ? 0:1)];
    }];
}

- (void)updateConversationAttr:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    long conversationId = [params[@"conversationId"] longValue];
    NSDictionary *obj =params[@"attributes"];
    NSString *attributes = obj.WC_JSONString;
    
    [[WeCloudIMClient sharedWeCloudIM] wcim_post_upateConversation:conversationId attributes:attributes completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        if (!error) {
            WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
            
            WeCloudSessionModel * session =  [_conversationCache conversationForId:conversationId];
            session.attributes = attributes;
            [_conversationCache updateConversationWithConversation:session];
        }
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error ? 0:1)];
    }];
}

- (void)updateConvMemberRemarkFromServer:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    long conversationId = [params[@"conversationId"] longValue];
    NSString *name = params[@"remarkName"];
    
    [[WeCloudIMClient sharedWeCloudIM] wcim_update_conversationMemberRemark:conversationId remark:name completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error ? 0:1)];
    }];
}

- (void)setGroupMutedFromServer:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    long conversationId = [params[@"conversationId"] longValue];
    NSInteger muted = [params[@"isMuted"] integerValue];
    
    [[WeCloudIMClient sharedWeCloudIM] wcim_post_conversationMutedGroup:conversationId mutedType:muted completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error ? 0:1)];
    }];
}

/// 添加或修改会话名称
- (void)updateConversationName:(NSDictionary *)params
                   channelName:(NSString *)aChannelName
                        result:(FlutterResult)result {
    
    long long conversationId = [params[@"conversationId"] longLongValue];
    NSString *attributes = params[@"attributes"];
    __weak typeof(self) weakSelf = self;
    [[WeCloudIMClient sharedWeCloudIM] wcim_post_upateConversation:conversationId  attributes:attributes completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        
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


- (void)saveDraft:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *conversationId = params[@"conversationId"];
    NSString *draft = params[@"draftJson"];
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [_conversationCache updateConversationForDraft:draft conversationId:[conversationId longLongValue]];
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
}

- (void)setDisband:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    long conversationId = [params[@"conversationId"] longValue];
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WCIMConversationMemberCache* _conversationMemberCache = [[WCIMConversationMemberCache alloc]initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [[WeCloudIMClient sharedWeCloudIM] wcim_post_disbandConversation:conversationId completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {
        WeCloudSessionModel *model = [_conversationCache conversationForId:conversationId];
        model.isDisband = YES;
        [_conversationCache updateConversationForDisbandWithConversation:model];
        [_conversationCache removeConversationForId:conversationId];
        [_conversationMemberCache deleteMembersByConversationId:conversationId];
        
        WeCloudException * errorBlock = [[WeCloudException alloc]init];
        errorBlock.error = error;
        errorBlock.code = responseCode;
        errorBlock.message = error.domain;
        
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:error?errorBlock:nil
                           object:@(error ? 0:1)];
    }];
    
}

-(void)updateNameFromLocal:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *conversationId = params[@"conversationId"];
    NSString *name = params[@"name"];
    WeCloudSessionModel *sessionModel = [[WeCloudSessionModel alloc]init];
    sessionModel.conversationId = [conversationId longLongValue];
    sessionModel.name = name;
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [_conversationCache updateConversationForHeadPortrait:sessionModel];
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
}

-(void)updateHeadPortraitFromLocal:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    NSString *conversationId = params[@"conversationId"];
    NSString *headPortrait = params[@"headPortrait"];
    WeCloudSessionModel *sessionModel = [[WeCloudSessionModel alloc]init];
    sessionModel.conversationId = [conversationId longLongValue];
    sessionModel.headPortrait = headPortrait;
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [_conversationCache updateConversationForHeadPortrait:sessionModel];
    
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
    
}
- (void)onUpdateConversationFromDB:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    NSDictionary *conDic = params[@"conversation"];
    WeCloudSessionModel *sessionModel = [WeCloudSessionModel WC_objectWithKeyValues:conDic];
    sessionModel.isTop = [[conDic valueForKey:@"isTop"] boolValue];
    sessionModel.isDoNotDisturb = [[conDic valueForKey:@"isDoNotDisturb"] boolValue];
    
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    [_conversationCache updateConversationWithConversation:sessionModel];
    
    [self wrapperCallBack:result
              channelName:aChannelName
                    error:nil
                   object:@(true)];
}

#pragma mark ----- WeCloudIMClientConversationDelegate ----
- (void)onConversationEvent:(WeCloudConversationEventModel *)convEvent {
    NSMutableDictionary * data = [[NSMutableDictionary alloc]initWithDictionary:convEvent.WC_keyValues];
    [data setValue:data[@"operatorId"] forKey:@"operator"];
    
    [self.channel invokeMethod:WeCloudMethodKeyOnConversationEvent
                     arguments:data];
}

-(void)onAddConversation:(WeCloudSessionModel *)conversationModel {
    [self.channel invokeMethod:WeCloudMethodKeyOnAddConversation
                     arguments:[self dicFromConversation:conversationModel]];
}

-(void)onUpdateConversation:(WeCloudSessionModel *)conversationModel {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[self dicFromConversation:conversationModel] forKey:@"conversation"];
    [dic setObject:@"refreshConversation" forKey:@"event"];
    if (conversationModel.lastMsg && conversationModel.lastMsg.withdraw) {
        [dic setObject:@"withdrawLastMsg" forKey:@"event"];
        
    }
    
    [self.channel invokeMethod:WeCloudMethodKeyOnUpdateConversation
                     arguments:dic];
}

- (void)onRemoveConversation:(long)conversationId {
    [self.channel invokeMethod:WeCloudMethodKeyOnRemoveConversation
                     arguments:@(conversationId)];
}

- (void)onTotalNotReadCountChangeListener:(int)totalNotReadCount {
    [self.channel invokeMethod:WeCloudMethodKeyOnTotalNotReadCountChangeListener
                     arguments:@(totalNotReadCount)];
}

- (NSDictionary *)dicFromConversation:(WeCloudSessionModel *)conversationModel{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:conversationModel.WC_keyValues];
    
    if ([dic objectForKey:@"lastMsg"] && ![[dic objectForKey:@"lastMsg"] isKindOfClass: NSNull.class]) {
        NSMutableDictionary * lastMsg = [[NSMutableDictionary alloc]initWithDictionary:[dic objectForKey:@"lastMsg"]];
        [lastMsg setValue:lastMsg[@"systemFlag"] forKey:@"system"];
        [lastMsg removeObjectForKey:@"systemFlag"];
//        [lastMsg setValue:lastMsg[@"operatorId"] forKey:@"operator"];
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

@end
