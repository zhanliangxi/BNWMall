//
//  BNWGoodsReviewViewController.m
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWGoodsReviewViewController.h"
#import "BNWGoodsReviewCell.h"
#import "MJExtension.h"
#import "BNWGoodsReview.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
#import "BNWHttpTool.h"
#import "MBProgressHUD+MJ.h"

@interface BNWGoodsReviewViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *goodsReviewList;

@end

@implementation BNWGoodsReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品评价";
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWGoodsReviewCell" bundle:nil] forCellReuseIdentifier:@"BNWGoodsReviewCell"];
    
    // 刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.header beginRefreshing];
}

#pragma mark - 刷新
- (void)loadNewData
{
    if (!self.goods_id) {
        [MBProgressHUD showError:@"未获取商品id"];
        [self.tableView.header endRefreshing];
        return;
    }
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/goods.php?action=get_comment";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"goods_id"] = self.goods_id;
    
    [BNWHttpTool post:url params:params success:^(id json) {
        
        self.goodsReviewList = [BNWGoodsReview objectArrayWithKeyValuesArray:json];
        
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsReviewList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWGoodsReviewCell *cell = [BNWGoodsReviewCell cellWithTableView:tableView];
    
    cell.goodsReview = self.goodsReviewList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"BNWGoodsReviewCell" cacheByIndexPath:indexPath configuration:^(BNWGoodsReviewCell *cell) {
        cell.goodsReview = self.goodsReviewList[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)goodsReviewList
{
    if (!_goodsReviewList) {
        _goodsReviewList = [NSMutableArray array];
    }
    return _goodsReviewList;
}

@end
