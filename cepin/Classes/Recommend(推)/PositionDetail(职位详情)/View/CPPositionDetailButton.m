//
//  CPPositionDetailButton.m
//  cepin
//
//  Created by ceping on 16/1/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPositionDetailButton.h"
#import "CPCommon.h"
@implementation CPPositionDetailButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 84 / CP_GLOBALSCALE;
    CGFloat imageH = 84 / CP_GLOBALSCALE;
    CGFloat imageX = (contentRect.size.width - imageW) / 2.0;
    CGFloat imageY = (contentRect.size.height - imageH) / 2.0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
