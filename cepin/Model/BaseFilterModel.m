//
//  BaseFilterModel.m
//  cepin
//
//  Created by Ricky Tang on 14-11-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseFilterModel.h"
#import "FileManagerHelper.h"

static NSString *BaseFilterData = @"BaseFilterData.json";

@implementation BaseFilterModel
+(instancetype)shareInstance
{
    return nil;
}

+(instancetype)loadData
{
    return nil;
}



-(BOOL)saveObjectToDisk
{
    return NO;
}

@end
