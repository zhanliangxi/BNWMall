//
//  BNWOrderCell.h
//  BNWMail
//
//  Created by mac on 15/8/7.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWOrder;

@protocol BNWOrderCellDelegate <NSObject>

@optional
- (void)orderCellBuyDidClickWithOrder:(BNWOrder *)order;
- (void)orderCellGoodsDetailDidClickWithOrder:(BNWOrder *)order;
- (void)orderCellOrderDidClickWithOrder:(BNWOrder *)order;

@end

@interface BNWOrderCell : UITableViewCell

@property (nonatomic,weak) id<BNWOrderCellDelegate> delegate;
@property (nonatomic,strong) BNWOrder *order;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
