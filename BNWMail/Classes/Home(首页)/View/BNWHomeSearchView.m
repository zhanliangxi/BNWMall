//
//  BNWHomeSearchView.m
//  BNWMail
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#define cacheFilename [kDocumentFolder stringByAppendingPathComponent:@"historyCache"]

#import "BNWHomeSearchView.h"

#import "SFTag.h"
#import "SFTagView.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "BNWHotTag.h"
#import "BNWHttpTool.h"
#import "BNWGoods.h"
#import "BNWGoodsListViewController.h"
#import "BNWHomeViewController.h"
#import "BNWMoreDealViewController.h"
#import "BNWMoreDeal.h"

@interface BNWHomeSearchView () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

- (IBAction)cancel:(id)sender;

@property (nonatomic,strong) NSMutableArray *hotList;
@property (nonatomic,strong) NSMutableArray *historyList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UIView *headerContainer;
@property (weak, nonatomic) IBOutlet UIView *headerTagView;
@property (strong, nonatomic) SFTagView *tagView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@property (weak, nonatomic) IBOutlet UIView *footerView;
- (IBAction)clearAllHistroy;
@property (weak, nonatomic) IBOutlet UIButton *clearAllHistroyButton;

@end

@implementation BNWHomeSearchView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadNewData];
    [self setupHeaderView];
    [self setupFooterView];
    
    self.historyList = [[NSArray arrayWithContentsOfFile:cacheFilename] mutableCopy];
}

#pragma mark - update
- (void)loadNewData
{
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=begin";
    
    [BNWHttpTool post:url params:nil success:^(id json) {
        self.hotList = [BNWHotTag objectArrayWithKeyValuesArray:json];
        
        for (BNWHotTag *hotTag in self.hotList) {
            SFTag *tag = [SFTag tagWithText:hotTag.keyword];
            tag.textColor = [UIColor whiteColor];
            tag.bgColor   = APP_NAV_BAR_COLOR;
            tag.target = self;
            tag.action = @selector(handleTag:);
            tag.cornerRadius = 5;
            
            [self.tagView addTag:tag];
        }

        [self.loadingView stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)setupHeaderView
{
    self.tableView.tableHeaderView = self.headerContainer;
    
    [self.headerTagView addSubview:self.tagView];
    
    [self.tagView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.tagView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.tagView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    self.headerTagView.clipsToBounds = YES;
}

- (void)setupFooterView
{
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - 监听方法
- (void)handleTag:(UIButton *)btn
{
    [MBProgressHUD showSuccess:btn.titleLabel.text];
    // 开始搜索
    [self searchWithKeyword:btn.titleLabel.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 归档搜索记录
    [self.historyList insertObject:textField.text atIndex:0];
    [self.historyList writeToFile:cacheFilename atomically:YES];
    
    // 开始搜索
    [self searchWithKeyword:textField.text];

    return YES;
}

- (void)searchWithKeyword:(NSString *)keyword
{
    [MBProgressHUD showMessage:@"正在搜索"];
    // 退出键盘
    [self endEditing:YES];
    
    if ([self.controller isMemberOfClass:[BNWHomeViewController class]]) {
        
        [MBProgressHUD hideHUD];
        [self hideSearchView];
        
        BNWGoodsListViewController *goodsListVc = [BNWGoodsListViewController new];
        goodsListVc.keyword = keyword;
        [self.controller.navigationController pushViewController:goodsListVc animated:YES];
    
    } else if ([self.controller isMemberOfClass:[BNWMoreDealViewController class]]) {
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=group_list";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"keyword"] = keyword;
        
        [BNWHttpTool post:url params:params success:^(id json) {
            
            [MBProgressHUD hideHUD];
            [self hideSearchView];
            
            NSMutableArray *dealList = [BNWMoreDeal objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            
            // 让controller自己刷新数据
            BNWMoreDealViewController *moreDealVc = (BNWMoreDealViewController *)self.controller;
            moreDealVc.moreDealList = dealList;
            [moreDealVc.tableView reloadData];
    
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUD];
            NSLog(@"%@",error);
            
        }];

    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchHistoryCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchHistoryCell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.historyList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle
	forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果正在提交删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.historyList removeObjectAtIndex:indexPath.row];
        
        [self.historyList writeToFile:cacheFilename atomically:YES];
        
        // 删除刷新要用deleteRowsAtIndexPaths
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [MBProgressHUD showSuccess:self.historyList[indexPath.row]];
    // 开始搜索
    [self searchWithKeyword:self.historyList[indexPath.row]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

#pragma mark - 显示和隐藏
-(void)showSearchViewInView:(UIView *)view
{
    [view addSubview:self];
    
    [self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.searchField becomeFirstResponder];
    }];
    
}

-(void)hideSearchView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - IBAction
- (IBAction)cancel:(id)sender
{
    [self hideSearchView];
}

- (IBAction)clearAllHistroy
{
    [self.historyList removeAllObjects];
    
    [self.historyList writeToFile:cacheFilename atomically:YES];
    
    [self.tableView reloadData];
}


#pragma mark - 懒加载

- (NSMutableArray *)historyList
{
    if (!_historyList) {
        _historyList = [NSMutableArray array];
    }
    return _historyList;
}

- (NSMutableArray *)hotList
{
    if (!_hotList) {
        _hotList = [NSMutableArray array];
    }
    return _hotList;
}

- (SFTagView *)tagView
{
    if(!_tagView)
    {
        _tagView = [[SFTagView alloc] init];
        _tagView.margin    = UIEdgeInsetsMake(8, 8, 8, 8);
        _tagView.insets    = 8;
        _tagView.lineSpace = 8;
        _tagView.backgroundColor = [UIColor whiteColor];
    }
    return _tagView;
}
@end
