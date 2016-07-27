//
//  CPResumeGuideExperienceCityButton.m
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeGuideExperienceCityButton.h"
#import "CPCommon.h"
@implementation CPResumeGuideExperienceCityButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 70 / CP_GLOBALSCALE;
    CGFloat imageH = imageW;
    CGFloat imageX = (contentRect.size.width - imageW) / 2.0;
    CGFloat imageY = (contentRect.size.height - imageH) / 2.0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
