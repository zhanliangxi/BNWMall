//
//  BNWMoreDealViewController.m
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWMoreDealViewController.h"
#import "BNWMoreDeal.h"
#import "BNWMoreDealCell.h"
#import "MJExtension.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MBProgressHUD+MJ.h"
#import "BNWCartViewController.h"
#import "BNWHomeSearchView.h"
#import "MJRefresh.h"
#import "BNWHttpTool.h"
#import "BNWGoods.h"
#import "BNWGoodsDetailViewController.h"

@interface BNWMoreDealViewController () <UITableViewDelegate,UITableViewDataSource,BNWMoreDealCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *tableViewHeaderView;
- (IBAction)CartButtonDidClick;
- (IBAction)scroll2Top;

@end

@implementation BNWMoreDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"团购活动";
    self.tableView.rowHeight = 160;
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWMoreDealCell" bundle:nil] forCellReuseIdentifier:@"BNWMoreDealCell"];
    // 刷新控件
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.header beginRefreshing];
    // 导航栏设置
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(search) image:@"home_searchIconWhite" highImage:@"home_searchIconWhite"];
    self.navigationItem.rightBarButtonItem = searchItem;
}

#pragma mark - 刷新
- (void)loadNewData
{
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=group_list";
    
    [BNWHttpTool post:url params:nil success:^(id json) {
        self.moreDealList = [BNWMoreDeal objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - 监听
- (void)search
{
    BNWHomeSearchView *searchView = [BNWHomeSearchView viewWithNibName:@"BNWHomeSearchView"];
    searchView.controller = self;
    [searchView showSearchViewInView:KEY_WINDOW];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moreDealList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWMoreDealCell *cell = [BNWMoreDealCell cellWithTableView:tableView];
    
    cell.moreDeal = self.moreDealList[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

#pragma mark - BNWMoreDealCellDelegate
- (void)moreDealBuyButtonDidClickWithDeal:(BNWMoreDeal *)deal
{
    BNWGoodsDetailViewController *detailVc = [BNWGoodsDetailViewController new];
    detailVc.goods_id = deal.goods_id;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - IBAction
- (IBAction)CartButtonDidClick
{
    BNWCartViewController *cartVc = [BNWCartViewController new];
    [self.navigationController pushViewController:cartVc animated:YES];
}

- (IBAction)scroll2Top
{
    [self.tableView  setContentOffset:CGPointMake(0,-64) animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)moreDealList
{
    if (!_moreDealList) {
        _moreDealList = [NSMutableArray array];
    }
    return _moreDealList;
}

@end
