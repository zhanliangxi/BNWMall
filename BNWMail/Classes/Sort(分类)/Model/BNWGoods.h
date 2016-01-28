//
//  BNWGoods.h
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWGoods : NSObject

/**	商品库存 */
@property (nonatomic,copy) NSString *goods_number;
/**	商品价格 */
@property (nonatomic,copy) NSString *shop_price;
/**	缩略图 */
@property (nonatomic,copy) NSString *goods_thumb;
/**	商品简述 */
@property (nonatomic,copy) NSString *goods_brief;
/**	商品id */
@property (nonatomic,copy) NSString *goods_id;
/**	商品名 */
@property (nonatomic,copy) NSString *goods_name;

/**
 *  是否未评价
 */
@property (nonatomic,assign,getter=isWithoutReview) BOOL withoutReview;
/**	订单商品id */
@property (nonatomic,copy) NSString *rec_id;
/** 没有评价 */
@property (nonatomic,copy) NSString *evaluation;

@end
