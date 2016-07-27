//
//  CPSearchHistoryHeaderView.m
//  cepin
//
//  Created by kun on 16/1/8.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchHistoryHeaderView.h"
#import "CPCommon.h"
@interface CPSearchHistoryHeaderView ()
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *searchHistoryLabel;
@end
@implementation CPSearchHistoryHeaderView

#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor whiteColor];
        
        // 搜索标题 高亮图标
        [self addSubview:self.titleBlueLineImageView];
        [self.titleBlueLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        
        // 热门搜索标题
        [self addSubview:self.searchHistoryLabel];
        [self.searchHistoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.searchHistoryLabel.font.pointSize ) );
        }];
        
        // 分割线
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}

#pragma mark - getters methods
- (UIImageView *)titleBlueLineImageView
{
    if( !_titleBlueLineImageView )
    {
        _titleBlueLineImageView = [[UIImageView alloc] init];
        _titleBlueLineImageView.image = [UIImage imageNamed:@"title_highlight"];
    }
    return _titleBlueLineImageView;
}
- (UILabel *)searchHistoryLabel
{
    if ( !_searchHistoryLabel )
    {
        _searchHistoryLabel = [[UILabel alloc] init];
        [_searchHistoryLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_searchHistoryLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_searchHistoryLabel setText:@"搜索历史"];
    }
    return _searchHistoryLabel;
}
@end
