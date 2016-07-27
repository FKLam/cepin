//
//  CPSearchHeaderView.m
//  cepin
//
//  Created by ceping on 16/1/8.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchHeaderView.h"
#import "JobSearchResultVC.h"
#import "CPCommon.h"
@interface CPSearchHeaderView ()

@property (nonatomic, strong) UIView *hotSearchBackground;
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *hotSearchLabel;
@property(nonatomic,strong)NSArray *hotKeyArray;

@end

@implementation CPSearchHeaderView

#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        // 热门搜索背景
        [self addSubview:self.hotSearchBackground];
        
        // 搜索标题 高亮图标
        [self.hotSearchBackground addSubview:self.titleBlueLineImageView];
        [self.titleBlueLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        
        // 热门搜索标题
        [self.hotSearchBackground addSubview:self.hotSearchLabel];
        [self.hotSearchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.hotSearchLabel.font.pointSize ) );
        }];
        
        
    }
    return self;
}

- (void)configHotButtonWithTitles:(NSArray *)titles target:(id)target selector:(SEL)selector
{
    if ( !titles || 0 == [titles count] )
        return;
    self.hotKeyArray = titles;
    CGFloat buttonX = 40.0 / CP_GLOBALSCALE;
    CGFloat buttonY = self.hotSearchLabel.font.pointSize + 60 / CP_GLOBALSCALE * 2.0;
    CGFloat buttonH = 120 / CP_GLOBALSCALE;
    CGFloat maxMargin = kScreenWidth - 40 / CP_GLOBALSCALE;
    NSInteger index = 0;
    NSInteger i = 0;
    for ( NSString *title in titles )
    {
        if ( 0 == [title length] )
            continue;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:42.0 / CP_GLOBALSCALE]];
        [button setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [button.layer setCornerRadius:6 / CP_GLOBALSCALE];
        [button.layer setMasksToBounds:YES];
        [button setTag:i];
        i++;
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [self.hotSearchBackground addSubview:button];
        
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, buttonH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :button.titleLabel.font } context:nil].size;
        
        CGFloat buttonW = 50 / CP_GLOBALSCALE * 2.0 + titleSize.width;
        
        if ( buttonX + buttonW > maxMargin )
        {
            buttonX = 40 / CP_GLOBALSCALE;
            buttonY += buttonH + 32 / CP_GLOBALSCALE;
            
            index++;
        }
        
        if ( index > 1 )
            break;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self.hotSearchBackground addSubview:button];
        
        buttonX += buttonW + 32 / CP_GLOBALSCALE;
        
    }
}
#pragma mark - getters
- (UIView *)hotSearchBackground
{
    if ( !_hotSearchBackground )
    {
        _hotSearchBackground = [[UIView alloc] initWithFrame:self.bounds];
        [_hotSearchBackground setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    }
    return _hotSearchBackground;
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
- (UILabel *)hotSearchLabel
{
    if ( !_hotSearchLabel )
    {
        _hotSearchLabel = [[UILabel alloc] init];
        [_hotSearchLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_hotSearchLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_hotSearchLabel setText:@"热门搜索"];
    }
    return _hotSearchLabel;
}
@end
