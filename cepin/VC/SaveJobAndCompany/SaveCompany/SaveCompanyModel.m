//
//  SaveCompanyModel.m
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SaveCompanyModel.h"
#import "MJExtension.h"

@implementation SaveCompanyModel

+(SaveCompanyModel*)beanFromDictionary:(NSDictionary*)dic
{
    NSError *error = nil;
    
//    SaveCompanyModel *bean = [[SaveCompanyModel alloc] initWithDictionary:dic error:&error];
    SaveCompanyModel *bean = [[SaveCompanyModel class]objectWithKeyValues:dic];
    NSAssert(error == nil, @"SendReumeModel fail");
    
    return bean;
}


@end
