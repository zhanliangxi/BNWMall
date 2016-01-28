//
//  BNWSite.h
//  BNWMail
//
//  Created by iOSLX1 on 15/8/14.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWSite : NSObject
/**
 *  上一届ID
 */
@property (copy,nonatomic) NSString *parent_id;
/**
 *  ID
 */
@property (copy,nonatomic) NSString *region_id;
/**
 *  地址名称
 */
@property (copy,nonatomic) NSString *region_name;
/**
 *  类型：1为省 2为市 3为区
 */
@property (copy,nonatomic) NSString *region_type;
@end
