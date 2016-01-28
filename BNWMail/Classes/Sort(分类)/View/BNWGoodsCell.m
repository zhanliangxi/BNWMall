//
//  BNWGoodsCell.m
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWGoodsCell.h"
#import "BNWGoods.h"
#import "UIImageView+WebCache.h"

@interface BNWGoodsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)add2Cart;


@end

@implementation BNWGoodsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWGoodsCell";
    BNWGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWGoodsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)setGoods:(BNWGoods *)goods
{
    _goods = goods;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = goods.goods_name;
    
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf",[goods.price doubleValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",goods.shop_price];
    
//    self.infoLabel.text = [NSString stringWithFormat:@"已售%zd 评论%zd",goods.buyCount,goods.reviewCount];
    self.infoLabel.text = [NSString stringWithFormat:@"库存%@件",goods.goods_number];
}

#pragma mark - IBAction
- (IBAction)add2Cart
{
    if ([self.delegate respondsToSelector:@selector(goodsCellDidAdd2Cart:)]) {
        [self.delegate goodsCellDidAdd2Cart:self.goods];
    }
}
@end
