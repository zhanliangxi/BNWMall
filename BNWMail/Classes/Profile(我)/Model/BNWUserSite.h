//
//  BNWUserSite.h
//  BNWMail
//
//  Created by 1 on 15/8/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWUserSite : NSObject
/**
 *  地区
 */
@property (copy,nonatomic) NSString *district;
/**
 *  城市
 */
@property (copy,nonatomic) NSString *city;
/**
 *  国家
 */
@property (copy,nonatomic) NSString *country;
/**
 *  收货人名称
 */
@property (copy,nonatomic) NSString *consignee;
/**
 *  详细地址
 */
@property (copy,nonatomic) NSString *address;
/**
 *  收货地址表数据 ID
 */
@property (copy,nonatomic) NSString *address_id;
/**
 *  收货人手机号码
 */
@property (copy,nonatomic) NSString *mobile;
/**
 *  省份
 */
@property (copy,nonatomic) NSString *province;
/**
 *  性别
 */
@property (copy,nonatomic) NSString *sex;
@end
