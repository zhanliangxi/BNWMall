//
//  BNWGoodsFullDetailViewController.m
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWGoodsFullDetailViewController.h"

@interface BNWGoodsFullDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BNWGoodsFullDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品图文详情";
    
    [self.webView loadHTMLString:self.htmlStr baseURL:nil];
}

@end
