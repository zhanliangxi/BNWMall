//
//  BNWPaySuccessViewController.m
//  BNWMail
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWPaySuccessViewController.h"
#import "BNWHttpTool.h"
#import "BNWGoods.h"
#import "MJExtension.h"
#import "BNWGoodsCell.h"
#import "BNWGoodsDetailViewController.h"
#import "BNWAccount.h"
#import "BNWAccountTool.h"
#import "MBProgressHUD+MJ.h"

@interface BNWPaySuccessViewController () <UITableViewDelegate,UITableViewDataSource,BNWGoodsCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *tableViewHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *guessList;
@end

@implementation BNWPaySuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"支付成功";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.tableView.rowHeight = 120;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWGoodsCell" bundle:nil] forCellReuseIdentifier:@"BNWGoodsCell"];
    
    [self setupGuessData];
}

#pragma mark - 刷新
- (void)setupGuessData
{
    // 商品
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=guess_like";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"1";
    
    [BNWHttpTool get:url params:params success:^(id json) {
        self.guessList = [BNWGoods objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.guessList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWGoodsCell *cell = [BNWGoodsCell cellWithTableView:tableView];
    
    cell.goods = self.guessList[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BNWGoodsDetailViewController *goodsDetailVc = [BNWGoodsDetailViewController new];
    BNWGoods *goods = self.guessList[indexPath.row];
    goodsDetailVc.goods_id = goods.goods_id;
    [self.navigationController pushViewController:goodsDetailVc animated:YES];
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
- (NSMutableArray *)guessList
{
    if (!_guessList) {
        _guessList = [NSMutableArray array];
    }
    return _guessList;
}


@end
