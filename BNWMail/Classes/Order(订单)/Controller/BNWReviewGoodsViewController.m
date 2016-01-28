//
//  BNWReviewGoodsViewController.m
//  BNWMail
//
//  Created by mac on 15/8/21.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWReviewGoodsViewController.h"
#import "BNWGoods.h"
#import "HCSStarRatingView.h"
#import "BNWAccount.h"
#import "BNWAccountTool.h"
#import "BNWHttpTool.h"
#import "MBProgressHUD+MJ.h"

@interface BNWReviewGoodsViewController ()
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)review;

@end

@implementation BNWReviewGoodsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.goods.goods_name;
}

- (IBAction)review
{
    BNWAccount *account = [BNWAccountTool account];
    NSString *url = @"http://ecshop.dadazu.com/new_api/inc/goods.php?action=comment";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"rec_id"] = self.goods.rec_id;
    params[@"token"] = account.token;
    params[@"comment_rank"] = @(self.ratingView.value);
    params[@"user_name"] = account.user_name;
    params[@"status"] = @"1";
    params[@"user_id"] = account.user_id;
    params[@"content"] = self.textView.text;
    params[@"mobile_phone"] = account.mobile_phone;
    
    [BNWHttpTool post:url params:params success:^(id json) {
        if ([json[@"return_code"] isEqualToString:@"00001"]) {
            [MBProgressHUD showSuccess:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"评价失败"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
