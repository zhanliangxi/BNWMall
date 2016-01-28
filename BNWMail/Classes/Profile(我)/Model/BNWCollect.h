//
//  BNWCollect.h
//  BNWMail
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWCollect : NSObject

/**	商品唯一货号 */
@property (nonatomic,copy) NSString *goods_sn;
/**	商品图片缩略图 */
@property (nonatomic,copy) NSString *goods_thumb;
/**	商品简介 */
@property (nonatomic,copy) NSString *good_brief;
/**	商品价格 */
@property (nonatomic,copy) NSString *shop_price;
/**	商品名称 */
@property (nonatomic,copy) NSString *goods_name;
/**	促销价 */
@property (nonatomic,copy) NSString *promote_price;

/**	id */
@property (nonatomic,copy) NSString *rec_id;
/**	用户ID */
@property (nonatomic,copy) NSString *user_id;
/**	商品id */
@property (nonatomic,copy) NSString *goods_id;
/**	收藏时间 */
@property (nonatomic,copy) NSString *add_time;
/**	是否关注该收藏 */
@property (nonatomic,copy) NSString *is_attention;
/**	用户手机号码 */
@property (nonatomic,copy) NSString *mobile_phone;

@end
