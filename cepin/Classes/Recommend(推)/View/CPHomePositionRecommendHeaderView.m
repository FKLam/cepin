//
//  CPHomePositionRecommendHeaderView.m
//  cepin
//
//  Created by ceping on 16/3/8.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomePositionRecommendHeaderView.h"
@interface CPHomePositionRecommendHeaderView ()
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *guessLabel;
@end
@implementation CPHomePositionRecommendHeaderView
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        // 搜索标题 高亮图标
        [self addSubview:self.titleBlueLineImageView];
        [self.titleBlueLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 40 / 3.0 );
            make.left.equalTo( self.mas_left ).offset( 40 / 3.0 );
            make.width.equalTo( @( 48 / 3.0 ) );
            make.height.equalTo( @( 48 / 3.0 ) );
        }];
        // 热门搜索标题
        [self addSubview:self.guessLabel];
        [self.guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.guessLabel.font.pointSize ) );
        }];
        // 更多按钮
        [self addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.guessLabel.mas_centerY );
            make.height.equalTo( @( 48 / 3.0 ) );
            make.right.equalTo( self.mas_right ).offset( -40 / 3.0 );
        }];
    }
    return self;
}
#pragma mark - getter methods
- (UILabel *)guessLabel
{
    if ( !_guessLabel )
    {
        _guessLabel = [[UILabel alloc] init];
        [_guessLabel setFont:[UIFont systemFontOfSize:42 / 3.0 ]];
        [_guessLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_guessLabel setText:@"职位推荐"];
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
- (CPHomeRecommendButton *)moreButton
{
    if ( !_moreButton )
    {
        _moreButton = [CPHomeRecommendButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_moreButton.titleLabel setFont:[UIFont systemFontOfSize:36 / 3.0 ]];
        [_moreButton setImage:[UIImage imageNamed:@"ic_next_blue"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(clickedMoreButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
- (void)clickedMoreButton
{
    if ( [self.homePositionRecommendHeaderViewDelegate respondsToSelector:@selector(homePositionRecommendHeaderView:clickedMoreButton:)] )
    {
        [self.homePositionRecommendHeaderViewDelegate homePositionRecommendHeaderView:self clickedMoreButton:self.moreButton];
    }
}
@end
