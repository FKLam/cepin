//
//  PositionIdModel.m
//  cepin
//
//  Created by dujincai on 15/9/7.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "PositionIdModel.h"

@implementation PositionIdModel

+ (PositionIdModel *)createPositionIdModelWith:(NSString *)positionId
{
    PositionIdModel *model = [PositionIdModel new];
    model.positionId = positionId;
    model.createDate = [NSDate date];
    return model;
}

+ (NSMutableArray *)allPositionIds
{
    return [PositionIdModel searchWithWhere:nil order:nil];
}

+ (BOOL)savePositionIdWith:(NSString *)positionId
{
    NSInteger i = [PositionIdModel searchCountWhere:[NSString stringWithFormat:@"positionId = \"%@\"",positionId]];
    if (i > 0) {
        return NO;
    }
    
    PositionIdModel *model = [PositionIdModel createPositionIdModelWith:positionId];
    return [model save];
}


+ (void)deletePositionId:(NSString *)positionId
{
    [self deleteWithWhere:[NSString stringWithFormat:@"positionId = \"%@\"",positionId]];
}


@end
