//
//  BNWHttpTool.h
//  BNWMail
//
//  Created by iOSLX1 on 15/7/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface BNWHttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))data success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
