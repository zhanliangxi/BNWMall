//
//  BNWMessage.h
//  BNWMail
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNWMessage : NSObject


/** 信息状态 */
@property (nonatomic,copy) NSString *mes_status;
/** 	1位全部用户收到 */
@property (nonatomic,copy) NSString *mes_all;
/** 	信息详细内容 */
@property (nonatomic,copy) NSString *mes_content;
/** 	信息简述 */
@property (nonatomic,copy) NSString *mes_breif;
/** 	信息类型 */
@property (nonatomic,copy) NSString *mes_type;
/** 	信息标题 */
@property (nonatomic,copy) NSString *mes_title;
/** 	用户电话号码 */
@property (nonatomic,copy) NSString *mes_phone;
/** 	添加信息时间 */
@property (nonatomic,copy) NSString *mes_time;
/** 	短信ID */
@property (nonatomic,copy) NSString *mes_id;
/** 	用户ID */
@property (nonatomic,copy) NSString *mes_uid;

@end
