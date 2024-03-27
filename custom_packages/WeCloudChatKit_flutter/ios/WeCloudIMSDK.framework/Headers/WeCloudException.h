//
//  WeCloudException.h
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/3/23.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WeCloudExceptionResult) {
        WeCloudExceptionSuccess = 200 ,//成功
        WeCloudExceptionUnauthorized = 401, //token失效
        WeCloudExceptionForbidden = 403,//禁止访问
        WeCloudExceptionNotFound = 404,//api未找到
        WeCloudExceptionFail = 500, //操作失败
        WeCloudExceptionLoginException = 4000,//登录失败
        WeCloudExceptionSystemException = 5000,//系统异常
        WeCloudExceptionParameterException = 5001,//请求参数校验异常
        WeCloudExceptionParameterParseException = 5002,//请求参数解析异常
        WeCloudExceptionHttpMedidTypeException = 5003,//http内容类型异常
        WeCloudExceptionSpringBootPlusException = 5100,//系统处理异常
        WeCloudExceptionBusinessException = 5101,//业务处理异常
        WeCloudExceptionDaoException = 5102,//数据库处理异常
        WeCloudExceptionVerificationCodeException = 5103,//验证码校验异常
        WeCloudExceptionAuthentionException = 5104,//登录授权异常
        WeCloudExceptionNoAccess = 5105,//没有访问权限
        WeCloudExceptionNoAccessException = 5106,//没有访问权限
        WeCloudExceptionJWTTokenException = 5107,// JWT Token解析异常
        WeCloudExceptionDefaultHandlingException = 5108,//默认的异常处理
        WeCloudExceptionCreateSessionRepeatedly = 6010,// 已有会话,不能重复创建会话
        WeCloudExceptionClientNotFound = 6011,//该用户不存在
        WeCloudExceptionErrorCodeUnkown = -1,// 未知错误
        WeCloudExceptionIsBeBlack = 6012,// 已被对方加入黑名单
        WeCloudExceptionIsToBlack = 6013,// 你把对方拉黑
        WeCloudExceptionIsBeKickOut = 6014,//已被踢出会话
        WeCloudExceptionIsBeMuted = 6015,//已被禁言
        WeCloudExceptionIsBeDisband = 6016,//群聊已解散
        WeCloudExceptionServerConnectionFailed = 100,//WeCloud服务器连接失败
        WeCloudExceptionRequestTimeout = 124,// 请求超时
};

NS_ASSUME_NONNULL_BEGIN

@interface WeCloudException : NSObject

@property (nonatomic, assign) WeCloudExceptionResult code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
