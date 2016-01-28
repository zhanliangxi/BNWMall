//
//  BNWEditSiteViewController.m
//  BNWMail
//
//  Created by 1 on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWEditSiteViewController.h"
#import "BNWEditSiteCell.h"
#import "BNWAccountTool.h"
#import "BNWHttpTool.h"
#import "BNWSite.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "BNWUserSite.h"

static NSString * const kEditSiteCell = @"BNWEditSiteCell";

@interface BNWEditSiteViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *placeholderList;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong,nonatomic) UIPickerView *pickerView;

@property (strong,nonatomic) NSMutableArray *provinceList;

@property (strong,nonatomic) NSMutableArray *cityList;

@property (strong,nonatomic) NSMutableArray *areaList;


@property (strong,nonatomic) NSMutableArray *cityS;
@property (strong,nonatomic) NSMutableArray *areaS;

@property (copy,nonatomic) NSString *province;
@property (copy,nonatomic) NSString *city;
@property (copy,nonatomic) NSString *area;
@end

@implementation BNWEditSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5;
    
    self.title = [NSString stringWithFormat:@"%@地址",self.titleStr];
    [self.tableView registerNib:[UINib nibWithNibName:kEditSiteCell bundle:nil] forCellReuseIdentifier:kEditSiteCell];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 44;
    if ([self.titleStr isEqualToString:@"添加"]) {
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BNWEditSiteCell *cell =  (BNWEditSiteCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.fieldPlaceholder becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.placeholderList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BNWEditSiteCell *cell = [tableView dequeueReusableCellWithIdentifier:kEditSiteCell];
    
    cell.fieldPlaceholder.userInteractionEnabled = YES;
    
    if ([self.titleStr isEqualToString:@"修改"]) {
        switch (indexPath.row) {
            case 0:
                 cell.fieldPlaceholder.text = self.userSite.consignee;
                break;
            case 1:
            {
                if (self.userSite.sex.integerValue == 1) {
                    cell.fieldPlaceholder.text = @"男";
                }else if (self.userSite.sex.integerValue == 2){
                 cell.fieldPlaceholder.text = @"女";
                }
              
                cell.fieldPlaceholder.userInteractionEnabled = NO;
                break;
            }
            case 2:
                cell.fieldPlaceholder.text = self.userSite.mobile;
                break;
            case 3:
            {
                for (BNWSite *site in self.provinceList) {
                    if ([site.region_id isEqualToString:self.userSite.province]) {
                        cell.fieldPlaceholder.text = site.region_name;
                    }
                }
                 break;
            }
               
            case 4:
            {
                for (BNWSite *site in self.cityList) {
                    if ([site.region_id isEqualToString:self.userSite.city]) {
                        cell.fieldPlaceholder.text = site.region_name;
                    }
                }
                break;
            }
            case 5:
            {
                for (BNWSite *site in self.areaList) {
                    if ([site.region_id isEqualToString:self.userSite.district]) {
                        cell.fieldPlaceholder.text = site.region_name;
                    }
                }
                break;
            }
            case 6:
                cell.fieldPlaceholder.text = self.userSite.address;
                break;
            default:
                break;
        }
    }else
    {
        if (indexPath.row == 1) {
              cell.fieldPlaceholder.userInteractionEnabled = NO;
        }
           cell.fieldPlaceholder.placeholder = self.placeholderList[indexPath.row];
    }
    
    
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row ==5) {
        cell.fieldPlaceholder.inputView = self.pickerView;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [self.view endEditing:YES];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BNWEditSiteCell *cell =  (BNWEditSiteCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (buttonIndex == 0) {
       cell.fieldPlaceholder.text = @"男";
        cell.tag = 1;
    }else{
       cell.fieldPlaceholder.text = @"女";
        cell.tag = 2;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component) {
        return self.provinceList.count;
    }else if (1 == component){
        NSMutableArray *cityList = [NSMutableArray array];
        BNWSite *selcomSite = self.provinceList[[pickerView selectedRowInComponent:0]];
        for (BNWSite *site in self.cityList) {
            if ([site.parent_id isEqualToString:selcomSite.region_id]) {
                [cityList addObject:site];
            }
        }
        self.cityS = cityList;
        return cityList.count;
    }else{
        NSMutableArray *cityList = [NSMutableArray array];
        BNWSite *selcomSite = self.provinceList[[pickerView selectedRowInComponent:0]];
        for (BNWSite *site in self.cityList) {
            if ([site.parent_id isEqualToString:selcomSite.region_id]) {
                [cityList addObject:site];
            }
        }
        
        
        NSMutableArray *areaList = [NSMutableArray array];
        BNWSite *selcomSite2 = cityList[[pickerView selectedRowInComponent:1]];
        for (BNWSite *site in self.areaList) {
            if ([site.parent_id isEqualToString:selcomSite2.region_id]) {
                [areaList addObject:site];
            }
        }
        self.areaS = areaList;
        return areaList.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (0 == component) {
        BNWSite *site = self.provinceList[row];
        return site.region_name;
    }else if(1 == component){
        BNWSite *site = self.cityS[row];
        return site.region_name;
    }else{
        BNWSite *site = self.areaS[row];
        return site.region_name;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (0 == component) {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    if (1 == component) {
        [pickerView reloadComponent:2];
    }
    
    [self sitePickerView:pickerView siteList:self.provinceList selCom:0 selCellIndex:3];

    [self sitePickerView:pickerView siteList:self.cityS selCom:1 selCellIndex:4];

    [self sitePickerView:pickerView siteList:self.areaS selCom:2 selCellIndex:5];

}

- (void)sitePickerView:(UIPickerView *)pickerView  siteList:(NSMutableArray *)siteList selCom:(NSInteger)com selCellIndex:(NSInteger)row {
    BNWSite *site = siteList[[pickerView selectedRowInComponent:com]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    BNWEditSiteCell *cell =(BNWEditSiteCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.fieldPlaceholder.text = site.region_name;
        cell.tag = site.region_id.integerValue;
//        NSLog(@"region_id%@,region_name%@",site.region_id,site.region_name);
    });
}

- (IBAction)submitClick {
    
    if (![self isMobileNumber:[self cellWithText:2]]) {
        [MBProgressHUD showError:@"请输入合法手机号码" toView:self.view];
        return;
    }
    if ([self cellWithText:0].length == 0 || [self cellWithText:0].length > 8) {
        [MBProgressHUD showError:@"姓名不能为空且不能超过8个字符" toView:self.view];
        return;
    }
    if ([self cellWithText:6].length == 0 || [self cellWithText:0].length > 20) {
        [MBProgressHUD showError:@"详细地址不能为空且不能超过20个字符" toView:self.view];
        return;
    }
    
    if ([self.titleStr isEqualToString:@"修改"]) {
        BNWAccount *account = [BNWAccountTool account];
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=update";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = account.user_id;
        params[tokenKey] = account.token;
        params[phoneNumberKey] = account.mobile_phone;
        params[@"consignee"] = [self cellWithText:0];
        params[@"sex"] = [self cellWithText:1];
        params[@"mobile"] = [self cellWithText:2];
        params[@"province"] = [self cellWithText:3];
        params[@"city"] = [self cellWithText:4];
        params[@"district"] = [self cellWithText:5];
        params[@"address"] = [self cellWithText:6];
        params[@"address_id"] = self.userSite.address_id;
        NSLog(@"%@",params);
        [BNWHttpTool post:url params:params success:^(id json) {
            if ([json[@"return_code"] isEqualToString:@"00001"]) {
                NSLog(@"%@",params);
                [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求失败" toView:self.view];
        }];
    }else{
        
        BNWAccount *account = [BNWAccountTool account];
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=add_addr";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = account.user_id;
        params[tokenKey] = account.token;
        params[phoneNumberKey] = account.mobile_phone;
        params[@"consignee"] = [self cellWithText:0];
        params[@"sex"] = [self cellWithText:1];
        params[@"mobile"] = [self cellWithText:2];
        params[@"province"] = [self cellWithText:3];
        params[@"city"] = [self cellWithText:4];
        params[@"district"] = [self cellWithText:5];
        params[@"address"] = [self cellWithText:6];
//        NSLog(@"%@",params);
        [BNWHttpTool post:url params:params success:^(id json) {
            NSLog(@"%@",json);
            if ([json[@"return_code"] isEqualToString:@"00001"]) {
                [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求失败" toView:self.view];
        }];

    }
    
}

- (NSString *)cellWithText:(NSInteger)row{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    BNWEditSiteCell *cell =(BNWEditSiteCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (row == 3) {
        if (cell.tag == 0) {
            return self.userSite.province;
        }
     return [NSString stringWithFormat:@"%zd",cell.tag];
    }
    if (row == 4) {
        if (cell.tag == 0) {
            return self.userSite.city;
        }
        return [NSString stringWithFormat:@"%zd",cell.tag];
    }
    if (row == 5) {
        if (cell.tag == 0) {
            return self.userSite.district;
        }
        return [NSString stringWithFormat:@"%zd",cell.tag];
    }
    
    if (row == 1) {
        return [NSString stringWithFormat:@"%zd",cell.tag];
    }
    return cell.fieldPlaceholder.text;
}

- (NSMutableArray *)placeholderList{
    if (_placeholderList == nil) {
        _placeholderList = [NSMutableArray arrayWithArray:@[
                                                            @"姓名",
                                                            @"性别",
                                                            @"手机号",
                                                            @"省",
                                                            @"市",
                                                            @"区",
                                                            @"详细地址"
                                                            ]];
    
    }
    return _placeholderList;
}

- (NSMutableArray *)provinceList{
    if (_provinceList == nil) {
        _provinceList = [BNWSite objectArrayWithFilename:@"consignee.plist"];
    }
    return _provinceList;
}
- (NSMutableArray *)cityList{
    if (_cityList == nil) {
        _cityList = [BNWSite objectArrayWithFilename:@"city.plist"];
    }
    return _cityList;
}
- (NSMutableArray *)areaList{
    if (_areaList == nil) {
        _areaList =  [BNWSite objectArrayWithFilename:@"district.plist"];
    }
    return _areaList;
}

- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.width = SCREEN_WIDTH;
        _pickerView.height = 216;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
