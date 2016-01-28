//
//  WBCCyclePageView.m
//  KuaiChong
//
//  Created by Onliu on 14-6-22.
//  Copyright (c) 2014年 Onliu. All rights reserved.
//

#import "WBCCyclePageView.h"

static NSString * const k_Observer_Self_Bounds_KeyPath = @"bounds";

static NSTimeInterval const k_Default_Cycle_Interval = 2;

static NSString * const k_Prev_Image_View_Name    = @"pervImageView";
static NSString * const k_Current_Image_View_Name = @"middImageView";
static NSString * const k_Next_Image_View_Name    = @"nextImageView";


@interface WBCCyclePageView()<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;

@property (strong,nonatomic) NSTimer *timer;

@property (nonatomic,assign,readonly) NSUInteger numOfPages;
@property (nonatomic,assign,readonly) NSUInteger prevPageIndex;
@property (assign,nonatomic         ) NSUInteger currentPageIndex;
@property (nonatomic,assign,readonly) NSUInteger nextPageIndex;

@property (nonatomic,strong  ) NSDictionary *imageViewsDic;
@property (nonatomic,readonly) UIImageView  *prevPage;
@property (nonatomic,readonly) UIImageView  *nextPage;
@property (nonatomic,readonly) UIImageView  *currentPage;

@property (nonatomic, strong) NSMutableArray *pageControlConstraints;
@property (nonatomic, strong) NSMutableArray *scrollViewConstraints;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) BOOL timerStopByDrag;
@property (nonatomic, assign) BOOL isBoundsChangedScroll;
@end

@implementation WBCCyclePageView

#pragma mark - life cycle
- (void)dealloc
{
    self.scrollView.delegate = nil;
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self removeObserver:self forKeyPath:k_Observer_Self_Bounds_KeyPath];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    //NSLog(@"WBCCyclePageView setup");
    [self addObserver:self
           forKeyPath:k_Observer_Self_Bounds_KeyPath
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    [self setupPageControlLayout];
    [self setupImageViewsLayout];
    [self setupScrollViewLayoutWithEdgeInsets:UIEdgeInsetsZero];
    
    [self reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - main method
-(void)reloadData
{
    //NSLog(@"reloadData");
    self.currentPageIndex = 0;
    
    [self refreshImageView];
    if (self.autoCycle) {
        [self delayFrie];
    }
}

-(void)toNextPage
{
    if (self.numOfPages == 0) {
        return;
    }
    self.currentPageIndex = (self.currentPageIndex + 1)%self.numOfPages;
    self.pageControl.currentPage = self.currentPageIndex;
    [self refreshImageView];
}

-(void)toPrevPage
{
    if (self.isBoundsChangedScroll) {
        self.isBoundsChangedScroll = NO;
        return;
    }
    if (self.numOfPages == 0) {
        return;
    }
    self.currentPageIndex = self.currentPageIndex == 0 ? (self.numOfPages - 1) : (self.currentPageIndex - 1)%self.numOfPages;
    self.pageControl.currentPage = self.currentPageIndex;
    [self refreshImageView];
}

#pragma mark - Delegate
#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;

    if (x <= 0) {
        [self toPrevPage];
    }
    else if (x >= 2*CGRectGetWidth(self.bounds))
    {
        [self toNextPage];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0) animated:YES];
    
    if (self.autoCycle && self.timerStopByDrag) {
        [self delayFrie];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.autoCycle)
    {
        [self stopCycle];
        self.timerStopByDrag = YES;
    }
}

#pragma mark - NSTimer
-(void)setAutoCycle:(BOOL)autoCycle
{
    _autoCycle = autoCycle;
    if (autoCycle) {
        [self delayFrie];
    }
    else{
        [self stopCycle];
    }
}

- (void)delayFrie
{
    [self stopCycle];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cycleFire) object:nil];
    [self performSelector:@selector(cycleFire) withObject:nil afterDelay:k_Default_Cycle_Interval];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(k_Default_Cycle_Interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self cycleFire];
//    });
}

-(void)cycleFire
{
    [self stopCycle];
    //NSLog(@"cycleFire");
    self.timerStopByDrag = NO;
    if (self.numOfPages > 1) {
        self.timer = [NSTimer timerWithTimeInterval:k_Default_Cycle_Interval target:self selector:@selector(cycleViewPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
}

-(void)stopCycle
{
    //NSLog(@"stopCycle");
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)cycleViewPage
{
    //NSLog(@"cycleViewPage");
    if (self.numOfPages < 2) {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame)*2, 0) animated:YES];
}

#pragma mark - Envet
- (void)handlerTap:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cyclePageView:didTapedPageAtIndex:)]) {
        if (self.numOfPages <= self.currentPageIndex) {
            return;
        }
        [self.delegate cyclePageView:self didTapedPageAtIndex:self.currentPageIndex];
    }
}

#pragma mark - private
- (void)refreshImageView
{
    //NSLog(@"refreshImageView:%@[%@,%@,%@]in %@",
//          NSStringFromCGSize(self.bounds.size),
//          @(self.prevPageIndex),
//          @(self.currentPageIndex),
//          @(self.nextPageIndex),
//          @(self.numOfPages));
    if (self.numOfPages == 0) {
        return;
    }
    
    self.pageControl.numberOfPages = self.numOfPages;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSource cyclePageView:self loadImageForImageView:self.prevPage atIndex:self.prevPageIndex];
        if (self.numOfPages > 1) {
            [self.dataSource cyclePageView:self loadImageForImageView:self.currentPage atIndex:self.currentPageIndex];
            [self.dataSource cyclePageView:self loadImageForImageView:self.nextPage atIndex:self.nextPageIndex];
        }
        
        if (self.numOfPages > 1) {
            self.pageControl.hidden = NO;
            [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0) animated:NO];
        }
        else{
            self.pageControl.hidden = YES;
            self.scrollView.contentSize = self.bounds.size;
            [self.scrollView setContentOffset:CGPointZero];
        }
    });
    //NSLog(@"did refreshImageView");
}

- (UIImageView *)addImageView2ScrollView
{
    CGFloat width = self.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right;
    CGFloat height = self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = NO;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.scrollView addSubview:imageView];
    
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
    
    return imageView;
}


#pragma mark - setup Layout
- (void)setupPageControlLayout
{
    //constraint pageControl 2 scorllView
    NSArray *pageControlVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-0-|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    NSArray *pageControlHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControl]|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    self.pageControlConstraints = [NSMutableArray arrayWithArray:pageControlVConstraints];
    [self.pageControlConstraints addObjectsFromArray:pageControlHConstraints];
    [self addConstraints:self.pageControlConstraints];
}

- (void)setupImageViewsLayout
{
    //constraint imageViews 2 scorllView
    NSMutableString *hConstraintString = [NSMutableString string];
    [hConstraintString appendString:@"H:|-0"];
    [hConstraintString appendFormat:@"-[%@]-0", k_Prev_Image_View_Name];
    [hConstraintString appendFormat:@"-[%@]-0", k_Current_Image_View_Name];
    [hConstraintString appendFormat:@"-[%@]-0", k_Next_Image_View_Name];
    [hConstraintString appendString:@"-|"];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[%@]-0-|", k_Prev_Image_View_Name]
                                                                            options:kNilOptions
                                                                            metrics:nil
                                                                              views:self.imageViewsDic]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hConstraintString
                                                                            options:NSLayoutFormatAlignAllTop
                                                                            metrics:nil
                                                                              views:self.imageViewsDic]];
    
}

- (void)setupScrollViewLayoutWithEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    [self removeConstraints:self.scrollViewConstraints];
    NSArray *scrollViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[scrollView]-bottom-|"
                                                                              options:kNilOptions
                                                                              metrics:@{@"top": @(self.edgeInsets.top),
                                                                                        @"bottom": @(self.edgeInsets.bottom)}
                                                                                views:@{@"scrollView": self.scrollView}];
    NSArray *scrollViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[scrollView]-right-|"
                                                                              options:kNilOptions
                                                                              metrics:@{@"left": @(self.edgeInsets.left),
                                                                                        @"right": @(self.edgeInsets.right)}
                                                                                views:@{@"scrollView": self.scrollView}];
    
    [self.scrollViewConstraints removeAllObjects];
    [self.scrollViewConstraints addObjectsFromArray:scrollViewHConstraints];
    [self.scrollViewConstraints addObjectsFromArray:scrollViewVConstraints];
    
    [self addConstraints:self.scrollViewConstraints];
    
    // update imageview constraints
    CGFloat width = self.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right;
    CGFloat height = self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)subView;
            for (NSLayoutConstraint *constraint in imageView.constraints) {
                if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                    constraint.constant = width;
                } else if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    constraint.constant = height;
                }
            }
        }
    }
}


#pragma mark - ObserveKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:k_Observer_Self_Bounds_KeyPath]) {
        //NSLog(@"Bounds Changed");
        self.isBoundsChangedScroll = YES;
        [self refreshImageView];
        self.edgeInsets = UIEdgeInsetsZero;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

#pragma mark - getters and setters
#pragma mark pageIndex getters setter
- (NSUInteger)numOfPages
{
    return [self.dataSource numberOfPagesInCyclePageView];
}

- (NSUInteger)nextPageIndex
{
    if (self.numOfPages == 1) {
        return 0;
    }
    
    if (self.currentPageIndex == self.numOfPages - 1) {
        return 0;
    }
    
    return self.currentPageIndex + 1;
}

- (NSUInteger)prevPageIndex
{
    if (self.numOfPages == 1) {
        return 0;
    }
    
    if (self.currentPageIndex == 0) {
        return self.numOfPages - 1;
    }
    
    return self.currentPageIndex - 1;
}

- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    //NSLog(@"setCurrentPageIndex:%@",@(currentPageIndex));
    if ([self.delegate respondsToSelector:@selector(cyclePageView:currentIndexDidChanged:)]) {
        if (self.numOfPages <= self.currentPageIndex) {//无数据时
            return;
        }
        [self.delegate cyclePageView:self currentIndexDidChanged:currentPageIndex];
    }
}

#pragma mark ImageView getter
-(UIImageView *)prevPage
{
    return self.imageViewsDic[k_Prev_Image_View_Name];
}

-(UIImageView *)nextPage
{
    return self.imageViewsDic[k_Next_Image_View_Name];
}

-(UIImageView *)currentPage
{
    return self.imageViewsDic[k_Current_Image_View_Name];
}

- (NSDictionary *)imageViewsDic
{
    if (!_imageViewsDic) {
        NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
        viewsDictionary[k_Prev_Image_View_Name] = [self addImageView2ScrollView];
        viewsDictionary[k_Current_Image_View_Name] = [self addImageView2ScrollView];
        viewsDictionary[k_Next_Image_View_Name] = [self addImageView2ScrollView];
        _imageViewsDic = [viewsDictionary copy];
    }
    return _imageViewsDic;
}

#pragma mark main getters
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        _pageControl.userInteractionEnabled = YES;
        _pageControl.numberOfPages = self.numOfPages;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.delegate = self;
        
        _scrollView.directionalLockEnabled = YES;
        _scrollView.scrollsToTop = NO;

        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        
        _scrollView.userInteractionEnabled = YES;
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTap:)]];
        
        [self insertSubview:_scrollView belowSubview:self.pageControl];
    }
    return _scrollView;
}

#pragma mark other getters setters
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    [self setupScrollViewLayoutWithEdgeInsets:edgeInsets];
}

- (NSMutableArray *)scrollViewConstraints
{
    if (!_scrollViewConstraints) {
        _scrollViewConstraints = [NSMutableArray arrayWithCapacity:3];
    }
    return _scrollViewConstraints;
}
@end
