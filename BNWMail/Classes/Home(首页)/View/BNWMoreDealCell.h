//
//  BNWMoreDealCell.h
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWMoreDeal;

@protocol BNWMoreDealCellDelegate <NSObject>

- (void)moreDealBuyButtonDidClickWithDeal:(BNWMoreDeal *)deal;

@end

@interface BNWMoreDealCell : UITableViewCell

@property (nonatomic,strong) BNWMoreDeal *moreDeal;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) id<BNWMoreDealCellDelegate> delegate;

@end
