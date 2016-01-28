//
//  BNWMessageViewController.m
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWMessageViewController.h"
#import "MJExtension.h"
#import "BNWMessage.h"
#import "BNWMessageCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "BNWMessageDetailViewController.h"
#import "MJRefresh.h"
#import "BNWHttpTool.h"

@interface BNWMessageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *messageList;

@end

@implementation BNWMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    self.tableView.tableFooterView = [UIView new];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWMessageCell" bundle:nil] forCellReuseIdentifier:@"BNWMessageCell"];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.header beginRefreshing];
}

#pragma mark - 刷新
- (void)loadNewData
{
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=message";
    
    [BNWHttpTool post:url params:nil success:^(id json) {
        self.messageList = [BNWMessage objectArrayWithKeyValuesArray:json];
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
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWMessageCell *cell = [BNWMessageCell cellWithTableView:tableView];
    
    cell.message = self.messageList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BNWMessageDetailViewController *messageDetailVc = [BNWMessageDetailViewController new];
    messageDetailVc.message = self.messageList[indexPath.row];
    [self.navigationController pushViewController:messageDetailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"BNWMessageCell" cacheByIndexPath:indexPath configuration:^(BNWMessageCell *cell) {
        cell.message = self.messageList[indexPath.row];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)messageList
{
    if (!_messageList) {
        _messageList = [NSMutableArray array];
    }
    return _messageList;
}

@end
