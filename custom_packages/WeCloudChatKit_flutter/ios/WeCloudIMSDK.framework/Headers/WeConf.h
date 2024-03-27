//
//  WEConf.h
//  WeCloudIMSDK
//
//  Created by WeCloudIOS on 2022/5/11.
//

#ifndef WEConf_h
#define WEConf_h

#define  WEAKSELF      __weak typeof(self) weakSelf  = self;

#define dispatch_main_async_safe(block)                                                                            \
    if ([NSThread isMainThread]) {                                                                                     \
        block();                                                                                                       \
    } else {                                                                                                           \
        dispatch_async(dispatch_get_main_queue(), block);                                                              \
    }

#define BFIntToString(name)               [NSString stringWithFormat:@"%d",name]

#endif /* WEConf_h */
