//
//  AWSManager.h
//  WeCloudChatDemo
//
//  Created by mac on 2022/3/1.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface AWSManager : NSObject

+ (AWSManager *)defaultManager;

/// 初始化AWS
/// @param accessKey accessKey
/// @param secretKey secretKey
/// @param endPointUrl endPointUrl 
- (void)createDefaultServiceConfiguration:(NSString *)accessKey secretKey:(NSString *)secretKey endPointUrl:(NSString *)endPointUrl;



/// 上传更换头像的图片
/// @param path 本地图片地址
/// @param imageName 图片名
/// @param completeBlock 结果回调，返回图片url
- (void)uploadHeadImageWithPath:(NSURL *)path imageName:(NSString *)imageName callback:(void (^)(BOOL success, NSString *__nullable imageUrl,NSString *__nullable error))completeBlock;


/// 上传文件
/// @param path 本地文件地址
/// @param fileName 本地文件名
/// @param completeBlock 结果回调，返回文件url
- (void)uploadFileWithPath:(NSURL *)path fileName:(NSString *)fileName contentType:(NSString *__nullable)contentType callback:(void (^)(BOOL success, NSString *__nullable fileUrl,NSString *__nullable error))completeBlock;

/// 加密聊天上传文件
/// @param path 本地文件地址
/// @param fileName 本地文件名
/// @param completeBlock 结果回调，返回文件URL
- (void)uploadEncryptFileWithPath:(NSURL *)path fileName:(NSString *)fileName callback:(void (^)(BOOL success, NSString *__nullable fileUrl,NSString *__nullable error))completeBlock;

/// 下载文件
/// @param url 文件url
/// @param foldPath 本地存储的直接路径
/// @param completeBlock 结果回调，返回本地文件地址
- (void)downWithFileUrl:(NSString *)url foldPath:(NSString *)foldPath callback:(void (^)(BOOL success, NSString *__nullable fileLocalPath,NSString *__nullable error))completeBlock;

@end

NS_ASSUME_NONNULL_END
