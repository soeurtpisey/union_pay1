//
//  WCIMAllDownloadCache.h
//  WeCloudChatDemo
//
//  Created by mac on 2022/3/4.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WeCloudMessageModel;

@interface WCIMAllDownloadCache : NSObject

@property (nonatomic, readonly, copy) NSString *clientId;

+ (instancetype)cacheWithClientId:(NSString *)clientId;


- (NSString *)allDownloadFilePathWithName:(WeCloudMessageModel *)model;

/// 
//- (NSString *)headFilePathWithName:(NSString *)name;

- (NSString *)getFileDownloadPath:(WeCloudMessageModel *)model;

//- (NSString *)getDoucumentPath;

@end

NS_ASSUME_NONNULL_END
