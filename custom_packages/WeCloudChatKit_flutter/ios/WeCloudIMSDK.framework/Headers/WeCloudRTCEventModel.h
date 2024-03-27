//
//  WeCloudRTCEventModel.h
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, WeCloudWeRTCType) {
    /// 视频
    WeCloudWeRTCTypVideo = 1,
    /*!
     音频
     */
    WeCloudWeRTCTypVoice = 2,
   
    
};




@interface WeCloudRTCEventModel : NSObject


@property (assign,nonatomic) int subCmd;

@property (assign,nonatomic) long conversationId;

@property (assign,nonatomic) WeCloudWeRTCType callType;

@property (assign, nonatomic) long channelId;

@property (assign, nonatomic) long timestamp;
@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) NSString *sdpData;
@property (strong, nonatomic) NSString *sdpType;
@property (strong, nonatomic) NSString *candidateData;



@end

NS_ASSUME_NONNULL_END
