//
//  BNWProfileViewController.m
//  BNWMail
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWProfileViewController.h"

#import "BNWUnLoginViewController.h"
#import "BNWAccountTool.h"
#import "BNWAccount.h"
#import "BNWOrderTabPageViewController.h"
#import "BNWPersonalDataViewController.h"
#import "BNWHttpTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "HCSStarRatingView.h"
#import "BNWSettingViewController.h"
#import "BNWWalletViewController.h"
#import "BNWCollectViewController.h"

@interface BNWProfileViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BNWUnLoginViewController *unloginVc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *profileList;
@property (strong, nonatomic) IBOutlet UIView *sectionFooterView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *vipView;

@property (strong,nonatomic) BNWAccount *account;
/** 待付款 */
- (IBAction)orderBarOne;
/** 已发货 */
- (IBAction)orderBarTwo;
/** 已完成 */
- (IBAction)orderBarThree;
/** 晒单评价 */
- (IBAction)orderBarFour;

@end

@implementation BNWProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = self.headerView;
    
    self.iconView.layer.cornerRadius = _iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
    self.tableView.delegate = self;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BNWAccount *account = [BNWAccountTool account];
    if (account) { // 之前已经登录成功过
        [self.unloginVc.view removeFromSuperview];
        NSLog(@"test");
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=my_mes";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[phoneNumberKey] = account.mobile_phone;
        params[tokenKey] = account.token;
        [BNWHttpTool post:url params:params success:^(id json) {
        self.account  = [BNWAccount objectWithKeyValues:json];
           
            if (account.user_thum) {
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecshop.dadazu.com/%@",account.user_thum]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                 self.nameLabel.text = account.user_name;
                 self.vipView.value = account.user_rank.integerValue;
            }else{
               [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecshop.dadazu.com/%@",self.account.user_thum]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                 self.nameLabel.text = self.account.user_name;
                 self.vipView.value = self.account.user_rank.integerValue;
                
                account.user_thum = self.account.user_thum;
                account.user_name = self.account.user_name;
                account.user_rank = self.account.user_rank;
                
                [BNWAccountTool saveAccount:account];
            }
           
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求失败" toView:self.view];
        }];

        
    } else {
        [self.view addSubview:self.unloginVc.view];
    }
}

#pragma mark Gesture Action
- (IBAction)tapWithPersonalData:(UITapGestureRecognizer *)sender {
    BNWPersonalDataViewController *personalDataVc  = [BNWPersonalDataViewController new];
    [self.navigationController pushViewController:personalDataVc animated:YES];
}

#pragma mark - IBActions
/** 待付款 */
- (IBAction)orderBarOne
{
    BNWOrderTabPageViewController *tabVc = [BNWOrderTabPageViewController new];
    tabVc.index = 1;
    [self.navigationController pushViewController:tabVc animated:YES];
}

/** 已发货 */
- (IBAction)orderBarTwo
{
    BNWOrderTabPageViewController *tabVc = [BNWOrderTabPageViewController new];
    tabVc.index = 2;
    [self.navigationController pushViewController:tabVc animated:YES];
}

/** 已完成 */
- (IBAction)orderBarThree
{
    BNWOrderTabPageViewController *tabVc = [BNWOrderTabPageViewController new];
    tabVc.index = 4;
    [self.navigationController pushViewController:tabVc animated:YES];
}

/** 晒单评价 */
- (IBAction)orderBarFour
{
    BNWOrderTabPageViewController *tabVc = [BNWOrderTabPageViewController new];
    tabVc.index = 3;
    [self.navigationController pushViewController:tabVc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.profileList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)self.profileList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNWProfileCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BNWProfileCell"];
    }
    
    cell.textLabel.text = self.profileList[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0 : {
            self.tabBarController.selectedIndex = 2;
            return;
        }
        case 1 : {
            BNWOrderTabPageViewController *orderTabPage = [BNWOrderTabPageViewController new];
            [self.navigationController pushViewController:orderTabPage animated:YES];
            return;
        }
        case 2 : {
            BNWWalletViewController *walletVc = [BNWWalletViewController new];
            [self.navigationController pushViewController:walletVc animated:YES];
            return;
        }
        case 3 : {
            BNWCollectViewController *collectVc = [BNWCollectViewController new];
            [self.navigationController pushViewController:collectVc animated:YES];
            return;
        }
        case 4 : {
          //设置
            BNWSettingViewController *settingVC = [BNWSettingViewController new];
            [self.navigationController pushViewController:settingVC animated:YES];
            return;
        }
        case 5 : {
            NSLog(@"6");
            return;
        }

    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return self.sectionFooterView;
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 1 ? 60 : 0;
}

#pragma mark - 懒加载
- (BNWUnLoginViewController *)unloginVc
{
    if (!_unloginVc) {
        BNWUnLoginViewController *unLoginVc = [BNWUnLoginViewController new];
        unLoginVc.view.frame = self.view.bounds;
        self.unloginVc = unLoginVc;
        self.unloginVc.message = @"您尚未登录";
    }
    return _unloginVc;
}

- (NSArray *)profileList
{
    if (!_profileList) {
        _profileList = @[
                         @[@"我的VIP"],
                         @[@"我的订单"],
                         @[@"我的钱包"],
                         @[@"我的收藏"],
                         @[@"设置"],
                         @[@"关于"]
                         ];
    }
    return _profileList;
}
@end
