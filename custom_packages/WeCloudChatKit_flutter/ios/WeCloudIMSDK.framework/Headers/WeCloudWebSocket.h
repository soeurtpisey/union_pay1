//
//  WeCloudWebSocket.h
//  ChatSDK
//
//  Created by together on 2021/11/10.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WeCloudRTMWebSocketCloseCode)
{
    WeCloudRTMWebSocketCloseCodeInvalid =                             0,
    WeCloudRTMWebSocketCloseCodeNormaWeCloudlosure =                    1000,
    WeCloudRTMWebSocketCloseCodeGoingAway =                        1001,
    WeCloudRTMWebSocketCloseCodeProtocolError =                    1002,
    WeCloudRTMWebSocketCloseCodeUnsupportedData =                  1003,
    WeCloudRTMWebSocketCloseCodeNoStatusReceived =                 1005,
    WeCloudRTMWebSocketCloseCodeAbnormaWeCloudlosure =                  1006,
    WeCloudRTMWebSocketCloseCodeInvalidFramePayloadData =          1007,
    WeCloudRTMWebSocketCloseCodePolicyViolation =                  1008,
    WeCloudRTMWebSocketCloseCodeMessageTooBig =                    1009,
    WeCloudRTMWebSocketCloseCodeMandatoryExtensionMissing =        1010,
    WeCloudRTMWebSocketCloseCodeInternalServerError =              1011,
    WeCloudRTMWebSocketCloseCodeTLSHandshakeFailure =              1015,
};

typedef NS_ENUM(NSInteger, WeCloudRTMWebSocketMessageType) {
    WeCloudRTMWebSocketMessageTypeData = 0,
    WeCloudRTMWebSocketMessageTypeString = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudRTMWebSocketMessage : NSObject

+ (instancetype)messageWithData:(NSData *)data;
+ (instancetype)messageWithString:(NSString *)string;

- (instancetype)initWithData:(NSData *)data NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithString:(NSString *)string NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) WeCloudRTMWebSocketMessageType type;
@property (nonatomic, nullable, readonly) NSData *data;
@property (nonatomic, nullable, readonly) NSString *string;

@property (retain) NSDictionary *attrInfo;//自定义消息

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@class WeCloudWebSocket;

@protocol WeCloudRTMWebSocketDelegate <NSObject>

- (void)WeCloudRTMWebSocket:(WeCloudWebSocket *)socket didOpenWithProtocol:(NSString * _Nullable)protocol;

- (void)WeCloudRTMWebSocket:(WeCloudWebSocket *)socket didCloseWithError:(NSError *)error;

- (void)WeCloudRTMWebSocket:(WeCloudWebSocket *)socket didReceiveMessage:(WeCloudRTMWebSocketMessage *)message;

- (void)WeCloudRTMWebSocket:(WeCloudWebSocket *)socket didReceivePing:(NSData * _Nullable)data;

- (void)WeCloudRTMWebSocket:(WeCloudWebSocket *)socket didReceivePong:(NSData * _Nullable)data;

@end

@interface WeCloudWebSocket : NSObject
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURL:(NSURL *)url protocols:(NSArray<NSString *> *)protocols;
- (instancetype)initWithRequest:(NSURLRequest *)request;

@property (nonatomic, nullable, weak) id<WeCloudRTMWebSocketDelegate> delegate;
@property (nonatomic) dispatch_queue_t delegateQueue;
@property (nonatomic) NSMutableURLRequest *request;
@property (nonatomic, nullable) id sslSettings;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)open;
- (void)closeWithCloseCode:(WeCloudRTMWebSocketCloseCode)closeCode reason:(NSData * _Nullable)reason;

- (void)sendMessage:(WeCloudRTMWebSocketMessage *)message completion:(void (^ _Nullable)(void))completion;
- (void)sendPing:(NSData * _Nullable)data completion:(void (^ _Nullable)(void))completion;
- (void)sendPong:(NSData * _Nullable)data completion:(void (^ _Nullable)(void))completion;

- (void)clean;
@end

NS_ASSUME_NONNULL_END
