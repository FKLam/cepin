//
//  CPDeliveryNoResumeTipsView.m
//  cepin
//
//  Created by ceping on 16/3/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPDeliveryNoResumeTipsView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@implementation CPDeliveryNoResumeTipsView
+ (instancetype)tipsViewWithButtonTitles:(NSArray *)buttonTitles showMessageVC:(UIViewController *)showMessageVC message:(NSString *)message
{
    __block CPDeliveryNoResumeTipsView *tipsViewBackgroundView = [[CPDeliveryNoResumeTipsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [tipsViewBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
    CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    CGFloat maxW = kScreenWidth - ( 84 + 64 + 40 * 2 ) / CP_GLOBALSCALE;
    CGFloat H = ( 84 + 2 + 144 + 84 ) / CP_GLOBALSCALE;
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
    CPPositionDetailDescribeLabel *contentLabel = [[CPPositionDetailDescribeLabel alloc] init];
    [contentLabel setVerticalAlignment:VerticalAlignmentTop];
    [contentLabel setNumberOfLines:0];
    [contentLabel setAttributedText:attStr];
    [tipsView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( tipsView.mas_top ).offset( 84 / CP_GLOBALSCALE );
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
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:cancelButton];
        [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [tipsViewBackgroundView setHidden:YES];
            [tipsViewBackgroundView removeFromSuperview];
            if ( [tipsViewBackgroundView.deliveryNoResumeTipsViewDelegate respondsToSelector:@selector(deliveryNoResumeTipsView:clickedCancleButton:)] )
            {
                [tipsViewBackgroundView.deliveryNoResumeTipsViewDelegate deliveryNoResumeTipsView:tipsViewBackgroundView clickedCancleButton:cancelButton];
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
            if ( [tipsViewBackgroundView.deliveryNoResumeTipsViewDelegate respondsToSelector:@selector(deliveryNoResumeTipsView:clickedSureButton:)] )
            {
                [tipsViewBackgroundView.deliveryNoResumeTipsViewDelegate deliveryNoResumeTipsView:tipsViewBackgroundView clickedSureButton:sureButton];
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
        }];
    }
    return tipsViewBackgroundView;
}
@end
