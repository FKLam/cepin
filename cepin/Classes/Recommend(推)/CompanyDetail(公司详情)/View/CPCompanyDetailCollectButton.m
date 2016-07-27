//
//  CPCompanyDetailCollectButton.m
//  cepin
//
//  Created by ceping on 16/1/27.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyDetailCollectButton.h"
#import "CPCommon.h"
@interface CPCompanyDetailCollectButton ()
@property (nonatomic, copy) NSString *storageTitleString;

@end

@implementation CPCompanyDetailCollectButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    _storageTitleString = title;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 84 / CP_GLOBALSCALE;
    CGFloat imageH = imageW;
    CGFloat imageX = (contentRect.size.width / 2.0 - imageW - 40 / CP_GLOBALSCALE / 2.0 );
    CGFloat imageY = (contentRect.size.height - imageH) / 2.0 - 2.0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleH = contentRect.size.height;
    CGFloat titleX = contentRect.size.width / 2.0 - 40 / CP_GLOBALSCALE / 2.0;
    CGFloat titleW = contentRect.size.width / 2.0;
    CGFloat titleY = 0;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
@end