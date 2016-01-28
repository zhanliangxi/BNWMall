//
//  UIBarButtonItem+BNWBarButtonItem.m
//  BNWMail
//
//  Created by yangjia on 15/8/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "UIBarButtonItem+BNWBarButtonItem.h"

@implementation UIBarButtonItem (BNWBarButtonItem)

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action doneTextColor:(UIColor *)color {
    id myBarButtonItem = [self initWithBarButtonSystemItem:systemItem target:target action:action];
    if (systemItem == UIBarButtonSystemItemDone) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button.layer setCornerRadius:4.0f];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        if (color == nil) {
            color = [UIColor blackColor];
        }
        [button.layer setBorderColor: [[UIColor clearColor] CGColor]];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        return doneItem;
    }
    return myBarButtonItem;
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action doneTextColor:(UIColor *)color {
    id myBarButtonItem = [self initWithTitle:title style:style target:target action:action];
    if (style == UIBarButtonSystemItemDone) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button.layer setCornerRadius:4.0f];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        if (color == nil) {
            color = [UIColor blackColor];
        }
        [button.layer setBorderColor: [[UIColor clearColor] CGColor]];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        return doneItem;
    }
    return myBarButtonItem;
}

@end
