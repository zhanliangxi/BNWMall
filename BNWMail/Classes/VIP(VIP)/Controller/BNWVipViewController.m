//
//  BNWVipViewController.m
//  BNWMail
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWVipViewController.h"
#import "BNWMainVipViewController.h"
#import "BNWVipCell.h"
#import "HCSStarRatingView.h"
#import "BNWHttpTool.h"
#import "BNWAccountTool.h"
#import "BNWUnLoginViewController.h"
#import "MJExtension.h"
#import "BNWVIPInfo.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "BNWBecomeVipViewController.h"

@interface BNWVipViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) BNWUnLoginViewController *unloginVc;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong,nonatomic) NSMutableArray *sectionList;

@property (copy,nonatomic) NSString *price;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *vipView;

@end

@implementation BNWVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerView.frame  =CGRectMake(0, 0, SCREEN_WIDTH, 170);
    self.tableView.tableHeaderView = self.bannerView;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 75, 0);
    
    self.exitBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = _iconView.width * 0.5;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWVipCell" bundle:nil] forCellReuseIdentifier:@"BNWVipCell"];
    
//    self.vipView.value = 1;
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getInfo];
}
- (void)getInfo{
    
    BNWAccount *account = [BNWAccountTool account];
    if (account) {
        [self.unloginVc.view removeFromSuperview];
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/vip.php?action=myVip";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[phoneNumberKey] = account.mobile_phone;
        params[tokenKey] = account.token;
        
        
        if (account.user_name) {
           [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecshop.dadazu.com/%@",account.user_thum]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            self.titleLabel.text = account.user_name;
            self.vipView.value = account.user_rank.integerValue;
            self.price = account.user_money;
        }else{
            [BNWHttpTool post:url params:params success:^(id json) {
                
                BNWAccount *account = [BNWAccount objectWithKeyValues:json];
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecshop.dadazu.com/%@",account.user_thum]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                self.titleLabel.text = account.user_name;
                self.vipView.value = account.user_rank.integerValue;
                self.price = account.user_money;
                [BNWAccountTool saveAccount:account];
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"请求失败" toView:self.view];
            }];
        }
        
       
    }else{
        [self.view addSubview:self.unloginVc.view];
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sectionList[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    BNWVipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNWVipCell"];
    NSDictionary *dict = (NSDictionary *)self.sectionList[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.titleLabel.text =[NSString stringWithFormat:@"%@:%zd元",dict[@"title"],self.price.integerValue];
        cell.iconView.image =[UIImage imageNamed:dict[@"image"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.titleLabel.text  = dict[@"title"];
         cell.iconView.image =[UIImage imageNamed:dict[@"image"]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            
            break;
            
        default:
        {
            BNWMainVipViewController *mainVip = [BNWMainVipViewController new];
            mainVip.index = indexPath.section - 1;
            [self.navigationController pushViewController:mainVip animated:YES];
        }
            break;
    }
    
}
- (IBAction)becomeVipClick {
    
    BNWBecomeVipViewController *becomeVC = [BNWBecomeVipViewController new];
    [self.navigationController pushViewController:becomeVC animated:YES];
    
}
- (BNWUnLoginViewController *)unloginVc
{
    if (!_unloginVc) {
        BNWUnLoginViewController *unLoginVc = [BNWUnLoginViewController new];
        unLoginVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.unloginVc = unLoginVc;
        self.unloginVc.message = @"您尚未登录";
    }
    return _unloginVc;
}

- (NSMutableArray *)sectionList{
    if (_sectionList == nil) {
        _sectionList = [NSMutableArray arrayWithArray:@[
                                                        @[@{@"title":@"余额",@"image":@"vip_balance"}],
                                                        @[@{@"title":@"每日领取",@"image":@"vip_everyday"}],
                                                        @[@{@"title":@"领取记录",@"image":@"vip_getRecord"}],
                                                        @[@{@"title":@"功能特权",@"image":@"vip_prerogative"}],
                                                        @[@{@"title":@"成长体系",@"image":@"vip_system"}]
                                                        ]];
    }
    return _sectionList;
}

@end
