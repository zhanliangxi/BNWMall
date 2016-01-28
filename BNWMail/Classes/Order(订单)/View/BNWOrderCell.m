//
//  BNWOrderCell.m
//  BNWMail
//
//  Created by mac on 15/8/7.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWOrderCell.h"
#import "BNWOrder.h"
#import "UIImageView+WebCache.h"
#import "BNWGoods.h"

@interface BNWOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@property (weak, nonatomic) IBOutlet UIButton *payButton;
- (IBAction)payButtonDidClick;

/** 商品详情 */
- (IBAction)goodsDetailDidClick;
- (IBAction)orderDidClick;



@end

@implementation BNWOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWOrderCell";
    BNWOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setOrder:(BNWOrder *)order
{
    _order = order;
    
    self.orderNumberLabel.text = order.order_sn;
    
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",order.order_amount];
    
    self.orderDateLabel.text = order.add_time;
    
    BNWGoods *goods = [order.goods firstObject];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = goods.goods_name;
    
    // 订单状态
    self.orderStateLabel.text = order.pay_status;
    
    // 按钮状态
    if ([order.pay_status isEqualToString:@"待付款"]) {
        
        [self.payButton setTitle:@"付款" forState:UIControlStateNormal];
        
    } else if ([order.pay_status isEqualToString:@"已发货"]) {
        
        [self.payButton setTitle:@"确认收货" forState:UIControlStateNormal];
        
    } else if ([order.pay_status isEqualToString:@"待评价"]) {
        
        [self.payButton setTitle:@"评价" forState:UIControlStateNormal];
        
    } else if ([order.pay_status isEqualToString:@"已完成"]) {
        
        [self.payButton setTitle:@"已完成" forState:UIControlStateNormal];
        
    }
}

#pragma mark - IBAction
- (IBAction)payButtonDidClick
{
    if ([self.delegate respondsToSelector:@selector(orderCellBuyDidClickWithOrder:)]) {
        [self.delegate orderCellBuyDidClickWithOrder:self.order];
    }
}

- (IBAction)goodsDetailDidClick
{
    if ([self.delegate respondsToSelector:@selector(orderCellGoodsDetailDidClickWithOrder:)]) {
        [self.delegate orderCellGoodsDetailDidClickWithOrder:self.order];
    }
}

- (IBAction)orderDidClick
{
    if ([self.delegate respondsToSelector:@selector(orderCellOrderDidClickWithOrder:)]) {
        [self.delegate orderCellOrderDidClickWithOrder:self.order];
    }
}
@end
