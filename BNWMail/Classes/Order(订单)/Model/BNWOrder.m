//
//  BNWOrder.m
//  BNWMail
//
//  Created by mac on 15/8/7.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWOrder.h"
#import "MJExtension.h"
#import "BNWGoods.h"

@implementation BNWOrder

+ (NSDictionary *)objectClassInArray
{
    return @{@"goods" : [BNWGoods class]};
}

- (NSString *)pay_status
{
    if ([_pay_status isEqualToString:@"0"]) {
        return @"待付款";
    } else if ([_pay_status isEqualToString:@"1"]) {
        return @"已发货";
    } else if ([_pay_status isEqualToString:@"2"]) {
        return @"待评价";
    } else {
        return @"已完成";
    }
}


@end
