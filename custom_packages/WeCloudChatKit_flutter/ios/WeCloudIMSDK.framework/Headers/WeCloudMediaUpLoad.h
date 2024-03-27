//
//  WeCloudMediaUpLoad.h
//  WeCloudChatKit
//
//  Created by WeCloudIOS on 2022/7/27.
//

#import <Foundation/Foundation.h>
#import "WeCloudMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 成功通用回调
typedef void (^WEUPSucc)(NSString * url);
/// 失败通用回调
typedef void (^WEUPFail)(NSInteger code, NSString * _Nullable desc);

@interface WeCloudMediaUpLoad : NSObject

//创建单利 保证上传逐一处理
+ (instancetype)sharedWeCloudUpLoad;

+ (NSString *)filePathWithModel:(WeCloudMessageModel *)model;

//上传头像
+(void)uploadHeadImageWithPath:(NSURL *)path
                     imageName:(NSString *)imageName
                     SuccBlock:(nullable WEUPSucc)succ
                     FailBlock:(nullable WEUPFail)fail;


-(void)uploadWithPathWithQueue:(NSURL *)path
                      fileName:(NSString *)fileName
                     SuccBlock:(nullable WEUPSucc)succ
                     FailBlock:(nullable WEUPFail)fail;

+(void)uploadFileWithPath:(NSURL *)path
                 fileName:(NSString *)fileName
                SuccBlock:(nullable WEUPSucc)succ
                FailBlock:(nullable WEUPFail)fail;

+(void)downloadFileWithPath:(NSString *)url
                    downObj:(id)obj
                    message:(nullable WeCloudMessageModel *)message
                  SuccBlock:(nullable WEUPSucc)succ
                  FailBlock:(nullable WEUPFail)fail;

+(void)uploadFileWithPath:(NSURL *)path
                 fileName:(NSString *)fileName
                 fileType:(WeCloudIMMessageMediaType)fileType
                SuccBlock:(nullable WEUPSucc)succ
                FailBlock:(nullable WEUPFail)fail;

+(void)downloadFileWithPath:(NSString *)url
            WEUIMessageData:(id)data;

@end

NS_ASSUME_NONNULL_END
