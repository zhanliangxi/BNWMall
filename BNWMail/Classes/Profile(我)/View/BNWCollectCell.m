//
//  BNWCollectCell.m
//  BNWMail
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWCollectCell.h"
#import "UIImageView+WebCache.h"
#import "BNWGoodsDeatil.h"
#import "BNWCollect.h"

@interface BNWCollectCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation BNWCollectCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWCollectCell";
    BNWCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWCollectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setGoods:(BNWGoodsDeatil *)goods
{
    _goods = goods;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = goods.goods_name;
    
    self.priceLable.text = [NSString stringWithFormat:@"￥%@",goods.shop_price];
    
    self.infoLabel.text = [NSString stringWithFormat:@"库存%@件",goods.goods_number];
}

- (void)setCollect:(BNWCollect *)collect
{
    _collect = collect;

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:collect.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = collect.goods_name;
    
    self.priceLable.text = [NSString stringWithFormat:@"￥%@",collect.shop_price];
    
    self.infoLabel.text = [NSString stringWithFormat:@""];
}


@end
