//
//  NSJSONSerialization+RTAddition.m
//  yanyu
//
//  Created by rickytang on 13-11-21.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "NSJSONSerialization+RTAddition.h"

@implementation NSJSONSerialization (RTAddition)
+(id)convertToObjectWithJsonString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    return object;
}

+(NSString *)convertToJsonStringWithObject:(id)object
{
    NSAssert([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]], @"object is not NSArray or NSDictionary");
    RTLog(@"object %@",object);
    //NSAssert([NSJSONSerialization isValidJSONObject:object], @"can not to json");
    @try {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            RTLog(@"error %@",error);
            return nil;
        }
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        RTLog(@"exception %@",exception);
    }
    @finally {
        
    }
}



+(NSData *)convertToJsonDataWithObject:(id)object
{
    NSString *temp = [NSJSONSerialization convertToJsonStringWithObject:object];
    return [temp dataUsingEncoding:NSUTF8StringEncoding];
}


+(id)convertToObjectWithJsonData:(NSData *)date
{
    NSString *temp = [[NSString alloc] initWithData:date encoding:NSUTF8StringEncoding];
    return [NSJSONSerialization convertToObjectWithJsonString:temp];
}
@end
