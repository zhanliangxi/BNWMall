//
//  BNWCommodityTool.h
//  BNWMail
//
//  Created by 1 on 15/8/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWCommodityTool : NSObject

+ (NSArray *)commoditysWithParams:(NSDictionary *)params;

+ (void)saveCommoditys:(NSArray *)commoditys catId:(NSString *)catId;
@end
