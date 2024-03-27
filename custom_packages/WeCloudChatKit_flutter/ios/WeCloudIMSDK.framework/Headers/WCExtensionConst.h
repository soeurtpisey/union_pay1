
#ifndef __WCExtensionConst__H__
#define __WCExtensionConst__H__

#import <Foundation/Foundation.h>

// 信号量
#define WCExtensionSemaphoreCreate \
static dispatch_semaphore_t signalSemaphore; \
static dispatch_once_t onceTokenSemaphore; \
dispatch_once(&onceTokenSemaphore, ^{ \
    signalSemaphore = dispatch_semaphore_create(1); \
});

#define WCExtensionSemaphoreWait \
dispatch_semaphore_wait(signalSemaphore, DISPATCH_TIME_FOREVER);

#define WCExtensionSemaphoreSignal \
dispatch_semaphore_signal(signalSemaphore);

// 过期
#define WCExtensionDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 构建错误
#define WCExtensionBuildError(clazz, msg) \
NSError *error = [NSError errorWithDomain:msg code:250 userInfo:nil]; \
[clazz setWC_error:error];

// 日志输出
#ifdef DEBUG
#define WCExtensionLog(...) NSLog(__VA_ARGS__)
#else
#define WCExtensionLog(...)
#endif

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define WCExtensionAssertError(condition, returnValue, clazz, msg) \
[clazz setWC_error:nil]; \
if ((condition) == NO) { \
    WCExtensionBuildError(clazz, msg); \
    return returnValue;\
}

#define WCExtensionAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define WCExtensionAssert(condition) WCExtensionAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define WCExtensionAssertParamNotNil2(param, returnValue) \
WCExtensionAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define WCExtensionAssertParamNotNil(param) WCExtensionAssertParamNotNil2(param, )

/**
 * 打印所有的属性
 */
#define WCLogAllIvars \
-(NSString *)description \
{ \
    return [self WC_keyValues].description; \
}
#define WCExtensionLogAllProperties WCLogAllIvars

/**
 *  类型（属性类型）
 */
extern NSString *const WCPropertyTypeInt;
extern NSString *const WCPropertyTypeShort;
extern NSString *const WCPropertyTypeFloat;
extern NSString *const WCPropertyTypeDouble;
extern NSString *const WCPropertyTypeLong;
extern NSString *const WCPropertyTypeLongLong;
extern NSString *const WCPropertyTypeChar;
extern NSString *const WCPropertyTypeBOOL1;
extern NSString *const WCPropertyTypeBOOL2;
extern NSString *const WCPropertyTypePointer;

extern NSString *const WCPropertyTypeIvar;
extern NSString *const WCPropertyTypeMethod;
extern NSString *const WCPropertyTypeBlock;
extern NSString *const WCPropertyTypeClass;
extern NSString *const WCPropertyTypeSEL;
extern NSString *const WCPropertyTypeId;

#endif
