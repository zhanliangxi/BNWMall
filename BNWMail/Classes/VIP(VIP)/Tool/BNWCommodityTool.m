//
//  BNWCommodityTool.m
//  BNWMail
//
//  Created by 1 on 15/8/22.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWCommodityTool.h"
#import "FMDB.h"


@implementation BNWCommodityTool


static FMDatabase *_db;
+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"commodity.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_commodity (id integer PRIMARY KEY, commodity blob NOT NULL, cat_id text NOT NULL);"];
}
+ (NSArray *)commoditysWithParams:(NSDictionary *)params
{
    // 根据请求参数生成对应的查询SQL语句
    NSString *sql = nil;
    if (params[@"cat_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_commodity WHERE cat_id = %@ ", params[@"cat_id"]];
    }
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *commoditys = [NSMutableArray array];
    while (set.next) {
        NSData *commodityData = [set objectForColumnName:@"commodity"];
        NSDictionary *commodity = [NSKeyedUnarchiver unarchiveObjectWithData:commodityData];
        [commoditys addObject:commodity];
    }
    return commoditys;
}


+ (void)saveCommoditys:(NSArray *)commoditys catId:(NSString *)catId
{
    // 要将一个对象存进数据库的blob字段,最好先转为NSData
    // 一个对象要遵守NSCoding协议,实现协议中相应的方法,才能转成NSData
    for (NSDictionary *commodity in commoditys) {
        // NSDictionary --> NSData
        NSData *commoditysData = [NSKeyedArchiver archivedDataWithRootObject:commodity];
        [_db executeUpdateWithFormat:@"INSERT INTO t_commodity(commodity, cat_id) VALUES (%@, %@);", commoditysData, catId];
    }
}
    
    
@end
