//
//  BNWOrderDetailCell.h
//  BNWMail
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWGoods;

@protocol OrderDetailCellDelegate <NSObject>

@optional
- (void)orderDetailCellReviewButtonDidClickWithGoods:(BNWGoods *)goods;

@end

@interface BNWOrderDetailCell : UITableViewCell

@property (nonatomic,strong) BNWGoods *goods;
@property (nonatomic,weak) id<OrderDetailCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
