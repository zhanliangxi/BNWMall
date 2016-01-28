//
//  BNWMessageDetailViewController.m
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWMessageDetailViewController.h"
#import "BNWMessage.h"

@interface BNWMessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation BNWMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息详情";
    
    self.titleLabel.text = self.message.mes_title;
    
    self.dateLabel.text = self.message.mes_time;
    
    self.contentLabel.text = self.message.mes_content;
}

@end
