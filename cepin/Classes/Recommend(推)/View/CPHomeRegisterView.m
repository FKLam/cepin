//
//  CPHomeRegisterView.m
//  cepin
//
//  Created by ceping on 16/1/13.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomeRegisterView.h"
#import "CPCommon.h"
@interface CPHomeRegisterView ()
@property (nonatomic, strong) UIView *registerBackgroundView;
@property (nonatomic, strong) UIButton *clickedButton;
@end
@implementation CPHomeRegisterView
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [self addSubview:self.registerBackgroundView];
        [self.registerBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right );
        }];
        // 分隔线
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.mas_right );
            make.top.equalTo( _registerBackgroundView.mas_bottom );
        }];
        [self addSubview:self.clickedButton];
        [self.clickedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
        }];
    }
    return self;
}
#pragma mark - getter methods
- (UIView *)registerBackgroundView
{
    if ( !_registerBackgroundView )
    {
        _registerBackgroundView = [[UIView alloc] init];
        [_registerBackgroundView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *leftImageView = [[UIImageView alloc] init];
        leftImageView.image = [UIImage imageNamed:@"index_ic_register"];
        [_registerBackgroundView addSubview:leftImageView];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _registerBackgroundView.mas_centerY );
            make.left.equalTo( _registerBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 84 / CP_GLOBALSCALE ) );
        }];
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailLabel setText:@"注册测聘网账号"];
        [detailLabel setTextColor:[UIColor colorWithHexString:@"6cbb56"]];
        [detailLabel setFont:[UIFont systemFontOfSize:34 / CP_GLOBALSCALE]];
        [_registerBackgroundView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _registerBackgroundView.mas_top ).offset( (self.viewHeight - 30 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE) / 2.0 - detailLabel.font.pointSize );
            make.left.equalTo( leftImageView.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( detailLabel.font.pointSize ) );
        }];
        UILabel *bindNowLabel = [[UILabel alloc] init];
        [bindNowLabel setText:@"体验更畅通的求职服务，获取更多合适的工作机会。"];
        [bindNowLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [bindNowLabel setFont:[UIFont systemFontOfSize:32.0 / CP_GLOBALSCALE]];
        [_registerBackgroundView addSubview:bindNowLabel];
        [bindNowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( leftImageView.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( bindNowLabel.font.pointSize ) );
            make.bottom.equalTo( _registerBackgroundView.mas_bottom ).offset( -((self.viewHeight - 30 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE) / 2.0 - bindNowLabel.font.pointSize) );
        }];
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"ic_next"];
        [_registerBackgroundView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _registerBackgroundView.mas_centerY );
            make.right.equalTo( _registerBackgroundView.mas_right ).offset( -20 / CP_GLOBALSCALE );
            make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 84 / CP_GLOBALSCALE ) );
        }];
    }
    return _registerBackgroundView;
}
- (UIButton *)clickedButton
{
    if ( !_clickedButton )
    {
        __weak typeof( self ) weakSelf = self;
        _clickedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickedButton setBackgroundColor:[UIColor clearColor]];
        [_clickedButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [weakSelf.homeRegisterViewDelegate respondsToSelector:@selector(homeRegisterView:isCanRegister:)] )
            {
                [weakSelf.homeRegisterViewDelegate homeRegisterView:weakSelf isCanRegister:YES];
            }
        }];
    }
    return _clickedButton;
}
@end
