//
//  NSObject+WCKeyValue.h
//  WCExtension
//
//  Created by WC on 13-8-24.
//  Copyright (c) 2013年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCExtensionConst.h"
#import <CoreData/CoreData.h>
#import "WCProperty.h"

/**
 *  KeyValue协议
 */
@protocol WCKeyValue <NSObject>
@optional
/**
 *  只有这个数组中的属性名才允许进行字典和模型的转换
 */
+ (NSArray *)WC_allowedPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)WC_ignoredPropertyNames;

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)WC_replacedKeyFromPropertyName;

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 从字典中取值用的key
 */
+ (id)WC_replacedKeyFromPropertyName121:(NSString *)propertyName;

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)WC_objectClassInArray;

/**
 *  旧值换新值，用于过滤字典中的值
 *
 *  @param oldValue 旧值
 *
 *  @return 新值
 */
- (id)WC_newValueFromOldValue:(id)oldValue property:(WCProperty *)property;

/**
 *  当字典转模型完毕时调用
 */
- (void)WC_keyValuesDidFinishConvertingToObject;

/**
 *  当模型转字典完毕时调用
 */
- (void)WC_objectDidFinishConvertingToKeyValues;
@end

@interface NSObject (WCKeyValue) <WCKeyValue>
#pragma mark - 类方法
/**
 * 字典转模型过程中遇到的错误
 */
+ (NSError *)WC_error;

/**
 *  模型转字典时，字典的key是否参考replacedKeyFromPropertyName等方法（父类设置了，子类也会继承下来）
 */
+ (void)WC_referenceReplacedKeyWhenCreatingKeyValues:(BOOL)reference;

#pragma mark - 对象方法
/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 */
- (instancetype)WC_setKeyValues:(id)keyValues;

/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @param context   CoreData上下文
 */
- (instancetype)WC_setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context;

/**
 *  将模型转成字典
 *  @return 字典
 */
- (NSMutableDictionary *)WC_keyValues;
- (NSMutableDictionary *)WC_keyValuesWithKeys:(NSArray *)keys;
- (NSMutableDictionary *)WC_keyValuesWithIgnoredKeys:(NSArray *)ignoredKeys;

/**
 *  通过模型数组来创建一个字典数组
 *  @param objectArray 模型数组
 *  @return 字典数组
 */
+ (NSMutableArray *)WC_keyValuesArrayWithObjectArray:(NSArray *)objectArray;
+ (NSMutableArray *)WC_keyValuesArrayWithObjectArray:(NSArray *)objectArray keys:(NSArray *)keys;
+ (NSMutableArray *)WC_keyValuesArrayWithObjectArray:(NSArray *)objectArray ignoredKeys:(NSArray *)ignoredKeys;

#pragma mark - 字典转模型
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @return 新建的对象
 */
+ (instancetype)WC_objectWithKeyValues:(id)keyValues;

/**
 *  通过字典来创建一个CoreData模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @param context   CoreData上下文
 *  @return 新建的对象
 */
+ (instancetype)WC_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context;

/**
 *  通过plist来创建一个模型
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 新建的对象
 */
+ (instancetype)WC_objectWithFilename:(NSString *)filename;

/**
 *  通过plist来创建一个模型
 *  @param file 文件全路径
 *  @return 新建的对象
 */
+ (instancetype)WC_objectWithFile:(NSString *)file;

#pragma mark - 字典数组转模型数组
/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组(可以是NSDictionary、NSData、NSString)
 *  @return 模型数组
 */
+ (NSMutableArray *)WC_objectArrayWithKeyValuesArray:(id)keyValuesArray;

/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组(可以是NSDictionary、NSData、NSString)
 *  @param context        CoreData上下文
 *  @return 模型数组
 */
+ (NSMutableArray *)WC_objectArrayWithKeyValuesArray:(id)keyValuesArray context:(NSManagedObjectContext *)context;

/**
 *  通过plist来创建一个模型数组
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 模型数组
 */
+ (NSMutableArray *)WC_objectArrayWithFilename:(NSString *)filename;

/**
 *  通过plist来创建一个模型数组
 *  @param file 文件全路径
 *  @return 模型数组
 */
+ (NSMutableArray *)WC_objectArrayWithFile:(NSString *)file;

#pragma mark - 转换为JSON
/**
 *  转换为JSON Data
 */
- (NSData *)WC_JSONData;
/**
 *  转换为字典或者数组
 */
- (id)WC_JSONObject;
/**
 *  转换为JSON 字符串
 */
- (NSString *)WC_JSONString;
@end

@interface NSObject (WCKeyValueDeprecated_v_2_5_16)
- (instancetype)setKeyValues:(id)keyValue WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (instancetype)setKeyValues:(id)keyValues error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (instancetype)setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (instancetype)setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (void)referenceReplacedKeyWhenCreatingKeyValues:(BOOL)reference WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSMutableDictionary *)keyValues WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSMutableDictionary *)keyValuesWithError:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSMutableDictionary *)keyValuesWithKeys:(NSArray *)keys WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSMutableDictionary *)keyValuesWithKeys:(NSArray *)keys error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSMutableDictionary *)keyValuesWithIgnoredKeys:(NSArray *)ignoredKeys WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSMutableDictionary *)keyValuesWithIgnoredKeys:(NSArray *)ignoredKeys error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray keys:(NSArray *)keys WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray keys:(NSArray *)keys error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray ignoredKeys:(NSArray *)ignoredKeys WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray ignoredKeys:(NSArray *)ignoredKeys error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (instancetype)objectWithKeyValues:(id)keyValues WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (instancetype)objectWithKeyValues:(id)keyValues error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (instancetype)objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (instancetype)objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (instancetype)objectWithFilename:(NSString *)filename WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (instancetype)objectWithFilename:(NSString *)filename error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (instancetype)objectWithFile:(NSString *)file WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (instancetype)objectWithFile:(NSString *)file error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray context:(NSManagedObjectContext *)context WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray context:(NSManagedObjectContext *)context error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)objectArrayWithFilename:(NSString *)filename WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)objectArrayWithFilename:(NSString *)filename error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)objectArrayWithFile:(NSString *)file WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
+ (NSMutableArray *)objectArrayWithFile:(NSString *)file error:(NSError **)error WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSData *)JSONData WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (id)JSONObject WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
- (NSString *)JSONString WCExtensionDeprecated("请在方法名前面加上WC_前缀，使用WC_***");
@end
