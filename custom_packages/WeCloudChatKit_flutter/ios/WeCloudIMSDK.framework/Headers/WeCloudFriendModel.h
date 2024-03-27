//
//  FriendModel.h
//  WeCloudChatDemo
//
//  Created by mac on 2022/1/28.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 好友关系状态
typedef NS_ENUM(NSUInteger, WeCloudFriendState) {
    /*!
     待确定
     */
    WeCloudFriendState_UnSure = 1,
    
    /*!
     已确认，：
     */
    WeCloudFriendState_Sure = 2,
    /*
     已拒绝
     */
    WeCloudFriendState_Reject = 3,
    /*
     已删除
     */
    WeCloudFriendState_Delete = 4,
    
};
/// 好友来源
typedef NS_ENUM(NSUInteger, WeCloudFriendSource) {
    /*!
     通讯录
     */
    WeCloudFriendSource_MailList = 1,
    
    /*!
     二度人脉：
     */
    WeCloudFriendSource_SecondDegreeContacts = 2,
    /*
     附近的人
     */
    WeCloudFriendSource_PeopleNearby = 3,
    /*
     同类标签
     */
    WeCloudFriendSource_SimilarLabel = 4,
    
};


NS_ASSUME_NONNULL_BEGIN

@interface WeCloudFriendModel : NSObject
/// 好友的clientId
@property (copy, nonatomic) NSString *friendClientId;
/// 好友的昵称备注
@property (copy, nonatomic) NSString *friendName;
/// 好友关系状态，1：待确定，2：已确认，3：已拒绝，4：已删除
@property (assign, nonatomic) WeCloudFriendState state;
/// 好友推荐来源，1：通讯录，2：二度人脉，3：附近的人，4：同类标签
@property (assign, nonatomic) WeCloudFriendSource source;
/// 是否删除
@property (assign, nonatomic) BOOL delFlag;

/// 待接受好友列表中
/// 好友申请者id
@property (copy, nonatomic) NSString *claimerClientId;
/// 好友拒绝原因
@property (copy, nonatomic) NSString *rejectRemark;
/// 好友请求说明
@property (copy, nonatomic) NSString *requestRemark;

/// 好友验证结果
@property (assign, nonatomic) BOOL agree;

@end

@interface WeCloudMyModel : NSObject
/// 用户ID
@property (copy, nonatomic) NSString *clientId;
/// 头像
@property (copy, nonatomic) NSString *headPortrait;
/// phone
@property (copy, nonatomic) NSString *phone;
/// 蓝豆ID
@property (copy, nonatomic) NSString *idNumber;
/// 上次登录时间
@property (copy, nonatomic) NSString *lastOfflineTime;
/// 名称
@property (copy, nonatomic) NSString *nickname;
/// 扩展
@property (copy, nonatomic) NSString *attributes;
/// 性别
@property (assign, nonatomic) int sex;

@end

NS_ASSUME_NONNULL_END
