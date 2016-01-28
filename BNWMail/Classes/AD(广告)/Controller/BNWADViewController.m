//
//  BNWADViewController.m
//  BNWMail
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWADViewController.h"
#import "BNWHttpTool.h"
#import "UIImageView+WebCache.h"
#import "BNWADImage.h"
#import "MJExtension.h"

@interface BNWADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BNWADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=home_ad";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"2";
    
    [BNWHttpTool post:url params:params success:^(id json) {
        NSMutableArray *adList = [BNWADImage objectArrayWithKeyValuesArray:json];
        BNWADImage *ad = [adList firstObject];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:ad.ad_code] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


@end
