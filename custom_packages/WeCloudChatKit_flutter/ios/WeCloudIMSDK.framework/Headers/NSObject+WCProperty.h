//
//  NSObject+WCProperty.h
//  WCExtensionExample
//
//  Created by WC Lee on 15/4/17.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCExtensionConst.h"

@class WCProperty;

/**
 *  遍历成员变量用的block
 *
 *  @param property 成员的包装对象
 *  @param stop   YES代表停止遍历，NO代表继续遍历
 */
typedef void (^WCPropertiesEnumeration)(WCProperty *property, BOOL *stop);

/** 将属性名换为其他key去字典中取值 */
typedef NSDictionary * (^WCReplacedKeyFromPropertyName)(void);
typedef id (^WCReplacedKeyFromPropertyName121)(NSString *propertyName);
/** 数组中需要转换的模型类 */
typedef NSDictionary * (^WCObjectClassInArray)(void);
/** 用于过滤字典中的值 */
typedef id (^WCNewValueFromOldValue)(id object, id oldValue, WCProperty *property);

/**
 * 成员属性相关的扩展
 */
@interface NSObject (WCProperty)
#pragma mark - 遍历
/**
 *  遍历所有的成员
 */
+ (void)WC_enumerateProperties:(WCPropertiesEnumeration)enumeration;

#pragma mark - 新值配置
/**
 *  用于过滤字典中的值
 *
 *  @param newValueFormOldValue 用于过滤字典中的值
 */
+ (void)WC_setupNewValueFromOldValue:(WCNewValueFromOldValue)newValueFormOldValue;
+ (id)WC_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained WCProperty *)property;

#pragma mark - key配置
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName 将属性名换为其他key去字典中取值
 */
+ (void)WC_setupReplacedKeyFromPropertyName:(WCReplacedKeyFromPropertyName)replacedKeyFromPropertyName;
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName121 将属性名换为其他key去字典中取值
 */
+ (void)WC_setupReplacedKeyFromPropertyName121:(WCReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121;

#pragma mark - array model class配置
/**
 *  数组中需要转换的模型类
 *
 *  @param objectClassInArray          数组中需要转换的模型类
 */
+ (void)WC_setupObjectClassInArray:(WCObjectClassInArray)objectClassInArray;
@end

@interface NSObject (WCPropertyDeprecated_v_2_5_16)
+ (void)enumerateProperties:(WCPropertiesEnumeration)enumeration WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (void)setupNewValueFromOldValue:(WCNewValueFromOldValue)newValueFormOldValue WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (id)getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained WCProperty *)property WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (void)setupReplacedKeyFromPropertyName:(WCReplacedKeyFromPropertyName)replacedKeyFromPropertyName WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (void)setupReplacedKeyFromPropertyName121:(WCReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121 WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (void)setupObjectClassInArray:(WCObjectClassInArray)objectClassInArray WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
@end
