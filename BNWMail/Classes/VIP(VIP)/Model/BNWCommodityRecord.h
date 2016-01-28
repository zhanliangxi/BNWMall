//
//  BNWCommodityRecord.h
//  BNWMail
//
//  Created by iOSLX1 on 15/8/25.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWCommodityRecord : NSObject
/**
 *  重量
 */
@property (copy,nonatomic) NSString *is_get_weight;
/**
 *  数量
 */
@property (copy,nonatomic) NSString *goods_number;
/**
 *  商品名称
 */
@property (copy,nonatomic) NSString *goods_name;
/**
 *  单件节省金额
 */
@property (copy,nonatomic) NSString *is_get_price;
@end
