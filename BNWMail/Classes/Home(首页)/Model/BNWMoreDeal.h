//
//  BNWMoreDeal.h
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWMoreDeal : NSObject

//@property (nonatomic,copy) NSString *icon;
//
//@property (nonatomic,copy) NSString *title;
//
///** 原价 */
//@property (nonatomic,strong) NSNumber *originalPrice;
///** 现价 */
//@property (nonatomic,strong) NSNumber *currentPrice;
///** 剩下数量 */
//@property (nonatomic,assign) NSInteger leftCount;
///** 团购开始时间 */
//@property (nonatomic,copy) NSString *startTime;
///** 团购持续时间 / 天*/
//@property (nonatomic,copy) NSString *duration;


/**	商品数量 */
@property (nonatomic,copy) NSString *goods_number;
/**	开始世界 */
@property (nonatomic,copy) NSString *start_time;
/**	商品ID */
@property (nonatomic,copy) NSString *goods_id;
/**	商品名称 */
@property (nonatomic,copy) NSString *goods_name;
/**	原价 */
@property (nonatomic,copy) NSString *shop_price;
/**	现价 */
@property (nonatomic,copy) NSString *promote_price;
/**	商品简介 */
@property (nonatomic,copy) NSString *goods_brief;
/**	商品缩略图 */
@property (nonatomic,copy) NSString *goods_thumb;
/**	结束时间 */
@property (nonatomic,copy) NSString *end_time;

@end
