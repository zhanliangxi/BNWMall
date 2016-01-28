//
//  YFLoginViewController.m
//  YFCustomer
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWLoginViewController.h"
#import "BNWRegisterViewController.h"
#import "BNWFindPwdViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface BNWLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIView *findPwd;
@end

@implementation BNWLoginViewController

- (void)viewDidLoad
{
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)findPwdBtnClick {
     BNWFindPwdViewController *findPwdVc = [BNWFindPwdViewController new];
    [self animateWithDuration:0.1 didModalTargetVc:findPwdVc];
}
- (IBAction)instantRegBtnClick {
    BNWRegisterViewController *regVc = [BNWRegisterViewController new];
    [self animateWithDuration:0.1 didModalTargetVc:regVc];
}

- (IBAction)login
{
    
    [MBProgressHUD showMessage:@"正在登陆.." toView:self.view];
    
    NSString *getSaltUrl = @"http://ecshop.dadazu.com/new_api/inc/user.php?action=get_salt";
    NSMutableDictionary *saltParams = [NSMutableDictionary dictionary];
    saltParams[phoneNumberKey] = self.phoneField.text;
    [BNWHttpTool post:getSaltUrl params:saltParams success:^(id json) {
        NSString *ec_salt = json[@"ec_salt"];
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/user.php?action=login";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[phoneNumberKey] = self.phoneField.text;
        params[pwdKey] = [self md5:[NSString stringWithFormat:@"%@%@",[self md5:self.pwdField.text],ec_salt]];
        [BNWHttpTool post:url params:params success:^(id json) {
            NSLog(@"json:%@",json);
            if ([json[@"return_code"] isEqualToString:@"00001"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                BNWAccount *account = [BNWAccount objectWithKeyValues:json];
                [BNWAccountTool saveAccount:account];
                [MBProgressHUD showSuccess:@"登陆成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self cancel];
                });
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:@"手机号码或密码错误" toView:self.view];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"请求失败" toView:self.view];
          
        }];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请求失败或号码不存在" toView:self.view];
    }];
    
    

}

- (IBAction)txtFieldChanged {
    BOOL enable  = (self.phoneField.text.length != 0 && self.pwdField.text.length != 0);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (enable) {
            [self.loginBtn setBackgroundColor:RGBCOLOR(52, 162, 68)];
        }else{
            [self.loginBtn setBackgroundColor:RGBCOLOR(200, 200, 200)];
        }
    });
    self.loginBtn.enabled = enable;
}


- (NSString *)md5:(NSString *)str{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ]; 
    
}
@end
