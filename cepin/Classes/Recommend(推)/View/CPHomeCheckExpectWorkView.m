//
//  CPHomeCheckExpectWorkView.m
//  cepin
//
//  Created by ceping on 16/2/29.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomeCheckExpectWorkView.h"
#import "CPCommon.h"
@interface CPHomeCheckExpectWorkView ()
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIButton *clickedToExpectButton;
@end
@implementation CPHomeCheckExpectWorkView
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.leftImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 35 / CP_GLOBALSCALE );
            make.centerY.equalTo( self.mas_centerY );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.leftImageView.mas_right ).offset( 35 / CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top );
            make.bottom.equalTo( self.mas_bottom );
        }];
        [self addSubview:self.rightImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.mas_centerY );
            make.right.equalTo( self.mas_right ).offset( -20 / CP_GLOBALSCALE );
            make.height.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.mas_right );
        }];
        [self addSubview:self.clickedToExpectButton];
        [self.clickedToExpectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
        }];
    }
    return self;
}
#pragma mark - getter method
- (UIImageView *)leftImageView
{
    if ( !_leftImageView )
    {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"resume_expection"];
    }
    return _leftImageView;
}
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
//        [_titleLabel setText:@"职位太杂？填写期望工作获取意向职位"];
        [_titleLabel setText:@"没有合适职位？编辑期望工作获取意向职位"];
        [_titleLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"6cbb56"]];
    }
    return _titleLabel;
}
-(UIImageView *)rightImageView
{
    if ( !_rightImageView )
    {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"ic_next"];
    }
    return _rightImageView;
}
- (UIButton *)clickedToExpectButton
{
    if ( !_clickedToExpectButton )
    {
        __weak typeof( self ) weakSelf = self;
        _clickedToExpectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickedToExpectButton setBackgroundColor:[UIColor clearColor]];
        [_clickedToExpectButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [weakSelf.homeCheckExpectWorkViewDelegate respondsToSelector:@selector(homeCheckExpectWorkView:isCheckExpectWork:)] )
            {
                [weakSelf.homeCheckExpectWorkViewDelegate homeCheckExpectWorkView:weakSelf isCheckExpectWork:YES];
            }
        }];
    }
    return _clickedToExpectButton;
}
@end