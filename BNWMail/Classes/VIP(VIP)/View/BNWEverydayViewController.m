//
//  BNWEverydayViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWEverydayViewController.h"
#import "BNWEverydayMenuCell.h"
#import "BNWEverydayCommodityCell.h"
#import "BNWCommodity.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "BNWHttpTool.h"
#import "BNWCategory.h"
#import "BNWConfirmOrderViewController.h"
#import "BNWCommodityTool.h"
#import "MBProgressHUD+MJ.h"
#import "BNWAccountTool.h"

#define cellMargin 5
#define cellRow 2
static NSString * const everydayMenuCell = @"BNWEverydayMenuCell";
static NSString * const everydayCommodityCell = @"BNWEverydayCommodityCell";

@interface BNWEverydayViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong,nonatomic) NSMutableArray *menuList;

@property (strong,nonatomic) NSMutableArray *goodsList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@property (strong,nonatomic) NSMutableArray *allDataList;
@property (nonatomic,copy) NSString *currentCatagory;

@end

@implementation BNWEverydayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTableView];
    [self setupCollectionView];
    [self getData];
}

- (void)getData{
    [MBProgressHUD showMessage:@"加载中"];
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/order.php?action=big_cate_list";
    [BNWHttpTool post:url params:nil success:^(id json) {
        self.menuList = [BNWCategory objectArrayWithKeyValuesArray:json];
        [self.tableView reloadData];
        
        [self loadCategoryDetailData];
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载失败"];
    }];
}

- (void)loadCategoryDetailData
{
    self.allDataList = [NSMutableArray array];
    for (BNWCategory *category in self.menuList) {
        
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/order.php?action=get_goods_list";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"cat_id"] = category.cat_id;
        [BNWHttpTool post:url params:params success:^(id json) {
            self.goodsList = [BNWCommodity objectArrayWithKeyValuesArray:json];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:self.goodsList forKey:category.cat_id];
            [self.allDataList addObject:dict];
            
            NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
        }];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BNWEverydayMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:everydayMenuCell];
    BNWCategory *category = self.menuList[indexPath.row];
    cell.titleLabel.text = category.cat_name;
    return cell;
}
#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNWCategory *category = self.menuList[indexPath.row];
    self.currentCatagory = category.cat_id;
    for (NSDictionary *dict in self.allDataList) {
        if (dict[category.cat_id]) {
            self.goodsList = dict[category.cat_id];
            [self.collectionView reloadData];
        }
    }
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BNWEverydayCommodityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:everydayCommodityCell forIndexPath:indexPath];
    cell.goods = self.goodsList[indexPath.row];
    return cell;
}

- (void)updateAllDataListWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *newDict = [NSDictionary dictionary];
    NSDictionary *willDeleteDict = [NSDictionary dictionary];
    for (NSDictionary *dict in self.allDataList) {
        if (dict[self.currentCatagory]) {
            BNWCommodity *commodity = dict[self.currentCatagory][indexPath.row];
            commodity.selected = !commodity.selected;
            
            newDict = [NSDictionary dictionaryWithObject:dict[self.currentCatagory] forKey:self.currentCatagory];
            willDeleteDict = dict;
        }
    }
    [self.allDataList removeObject:willDeleteDict];
    [self.allDataList addObject:newDict];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateAllDataListWithIndexPath:indexPath];
    [self.collectionView reloadData];
}

#pragma mark -Action methods

- (IBAction)deSel:(id)sender {
    [self getData];
}
- (IBAction)confSel:(id)sender {
    NSMutableArray *selectedList = [NSMutableArray array];
    for (NSDictionary *dict in self.allDataList) {
        //得到词典中所有Value值
        NSEnumerator * enumeratorValue = [dict objectEnumerator];
        
        //快速枚举遍历所有Value的值
        for (NSArray *object in enumeratorValue) {
            for (BNWCommodity *goods in object) {
                if (goods.isSelected) {
                    [selectedList addObject:goods];
                    NSLog(@"%@",goods.goods_name);
                }
            }
        }
    }
    
    BNWAccount *account = [BNWAccountTool account];
    if (account.user_rank.integerValue == 0) {
        [MBProgressHUD showError:@"成为VIP才能领取" toView:self.view];
        return;
    }
    
        BNWConfirmOrderViewController *orderVC = [BNWConfirmOrderViewController new];
        orderVC.confirmList = selectedList;
        orderVC.orderType = BNWConfirmOrderTypeGet;
        [self.navigationController pushViewController:orderVC animated:YES];
    
}

#pragma mark -私有方法
- (void)setupTableView{
    [self.tableView registerNib:[UINib nibWithNibName:everydayMenuCell bundle:nil] forCellReuseIdentifier:everydayMenuCell];
}

- (void)setupCollectionView{
    
    [self.collectionView registerNib:[UINib nibWithNibName:everydayCommodityCell bundle:nil] forCellWithReuseIdentifier:everydayCommodityCell];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.allowsMultipleSelection = YES;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat width  = (SCREEN_WIDTH - self.tableView.width - ((cellRow + 1) * cellMargin)) / cellRow;
    CGFloat height = width + width / 1.4 ;
    layout.itemSize = CGSizeMake(width,height);
    
    layout.minimumLineSpacing = cellMargin;
    layout.minimumInteritemSpacing = cellMargin;
    layout.sectionInset = UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin);
}


#pragma mark -lazy
- (NSMutableArray *)menuList{
    if (_menuList == nil) {
        _menuList = [NSMutableArray array];
    }
    return _menuList;
}
- (NSMutableArray *)goodsList{
    if (_goodsList == nil) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}




@end
