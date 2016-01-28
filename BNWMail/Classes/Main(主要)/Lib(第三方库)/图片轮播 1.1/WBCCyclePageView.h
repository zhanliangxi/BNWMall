//
//  WBCCyclePageView.h
//  KuaiChong
//
//  Created by Onliu on 14-6-22.
//  Copyright (c) 2014年 Onliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBCCyclePageView;

@protocol WBCCyclePageViewDelegate <NSObject>
@optional
- (void)cyclePageView:(WBCCyclePageView *)cyclePageView didTapedPageAtIndex:(NSUInteger) index;
- (void)cyclePageView:(WBCCyclePageView *)cyclePageView currentIndexDidChanged:(NSUInteger) currentIndex;
@end

@protocol WBCCyclePageViewDataSource <NSObject>
@required
- (NSUInteger) numberOfPagesInCyclePageView;
- (void)cyclePageView:(WBCCyclePageView *)cyclePageView loadImageForImageView:(UIImageView *)imageView atIndex:(NSUInteger) index;
@end

@interface WBCCyclePageView : UIView

@property (weak,nonatomic) IBOutlet id<WBCCyclePageViewDelegate> delegate;
@property (weak,nonatomic) IBOutlet id<WBCCyclePageViewDataSource> dataSource;
@property (nonatomic,assign) BOOL autoCycle;
- (void)reloadData;
@end
