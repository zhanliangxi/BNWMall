//
//  UIBarButtonItem+BNWBarButtonItem.h
//  BNWMail
//
//  Created by yangjia on 15/8/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BNWBarButtonItem)

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action doneTextColor:(UIColor *)color;

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action doneTextColor:(UIColor *)color;

@end
