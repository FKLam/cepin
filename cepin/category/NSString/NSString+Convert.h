//
//  NSString+Convert.h
//  yanyu
//
//  Created by rickytang on 13-9-2.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Convert)
-(NSString *)removeEscape;

-(NSString *)replaceString:(NSString *)convertString toString:(NSString *)toString;

-(NSString *)replaceString:(NSString *)convertString toArray:(NSArray *)strings;

-(NSString *)addWhiteSpaceBetweenString:(NSString *)aString;

-(NSString *)addStringBeforeExtensionWith:(NSString *)aString;

@end
