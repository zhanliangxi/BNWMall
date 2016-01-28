//
//  BNWMainVipViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWMainVipViewController.h"
#import "BNWEverydayViewController.h"
#import "BNWGetRecordViewController.h"
#import "BNWPrerogativeViewController.h"
#import "BNWSystemViewController.h"


@interface BNWMainVipViewController ()<GUITabPagerDataSource,GUITabPagerDelegate>



@property (strong,nonatomic) NSMutableArray *vcList;
@property (strong,nonatomic) NSMutableArray *vcTitleList;
@end

@implementation BNWMainVipViewController

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (NSMutableArray *)vcList{
    if (_vcList == nil) {
        _vcList = [NSMutableArray arrayWithObjects:@"BNWEverydayViewController",@"BNWGetRecordViewController",@"BNWPrerogativeViewController",@"BNWSystemViewController", nil];
    }
    return _vcList;
}

- (NSMutableArray *)vcTitleList{
    if (_vcTitleList == nil) {
        _vcTitleList = [NSMutableArray arrayWithObjects:@"每日领取",@"领取记录",@"功能特权",@"成长体系", nil];
    }
    return _vcTitleList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"我的VIP";
    [self setDataSource:self];
    [self setDelegate:self];
    
    self.labelColor = APP_NAV_BAR_COLOR;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData:self.index];
  
}
- (UIColor *)tabColor {
    
    return RGBCOLOR(42, 163, 73);
}


- (NSInteger)numberOfViewControllers{
    return self.vcList.count;
}
- (UIViewController *)viewControllerForIndex:(NSInteger)index{
    UIViewController *vc = [[NSClassFromString(self.vcList[index]) alloc] init];
    
    return vc;
}
- (NSString *)titleForTabAtIndex:(NSInteger)index {
    return self.vcTitleList[index];
}



@end
