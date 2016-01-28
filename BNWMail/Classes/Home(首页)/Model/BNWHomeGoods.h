//
//  BNWHomeGoods.h
//  BNWMail
//
//  Created by 杨育彬 on 15/8/11.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWHomeGoods : NSObject

/**	促销开始时间 */
@property (nonatomic,copy) NSString *promote_start_date;
/**	缩略图 */
@property (nonatomic,copy) NSString *goods_thumb;
/**	推荐(热销) */
@property (nonatomic,copy) NSString *is_hot;
/**	商品ID */
@property (nonatomic,copy) NSString *goods_id;
/**	商品名称 */
@property (nonatomic,copy) NSString *goods_name;

@end
