//
//  BNWBaseLoginViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWBaseLoginViewController.h"



@interface BNWBaseLoginViewController ()

@end

@implementation BNWBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)animateWithDuration:(NSTimeInterval)duration didModalTargetVc:(id)targetVc{
    [UIView animateWithDuration:duration animations:^{
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
    } completion:^(BOOL finished) {
        [KEY_WINDOW.rootViewController presentViewController:targetVc animated:YES completion:nil];
    }];
}

- (void)verifyCodeCheckoutPhoneWith:(UITextField *)textField verifyCodeBtn:(UIButton *)verifyCodeBtn delegate:(id)delegate{
    if ([self isMobileNumber:textField.text]) {
        [SMS_SDK getVerificationCodeBySMSWithPhone:textField.text zone:@"86" result:^(SMS_SDKError *error) {
            if (error == nil) {
                [self timeCount:verifyCodeBtn delegate:delegate];
            }else{
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                              message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                    otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }else{
        [MBProgressHUD showError:@"请输入有效号码"];
    }
}
- (void)timeCount:(UIButton *)verifyCodeBtn delegate:(id)delegate{
    [verifyCodeBtn setTitle:nil forState:UIControlStateNormal];
    [verifyCodeBtn setBackgroundColor:RGBCOLOR(200, 200, 200)];
    self.showTimeLabel = [[UILabel alloc] init];
    [verifyCodeBtn addSubview:self.showTimeLabel];
    [self.showTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.showTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.showTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.showTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];

    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:self.showTimeLabel andTimerType:MZTimerLabelTypeTimer];
    [timer_cutDown setCountDownTime:60];
    timer_cutDown.timeFormat = @"ss后可重获验证码";
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;
    timer_cutDown.delegate = delegate;
    verifyCodeBtn.userInteractionEnabled = NO;
    [timer_cutDown start];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)validatePassword:(NSString *)passWord
{
    //(?=^.{8,}$)(?=.*\d)(?=.*\W+)(?=.*[A-Z])(?=.*[a-z])(?!.*\n).*$
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
@end
