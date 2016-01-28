//
//  BNWMacros.h
//  BNWMail
//
//  Created by 杨育彬 on 15/8/2.
//  Copyright (c) 2015年 yb. All rights reserved.
//
#import "AppDelegate.h"
#import "AppMacros.h"

#ifndef BNW_h
#define BNW_h

#define BNWDomain @"http://ecshop.dadazu.com/"

#define APP_NAV_BAR_COLOR            RGBCOLOR(27,181,95)
#define APP_BG_COLOR                 RGBCOLOR(242,230,216)
#define APP_BUTTON_COLOR                 RGBCOLOR(255,143,44)
// 账号的存储路径
#define BNWAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]



#endif