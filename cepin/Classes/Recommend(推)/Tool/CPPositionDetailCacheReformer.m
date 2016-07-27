//
//  CPPositionDetailCacheReformer.m
//  cepin
//
//  Created by ceping on 16/3/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPositionDetailCacheReformer.h"
#import "FMDB.h"
@implementation CPPositionDetailCacheReformer
static FMDatabaseQueue *_guessQueue;
+ (void)setup
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"positioncache.sqlite"];
    // 1.创建队列
    _guessQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    // 2.创建表
    [_guessQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_positiondetail (id integer primary key autoincrement, position blob, positionid text, userid text, companyid text);"];
    }];
}
+ (void)addGuessYouLikePositionDict:(NSDictionary *)positionDict params:(CPPositionDetailParam *)params
{
    [self setup];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        NSDictionary *dict = positionDict;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        FMResultSet *rs = nil;
        BOOL canInsert = YES;
        rs = [db executeQuery:@"select * from t_positiondetail where positionid = ? AND companyid = ?", params.positionID, params.companyID];
        while(rs.next)
        {
            canInsert = NO;
            break;
        }
        if(canInsert)
        {
            // 2.存储数据
            [db executeUpdate:@"insert into t_positiondetail (position, positionid, userid, companyid) values(?, ?, ?, ?)", data, params.positionID, params.userID, params.companyID];
        }
        [rs close];
    }];
    
    [_guessQueue close];
}
+ (NSArray *)positionDictsWithParams:(CPPositionDetailParam *)parmas
{
    [self setup];
    __block NSMutableArray *resultArrayM = [NSMutableArray array];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_positiondetail"];
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
+ (NSDictionary *)positionDictWithParams:(CPPositionDetailParam *)params
{
    [self setup];
    __block NSDictionary *result = nil;
    [_guessQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_positiondetail where positionid = ? AND companyid = ?", params.positionID, params.companyID];
        while(rs.next)
        {
            NSData *data = [rs dataForColumn:@"position"];
            result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ( result )
                break;
        }
        [rs close];
    }];
    [_guessQueue close];
    return result;
}
+ (void)clearup
{
    [self setup];
    [_guessQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM t_positiondetail"];
        [db executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name='t_positiondetail'"];
    }];
    [_guessQueue close];
}
@end
