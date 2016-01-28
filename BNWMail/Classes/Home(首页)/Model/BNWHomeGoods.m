//
//  BNWHomeGoods.m
//  BNWMail
//
//  Created by 杨育彬 on 15/8/11.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWHomeGoods.h"

@implementation BNWHomeGoods

- (NSString *)goods_thumb
{
    if (_goods_thumb) {
        return [BNWDomain stringByAppendingString:_goods_thumb];
    } else {
        return _goods_thumb;
    }
}

@end
