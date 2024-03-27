//
//  WeCloudCommonDefine.h
//  ChatSDK
//
//  Created by mac on 2022/1/9.
//  Copyright © 2022 wecloud .Icn. All rights reserved.
//

#ifndef WeCloudCommonDefine_h
#define WeCloudCommonDefine_h

//#define HTTP_URL @"https://imapitest.wecloud.cn/"
//#define APP_KEY  @"51btQenFwcXaEeDa"
//#define APP_SECRET  @"e50a3fd91e2c3f3927e332a720aa5cba6b2302faf2ab3737"
//#define WS_URL  @"wss://imapitest.wecloud.cn/ws"



#define APP_KEY  @"icy6c6gVtJCuQwBk"
#define APP_SECRET  @"195df122ade65a36b978c22afd81718ec8441c970ad2bcb0"

#define APP_KEY_TRTC  @"icy6c6gVtJCuQwBk"
#define APP_SECRET_TRTC  @"195df122ade65a36b978c22afd81718ec8441c970ad2bcb0"

//#define HTTP_URL  @"http://192.168.1.45:8082/"
//#define WS_URL  @"ws://192.168.1.45:8899/ws"
#define HTTP_URL  @"https://imapitest.wecloud.cn/api/"
#define WS_URL  @"wss://imapitest.wecloud.cn/ws"
//#define WS_TRTC_API_URL @"http://121.37.22.224:8089"
//#define WS_TRTC_URL @"wss://ws-meet-test.wecloud.cn"
#define WS_TRTC_API_URL @"http://123.60.77.107:8089"
#define WS_TRTC_URL @"wss://ws-meet.wecloud.cn"

///// 正式环境
//#define APP_KEY  @"QizKVHcILRWp6Td2"
//#define APP_SECRET  @"287d04828099fb7de871e9dda845fa8b6b2302faf2ab3737"
//#define HTTP_URL  @"https://imapi.wecloud.cn/api/"
//#define WS_URL  @"wss://imapi.wecloud.cn/ws"
//#define WS_TRTC_URL @"wss://ws-meet.wecloud.cn"
//#define WS_TRTC_API_URL @"http://meet-api.wecloud.cn"
///// 正式环境的多人音视频KEY
//#define APP_KEY_TRTC  @"APIiMJcGWevwjzP"
//#define APP_SECRET_TRTC  @"Cmpfbn94mByfema9JF6UXDQGr3q391DaulBf8LNqaA8B"

#define AWSBucketName @"uim"
#define AWSBucketNameForever @"uim-forever"
#define AWSEndpointUrl   @"https://test-file.wecloud.cn"
#define AWSAccessKey  @"test-pwdisZz123456"
#define AWSSecretKey  @"Zz123456"

/// AWS生产环境
//#define AWSBucketName @"paas-im-demo"
//#define AWSBucketNameForever @"paas-im-demo-forever"
//#define AWSEndpointUrl   @"https://oss.wecloud.cn"
//#define AWSAccessKey  @"ee4tXw1pKzdIf0rW"
//#define AWSSecretKey  @"H8DkFwN3oOsxmVNVZ3ZuQ4iSX40ajehHCHnSPmAaepknGI5qNLulm7QSDPKX4gt4"


#define dispatch_main_async_safe(block)                                                                            \
    if ([NSThread isMainThread]) {                                                                                     \
        block();                                                                                                       \
    } else {                                                                                                           \
        dispatch_async(dispatch_get_main_queue(), block);                                                              \
    }
#define LoadingView(a) [MBProgressHUD loadingViewWithMessage:a];
#define LoadingWin(a) [MBProgressHUD loadingWindowWithMessage:a];
#define ShowViewMessage(a) [MBProgressHUD showViewPromptTitle:a];
#define ShowWinMessage(a) [MBProgressHUD showWindowPromptTitle:a];
#define HiddenHUD  [MBProgressHUD hiddenHUD];

#endif /* WeCloudCommonDefine_h */
