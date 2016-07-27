//
//  CustemLineLable.m
//  cepin
//
//  Created by peng on 14-11-11.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CustemLineLable.h"


@implementation CustemLineLable

-(void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize textSize = CGSizeZero;
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 7.0 )
    {
        textSize = [[self text] sizeWithAttributes:@{ NSFontAttributeName : [self font] }];
    }
    else
    {
        textSize = [[self text] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [self font] } context:nil].size;
    }
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    CGRect lineRect2;
    CGFloat origin_x1;
    CGFloat origin_x2;
    CGFloat origin_y = 0.0;
    
    if ([self textAlignment] == NSTextAlignmentRight) {
        
        origin_x1 = rect.size.width - strikeWidth;
        
    } else if ([self textAlignment] == NSTextAlignmentCenter) {
        
        origin_x2 = (rect.size.width + strikeWidth) / 2 ;
//        origin_x1 = 0;
        
    } else {
        
        origin_x1 = 0;
    }
    
    
    if (self.lineType == LineTypeUp) {
        
        origin_y =  2;
    }
    
    if (self.lineType == LineTypeMiddle) {
        
        origin_y =  rect.size.height / 2;
    }
    
    if (self.lineType == LineTypeDown) {//下画线
        
        origin_y = rect.size.height - 2;
    }
    
    lineRect = CGRectMake( origin_x1 - 10, origin_y, (rect.size.width - strikeWidth) / 2, 1);
    lineRect2 = CGRectMake( origin_x2 + 10, origin_y, (rect.size.width - strikeWidth) / 2, 1);
    
    if ( self.lineType != LineTypeNone ) {
        [self drawGradientLineWithContext:context rect:lineRect direction:0];
        [self drawGradientLineWithContext:context rect:lineRect2 direction:-1];
    }

}

- (void)drawGradientLineWithContext:(CGContextRef)context rect:(CGRect)rect direction:(CGFloat)direction
{
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef beginColor = CGColorCreateCopyWithAlpha([[RTAPPUIHelper shareInstance] subTitleColor].CGColor, 0.025 );
    CGColorRef endColor = CGColorCreateCopyWithAlpha([[RTAPPUIHelper shareInstance] subTitleColor].CGColor, 0.4 );
    if ( direction < 0 )
    {
        CGColorRef tempColor = beginColor;
        beginColor = endColor;
        endColor = tempColor;    }
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,
        1.0f
    });
    CFRelease( colorArray );
    CGColorRelease( beginColor );
    CGColorRelease( endColor );
    
    CGColorSpaceRelease( colorSpaceRef );
    CGContextClipToRect(context, rect);
    CGContextDrawLinearGradient(context, gradientRef, rect.origin, CGPointMake(CGRectGetMaxX(rect), rect.origin.y), 0);
    
    CGGradientRelease(gradientRef);
    
    CGContextRestoreGState(context);

}

@end
