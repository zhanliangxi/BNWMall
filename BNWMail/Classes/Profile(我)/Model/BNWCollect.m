//
//  BNWCollect.m
//  BNWMail
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWCollect.h"

@implementation BNWCollect
- (NSString *)goods_thumb
{
    if (_goods_thumb) {
        return [BNWDomain stringByAppendingString:_goods_thumb];
    } else {
        return _goods_thumb;
    }
}
@end
