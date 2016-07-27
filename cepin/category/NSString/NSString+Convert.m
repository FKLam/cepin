//
//  NSString+Convert.m
//  yanyu
//
//  Created by rickytang on 13-9-2.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "NSString+Convert.h"
#import "NSString+Addition.h"

@implementation NSString (Convert)
-(NSString *)removeEscape
{
    return [self replaceString:@"\\n" toString:@"\n"];
}

-(NSString *)replaceString:(NSString *)convertString toString:(NSString *)toString
{
    if ([self rangeOfString:convertString].length > 0) {
        return [[self componentsSeparatedByString:convertString] componentsJoinedByString:toString];
    }
    return self;
}


-(NSString *)replaceString:(NSString *)convertString toArray:(NSArray *)strings
{
    if ([self rangeOfString:convertString].length > 0) {
        NSArray *temp = [self componentsSeparatedByString:convertString];
        NSString *item;
        for (int i = 0;i<temp.count;i++) {
            if (temp == nil) {
                item = temp[i];
            }
            else{
                [[item stringByAppendingFormat:@"%@",strings[i]] stringByAppendingString:temp[i]];
            }
        }
        return item;
    }
    return self;
}


-(NSString *)addWhiteSpaceBetweenString:(NSString *)aString
{
    if (![aString checkTextBlank] || !aString) {
        return self;
    }
    return [self stringByAppendingFormat:@" %@",aString];
}


-(NSString *)addStringBeforeExtensionWith:(NSString *)aString
{
    NSString *tempExtension = [self pathExtension];
    NSString *tempString = [self stringByDeletingPathExtension];
    return [[tempString stringByAppendingString:aString] stringByAppendingPathExtension:tempExtension];
}
@end
