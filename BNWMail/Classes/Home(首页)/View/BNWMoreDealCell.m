//
//  BNWMoreDealCell.m
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWMoreDealCell.h"
#import "CenterLineLabel.h"
#import "UIImageView+WebCache.h"
#import "BNWMoreDeal.h"
#import "DateTools.h"

@interface BNWMoreDealCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet CenterLineLabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
- (IBAction)buy;


@property (nonatomic,strong) NSTimer *timer;

@end

@implementation BNWMoreDealCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWMoreDealCell";
    BNWMoreDealCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWMoreDealCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setMoreDeal:(BNWMoreDeal *)moreDeal
{
    _moreDeal = moreDeal;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:moreDeal.goods_thumb] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = moreDeal.goods_name;
    
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",moreDeal.promote_price];
    
    self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%@",moreDeal.shop_price];
    

    if (![moreDeal.goods_number isEqualToString:@"0"]) {
        
        // 有货  倒计时
        self.leftCountLabel.text = [NSString stringWithFormat:@"共%@份",moreDeal.goods_number];
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        // 设置时间
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupDate) userInfo:nil repeats:YES];
        [self.timer fire];
        
    } else {
        // 没有货的情况 , 不倒计时
        self.dateLabel.text = @"";
        self.leftCountLabel.text = @"已售罄";
        [self.buyButton setTitle: @"已售罄" forState:UIControlStateDisabled];
        [self.buyButton setBackgroundColor:[UIColor whiteColor]];
        [self.buyButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.buyButton setBackgroundImage:[UIImage imageNamed:@"home_deal_saleEmpty"] forState:UIControlStateDisabled];
        self.buyButton.enabled = NO;
    }
}

#pragma mark - IBAction
- (IBAction)buy
{
    if ([self.delegate respondsToSelector:@selector(moreDealBuyButtonDidClickWithDeal:)]) {
        [self.delegate moreDealBuyButtonDidClickWithDeal:self.moreDeal];
    }
}

- (void)setupDate
{
    if ([self.moreDeal.goods_number isEqualToString:@"0"]) return;
    
    NSDate *start = [NSDate dateWithString:self.moreDeal.start_time formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateInfo = [NSString string];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date] toDate:start options:0];
    if (components.month >= 0 & components.day >= 0 & components.hour >= 0 & components.minute >= 0 & components.second >= 0) {
        // 团购未开始
        
        [self.buyButton setTitle: @"即将开始" forState:UIControlStateDisabled];
        [self.buyButton setTitleColor:APP_BUTTON_COLOR forState:UIControlStateDisabled];
        [self.buyButton setBackgroundColor:[UIColor whiteColor]];
        [self.buyButton setBackgroundImage:[UIImage imageNamed:@"home_deal_beginSale"] forState:UIControlStateDisabled];
        self.buyButton.enabled = NO;
        
        if (components.month == 0) {
            // 不到一个月
            dateInfo = [NSString stringWithFormat:@"%zd天%zd小时%zd分钟%zd秒后开始抢",components.day,components.hour,components.minute,components.second];
        } else if (components.day == 0){
            // 不到一天
            dateInfo = [NSString stringWithFormat:@"%zd小时%zd分钟%zd秒后开始抢",components.hour,components.minute,components.second];
        } else {
            // 不到一年
            dateInfo = [NSString stringWithFormat:@"%zd月%zd天%zd小时%zd分钟%zd秒后开始抢",components.month,components.day,components.hour,components.minute,components.second];
        }
    } else {
        // 团购已经开始
        
        [self.buyButton setTitle: @"立即抢购" forState:UIControlStateNormal];
        [self.buyButton setBackgroundColor:APP_BUTTON_COLOR];
        self.buyButton.enabled = YES;
        
        // 算出结束时间
        NSDate *last = [NSDate dateWithString:self.moreDeal.end_time formatString:@"yyyy-MM-dd HH:mm:ss"];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date] toDate:last options:0];
        
        
        if (components.month >= 0 & components.day >= 0 & components.hour >= 0 & components.minute >= 0 & components.second >= 0) {
            // 时间未过期
            
            // 团购未开始
            if (components.month == 0) {
                // 不到一个月
                dateInfo = [NSString stringWithFormat:@"剩余%zd天%zd小时%zd分钟%zd秒",components.day,components.hour,components.minute,components.second];
            } else if (components.day == 0){
                // 不到一天
                dateInfo = [NSString stringWithFormat:@"剩余%zd小时%zd分钟%zd秒",components.hour,components.minute,components.second];
            } else {
                // 不到一年
                dateInfo = [NSString stringWithFormat:@"剩余%zd月%zd天%zd小时%zd分钟%zd秒",components.month,components.day,components.hour,components.minute,components.second];
            }
            
        } else {
            // 时间过期了
            
            [self.buyButton setTitle: @"抢购结束" forState:UIControlStateNormal];
            [self.buyButton setBackgroundColor:[UIColor whiteColor]];
            [self.buyButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            [self.buyButton setBackgroundImage:[UIImage imageNamed:@"home_deal_saleEmpty"] forState:UIControlStateDisabled];
            self.buyButton.enabled = NO;
            
            dateInfo = @"过期啦";
        }
    }
    
    self.dateLabel.text = dateInfo;
}
@end
