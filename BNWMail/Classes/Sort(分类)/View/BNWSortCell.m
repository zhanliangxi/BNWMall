//
//  BNWSortCell.m
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWSortCell.h"
#import "UIImageView+WebCache.h"
#import "BNWSort.h"

@interface BNWSortCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation BNWSortCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWSortCell";
    BNWSortCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWSortCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setSort:(BNWSort *)sort
{
    _sort = sort;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:sort.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = sort.cat_name;
    
    self.descLabel.text = sort.cat_id;
}

@end
