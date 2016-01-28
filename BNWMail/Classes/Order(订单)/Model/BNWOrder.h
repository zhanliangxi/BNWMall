//
//  BNWOrder.h
//  BNWMail
//
//  Created by mac on 15/8/7.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWOrder : NSObject

/** 订单id */
@property (nonatomic,copy) NSString *order_id;
/** 收件人 */
@property (nonatomic,copy) NSString *consignee;
/** 订单号 */
@property (nonatomic,copy) NSString *order_sn;
/** 订单状态 */
@property (nonatomic,copy) NSString *pay_status;
/** 手机号码 */
@property (nonatomic,copy) NSString *mobile;
/** 省 */
@property (nonatomic,copy) NSString *province;
/** 详细地址 */
@property (nonatomic,copy) NSString *address;
/** 备注 */
@property (nonatomic,copy) NSString *remark;
/** 市 */
@property (nonatomic,copy) NSString *city;
/** 邮费 */
@property (nonatomic,copy) NSString *shipping_fee;
/** 订单总额 */
@property (nonatomic,copy) NSString *order_amount;
/** 区 */
@property (nonatomic,copy) NSString *district;
/** 订单时间 */
@property (nonatomic,copy) NSString *add_time;
/** 商品金额 */
@property (nonatomic,copy) NSString *goods_amount;
/** 商品数组 */
@property (nonatomic,strong) NSArray *goods;

/**
 *  是否未评价
 */
@property (nonatomic,assign,getter=isWithoutReview) BOOL withoutReview;
/**
 *  支付id
 */
@property (nonatomic,copy) NSString *pay_id;

@end
