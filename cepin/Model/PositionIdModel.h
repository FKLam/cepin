//
//  PositionIdModel.h
//  cepin
//
//  Created by dujincai on 15/9/7.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JSONModel.h"
#import "JSONModel+Sqlite.h"
@interface PositionIdModel : JSONModel

@property(nonatomic, strong)NSString *positionId;
@property(nonatomic, strong)NSDate *createDate;

+(NSMutableArray *)allPositionIds;

+(BOOL)savePositionIdWith:(NSString *)positionId;

+(void)deletePositionId:(NSString*)positionId;
@end
