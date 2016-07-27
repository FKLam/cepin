//
//  JSONModelSQLManager.h
//  yanyunew
//
//  Created by Ricky Tang on 14-6-24.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

@interface JSONModelSQLManager : NSObject
//@property(nonatomic,strong)FMDatabase *dataBase;
@property(nonatomic,strong)FMDatabaseQueue *dataQueue;
@property(nonatomic,strong)NSArray *dataArray;

+(instancetype)shareManager;

-(void)resetDBpath;

-(BOOL)isHasTableWithClass:(NSString *)className swithDBWithIndex:(NSUInteger)index;

-(FMDatabaseQueue *)switchDBWithIndex:(NSUInteger)index;

@end
