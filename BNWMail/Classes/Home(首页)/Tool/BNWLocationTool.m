//
//  BNWLocationTool.m
//  BNWMail
//
//  Created by mac on 15/8/11.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWLocationTool.h"

// 定位的存储路径
#define BNWLocationPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"location.archive"]

@implementation BNWLocationTool

+ (void)saveCity:(BNWLocationCity *)city
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:city toFile:BNWLocationPath];
}

+ (BNWLocationCity *)city
{
    // 加载模型
    BNWLocationCity *city = [NSKeyedUnarchiver unarchiveObjectWithFile:BNWLocationPath];
    
    
    return city;
}

@end
