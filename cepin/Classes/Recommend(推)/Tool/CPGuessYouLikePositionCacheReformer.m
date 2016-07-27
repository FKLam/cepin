//
//  CPGuessYouLikePositionCacheReformer.m
//  cepin
//
//  Created by ceping on 16/3/10.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPGuessYouLikePositionCacheReformer.h"
#import "FMDB.h"
@implementation CPGuessYouLikePositionCacheReformer
static FMDatabaseQueue *_guessQueue;
+ (void)setup
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"positioncache.sqlite"];
    // 1.创建队列
    _guessQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    // 2.创建表
    [_guessQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_guess (id integer primary key autoincrement, position blob, page text, userid text);"];
    }];
}
+ (void)addGuessYouLikePositionDict:(NSDictionary *)positionDict params:(CPGuessYouLikePositionParam *)params
{
    [self setup];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        NSDictionary *dict = positionDict;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        FMResultSet *rs = nil;
        BOOL canInsert = YES;
        rs = [db executeQuery:@"select * from t_guess where page = ? and userid = ?",[NSString stringWithFormat:@"%@", params.pageString], [NSString stringWithFormat:@"%@", params.userid]];
//        while(rs.next)
//        {
//            canInsert = NO;
//            break;
//        }
        if(canInsert)
        {
            // 2.存储数据
            [db executeUpdate:@"insert into t_guess (position, page, userid) values(?, ?, ?)", data, [NSString stringWithFormat:@"%@", params.pageString], [NSString stringWithFormat:@"%@", params.userid]];
        }
        [rs close];
    }];
    
    [_guessQueue close];
}
+ (void)clearup
{
    [self setup];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM t_guess"];
        [db executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name='t_guess'"];
    }];
    [_guessQueue close];
}
+ (void)addGuessYouLikePosition:(CPRecommendModelFrame *)positionDict params:(CPGuessYouLikePositionParam *)params
{
    [self setup];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        NSDictionary *dict = @{@"position" : @"1111111111"};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        FMResultSet *rs = nil;
        BOOL canInsert = YES;
        rs = [db executeQuery:@"select * from t_guess where page = ? and userid = ?",[NSString stringWithFormat:@"%@", params.pageString], [NSString stringWithFormat:@"%@", params.userid]];
        while(rs.next)
        {
            canInsert = NO;
            break;
        }
        if(canInsert)
        {
            // 2.存储数据
            [db executeUpdate:@"insert into t_guess (position, page, userid) values(?, ?, ?)", data, [NSString stringWithFormat:@"%@", params.pageString], [NSString stringWithFormat:@"%@", params.userid]];
        }
        [rs close];
    }];
    
    [_guessQueue close];
}
+ (CPRecommendModelFrame *)positionDictWithParams:(CPGuessYouLikePositionParam *)params
{
    [self setup];
    __block CPRecommendModelFrame *result = nil;
    [_guessQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_guess where page = ? and userid = ?", [NSString stringWithFormat:@"%@", params.pageString], [NSString stringWithFormat:@"%@", params.userid]];
        while(rs.next)
        {
            NSData *data = [rs dataForColumn:@"position"];
            result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            break;
        }
        [rs close];
    }];
    [_guessQueue close];
    return result;
}
+ (NSArray *)positionDictsWithParams:(CPGuessYouLikePositionParam *)params
{
    [self setup];
    __block NSMutableArray *resultArrayM = [NSMutableArray array];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_guess"];
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
