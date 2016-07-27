//
//  CPEditResumeRightMenuButton.m
//  cepin
//
//  Created by ceping on 16/2/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPEditResumeRightMenuButton.h"
#import "CPCommon.h"
@interface CPEditResumeRightMenuButton ()
@property (nonatomic, strong) NSString *staticTitleStr;
@end
@implementation CPEditResumeRightMenuButton
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        [self.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
    }
    return self;
}
- (void)configWithTitel:(NSString *)title imageName:(NSString *)imageName
{
    self.staticTitleStr = title;
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    NSString *title = self.staticTitleStr;
    CGSize staticSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]} context:nil].size;
    return CGRectMake(contentRect.size.width / 2.0 - 42 / CP_GLOBALSCALE, 0, staticSize.width, contentRect.size.height);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat H = 70 / CP_GLOBALSCALE;
    CGFloat W = 70 / CP_GLOBALSCALE;
    CGFloat Y = ( contentRect.size.height - H ) / 2.0;
    CGFloat X = ( contentRect.size.width / 2.0 - W - 42 / CP_GLOBALSCALE - 20 / CP_GLOBALSCALE);
    return CGRectMake(X, Y, W, H);
}
@end
