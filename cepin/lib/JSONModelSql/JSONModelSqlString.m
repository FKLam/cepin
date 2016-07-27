//
//  JSONModelSqlString.m
//  yanyunew
//
//  Created by Ricky Tang on 14-7-4.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "JSONModelSqlString.h"

@implementation JSONModelSqlString

+(NSString *)sqlLikeWithColummName:(NSString *)name string:(NSString *)string
{
    return [NSString stringWithFormat:@"%@ like \"%@%@%@\"",name,@"%",string,@"%"];
}



@end
