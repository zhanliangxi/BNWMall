//
//  BNWOrderMainViewController.m
//  BNWMail
//
//  Created by mac on 15/8/7.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWOrderMainViewController.h"
#import "MJRefresh.h"
#import "BNWOrderCell.h"
#import "BNWOrder.h"
#import "MJExtension.h"
#import "BNWAccount.h"
#import "BNWAccountTool.h"
#import "BNWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "BNWGoodsDetailViewController.h"
#import "BNWOrderDetailViewController.h"
#import "BNWGoods.h"
#import "BNWPayModeViewController.h"

@interface BNWOrderMainViewController () <BNWOrderCellDelegate>

@property (nonatomic,strong) NSMutableArray *orderList;

@end

@implementation BNWOrderMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWOrderCell" bundle:nil] forCellReuseIdentifier:@"BNWOrderCell"];
    
    self.tableView.backgroundColor = APP_BG_COLOR;
    self.tableView.rowHeight = 268;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self loadNewData];
}

#pragma mark - refresh
- (void)loadNewData
{
    BNWAccount *account = [BNWAccountTool account];
    
    if (!account) return;
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/order.php?action=get_order_list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"mobile_phone"] = account.mobile_phone;
    params[@"token"] = account.token;
    params[@"user_id"] = account.user_id;
    if (![self.orderState isEqualToString:@"all"]) {
        params[@"pay_status"] = self.orderState;
    }

    
    [BNWHttpTool post:url params:params success:^(id json) {
        NSLog(@"%@",json);
        self.orderList = [BNWOrder objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [self.tableView.header endRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWOrderCell *cell = [BNWOrderCell cellWithTableView:tableView];
    
    cell.delegate = self;
    cell.order = self.orderList[indexPath.row];
    
    return cell;
}

#pragma mark - BNWOrderCellDelegate
- (void)orderCellBuyDidClickWithOrder:(BNWOrder *)order
{
    if ([order.pay_status isEqualToString:@"待付款"]) {
        BNWPayModeViewController *payModeVc = [BNWPayModeViewController new];
        payModeVc.orderDetail = order;
        [self.navigationController pushViewController:payModeVc animated:YES];
        
    } else if ([order.pay_status isEqualToString:@"已发货"]) {
        
        
    } else if ([order.pay_status isEqualToString:@"待评价"]) {
        [self orderCellOrderDidClickWithOrder:order];
        
    } else if ([order.pay_status isEqualToString:@"已完成"]) {
        
        
    }
}

- (void)orderCellGoodsDetailDidClickWithOrder:(BNWOrder *)order
{
    BNWGoodsDetailViewController *goodsDetailVc = [BNWGoodsDetailViewController new];
    BNWGoods *goods = [order.goods firstObject];
    goodsDetailVc.goods_id = goods.goods_id;
    [self.navigationController pushViewController:goodsDetailVc animated:YES];
}

- (void)orderCellOrderDidClickWithOrder:(BNWOrder *)order
{
    
    BNWOrderDetailViewController *orderDetailVc = [BNWOrderDetailViewController new];
    order.withoutReview = [order.pay_status isEqualToString:@"待评价"] ? YES : NO;
    orderDetailVc.order = order;
    [self.navigationController pushViewController:orderDetailVc animated:YES];
}


#pragma mark - 懒加载


@end
