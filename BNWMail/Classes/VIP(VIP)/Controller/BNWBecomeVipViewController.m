//
//  BNWBecomeVipViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/19.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWBecomeVipViewController.h"
#import "BNWBecomVipCell.h"
#import "BNWPayModeViewController.h"

@interface BNWBecomeVipViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (strong,nonatomic) NSArray *vipRankList;

@end

@implementation BNWBecomeVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入VIP";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWBecomVipCell" bundle:nil] forCellReuseIdentifier:@"BNWBecomVipCell"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.vipRankList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BNWBecomVipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNWBecomVipCell"];
    cell.vipLabel.text = self.vipRankList[indexPath.row][@"rank"];
    cell.priceLabel.text = self.vipRankList[indexPath.row][@"price"];
    
    if (indexPath.row != 0) {
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (IBAction)becomeVipClick:(id)sender {
    
    BNWPayModeViewController *payModeVC = [BNWPayModeViewController new];
//    payModeVC.orderDetail =
    [self.navigationController pushViewController:payModeVC animated:YES];
    
}


- (NSArray *)vipRankList{
    if (_vipRankList == nil) {
        _vipRankList = @[
                         @{@"rank":@"VIP1",@"price":@"充值10000元"},
                         @{@"rank":@"VIP2",@"price":@"充值20000元"},
                         @{@"rank":@"VIP3",@"price":@"充值30000元"},
                         @{@"rank":@"VIP4",@"price":@"充值40000元"},
                         @{@"rank":@"VIP5",@"price":@"充值50000元"},
                         ];
    }
    return _vipRankList;
}

@end
