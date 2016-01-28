//
//  BNWTabBarViewController.m
//  BNWMail
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWTabBarViewController.h"
#import "BNWNavigationViewController.h"

#import "BNWHomeViewController.h"
#import "BNWSortViewController.h"
#import "BNWVipViewController.h"
#import "BNWCartViewController.h"
#import "BNWProfileViewController.h"

@interface BNWTabBarViewController ()

@end

@implementation BNWTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.初始化子控制器
    BNWHomeViewController *home = [[BNWHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    BNWSortViewController *sort = [[BNWSortViewController alloc] init];
    [self addChildVc:sort title:@"分类" image:@"tabbar_sort" selectedImage:@"tabbar_sort_selected"];
    
    BNWVipViewController *vip = [[BNWVipViewController alloc] init];
    [self addChildVc:vip title:@"VIP" image:@"tabbar_vip" selectedImage:@"tabbar_vip_selected"];
    
    BNWCartViewController *cart = [[BNWCartViewController alloc] init];
    [self addChildVc:cart title:@"购物车" image:@"tabbar_cart" selectedImage:@"tabbar_cart_selected"];
    
    BNWProfileViewController *profile = [[BNWProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    // 2.更换系统自带的tabbar
//    HWTabBar *tabBar = [[HWTabBar alloc] init];
//    [self setValue:tabBar forKeyPath:@"tabBar"];
    /*
     [self setValue:tabBar forKeyPath:@"tabBar"];相当于self.tabBar = tabBar;
     [self setValue:tabBar forKeyPath:@"tabBar"];这行代码过后，tabBar的delegate就是HWTabBarViewController
     说明，不用再设置tabBar.delegate = self;
     */
    
    /*
     1.如果tabBar设置完delegate后，再执行下面代码修改delegate，就会报错
     tabBar.delegate = self;
     
     2.如果再次修改tabBar的delegate属性，就会报下面的错误
     错误信息：Changing the delegate of a tab bar managed by a tab bar controller is not allowed.
     错误意思：不允许修改TabBar的delegate属性(这个TabBar是被TabBarViewController所管理的)
     */
    
//    self.tabBar.barTintColor = [UIColor whiteColor];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = APP_NAV_BAR_COLOR;
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    BNWNavigationViewController *nav = [[BNWNavigationViewController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}
@end
