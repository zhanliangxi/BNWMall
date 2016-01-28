//
//  BNWBaseView.m
//  BNWMail
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWBaseView.h"

@implementation BNWBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)viewWithNibName:(NSString *)nibName
{
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    UIView *view = nil;
    if (nibObjects && nibObjects.count >0 )
    {
        view = [nibObjects objectAtIndex:0];
    }
    
    if ([view isKindOfClass:[BNWBaseView class]])
    {
        [(BNWBaseView *)view customInit];
    }
    
    return view;
}

- (void)customInit
{
    
}
@end
