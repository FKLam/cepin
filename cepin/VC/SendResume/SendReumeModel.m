//
//  SendReumeModel.m
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SendReumeModel.h"

@implementation SendReumeModel

+(SendReumeModel*)beanFromDictionary:(NSDictionary*)dic
{
    NSError *error = nil;
    
    SendReumeModel *bean = [[SendReumeModel alloc] initWithDictionary:dic error:&error];
    NSAssert(error == nil, @"SendReumeModel fail");
    
    return bean;
}

@end
