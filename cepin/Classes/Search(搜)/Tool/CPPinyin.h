//
//  CPPinyin.h
//  cepin
//
//  Created by dujincai on 16/3/24.
//  Copyright © 2016年 talebase. All rights reserved.
//

#ifndef CPPinyin_h
#define CPPinyin_h

#include <stdio.h>

#endif /* CPPinyin_h */
/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"中文测试文字！";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */
#define ALPHA    @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"
char pinyinFirstLetter(unsigned short hanzi);


