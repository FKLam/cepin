//
//  CPHomeBannerCacheReformer.m
//  cepin
//
//  Created by ceping on 16/3/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomeBannerCacheReformer.h"
#import "FMDB.h"
@implementation CPHomeBannerCacheReformer
static FMDatabaseQueue *_guessQueue;
+ (void)setup
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"positioncache.sqlite"];
    // 1.创建队列
    _guessQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    // 2.创建表
    [_guessQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_banner (id integer primary key autoincrement, position blob, page text, userid text);"];
    }];
}
+ (void)clearup
{
    [self setup];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM t_banner"];
        [db executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name='t_banner'"];
    }];
    [_guessQueue close];
}
+ (void)addBannerDict:(NSDictionary *)positionDict params:(CPGuessYouLikePositionParam *)params
{
    [self setup];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        NSDictionary *dict = positionDict;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        FMResultSet *rs = nil;
        BOOL canInsert = YES;
        rs = [db executeQuery:@"select * from t_banner where page = ? and userid = ?",[NSString stringWithFormat:@"%@", params.pageString], [NSString stringWithFormat:@"%@", params.userid]];
        if(canInsert)
        {
            // 2.存储数据
            [db executeUpdate:@"insert into t_banner (position, page, userid) values(?, ?, ?)", data, [NSString stringWithFormat:@"%@", params.pageString], [NSString stringWithFormat:@"%@", params.userid]];
        }
        [rs close];
    }];
    [_guessQueue close];
}
+ (NSArray *)bannerDictsWithParams:(CPGuessYouLikePositionParam *)parmas
{
    [self setup];
    __block NSMutableArray *resultArrayM = [NSMutableArray array];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_banner"];
        while(rs.next)
        {
            NSData *data = [rs dataForColumn:@"position"];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [resultArrayM addObject:result];
        }
        [rs close];
    }];
    [_guessQueue close];
    return [resultArrayM copy];
}
@end
