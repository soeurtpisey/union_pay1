//
//  WeCloudTransparentEventModel.h
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WeCloudTransparentEventType) {
    /// 业务事件
    WeCloudTransparentEventType_TransparentNumber = -10000,
    /// 音视频接听
    WeCloudTransparentEventType_AudioAndVideoAnswering = -2301,
    /// 音视频拒绝
    WeCloudTransparentEventType_AudioAndVideoRejection = -2302,
    /// 消息已读
    WeCloudTransparentEventType_ConversationMsgRead = -2501,
};


@interface WeCloudTransparentEventModel : NSObject
/// 透传事件类型
@property (assign,nonatomic) WeCloudTransparentEventType subCmd;
/// 具体业务事件底下的子指令
@property (assign,nonatomic) int clientCmd;
/// 自定义内容
@property (strong,nonatomic) NSDictionary *attribute;
/// 触发者用户id
@property (strong, nonatomic) NSString *clientId;
/// 发送内容
@property (strong, nonatomic) NSString *content;
/// 时间戳
@property (assign, nonatomic) long timestamp;




@end

NS_ASSUME_NONNULL_END
