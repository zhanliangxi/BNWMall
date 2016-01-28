//
//  BNWGoodsDeatil.h
//  BNWMail
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWGoodsDeatil : NSObject

/**	商品ID */
@property (nonatomic,copy) NSString *goods_id;
/**	所属分类ID */
@property (nonatomic,copy) NSString *cat_id;
/**	商品唯一货号 */
@property (nonatomic,copy) NSString *goods_sn;
/**	商品名称 */
@property (nonatomic,copy) NSString *goods_name;
/**	商品数量 */
@property (nonatomic,copy) NSString *goods_number;
/**	商品价格 */
@property (nonatomic,copy) NSString *shop_price;
/**	商品简述 */
@property (nonatomic,copy) NSString *goods_brief;
/**	商品详细描述 */
@property (nonatomic,copy) NSString *goods_desc;
/**	商品缩略图 */
@property (nonatomic,copy) NSString *goods_thumb;
/**	商品大图 */
@property (nonatomic,copy) NSString *goods_img;
/**
 *  满多少包邮
 */
@property (nonatomic,copy) NSString *f_price_min;

@end
