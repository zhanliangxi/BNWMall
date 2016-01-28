//
//  BNWCart.h
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BNWCart : NSObject

///** 商品模型 */
//@property (nonatomic,strong) BNWGoods *goods;
///** 商品数量 */
//@property (nonatomic,assign) NSInteger number;


/**	用户删除返回 */
@property (nonatomic,copy) NSString *rec_id;
/**	商品ID */
@property (nonatomic,copy) NSString *goods_id;
/**	商品名称 */
@property (nonatomic,copy) NSString *goods_name;
/**	商品价格 */
@property (nonatomic,copy) NSString *goods_price;
/**	商品数量 */
@property (nonatomic,copy) NSString *goods_number;
/**	商品图片缩略图地址 */
@property (nonatomic,copy) NSString *goods_thumbs;

/** 选中 */
@property (nonatomic,assign,getter=isSelected) BOOL selected;

@end
