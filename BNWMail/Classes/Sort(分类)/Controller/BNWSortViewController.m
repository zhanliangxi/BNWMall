//
//  BNWSortViewController.m
//  BNWMail
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWSortViewController.h"
#import "BNWSearchBar.h"
#import "BNWSortCell.h"
#import "BNWSort.h"
#import "MJExtension.h"
#import "BNWGoodsListViewController.h"
#import "BNWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "BNWGoods.h"
#import "MJRefresh.h"

@interface BNWSortViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sortList;

@end

@implementation BNWSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWSortCell" bundle:nil] forCellReuseIdentifier:@"BNWSortCell"];
    self.tableView.rowHeight = 80;
    self.tableView.tableFooterView = [UIView new];
    
    BNWSearchBar *searchBar = [BNWSearchBar searchBar];
    CGFloat margin = 8;
    searchBar.width = SCREEN_WIDTH - (2 * margin);
    searchBar.height = 30;
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(searchItemDidClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self loadNewData];
}

#pragma mark - 刷新 
- (void)loadNewData
{
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=classify";
    
    [BNWHttpTool post:url params:nil success:^(id json) {
        self.sortList = [BNWSort objectArrayWithKeyValuesArray:json];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWSortCell *cell = [BNWSortCell cellWithTableView:tableView];
    
    cell.sort = self.sortList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BNWSort *sort = self.sortList[indexPath.row];
    BNWGoodsListViewController *goodsListVc = [BNWGoodsListViewController new];
    goodsListVc.cat_id = sort.cat_id;
    [self.navigationController pushViewController:goodsListVc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return NO;
    }
    
    [self searchItemDidClick];
    textField.text = nil;
    
    return YES;
}

#pragma mark - 监听方法
- (void)searchItemDidClick
{
    BNWSearchBar *searchBar = (BNWSearchBar *)self.navigationItem.titleView;
    
    // 退出键盘
    [searchBar resignFirstResponder];
    if (searchBar.text.length == 0) return;
    
    BNWGoodsListViewController *goodsListVc = [BNWGoodsListViewController new];
    goodsListVc.keyword = searchBar.text;
    [self.navigationController pushViewController:goodsListVc animated:YES];

    searchBar.text = nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BNWSearchBar *searchBar = (BNWSearchBar *)self.navigationItem.titleView;
    [searchBar resignFirstResponder];
}

#pragma mark - 懒加载
- (NSMutableArray *)sortList
{
    if (!_sortList) {
        _sortList = [NSMutableArray array];
    }
    return _sortList;
}
@end
