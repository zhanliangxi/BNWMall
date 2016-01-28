//
//  BNWADImage.h
//  BNWMail
//
//  Created by mac on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWADImage : NSObject

/**	广告图片地址 */
@property (nonatomic,copy) NSString *ad_code;
/**	类型1为登陆广告 2为首页广告 */
@property (nonatomic,copy) NSString *media_type;

@end
