//
//  NSString+Extension.m
//  cepin
//
//  Created by ceping on 15/11/20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "NSString+Extension.h"
#import <sys/utsname.h>

@implementation NSString (Extension)

#pragma mark - java api

- (NSUInteger) compareTo: (NSString*) comp {
    NSComparisonResult result = [self compare:comp];
    if (result == NSOrderedSame) {
        return 0;
    }
    return result == NSOrderedAscending ? -1 : 1;
}

- (NSUInteger) compareToIgnoreCase: (NSString*) comp {
    return [[self lowercaseString] compareTo:[comp lowercaseString]];
}

- (bool) contains: (NSString*) substring {
    NSRange range = [self rangeOfString:substring];
    return range.location != NSNotFound;
}

- (bool) endsWith: (NSString*) substring {
    NSRange range = [self rangeOfString:substring];
    return range.location == [self length] - [substring length];
}

- (bool) startsWith: (NSString*) substring {
    NSRange range = [self rangeOfString:substring];
    return range.location == 0;
}

- (NSUInteger) indexOf: (NSString*) substring {
    NSRange range = [self rangeOfString:substring options:NSCaseInsensitiveSearch];
    return range.location == NSNotFound ? -1 : range.location;
}

- (NSUInteger) indexOf:(NSString *)substring startingFrom: (NSUInteger) index {
    NSString* test = [self substringFromIndex:index];
    return index+[test indexOf:substring];
}

- (NSUInteger) lastIndexOf: (NSString*) substring {
    NSRange range = [self rangeOfString:substring options:NSBackwardsSearch];
    return range.location == NSNotFound ? -1 : range.location;
}

- (NSUInteger) lastIndexOf:(NSString *)substring startingFrom: (NSUInteger) index {
    NSString* test = [self substringFromIndex:index];
    return [test lastIndexOf:substring];
}

- (NSString*) substringFromIndex:(NSUInteger)from toIndex: (NSUInteger) to {
    NSRange range;
    range.location = from;
    range.length = to - from;
    return [self substringWithRange: range];
}

- (NSString*) trim {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray*) split: (NSString*) token {
    return [self split:token limit:0];
}

- (NSArray*) split: (NSString*) token limit: (NSUInteger) maxResults {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity: 8];
    NSString* buffer = self;
    while ([buffer contains:token]) {
        if (maxResults > 0 && [result count] == maxResults - 1) {
            break;
        }
        NSUInteger matchIndex = [buffer indexOf:token];
        NSString* nextPart = [buffer substringFromIndex:0 toIndex:matchIndex];
        buffer = [buffer substringFromIndex:matchIndex + [token length]];
        [result addObject:nextPart];
    }
    if ([buffer length] > 0) {
        [result addObject:buffer];
    }
    
    return result;
}

- (NSString*) replace: (NSString*) target withString: (NSString*) replacement {
    return [self stringByReplacingOccurrencesOfString:target withString:replacement];
}

- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace{
    return [self sizeWithConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX) fromFont:font1 lineSpace:lineSpace];
}

- (CGSize)sizeWithConstrainedToSize:(CGSize)size fromFont:(UIFont *)font1 lineSpace:(float)lineSpace{
    CGFloat minimumLineHeight = font1.pointSize,maximumLineHeight = minimumLineHeight, linespace = lineSpace;
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)font1.fontName,font1.pointSize,NULL);
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    //Apply paragraph settings
    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font,(NSString*)kCTFontAttributeName,(__bridge id)style,(NSString*)kCTParagraphStyleAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    //    [self clearEmoji:string start:0 font:font1];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)string;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize result = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [string length]), NULL, size, NULL);
    CFRelease(framesetter);
    CFRelease(font);
    CFRelease(style);
    string = nil;
    attributes = nil;
    return result;
}

- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height andWidth:(float)width{
    CGSize size = CGSizeMake(width, font.pointSize);
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0,height);
    CGContextScaleCTM(context,1.0,-1.0);
    
    //Determine default text color
    UIColor* textColor = color;
    //Set line height, font, color and break mode
    CTFontRef font1 = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize,NULL);
    //Apply paragraph settings
    CGFloat minimumLineHeight = font.pointSize,maximumLineHeight = minimumLineHeight, linespace = 5;
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    CTTextAlignment alignment = kCTTextAlignmentCenter;
    //Apply paragraph settings
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font1,(NSString*)kCTFontAttributeName,
                                textColor.CGColor,kCTForegroundColorAttributeName,
                                style,kCTParagraphStyleAttributeName,
                                nil];
    //Create path to work with a frame with applied margins
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path,NULL,CGRectMake(p.x, height-p.y-size.height,(size.width),(size.height)));
    
    //Create attributed string, with applied syntax highlighting
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)attributedStr;
    
    //Draw the frame
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,CFAttributedStringGetLength(attributedString)),path,NULL);
    CTFrameDraw(ctframe,context);
    CGPathRelease(path);
    CFRelease(font1);
    CFRelease(framesetter);
    CFRelease(ctframe);
    [[attributedStr mutableString] setString:@""];
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0, height);
    CGContextScaleCTM(context,1.0,-1.0);
}

- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height{
    [self drawInContext:context withPosition:p andFont:font andTextColor:color andHeight:height andWidth:CGFLOAT_MAX];
}

- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)position andColor:(UIColor *)color andFont:(UIFont *)font andHeight:(CGFloat)height andWidth:(CGFloat)width
{
    CGSize size = CGSizeMake(width, font.pointSize);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    UIColor *tempTextColor = color;
    CTFontRef font1 = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize,NULL);
    
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    CTTextAlignment alignment = kCTTextAlignmentLeft;
    CGFloat minimumLineHeight = font.pointSize,maximumLineHeight = minimumLineHeight,linespace = 5;
    
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}
    }, 6);
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font1,(NSString*)kCTFontAttributeName, tempTextColor.CGColor, kCTForegroundColorAttributeName, style, kCTParagraphStyleAttributeName, nil];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect addFrame = CGRectMake(position.x, position.y - (font.pointSize + linespace) * 1.6, size.width, height + linespace);
    CGPathAddRect(path, NULL, addFrame);
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    attString = [[NSAttributedString alloc] initWithString:@""];
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
}


- (void)drawInContext11:(CGContextRef)context withPosition:(CGPoint)position andColor:(UIColor *)color andFont:(UIFont *)font andHeight:(CGFloat)height andWidth:(CGFloat)width
{
    CGSize size = CGSizeMake(width, font.pointSize);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    UIColor *tempTextColor = color;
    CTFontRef font1 = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize,NULL);
    
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    CTTextAlignment alignment = kCTTextAlignmentLeft;
    CGFloat minimumLineHeight = font.pointSize,maximumLineHeight = minimumLineHeight,linespace = 5;
    
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}
    }, 6);
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font1,(NSString*)kCTFontAttributeName, tempTextColor.CGColor, kCTForegroundColorAttributeName, style, kCTParagraphStyleAttributeName, nil];
    
    CGMutablePathRef path = CGPathCreateMutable();
//    CGRect addFrame = CGRectMake(position.x, position.y - (font.pointSize + linespace) * 1.6, size.width, height + linespace);
    CGRect addFrame = CGRectMake(position.x, -position.y, size.width, size.height);
    CGPathAddRect(path, NULL, addFrame);
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    attString = [[NSAttributedString alloc] initWithString:@""];
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
}

+ (NSString *)deviceStr
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return [deviceString copy];
}

+ (CGSize)caculateTextSize:(UIView *)control
{
    if ( ![control isKindOfClass:[UILabel class]] )
        return CGSizeZero;
    UILabel *label = (UILabel *)control;
    CGSize controlSize = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : label.font } context:nil].size;
    return controlSize;
}
+ (CGSize)caculateTextSize:(UIFont *)font text:(NSString *)text andWith:(CGFloat)width
{
    CGSize controlSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : font } context:nil].size;
    return controlSize;
}

+ (CGSize)caculateAttTextSize:(NSAttributedString *)text andWith:(CGFloat)width
{
//    CGSize controlSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : font } context:nil].size;
//    return controlSize;
    
    CGSize attTextSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return attTextSize;
}
@end
