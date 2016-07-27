//
//  CPReviewJobTestView.m
//  cepin
//
//  Created by ceping on 16/3/24.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPReviewJobTestView.h"
#import "CPCommon.h"
@interface CPReviewJobTestView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@end
@implementation CPReviewJobTestView
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        self.separatorLine = separatorLine;
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.titleLabel.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.tipsLabel];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.top.equalTo( self.separatorLine.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.right.equalTo( separatorLine.mas_right );
        }];
        [self addSubview:self.beginTestButton];
        [self.beginTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( self.mas_centerX );
            make.top.equalTo( self.tipsLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 330 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorEndLine = [[UIView alloc] init];
        [separatorEndLine setBackgroundColor:[UIColor colorWithHexString:@"e6e6ea"]];
        [self addSubview:separatorEndLine];
        self.secondSeparatorLine = separatorEndLine;
        [separatorEndLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.mas_bottom );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 6 / CP_GLOBALSCALE ) );
        }];
    }
    return self;
}
#pragma mark - getter methods
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setText:@"职业测评"];
    }
    return _titleLabel;
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
@end
