//
//  WeCloudGroupModel.h
//  WeCloudIMSDK
//
//  Created by FungYan on 2022/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudGroupModel : NSObject
/// 主键ID
//@property (copy, nonatomic) NSString *id;
/// client自己的自定义扩展属性
@property (copy, nonatomic) NSString *clientAttributes;
/// 用户ID
@property (copy, nonatomic) NSString *clientId;
/// 会话中client的备注名
@property (copy, nonatomic) NSString *clientRemarkName;
/// 头像
@property (copy, nonatomic) NSString *headPortrait;
/// 会话成员列表的自定义扩展属性
@property (copy, nonatomic) NSString *memberAttributes;
/// 禁言开关 1-未禁言 2-禁言
@property (assign, nonatomic) int muted;
/// 主昵称
@property (copy, nonatomic) NSString *nickname;
/// 群内角色 1 普通群成员  2管理员  3群主
@property (assign, nonatomic) int role;

@end

NS_ASSUME_NONNULL_END
