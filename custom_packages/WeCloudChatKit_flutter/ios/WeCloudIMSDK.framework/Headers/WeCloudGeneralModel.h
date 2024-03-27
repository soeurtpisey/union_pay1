//
//  WeCloudGeneralModel.h
//  WeCloudIMSDK
//
//  Created by FungYan on 2022/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudGeneralModel : NSObject
/// 好友的clientId
@property (copy, nonatomic) NSString *clientId;
/// 好友的昵称备注
@property (copy, nonatomic) NSString *clientRemarkName;
/// 扩展
@property (copy, nonatomic) NSString *memberAttributes;
/// 扩展2
@property (copy, nonatomic) NSString *clientAttributes;
/// 昵称
@property (copy, nonatomic) NSString *nickname;
/// 头像
@property (copy, nonatomic) NSString *headPortrait;
/// 状态
@property (assign, nonatomic) int relation;
@end

NS_ASSUME_NONNULL_END
