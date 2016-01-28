//
//  BNWEverydayCell.m
//  BNWMail
//
//  Created by 1 on 15/8/8.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWEverydayMenuCell.h"

@implementation BNWEverydayMenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if(selected){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleLabel.textColor = [UIColor whiteColor];
            self.backgroundColor = APP_NAV_BAR_COLOR;
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleLabel.textColor = [UIColor grayColor];
            self.backgroundColor = [UIColor clearColor];
        });
    }
    // Configure the view for the selected state
}

@end
