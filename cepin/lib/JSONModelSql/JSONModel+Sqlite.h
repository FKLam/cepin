//
//  JSONModel+Sqlite.h
//  yanyunew
//
//  Created by Ricky Tang on 14-6-24.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "JSONModel.h"


extern const NSString *DBSqlID;

@interface JSONModel (Sqlite)
@property(nonatomic,readwrite)NSNumber *dbSqlId;

+(NSInteger)userDBIndex;

-(BOOL)save;

-(BOOL)update;

-(BOOL)deleteRecord;

+(void)insertWithModels:(NSArray *)array;

+(BOOL)updateWithArray:(NSArray *)array;


+(NSMutableArray *)searchWithWhere:(NSString *)where order:(NSString *)order;

+(NSMutableArray *)searchDistinctWithString:(NSString *)distince where:(NSString *)where order:(NSString *)order;

+(NSInteger)searchCountWhere:(NSString *)where;

+(void)deleteWithArray:(NSArray *)models;

+(void)deleteWithWhere:(NSString *)where;

@end
