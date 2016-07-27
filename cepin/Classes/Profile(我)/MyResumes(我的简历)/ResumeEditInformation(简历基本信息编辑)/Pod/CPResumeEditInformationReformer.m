//
//  CPResumeEditInformationReformer.m
//  cepin
//
//  Created by ceping on 16/1/29.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEditInformationReformer.h"
#import "RegionDTO.h"
@interface CPResumeEditInformationReformer ()

@end
NSString *_oneWordStr = @"";
@implementation CPResumeEditInformationReformer
+ (void)SaveOneWord:(NSString *)oneWordStr
{
    if ( !oneWordStr || [oneWordStr isEqualToString:@"(null)"] )
        return;
    _oneWordStr = oneWordStr;
}
+ (NSString *)onwWordStr
{
    return _oneWordStr;
}
+ (NSArray *)searchMatchAddressWithMatchString:(NSString *)matchString originArray:(NSArray *)originArray
{
    NSMutableArray *arrayM = [NSMutableArray array];
    if ( !matchString || 0 == [matchString length] )
        return arrayM;
    NSArray *allAddress = originArray;
    for ( Region *region in allAddress )
    {
        NSRange range = [region.RegionName rangeOfString:matchString];
        if ( range.location == NSNotFound )
        {
            continue;
        }
        [arrayM addObject:region];
    }
    return arrayM;
}
@end
