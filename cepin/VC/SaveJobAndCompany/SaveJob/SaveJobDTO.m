//
//  SaveJobDTO.m
//  cepin
//
//  Created by ceping on 14-11-26.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SaveJobDTO.h"
#import "MJExtension.h"

@implementation SaveJobDTO

+(SaveJobDTO*)beanFromDictionary:(NSDictionary*)dic
{
    NSError *error = nil;
    
//    SaveJobDTO *bean = [[SaveJobDTO alloc] initWithDictionary:dic error:&error];
    SaveJobDTO *bean = [[SaveJobDTO class]objectWithKeyValues:dic];
    NSAssert(error == nil, @"UserInfo fail");
    
    return bean;
}

@end
