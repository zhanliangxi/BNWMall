//
//  AppMacros.h
//  KuaiChong
//
//  Created by Onliu on 14-6-6.
//  Copyright (c) 2014年 Onliu. All rights reserved.
//


// Release a CoreFoundation object safely.
#define MM_RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

//颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RandomColor RGBCOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//系统版本：
#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8 )
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7 )
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] floatValue] >= 6 )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] floatValue] >= 5 )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] floatValue] >= 4 )

#define IS_IOS8	( [[[UIDevice currentDevice] systemVersion] intValue] == 8 )
#define IS_IOS7	( [[[UIDevice currentDevice] systemVersion] intValue] == 7 )
#define IS_IOS6	( [[[UIDevice currentDevice] systemVersion] intValue] == 6 )
#define IS_IOS5	( [[[UIDevice currentDevice] systemVersion] intValue] == 5 )
#define IS_IOS4	( [[[UIDevice currentDevice] systemVersion] intValue] == 4 )

#define KEY_WINDOW  [UIApplication sharedApplication].keyWindow

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define IOS7_SDK_AVAILABLE 1
#endif

#define IOS7_NAVI_SPACE -10

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound)
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)


//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//屏幕长宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define NavigationBar_HEIGHT 44     //导航栏高度
#define StatusBar_HEIGHT 20         //状态栏高度
#define TABBAR_HEIGHT  49

//G－C－D
#define QUEUE_BACKGROUND    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define QUEUE_MAIN          dispatch_get_main_queue()


#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#pragma mark - Setting
//当前系统设置国家的country iso code
#define countryISO  [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode]
//当前系统设置语言的iso code
#define languageISO [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode]

#pragma mark - Path
#define kHomePath            NSHomeDirectory()
#define kCachePath          [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]
#define kDocumentFolder     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kDocumentFolder2    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kLibraryPath        [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]

#define kTempPath            NSTemporaryDirectory()
#define kMainBoundPath      [[NSBundle mainBundle] bundlePath]
#define kResourcePath       [[NSBundle mainBundle] resourcePath]
#define kExecutablePath     [[NSBundle mainBundle] executablePath]


#pragma mark Time
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

#pragma mark - LOG

#ifdef DEBUG // 处于开发阶段
#define YBLog(format, ...) \
do { \
NSLog(@"<%@ : %d : %s>-: %@", \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
__LINE__, \
__FUNCTION__, \
[NSString stringWithFormat:format, ##__VA_ARGS__]); \
} while(0)
#else // 处于发布阶段
#define YBLog(...)
#endif
