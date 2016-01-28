//
//  BNWPrerogativeViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWPrerogativeViewController.h"
#import "HCSStarRatingView.h"
#import "BNWAccountTool.h"
#import "UIImageView+WebCache.h"

@interface BNWPrerogativeViewController ()
@property (weak, nonatomic) IBOutlet HCSStarRatingView *vipView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BNWPrerogativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.vipView.value = 1;
    
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = _iconView.width * 0.5;
    
    BNWAccount *account = [BNWAccountTool account];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecshop.dadazu.com/%@",account.user_thum]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = account.user_name;
    self.vipView.value = account.user_rank.integerValue;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
