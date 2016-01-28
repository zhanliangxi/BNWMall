//
//  BNWUnLoginViewController.m
//  BNWMail
//
//  Created by 杨育彬 on 15/8/2.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWUnLoginViewController.h"
#import "BNWLoginViewController.h"
#import "BNWRegisterViewController.h"

@interface BNWUnLoginViewController ()

- (IBAction)registerDidClick;

- (IBAction)loginDidClick;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation BNWUnLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    
    self.messageLabel.text = message;
}

- (IBAction)registerDidClick {
    BNWRegisterViewController *regVc = [[BNWRegisterViewController alloc] init];
    [KEY_WINDOW.rootViewController presentViewController:regVc animated:YES completion:nil];
    
}

- (IBAction)loginDidClick {
    BNWLoginViewController *loginVc = [BNWLoginViewController new];
    [KEY_WINDOW.rootViewController presentViewController:loginVc animated:YES completion:nil];
}

@end
