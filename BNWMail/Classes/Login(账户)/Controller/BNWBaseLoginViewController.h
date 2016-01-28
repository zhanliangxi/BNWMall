//
//  BNWBaseLoginViewController.h
//  BNWMail
//
//  Created by iOSLX1 on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMS_SDK/SMS_SDK.h>
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#import "MZTimerLabel.h"
#import "BNWAccountTool.h"
#import "BNWAccount.h"
#import "MJExtension.h"
#import "BNWHttpTool.h"
@interface BNWBaseLoginViewController : UIViewController


@property(strong,nonatomic) UILabel *showTimeLabel;

- (void)animateWithDuration:(NSTimeInterval)duration didModalTargetVc:(id)targetVc;
- (void)verifyCodeCheckoutPhoneWith:(UITextField *)textField verifyCodeBtn:(UIButton *)verifyCodeBtn delegate:(id)delegate;

@end
