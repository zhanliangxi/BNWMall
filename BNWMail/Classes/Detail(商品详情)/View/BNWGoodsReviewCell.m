//
//  BNWGoodsReviewCell.m
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWGoodsReviewCell.h"
#import "HCSStarRatingView.h"
#import "BNWGoodsReview.h"

@interface BNWGoodsReviewCell()

@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyDateLabel;

@end

@implementation BNWGoodsReviewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWGoodsReviewCell";
    BNWGoodsReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWGoodsReviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setGoodsReview:(BNWGoodsReview *)goodsReview
{
    _goodsReview = goodsReview;
    
    self.ratingView.value = [goodsReview.comment_rank integerValue];
    
    goodsReview.user_name = [goodsReview.user_name stringByReplacingCharactersInRange:NSMakeRange(1, goodsReview.user_name.length - 2) withString:@"***"];
    
    self.nameLabel.text = goodsReview.user_name;
    
    self.reviewDateLabel.text = goodsReview.add_time;
    
    self.reviewLabel.text = goodsReview.content;
    
    self.buyDateLabel.text = [NSString stringWithFormat:@"购买时间:%@",goodsReview.add_time];
}

@end
