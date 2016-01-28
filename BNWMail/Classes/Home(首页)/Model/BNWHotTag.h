//
//  BNWHotTag.h
//  BNWMail
//
//  Created by 杨育彬 on 15/8/11.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWHotTag : NSObject

/**	搜索数次 */
@property (nonatomic,copy) NSString *count;
/**	搜索关键词 */
@property (nonatomic,copy) NSString *keyword;
/**	日期 */
@property (nonatomic,copy) NSString *date;
/**	id */
@property (nonatomic,copy) NSString *key_id;

@end
