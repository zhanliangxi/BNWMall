//
//  BNWMessageCell.m
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWMessageCell.h"
#import "BNWMessage.h"

@interface BNWMessageCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation BNWMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWMessageCell";
    BNWMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setMessage:(BNWMessage *)message
{
    _message = message;
    
    self.titleLabel.text = message.mes_title;
    
    self.dateLabel.text = message.mes_time;
}

@end
