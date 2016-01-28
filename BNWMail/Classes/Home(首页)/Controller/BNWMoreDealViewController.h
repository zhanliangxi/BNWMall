//
//  BNWMoreDealViewController.h
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNWMoreDealViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *moreDealList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
