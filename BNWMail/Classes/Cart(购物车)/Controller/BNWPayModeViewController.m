//
//  BNWPayModeViewController.m
//  BNWMail
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWPayModeViewController.h"
#import "MBProgressHUD+MJ.h"
#import "BNWPaySuccessViewController.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"
#import "BNWOrder.h"
#import "BNWGoods.h"

@interface BNWPayModeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *payModeList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BNWPayModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"支付方式";
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payModeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNWPayModeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BNWPayModeCell"];
    }
    
    cell.textLabel.text = self.payModeList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: // 支付宝
        {
            [self alipay];
            break;
        }
        case 1: // 银联
        {
            
            break;
        }
        case 2: // 余额
        {
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 私有方法
/**
 *  支付宝支付
 */
- (void)alipay
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    BNWOrder *product = self.orderDetail;
    BNWGoods *goods = [product.goods firstObject];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088911927520981";
    NSString *seller = @"jxwldzsw@163.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANe/NQKiumGtOiBTSTP+uhMqJzV7DI1r+GoVfd+7dKIpjK+WPoiHlxLT6nbYcIa+o2u8wTbQC2X+ovf/sp0s5e7NuViN1ar2x22TnthEbylAX9x5aI7nVcnvzvMmR74EquCQeSLjrxrMerXIXRjTHaUVqGr116LzwkuR7kB8mUaFAgMBAAECgYEAuTXfRyz1fgbdAIUfMbC6gttMH6BLzVhkQIXEsn3ViaTLrqz3b/OeoL4l6PKz3yjnWAUJhYmiT2QC+Y2cA0xY8k5CLeGXScQj4/GD0S7Kx4dsfRfLFg2dvj1crLpOlOd4Sgwggg2d2ze6QW6+DqGOlasNkVHAnX5P8zV8lFgbFaECQQDum4mnjuhrAdGTAPBYeF2IodQpMI6nU8+mb2spQ1fY3ASB118Ww6oNaJgqox50LdZ6G6bvWRs3+/6btxBx3biZAkEA53kVwttRiOSnuNC/N5yU5VANIE8ERhZ2o547m8E6T7Hb0r1GUFuYU3qHZSa+q01YTbL1ZfsfjU0aZdHfinSUzQJADrzss7zP/kwOddYJAm3s2ROl1yV4qj0zBkS7icDvHCX64Uo8RVuwlUNworGQn/x00vYCSaZnV/3orBWSnnXjgQJAFjHaEFEPRF0IaAQ8EY0GCebfG1X4RvAoeA/YD1s7yCB5v38+mr3toTOCgARzC+HisbCTLzAhGl9mRJUXJiN/kQJAN1jrs0VRjN2rUq3+1V9+AJgmKBFr3d2J8YJ6JmOUn1vl3RLjWbn3/EtO6YKg7MPAFC5BJwYaG+8W1qRZJzMz1A==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = product.pay_id; //订单ID（由商家自行制定）
    order.productName = product.goods.count == 1 ? goods.goods_name : [NSString stringWithFormat:@"%@等%zd件商品",goods.goods_name,product.goods.count - 1]; //商品标题
    order.productDescription = order.productName; //商品描述
    order.amount = product.order_amount; //商品价格
    order.notifyURL =  @"http://ecshop.dadazu.com/alipay/notify_url.php"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"bnwmall";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"order reslut = %@",resultDic);
            
//            9000	订单支付成功
//            8000	正在处理中
//            4000	订单支付失败
//            6001	用户中途取消
//            6002    网络连接出错
            NSString *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) { // 用户中途取消
                [MBProgressHUD showError:@"用户中途取消"];
            } else if ([resultStatus isEqualToString:@"8000"]) { // 正在处理中
                [MBProgressHUD showError:@"正在处理中"];
            } else if ([resultStatus isEqualToString:@"4000"]) { // 订单支付失败
                [MBProgressHUD showError:@"订单支付失败"];
            } else if ([resultStatus isEqualToString:@"6001"]) { // 用户中途取消
                [MBProgressHUD showError:@"用户中途取消"];
            } else if ([resultStatus isEqualToString:@"6002"]) { // 网络连接出错
                [MBProgressHUD showError:@"网络连接出错"];
            }
        }];
    }
    
    
    
    //    [MBProgressHUD showSuccess:@"支付成功"];
    //
    //    BNWPaySuccessViewController *successVc = [BNWPaySuccessViewController new];
    //    [self.navigationController pushViewController:successVc animated:YES];
}

#pragma mark - 懒加载
- (NSArray *)payModeList
{
    if (!_payModeList) {
        _payModeList = @[
                         @"支付宝",
                         @"银联支付",
                         @"余额支付"
                         ];
    }
    return _payModeList;
}

@end
