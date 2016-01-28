//
//  BNWBecomVipCell.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWBecomVipCell.h"

@implementation BNWBecomVipCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        dispatch_async(dispatch_get_main_queue(), ^{
           self.accessoryType = UITableViewCellAccessoryCheckmark;
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
           self.accessoryType = UITableViewCellAccessoryNone;
        });
    }
}

@end
