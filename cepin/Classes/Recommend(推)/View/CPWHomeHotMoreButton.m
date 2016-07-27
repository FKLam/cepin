//
//  CPWHomeHotMoreButton.m
//  cepin
//
//  Created by ceping on 16/3/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWHomeHotMoreButton.h"
#import "CPCommon.h"
@interface CPWHomeHotMoreButton ()
@property (nonatomic, copy) NSString *storageTitleStr;
@property (nonatomic, assign) CGFloat titleWidth;
@end
@implementation CPWHomeHotMoreButton
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    _storageTitleStr = title;
    CGSize tempTitleSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} context:nil].size;
    self.titleWidth = tempTitleSize.width;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleW = self.titleWidth;
    CGFloat titleX = contentRect.size.width - contentRect.size.height - 0 - titleW;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageH = contentRect.size.height;
    CGFloat imageW = imageH;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageY = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
