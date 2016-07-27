//
//  SchoolDTO.m
//  cepin
//
//  Created by ricky.tang on 14-10-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SchoolDTO.h"
#import "JSONModel+Sqlite.h"
#import "JSONModelSqlString.h"

@implementation School
+(NSInteger)userDBIndex
{
    return 1;
}

+(NSMutableArray *)school
{
//    return  [School searchDistinctWithString:@"Name" where:@"Country = \"中国\"" order:@"SortNumber"];
    return  [School searchDistinctWithString:@"Name" where:@"Country = \"中国\"" order:@"LENGTH(Name)"];
}

+(NSMutableArray *)schoolWithName:(NSString *)name
{
    return [School searchWithWhere:[JSONModelSqlString sqlLikeWithColummName:@"Name" string:name] order:nil];
}

+(NSMutableArray *)schoolWithFullName:(NSString *)name
{
    return [School searchWithWhere:[NSString stringWithFormat:@" Name = \"%@\"",name] order:nil];
}

+(NSMutableArray *)schoolAddress
{
    return [School searchDistinctWithString:@"Province" where:@"Country = \"中国\"" order:@"SortNumber"];
}

+(NSMutableArray *)schoolsWithProvince:(NSString *)province
{
    return [School searchWithWhere:[NSString stringWithFormat:@" Province = \"%@\"",province] order:@"SortNumber"];
}

+(NSMutableArray *)shoolsWithShoolNames:(NSString*)shoolNames province:(NSString*)province
{
    NSArray *array = [shoolNames componentsSeparatedByString:@"，"];
    NSUInteger count = [array count];
    if ([[array lastObject]isEqualToString:@""])
    {
        count -= 1;
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc]init];
    for (int i = 0; i < count; i++)
    {
        if (i == 0)
        {
            NSString *tmStr = [NSString stringWithFormat:@"(Name like \"%@%@%@\"",@"%",[array objectAtIndex:i],@"%"];
            [mutableString appendString:tmStr];
        }
        else
        {
            NSString *tmStr = [NSString stringWithFormat:@" OR Name like \"%@%@%@\"",@"%",[array objectAtIndex:i],@"%"];
            [mutableString appendString:tmStr];
        }
    }
    
    NSString *tmStr = [NSString stringWithFormat:@") AND Province = \"%@\"",province];
    [mutableString appendString:tmStr];
    
    return [School searchWithWhere:mutableString order:@"SortNumber"];
}

//根据shools查询shool
+(NSMutableArray*)searchSchoolsWithShoolIds:(NSString*)schools
{
    if (!schools && [schools isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *array = [schools componentsSeparatedByString:@","];
    NSUInteger count = [array count];
    if ([[array lastObject]isEqualToString:@""])
    {
        count -= 1;
    }

    NSMutableString *mutableString = [[NSMutableString alloc]init];
    for (int i = 0; i < count; i++)
    {
        if (i == 0)
        {
            NSString *tmStr = [NSString stringWithFormat:@"SchoolId = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
        else
        {
            NSString *tmStr = [NSString stringWithFormat:@" OR SchoolId = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
    }
    return [School searchWithWhere:mutableString order:@"SortNumber"];
}

//根据schools查询
+(NSMutableArray*)searchSchoolsWithShoolNames:(NSString*)schools
{
    if (!schools && [schools isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *array = [schools componentsSeparatedByString:@","];
    NSUInteger count = [array count];
    if ([[array lastObject]isEqualToString:@""])
    {
        count -= 1;
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc]init];
    for (int i = 0; i < count; i++)
    {
        if (i == 0)
        {
            NSString *tmStr = [NSString stringWithFormat:@"(Name = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
        else
        {
            NSString *tmStr = [NSString stringWithFormat:@" OR Name = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
    }
    
    //return [School searchDistinctWithString:mutableString where:@"Country = \"中国\"" order:@"SortNumber"];
    
    NSString *tmStr = @") AND Country = \"中国\"";
    [mutableString appendString:tmStr];
    return [School searchWithWhere:mutableString order:@"SortNumber"];
}



@end
