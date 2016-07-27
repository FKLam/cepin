//
//  CPProfileResumeButton.m
//  cepin
//
//  Created by ceping on 16/1/7.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPProfileResumeButton.h"
#import "CPCommon.h"
@implementation CPProfileResumeButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height;
    CGFloat imageW = 48 / CP_GLOBALSCALE;
    CGFloat imageH = imageW;
    CGFloat marge = 20 / CP_GLOBALSCALE;
    CGFloat imageX = width / 2.0 - marge - imageW;
    CGFloat imageY = ( height - imageH ) / 2.0;
    return CGRectMake( imageX, imageY, imageW, imageH );
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height;
    CGFloat titleH = height;
    CGFloat titleX = width / 2.0;
    CGFloat titleY = 0;
    CGFloat titleW = width - titleX;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (void)setHighlighted:(BOOL)highlighted
{
//    if ( highlighted && self.imageView )
//    {
//        self.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
//    }
//    else
//    {
//        self.backgroundColor = [UIColor clearColor];
//    }
}
@end
