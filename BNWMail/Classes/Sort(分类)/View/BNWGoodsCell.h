//
//  BNWGoodsCell.h
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNWGoods;

@protocol BNWGoodsCellDelegate <NSObject>

- (void)goodsCellDidAdd2Cart:(BNWGoods *)goods;

@end

@interface BNWGoodsCell : UITableViewCell

@property (nonatomic,strong) BNWGoods *goods;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) id<BNWGoodsCellDelegate> delegate;

@end
