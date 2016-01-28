//
//  BNWOrderDetailCell.m
//  BNWMail
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWOrderDetailCell.h"
#import "BNWGoods.h"
#import "UIImageView+WebCache.h"

@interface BNWOrderDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
- (IBAction)reviewButtonDidClick;

@end

@implementation BNWOrderDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWOrderDetailCell";
    BNWOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWOrderDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setGoods:(BNWGoods *)goods
{
    _goods = goods;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleView.text = goods.goods_name;
    
    self.priceLable.text = [NSString stringWithFormat:@"￥%@",goods.shop_price];
    
    self.numberLabel.text = [NSString stringWithFormat:@"x%@",goods.goods_number];
    
    if (goods.withoutReview) {
        self.reviewButton.hidden = ![goods.evaluation isEqualToString:@"0"];
    } else {
        self.reviewButton.hidden = YES;
    }
}

- (IBAction)reviewButtonDidClick
{
    if ([self.delegate respondsToSelector:@selector(orderDetailCellReviewButtonDidClickWithGoods:)]) {
        [self.delegate orderDetailCellReviewButtonDidClickWithGoods:self.goods];
    }
}
@end
