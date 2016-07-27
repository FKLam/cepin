//
//  CPHomeChangeCityButton.m
//  cepin
//
//  Created by ceping on 16/1/11.
//  Copyright © 2016年 talebase. All rights reserved.
//


#import "CPHomeChangeCityButton.h"
#import "CPCommon.h"
@interface CPHomeChangeCityButton ()
@property (nonatomic, copy) NSString *storageTitleStr;
@end
@implementation CPHomeChangeCityButton
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = contentRect.size.width - 42 / CP_GLOBALSCALE - 20 / CP_GLOBALSCALE;
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width - 42 / CP_GLOBALSCALE;
    CGFloat titleH = contentRect.size.height;
    CGSize titleSize = [_storageTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, titleH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]} context:nil].size;
    if ( titleW > titleSize.width )
    {
        
        titleW = titleSize.width;
    }
    if ( titleX < titleW )
        titleX = 0;
    else
        titleX -= titleW;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 48 / CP_GLOBALSCALE;
    CGFloat imageH = 48 / CP_GLOBALSCALE;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageY = (contentRect.size.height - imageH) / 2.0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    _storageTitleStr = title;
}
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
