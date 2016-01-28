//
//  BNWEditPwdViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/13.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWEditPwdViewController.h"
#import "BNWHttpTool.h"
#import "BNWAccountTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD+MJ.h"
@interface BNWEditPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;


@end

@implementation BNWEditPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = [NSString stringWithFormat:@"修改%@密码",self.titleLabel];
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


- (IBAction)updatePwd:(id)sender {
    if ([self.titleLabel isEqualToString:@"登录"]) {
        [self resetPwd];
    }
}
- (void)resetPwd{

    if (self.pwdField.text.length <6 || self.pwdField.text.length >= 20) {
        [MBProgressHUD showError:@"请输入有效密码范围" toView:self.view];
        return;
    }
    
    if (![self.pwdField.text isEqualToString:self.confirmPwdField.text]) {
        [MBProgressHUD showError:@"密码不一致" toView:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在修改.." toView:self.view];
    BNWAccount *account = [BNWAccountTool account];
    NSString *getSaltUrl = @"http://ecshop.dadazu.com/new_api/inc/user.php?action=retrieve";
    NSMutableDictionary *saltParams = [NSMutableDictionary dictionary];
    saltParams[phoneNumberKey] = account.mobile_phone;
    [BNWHttpTool post:getSaltUrl params:saltParams success:^(id json) {
        NSString *ec_salt = [NSString stringWithFormat:@"%@lijiawei",json[@"ec_salt"]];
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/user.php?action=reset_pwd";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[phoneNumberKey] = account.mobile_phone;
        params[pwdKey] = self.pwdField.text;
        params[@"vcode"] = [self md5:ec_salt];
        [BNWHttpTool post:url params:params success:^(id json) {
            
            if ([json[@"return_code"] isEqualToString:@"00001"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showSuccess:@"修改成功,请重新登陆" toView:self.view];
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                [fileMgr removeItemAtPath:BNWAccountPath error:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"1%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"请求失败" toView:self.view];
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"2%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请求失败" toView:self.view];
    }];
    
    
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
