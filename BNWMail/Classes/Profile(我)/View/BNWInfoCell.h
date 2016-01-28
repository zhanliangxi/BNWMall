//
//  BNWInfoCell.h
//  BNWMail
//
//  Created by iOSLX1 on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNWAccount.h"
@interface BNWInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong,nonatomic) BNWAccount *account;

- (void)cellWithAccount:(BNWAccount *)account didIndex:(NSInteger)index;

@end
