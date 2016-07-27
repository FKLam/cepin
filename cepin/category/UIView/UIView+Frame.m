//
//  UIView+Frame.m
//  yanyu
//
//  Created by rickytang on 13-9-12.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

-(CGFloat)viewX
{
    return CGRectGetMinX(self.frame);
}

-(void)setViewX:(CGFloat)xPoint
{
    CGRect rect = self.frame;
    rect = CGRectMake(xPoint, CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
    self.frame = rect;
}

-(CGFloat)viewY
{
    return CGRectGetMinY(self.frame);
}

-(void)setViewY:(CGFloat)yPoint
{
    CGRect rect = self.frame;
    rect = CGRectMake(CGRectGetMinX(rect), yPoint, CGRectGetWidth(rect), CGRectGetHeight(rect));
    self.frame = rect;
}

-(CGPoint)viewPoint
{
    return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
}

-(void)setViewPoint:(CGPoint)point
{
    self.viewX = point.x;
    self.viewY = point.y;
}

-(CGFloat)viewWidth
{
    return CGRectGetWidth(self.frame);
}

-(void)setViewWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), width, CGRectGetHeight(rect));
    self.frame = rect;
}


-(CGFloat)viewHeight
{
    return CGRectGetHeight(self.frame);
}

-(void)setViewHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), height);
    self.frame = rect;
}

-(CGSize)viewSize
{
    return CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

-(void)setViewSize:(CGSize)size
{
    self.viewWidth = size.width;
    self.viewHeight = size.height;
}


-(CGFloat)viewCenterX
{
    return self.center.x;
}

-(void)setViewCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

-(CGFloat)viewCenterY
{
    return self.center.y;
}

-(void)setViewCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

@end
