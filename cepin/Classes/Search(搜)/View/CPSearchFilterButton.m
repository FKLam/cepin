//
//  CPSearchFilterButton.m
//  cepin
//
//  Created by kun on 16/1/10.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchFilterButton.h"
#import "CPCommon.h"
@interface CPSearchFilterButton ()
@property (nonatomic, strong) UIView *separatorLine;
@end
@implementation CPSearchFilterButton
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        [self addSubview:self.separatorLine];
        
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 45 / CP_GLOBALSCALE;
    CGFloat imageH = 45 / CP_GLOBALSCALE;
    CGFloat imageY = ( contentRect.size.height - imageH ) / 2.0;
    CGFloat imageX = contentRect.size.width - imageW - 20 / CP_GLOBALSCALE / 2.0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleH = contentRect.size.height;
    CGFloat titleY = 0;
    NSString *titleStr = @"工作地点";
    CGSize titleSize = [titleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, titleH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE] } context:nil].size;
    CGFloat titleW = titleSize.width;
    CGFloat titleX = contentRect.size.width - 45 / CP_GLOBALSCALE - 20 / CP_GLOBALSCALE - titleW;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if ( selected )
    {
        _separatorLine.hidden = YES;
    }
    else
    {
        _separatorLine.hidden = NO;
    }
}

#pragma mark - getter methods
- (UIView *)separatorLine
{
    if ( !_separatorLine )
    {
        _separatorLine = [[UIView alloc] init];
        [_separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _separatorLine;
}
@end
