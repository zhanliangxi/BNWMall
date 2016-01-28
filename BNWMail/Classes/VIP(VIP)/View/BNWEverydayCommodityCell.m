//
//  BNWEverydayCommodityCell.m
//  BNWMail
//
//  Created by 1 on 15/8/8.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWEverydayCommodityCell.h"
#import "UIImageView+WebCache.h"

@interface BNWEverydayCommodityCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *integral;

@property (assign,nonatomic) BOOL selState;
@end

@implementation BNWEverydayCommodityCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setGoods:(BNWCommodity *)goods{
    _goods = goods;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = goods.goods_name;
//    self.integral.text = [NSString stringWithFormat:@"所需积分:%@分",goods.is_get_integral];
    self.integral.text = @"所需积分:200分";
    goods.goods_number = @"1";
    goods.is_get_integral = @"200";
    if (goods.isSelected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.getView.image = [UIImage imageNamed:@"check_sel"];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.getView.image = [UIImage imageNamed:@"check"];
        });
    }
}



@end
