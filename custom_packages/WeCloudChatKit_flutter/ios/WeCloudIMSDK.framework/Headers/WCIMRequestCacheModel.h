//
//  WCIMRequestCacheModel.h
//  WeCloudChatDemo
//
//  Created by 与梦信息的Mac on 2022/4/13.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudStatusDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface WCIMRequestCacheModel : NSObject
//主键id
@property (nonatomic, copy) NSString *reqId;
//请求接口
@property (nonatomic, copy) NSString *action;
//通过websocket发起的请求类型，1.消息类型 2.数据请求类型 用于回调判断
@property (nonatomic, assign) WCIMClientRequestType requestType;
//接口请求参数
@property (nonatomic, strong) NSDictionary *param;
//请求创建时间
@property (nonatomic, assign) long long createTime;
//推送消息
@property (nonatomic, strong) NSDictionary *push;
//自定义内容
@property (nonatomic, strong) NSDictionary *attrs;
@end

NS_ASSUME_NONNULL_END
