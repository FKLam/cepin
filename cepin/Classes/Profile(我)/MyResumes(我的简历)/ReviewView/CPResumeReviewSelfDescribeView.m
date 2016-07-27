//
//  CPResumeReviewSelfDescribeView.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeReviewSelfDescribeView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface CPResumeReviewSelfDescribeView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *describeLabel;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@end
@implementation CPResumeReviewSelfDescribeView
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
        [self addSubview:self.describeLabel];
        [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( separatorLine.mas_left );
            make.bottom.equalTo( separatorEndLine.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return self;
}
- (void)configWithResume:(ResumeNameModel *)resumeModel
{
    _resumeModel = resumeModel;
    NSString *describeStr = _resumeModel.UserRemark;
    if ( !describeStr || 0 == [describeStr length] )
    {
        [self.titleLabel setHidden:YES];
        [self.separatorLine setHidden:YES];
        [self.secondSeparatorLine setHidden:YES];
        return;
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:describeStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]} range:NSMakeRange(0, [attStr length])];
    [self.describeLabel setAttributedText:attStr];
}
#pragma mark - getter methods
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setText:@"自我描述"];
    }
    return _titleLabel;
}
- (CPPositionDetailDescribeLabel *)describeLabel
{
    if ( !_describeLabel )
    {
        _describeLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_describeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_describeLabel setNumberOfLines:0];
        [_describeLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _describeLabel;
}
@end
