//
//  CPResumeEditLocalAddressButton.m
//  cepin
//
//  Created by ceping on 16/2/23.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEditLocalAddressButton.h"
#import "CPCommon.h"
@interface CPResumeEditLocalAddressButton ()
@property (nonatomic, strong) NSString *staticTitleStr;
@end
@implementation CPResumeEditLocalAddressButton
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    self.staticTitleStr = title;
    [super setTitle:title forState:state];
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat H = contentRect.size.height;
    CGSize titleSize = [self.staticTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]} context:nil].size;
    CGFloat X = (contentRect.size.width) / 2.0 - 20 / CP_GLOBALSCALE;
    CGFloat Y = 0;
    return CGRectMake(X, Y, titleSize.width, H);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat H = 48 / CP_GLOBALSCALE;
    CGFloat W = 48 / CP_GLOBALSCALE;
    CGFloat X = contentRect.size.width / 2.0 - 30 / CP_GLOBALSCALE - W;
    CGFloat Y = ( contentRect.size.height - H ) / 2.0;
    return CGRectMake(X, Y, W, H);
}
@end
