//
//  BNWConfirmOrderViewController.h
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BNWConfirmOrderType) {
    BNWConfirmOrderTypeCart,
    BNWConfirmOrderTypeBuyNow,
    BNWConfirmOrderTypeGet
} ;

@interface BNWConfirmOrderViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *confirmList;
@property (nonatomic,assign) BNWConfirmOrderType orderType;

@end
