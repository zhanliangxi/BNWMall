//
//  BNWADImage.m
//  BNWMail
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWADImage.h"

@implementation BNWADImage

- (NSString *)ad_code
{
    if (_ad_code) {
        return [BNWDomain stringByAppendingString:_ad_code];
    } else {
        return _ad_code;
    }
}

@end
