//
//  WeCloudIMClient.h
//  ChatSDK
//
//  Created by mac on 2022/1/6.
//  Copyright © 2022 wecloud .Icn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudStatusDefine.h"
#import "WeCloudIMClientProtocol.h"
#import "WeCloudException.h"
#import "WeCloudWebSocket.h"
#import "WeCloudIMClientAPI.h"


/// 普通聊天
static NSString * _Nonnull const WeCloudIMClientSendChatActionNormal = @"/chat/normal/send";
/// 万人群
static NSString * _Nonnull const WeCloudIMClientSendChatActionThousand  = @"/chat/thousand/send";
/// 聊天室
static NSString * _Nonnull const WeCloudIMClientSendChatActionChatRoom  = @"/chat/chatroom/send";

/*!
 @const 收到消息的Notification
 
 @discussion 接收到消息后，SDK会分发此通知。
 
 Notification的object为WeCloudMessageModel消息对象。
 
 与WeCloudIMClientReceiveMessageDelegate的区别:
 WeCloudKitDispatchMessageNotification只要注册都可以收到通知；WeCloudIMClientReceiveMessageDelegate需要设置监听，并同时只能存在一个监听。
 */
FOUNDATION_EXPORT NSString * _Nullable const WeCloudKitDispatchMessageNotification;

/*
 @const 收到消息的Notification
 
 @discussion 接收到消息后，SDK会分发此通知。
 
 Notification的object为WeCloudFriendModel消息对象。
 */
FOUNDATION_EXPORT NSString * _Nullable const WeCloudKitDispatchFriendNotification;


NS_ASSUME_NONNULL_BEGIN

typedef void(^WCIMRequestCompletionBlock)(NSString *reqId, _Nullable id responseData, NSError * _Nullable error, WeCloudExceptionResult responseCode);

@class WeCloudSocket;
@interface WeCloudIMClient : NSObject

@property (nonatomic, weak) id<WeCloudIMClientReceiveMessageDelegate> delegate;

@property (nonatomic, weak) id<WeCloudIMClientDelegate> imClientdelegate;

@property (nonatomic, weak) id<WeCloudIMClientConversationDelegate> conversationDelegate;

@property (nonatomic, weak) id<WeCloudIMClientReceiveFriendShipDelegate> friendShipDelegate;

@property (nonatomic, weak) id<WeCloudIMClientRTCEventDelegate> rtcEventDelegate;

@property (nonatomic, weak) id<WeCloudIMClientTransparentEventDelegate> transparentEventDelegate;

//TRTC 消息监听代理
@property (nonatomic, weak) id<WeCloudIMClientTRTCDelegate> delegate_trtc;
//视图监听代理
@property (nonatomic, weak) id<WeCloudIMTRTCCallDelegate> delegate_call;

@property (nullable, nonatomic, strong) WeCloudSocket *webSocket;
@property (nonatomic, strong) NSDictionary *pushMegData;//等待推送的数据
@property (nonatomic, strong) NSMutableDictionary *downData;//正在下载的数据
@property (nonatomic, strong) NSMutableDictionary *requestDataDict;

/// 第一次安装  获取到的服务器时间
@property(nonatomic, copy) NSString *firstServerTime;

/// 网络变化  是否有网络
@property (nonatomic,copy) void (^netWorkStatusChangeBlock)(BOOL hasNet);

///当前是否有网络
- (BOOL)isHaveNet;


+ (dispatch_queue_t)requestQueue;

/*!
 获取通讯能力库IM的核心类单例
 
 @return 通讯能力库IM的核心类单例
 
 @discussion 您可以通过此方法，获取IM的单例，访问对象中的属性和方法.
 */
+ (instancetype)sharedWeCloudIM;


/// 初始化im的后台服务
/// @param httpUrl httpUrl
/// @param wsUrl websocketUrl
- (void)initServiceHttpUrl:(NSString *)httpUrl wsUrl:(NSString *)wsUrl;


/// 判断IM模块是否登录
- (BOOL)isLogin;
/// 开启模块
/// resultDic中返回token 和 clientId;
- (void)openWithCallback:(void (^)(BOOL isAutoOpen,NSDictionary * resultDic))completeBlock;
/// 开启模块
/// @param token token
/// @param clientId 用户id
/// @param appKey appkey
- (void)openModel:(NSString *)token clientId:(NSString *)clientId appKey:(NSString *)appKey callback:(void (^)(BOOL success))completeBlock;

/// 登录模块
/// @param timestamp 时间戳
/// @param clientId clientId
/// @param appKey appkey
/// @param sign sign的时间戳
/// @param completeBlock 结果回调
- (void)login:(NSString *)timestamp clientId:(NSString *)clientId appKey:(NSString *)appKey sign:(NSString *)sign callback:(void (^)(BOOL success, NSString *token, NSString *clientId,WeCloudException *apiResult))completeBlock;

/// 关闭模块
/// @param completeBlock 结果回调
- (void)closeWithCallback:(void (^)(BOOL isClose))completeBlock;

/// 添加或修改推送设备信息(每次请求都会覆盖之前的数据)
/// @param valid 设备不想收到推送提醒, 1想, 0不想
/// @param deviceToken 设备推送token
/// @param completeBlock 结果回调
- (void)updateDeviceInfoValid:(NSInteger)valid deviceToken:(NSString *)deviceToken pushChannel:(NSString *)pushChannel callback:(void (^)(BOOL success,WeCloudException * _Nonnull apiResult))completeBlock;

/// 设置会话的最后一条消息
/// @param conversationId 会话ID
/// @param model 消息模型
- (void)getConversationInfoAfterBeInvited:(long long)conversationId
                                  message:(WeCloudMessageModel* _Nonnull)model
                          completionBlock:(WCIMRequestCompletionBlock)completionBlock;

// socket发送数据（基类方法，分类公用）
// @param action 接口地址
// @param param  参数
// @param completionBlock 回调
-(BOOL)sendDataWithSocket:(NSString *)action
                    param:(NSDictionary * __nullable)param
          completionBlock:(nullable WCIMRequestCompletionBlock)completionBlock;


/// 更新消息自定义属性
-(void)updateMessageAttrs:(long)msgId attrs:(NSDictionary *)attrs callback:(void (^)(BOOL success))completeBlock;

/*!
 与服务器建立连接
 
 @param token        从您服务器端获取的token(用户身份令牌)
 */
- (void)connectWithToken:(NSString *)token;

/*!
 当应用处于前台时，若断掉的即刻进行连接。
 */
- (void)appDesk:(id)obj;


/// 关闭连接
- (void)webSocketClose;

/// The current status of this client, see `WeCloudIMClientStatus`.
//@property (nonatomic, readonly) WeCloudIMClientStatus status;

/// 获取发送消息体的请求id
- (NSString *)getSendReqId;

/// 获取当前用户的clientid
- (NSString *)getCurrentClientId;

#pragma mark ------ 消息操作-------

/// 消息修改为已接收状态
/// @param msgId 消息id
- (void)msgReceivedUpdateWithMsgId:(NSString *)msgId;

/// 消息修改为已读状态
/// @param msgIds 消息id组
- (void)msgReadUpdateWithMsgIds:(NSArray *)msgIds;



/// 获取某个会话中指定数量的消息列表(新)
- (void)getLatestMessageListWithConversationId:(long long)conversationId
                                    msgIdStart:(long long)msgIdStart
                                      msgIdEnd:(long long)msgIdEnd
                                         count:(NSInteger)count
                                      isAscend:(BOOL)isAscend
                                      callback:(void (^)(NSArray *messageAry))completeBlock;

- (void)getRemoteMessagesForConversationId:(long long)conversationId
                              endMessageId:(long long)endMessageId
                                     limit:(int)limit
                                  callback:(void (^)(NSArray *messageAry))completeBlock;

- (NSString *)getSingleOtherClientId:(NSString *)members;


//-(void)downloadFliesWithEncrypt:(NSMutableArray *)msgList isEncrypt:(BOOL)isEncrpt callBack:(void (^)(NSArray *messageAry))callBack;

#pragma mark - json转换相关（后续要写到分类去不要写在单例里面，以后避免这种写法）
/// NSDictionary转json
- (NSString *)gs_jsonStringCompactFormatForDictionary:(NSDictionary *)dicJson;

// json转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

#pragma mark - Public
- (WeCloudIMClientStatus)status;

/// 发送消息
- (void)sendMessage:(WeCloudRTMWebSocketMessage *)message;

/// 获取长连接状态：Opened, Closed, ERROR
- (NSString *)socketStatus;

/// 根据结果返回错误信息对象
-(NSError *)getErrorInformation:(WeCloudException *)apiResult;

/// 是否需要增加未读数
- (BOOL)isNeedToAddMessageNotReadCount:(WeCloudMessageModel *)msgModel;

@end

NS_ASSUME_NONNULL_END
