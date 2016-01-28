//
//  BNWEditInfoViewController.m
//  BNWMail
//
//  Created by 1 on 15/8/15.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWEditInfoViewController.h"
#import "BNWAccountTool.h"
#import "BNWHttpTool.h"
#import "MBProgressHUD+MJ.h"
@interface BNWEditInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BNWEditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = [NSString stringWithFormat:@"修改%@",[self.titleLabel substringToIndex:self.titleLabel.length - 1]];
    self.title = str;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
   
    [self.textField becomeFirstResponder];
    
    self.textField.text = self.updateText;
}

- (void)done{
    
    BNWAccount *account  = [BNWAccountTool account];
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=update_mes";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[tokenKey] = account.token;
    params[phoneNumberKey] = account.mobile_phone;
    if ([self.titleLabel isEqualToString:@"昵称:"]) {
        params[@"type"] =  @"2";
        params[@"user_name"] = self.textField.text;
        
        if (self.textField.text.length > 8) {
            [MBProgressHUD showError:@"昵称限制在8个字符" toView:self.view];
            return;
        }
        
        
    }else{
        params[@"type"] =  @"4";
        params[@"new_phone"] = self.textField.text;
    }

    [BNWHttpTool post:url params:params success:^(id json) {
        if ([json[@"return_code"] isEqualToString:@"00001"]) {
            if ([params[@"type"] isEqualToString:@"2"]) {
                NSLog(@"tes");
                account.user_name = self.textField.text;
                [BNWAccountTool saveAccount:account];
            }
            
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败" toView:self.view];
    }];
    
}

@end
