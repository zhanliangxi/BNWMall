//
//  BNWCollectViewController.m
//  BNWMail
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWCollectViewController.h"
#import "BNWCollectCell.h"
#import "BNWCollect.h"
#import "BNWHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "BNWAccount.h"
#import "BNWAccountTool.h"
#import "BNWGoodsDeatil.h"
#import "BNWGoodsDetailViewController.h"

@interface BNWCollectViewController () <UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据 */
@property (nonatomic,strong) NSMutableArray *collectList;
@property (nonatomic,strong) BNWAccount *account;

@end

@implementation BNWCollectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 120;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWCollectCell" bundle:nil] forCellReuseIdentifier:@"BNWCollectCell"];
    // 刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.header beginRefreshing];
}

#pragma mark - 刷新
- (void)loadNewData
{
    if (!self.account) {
        [self.tableView.header endRefreshing];
        return;
    }
    
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=my_Collect";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = self.account.token;
    params[@"mobile_phone"] = self.account.mobile_phone;
    
    [BNWHttpTool post:url params:params success:^(id json) {
        [self.tableView.header endRefreshing];
        self.collectList = [BNWCollect objectArrayWithKeyValuesArray:json];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWCollectCell *cell = [BNWCollectCell cellWithTableView:tableView];
    
    cell.collect = self.collectList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BNWGoodsDeatil *goods = self.collectList[indexPath.row];
    BNWGoodsDetailViewController *detailVc = [BNWGoodsDetailViewController new];
    detailVc.goods_id = goods.goods_id;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle
	forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果正在提交删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BNWCollect *goods = self.collectList[indexPath.row];
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=del_collect";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile_phone"] = self.account.mobile_phone;
        params[@"token"] = self.account.token;
        params[@"rec_id"] = goods.rec_id;
        params[@"user_id"] = self.account.user_id;
        
        [BNWHttpTool post:url params:params success:^(id json) {
            
            if ([json[@"return_info"] isEqualToString:@"succeed"]) {
                [MBProgressHUD showSuccess:@"删除成功"];
                [self.collectList removeObjectAtIndex:indexPath.row];
                // 删除刷新要用deleteRowsAtIndexPaths
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [MBProgressHUD showError:@"删除失败"];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
        
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)collectList
{
    if (!_collectList) {
        _collectList = [NSMutableArray array];
    }
    return _collectList;
}

- (BNWAccount *)account
{
    if (!_account) {
        _account = [BNWAccountTool account];
    }
    return _account;
}

@end
