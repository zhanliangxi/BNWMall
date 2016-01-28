//
//  BNWSortCell.h
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWSort;

@interface BNWSortCell : UITableViewCell

@property (nonatomic,strong) BNWSort *sort;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
