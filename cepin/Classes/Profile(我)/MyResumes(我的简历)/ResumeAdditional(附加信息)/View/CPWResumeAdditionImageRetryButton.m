//
//  CPWResumeAdditionImageRetryButton.m
//  cepin
//
//  Created by ceping on 16/4/8.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWResumeAdditionImageRetryButton.h"
@interface CPWResumeAdditionImageRetryButton ()
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, assign) CGFloat contentHeight;
@end
@implementation CPWResumeAdditionImageRetryButton
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    self.titleString = title;
    self.contentHeight = 36 / 3.0;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = 48 / 3.0;
    CGFloat H = 48 / 3.0;
    CGFloat Y = ( contentRect.size.height - H - self.contentHeight ) / 2.0 - 5 / 3.0;
    CGFloat X = ( contentRect.size.width - W ) / 2.0;
    return CGRectMake(X, Y, W, H);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width;
    CGFloat H = self.contentHeight;
    CGFloat X = 0;
    CGFloat Y = CGRectGetMaxY(self.imageView.frame) + 5 / 3.0;
    return CGRectMake(X, Y, W, H);
}
@end
