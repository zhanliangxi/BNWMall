//
//  BNWCartViewController.m
//  BNWMail
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWCartViewController.h"
#import "BNWCartCell.h"
#import "BNWCart.h"
#import "BNWGoods.h"
#import "MJExtension.h"

#import "BNWUnLoginViewController.h"
#import "BNWAccountTool.h"
#import "BNWAccount.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "BNWConfirmOrderViewController.h"
#import "BNWHttpTool.h"
#import "BNWCollectViewController.h"

@interface BNWCartViewController () <UITableViewDataSource,UITableViewDelegate,BNWCartCellDelegate>

@property (nonatomic,strong) BNWUnLoginViewController *unloginVc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *cartEmptyView;

@property (nonatomic,strong) NSMutableArray *cartList;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)selectAllButtonDidClick:(UIButton *)sender;
- (IBAction)deleteButtonDidClick:(UIButton *)sender;
- (IBAction)goMyCollect;
- (IBAction)goShopping;
- (IBAction)confirmButtonDidClick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conBarBottomSpace;
@property (weak, nonatomic) IBOutlet UIView *bottombar;

/** 账号 */
@property (nonatomic,strong) BNWAccount *account;

@end

@implementation BNWCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 130;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWCartCell" bundle:nil] forCellReuseIdentifier:@"BNWCartCell"];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWCartCell" bundle:nil] forCellReuseIdentifier:@"BNWCartCell"];
    
    // 刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    [self.tableView.header beginRefreshing];
    
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(collect)];
    self.navigationItem.rightBarButtonItem = collectItem;
    
    // 控制底部bar
    [self setupBarBottomSpace];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BNWAccount *account = [BNWAccountTool account];
    if (account) { // 之前已经登录成功过
        [self.unloginVc.view removeFromSuperview];
    } else {
        [self.view addSubview:self.unloginVc.view];
    }
    
    // 计算金额
//    [self cartCellUpdateData];
    [self.cartEmptyView removeFromSuperview];
    [self.tableView.header beginRefreshing];
}


#pragma mark - 刷新
- (void)loadNewData
{
    // 如果没有登录
    if (!self.account) {
        [self.tableView.header endRefreshing];
        return;
    }
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/cart.php?action=cart_mes";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile_phone"] = self.account.mobile_phone;
    params[@"token"] = self.account.token;
    
    [BNWHttpTool post:url params:params success:^(id json) {
        self.cartList = [BNWCart objectArrayWithKeyValuesArray:json];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self cartCellUpdateData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.header endRefreshing];
    }];
    
    
}

#pragma mark - 监听
- (void)collect
{
    BNWCollectViewController *collectVc = [BNWCollectViewController new];
    [self.navigationController pushViewController:collectVc animated:YES];
}

#pragma mark - IBActions
- (IBAction)selectAllButtonDidClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.isSelected) {
        for (BNWCart *cart in self.cartList) {
            cart.selected = YES;
        }
    } else {
        for (BNWCart *cart in self.cartList) {
            cart.selected = NO;
        }
    }
    
    // 刷新数据
    [self.tableView reloadData];
    [self cartCellUpdateData];
}

- (IBAction)deleteButtonDidClick:(UIButton *)sender
{
    NSMutableArray *removeTempArray = [NSMutableArray array];
    NSMutableArray *removeTempIndexPaths = [NSMutableArray array];
    for (BNWCart *cart in self.cartList) {
        if (cart.isSelected) {
            NSUInteger index =  [self.cartList indexOfObject:cart];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [removeTempArray addObject:cart];
            [removeTempIndexPaths addObject:indexPath];
        }
    }
    
    // 请求服务器删除购物车商品
    for (BNWCart *cart in removeTempArray) {
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/cart.php?action=del_cart";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"rec_id"] = cart.rec_id;
        params[@"token"] = self.account.token;
        params[@"mobile_phone"] = self.account.mobile_phone;
        
        [BNWHttpTool post:url params:params success:^(id json) {
            [MBProgressHUD hideHUD];
            
            if ([json[@"return_info"] isEqualToString:@"true"]) {
                [MBProgressHUD showSuccess:@"删除成功"];
                
                // 获取indexPath
                NSUInteger index =  [self.cartList indexOfObject:cart];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                // 从数组中移除
                [self.cartList removeObject:cart];
                // 刷新界面
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                // 更新数据
                [self cartCellUpdateData];
            } else {
                [MBProgressHUD showError:@"删除失败"];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

- (IBAction)goMyCollect
{
    BNWCollectViewController *collectVc = [BNWCollectViewController new];
    [self.navigationController pushViewController:collectVc animated:YES];
}

- (IBAction)goShopping
{
    // temp
    [self loadNewData];
    
    // 跳转
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)confirmButtonDidClick
{
    // 判断有没有选中商品
    BOOL hasChecking = NO;
    for (BNWCart *cart in self.cartList) {
        if (cart.isSelected) {
            hasChecking = YES;
            break;
        }
    }
    if (!hasChecking) {
        [MBProgressHUD showError:@"未选中商品"];
        return;
    }
    
    // 提交订单
    NSMutableArray *confirmTempArray = [NSMutableArray array];
    for (BNWCart *cart in self.cartList) {
        if (cart.isSelected) {
            [confirmTempArray addObject:cart];
        }
    }
    BNWConfirmOrderViewController *confirmVc = [BNWConfirmOrderViewController new];
    confirmVc.confirmList = confirmTempArray;
    confirmVc.orderType = BNWConfirmOrderTypeCart;
    [self.navigationController pushViewController:confirmVc animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cartList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWCartCell *cell = [BNWCartCell cellWithTableView:tableView];
    
    cell.cart = self.cartList[indexPath.row];
    cell.delegate = self;
    
    return  cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - BNWCartCellDelegate
/**
 *  购物车更新数据
 */
- (void)cartCellUpdateData
{
    [self.tableView reloadData];
    
    // 价格
    CGFloat totalPrice = 0;
    for (BNWCart *cart in self.cartList) {
        if (cart.isSelected) {
            CGFloat unitPrice = [cart.goods_number integerValue] * [cart.goods_price doubleValue];
            totalPrice += unitPrice;
        }
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf",totalPrice];
    
    // 购物车为空
    if (!self.cartList.count) {
        // 全勾选取消
        self.selectAllButton.selected = NO;
        
        // 显示空View
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view addSubview:self.cartEmptyView];
            [self.cartEmptyView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
            [self.cartEmptyView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
            [self.cartEmptyView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
            [self.cartEmptyView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        });

    } else {
        // 隐藏空View
        [self.cartEmptyView removeFromSuperview];
    }
}

/**
 *  购物车数量改变通知
 */
- (void)cartCellUpdateGoodsNumberWithCart:(BNWCart *)cart
{
    BNWAccount *account = [BNWAccountTool account];
    if (account) {
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/cart.php?action=change_num";
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile_phone"] = account.mobile_phone;
        params[@"token"] = account.token;
        params[@"goods_number"] = cart.goods_number;
        params[@"rec_id"] = cart.rec_id;
        
        [BNWHttpTool post:url params:params success:^(id json) {
            [MBProgressHUD hideHUD];
            
            if ([json[@"return_info"] isEqualToString:@"success"]) {
                [MBProgressHUD showSuccess:@"修改成功"];
                [MBProgressHUD hideHUD];
            } else {
                [MBProgressHUD showError:@"修改失败"];
                [MBProgressHUD hideHUD];
                [self.tableView.header beginRefreshing];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [self.tableView.header beginRefreshing];
            NSLog(@"%@",error);
        }];
        
    } else {
        [MBProgressHUD showError:@"您还没有登陆"];
    }
}

/**
 *  购物车商品选中
 */
- (void)cartCellSelectStateChange
{
    BOOL hasSelected = NO;
    NSInteger unSelectCount = 0;
    NSInteger selectCount = 0;
    for (BNWCart *cart in self.cartList) {
        if (cart.isSelected) {
            hasSelected = YES;
            selectCount ++;
        } else {
            unSelectCount ++;
        }
    }
    // 如果一个都没有勾上 全选按钮不勾选
    if (unSelectCount == self.cartList.count) {
        hasSelected = YES;
    }
    // 如果全部单选勾上 全选按钮选中
    if (selectCount == self.cartList.count) {
        hasSelected = NO;
    }
    
    self.selectAllButton.selected = !hasSelected;
}

/**
 *  选中删除的购物车商品
 */
- (void)cartCellDeleteWithCart:(BNWCart *)cart
{
    NSUInteger index =  [self.cartList indexOfObject:cart];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    // 请求删除
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/cart.php?action=del_cart";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rec_id"] = cart.rec_id;
    params[@"token"] = self.account.token;
    params[@"mobile_phone"] = self.account.mobile_phone;
    
    [BNWHttpTool post:url params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        
        if ([json[@"return_info"] isEqualToString:@"true"]) {
            [MBProgressHUD showSuccess:@"删除成功"];
            
            [self.cartList removeObject:cart];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self cartCellUpdateData];
        } else {
            [MBProgressHUD showError:@"删除失败"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    

}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滑动的时候退下键盘
    [self.view endEditing:YES];
}

#pragma mark - 私有方法
- (void)setupBarBottomSpace
{
    if (self.navigationController.viewControllers.count != 1) {
        self.conBarBottomSpace.constant = 0;
        [self.bottombar layoutIfNeeded];
    }
}

#pragma mark - 懒加载
- (BNWUnLoginViewController *)unloginVc
{
    if (!_unloginVc) {
        BNWUnLoginViewController *unLoginVc = [BNWUnLoginViewController new];
        unLoginVc.view.frame = self.view.bounds;
        self.unloginVc = unLoginVc;
        self.unloginVc.message = @"尚未登录";
    }
    return _unloginVc;
}

- (NSMutableArray *)cartList
{
    if (!_cartList) {
        _cartList = [NSMutableArray array];
    }
    return _cartList;
}

- (BNWAccount *)account
{
    return [BNWAccountTool account];
}
@end
