//
//  YFAccount.m
//  YFCustomer
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWAccount.h"
#import "MJExtension.h"

@implementation BNWAccount

MJCodingImplementation


/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.mobile_phone forKey:@"mobile_phone"];
//    [encoder encodeObject:self.password forKey:@"password"];
//    [encoder encodeObject:self.token forKey:@"token"];
//    [encoder encodeObject:self.user_id forKey:@"user_id"];
//}
//
///**
// *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
// *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
// */
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        self.mobile_phone = [decoder decodeObjectForKey:@"mobile_phone"];
//        self.password = [decoder decodeObjectForKey:@"password"];
//        self.token = [decoder decodeObjectForKey:@"token"];
//        self.user_id = [decoder decodeObjectForKey:@"user_id"];
//    }
//    return self;
//}
@end
