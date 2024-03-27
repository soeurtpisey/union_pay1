//
//  WeCloudChatManagerWrapper.m
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/3/24.
//

#import "WeCloudChatManagerWrapper.h"
#import "WeCloudSDKMethod.h"

//#import "WeCloudHttpApi.h"
//#import "WeCloudIMClient.h"
//#import "WeCloudSessionModel.h"
//#import "WCIMConversationCache.h"
//#import "WCIMMessageCache.h"
//#import "WeCloudIMClientHeader.h"
//#import "WCExtension.h"
//#import "NSDate+AL.h"
//#import "WeCloudMediaUpLoad.h"
//#import "WCIMAllDownloadCache.h"
//#import "WeCloudIMClient+EndToEndEncryptMessage.h"
#import <WeCloudIMSDK/WeCloudIMSDK.h>


@interface WeCloudChatManagerWrapper ()<WeCloudIMClientReceiveMessageDelegate,WeCloudIMClientDelegate>

@end

@implementation WeCloudChatManagerWrapper


- (instancetype)initWithChannelName:(NSString *)aChannelName
                          registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if(self = [super initWithChannelName:aChannelName
                               registrar:registrar]) {
        [registrar addApplicationDelegate:self];
        [WeCloudIMClient sharedWeCloudIM].delegate = self;
        [WeCloudIMClient sharedWeCloudIM].imClientdelegate = self;
    }
    return self;
}

#pragma mark - FlutterPlugin

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if ([WeCloudMethodKeySendMessage isEqualToString:call.method]) {
        [self sendMessage:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeySaveOrUpdateMessage isEqualToString:call.method]){
        [self saveOrUpdateMessage:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeySyncOfflineMessages isEqualToString:call.method]){
        [self syncOfflineMessages:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyFindHistMsg isEqualToString:call.method]){
        [self findHistMsg:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyFindMessageFromHistory isEqualToString:call.method]){
        [self findMessageFromHistory:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyFindMessageFromHistoryByTime isEqualToString:call.method]){
        [self findMessageFromHistoryByTime:call.arguments channelName:call.method result:result];
    } else if([WeCloudMethodKeyUpdateMessageAttrs isEqualToString:call.method]){
        [self updateMessageAttrs:call.arguments channelName:call.method result:result];
    }  else if([WeCloudMethodKeyInsertMessageDB isEqualToString:call.method]){
        [self insertMessageDB:call.arguments channelName:call.method result:result];
    }
}

- (void)sendMessage:(NSDictionary *)messageDic channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *message = messageDic[@"message"];
    WeCloudMessageModel *messageModel = [WeCloudMessageModel WC_objectWithKeyValues:message];
    
    // UPay应用层还是采用单文件的逻辑，需要转成多文件格式
    if ([message.allKeys containsObject:@"file"]) {
        NSDictionary *fileDic = message[@"file"];
        if (fileDic && ![fileDic isKindOfClass:[NSNull class]]) {
            WeCloudMessageFileContentModel *fileModel = [WeCloudMessageFileContentModel WC_objectWithKeyValues:fileDic];
            messageModel.files = @[fileModel];
        }
    }
    
    WCIMConversationCache* _conversationCache = [[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];

    WeCloudSessionModel *sessionModel = [_conversationCache conversationForId:messageModel.conversationId];
    
    // 配置发送消息的聊天类型
    NSString *actionStr = WeCloudIMClientSendChatActionNormal;
    if (sessionModel.chatType == WeCloudChatType_TenThousandGroup) {
        actionStr = WeCloudIMClientSendChatActionThousand;
    } else if (sessionModel.chatType == WeCloudChatType_ChatRoom) {
        actionStr = WeCloudIMClientSendChatActionChatRoom;
    }
    
    if (messageModel.type == WeCloudIMMessageMediaTypeText || messageModel.type == WeCloudIMMessageMediaTypecustom) {
    
        if (sessionModel.isEncrypt) { // 加密
            [[WeCloudIMClient sharedWeCloudIM] sendEncryptMessage:messageModel action:actionStr pushContent:messageModel.pushContent attrs:messageModel.attrs];
        } else {
            [[WeCloudIMClient sharedWeCloudIM] sendMessage:messageModel action:actionStr pushContent:messageModel.pushContent attrs:messageModel.attrs];
        }
    } else if (messageModel.type == WeCloudIMMessageMediaTypeImage || messageModel.type == WeCloudIMMessageMediaTypeVideo || messageModel.type == WeCloudIMMessageMediaTypeAudio) {
        
        if (sessionModel.isEncrypt) {
            [[WeCloudIMClient sharedWeCloudIM] sendEncryptFileMessage:messageModel action:actionStr pushContent:messageModel.pushContent attrs:messageModel.attrs];
        } else {
            [[WeCloudIMClient sharedWeCloudIM] sendFileMessage:messageModel action:actionStr pushContent:messageModel.pushContent attrs:messageModel.attrs];
        }
    }
    
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
}

- (void)saveOrUpdateMessage:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    long messageId = [params[@"msgId"] longValue];
    NSString *localPath = params[@"localPath"];
    
    __weak typeof(self) weakSelf = self;
    WCIMMessageCache* _messageCache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    
    WeCloudMessageModel *messageModel = [_messageCache messageForId:messageId];
//    messageModel.file.locPath = localPath;
//    [_messageCache insertMessage:messageModel];
    if (messageModel.files.count > 0) {
        WeCloudMessageFileContentModel *fileModel = messageModel.files.firstObject;
        fileModel.locPath = localPath;
        
        // TODO:更新文件表的路径
        
    }
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
}
/// 更新消息自定义属性
- (void)updateMessageAttrs:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    long messageId = [params[@"msgId"] longValue];
    NSDictionary *attrs = params[@"attrs"];
    
    __weak typeof(self) weakSelf = self;
    
    [[WeCloudIMClient sharedWeCloudIM] updateMessageAttrs:messageId attrs:attrs callback:^(BOOL success) {
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:@(success)];
    }];
    
}
/// 同步离线消息（进聊天页面，拉去离线个本地没有的消息的）
- (void)syncOfflineMessages:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    long conversationId = [params[@"conversationId"] longValue];
    __weak typeof(self) weakSelf = self;
    WCIMMessageCache* _messageCache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    
    WeCloudMessageModel *model = [_messageCache latestMessageForConversation:conversationId isSucc:YES];
    NSArray *msgArray = [_messageCache messagesAfterTimestamp:model.createTime conversationId:model.conversationId];
    NSMutableArray *list = [NSMutableArray array];
    for (WeCloudMessageModel *msg in msgArray) {
        [list addObject:[self dicFrommessage:msg]];
    }
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
    
}

//取历史消息
- (void)findHistMsg:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    
    __weak typeof(self) weakSelf = self;
    long conversationId = [params[@"conversationId"] longValue];
    int limit = [params[@"pageSize"] intValue];
    
    dispatch_group_t group = dispatch_group_create();
        
    WeCloudMessageModel *model;
    BOOL isLastMsg = NO;
    if([params objectForKey: @"lastMsg"] && ![[params objectForKey: @"lastMsg"] isKindOfClass:[NSNull class]]){
        NSDictionary *lastMsg = params[@"lastMsg"];
        isLastMsg = YES;
        model  = [WeCloudMessageModel WC_objectWithKeyValues:lastMsg];
    }
    
    __block NSMutableArray * list = @[].mutableCopy;
    dispatch_group_enter(group);
    
    [[WeCloudIMClient sharedWeCloudIM] getMessageListWithConversationId:conversationId currentMessage:model isAscend:NO limit:limit callback:^(NSArray * _Nonnull messageAry) {
        
        // 标记会话为已读（新接口，UPay在这里使用）
        if (!isLastMsg) {
            NSDictionary *dic = @{@"conversationId" : @(conversationId),
                                   @"isMessageRead" : @(YES)};
            [[WeCloudIMClient sharedWeCloudIM] wcim_post_conversationBatchRead:@[dic] completionBlock:^(NSString * _Nonnull reqId, id  _Nullable responseData, NSError * _Nullable error, NSInteger responseCode) {

            }];
        }

        NSMutableArray * listOrder = [[NSMutableArray alloc]initWithArray:messageAry];
        //排序
        [listOrder sortUsingComparator:^NSComparisonResult(WeCloudMessageModel *obj1, WeCloudMessageModel *obj2) {
            return obj1.createTime > obj2.createTime;
        }];
        
        for (WeCloudMessageModel *msg in listOrder) {
            NSMutableDictionary *muDic = [[NSMutableDictionary alloc]initWithDictionary:[self dicFrommessage:msg]];
            //有等待更新的数据
            if (WeCloudIMClient.sharedWeCloudIM.pushMegData.count>0 && [WeCloudIMClient.sharedWeCloudIM.pushMegData objectForKey:[NSString stringWithFormat:@"%lld",msg.msgId]]) {
                
                WeCloudMessageModel *newMsg = [WeCloudIMClient.sharedWeCloudIM.pushMegData objectForKey:[NSString stringWithFormat:@"%lld",msg.msgId]];
                if (newMsg.files.count > 0) {
                    dispatch_group_enter(group);
                    
                    WeCloudMessageFileContentModel *fileModel = newMsg.files.firstObject;
                    [WeCloudMediaUpLoad downloadFileWithPath:fileModel.url downObj:fileModel message:newMsg SuccBlock:^(NSString * _Nonnull url) {
                        
                        fileModel.locPath = url;

                        WeCloudMessageModel *messageModel = [[WeCloudIMClient sharedWeCloudIM] aesEncryptLocalMessage:newMsg];

                        [list addObject:[[NSMutableDictionary alloc]initWithDictionary:[self dicFrommessage:messageModel]]];
                        
                        NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithDictionary:WeCloudIMClient.sharedWeCloudIM.pushMegData.copy];
                        [data removeObjectForKey:[NSString stringWithFormat:@"%lld",msg.msgId]];
                        WeCloudIMClient.sharedWeCloudIM.pushMegData = data.copy;
                        
                        WCIMMessageCache *cache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
                        
                        if (![cache containMessageToReal:messageModel]) {
                            [cache insertMessageWithConversation:messageModel];
                        } else {
                            [cache updateMessage:messageModel];
                        }
                        
                        dispatch_group_leave(group);
                    } FailBlock:^(NSInteger code, NSString * _Nullable desc) {
                        NSLog(@"同步会话的最后一条媒体信息失败");
                        dispatch_group_leave(group);
                    }];
                }
            }else{
                [list addObject:muDic];
            }
        }
                
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSArray *resultAry = [list reverseObjectEnumerator].allObjects;
        [weakSelf wrapperCallBack:result
                      channelName:aChannelName
                            error:nil
                           object:resultAry];
    });
    
}

- (void)findMessageFromHistory:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    long conversationId = [params[@"conversationId"] longValue];
    WCIMMessageCache* _messageCache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    
    WeCloudMessageModel *messageModel = [_messageCache earliestMessageForConversation:conversationId];
    NSArray *msgArray = [_messageCache messagesAfterTimestamp:messageModel.createTime conversationId:conversationId];
    NSMutableArray *list = [NSMutableArray array];
    for (WeCloudMessageModel *msg in msgArray) {
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc]initWithDictionary:[self dicFrommessage:msg]];
        if (msg.type == WeCloudIMMessageMediaTypeText) {
            [muDic removeObjectForKey:@"file"];
        }
        [list addObject:muDic];
    }
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:list];
}

- (void)findMessageFromHistoryByTime:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    
    long conversationId = [params[@"conversationId"] longValue];
    
    WCIMMessageCache* _messageCache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    
    NSArray *msgArray = [_messageCache messagesAfterTimestamp:[params[@"endTime"] doubleValue] conversationId:conversationId];
    
    WCIMConversationCache* conCache =[[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WeCloudSessionModel *conversationModel = [conCache conversationForId:conversationId];
    
    
    /// 对加密会话的本地数据进行解密
    NSMutableArray *de_Ary = [[NSMutableArray alloc]init];
    if (conversationModel.isEncrypt == 1) {
        for (WeCloudMessageModel * obj in msgArray) {
            __block WeCloudMessageModel *new_obj = obj;
            if (!obj.withdraw && !obj.event && obj.deleted != 2 ) {
                new_obj = [[WeCloudIMClient sharedWeCloudIM] aesDecryptLocalMessage:obj];
            }

            if (new_obj.files.count > 0) {
                WeCloudMessageFileContentModel *fileModel = new_obj.files.firstObject;
                WCIMAllDownloadCache *_downloadCache = [WCIMAllDownloadCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM]getCurrentClientId]];
                NSString *path = [_downloadCache allDownloadFilePathWithName:new_obj];
                fileModel.locPath = [path stringByAppendingPathComponent:fileModel.name];
            }
            
            [de_Ary addObject:new_obj];
        }
        if (de_Ary.count >0) msgArray = de_Ary;
    }
    
    NSMutableArray *list = [NSMutableArray array];
    for (WeCloudMessageModel *msg in msgArray) {
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc]initWithDictionary:msg.WC_keyValues];
        if (msg.type == WeCloudIMMessageMediaTypeText) {
            [muDic removeObjectForKey:@"file"];
        }
        
        [muDic setValue:muDic[@"systemFlag"] forKey:@"system"];
//        [muDic setValue:muDic[@"operatorId"] forKey:@"operator"];
        [muDic removeObjectForKey:@"systemFlag"];
        
        [list addObject:muDic];
    }
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:[[list reverseObjectEnumerator] allObjects]] ;
    
}
- (void)insertMessageDB:(NSDictionary *)params channelName:(NSString *)aChannelName result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    
    NSDictionary * dic = params[@"message"];
    
    WeCloudMessageModel *newMessageModel = [WeCloudMessageModel WC_objectWithKeyValues:dic];
//    newMessageModel.operatorId = [dic objectForKey:@"operator"];
    WCIMMessageCache* _messageCache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WeCloudMessageModel *dbMsgModel =  [_messageCache messageForId:newMessageModel.msgId];
    newMessageModel.createTime = dbMsgModel.createTime;
    newMessageModel.preMessageId = dbMsgModel.preMessageId;
//    newMessageModel.file.fileKey = dbMsgModel.file.fileKey;
    WCIMConversationCache* conCache =[[WCIMConversationCache alloc] initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    WeCloudSessionModel *conversationModel = [conCache conversationForId:newMessageModel.conversationId];
    
    if (conversationModel.isEncrypt == 1 && conversationModel.isEncrypt) {
        WeCloudMessageModel *messageModel = [[WeCloudIMClient sharedWeCloudIM] aesEncryptLocalMessage:newMessageModel];
        [_messageCache insertMessage:messageModel];
    }else{
        [_messageCache insertMessage:newMessageModel];
    }
    
    
    
    [weakSelf wrapperCallBack:result
                  channelName:aChannelName
                        error:nil
                       object:@(true)];
}


#pragma mark --WeCloudIMClientDelegate ---
- (void)onConversationSyncComplete{
    [self.channel invokeMethod:WeCloudMethodKeySyncConversationListener
                     arguments:nil];
}

#pragma mark --WeCloudIMClientReceiveMessageDelegate ---
- (void)onReceived:(WeCloudMessageModel *)message {
    
    [self.channel invokeMethod:WeCloudMethodKeyOnMessagesReceived
                     arguments:[self dicFrommessage:message]];
}

- (void)didUpdateMessageStatus:(WeCloudMessageStatus)sendStatus reqId:(NSString * __nullable)reqId msgIds:(NSArray * __nullable)msgIds messageModel:(WeCloudMessageModel *  __nullable)messageModel errorCode:(NSInteger)errorCode {
    
    NSLog(@"消息正在回传");
    
    WeCloudMessageModel *model = [[WeCloudMessageModel alloc]init];
    WCIMMessageCache *cache = [WCIMMessageCache cacheWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
    if (messageModel) {
        model = messageModel;
    }else{
        if(msgIds){
            WeCloudMessageModel *teMessageModel = [cache messageForId:[msgIds[0] longValue]];
            
            model = teMessageModel;
            
        }
    }
    model.msgStatus = sendStatus;
    if (msgIds) {
        model.msgId = [msgIds[0] longValue];
    }
    if (reqId) {
        model.reqId =reqId;
    }
    if (sendStatus == WeCloudMessageStatusFailed) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:model.reqId forKey:@"reqId"];
        [params setObject:@(errorCode) forKey:@"errCode"];
        [self.channel invokeMethod:WeCloudMethodKeyOnMessagesSendFail arguments:params];
    } else {
        [self.channel invokeMethod:WeCloudMethodKeyOnMessagesUpdateStatus arguments:[self dicFrommessage:model]];
    }
    
    
    if (sendStatus == WeCloudMessageStatusFailed) {
        [cache updateMessageStatus:model];
    } else{
        [cache updateMessage:model];
    }
    
    if(sendStatus == WeCloudMessageStatusWithdraw){
        WCIMConversationCache *conCache = [[WCIMConversationCache alloc]initWithClientId:[[WeCloudIMClient sharedWeCloudIM] getCurrentClientId]];
        WeCloudSessionModel *sessionModel = [conCache conversationForId:model.conversationId];
        if (sessionModel.lastMsg.msgId == model.msgId) [[WeCloudIMClient sharedWeCloudIM].conversationDelegate onUpdateConversation:sessionModel];
    }
    
    
}
////消息发送前的预处理
//- (void)onSendMsgBefore:(WeCloudMessageModel *)message conversation:(WeCloudSessionModel *)conversation callback:(nonnull msgBlock)callback
//{
//
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setObject:message.mj_keyValues forKey:@"message"];
//    [dic setObject:conversation.mj_keyValues forKey:@"conversation"];
//    [self.channel invokeMethod:WeCloudMethodKeyOnDefaultMsgBeforeSendHandler
//                     arguments:dic result:^(id  _Nullable result) {
//        WeCloudMessageModel *model = [WeCloudMessageModel mj_objectWithKeyValues:result[@"message"]];
//        callback(model);
//    }];
//}
////消息接收前的预处理  请注意，只有加密会话会走这边的代理，且走了这边代理后讲不再走onReceived:代理方法，
//- (void)onReceivedMsgBefore:(WeCloudMessageModel *)message conversation:(WeCloudSessionModel *)conversation callback:(nonnull msgBlock)callback{
//
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setObject:message.mj_keyValues forKey:@"message"];
//    [dic setObject:conversation.mj_keyValues forKey:@"conversation"];
//    [self.channel invokeMethod:WeCloudMethodKeyOnDefaultMsgBeforeReceiveHandler
//                     arguments:dic result:^(id  _Nullable result) {
//        WeCloudMessageModel *model = [WeCloudMessageModel mj_objectWithKeyValues:result[@"message"]];
//        callback(model);
//    }];
//}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
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
//    [dic setValue:dic[@"operatorId"] forKey:@"operator"];
    [dic removeObjectForKey:@"systemFlag"];
    
    // UPay应用层还是采用单文件的逻辑，SDK采用的是多文件，需要转成单文件供应用层使用
    WeCloudMessageFileContentModel *fileModel;
    NSMutableDictionary *fileDic;
    if (messageModel.files.count > 0) {
        fileModel = messageModel.files.firstObject;
        fileDic = [fileModel WC_keyValues];
    } else {
        fileModel = [[WeCloudMessageFileContentModel alloc] init];
        fileModel.url = @"";
        fileModel.name = @"";
        fileDic = [fileModel WC_keyValues];
    }
    
    if (fileModel.fileInfo.length == 0) {
        [fileDic setValue:[NSNull null] forKey:@"fileInfo"];
    }
     
    [dic setValue:fileDic forKey:@"file"];
    
    return dic;
    
}

@end
