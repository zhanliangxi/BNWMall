//
//  BNWCart.m
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWCart.h"

@implementation BNWCart

- (NSString *)goods_thumbs
{
    if (_goods_thumbs) {
        return [BNWDomain stringByAppendingString:_goods_thumbs];
    } else {
        return _goods_thumbs;
    }
}

@end
