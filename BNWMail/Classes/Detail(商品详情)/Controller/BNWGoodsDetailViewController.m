//
//  BNWGoodsDetailViewController.m
//  BNWMail
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWGoodsDetailViewController.h"
#import "BNWGoodsFullDetailViewController.h"
#import "BNWGoodsReviewViewController.h"
#import "BNWCartViewController.h"
#import "BNWLocationTool.h"
#import "BNWLocationCity.h"
#import "BNWGoodsDeatil.h"
#import "BNWHttpTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "BNWAccount.h"
#import "BNWAccountTool.h"
#import "BNWConfirmOrderViewController.h"
#import "BNWCart.h"
#import "BNWLoginViewController.h"

@interface BNWGoodsDetailViewController () <UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTableViewHeight;

/** 低栏按钮事件 */
- (IBAction)cartButtonDidClick;
- (IBAction)buy;
- (IBAction)add2Cart;

/** 数据 */
@property (nonatomic,strong) NSArray *detailStaticList;
@property (nonatomic,strong) BNWGoodsDeatil *goodsDetail;
/** UI */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationInfo;
- (IBAction)collectButtonDidClick:(UIButton *)sender;

@end

@implementation BNWGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    [self setupDetailInfo];
}

#pragma mark - 设置详细信息
- (void)setupDetailInfo
{
    // loading
    [MBProgressHUD showMessage:@"正在加载"];
    
    // 定位信息
    BNWLocationCity *city = [BNWLocationTool city];
    self.locationInfo.text = city ? [NSString stringWithFormat:@"%@>%@>%@",city.State,city.City,city.SubLocality] : @"没有定位信息";
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/goods.php?action=details";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.goods_id) {
        params[@"goods_id"] = self.goods_id;
    }
    
    [BNWHttpTool post:url params:params success:^(id json) {
        // 隐藏HUD
        [MBProgressHUD hideHUD];
        
        self.goodsDetail = [BNWGoodsDeatil objectWithKeyValues:json];
        
        // 填充数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.goodsDetail.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            self.titleLabel.text = self.goodsDetail.goods_name;
            
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.goodsDetail.shop_price];
            
            self.saleNumberLabel.text = [NSString stringWithFormat:@"%@件",self.goodsDetail.goods_number];
            
            self.shippingLabel.text = [NSString stringWithFormat:@"满%@元免邮费",self.goodsDetail.f_price_min];
        });

        
    } failure:^(NSError *error) {
        // 隐藏HUD
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
    }];
}

#pragma mark - IBAction
- (IBAction)cartButtonDidClick
{
    BNWCartViewController *cartVc = [BNWCartViewController new];
    [self.navigationController pushViewController:cartVc animated:YES];
}

- (IBAction)buy
{
    BNWAccount *account = [BNWAccountTool account];
    if (!account) {
        [MBProgressHUD showError:@"请先登录"];
        BNWLoginViewController *loginVc = [BNWLoginViewController new];
        [KEY_WINDOW.rootViewController presentViewController:loginVc animated:YES completion:nil];
        return;
    }
    
    BNWConfirmOrderViewController *confirmOrderVc = [BNWConfirmOrderViewController new];
    
    // 构造模型
    BNWCart *cart = [BNWCart new];
    cart.goods_id = self.goodsDetail.goods_id;
    cart.goods_name = self.goodsDetail.goods_name;
    cart.goods_price = self.goodsDetail.shop_price;
    cart.goods_number = @"1";
    NSString *thumb = self.goodsDetail.goods_thumb;
    thumb = [thumb substringFromIndex:[thumb rangeOfString:BNWDomain].length];
    cart.goods_thumbs = thumb;
    
    confirmOrderVc.confirmList = [@[cart] mutableCopy];
    confirmOrderVc.orderType = BNWConfirmOrderTypeBuyNow;
    
    [self.navigationController pushViewController:confirmOrderVc animated:YES];
}

- (IBAction)add2Cart
{
    BNWAccount *account = [BNWAccountTool account];
    if (account) {
        [MBProgressHUD showMessage:@"添加中"];
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/cart.php?action=add_cart";

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = account.user_id;
        params[@"mobile_phone"] = account.mobile_phone;
        params[@"goods_id"] = self.goods_id;
        params[@"token"] = account.token;
        params[@"goods_number"] = @"1";
        
        NSLog(@"%@",params);
        [BNWHttpTool post:url params:params success:^(id json) {
            NSLog(@"%@",json);
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

- (IBAction)collectButtonDidClick:(UIButton *)sender
{
    BNWAccount *account = [BNWAccountTool account];
    if (account) {
        [MBProgressHUD showMessage:@"添加中"];
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=collect";
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = account.user_id;
        params[@"mobile_phone"] = account.mobile_phone;
        params[@"goods_id"] = self.goods_id;
        params[@"token"] = account.token;
        
        [BNWHttpTool post:url params:params success:^(id json) {
            
            [MBProgressHUD hideHUD];
            
            if ([json[@"return_info"] isEqualToString:@"succeed"]) {
                [MBProgressHUD showSuccess:@"收藏成功"];
            } else if ([json[@"return_info"] isEqualToString:@"please log in first"]) {
                [MBProgressHUD showError:@"请先登录"];
            } else {
                [MBProgressHUD showError:@"已经收藏过了"];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"%@",error);
        }];
        
    } else {
        [MBProgressHUD showError:@"您还没有登陆"];
    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detailStaticList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.conTableViewHeight.constant = 4 * 44;
    [self.tableView layoutIfNeeded];
    
    NSDictionary *sectionDir = self.detailStaticList[section];
    return sectionDir.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNWGoodsDetailCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BNWGoodsDetailCell"];
    }
    
    cell.textLabel.text = self.detailStaticList[indexPath.section][@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            BNWGoodsFullDetailViewController *fullDetailVc = [BNWGoodsFullDetailViewController new];
            fullDetailVc.htmlStr = self.goodsDetail.goods_desc;
            [self.navigationController pushViewController:fullDetailVc animated:YES];
            break;
        }
         
        case 1:
        {
            BNWGoodsReviewViewController *reviewVc = [BNWGoodsReviewViewController new];
            reviewVc.goods_id = self.goods_id;
            [self.navigationController pushViewController:reviewVc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 懒加载
- (NSArray *)detailStaticList
{
    if (!_detailStaticList) {
        _detailStaticList = @[@{@"title":@"查看图文详情"},@{@"title":@"查看商品评价"}];
    }
    return _detailStaticList;
}

@end
