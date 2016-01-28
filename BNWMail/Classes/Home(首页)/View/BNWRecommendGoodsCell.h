//
//  BNWRecommendGoodsCell.h
//  BNWMail
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWHomeDeal;
@class BNWHomeGoods;

@interface BNWRecommendGoodsCell : UICollectionViewCell

@property (nonatomic,strong) BNWHomeDeal *deal;
@property (nonatomic,strong) BNWHomeGoods *goods;

@end
