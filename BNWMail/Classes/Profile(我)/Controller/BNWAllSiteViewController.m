//
//  BNWAllSiteViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWAllSiteViewController.h"
#import "BNWSiteCell.h"
#import "BNWHttpTool.h"
#import "BNWEditSiteViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "BNWAccountTool.h"
#import "MJRefresh.h"

@interface BNWAllSiteViewController ()<UITableViewDataSource,UITableViewDelegate,BNWSiteCellDelegate>


@property (strong,nonatomic) NSMutableArray *siteList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BNWAllSiteViewController

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地址管理";
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWSiteCell" bundle:nil] forCellReuseIdentifier:@"BNWSiteCell"];
    self.tableView.rowHeight = 85;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAllSite)];
    [self.tableView.header beginRefreshing];
}


- (void)getAllSite{
    BNWAccount *account = [BNWAccountTool account];
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/cart.php?action=get_address";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"all"] = @"1";
    params[phoneNumberKey] = account.mobile_phone;
    params[tokenKey] = account.token;
    [BNWHttpTool post:url params:params success:^(id json) {
        self.siteList = [BNWUserSite objectArrayWithKeyValuesArray:json];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败" toView:self.view];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.siteList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BNWSiteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNWSiteCell"];
    cell.delegate = self;
    cell.userSite = self.siteList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.selSiteViewBlock) {
        self.selSiteViewBlock(self.siteList[indexPath.row]);
    }
}

- (void)siteCellWithEditSite:(BNWSiteCell *)siteCell{
    BNWEditSiteViewController *editSiteVc = [BNWEditSiteViewController new];
    editSiteVc.titleStr  = @"修改";
    editSiteVc.userSite = siteCell.userSite;
    [self.navigationController pushViewController:editSiteVc animated:YES];
}

- (void)siteCellWithDelSite:(BNWSiteCell *)siteCell{
    BNWAccount *account = [BNWAccountTool account];
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=del_address";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[phoneNumberKey] = account.mobile_phone;
    params[tokenKey] = account.token;
    params[@"address_id"] = siteCell.userSite.address_id;
    params[@"user_id"] = account.user_id;
    [BNWHttpTool post:url params:params success:^(id json) {
        if ([json[@"return_code"] isEqualToString:@"00001"]) {
           [MBProgressHUD showError:@"删除成功" toView:self.view];
            [self getAllSite];
        }
    } failure:^(NSError *error) {
         NSLog(@"e%@",error);
    }];

    
}


- (IBAction)addSite {
    BNWEditSiteViewController *editSiteVc = [BNWEditSiteViewController new];
    editSiteVc.titleStr  = @"添加";
    [self.navigationController pushViewController:editSiteVc animated:YES];
}


- (NSMutableArray *)siteList{
    if (_siteList == nil) {
        _siteList = [[NSMutableArray alloc]init];
    }
    return _siteList;
}

@end
