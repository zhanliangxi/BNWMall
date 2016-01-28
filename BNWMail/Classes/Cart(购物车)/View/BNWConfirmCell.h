//
//  BNWConfirmCell.h
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWCart;
@class BNWCommodity;

@protocol BNWConfirmCellDelegate <NSObject>

@optional
- (void)confirmCellUpdateDate;
- (void)confirmCellDidClickCart:(BNWCart *)cart;
- (void)confirmCellUpdateGoodsNumberWithCart:(BNWCart *)cart;

@end

@interface BNWConfirmCell : UITableViewCell

@property (nonatomic,strong) BNWCart *cart;

@property (strong,nonatomic)  BNWCommodity *commodity;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) id<BNWConfirmCellDelegate> delegate;

@end
