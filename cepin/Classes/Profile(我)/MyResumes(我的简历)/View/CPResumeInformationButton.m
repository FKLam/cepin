//
//  CPResumeInformationButton.m
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeInformationButton.h"
#import "CPCommon.h"
@implementation CPResumeInformationButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 48 / CP_GLOBALSCALE;
    CGFloat imageH = imageW;
    CGFloat imageX = (contentRect.size.width - imageW) / 2.0;
    CGFloat imageY = (contentRect.size.height - imageH) / 2.0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
