//
//  BNWGoodsListViewController.m
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWGoodsListViewController.h"
#import "BNWSearchBar.h"
#import "BNWGoodsCell.h"
#import "MJExtension.h"
#import "BNWGoods.h"
#import "BNWCartViewController.h"
#import "MBProgressHUD+MJ.h"
#import "BNWGoodsDetailViewController.h"
#import "BNWHttpTool.h"
#import "MJRefresh.h"
#import "BNWAccount.h"
#import "BNWAccountTool.h"

@interface BNWGoodsListViewController () <UITableViewDelegate,UITableViewDataSource,BNWGoodsCellDelegate,UITextFieldDelegate>
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 购物车 */
- (IBAction)CartButtonDidClick;
/** 排序按钮 */
- (IBAction)hotSale:(UIButton *)sender;
- (IBAction)price:(UIButton *)sender;
- (IBAction)goodReview:(UIButton *)sender;
- (IBAction)collect:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *hotSaleButton;
@property (nonatomic,assign) NSInteger lastSelectedIndex;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *barButton;

/** 数据 */
@property (nonatomic,strong) NSMutableArray *goodsList;
// 排序
@property (nonatomic,copy) NSString *type;

@end

@implementation BNWGoodsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWGoodsCell" bundle:nil] forCellReuseIdentifier:@"BNWGoodsCell"];
    self.tableView.rowHeight = 120;
    
    BNWSearchBar *searchBar = [BNWSearchBar searchBar];
    CGFloat margin = 8;
    searchBar.width = SCREEN_WIDTH - (2 * margin);
    searchBar.height = 30;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    
    // 默认点击
    [self hotSale:self.hotSaleButton];
    
    // 刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.header beginRefreshing];
    
    
}

#pragma mark - 请求
- (void)loadNewData
{
    // 如果没有关键字
//    if (!self.keyword) {
//        [self.tableView.header endRefreshing];
//        return;
//    }
//    if (!self.cat_id) {
//        [self.tableView.header endRefreshing];
//        return;
//    }
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/goods.php?action=goods_list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.keyword) {
        params[@"keyword"] = self.keyword;
    }
    if (self.cat_id) {
        params[@"cat_id"] = self.cat_id;
    }
    params[@"type"] = self.type;
    
//    NSLog(@"%@",params);
    
    [BNWHttpTool get:url params:params success:^(id json) {
//        NSLog(@"%@",json);
        self.goodsList = [BNWGoods objectArrayWithKeyValuesArray:json];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.header endRefreshing];
        NSLog(@"%@",error);
    }];
}

#pragma mark - IBAction
- (IBAction)CartButtonDidClick
{
    BNWCartViewController *cartVc = [BNWCartViewController new];
    [self.navigationController pushViewController:cartVc animated:YES];
}

- (IBAction)hotSale:(UIButton *)sender
{
    [self buttonStateControlWithButton:sender];
    self.type = @"1";
    
    [MBProgressHUD showSuccess:@"热卖"];
    [self loadNewData];
}

- (IBAction)price:(UIButton *)sender
{
    [self buttonStateControlWithButton:sender];
    
    if (sender.isSelected) {
        self.type = @"3";
        [MBProgressHUD showSuccess:@"价格从低到高"];
        [self loadNewData];
    } else {
        self.type = @"2";
        [MBProgressHUD showSuccess:@"价格从高到低"];
        [self loadNewData];
    }
}

- (IBAction)goodReview:(UIButton *)sender
{
    [self buttonStateControlWithButton:sender];
    self.type = @"4";

    [MBProgressHUD showSuccess:@"好评"];
    [self loadNewData];

}

- (IBAction)collect:(UIButton *)sender
{
    [self buttonStateControlWithButton:sender];
    
    self.type = @"5";

    [MBProgressHUD showSuccess:@"收藏"];
    [self loadNewData];
}

/**
 *  Bar按钮的状态控制
 */
- (void)buttonStateControlWithButton:(UIButton *)sender
{
    // 获取当前点击按钮在按钮数组中的index
    NSInteger currentSelectIdnex = [self.barButton indexOfObject:sender];
    // 统一设置按钮颜色
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    // 将当前点击的按钮从按钮数组中移除(临时数组)
    NSMutableArray *tBarButton = [self.barButton mutableCopy];
    if ([self.barButton containsObject:sender]) {
        [tBarButton removeObject:sender];
    }
    // 遍历临时数组
    for (UIButton *button in tBarButton) {
        // 如果和上一次点击的不是同一个按钮
        if (self.lastSelectedIndex != currentSelectIdnex) {
            button.selected = NO;
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        }
    }
    // 按钮反选
    sender.selected = !sender.selected;

    self.lastSelectedIndex = currentSelectIdnex;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return NO;
    }
    
    self.type = @"1";
    self.keyword = textField.text;
    [self loadNewData];
    textField.text = nil;
    
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWGoodsCell *cell = [BNWGoodsCell cellWithTableView:tableView];
    
    cell.goods = self.goodsList[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BNWGoods *goods = self.goodsList[indexPath.row];
    BNWGoodsDetailViewController *detailVc = [BNWGoodsDetailViewController new];
    detailVc.goods_id = goods.goods_id;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - BNWGoodsCellDelegate
- (void)goodsCellDidAdd2Cart:(BNWGoods *)goods
{
    BNWAccount *account = [BNWAccountTool account];
    if (account) {
        [MBProgressHUD showMessage:@"添加中"];
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/cart.php?action=add_cart";
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = account.user_id;
        params[@"mobile_phone"] = account.mobile_phone;
        params[@"goods_id"] = goods.goods_id;
        params[@"token"] = account.token;
        params[@"goods_number"] = @"1";
        
        [BNWHttpTool post:url params:params success:^(id json) {
            
            [MBProgressHUD hideHUD];
            
            if ([json[@"return_info"] isEqualToString:@"true"]) {
                [MBProgressHUD showSuccess:@"加入购物车成功"];
            } else {
                [MBProgressHUD showError:@"加入购物车失败"];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"%@",error);
        }];
        
    } else {
        [MBProgressHUD showError:@"您还没有登陆"];
    }

}

#pragma mark - 懒加载
- (NSMutableArray *)goodsList
{
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

@end
