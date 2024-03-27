//
//  WeCloudException+Flutter.m
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/3/23.
//

#import "WeCloudException+Flutter.h"

@implementation WeCloudException (Flutter)

- (NSDictionary *)toJson {
    return @{
        @"code": @(self.code),
        @"description":self.message,
    };
}

@end
