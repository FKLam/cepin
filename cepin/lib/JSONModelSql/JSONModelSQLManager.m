//
//  JSONModelSQLManager.m
//  yanyunew
//
//  Created by Ricky Tang on 14-6-24.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "JSONModelSQLManager.h"


#define kAPP_LIBRARY_CACHES_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#import "NSUserDefaults+UserData.h"

//static JSONModelSQLManager *instance;

static NSString *DBName = @"db.sqlite";

@interface JSONModelSQLManager ()

@end

@implementation JSONModelSQLManager

+(JSONModelSQLManager *)shareManager
{
    static JSONModelSQLManager *instance = nil;
    @synchronized(self)
    {
        if (!instance)
        {
            instance = [[JSONModelSQLManager alloc] init];
        }
        return instance;
    }
}

-(instancetype)init
{
    if (self = [super init])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *dbPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",DBName]];
        RTLog(@"dbpath %@",dbPath);
        
        FMDatabaseQueue *dq = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        FMDatabaseQueue *dq1 = [FMDatabaseQueue databaseQueueWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DB.db3"]];
        
        self.dataArray = @[dq,dq1];
    }
    return self;
}

-(void)resetDBpath
{
    FMDatabaseQueue *dq = self.dataArray[0];
    [dq close];

    FMDatabaseQueue *dq1 = self.dataArray[1];
    [dq1 close];
}


-(FMDatabaseQueue *)switchDBWithIndex:(NSUInteger)index
{
    if (index >= self.dataArray.count) {
        return nil;
    }
    
    return self.dataArray[index];
}


-(void)dealloc
{
    self.dataArray = nil;
    self.dataQueue = nil;
}

-(BOOL)isHasTableWithClass:(NSString *)className swithDBWithIndex:(NSUInteger)index
{
    
    __block BOOL isHasTable = NO;
    
    [[self switchDBWithIndex:index] inDatabase:^(FMDatabase *db){
        
        isHasTable = [db tableExists:className];
        
    }];
    
    return isHasTable;
}


@end
