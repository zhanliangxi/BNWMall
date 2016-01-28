//
//  BNWCartCell.m
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWCartCell.h"
#import "UIImageView+WebCache.h"
#import "BNWCart.h"
#import "MBProgressHUD+MJ.h"
#import "BNWGoods.h"

@interface BNWCartCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 单选 */
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
/** 删除 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButton;
/** 数量文本框 */
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
/** 数量- */
@property (weak, nonatomic) IBOutlet UIButton *minus;
/** 数量+ */
@property (weak, nonatomic) IBOutlet UIButton *plus;
- (IBAction)selectButtonDidClick;
- (IBAction)deleteButtonDidClick;
- (IBAction)plusDidClick;
- (IBAction)minusDidClick;
- (IBAction)textFieldDidChangeValue:(UITextField *)textField;
- (IBAction)textFieldBeginEdit:(UITextField *)sender;


/** 商品数量 */
@property (nonatomic,assign) NSInteger number;

@end

@implementation BNWCartCell

- (void)awakeFromNib
{
    [self sendNumberData];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWCartCell";
    BNWCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWCartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    
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
    
    // 勾选
    self.selectButton.selected = cart.isSelected;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (IBAction)selectButtonDidClick
{
    self.selectButton.selected = !self.selectButton.isSelected;
    
    self.cart.selected = !self.cart.isSelected;
    
    [self sendNumberData];
    
    // 代理
    if ([self.delegate respondsToSelector:@selector(cartCellSelectStateChange)]) {
        [self.delegate cartCellSelectStateChange];
    }
}

- (IBAction)deleteButtonDidClick
{
    if ([self.delegate respondsToSelector:@selector(cartCellDeleteWithCart:)]) {
        [self.delegate cartCellDeleteWithCart:self.cart];
    }
}

#pragma mark - 数量加减
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
//    if (self.number == 99) {
//        self.plus.enabled = NO;
//    } else {
//        self.plus.enabled = YES;
//    }
//    if (self.number == 1) {
//        self.minus.enabled = NO;
//    } else {
//        self.minus.enabled = YES;
//    }
    
    // 2.改变模型
    self.cart.goods_number = [NSString stringWithFormat:@"%zd",self.number];
    // 3.更新UI
    self.numberTextField.text = [NSString stringWithFormat:@"%zd",self.number];
    // 4.发送代理
    if ([self.delegate respondsToSelector:@selector(cartCellUpdateData)]) {
        [self.delegate cartCellUpdateData];
    }
}

- (void)changeGoodsNumber
{
    // 5.改变数量的代理
    if ([self.delegate respondsToSelector:@selector(cartCellUpdateGoodsNumberWithCart:)]) {
        [self.delegate cartCellUpdateGoodsNumberWithCart:self.cart];
    }
}
@end
