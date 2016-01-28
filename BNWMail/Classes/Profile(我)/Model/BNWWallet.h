//
//  BNWWallet.h
//  BNWMail
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWWallet : NSObject

@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *value;
/**
 *  右边显示样式
 *  0:空白
 *  1:文字
 *  2:箭头
 */
@property (nonatomic,assign) int type;

@end
