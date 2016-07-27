//
//  CPWCompanyDetailButton.m
//  cepin
//
//  Created by ceping on 16/3/31.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWCompanyDetailButton.h"
#import "CPCommon.h"
@interface CPWCompanyDetailButton ()
@property (nonatomic, strong) NSString *storageTitle;
@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, strong) UIView *topSeparatorLine;
@end
@implementation CPWCompanyDetailButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self addSubview:self.topSeparatorLine];
        [self.topSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return self;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    self.storageTitle = title;
    self.titleWidth = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} context:nil].size.width;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 70 / CP_GLOBALSCALE;
    CGFloat imageH = 70 / CP_GLOBALSCALE;
    CGFloat imageX = (contentRect.size.width - imageW - self.titleWidth - 30 / CP_GLOBALSCALE) / 2.0 ;
    CGFloat imageY = ( 144 / CP_GLOBALSCALE - imageH) / 2.0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = self.titleWidth;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleY = 0;
    CGFloat titleX = CGRectGetMaxX(self.imageView.frame) + 30 / CP_GLOBALSCALE;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (UIView *)topSeparatorLine
{
    if ( !_topSeparatorLine )
    {
        _topSeparatorLine = [[UIView alloc] init];
        [_topSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _topSeparatorLine;
}
@end
