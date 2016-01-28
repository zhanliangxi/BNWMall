//
//  BNWAllSiteViewController.h
//  BNWMail
//
//  Created by iOSLX1 on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNWAccount.h"
@class BNWUserSite;
@interface BNWAllSiteViewController : UIViewController

//@property (strong,nonatomic) NSMutableArray *siteList;

@property (copy,nonatomic) void (^selSiteViewBlock)(BNWUserSite *userSite);


@end
