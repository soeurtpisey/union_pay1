//
//  NSObject+WCCoding.h
//  WCExtension
//
//  Created by WC on 14-1-15.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCExtensionConst.h"

/**
 *  Codeing协议
 */
@protocol WCCoding <NSObject>
@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)WC_allowedCodingPropertyNames;
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)WC_ignoredCodingPropertyNames;
@end

@interface NSObject (WCCoding) <WCCoding>
/**
 *  解码（从文件中解析对象）
 */
- (void)WC_decode:(NSCoder *)decoder;
/**
 *  编码（将对象写入文件中）
 */
- (void)WC_encode:(NSCoder *)encoder;
@end

/**
 归档的实现
 */
#define WCCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self WC_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self WC_encode:encoder]; \
}

#define WCExtensionCodingImplementation WCCodingImplementation
