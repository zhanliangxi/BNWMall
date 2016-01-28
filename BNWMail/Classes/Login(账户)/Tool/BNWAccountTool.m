//
//  YFAccountTool.m
//  YFCustomer
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWAccountTool.h"


// 账号的存储路径
#define BNWAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation BNWAccountTool

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(BNWAccount *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:BNWAccountPath];
}


/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (BNWAccount *)account
{
    // 加载模型
    BNWAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:BNWAccountPath];
    /* 验证账号是否过期 */
    
    // 过期的秒数
    long long expires_in = [account.time longLongValue];

    // 获得过期时间
    NSDate *expiresTime = [NSDate dateWithTimeIntervalSince1970:expires_in];
    // 获得当前时间
    NSDate *now = [NSDate date];
    NSComparisonResult result = [expiresTime compare:now];
    if (result == NSOrderedSame) { // 过期
        return nil;
    }

    
    return account;
}


@end
