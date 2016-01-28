//
//  BNWLocationTool.h
//  BNWMail
//
//  Created by mac on 15/8/11.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNWLocationCity.h"

@interface BNWLocationTool : NSObject

+ (void)saveCity:(BNWLocationCity *)city;

+ (BNWLocationCity *)city;

@end
