//
//  BNWWalletViewController.m
//  BNWMail
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWWalletViewController.h"
#import "BNWWallet.h"
#import "MJExtension.h"

@interface BNWWalletViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *walletList;

@end

@implementation BNWWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = APP_BG_COLOR;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (BNWWallet *wallet in self.walletList) {
            if ([wallet.key isEqualToString:@"余额"]) {
                wallet.value = [NSString stringWithFormat:@"%@元",@"10000"];
                [self.tableView reloadData];
                return ;
            }
        }
    });
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.walletList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNWWalletCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BNWWalletCell"];
    }
    
    BNWWallet *wallet = self.walletList[indexPath.row];
    cell.textLabel.text = wallet.key;
    cell.detailTextLabel.text = wallet.value;
    cell.detailTextLabel.textColor = APP_BUTTON_COLOR;
    cell.accessoryType = wallet.type == 2 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone ;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 懒加载
- (NSArray *)walletList
{
    if (!_walletList) {
        NSArray *array = @[
                        @{@"key":@"余额",@"value":@"",@"type":@1},
                        @{@"key":@"充值",@"type":@2},
                        @{@"key":@"提现",@"type":@2}
                        ];
        _walletList = [BNWWallet objectArrayWithKeyValuesArray:array];
    }
    return  _walletList;
}

@end
