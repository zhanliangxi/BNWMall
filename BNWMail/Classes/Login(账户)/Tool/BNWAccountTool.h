//
//  YFAccountTool.h
//  YFCustomer
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNWAccount.h"

@interface BNWAccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(BNWAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型
 */
+ (BNWAccount *)account;

@end
