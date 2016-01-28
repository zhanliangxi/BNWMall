//
//  BNWHomeViewController.m
//  BNWMail
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#define cellMargin 5
#define cellRow 4

#import "BNWHomeViewController.h"
#import "BNWHomeSearchView.h"
#import "WBCCyclePageView.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "BNWRecommendGoodsCell.h"
#import "BNWSectionHeaderView.h"
#import "BNWGoodsDetailViewController.h"
#import "BNWMessageViewController.h"
#import "BNWMoreDealViewController.h"
#import "BNWOrderTabPageViewController.h"
#import "MBProgressHUD+MJ.h"
#import <CoreLocation/CoreLocation.h>
#import "BNWHttpTool.h"
#import "AFNetworking.h"
#import "BNWLocationCity.h"
#import "MJExtension.h"
#import "BNWLocationTool.h"
#import "BNWHomeDeal.h"
#import "BNWHomeGoods.h"
#import "BNWADImage.h"

@interface BNWHomeViewController () <WBCCyclePageViewDelegate,WBCCyclePageViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,BNWSectionHeaderViewDelegate,CLLocationManagerDelegate>

/** 搜索栏 */
@property (strong, nonatomic) IBOutlet UIView *searchBar;
- (IBAction)searchBarDidClick;
/** 定位 */
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
- (IBAction)mapViewDidClick;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (nonatomic,assign) CLLocationCoordinate2D currentLocation;
/** 轮播 */
@property (weak, nonatomic) IBOutlet WBCCyclePageView *cycleImageView;
@property (nonatomic,strong) NSMutableArray *cycleImageList;
/** collectionView */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conCollectionHeight;
@property (nonatomic,assign) CGFloat collectionCellWH;
/** 导航栏 */
- (IBAction)messageDidClick:(UIButton *)sender;
- (IBAction)orderDidClick:(UIButton *)sender;
- (IBAction)serviceDidClick:(UIButton *)sender;
- (IBAction)vipDidClick:(UIButton *)sender;
/** 数据 */
@property (nonatomic,strong) NSMutableArray *dealList;
@property (nonatomic,strong) NSMutableArray *goodsList;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation BNWHomeViewController

static NSString * const cellReuseIdentifier = @"BNWRecommendGoodsCell";
static NSString * const sectionReuseIdentifier = @"BNWSectionHeaderView";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏
    [self setupNavBarItem];
    // collection
    [self setupCollectionView];
    // 图片轮播
    [self setupCycleView];
    // 刷新控件
    self.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewData)];
    self.scrollView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    [self.scrollView.header beginRefreshing];
    // 显示上一次的定位信息
    BNWLocationCity *city = [BNWLocationTool city];
    self.mapLabel.text = city ? city.City : @"没有定位信息";
    //启动跟踪定位
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
}

#pragma mark - 刷新
- (void)reloadNewData
{
    // 团购
    NSString *dealUrl = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=group_buy";
    
    [BNWHttpTool post:dealUrl params:nil success:^(id json) {
        self.dealList = [BNWHomeDeal objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        [self.collectionView reloadData];
        
        [self.scrollView.header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        [self.scrollView.header endRefreshing];
    }];
    
    self.currentPage = 1;
    // 商品
    NSString *goodsUrl = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=affiliate";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    
    [BNWHttpTool post:goodsUrl params:params success:^(id json) {
        self.goodsList = [BNWHomeGoods objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        [self.collectionView reloadData];
        
        [self.scrollView.header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.scrollView.header endRefreshing];
    }];
    
}

- (void)reloadMoreData
{
    self.currentPage ++;
    // 商品
    NSString *goodsUrl = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=affiliate";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    
    [BNWHttpTool post:goodsUrl params:params success:^(id json) {
        
        // 请求失败
        if ([json[@"code"] isEqualToString:@"00002"]) {
            [MBProgressHUD showError:@"没有更多推荐商品"];
            [self.scrollView.footer endRefreshing];
            return;
        }
        
        NSArray *newList = [BNWHomeGoods objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
        [self.goodsList addObjectsFromArray:newList];
        
        [self.collectionView reloadData];
        [self.scrollView.footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        [self.collectionView reloadData];
        [self.scrollView.footer endRefreshing];
        
        // 加载失败page--
        if (self.currentPage > 1) {
            self.currentPage -- ;
        }
    }];
}

#pragma mark - WBCCyclePageViewDataSource
- (NSUInteger)numberOfPagesInCyclePageView
{
    return self.cycleImageList.count;
}

- (void)cyclePageView:(WBCCyclePageView *)cyclePageView loadImageForImageView:(UIImageView *)imageView atIndex:(NSUInteger)index
{
    BNWADImage *ad = self.cycleImageList[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:ad.ad_code] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations firstObject]; //取出第一个位置
    CLLocationCoordinate2D coordinate = location.coordinate; //位置坐标
    self.currentLocation = coordinate;
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [self.locationManager stopUpdatingLocation];
}

#pragma mark 根据坐标取得地名
- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        经度：113.966746,纬度：22.585017
        
        
        CLPlacemark *placemark = [placemarks firstObject];
        NSDictionary *address = placemark.addressDictionary;
        NSLog(@"%@",address);
        [MBProgressHUD hideHUD];
        if (!address) {
            [MBProgressHUD showError:@"获取定位失败,请重新定位"];
            self.mapLabel.text = @"没有定位信息";
        } else {
            // 缓存位置
            BNWLocationCity *city = [BNWLocationCity objectWithKeyValues:address];
            [BNWLocationTool saveCity:city];
            
            self.mapLabel.text = city.City;
        }
    }];
}

#pragma mark - 监听方法
- (IBAction)mapViewDidClick
{
    if (![CLLocationManager locationServicesEnabled]) {
        [MBProgressHUD showError:@"定位服务未打开,请设置打开"];
        return;
    }
    
    //启动跟踪定位
    [self.locationManager startUpdatingLocation];
    
    [self getAddressByLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude];
    
    [MBProgressHUD showMessage:@"正在获取定位"];
    self.mapLabel.text = @"定位中";
}

- (IBAction)searchBarDidClick
{
    BNWHomeSearchView *searchView = [BNWHomeSearchView viewWithNibName:@"BNWHomeSearchView"];
    searchView.controller = self;
    [searchView showSearchViewInView:KEY_WINDOW];
}

- (IBAction)messageDidClick:(UIButton *)sender
{
    BNWMessageViewController *messageVc = [BNWMessageViewController new];
    [self.navigationController pushViewController:messageVc animated:YES];
}

- (IBAction)orderDidClick:(UIButton *)sender
{
    BNWOrderTabPageViewController *orderVc = [BNWOrderTabPageViewController new];
    [self.navigationController pushViewController:orderVc animated:YES];
}

- (IBAction)serviceDidClick:(UIButton *)sender
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"123465789"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)vipDidClick:(UIButton *)sender
{
    self.tabBarController.selectedIndex = 2;

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 算行高
    NSInteger dealItemBig = self.collectionCellWH * 1.5;
    NSInteger dealItemSmall = self.dealList.count <= 2 ? 0 : self.collectionCellWH ;
    NSInteger dealMargin = self.dealList.count <= 2 ? cellMargin * 2 : ((((self.dealList.count - 2) / cellRow) + cellRow - 1) / cellRow ) * cellMargin + (2 * cellMargin);
    NSInteger goodsMargin = (((self.goodsList.count + cellRow - 1) / cellRow) + 2) * cellMargin;
    
    self.conCollectionHeight.constant = (dealItemBig + dealItemSmall) + ((self.goodsList.count / cellRow) + 1.2) * self.collectionCellWH + dealMargin + goodsMargin;
    [self.collectionView layoutIfNeeded];
    
    if (section == 0) {
        return self.dealList.count;
    } else if (section == 1) {
        return self.goodsList.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BNWRecommendGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.deal = self.dealList[indexPath.row];
    } else if (indexPath.section == 1) {
        cell.goods = self.goodsList[indexPath.row];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.item == 0 || indexPath.item == 1) {
            return CGSizeMake((SCREEN_WIDTH - 3 * cellMargin) * 0.5, self.collectionCellWH * 1.5);
        }
    }
    return CGSizeMake(self.collectionCellWH, self.collectionCellWH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BNWSectionHeaderView *header =  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionReuseIdentifier forIndexPath:indexPath];
    header.delegate = self;
    
    switch (indexPath.section) {
        case 0: {
            header.titleLabel.text = @"团购活动";
            header.headerView.backgroundColor = RGBCOLOR(54, 169, 71);
            header.moreButton.hidden = NO;
            break;
        }
        case 1: {
            header.titleLabel.text = @"推荐商品";
            header.headerView.backgroundColor = RGBCOLOR(253, 200, 100);
            header.moreButton.hidden = YES;
            break;
        }
    }
    
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH,44);
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BNWHomeGoods *homeGoods = self.goodsList[indexPath.item];
    BNWGoodsDetailViewController *detailVc = [BNWGoodsDetailViewController new];
    detailVc.goods_id = homeGoods.goods_id;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - BNWSectionHeaderViewDelegate
- (void)sectionHeaderMoreButtonDidClick
{
    BNWMoreDealViewController *moreDealVc = [BNWMoreDealViewController new];
    [self.navigationController pushViewController:moreDealVc animated:YES];
}

#pragma mark - 私有方法
- (void)setupNavBarItem
{
    self.navigationItem.title = @"";
    
    self.mapView.width = SCREEN_WIDTH * 0.2;
    self.mapView.height = 30;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.mapView];
    
    self.searchBar.width = SCREEN_WIDTH * 0.7;
    self.searchBar.height = 30;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
}

- (void)setupCollectionView
{
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"BNWRecommendGoodsCell" bundle:nil] forCellWithReuseIdentifier:cellReuseIdentifier];
    // 注册header
    [self.collectionView registerNib:[UINib nibWithNibName:@"BNWSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionReuseIdentifier];
    // 背景颜色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    CGFloat WH = (NSInteger)(SCREEN_WIDTH - ((cellRow + 1) * cellMargin)) / (cellRow);
    self.collectionCellWH = WH;
    
    layout.itemSize = CGSizeMake(WH, WH);                 // 每个cell的大小
    layout.minimumInteritemSpacing = cellMargin;                    // 水平间距;
    layout.minimumLineSpacing = cellMargin;                         //垂直间距
    layout.sectionInset = UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin);
}

- (void)setupCycleView
{
    self.cycleImageView.autoCycle = YES;
    
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/home.php?action=home_ad";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"3";
    
    [BNWHttpTool post:url params:params success:^(id json) {
        self.cycleImageList = [BNWADImage objectArrayWithKeyValuesArray:json];
        [self.cycleImageView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 懒加载

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        
        //定位管理器
        _locationManager=[[CLLocationManager alloc]init];
        
        //如果没有授权则请求用户授权
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            if (IOS8_OR_LATER) {
                [_locationManager requestWhenInUseAuthorization];
            }            
        }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
            //设置代理
            _locationManager.delegate = self;
            //设置定位精度
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            //启动跟踪定位
            [_locationManager startUpdatingLocation];
        }
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (NSMutableArray *)cycleImageList
{
    if (!_cycleImageList) {
        _cycleImageList = [NSMutableArray array];
    }
    return _cycleImageList;
}

- (NSMutableArray *)dealList
{
    if (!_dealList) {
        _dealList = [NSMutableArray array];
    }
    return _dealList;
}

- (NSMutableArray *)goodsList
{
    if (!_goodsList) {
         _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}
@end
