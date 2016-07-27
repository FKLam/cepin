//
//  CPCompanyDetailIntroduceView.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyDetailIntroduceView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCompanyDetailReformer.h"
#import "CPCommon.h"
@interface CPCompanyDetailIntroduceView ()
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *requireLabel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *introduceLabel;
@property (nonatomic, strong) NSDictionary *companyDict;
@end
@implementation CPCompanyDetailIntroduceView
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
        [self addSubview:self.lookMoreButton];
        [self.lookMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
        [self addSubview:self.introduceLabel];
        [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.requireLabel.mas_bottom ).offset( 55 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.lessThanOrEqualTo( self.lookMoreButton.mas_top );
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
- (void)configWithDict:(NSDictionary *)companyDict
{
    _companyDict = companyDict;
    NSString *introduction = @"";
    if ( ![[companyDict valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
        introduction = [companyDict valueForKey:@"Description"];
    if(nil != introduction && ![@"" isEqualToString:introduction]){
        introduction = [introduction stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        introduction = [introduction stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
        introduction = [introduction stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        introduction = [introduction stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:introduction];
    UIFont *font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attString addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"707070"]} range:NSMakeRange(0, introduction.length)];
    [self.introduceLabel setAttributedText:attString];
    CGFloat minHeight = ( 36 * 6 + 20 * 5 ) / CP_GLOBALSCALE;
    CGFloat tempHeight= [CPCompanyDetailReformer companyIntroduceDescriptHeightWithCampanyData:companyDict];
    if ( tempHeight > minHeight )
    {
        [self.lookMoreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
        [self.lookMoreButton setHidden:NO];
    }
    else
    {
        [self.lookMoreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 0 ) );
        }];
        [self.lookMoreButton setHidden:YES];
    }
}
#pragma mark - getter methods
- (UILabel *)requireLabel
{
    if ( !_requireLabel )
    {
        _requireLabel = [[UILabel alloc] init];
        [_requireLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_requireLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_requireLabel setText:@"企业介绍"];
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
- (CPPositionDetailDescribeLabel *)introduceLabel
{
    if ( !_introduceLabel )
    {
        _introduceLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_introduceLabel setVerticalAlignment:VerticalAlignmentTop];
        [_introduceLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_introduceLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_introduceLabel setNumberOfLines:0];
        [_introduceLabel sizeToFit];
    }
    return _introduceLabel;
}
- (CPWCompanyDetailButton *)lookMoreButton
{
    if ( !_lookMoreButton )
    {
        _lookMoreButton = [[CPWCompanyDetailButton alloc] initWithFrame:CGRectZero];
        [_lookMoreButton setTitle:@"点击展开" forState:UIControlStateNormal];
        [_lookMoreButton setTitle:@"点击收起" forState:UIControlStateSelected];
        [_lookMoreButton setImage:[UIImage imageNamed:@"ic_down_gray"] forState:UIControlStateNormal];
        [_lookMoreButton setImage:[UIImage imageNamed:@"ic_up_gray"] forState:UIControlStateSelected];
        [_lookMoreButton.titleLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_lookMoreButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
    }
    return _lookMoreButton;
}
@end
