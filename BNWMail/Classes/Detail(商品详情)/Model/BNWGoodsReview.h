//
//  BNWGoodsReview.h
//  BNWMail
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWGoodsReview : NSObject

//@property (nonatomic,assign) NSInteger rating;
//@property (nonatomic,copy) NSString *name;
//@property (nonatomic,copy) NSString *reviewDate;
//@property (nonatomic,copy) NSString *review;
//@property (nonatomic,copy) NSString *buyDate;

/**	评论ID */
@property (nonatomic,copy) NSString *comment_id;
/**	用户名 */
@property (nonatomic,copy) NSString *user_name;
/**	评论内容 */
@property (nonatomic,copy) NSString *content;
/**	好评等级 */
@property (nonatomic,copy) NSString *comment_rank;
/**	评论时间 */
@property (nonatomic,copy) NSString *add_time;
/**	评论IP地址 */
@property (nonatomic,copy) NSString *ip_address;
/**	1显示 2不显示 */
@property (nonatomic,copy) NSString *status;

@end
