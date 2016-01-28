//
//  BNWSectionHeaderView.m
//  BNWMail
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWSectionHeaderView.h"

@interface BNWSectionHeaderView ()

- (IBAction)moreButtonDidClick:(UIButton *)sender;

@end

@implementation BNWSectionHeaderView


- (IBAction)moreButtonDidClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(sectionHeaderMoreButtonDidClick)]) {
        [self.delegate sectionHeaderMoreButtonDidClick];
    }
}
@end
