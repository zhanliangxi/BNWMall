//
//  BNWEverydayCommodityCell.h
//  BNWMail
//
//  Created by 1 on 15/8/8.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNWCommodity.h"
@interface BNWEverydayCommodityCell : UICollectionViewCell


@property (strong,nonatomic) BNWCommodity *goods;
@property (weak, nonatomic) IBOutlet UIImageView *getView;
@end
