//
//  BNWSiteCell.h
//  BNWMail
//
//  Created by iOSLX1 on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNWUserSite.h"
@class BNWSiteCell;
@protocol BNWSiteCellDelegate <NSObject>
@optional

- (void)siteCellWithEditSite:(BNWSiteCell *)siteCell;
- (void)siteCellWithDelSite:(BNWSiteCell *)siteCell;
@end


@interface BNWSiteCell : UITableViewCell

@property(weak,nonatomic) id<BNWSiteCellDelegate> delegate;

@property (strong,nonatomic) BNWUserSite *userSite;

@end
