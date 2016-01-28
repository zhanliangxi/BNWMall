//
//  BNWMoreDeal.m
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWMoreDeal.h"

@implementation BNWMoreDeal

- (NSString *)goods_thumb
{
    if (_goods_thumb) {
        return [BNWDomain stringByAppendingString:_goods_thumb];
    } else {
        return _goods_thumb;
    }
}

//- (NSString *)start_time
//{
//    return @"2015-08-12 12:00:00";
//}
//
//- (NSString *)end_time
//{
//    return @"2015-09-01 12:00:00";
//}

@end
