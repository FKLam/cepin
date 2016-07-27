//
//  NSJSONSerialization+RTAddition.h
//  yanyu
//
//  Created by rickytang on 13-11-21.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (RTAddition)
+(id)convertToObjectWithJsonString:(NSString *)string;

+(NSString *)convertToJsonStringWithObject:(id)object;

+(NSData *)convertToJsonDataWithObject:(id)object;

+(id)convertToObjectWithJsonData:(NSData *)date;
@end
