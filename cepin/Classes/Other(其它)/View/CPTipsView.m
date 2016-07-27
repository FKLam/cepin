//
//  CPTipsView.m
//  cepin
//
//  Created by ceping on 16/3/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPTipsView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@implementation CPTipsView
+ (instancetype)tipsViewWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles showMessageRect:(CGRect)showMessageRect message:(NSString *)message
{
    __block CPTipsView *tipsViewBackgroundView = [[CPTipsView alloc] initWithFrame:showMessageRect];
    tipsViewBackgroundView.identifier = 0;
    [tipsViewBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
    CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    CGFloat maxW = kScreenWidth - ( 84 + 64 + 40 * 2 ) / CP_GLOBALSCALE;
    CGFloat H = ( 84 + 60 + 84 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
    CGFloat X = 40 / CP_GLOBALSCALE;
    CGFloat Y = ( kScreenHeight - H ) / 2.0;
    NSString *str = message;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
    CGSize strSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    H += strSize.height;
    if ( strSize.height > ( 48 + 24 + 24 ) / CP_GLOBALSCALE )
    {
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        H -= 24 / CP_GLOBALSCALE;
    }
    else
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
    attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    [tipsView.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [tipsView.layer setMasksToBounds:YES];
    [tipsViewBackgroundView addSubview:tipsView];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:60 / CP_GLOBALSCALE]];
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tipsView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( tipsView.mas_top ).offset( 84 / CP_GLOBALSCALE );
        make.left.equalTo( tipsView.mas_left );
        make.right.equalTo( tipsView.mas_right );
        make.height.equalTo( @( 60 / CP_GLOBALSCALE ) );
    }];
    CPPositionDetailDescribeLabel *contentLabel = [[CPPositionDetailDescribeLabel alloc] init];
    [contentLabel setVerticalAlignment:VerticalAlignmentTop];
    [contentLabel setNumberOfLines:0];
    [contentLabel setAttributedText:attStr];
    [tipsView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( titleLabel.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
        make.left.equalTo( tipsView.mas_left ).offset( 74 / CP_GLOBALSCALE );
        make.right.equalTo( tipsView.mas_right ).offset( -64 / CP_GLOBALSCALE );
    }];
    UIView *separatorLine = [[UIView alloc] init];
    [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    [tipsView addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE) );
        make.left.equalTo( tipsView.mas_left );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        make.right.equalTo( tipsView.mas_right );
    }];
    if ( 1 < [buttonTitles count] )
    {
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE) );
            make.left.equalTo( tipsView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( tipsView.mas_right );
        }];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:buttonTitles[0] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:cancelButton];
        [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [tipsViewBackgroundView setHidden:YES];
            [tipsViewBackgroundView removeFromSuperview];
            if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickCancelButton:)] )
            {
                [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickCancelButton:cancelButton];
            }
        }];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:buttonTitles[1] forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [tipsViewBackgroundView setHidden:YES];
            [tipsViewBackgroundView removeFromSuperview];
            if ( tipsViewBackgroundView.identifier == 0 )
            {
                if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickEnsureButton:)] )
                {
                    [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickEnsureButton:sureButton];
                }
            }
            else
            {
                if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickEnsureButton:identifier:)] )
                {
                    [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickEnsureButton:sureButton identifier:tipsViewBackgroundView.identifier];
                }
            }
        }];
        UIView *verSeparatorLine = [[UIView alloc] init];
        [verSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:verSeparatorLine];
        CGFloat buttonW = ( W - 2 / CP_GLOBALSCALE ) / 2.0;
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( buttonW ) );
        }];
        [verSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( cancelButton.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.width.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( tipsView.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( cancelButton );
            make.width.equalTo( cancelButton );
        }];
    }
    else
    {
        NSString *buttonTitle = @"确定";
        if ( 1 == [buttonTitles count] )
            buttonTitles = buttonTitles[0];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:buttonTitle forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.right.equalTo( tipsView.mas_right );
        }];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [tipsViewBackgroundView setHidden:YES];
            [tipsViewBackgroundView removeFromSuperview];
            if ( tipsViewBackgroundView.identifier == 0 )
            {
                if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickCancelButton:)] )
                {
                    [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickCancelButton:sureButton];
                }
            }
            else
            {
                if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickEnsureButton:identifier:)] )
                {
                    [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickEnsureButton:sureButton identifier:tipsViewBackgroundView.identifier];
                }
            }
        }];
    }
    return tipsViewBackgroundView;
}
+ (instancetype)tipsViewWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles showMessageVC:(UIViewController *)showMessageVC message:(NSString *)message
{
    __block CPTipsView *tipsViewBackgroundView = [[CPTipsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    tipsViewBackgroundView.identifier = 0;
    [tipsViewBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
    CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    CGFloat maxW = kScreenWidth - ( 84 + 64 + 40 * 2 ) / CP_GLOBALSCALE;
    CGFloat H = ( 84 + 60 + 84 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
    CGFloat X = 40 / CP_GLOBALSCALE;
    CGFloat Y = ( kScreenHeight - H ) / 2.0;
    NSString *str = message;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
    CGSize strSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    H += strSize.height;
    if ( strSize.height > ( 48 + 24 + 24 ) / CP_GLOBALSCALE )
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
    else
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
    attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    [tipsView.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [tipsView.layer setMasksToBounds:YES];
    [tipsViewBackgroundView addSubview:tipsView];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:60 / CP_GLOBALSCALE]];
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tipsView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( tipsView.mas_top ).offset( 84 / CP_GLOBALSCALE );
        make.left.equalTo( tipsView.mas_left );
        make.right.equalTo( tipsView.mas_right );
        make.height.equalTo( @( 60 / CP_GLOBALSCALE ) );
    }];
    CPPositionDetailDescribeLabel *contentLabel = [[CPPositionDetailDescribeLabel alloc] init];
    [contentLabel setVerticalAlignment:VerticalAlignmentTop];
    [contentLabel setNumberOfLines:0];
    [contentLabel setAttributedText:attStr];
    [tipsView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( titleLabel.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
        make.left.equalTo( tipsView.mas_left ).offset( 74 / CP_GLOBALSCALE );
        make.right.equalTo( tipsView.mas_right ).offset( -64 / CP_GLOBALSCALE );
    }];
    UIView *separatorLine = [[UIView alloc] init];
    [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    [tipsView addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE) );
        make.left.equalTo( tipsView.mas_left );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        make.right.equalTo( tipsView.mas_right );
    }];
    if ( 1 < [buttonTitles count] )
    {
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE) );
            make.left.equalTo( tipsView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( tipsView.mas_right );
        }];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:buttonTitles[0] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:cancelButton];
        [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [tipsViewBackgroundView setHidden:YES];
            [tipsViewBackgroundView removeFromSuperview];
            if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickCancelButton:)] )
            {
                [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickCancelButton:cancelButton];
            }
        }];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:buttonTitles[1] forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [tipsViewBackgroundView setHidden:YES];
            [tipsViewBackgroundView removeFromSuperview];
            if ( tipsViewBackgroundView.identifier == 0 )
            {
                if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickEnsureButton:)] )
                {
                    [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickEnsureButton:sureButton];
                }
            }
            else
            {
                if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickEnsureButton:identifier:)] )
                {
                    [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickEnsureButton:sureButton identifier:tipsViewBackgroundView.identifier];
                }
            }
        }];
        UIView *verSeparatorLine = [[UIView alloc] init];
        [verSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:verSeparatorLine];
        CGFloat buttonW = ( W - 2 / CP_GLOBALSCALE ) / 2.0;
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( buttonW ) );
        }];
        [verSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( cancelButton.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.width.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( tipsView.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( cancelButton );
            make.width.equalTo( cancelButton );
        }];
    }
    else
    {
        NSString *buttonTitle = @"确定";
        if ( 1 == [buttonTitles count] )
            buttonTitles = buttonTitles[0];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:buttonTitle forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.right.equalTo( tipsView.mas_right );
        }];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [tipsViewBackgroundView setHidden:YES];
            [tipsViewBackgroundView removeFromSuperview];
            if ( tipsViewBackgroundView.identifier == 0 )
            {
                if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickCancelButton:)] )
                {
                    [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickCancelButton:sureButton];
                }
            }
            else
            {
                if ( [tipsViewBackgroundView.tipsViewDelegate respondsToSelector:@selector(tipsView:clickEnsureButton:identifier:)] )
                {
                    [tipsViewBackgroundView.tipsViewDelegate tipsView:tipsViewBackgroundView clickEnsureButton:sureButton identifier:tipsViewBackgroundView.identifier];
                }
            }
        }];
    }
    return tipsViewBackgroundView;
}
@end
