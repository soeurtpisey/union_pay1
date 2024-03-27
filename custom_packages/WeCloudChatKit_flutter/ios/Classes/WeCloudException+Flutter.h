//
//  WeCloudException+Flutter.h
//  wecloudchatkit_flutter
//
//  Created by mac on 2022/3/23.
//

//#import "WeCloudException.h"
#import <WeCloudIMSDK/WeCloudIMSDK.h>
#import "WeCloudToFlutterJson.h"
NS_ASSUME_NONNULL_BEGIN

@interface WeCloudException (Flutter)

- (NSDictionary *)toJson;

@end

NS_ASSUME_NONNULL_END
