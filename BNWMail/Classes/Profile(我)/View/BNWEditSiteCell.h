//
//  BNWEditSiteCell.h
//  BNWMail
//
//  Created by 1 on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNWEditSiteCellDelegate <NSObject>
@optional
- (void)editSiteCellWithTextField:(UITextField *)textField;

@end

@interface BNWEditSiteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *fieldPlaceholder;


@property(weak,nonatomic) id<BNWEditSiteCellDelegate> delegate;

@end
