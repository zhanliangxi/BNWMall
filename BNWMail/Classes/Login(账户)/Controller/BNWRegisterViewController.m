//
//  BNWRegisterViewController.m
//  BNWMail
//
//  Created by 1 on 15/8/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWRegisterViewController.h"
#import "BNWLoginViewController.h"

@interface BNWRegisterViewController ()<MZTimerLabelDelegate>{
    UILabel *timer_show;
}

@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (strong, nonatomic) IBOutlet UIView *succeedView;

@end

@implementation BNWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupShowPwdBtn];
}
- (void)setupShowPwdBtn{
    UIButton *showPwd = [UIButton buttonWithType:UIButtonTypeCustom];
    [showPwd setImage:[UIImage imageNamed:@"login_showPwd"] forState:UIControlStateNormal];
    [showPwd setImage:[UIImage imageNamed:@"login_hiddePWd"] forState:UIControlStateSelected];
    [showPwd setContentMode:UIViewContentModeCenter];
    showPwd.size = CGSizeMake(50, self.pwdField.width);
    [showPwd addTarget:self action:@selector(showPwdBtn:) forControlEvents:UIControlEventTouchDown];
    self.pwdField.rightView = showPwd;
    self.pwdField.keyboardType = UIKeyboardAppearanceDefault;
    self.pwdField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)showPwdBtn:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.pwdField.secureTextEntry = !self.pwdField.isSecureTextEntry;
}

- (IBAction)cancel {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getVerificationCode:(UIButton *)sender {
    [self verifyCodeCheckoutPhoneWith:self.phoneField verifyCodeBtn:sender delegate:self];
}
- (IBAction)txtFieldChanged {
    BOOL enable  = (self.phoneField.text.length != 0 && self.verifyCodeField.text.length != 0 && self.pwdField.text.length != 0);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (enable) {
            [self.regBtn setBackgroundColor:APP_BUTTON_COLOR];
        }else{
            [self.regBtn setBackgroundColor:RGBCOLOR(200, 200, 200)];
        }
    });
     self.regBtn.enabled = enable;
}

- (IBAction)regBtnClick {
    [MBProgressHUD showMessage:@"正在注册.." toView:self.view];
    if (self.pwdField.text.length < 6 || self.pwdField.text.length >= 20) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请输入有效密码范围" toView:self.view];
        return;
    }
    [SMS_SDK commitVerifyCode:self.verifyCodeField.text result:^(enum SMS_ResponseState state) {
        if(0 == state){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"验证失败"];
            return ;
        }
    }];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[phoneNumberKey] = self.phoneField.text;
    params[pwdKey] = self.pwdField.text;
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/user.php?action=register";
    
    [BNWHttpTool post:url params:params success:^(id json) {
        if ([json[@"return_code"] isEqualToString:@"00001"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            BNWAccount *account = [BNWAccount objectWithKeyValues:json];
            [BNWAccountTool saveAccount:account];
            self.succeedView.frame = self.view.bounds;
            [self.view addSubview:self.succeedView];
            [self.view endEditing:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"用户名已存在" toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
      [MBProgressHUD showError:@"请求失败" toView:self.view];
    }];
    
    
}
- (IBAction)returnLogin {
     BNWLoginViewController *loginVc = [BNWLoginViewController new];
    [self animateWithDuration:0.1 didModalTargetVc:loginVc];
}

#pragma mark -MZTimerLabelDelegate

- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeBtn setBackgroundColor:APP_BUTTON_COLOR];
    [self.showTimeLabel removeFromSuperview];
    self.verifyCodeBtn.userInteractionEnabled = YES;
}


@end
