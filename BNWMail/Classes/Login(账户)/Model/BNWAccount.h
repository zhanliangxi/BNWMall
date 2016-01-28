//
//  YFAccount.h
//  YFCustomer
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWAccount : NSObject
/**
 *  手机号码
 */
@property (nonatomic,copy) NSString *mobile_phone;
/**
 *  密码
 */
@property (nonatomic,copy) NSString *password;
/**
 *  token
 */
@property (copy,nonatomic) NSString *token;
/**
 *  用户ID
 */
@property (copy,nonatomic) NSString *user_id;
/**
 *  性别
 */
@property (copy,nonatomic) NSString *sex;
/**
 *  用户名
 */
@property (copy,nonatomic) NSString *user_name;
/**
 *  头像（缩略图）
 */
@property (copy,nonatomic) NSString *user_thum; 
/**
 *  用户等级
 */
@property (copy,nonatomic) NSString *user_rank;
/**
 *  余额
 */
@property (copy,nonatomic) NSString *user_money;
/**
 *  登陆过期时间
 */
@property (copy,nonatomic) NSString *time;
@end
