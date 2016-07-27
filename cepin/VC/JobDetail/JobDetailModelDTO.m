//
//  JobDetailModelDTO.m
//  cepin
//
//  Created by ceping on 14-12-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobDetailModelDTO.h"

@implementation ApplyUserModel

+(ApplyUserModel*)beanFromDictionary:(NSDictionary*)dic
{
    NSError *error = nil;
    ApplyUserModel *bean = [[ApplyUserModel alloc] initWithDictionary:dic error:&error];
    NSAssert(error == nil, @"SendReumeModel fail");
    return bean;
}
@end

@implementation JobDetailModelDTO
//+(JobDetailModelDTO*)beanFromDictionary:(NSDictionary*)dic
//{
//    NSError *error = nil;
//    JobDetailModelDTO *bean = [[JobDetailModelDTO alloc] initWithDictionary:dic error:&error];
//    NSAssert(error == nil, @"SendReumeModel fail");
//    
//    return bean;
//}
+(instancetype)beanFromDictionary:(NSDictionary*)dic
{
    return [[self class] objectWithKeyValues:dic];
}
@end
