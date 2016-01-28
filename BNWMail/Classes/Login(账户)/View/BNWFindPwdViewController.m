//
//  BNWFindPwdViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWFindPwdViewController.h"
#import "BNWLoginViewController.h"
@interface BNWFindPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UIView *findPwdView;

@property (weak, nonatomic) IBOutlet UITextField *newlyPwdField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation BNWFindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)cancel:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    } completion:^(BOOL finished) {
        BNWLoginViewController *loginVc = [BNWLoginViewController new];
        [KEY_WINDOW.rootViewController presentViewController:loginVc animated:YES completion:nil];
    }];
}
- (IBAction)getverifyCodeBtnClick:(id)sender {
    
    [self verifyCodeCheckoutPhoneWith:self.phoneField verifyCodeBtn:sender delegate:self];
    
}
- (IBAction)submitBtn:(id)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"提交"]) {
        [SMS_SDK commitVerifyCode:self.verifyCodeField.text result:^(enum SMS_ResponseState state) {
            if(0 == state){
                [MBProgressHUD showError:@"验证失败"];
                return ;
            }
        }];
        [self.view endEditing:YES];
        [UIView animateWithDuration:1 animations:^{
            self.findPwdView.frame = self.view.bounds;
            [self.view addSubview:self.findPwdView];
        }];
        return;
    }
    
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"完成"]) {
        [self cancel:nil];
    }
    
}
- (IBAction)txtFieldChanged {
    BOOL enable  = (self.phoneField.text.length != 0 && self.verifyCodeField.text.length != 0);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (enable) {
            [self.submitBtn setBackgroundColor:RGBCOLOR(52, 162, 68)];
        }else{
            [self.submitBtn setBackgroundColor:RGBCOLOR(200, 200, 200)];
        }
    });
    self.submitBtn.enabled = enable;
    
    BOOL findEnable = (self.newlyPwdField.text.length!= 0 && self.confirmPwdField.text.length !=0);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (findEnable) {
            [self.finishBtn setBackgroundColor:RGBCOLOR(52, 162, 68)];
        }else{
            [self.finishBtn setBackgroundColor:RGBCOLOR(200, 200, 200)];
        }
    });
    self.finishBtn.enabled = findEnable;
    
}

@end
