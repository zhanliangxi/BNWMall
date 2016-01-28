//
//  BNWOrderMainViewController.h
//  BNWMail
//
//  Created by mac on 15/8/7.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNWOrderMainViewController : UITableViewController

/**
 *  设置请求参数:交给子类去实现
 */
//- (void)setupParams:(NSString *)params;

@property (nonatomic,copy) NSString *orderState;

@end
