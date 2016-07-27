//
//  BaseBeanModel.m
//  cepin
//
//  Created by ceping on 14-12-4.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"
#import "MJExtension.h"

@implementation BaseBeanModel

+(instancetype)beanFromDictionary:(NSDictionary*)dic
{
    return [[self class] objectWithKeyValues:dic];
}

@end
