//
//  BNWGoodsDeatil.m
//  BNWMail
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWGoodsDeatil.h"

@implementation BNWGoodsDeatil

- (NSString *)goods_thumb
{
    if (_goods_thumb) {
        return [BNWDomain stringByAppendingString:_goods_thumb];
    } else {
        return _goods_thumb;
    }
}


@end
