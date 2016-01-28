//
//  BNWGetRecordViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWGetRecordViewController.h"
#import "JTCalendar.h"
#import "NSDate+FSExtension.h"
#import "BNWAccountTool.h"
#import "BNWHttpTool.h"
#import "MJExtension.h"
#import "BNWGetDate.h"
#import "BNWCommodityRecord.h"
#import "MBProgressHUD+MJ.h"

@interface BNWGetRecordViewController () <JTCalendarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;



@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;
@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (nonatomic,strong) NSMutableArray *datesSelected;

/**
 *  领取过的日期
 */

@property (strong,nonatomic) NSMutableArray *getDateS;


@end

@implementation BNWGetRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calendarManager = [JTCalendarManager new];
    self.calendarManager.delegate = self;
    
    
    self.calendarManager.settings.pageViewHaveWeekDaysView = NO;
    self.calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    
    self.weekDayView.manager = _calendarManager;
    [self.weekDayView reload];
    
    [self.calendarManager setMenuView:_calendarMenuView];
    [self.calendarManager setContentView:_calendarContentView];
    [self.calendarManager setDate:[NSDate date]];
    
    self.dateLabel.text = [[self dateFormatter] stringFromDate:[NSDate date]];
    
    self.calendarMenuView.scrollView.scrollEnabled = NO; // Scroll not supported with JTVerticalCalendarView

    
    [self getDay];
    
    [self getGoodsRecord:[NSDate date]];
}
- (void)getDay{
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/order.php?action=already_get_day";
    BNWAccount *account = [BNWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[phoneNumberKey] = account.mobile_phone;
    params[tokenKey] = account.token;
    params[@"user_id"] = account.user_id;
    
    [BNWHttpTool post:url params:params success:^(id json) {
        self.getDateS = [BNWGetDate objectArrayWithKeyValuesArray:json];
        [self.calendarManager reload];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - CalendarManager delegate
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    if ([self haveEventForDay:dayView.date]) {
        // 如果有领取纪录
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = APP_NAV_BAR_COLOR;
        dayView.textLabel.textColor = [UIColor whiteColor];
    } else {
        // 没有领取纪录
        if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
            dayView.circleView.hidden = NO;
            dayView.circleView.backgroundColor = APP_BUTTON_COLOR;
            dayView.textLabel.textColor = [UIColor whiteColor];
        }
        // Today
        if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
            dayView.circleView.hidden = NO;
            dayView.circleView.backgroundColor = APP_BUTTON_COLOR;
            dayView.textLabel.textColor = [UIColor whiteColor];
        }
        // Other month
        else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
            dayView.circleView.hidden = YES;
            dayView.textLabel.textColor = [UIColor lightGrayColor];
        }
        // Another day of the current month
        else{
            dayView.circleView.hidden = YES;
            dayView.textLabel.textColor = [UIColor blackColor];
        }
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    // 如果点击的是下个月的 就滑动到下个月
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    [self getGoodsRecord:dayView.date];
     self.dateLabel.text = [[self dateFormatter] stringFromDate:dayView.date];
}

- (void)getGoodsRecord:(NSDate *)date{
    
    [MBProgressHUD showMessage:@"正在加载.." toView:self.view];
    
    NSString *time = [NSString stringWithFormat:@"%zd",(long)[date timeIntervalSince1970]];
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/order.php?action=get_record";
    BNWAccount *account = [BNWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[phoneNumberKey] = account.mobile_phone;
    params[tokenKey] = account.token;
    params[@"user_id"] = account.user_id;
    params[@"get_time"] = time;
    [BNWHttpTool post:url params:params success:^(id json) {
        if ([json[@"code"] isEqualToString:@"00001"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.datesSelected = [BNWCommodityRecord objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            self.amountLabel.text = [NSString stringWithFormat:@"当天节省:%@元",[json[@"amount"] stringValue]];
            NSMutableString *allGoods = [NSMutableString string];
            for (BNWCommodityRecord *commodityRecord in self.datesSelected) {
                [allGoods appendString:[NSString stringWithFormat:@"%@%.0lf,",commodityRecord.goods_name,commodityRecord.is_get_weight.doubleValue * commodityRecord.goods_number.doubleValue]];
            }
            self.contentLabel.text = allGoods;
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.dateLabel.text = [[self dateFormatter] stringFromDate:date];
            self.contentLabel.text = @"没有领取";
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Fake data
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    for (BNWGetDate *getDate in self.getDateS) {
        if ([[[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:getDate.add_time.doubleValue]] isEqualToString:[[self dateFormatter] stringFromDate:date]]) {
            
            return YES;
        }
    }
    return NO;
    
}

#pragma mark - 懒加载
- (NSMutableArray *)datesSelected
{
    if (!_datesSelected) {
        _datesSelected = [NSMutableArray array];
    }
    return _datesSelected;
}

- (NSMutableArray *)getDateS{
    if (_getDateS == nil) {
        _getDateS = [[NSMutableArray alloc] init];
    }
    return _getDateS;
}


@end
