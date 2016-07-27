//
//  CPCompanyDetailPositionView.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyDetailPositionView.h"
#import "CPCommon.h"
@interface CPCompanyDetailPositionView ()

@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *requireLabel;

@end

@implementation CPCompanyDetailPositionView
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
            make.top.equalTo( self.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 42 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 42 / CP_GLOBALSCALE ) );
        }];
        // 热门搜索标题
        [self addSubview:self.requireLabel];
        [self.requireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.requireLabel.font.pointSize ) );
            
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}

#pragma mark - getter methods
- (UILabel *)requireLabel
{
    if ( !_requireLabel )
    {
        _requireLabel = [[UILabel alloc] init];
        [_requireLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_requireLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_requireLabel setText:@"职位列表"];
    }
    return _requireLabel;
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
@end
