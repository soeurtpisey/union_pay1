//
//  NSObject+WCClass.h
//  WCExtensionExample
//
//  Created by WC Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  遍历所有类的block（父类）
 */
typedef void (^WCClassesEnumeration)(Class c, BOOL *stop);

/** 这个数组中的属性名才会进行字典和模型的转换 */
typedef NSArray * (^WCAllowedPropertyNames)(void);
/** 这个数组中的属性名才会进行归档 */
typedef NSArray * (^WCAllowedCodingPropertyNames)(void);

/** 这个数组中的属性名将会被忽略：不进行字典和模型的转换 */
typedef NSArray * (^WCIgnoredPropertyNames)(void);
/** 这个数组中的属性名将会被忽略：不进行归档 */
typedef NSArray * (^WCIgnoredCodingPropertyNames)(void);

/**
 * 类相关的扩展
 */
@interface NSObject (WCClass)
/**
 *  遍历所有的类
 */
+ (void)WC_enumerateClasses:(WCClassesEnumeration)enumeration;
+ (void)WC_enumerateAllClasses:(WCClassesEnumeration)enumeration;

#pragma mark - 属性白名单配置
/**
 *  这个数组中的属性名才会进行字典和模型的转换
 *
 *  @param allowedPropertyNames          这个数组中的属性名才会进行字典和模型的转换
 */
+ (void)WC_setupAllowedPropertyNames:(WCAllowedPropertyNames)allowedPropertyNames;

/**
 *  这个数组中的属性名才会进行字典和模型的转换
 */
+ (NSMutableArray *)WC_totalAllowedPropertyNames;

#pragma mark - 属性黑名单配置
/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 *
 *  @param ignoredPropertyNames          这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (void)WC_setupIgnoredPropertyNames:(WCIgnoredPropertyNames)ignoredPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSMutableArray *)WC_totalIgnoredPropertyNames;

#pragma mark - 归档属性白名单配置
/**
 *  这个数组中的属性名才会进行归档
 *
 *  @param allowedCodingPropertyNames          这个数组中的属性名才会进行归档
 */
+ (void)WC_setupAllowedCodingPropertyNames:(WCAllowedCodingPropertyNames)allowedCodingPropertyNames;

/**
 *  这个数组中的属性名才会进行字典和模型的转换
 */
+ (NSMutableArray *)WC_totalAllowedCodingPropertyNames;

#pragma mark - 归档属性黑名单配置
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 *
 *  @param ignoredCodingPropertyNames          这个数组中的属性名将会被忽略：不进行归档
 */
+ (void)WC_setupIgnoredCodingPropertyNames:(WCIgnoredCodingPropertyNames)ignoredCodingPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSMutableArray *)WC_totalIgnoredCodingPropertyNames;

#pragma mark - 内部使用
+ (void)WC_setupBlockReturnValue:(id (^)(void))block key:(const char *)key;
@end
