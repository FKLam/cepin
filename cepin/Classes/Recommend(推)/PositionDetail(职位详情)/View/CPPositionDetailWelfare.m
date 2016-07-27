//
//  CPPositionDetailWelfare.m
//  cepin
//
//  Created by dujincai on 16/3/22.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPositionDetailWelfare.h"
#import "CPCommon.h"
@interface CPPositionDetailWelfare ()

@property (nonatomic, strong) NSArray *welfareArray;
@property (nonatomic, strong) NSMutableArray *welfareButtonM;
@end

@implementation CPPositionDetailWelfare
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
    }
    return self;
}
- (void)configWithArray:(NSArray *)welfareArray
{
    _welfareArray = welfareArray;
    for ( UIButton *subBtn in self.welfareButtonM )
    {
        [subBtn removeFromSuperview];
    }
    [self.welfareButtonM removeAllObjects];
    for (NSString *subStr in _welfareArray )
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHexString:@"707070"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:32 / CP_GLOBALSCALE]];
        [btn.layer setCornerRadius:6 / CP_GLOBALSCALE];
        [btn.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
        btn.hidden = YES;
        [btn setEnabled:NO];
        [btn setTitle:subStr forState:UIControlStateNormal];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [self addSubview:btn];
        [self.welfareButtonM addObject:btn];
    }
    [self setNeedsDisplay];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat buttonX = 40 / CP_GLOBALSCALE;
    CGFloat buttonY =  40 / CP_GLOBALSCALE;
    CGFloat buttonH = ( 15 + 15 + 32 ) / CP_GLOBALSCALE;
    CGFloat buttonW = 0;
    NSString *buttonTitle = nil;
    UIButton *btn = nil;
    CGFloat maxX = kScreenWidth - 40 / CP_GLOBALSCALE;
    NSUInteger buttonIndex = 0;
    NSUInteger stop = 0;
    for ( NSUInteger index = 0; index < [_welfareArray count]; index++ )
    {
        if ( 2 == stop )
            break;
        buttonTitle = _welfareArray[index];
        buttonW = 15 / CP_GLOBALSCALE * 2 + 32 / CP_GLOBALSCALE * buttonTitle.length;
        if ( maxX < buttonW + buttonX )
            continue;
        btn = self.welfareButtonM[buttonIndex];
        [btn setTitle:buttonTitle forState:UIControlStateNormal];
        [btn setHidden:NO];
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        buttonX += buttonW + 20 / CP_GLOBALSCALE;
        if ( buttonX > maxX )
        {
            stop++;
            buttonX = 40 / CP_GLOBALSCALE;
            buttonY += buttonH + 20 / CP_GLOBALSCALE;
        }
        buttonIndex++;
    }
}
- (NSMutableArray *)welfareButtonM
{
    if ( !_welfareButtonM )
    {
        _welfareButtonM = [NSMutableArray array];
    }
    return _welfareButtonM;
}
@end
