//
//  JobModelDTO.m
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobModelDTO.h"

@implementation JobModelDTO

+(JobModelDTO*)beanFromDictionary:(NSDictionary*)dic
{
    NSError *error = nil;
    
    JobModelDTO *bean = [[JobModelDTO alloc] initWithDictionary:dic error:&error];
    NSAssert(error == nil, @"UserInfo fail");
    
    return bean;
}


@end
