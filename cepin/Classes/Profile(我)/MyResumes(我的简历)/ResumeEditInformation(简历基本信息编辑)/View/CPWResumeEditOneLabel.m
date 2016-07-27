//
//  CPWResumeEditOneLabel.m
//  cepin
//
//  Created by ceping on 16/5/4.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWResumeEditOneLabel.h"
#import <CoreText/CoreText.h>
#import "CPCommon.h"
@implementation CPWResumeEditOneLabel
/**
 *  绘制个性化的文字
 *
 */
- (void)drawTextInRect:(CGRect)rect
{
    if ( !self.text || 0 == [self.text length] )
        return;
    // 去掉空行
    NSString *labeString = self.text;
    NSString *myString = [labeString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    // 创建AttributeString
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:myString];
    // 设置字体及大小
    CTFontRef helvetica = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [string addAttribute:(id)kCTFontAttributeName value:(__bridge id)helvetica range:NSMakeRange(0, [string length])];
    // 设置字间距
    // 设置字体颜色
    [string addAttribute:(id)kCTForegroundColorAttributeName value:(__bridge id)(self.textColor.CGColor) range:NSMakeRange(0, [string length])];
    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value = &alignment;
    // 设置文本行间距
    CGFloat lineSpace = 10.0 / CP_GLOBALSCALE;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value = &lineSpace;
    // 设置文本段间距
    CGFloat paragraphSpacing = 0.0;
    CTParagraphStyleSetting paragraphSpaceStyle;
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpaceStyle.valueSize = sizeof(CGFloat);
    paragraphSpaceStyle.value = &paragraphSpacing;
    // 设置换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    // 创建设置数组
    CTParagraphStyleSetting settings[] = {alignmentStyle, lineSpaceStyle, paragraphSpaceStyle, lineBreakMode};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings));
    // 给文本条件设置
    [string addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0, [string length])];
    // 排版
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 3 - 255 / CP_GLOBALSCALE - 20 / CP_GLOBALSCALE;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    CGPathAddRect(leftColumnPath, NULL, CGRectMake(0, 2.0, maxW, self.bounds.size.height));
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), leftColumnPath, NULL);
    // 翻转坐标系统（文本原来是倒的药翻转一下）
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // 画出文本
    CTFrameDraw(leftFrame, context);
    // 释放
    CGPathRelease(leftColumnPath);
    CFRelease(framesetter);
    CFRelease(helvetica);
    UIGraphicsPushContext(context);
}
@end
