//
//  BNWSettingViewController.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/13.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWSettingViewController.h"
#import "BNWEditPwdViewController.h"
#import "BNWHttpTool.h"
#import "MBProgressHUD+MJ.h"

@interface BNWSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *settinList;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (copy,nonatomic) NSString *trackViewUrl;
@end

@implementation BNWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设置";
    
    
    self.logoutBtn.layer.cornerRadius = 5;
    self.logoutBtn.layer.masksToBounds = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.settinList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.settinList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            BNWEditPwdViewController *editPwdVC = [BNWEditPwdViewController new];
            editPwdVC.titleLabel = @"登录";
            [self.navigationController pushViewController:editPwdVC animated:YES];
            break;
        }
        case 1:{
            
            BNWEditPwdViewController *editPwdVC = [BNWEditPwdViewController new];
            editPwdVC.titleLabel = @"支付";
            [self.navigationController pushViewController:editPwdVC animated:YES];
            
            break;
        }
        case 2:{
            
            [self checkVersion];
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)checkVersion{

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    NSString *url = @"https://itunes.apple.com/cn/lookup";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = APPID;
    
    [BNWHttpTool get:url params:params success:^(id json) {
       
        NSString *version = json[@"results"][0][@"version"];
        self.trackViewUrl = json[@"results"][0][@"trackViewUrl"];
        NSString *trackName = json[@"results"][0][@"trackName"];
       
        if ([version doubleValue] > [currentVersion doubleValue]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:trackName message:[NSString stringWithFormat:@"有新的版本%@，是否前往更新？",version] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
            
        } else{
            [MBProgressHUD showError:@"您使用的是最新版本！" toView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl]];
    }
}

- (IBAction)logout {
    [self.navigationController popViewControllerAnimated:YES];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:BNWAccountPath error:nil];
}

- (NSMutableArray *)settinList{
    if (_settinList == nil) {
        _settinList = [NSMutableArray arrayWithArray:@[
                                                       @"修改登录密码",
                                                       @"修改支付密码",
                                                       @"版本升级",
                                                       @"系统消息",
                                                       @"关于我们"
                                                       ]];
    }
    return _settinList;
}

@end
