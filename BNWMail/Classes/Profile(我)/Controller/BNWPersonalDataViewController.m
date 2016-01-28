//
//  BNWPersonalDataViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWPersonalDataViewController.h"
#import "BNWInfoCell.h"
#import "BNWSiteCell.h"
#import "BNWAllSiteViewController.h"
#import "BNWEditSiteViewController.h"
#import "BNWHttpTool.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "BNWEditInfoViewController.h"
#import "MJRefresh.h"
#import "BNWUserSite.h"

typedef NS_ENUM(NSInteger, BNWSheetType){
    BNWSheetTypeIcon = 0,
    BNWSheetTypeSex
};

@interface BNWPersonalDataViewController ()<UITableViewDataSource,UITableViewDelegate,BNWSiteCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>




@property (strong,nonatomic) BNWAllSiteViewController *allSiteVC;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *infoList;
@property (strong,nonatomic) BNWAccount *account;
@property (strong, nonatomic) IBOutlet UIView *hearderView;
@property (strong, nonatomic) IBOutlet UIView *iconHearderView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (strong,nonatomic) NSMutableArray *siteList;


@end

@implementation BNWPersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWInfoCell" bundle:nil] forCellReuseIdentifier:@"BNWInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BNWSiteCell" bundle:nil] forCellReuseIdentifier:@"BNWSiteCell"];
    self.tableView.sectionFooterHeight = 5;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getInfo)];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getInfo];
    [self getAllSite];
}
- (void)getInfo{
    BNWAccount *account = [BNWAccountTool account];
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=my_mes";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[phoneNumberKey] = account.mobile_phone;
    params[tokenKey] = account.token;
    [BNWHttpTool post:url params:params success:^(id json) {
        self.account  = [BNWAccount objectWithKeyValues:json];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecshop.dadazu.com/%@",account.user_thum]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败" toView:self.view];
        [self.tableView.header endRefreshing];
    }];
}
- (void)getAllSite{
     BNWAccount *account = [BNWAccountTool account];
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/cart.php?action=get_address";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[phoneNumberKey] = account.mobile_phone;
    params[tokenKey] = account.token;
    [BNWHttpTool post:url params:params success:^(id json) {
    self.siteList = [BNWUserSite objectArrayWithKeyValuesArray:json];
    [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败" toView:self.view];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.infoList[section] count];
    }else {
        return !!self.siteList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
       BNWInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNWInfoCell"];
        cell.titleLabel.text = self.infoList[indexPath.section][indexPath.row];
        [cell cellWithAccount:self.account didIndex:indexPath.row];
       return cell;
    } else {
       BNWSiteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNWSiteCell"];
        cell.delegate = self;
        cell.userSite = self.siteList[0];

        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section == 1 ? self.hearderView : self.iconHearderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  section == 1 ? 190 : 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 85;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.row == 1) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        sheet.tag = BNWSheetTypeSex;
        [sheet showInView:self.view];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 2) {
            BNWEditInfoViewController *editInfoVC = [BNWEditInfoViewController new];
            editInfoVC.titleLabel = self.infoList[indexPath.section][indexPath.row];
            editInfoVC.updateText = (indexPath.row == 0 ? self.account.user_name : self.account.mobile_phone);
            [self.navigationController pushViewController:editInfoVC animated:YES];
        }
    }
}
- (IBAction)tapEditIcon:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    sheet.tag = BNWSheetTypeIcon;
    [sheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == BNWSheetTypeSex) {
        NSString *sex = [NSString string];
        switch (buttonIndex) {
            case 0:
                sex = @"1";
                break;
            case 1:
                sex = @"2";
                break;
            default:
                break;
        }
            BNWAccount *account  = [BNWAccountTool account];
            NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=update_mes";
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[tokenKey] = account.token;
            params[phoneNumberKey] = account.mobile_phone;
            params[@"type"] = @"3";
            params[@"sex"] = sex;
            [BNWHttpTool post:url params:params success:^(id json) {
                if ([json[@"return_code"] isEqualToString:@"00001"]) {
                    [self getInfo];
                    [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"请求失败" toView:self.view];
            }];
        
    }else{
        switch (buttonIndex) {
            case 0:
                [self openCamera];
                break;
            case 1:
                [self openAlbum];
                break;
            default:
                break;
        }
    }
}

#pragma mark -OpenImagePicker Action
- (void)openAlbum
{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)openCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    

}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [UIImage imageWithData:UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 0.2)];
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/favicon.php";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = self.account.user_id;
   [BNWHttpTool post:url params:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       [formData appendPartWithFileData:UIImageJPEGRepresentation(image,1.0) name:@"fileName" fileName:@"icon.jpg" mimeType:@"image/jpg"];
       [MBProgressHUD showMessage:@"正在上传..." toView:self.view];
   } success:^(id json) {
       self.iconView.image = image;
       BNWAccount *account = [BNWAccountTool account];
       account.user_thum = nil;
       [BNWAccountTool saveAccount:account];
       [MBProgressHUD hideHUDForView:self.view animated:YES];
       [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
       [self.tableView reloadData];

   } failure:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
       [MBProgressHUD showError:@"上传失败" toView:self.view];

   }];
}

- (void)siteCellWithEditSite:(BNWSiteCell *)siteCell{
    BNWEditSiteViewController *editSiteVc = [BNWEditSiteViewController new];
    editSiteVc.titleStr  = @"修改";
    editSiteVc.userSite = siteCell.userSite;
    [self.navigationController pushViewController:editSiteVc animated:YES];
}
- (void)siteCellWithDelSite:(BNWSiteCell *)siteCell{
    BNWAccount *account = [BNWAccountTool account];
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=del_address";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[phoneNumberKey] = account.mobile_phone;
    params[tokenKey] = account.token;
    params[@"address_id"] = siteCell.userSite.address_id;
    params[@"user_id"] = account.user_id;
    [BNWHttpTool post:url params:params success:^(id json) {
        if ([json[@"return_code"] isEqualToString:@"00001"]) {
            [MBProgressHUD showError:@"删除成功" toView:self.view];
            [self getAllSite];
        }
    } failure:^(NSError *error) {
        NSLog(@"e%@",error);
    }];

}
- (IBAction)addSite {
    BNWEditSiteViewController *editSiteVc = [BNWEditSiteViewController new];
    editSiteVc.titleStr  = @"添加";
    [self.navigationController pushViewController:editSiteVc animated:YES];
}

- (IBAction)showAllSite {

    __weak typeof(self) _self = self;
    [self.allSiteVC setSelSiteViewBlock:^(BNWUserSite *userSite) {
        BNWAccount *account = [BNWAccountTool account];
        NSString *url = @"http://ecshop.dadazu.com/new_api/inc/my.php?action=default_addr";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[phoneNumberKey] = account.mobile_phone;
        params[tokenKey] = account.token;
        params[@"new_address_id"] = userSite.address_id;
        [BNWHttpTool post:url params:params success:^(id json) {
            if ([json[@"return_code"] isEqualToString:@"00001"]) {
                [_self getAllSite];
            }
        } failure:^(NSError *error) {
        }];
    }];
    
    [self.navigationController pushViewController:self.allSiteVC animated:YES];
    self.allSiteVC = nil;
    
}

- (NSMutableArray *)infoList{
    if (_infoList == nil) {
        _infoList = [NSMutableArray arrayWithArray:@[
                                                     @[@"昵称:",@"性别:",@"手机:"]
                                                     ]];
    }
    return _infoList;
}
- (BNWAllSiteViewController *)allSiteVC{
    if (_allSiteVC == nil) {
        _allSiteVC = [[BNWAllSiteViewController alloc] init];
    }
    return _allSiteVC;
}
- (NSMutableArray *)siteList{
    if (_siteList == nil) {
        _siteList = [[NSMutableArray alloc]init];
    }
    return _siteList;
}

@end
