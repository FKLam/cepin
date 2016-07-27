//
//  NSObject+UrlParams.m
//  yanyunew
//
//  Created by Ricky Tang on 14-6-20.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "NSObject+UrlParams.h"

@implementation NSObject (UrlParams)

+(id)objectOfClass:(Class)objectClass fromParams:(NSString *)str spliteStr:(NSString *)splite
{
    id object = [[objectClass alloc] init];
    
    NSArray *params = [str componentsSeparatedByString:splite];
    
    for (int i = 0; i<params.count; ++i) {
        NSArray *temps = [params[i] componentsSeparatedByString:@"="];
        [object setValue:temps[1] forKey:temps[0]];
    }
    
    return object;
}

+(id)objectOfClass:(Class)objectClass fromParams:(NSString *)str
{
    return [NSObject objectOfClass:objectClass fromParams:str spliteStr:@"&"];
}

@end
