//
//  BNWGoods.h
//  BNWMail
//
//  Created by 1 on 15/8/8.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWCommodity : NSObject


@property (copy,nonatomic) NSString *goods_id;
@property (copy,nonatomic) NSString *goods_name;
@property (copy,nonatomic) NSString *is_get_integral;
@property (copy,nonatomic) NSString *goods_thumb;

@property (copy,nonatomic) NSString *goods_number;

/**
 *  选中
 */
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end
