//
//  BNWSectionHeaderView.h
//  BNWMail
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNWSectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderMoreButtonDidClick;

@end

@interface BNWSectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic,weak) id<BNWSectionHeaderViewDelegate> delegate;

@end
