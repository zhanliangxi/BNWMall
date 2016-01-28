//
//  BNWCartCell.h
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWCart;

@protocol BNWCartCellDelegate <NSObject>

@optional
- (void)cartCellUpdateData;
- (void)cartCellSelectStateChange;
- (void)cartCellDeleteWithCart:(BNWCart *)cart;
- (void)cartCellUpdateGoodsNumberWithCart:(BNWCart *)cart;
@end

@interface BNWCartCell : UITableViewCell

@property (nonatomic,strong) BNWCart *cart;

@property (nonatomic,weak) id<BNWCartCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
