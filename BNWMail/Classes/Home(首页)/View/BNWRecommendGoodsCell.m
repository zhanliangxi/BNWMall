//
//  BNWRecommendGoodsCell.m
//  BNWMail
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWRecommendGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "BNWHomeDeal.h"
#import "BNWHomeGoods.h"

@interface BNWRecommendGoodsCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;


@end

@implementation BNWRecommendGoodsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDeal:(BNWHomeDeal *)deal
{
    _deal = deal;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:deal.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)setGoods:(BNWHomeGoods *)goods
{
    _goods = goods;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end
