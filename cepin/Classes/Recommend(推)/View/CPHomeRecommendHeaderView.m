//
//  CPHomeRecommendHeaderView.m
//  cepin
//
//  Created by ceping on 16/1/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomeRecommendHeaderView.h"
#import "CPCommon.h"
@interface CPHomeRecommendHeaderView ()

@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *guessLabel;

@end

@implementation CPHomeRecommendHeaderView

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
            make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        // 热门搜索标题
        [self addSubview:self.guessLabel];
        [self.guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.guessLabel.font.pointSize ) );
        }];
        // 换一批按钮
        [self addSubview:self.changeButton];
        [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.guessLabel.mas_centerY );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
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
        [_guessLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_guessLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_guessLabel setText:@"企业推荐"];
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
- (CPHomeRecommendButton *)changeButton
{
    if ( !_changeButton )
    {
        _changeButton = [CPHomeRecommendButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setTitle:@"换一换" forState:UIControlStateNormal];
        [_changeButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_changeButton.titleLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE ]];
        [_changeButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_changeButton setImage:[UIImage imageNamed:@"ic_shuffle"] forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(clickedChangeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
}
- (void)clickedChangeButton
{
    if ( [self.recommendHeaderViewDelegate respondsToSelector:@selector(recommendView:changeImageWithIndex:)] )
    {
        [self.recommendHeaderViewDelegate recommendView:self changeImageWithIndex:self.changeButton.tag];
    }
}
@end
