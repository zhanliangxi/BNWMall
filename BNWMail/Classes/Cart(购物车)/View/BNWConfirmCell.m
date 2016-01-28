//
//  BNWConfirmCell.m
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWConfirmCell.h"
#import "UIImageView+WebCache.h"
#import "BNWCart.h"
#import "MBProgressHUD+MJ.h"
#import "BNWGoods.h"
#import "BNWCommodity.h"

@interface BNWConfirmCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

/** 数量文本框 */
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
/** 数量- */
@property (weak, nonatomic) IBOutlet UIButton *minus;
/** 数量+ */
@property (weak, nonatomic) IBOutlet UIButton *plus;
- (IBAction)plusDidClick;
- (IBAction)minusDidClick;
- (IBAction)textFieldDidChangeValue:(UITextField *)textField;
- (IBAction)textFieldBeginEdit:(UITextField *)sender;

- (IBAction)goodsDidClick;

/** 商品数量 */
@property (nonatomic,assign) NSInteger number;

@end

@implementation BNWConfirmCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWConfirmCell";
    BNWConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWConfirmCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    return cell;
}

- (void)setCart:(BNWCart *)cart
{
    _cart = cart;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:cart.goods_thumbs] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = cart.goods_name;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",cart.goods_price];
    
    self.numberTextField.text = [NSString stringWithFormat:@"%@",cart.goods_number];
    
    // 判断状态
    self.number = [self.numberTextField.text integerValue];
    if (self.number == 1) {
        self.minus.enabled = NO;
    } else if (self.number == 99) {
        self.plus.enabled = NO;
    } else {
        self.minus.enabled = YES;
        self.plus.enabled = YES;
    }
}


- (void)setCommodity:(BNWCommodity *)commodity{
    _commodity = commodity;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:commodity.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = commodity.goods_name;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥0"];
    
    self.numberTextField.text = [NSString stringWithFormat:@"%@",commodity.goods_number];
    
   self.number = [self.numberTextField.text integerValue];
    if (self.number == 1) {
        self.minus.enabled = NO;
    } else if (self.number == 99) {
        self.plus.enabled = NO;
    } else {
        self.minus.enabled = YES;
        self.plus.enabled = YES;
    }
    self.numberTextField.enabled = NO;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - IBAction
- (IBAction)goodsDidClick
{
    if ([self.delegate respondsToSelector:@selector(confirmCellDidClickCart:)]) {
        [self.delegate confirmCellDidClickCart:self.cart];
    }
}

- (IBAction)plusDidClick
{
    [self.numberTextField resignFirstResponder];
    self.minus.enabled = YES;
    self.number ++ ;
    
    [self sendNumberData];
    // 改变数量
    [self changeGoodsNumber];
}

- (IBAction)minusDidClick
{
    [self.numberTextField resignFirstResponder];
    self.plus.enabled = YES;
    self.number -- ;
    
    [self sendNumberData];
    // 改变数量
    [self changeGoodsNumber];
}

- (IBAction)textFieldDidChangeValue:(UITextField *)textField
{
    if ([textField.text integerValue] > 99 || [textField.text integerValue] < 1) {
        
        [MBProgressHUD showError:@"请输入0-99之间的数量"];
        textField.text = [NSString stringWithFormat:@"%zd",self.number];
        self.plus.enabled = YES;
        self.minus.enabled = YES;
        return;
    }
    
    self.plus.enabled = YES;
    self.minus.enabled = YES;
    
    self.number = [textField.text integerValue];
    
    [self sendNumberData];
    // 改变数量
    [self changeGoodsNumber];
    
}

- (IBAction)textFieldBeginEdit:(UITextField *)sender
{
    self.plus.enabled = NO;
    self.minus.enabled = NO;
}

- (void)sendNumberData
{
    // 1.判断输入
    if (self.number == 99) {
        self.plus.enabled = NO;
    } else {
        self.plus.enabled = YES;
    }
    if (self.number == 1) {
        self.minus.enabled = NO;
    } else {
        self.minus.enabled = YES;
    }
    
    // 2.改变模型
    self.cart.goods_number = [NSString stringWithFormat:@"%zd",self.number];
    self.commodity.goods_number = [NSString stringWithFormat:@"%zd",self.number];
    // 3.更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
       self.numberTextField.text = [NSString stringWithFormat:@"%zd",self.number];
    });
    // 4.发送代理
    if ([self.delegate respondsToSelector:@selector(confirmCellUpdateDate)]) {
        [self.delegate confirmCellUpdateDate];
    }
}

- (void)changeGoodsNumber
{
    // 5.改变数量的代理
    if ([self.delegate respondsToSelector:@selector(confirmCellUpdateGoodsNumberWithCart:)]) {
        [self.delegate confirmCellUpdateGoodsNumberWithCart:self.cart];
    }
}
@end
