//
//  JSONModel+Sqlite.m
//  yanyunew
//
//  Created by Ricky Tang on 14-6-24.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "JSONModel+Sqlite.h"
#import <objc/runtime.h>
#import "JSONModelSQLManager.h"

static const char * DBSqlIDValue;

NSString *DBSqlID = @"DBSqlID";

@implementation JSONModel (Sqlite)

+(NSInteger)userDBIndex
{
    return 0;
}

-(NSArray *)arrayOutputKeys
{
    return [[self toDictionary] allKeys];
}

-(void)setDbSqlId:(NSNumber *)dbSqlId
{
    objc_setAssociatedObject(self, DBSqlIDValue, dbSqlId, OBJC_ASSOCIATION_RETAIN);
}


-(NSNumber *)dbSqlId
{
    NSNumber *num = objc_getAssociatedObject(self, DBSqlIDValue);
    return num;
}


-(BOOL)createTable
{
    __block NSArray *keys = [self arrayOutputKeys];
    if (keys == nil || keys.count < 1) {
        return NO;
    }
    
    __block BOOL returnValue = YES;
    
    NSString *tableName = NSStringFromClass([self class]);
    //如果有表就添加属性
    if ([[JSONModelSQLManager shareManager] isHasTableWithClass:tableName swithDBWithIndex:[[self class] userDBIndex]]) {
        
        [[[JSONModelSQLManager shareManager] switchDBWithIndex:[[self class] userDBIndex]] inTransaction:^(FMDatabase *db ,BOOL *rb){
            for (NSString *key in keys) {
                if (![db columnExists:key inTableWithName:tableName]) {
                    
                    NSString *sql = [NSString stringWithFormat:@"alter table %@ add %@",tableName,key];
                    
                    returnValue = [db executeUpdate:sql];
                    
                    if (returnValue == NO) {
                        *rb = YES;
                        break;
                    }
                }
            }
        }];
        
        return returnValue;
    }
    
    //没有表就创建表
    NSString *temp = [NSString stringWithFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT, ",DBSqlID];
    
    temp = [temp stringByAppendingString:[keys componentsJoinedByString:@","]];
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",tableName,temp];
    
    
    [[[JSONModelSQLManager shareManager] switchDBWithIndex:[[self class] userDBIndex]] inTransaction:^(FMDatabase *db ,BOOL *rb){
        returnValue = [db executeUpdate:sql];
        
        if (returnValue == NO) {
            *rb = YES;
        }
    }];
    
    return returnValue;
}

- (NSString *)insertSql:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    
    NSString *key = [keys componentsJoinedByString:@","];
    
    NSMutableArray *valueKeys = [[NSMutableArray alloc] initWithCapacity:keys.count];
    
    for (NSString *item in keys) {
        [valueKeys addObject:[NSString stringWithFormat:@":%@",item]];
    }
    
    NSString *values = [valueKeys componentsJoinedByString:@","];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)",NSStringFromClass([self class]),key,values];
    return sql;
}

-(BOOL)save
{
    NSDictionary *dic = [self toDictionary];
    
    __block BOOL returnValue = NO;
    
    if ([self createTable]) {
        
        [[[JSONModelSQLManager shareManager] switchDBWithIndex:[[self class] userDBIndex]] inTransaction:^(FMDatabase *db,BOOL *rb){
            
            NSString *sql;
            sql = [self insertSql:dic];
            
            returnValue = [db executeUpdate:sql withParameterDictionary:dic];
            
            if (returnValue == NO) {
                *rb = YES;
            }
            
            //得到插入值id
            FMResultSet *rs = [db executeQuery:@"select last_insert_rowid()"];
            
            while ([rs next]) {
                int value = [rs intForColumnIndex:0];
                self.dbSqlId = @(value);
            }
        }];
    }
    
    return returnValue;
}


- (NSString *)updateSql
{
    NSDictionary *dic = [self toDictionary];
    
    NSMutableArray *keyValues = [[NSMutableArray alloc] initWithCapacity:[[dic allKeys] count]];
    
    for (NSString *item in [dic allKeys]) {
        NSString *temp = [NSString stringWithFormat:@"%@=:%@",item,item];
        [keyValues addObject:temp];
    }
    
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ where %@ = %@",NSStringFromClass([self class]),[keyValues componentsJoinedByString:@","],DBSqlID,self.dbSqlId];
    return sql;
}

-(BOOL)update
{
     __block BOOL returnValue = NO;
    
    if (![self createTable]) {
        //没有表就插入数据
        return [self save];
    }else{
        //如果DBSqlID为空就查找数据是否有，没有就插入
        if (self.dbSqlId == nil) {
            return [self save];
        }
        
        //有数据就更新表表
        
        [[[JSONModelSQLManager shareManager] switchDBWithIndex:[[self class] userDBIndex]] inTransaction:^(FMDatabase *db,BOOL *rb){
            
            NSString *sql;
            sql = [self updateSql];
            
            returnValue = [db executeUpdate:sql withParameterDictionary:[self toDictionary]];
            
            if (!returnValue) {
                *rb = YES;
            }
            
        }];
    }
    
    return returnValue;
}


-(BOOL)deleteRecord
{
    __block BOOL returnValue = NO;
    
    if ([[JSONModelSQLManager shareManager] isHasTableWithClass:NSStringFromClass([self class]) swithDBWithIndex:[[self class] userDBIndex]]) {
        
        [[[JSONModelSQLManager shareManager] switchDBWithIndex:[JSONModel userDBIndex]] inTransaction:^(FMDatabase *db , BOOL *rb){
        
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = ?",NSStringFromClass([self class]),DBSqlID];
            
            returnValue = [db executeUpdate:sql,self.dbSqlId];
            
            if (returnValue == NO) {
                *rb = YES;
            }
            
        }];
        
    }
    
    return returnValue;
}


+(void)insertWithModels:(NSArray *)array
{
    [array enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        
        JSONModel *model = (JSONModel *)obj;
        
        [model save];
        
    }];
}



+(BOOL)updateWithArray:(NSArray *)array
{
    NSArray *temp = [[self class] arrayOfModelsFromDictionaries:array];
    
    if (temp == nil) {
        return NO;
    }
    
    for (JSONModel *item in temp) {
        [item update];
    }
    
    return YES;
}




+(NSMutableArray *)searchWithWhere:(NSString *)where order:(NSString *)order
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",[self class]];
    
    if (where) {
        sql = [sql stringByAppendingFormat:@" where %@",where];
    }
    
    if (order) {
        sql = [sql stringByAppendingFormat:@" order by %@",order];
    }
    
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:5];
    
    RTLog(@"sql %@",sql);
    
    [[[JSONModelSQLManager shareManager] switchDBWithIndex:[[self class] userDBIndex]] inDatabase:^(FMDatabase *db){
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            JSONModelError* initErr = nil;
            id obj = [[self alloc] initWithDictionary:dic error:&initErr];
            JSONModel *model = (JSONModel *)obj;
            model.dbSqlId = [dic objectForKey:DBSqlID];

            if (model) {
                [results addObject:obj];
            }
        }
        
        [rs close];
        
    }];
    
    return (results.count > 0)?results:nil;
}


+(NSMutableArray *)searchDistinctWithString:(NSString *)distince where:(NSString *)where order:(NSString *)order
{
    NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT   %@ FROM %@",distince,[self class]];
    
    if (where) {
        sql = [sql stringByAppendingFormat:@" where %@",where];
    }
    
    if (order) {
        sql = [sql stringByAppendingFormat:@" order by %@",order];
    }
    
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:5];
    
    RTLog(@"sql %@",sql);
    
    [[[JSONModelSQLManager shareManager] switchDBWithIndex:[[self class] userDBIndex]] inDatabase:^(FMDatabase *db){
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            JSONModelError* initErr = nil;
            id obj = [[self alloc] initWithDictionary:dic error:&initErr];
            JSONModel *model = (JSONModel *)obj;
            model.dbSqlId = [dic objectForKey:DBSqlID];
            
            if (model) {
                [results addObject:obj];
            }
            
        }
        
        [rs close];
        
    }];
    
    return (results.count > 0)?results:nil;

}


+(NSInteger)searchCountWhere:(NSString *)where
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",[self class]];
    
    if (where) {
        sql = [sql stringByAppendingFormat:@" where %@",where];
    }
    
    __block NSInteger count = 0;
    
    [[[JSONModelSQLManager shareManager] switchDBWithIndex:[[self class] userDBIndex]] inDatabase:^(FMDatabase *db){
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            count = (NSInteger)[rs longLongIntForColumnIndex:0];
        }
        
        [rs close];
        
    }];
    
    return count;
}


+(void)deleteWithArray:(NSArray *)models
{
    [models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
        JSONModel *model = (JSONModel *)obj;
        [model deleteRecord];
        
    }];
}


+(void)deleteWithWhere:(NSString *)where
{
    [[[JSONModelSQLManager shareManager] switchDBWithIndex:[[self class] userDBIndex]] inTransaction:^(FMDatabase *db , BOOL *rb){
        
        NSString *sql = [NSString stringWithFormat:@"delete from %@", [self class]];
        
        if (where) {
            sql = [sql stringByAppendingFormat:@" where %@",where];
        }
        
        [db executeUpdate:sql];
        
    }];
}

@end
