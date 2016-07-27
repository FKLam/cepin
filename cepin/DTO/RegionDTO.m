//
//  RegionDTO.m
//  cepin
//
//  Created by ricky.tang on 14-10-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RegionDTO.h"
#import "JSONModel+Sqlite.h"
@implementation Region
+(NSInteger)userDBIndex
{
    return 1;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.RegionId = [aDecoder decodeObjectForKey:@"RegionId"];
        self.Level = [aDecoder decodeObjectForKey:@"Level"];
        self.PathCode = [aDecoder decodeObjectForKey:@"PathCode"];
        self.Hot = [aDecoder decodeObjectForKey:@"Hot"];
        self.SortCode = [aDecoder decodeObjectForKey:@"SortCode"];
        self.RegionName = [aDecoder decodeObjectForKey:@"RegionName"];
        self.RegionFullName = [aDecoder decodeObjectForKey:@"RegionFullName"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_RegionId forKey:@"RegionId"];
    [aCoder encodeObject:_Level forKey:@"Level"];
    [aCoder encodeObject:_PathCode forKey:@"PathCode"];
    [aCoder encodeObject:_Hot forKey:@"Hot"];
    [aCoder encodeObject:_SortCode forKey:@"SortCode"];
    [aCoder encodeObject:_RegionName forKey:@"RegionName"];
    [aCoder encodeObject:_RegionFullName forKey:@"RegionFullName"];
}
+(NSMutableArray *)hotRegions
{
    return [Region searchWithWhere:@"Hot > 0" order:@"Hot"];
}
+(NSMutableArray *)allRegions
{
    return [Region searchWithWhere:@"Level = 2" order:@"SortNumber"];
    // AND Hot = 0
}
+ (NSMutableArray *)allThirdLevelRegion
{
    return [Region searchWithWhere:@"Level = 3" order:@"SortNumber"];
}
+(NSMutableArray *)citiesWithRegionId:(NSNumber *)regionId
{
    return [Region searchWithWhere:[NSString stringWithFormat:@"ParentId = %ld",(long)[regionId integerValue]] order:nil];
}
+(NSMutableArray *)citiesWithCodePath:(NSString *)codePath
{
    return [Region searchWithWhere:[NSString stringWithFormat:@" PathCode LIKE \"%@%@%@\"",@"%",codePath,@"%"] order:@"SortNumber"];
}
+ (NSMutableArray *)citiesWithCodeAndNotHot:(NSString*)codePath
{
    return [Region searchWithWhere:[NSString stringWithFormat:@"Level = 3 AND PathCode LIKE \"%@%@%@\"",@"%",codePath,@"%"] order:@"SortNumber"];
//AND PathCode <> \"%@\" codePath
}
+ (NSMutableArray *)searchRegionWithRegionName:(NSString *)name
{
    return [Region searchWithWhere:[NSString stringWithFormat:@" RegionName LIKE \"%@%@%@\"",@"%",name,@"%"] order:@"SortNumber"];
}
+ (NSMutableArray*)searchAddressWithAddressPathCodeString:(NSString*)pathCodeString
{
    if (!pathCodeString && [pathCodeString isEqualToString:@""])
    {
        return nil;
    }
    NSArray *array = [pathCodeString componentsSeparatedByString:@","];
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
            NSString *tmStr = [NSString stringWithFormat:@"PathCode = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
        else
        {
            NSString *tmStr = [NSString stringWithFormat:@" OR PathCode = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
    }
    //NSArray *tmArray = [Region searchWithWhere:mutableString order:@"SortNumber"];
    return [Region searchWithWhere:mutableString order:@"SortNumber"];
}
+(Region*)searchAddressWithAddressString:(NSString*)codeName
{
    NSString *tmStr = [NSString stringWithFormat:@"RegionName = \"%@\"",codeName];
    Region *region = [Region searchWithWhere:tmStr order:nil][0];
    return region;
}
+(Region*)searchAddressWithPathCode:(NSString*)pathCode
{
    NSString *tmStr = [NSString stringWithFormat:@"PathCode = \"%@\"",pathCode];
    Region *region = [Region searchWithWhere:tmStr order:nil][0];
    return region;
}
+(NSMutableArray*)searchRegionWithAddressString:(NSString*)pathCodeString
{
    if (!pathCodeString && [pathCodeString isEqualToString:@""])
    {
        return nil;
    }
    NSArray *array = [pathCodeString componentsSeparatedByString:@","];
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
            NSString *tmStr = [NSString stringWithFormat:@"RegionName = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
        else
        {
            NSString *tmStr = [NSString stringWithFormat:@" OR RegionName = \"%@\"",[array objectAtIndex:i]];
            [mutableString appendString:tmStr];
        }
    }
    //NSArray *tmArray = [Region searchWithWhere:mutableString order:@"SortNumber"];
    return [Region searchWithWhere:mutableString order:@"SortNumber"];
}
@end
