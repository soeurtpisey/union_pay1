//
//  NSString+WCExtension.h
//  WCExtensionExample
//
//  Created by WC Lee on 15/6/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCExtensionConst.h"

@interface NSString (WCExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)WC_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)WC_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)WC_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)WC_firstCharLower;

- (BOOL)WC_isPureInt;

- (NSURL *)WC_url;

/// 创建临时路径，用于存储临时数据，使用后一般需要删除
/// subFolder:子文件夹
/// fileName:文件名
+ (NSString *)wc_getTempPathWithSubFolder:(nullable NSString *)subFolder fileName:(nullable NSString *)fileName;

/// 获取随机字符串
+ (NSString *)wc_getRandomString;

@end

@interface NSString (WCExtensionDeprecated_v_2_5_16)
- (NSString *)underlineFromCamel WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSString *)camelFromUnderline WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSString *)firstCharUpper WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSString *)firstCharLower WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (BOOL)isPureInt WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSURL *)url WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
@end
