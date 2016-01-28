//
//  BNWMessageCell.h
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWMessage;

@interface BNWMessageCell : UITableViewCell

@property (nonatomic,strong) BNWMessage *message;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
