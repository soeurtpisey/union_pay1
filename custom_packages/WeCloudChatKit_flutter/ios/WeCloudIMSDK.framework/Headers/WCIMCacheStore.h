//
//  WCIMCacheStore.h
//  WeCloudChatDemo
//
//  Created by 与梦信息的Mac on 2022/2/11.
//  Copyright © 2022 WeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeCloudDB.h"

#ifdef DEBUG
#define WCIM_SHOULD_LOG_ERRORS YES
#else
#define WCIM_SHOULD_LOG_ERRORS NO
#endif

#define WCIM_OPEN_DATABASE(db, routine) do {              \
    WeCloudDatabaseQueue *dbQueue = [self databaseQueue]; \
    [dbQueue inDatabase:^(WeCloudDatabase *db) {          \
        routine;                                          \
    }];                                                   \
} while (0)

@interface WCIMCacheStore : NSObject

@property (nonatomic, readonly, copy) NSString *clientId;

+ (NSString *)databasePathWithName:(NSString *)name;

- (instancetype)initWithClientId:(NSString *)clientId;

- (WeCloudDatabaseQueue *)databaseQueue;

/// 初始化库
/// @param clientId clientId
/// @param sqlAry 需要额外增加的表的sql语句组
- (instancetype)initWithClientId:(NSString *)clientId sqlAry:(NSArray *)sqlAry;

/// 创建表
- (void)createTable;

#pragma mark - 数据库升级
/// 早期的版本没有设计数据库升级的逻辑，也没有版本WeCloudDBUserVersion，从2.7.3开始设计这块逻辑
- (void)upgradeDatabase;

@end

