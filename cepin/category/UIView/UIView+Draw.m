//
//  UIView+Draw.m
//  Daishu
//
//  Created by Ricky Tang on 14-3-19.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "UIView+Draw.h"

@implementation UIView (Draw)
-(void)drawSeparatorWithRect:(CGRect)rect color:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
//    CGFloat width = CGRectGetWidth(rect);
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect)+10, CGRectGetMaxY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect)-10, CGRectGetMaxY(rect));
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [color setStroke];
    path.lineWidth = 1;
    [path stroke];
    [path closePath];
}



-(void)drawSeparatorLongWithRect:(CGRect)rect color:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)-2);
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)-2);
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [color setStroke];
    path.lineWidth = 1;
    [path stroke];
    [path closePath];
    
}


-(void)drawSeparatorAboveWithRect:(CGRect)rect color:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect)+10, CGRectGetMinY(rect)+1);
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect)-10, CGRectGetMinY(rect)+1);
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [color setStroke];
    path.lineWidth = 1;
    [path stroke];
    [path closePath];
}


-(void)drawSeparatorAboveLongWithRect:(CGRect)rect color:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)+1);
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)+1);
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [color setStroke];
    path.lineWidth = 1;
    [path stroke];
    [path closePath];
}



-(void)drawVerticalLineSeparatorWithRect:(CGRect)rect color:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(CGRectGetMaxX(rect)-1, CGRectGetMinY(rect)+5);
    CGPoint endpoint = CGPointMake(CGRectGetMaxX(rect)-1, CGRectGetMaxY(rect)-5);
    
    [path moveToPoint:startPoint];
    [path addLineToPoint:endpoint];
    [color setStroke];
    path.lineWidth = 1;
    [path stroke];
    [path closePath];
}

-(void)drawDeleteLineWithRect:(CGRect)rect color:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [color setStroke];
    path.lineWidth = 1;
    [path stroke];
    [path closePath];
}

@end
