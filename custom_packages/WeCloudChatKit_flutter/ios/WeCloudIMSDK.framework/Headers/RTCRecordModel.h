//
//  RTCRecordModel.h
//  XYDChat
//
//   on 2020/2/25.
//  Copyright © 2020 With_Dream. All rights reserved.
//

#import "WeCloudMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTCRecordModel : NSObject

@property (nonatomic, assign) int recordId;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, assign) long long userId;
@property (nonatomic, assign) long long receiver;
@property (nonatomic, assign) long long sender;
@property (nonatomic, assign) long createTime;
@property (nonatomic, assign) long endTime;
@property (nonatomic, copy) NSString *rtcType;//video voice

@property (nonatomic, copy) NSString *date;

//1.视频呼出，2.视频呼入, 3.视频未接, 4.电话呼出、5.电话呼入、6电话未接
@property (nonatomic, assign) NSInteger sessionType;


//******************应用层用到的，可以自己去应用层实现**************************
@property (nonatomic, assign) NSInteger duration;//通话时长

/**
 * 10 拨打者取消拨打
 * 11 拨打方由于拨打时间过长取消
 * 12 接收者拒绝
 * 13 对方忙线
 * 14 拨号失败或加入房间失败
 * 15 连接失败
 * 16 异常断开连接
 * 17 正常通话结束
 */
@property (nonatomic, assign) NSInteger rtcStatus;//RTC记录状态

- (NSInteger)getSessionStatus;


@end


@interface RTCRecordSectionModel : NSObject

@property (nonatomic, strong) NSMutableArray <RTCRecordModel *> *records;
@property (nonatomic, copy) NSString *showName;
@property (nonatomic, assign) BOOL isSelected;

@end


NS_ASSUME_NONNULL_END
