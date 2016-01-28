//
//  BNWOrderTabPageViewController.m
//  BNWMail
//
//  Created by mac on 15/8/7.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWOrderTabPageViewController.h"
#import "BNWAllOrderViewController.h"
#import "BNWPaymentViewController.h"
#import "BNWDeliveredViewController.h"
#import "BNWWaitReviewViewController.h"
#import "BNWCompletedViewController.h"

@interface BNWOrderTabPageViewController () <GUITabPagerDataSource,GUITabPagerDelegate>

@property (strong,nonatomic) NSMutableArray *vcList;
@property (strong,nonatomic) NSMutableArray *vcTitleList;

@end

@implementation BNWOrderTabPageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    self.labelColor = APP_NAV_BAR_COLOR;
    self.view.backgroundColor = APP_BG_COLOR;
    
    self.title = @"我的订单";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData:self.index];
}

- (CGFloat)tabHeight
{
    return 44;
}

- (UIColor *)tabColor
{
    return APP_NAV_BAR_COLOR;
}

- (NSInteger)numberOfViewControllers
{
    return self.vcList.count;
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index
{
    UIViewController *vc = [[NSClassFromString(self.vcList[index]) alloc] init];
    
    return vc;
}

- (NSString *)titleForTabAtIndex:(NSInteger)index
{
    return self.vcTitleList[index];
}

//- (void)tabPager:(GUITabPagerViewController *)tabPager willTransitionToTabAtIndex:(NSInteger)index
//{
//    NSLog(@"Will transition from tab %ld to %ld", [self selectedIndex], (long)index);
//}
//
//- (void)tabPager:(GUITabPagerViewController *)tabPager didTransitionToTabAtIndex:(NSInteger)index
//{
//    NSLog(@"Did transition to tab %ld", (long)index);
//}

#pragma mark - 懒加载
- (NSMutableArray *)vcList{
    if (_vcList == nil) {
        _vcList = [NSMutableArray arrayWithObjects:@"BNWAllOrderViewController",@"BNWPaymentViewController",@"BNWDeliveredViewController",@"BNWWaitReviewViewController", @"BNWCompletedViewController" ,nil];
    }
    return _vcList;
}

- (NSMutableArray *)vcTitleList{
    if (_vcTitleList == nil) {
        _vcTitleList = [NSMutableArray arrayWithObjects:@"全部订单",@"待付款",@"已发货",@"待评价",@"已完成", nil];
    }
    return _vcTitleList;
}

@end
