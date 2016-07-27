//
//  CPResumeMoreButton.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeMoreButton.h"
#import "CPCommon.h"
@interface CPResumeMoreButton ()
@property (nonatomic, copy) NSString *storageTitleString;
@property (nonatomic, assign) CGFloat titleWidth;
@end
@implementation CPResumeMoreButton
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    _storageTitleString = title;
    CGSize tempTitleSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]} context:nil].size;
    self.titleWidth = tempTitleSize.width + 70 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 70 / CP_GLOBALSCALE;
    CGFloat imageH = imageW;
    CGFloat imageX = (contentRect.size.width / 2.0 - self.titleWidth / 2.0 );
    CGFloat imageY = (contentRect.size.height - imageH) / 2.0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleH = contentRect.size.height;
    if ( 0 == titleH )
    {
        return CGRectZero;
    }
    CGFloat titleX = self.imageView.viewX + 70 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    CGFloat titleW = self.titleWidth - ( 70 + 40 ) / CP_GLOBALSCALE;
    CGFloat titleY = 0;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
@end
