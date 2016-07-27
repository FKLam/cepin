//
//  CPJobTestView.m
//  cepin
//
//  Created by ceping on 16/3/24.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPJobTestView.h"
#import "CPCommon.h"
@interface CPJobTestView ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *guessLabel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *tipsLabel;
@end;
@implementation CPJobTestView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.blackBackgroundView];
        [self.blackBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}
#pragma mark - getter methods
- (UIView *)blackBackgroundView
{
    if ( !_blackBackgroundView )
    {
        _blackBackgroundView = [[UIView alloc] init];
        [_blackBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.04]];
        [_blackBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_blackBackgroundView.layer setMasksToBounds:YES];
        
        [_blackBackgroundView addSubview:self.whiteBackgroundView];
        [self.whiteBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _blackBackgroundView.mas_top );
            make.left.equalTo( _blackBackgroundView.mas_left );
            make.bottom.equalTo( _blackBackgroundView.mas_bottom ).offset( -6 / CP_GLOBALSCALE );
            make.right.equalTo( _blackBackgroundView.mas_right );
        }];
    }
    return _blackBackgroundView;
}
- (UIView *)whiteBackgroundView
{
    if ( !_whiteBackgroundView )
    {
        _whiteBackgroundView = [[UIView alloc] init];
        [_whiteBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:1.0]];
        [_whiteBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_whiteBackgroundView.layer setMasksToBounds:YES];
        [_whiteBackgroundView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top );
            make.left.equalTo( _whiteBackgroundView.mas_left );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        [_whiteBackgroundView addSubview:self.tipsLabel];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( self.topView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.right.lessThanOrEqualTo( _whiteBackgroundView.mas_right ).offset( -30 / CP_GLOBALSCALE );
        }];
        [_whiteBackgroundView addSubview:self.beginTestButton];
        [self.beginTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _whiteBackgroundView.mas_centerX );
            make.top.equalTo( self.tipsLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 330 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
    }
    return _whiteBackgroundView;
}
- (UIView *)topView
{
    if ( !_topView )
    {
        _topView = [[UIView alloc] init];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_topView addSubview:self.titleBlueLineImageView];
        [_topView addSubview:self.guessLabel];
        [self.titleBlueLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _topView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [self.guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.guessLabel.font.pointSize ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _topView.mas_bottom );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _topView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _topView;
}
- (UILabel *)guessLabel
{
    if ( !_guessLabel )
    {
        _guessLabel = [[UILabel alloc] init];
        [_guessLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_guessLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_guessLabel setText:@"职业测评"];
    }
    return _guessLabel;
}
- (UIImageView *)titleBlueLineImageView
{
    if( !_titleBlueLineImageView )
    {
        _titleBlueLineImageView = [[UIImageView alloc] init];
        _titleBlueLineImageView.image = [UIImage imageNamed:@"title_highlight"];
    }
    return _titleBlueLineImageView;
}
- (UIButton *)beginTestButton
{
    if ( !_beginTestButton )
    {
        _beginTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beginTestButton setTitle:@"开始测评" forState:UIControlStateNormal];
        [_beginTestButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_beginTestButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_beginTestButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_beginTestButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_beginTestButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_beginTestButton.layer setMasksToBounds:YES];
    }
    return _beginTestButton;
}
- (UILabel *)tipsLabel
{
    if ( !_tipsLabel )
    {
        _tipsLabel = [[UILabel alloc] init];
        [_tipsLabel setText:@"亲,赶紧去做一份测评吧,给自己3D简历加分!"];
        [_tipsLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_tipsLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_tipsLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _tipsLabel;
}
@end
