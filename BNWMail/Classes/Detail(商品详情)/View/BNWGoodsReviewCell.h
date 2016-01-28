//
//  BNWGoodsReviewCell.h
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWGoodsReview;

@interface BNWGoodsReviewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) BNWGoodsReview *goodsReview;
@end
