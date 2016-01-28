//
//  BNWCollectCell.h
//  BNWMail
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWGoodsDeatil;
@class BNWCollect;

@interface BNWCollectCell : UITableViewCell

@property (nonatomic,strong) BNWGoodsDeatil *goods;
@property (nonatomic,strong) BNWCollect *collect;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
