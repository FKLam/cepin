//
//  CPTestSexButton.m
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPTestSexButton.h"

@implementation CPTestSexButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageW = 50 / 3.0;
    CGFloat imageH = 50 / 3.0;
    CGFloat imageY = ( contentRect.size.height - imageH ) / 2.0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = ( 50 + 40 ) / 3.0;
    CGFloat titleY = 0;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleW = contentRect.size.width - titleX;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
