//
//  AddFriendsModel.h
//  XYDChat
//
//  Created by together on 2018/4/13.
//  Copyright © 2018年 With_Dream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudGeneralModel.h"
@interface AddFriendsModel : NSObject
@property (nonatomic,copy) NSString *userId;// userId
@property (nonatomic, copy) NSString *idNumber;//自己设置的id
@property (nonatomic,copy) NSString *headPortrait;// 头像
@property (nonatomic,assign) NSInteger sex;// 1 是男 2是女 3未知
@property (nonatomic,copy) NSString *nickname;// 昵称
@property (nonatomic,copy) NSString *clientRemarkName;// 好友备注昵称
/// 与我关系 1-陌生人 2-好友 3-被我拉黑
@property (nonatomic, assign) NSInteger relation;
/// 最后更新时间
@property (nonatomic, assign) long lastModifyTimestamp;

+(AddFriendsModel *)addFrirendToGeneralModel:(WeCloudGeneralModel*)generalModel;

+(WeCloudGeneralModel*)generalModelFromFriendsModel:(AddFriendsModel*)model;

//@property (nonatomic,copy) NSString *email;
//@property (nonatomic,copy) NSString *mobile;
//
//@property (nonatomic,copy) NSString *roomId;
//
//@property (nonatomic,copy) NSString *address;
//@property (nonatomic,copy) NSString *region;
//@property (nonatomic,copy) NSString *city;
//@property (nonatomic,copy) NSString *district;
//@property (copy, nonatomic) NSString *introduce;
//
//@property (copy, nonatomic) NSString *requestId;//请求ID
//
////添加来源：0手机号 1 自定义的用户-ID 2群聊  3二维码 4名片
//@property (nonatomic, assign) NSInteger sourceType;


@end
