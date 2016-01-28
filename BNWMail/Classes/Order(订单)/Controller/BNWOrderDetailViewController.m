//
//  BNWOrderDetailViewController.m
//  BNWMail
//
//  Created by mac on 15/8/14.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWOrderDetailViewController.h"
#import "HCSStarRatingView.h"
#import "BNWOrder.h"
#import "BNWUserSite.h"
#import "BNWSite.h"
#import "MJExtension.h"
#import "BNWGoods.h"
#import "BNWOrderDetailCell.h"
#import "BNWGoodsDetailViewController.h"
#import "BNWReviewGoodsViewController.h"
#import "BNWPayModeViewController.h"

@interface BNWOrderDetailViewController () <UITableViewDelegate,UITableViewDataSource,OrderDetailCellDelegate>

/** 商品信息 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTableViewHeight;

/** 备注 */
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIView *reviewView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conReviewHeight;

/** 底部Bar */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conBottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conBottomViewBottom;
/** 未付款 */
@property (strong, nonatomic) IBOutlet UIView *unPayView;
@property (weak, nonatomic) IBOutlet UILabel *shouldPayLabel;
- (IBAction)cancelOrder;
- (IBAction)pay;

/** UI */
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UITextView *postscriptTextView;

@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingLabel;

@end

@implementation BNWOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self setupOrder];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWOrderDetailCell" bundle:nil] forCellReuseIdentifier:@"BNWOrderDetailCell"];
    self.tableView.rowHeight = 100;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.scrollView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.scrollView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    /** 设置备注 */
    self.conReviewHeight.constant = self.reviewTextView.contentSize.height;
    [self.reviewView layoutIfNeeded];
    
    /** 设置底部bar */
    NSString *orderState = self.order.pay_status;
    if ([orderState isEqualToString:@"待付款"]) {
        /** 没有付款     */
        self.conBottomViewHeight.constant = self.unPayView.size.height;
        [self.bottomView layoutIfNeeded];
        [self.bottomView addSubview:self.unPayView];
        [self.unPayView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.unPayView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.unPayView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.unPayView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    } else {
        /** 确认订单     */
        self.conBottomViewHeight.constant = 0;
        [self.bottomView layoutIfNeeded];
    }
}

#pragma mark - 键盘收下
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 设置信息
- (void)setupOrder
{
    /** 订单信息     */
    self.orderNumberLabel.text = self.order.order_sn;
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.order.order_amount];
    self.orderDateLabel.text = self.order.add_time;
    /** 收货信息     */
    self.nameLabel.text = self.order.consignee;
    self.phoneLabel.text = self.order.mobile;
    BNWUserSite *userSite = [BNWUserSite new];
    userSite.province = self.order.province;
    userSite.city = self.order.city;
    userSite.district = self.order.district;
    userSite.address = self.order.address;
    self.addressDetailLabel.text = [self setupAddressDetail:userSite];
    /** 订单备注     */
    self.postscriptTextView.text = self.order.remark;
    /** 订单价格     */
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.order.goods_amount];
    self.shippingLabel.text = [NSString stringWithFormat:@"￥%@",self.order.shipping_fee];
    /** 未付款的金额     */
    self.shouldPayLabel.text = self.orderPriceLabel.text;
}

#pragma mark - IBActions
/**
 *  取消订单
 */
- (IBAction)cancelOrder
{
    
}

/**
 *  购买
 */
- (IBAction)pay
{
    BNWPayModeViewController *payModeVc = [BNWPayModeViewController new];
    payModeVc.orderDetail = self.order;
    [self.navigationController pushViewController:payModeVc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.conTableViewHeight.constant = self.order.goods.count * 100;
    [self.tableView layoutIfNeeded];
    
    return self.order.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWOrderDetailCell *cell = [BNWOrderDetailCell cellWithTableView:tableView];
    BNWOrder *order = self.order;
    for (BNWGoods *goods in order.goods) {
        goods.withoutReview = order.isWithoutReview;
    }
    cell.goods = order.goods[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BNWGoodsDetailViewController *goodsDetailVc = [BNWGoodsDetailViewController new];
    BNWGoods *goods = self.order.goods[indexPath.row];
    goodsDetailVc.goods_id = goods.goods_id;
    [self.navigationController pushViewController:goodsDetailVc animated:YES];
}

#pragma mark - OrderDetailCellDelegate
- (void)orderDetailCellReviewButtonDidClickWithGoods:(BNWGoods *)goods
{
    BNWReviewGoodsViewController *reviewGoodsVc = [BNWReviewGoodsViewController new];
    reviewGoodsVc.goods = goods;
    [self.navigationController pushViewController:reviewGoodsVc animated:YES];
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


#pragma mark - keyboard
-(void)keyboradWillShowWithFrame:(CGRect)keyboradFrame
{
    self.conBottomViewBottom.constant = keyboradFrame.size.height;
    [self.bottomView layoutIfNeeded];
}

-(void)keyboradWillHide
{
    self.conBottomViewBottom.constant = 0;
    [self.bottomView layoutIfNeeded];
}

-(void)keyboradWillShow:(NSNotification *)notification
{
    CGRect keyboardFrameEnd;
    double duration = 0;
    NSDictionary *info = [notification userInfo];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameEnd];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [UIView animateWithDuration:duration animations:^{
        [self keyboradWillShowWithFrame:keyboardFrameEnd];
    } completion:^(BOOL finished) {
//        [self keyboradShowComplet];
    }];
}

-(void)keyboradWillHide:(NSNotification *)notification
{
    double duration = 0;
    NSDictionary *info = [notification userInfo];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [UIView animateWithDuration:duration animations:^{
        [self keyboradWillHide];
    } completion:^(BOOL finished) {
//        [self keyboradHideComplet];
    }];
}
@end
