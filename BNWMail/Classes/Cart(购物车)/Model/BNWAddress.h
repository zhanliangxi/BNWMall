//
//  BNWAddress.h
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWAddress : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *address;

@property (nonatomic,assign,getter = isDefaultAddress) BOOL defaultAddress;

@end
