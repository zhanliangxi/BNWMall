//
//  BNWConfirmOrderViewController.m
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWConfirmOrderViewController.h"
#import "BNWConfirmCell.h"
#import "BNWCart.h"
#import "BNWGoodsDetailViewController.h"
#import "BNWAllSiteViewController.h"
#import "BNWGoods.h"
#import "BNWPayModeViewController.h"
#import "BNWUserSite.h"
#import "BNWAccount.h"
#import "BNWAccountTool.h"
#import "BNWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "BNWSite.h"
#import "MJExtension.h"
#import "BNWOrder.h"
#import "BNWCommodity.h"

@interface BNWConfirmOrderViewController () <UITableViewDelegate,UITableViewDataSource,BNWConfirmCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conRootViewBottom;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic) BNWAllSiteViewController *allSiteVC;


/** UI */
/** 地址 */
@property (weak, nonatomic) IBOutlet UIView *addressEmptyView;
@property (weak, nonatomic) IBOutlet UIView *addressHaveView;
@property (weak, nonatomic) IBOutlet UILabel *addressNameLable;
@property (weak, nonatomic) IBOutlet UILabel *addressPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;
/** 总价 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/** 商品价格 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPirceLabel;
@property (nonatomic,assign) CGFloat goodsPrice;
/** 运费 */
@property (weak, nonatomic) IBOutlet UILabel *carriageLabel;
@property (weak, nonatomic) IBOutlet UITextView *postscriptTextField;

- (IBAction)addressButtonDidClick;
- (IBAction)SubmitOrderButtonDidClick;

/** 请求 */
@property (nonatomic,copy) NSString *address_id;
@property (nonatomic,copy) NSString *rec_id;
@property (nonatomic,strong) BNWAccount *account;
@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,assign) NSInteger goods_number;

/** 商品积分 */
@property (assign,nonatomic) CGFloat goodsIntegral;

@end

@implementation BNWConfirmOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    self.title = @"订单详情";
    
    self.tableView.rowHeight = 180;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWConfirmCell" bundle:nil] forCellReuseIdentifier:@"BNWConfirmCell"];
    
    // 计算金额
    [self confirmCellUpdateDate];
    
    // 计算运费
    [self setupCarriage];
}

- (void)setupCarriage
{
    self.carriageLabel.text = @"";
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/order.php?action=shipping_fee";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"shipping_fee"] = @(self.goodsPrice);
    
    [BNWHttpTool post:url params:params success:^(id json) {
        self.carriageLabel.text = [NSString stringWithFormat:@"%@",json[@"shipping_fee"]];
        [self confirmCellUpdateDate];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupAddress];
}

#pragma mark - UI
- (void)setupAddress
{
    __weak typeof(self) _self = self;
    [self.allSiteVC setSelSiteViewBlock:^(BNWUserSite *userSite) {
        _self.address_id = userSite.address_id;
        
        _self.addressNameLable.text = userSite.consignee;
        _self.addressPhoneLabel.text = userSite.mobile;
        // 详细地址转换
        _self.addressDetailLabel.text = [_self setupAddressDetail:userSite];
    }];
    
    if (_self.address_id) {
        _self.addressHaveView.hidden = NO;
        _self.addressEmptyView.hidden = YES;
    } else {
        _self.addressHaveView.hidden = YES;
        _self.addressEmptyView.hidden = NO;
    }
}

#pragma mark - IBAction
- (IBAction)addressButtonDidClick
{
    [self.navigationController pushViewController:self.allSiteVC animated:YES];
}

- (IBAction)SubmitOrderButtonDidClick
{
    if (!self.address_id) {
        [MBProgressHUD showError:@"还未选择地址"];
        return;
    }
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/order.php?action=create_order";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    switch (self.orderType) {
        case BNWConfirmOrderTypeCart: {
            params[@"mobile_phone"] = self.account.mobile_phone;
            params[@"token"] = self.account.token;
            params[@"user_id"] = self.account.user_id;
            params[@"address_id"] = self.address_id;
            params[@"rec_id"] = self.rec_id;
            params[@"postscript"] = self.postscriptTextField.text;
            params[@"order_type"] = @"2";
            break;
        }
        case BNWConfirmOrderTypeBuyNow: {
            params[@"mobile_phone"] = self.account.mobile_phone;
            params[@"token"] = self.account.token;
            params[@"user_id"] = self.account.user_id;
            params[@"address_id"] = self.address_id;
            params[@"goods_id"] = self.goods_id;
            params[@"postscript"] = self.postscriptTextField.text;
            params[@"gs_number"] = [NSString stringWithFormat:@"%zd",self.goods_number];
            params[@"order_type"] = @"1";
            break;
        }
        case BNWConfirmOrderTypeGet:{
            
            if (self.goodsIntegral > 1000.0) {
                [MBProgressHUD showError:@"超过积分范围" toView:self.view];
                return;
            }
        
            url = @"http://ecshop.dadazu.com/new_api/inc/order.php?action=add_get_goods";
            BNWAccount *account = [BNWAccountTool account];
            params[tokenKey] = account.token;
            params[phoneNumberKey] = account.mobile_phone;
            params[@"address_id"]= self.address_id;
            params[@"user_id"] = account.user_id;
            
            NSMutableString *goodsIdStr = [NSMutableString string];
            NSMutableString *goodsNumber = [NSMutableString string];
            for (BNWCommodity *commodity in self.confirmList) {
                [goodsIdStr appendString:[NSString stringWithFormat:@"%@,",commodity.goods_id]];
                [goodsNumber appendString:[NSString stringWithFormat:@"%@,",commodity.goods_number]];
            }
            params[@"goods_id"] = [goodsIdStr substringToIndex:[goodsIdStr rangeOfString:@"," options:NSBackwardsSearch].location];
            params[@"number"] = [goodsNumber substringToIndex:[goodsNumber rangeOfString:@"," options:NSBackwardsSearch].location];
            break;
        }
    }
    NSLog(@"%@",params);
    [BNWHttpTool post:url params:params success:^(id json) {
        NSLog(@"%@",json);
        
        if ([json[@"return_code"] isEqualToString:@"00002"]) {
             [MBProgressHUD showError:@"今天已领取过" toView:self.view];
            return;
        }
        
        if ([json[@"code"] isEqualToString:@"00001"]) {
            [MBProgressHUD showSuccess:@"订单提交成功"];
            // 提交完订单,先pop到上一个界面,再跳转支付页面,
            UINavigationController *navVC = self.navigationController;
            [navVC popViewControllerAnimated:NO];
            
            BNWPayModeViewController *payVc = [BNWPayModeViewController new];
            payVc.orderDetail = [BNWOrder objectWithKeyValues:json[@"data"][@"list"][0]];
            [navVC pushViewController:payVc animated:YES];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.conTableViewHeight.constant = self.confirmList.count * self.tableView.rowHeight - 1;
    [self.tableView layoutIfNeeded];
    
    return self.confirmList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWConfirmCell *cell = [BNWConfirmCell cellWithTableView:tableView];
    if (self.orderType == BNWConfirmOrderTypeGet) {
        cell.commodity = self.confirmList[indexPath.row];
    }else{
       cell.cart = self.confirmList[indexPath.row];
    }
    cell.delegate = self;
    return cell;
}

#pragma mark - BNWConfirmCellDelegate
- (void)confirmCellDidClickCart:(BNWCart *)cart
{
    if (self.orderType != BNWConfirmOrderTypeGet) {
        BNWGoodsDetailViewController *detailVc = [BNWGoodsDetailViewController new];
        detailVc.goods_id = cart.goods_id;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)confirmCellUpdateDate
{
    [self.tableView reloadData];
    
    NSMutableString *recStr = [NSMutableString string];
    // 价格
    CGFloat goodsPrice = 0;
    if (self.orderType == BNWConfirmOrderTypeGet) {
        for (BNWCommodity *commodity in self.confirmList) {
            // 数量
            self.goods_number = [commodity.goods_number integerValue];
             // 算积分
            CGFloat unitPrice = [commodity.goods_number integerValue] * [commodity.is_get_integral doubleValue];
            goodsPrice += unitPrice;
            
             self.goodsPirceLabel.text = @"0.0";
             self.goodsIntegral= goodsPrice;
            
            CGFloat totalPrice = 0;
            CGFloat carriagePrice = [self.carriageLabel.text doubleValue];
            totalPrice = self.goodsPirceLabel.text.integerValue + carriagePrice;
            
            self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2lf",totalPrice];
        }
    }else{
        for (BNWCart *cart in self.confirmList) {
            // 数量
            self.goods_number = [cart.goods_number integerValue];
            // 算价格
            CGFloat unitPrice = [cart.goods_number integerValue] * [cart.goods_price doubleValue];
            goodsPrice += unitPrice;
            
            // 拼接id
            [recStr appendFormat:@"%@,",cart.rec_id];
            
            if (self.orderType == BNWConfirmOrderTypeBuyNow) {
                self.goods_id = cart.goods_id;
            }
        }
        self.goodsPirceLabel.text = [NSString stringWithFormat:@"%.2lf",goodsPrice];
        self.goodsPrice = goodsPrice;
        
        CGFloat totalPrice = 0;
        CGFloat carriagePrice = [self.carriageLabel.text doubleValue];
        totalPrice = goodsPrice + carriagePrice;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2lf",totalPrice];
        
        // 订单id
        if (recStr.length) {
            self.rec_id = [recStr substringToIndex:[recStr rangeOfString:@"," options:NSBackwardsSearch].location];
        }
    }
}

/**
 *  购物车数量改变通知
 */
- (void)confirmCellUpdateGoodsNumberWithCart:(BNWCart *)cart
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
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"%@",error);
        }];
        
    } else {
        [MBProgressHUD showError:@"您还没有登陆"];
    }
}


#pragma mark - 私有方法
- (NSString *)setupAddressDetail:(BNWUserSite *)userSite
{
    NSString *provinceStr = nil;
    NSMutableArray *provinceList = [BNWSite objectArrayWithFilename:@"consignee.plist"];
    for (BNWSite *site in provinceList) {
        if ([site.region_id isEqualToString:userSite.province]) {
            provinceStr = site.region_name;
        }
    }
    NSString *cityStr = nil;
    NSMutableArray *cityList = [BNWSite objectArrayWithFilename:@"city.plist"];
    for (BNWSite *site in cityList) {
        if ([site.region_id isEqualToString:userSite.city]) {
            cityStr = site.region_name;
        }
    }
    NSString *areaStr = nil;
    NSMutableArray *areaList = [BNWSite objectArrayWithFilename:@"district.plist"];
    for (BNWSite *site in areaList) {
        if ([site.region_id isEqualToString:userSite.district]) {
            areaStr = site.region_name;
        }
    }
    
    return [NSString stringWithFormat:@"%@ %@ %@ %@",
            provinceStr,
            cityStr,
            areaStr,
            userSite.address];
}

#pragma mark - 懒加载
- (BNWAllSiteViewController *)allSiteVC
{
    if (_allSiteVC == nil) {
        _allSiteVC = [[BNWAllSiteViewController alloc] init];
    }
    return _allSiteVC;
}

- (NSString *)rec_id
{
    if (!_rec_id) {
        _rec_id = [NSString string];
    }
    return _rec_id;
}

- (BNWAccount *)account
{
    if (!_account) {
        _account = [BNWAccountTool account];
    }
    return _account;
}
@end
