//
//  NSString+Extension.h
//  cepin
//
//  Created by ceping on 15/11/20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface NSString (Extension)

#pragma mark - java api
- (NSUInteger) compareTo: (NSString*) comp;
- (NSUInteger) compareToIgnoreCase: (NSString*) comp;
- (bool) contains: (NSString*) substring;
- (bool) endsWith: (NSString*) substring;
- (bool) startsWith: (NSString*) substring;
- (NSUInteger) indexOf: (NSString*) substring;
- (NSUInteger) indexOf:(NSString *)substring startingFrom: (NSUInteger) index;
- (NSUInteger) lastIndexOf: (NSString*) substring;
- (NSUInteger) lastIndexOf:(NSString *)substring startingFrom: (NSUInteger) index;
- (NSString*) substringFromIndex:(NSUInteger)from toIndex: (NSUInteger) to;
- (NSString*) trim;
- (NSArray*) split: (NSString*) token;
- (NSString*) replace: (NSString*) target withString: (NSString*) replacement;
- (NSArray*) split: (NSString*) token limit: (NSUInteger) maxResults;

- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;
- (CGSize)sizeWithConstrainedToSize:(CGSize)size fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;
- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height andWidth:(float)width;
- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height;

- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)position andColor:(UIColor *)color andFont:(UIFont *)font andHeight:(CGFloat)height andWidth:(CGFloat)width;

- (void)drawInContext11:(CGContextRef)context withPosition:(CGPoint)position andColor:(UIColor *)color andFont:(UIFont *)font andHeight:(CGFloat)height andWidth:(CGFloat)width;

/** 返回设备字符串 */
+ (NSString *)deviceStr;

/** 返回uilabel控件文本所占据的空间大小size */
+ (CGSize)caculateTextSize:(UIView *)control;


+ (CGSize)caculateTextSize:(UIFont *)font text:(NSString *)text andWith:(CGFloat)width;

+ (CGSize)caculateAttTextSize:(NSAttributedString *)text andWith:(CGFloat)width;
@end
