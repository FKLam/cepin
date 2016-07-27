//
//  CPCompanyDetailDescribeView.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPositionDetailDescribeView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface CPPositionDetailDescribeView ()

@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *requireLabel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *positionDescribeLabel;
@property (nonatomic, strong) NSDictionary *positionDetail;
@end

@implementation CPPositionDetailDescribeView

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
        [self addSubview:self.positionDescribeLabel];
        [self.positionDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.requireLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom ).offset( -60 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -30 / CP_GLOBALSCALE );
        }];
    }
    return self;
}
- (void)configWithPosition:(NSDictionary *)position
{
    _positionDetail = position;
    NSString *str = [_positionDetail valueForKey:@"HtmlJobDescription"];
    if(nil != str && ![@"" isEqualToString:str]){
        str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    [_positionDescribeLabel setAttributedText:attStr];
}
#pragma mark - getter methods
- (UILabel *)requireLabel
{
    if ( !_requireLabel )
    {
        _requireLabel = [[UILabel alloc] init];
        [_requireLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_requireLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_requireLabel setText:@"职位描述"];
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
- (CPPositionDetailDescribeLabel *)positionDescribeLabel
{
    if ( !_positionDescribeLabel )
    {
        _positionDescribeLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_positionDescribeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_positionDescribeLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_positionDescribeLabel setNumberOfLines:0];
        [_positionDescribeLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _positionDescribeLabel;
}
@end
