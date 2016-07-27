//
//  CPResumeReviewExpectWorkView.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeReviewExpectWorkView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "RegionDTO.h"
#import "TBTextUnit.h"
#import "CPCommon.h"
@interface CPResumeReviewExpectWorkView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *separatorEndLine;
@end
@implementation CPResumeReviewExpectWorkView
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
        self.separatorEndLine = separatorEndLine;
        [separatorEndLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.mas_bottom );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 6 / CP_GLOBALSCALE ) );
        }];
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( separatorEndLine.mas_top ).offset( -20 / CP_GLOBALSCALE );
        }];
    }
    return self;
}
- (void)configWithResume:(ResumeNameModel *)resumeModel
{
    _resumeModel = resumeModel;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:_resumeModel.ExpectCity];
    NSString *type = nil;
    if ( !resumeModel.ExpectCity || 0 == [resumeModel.ExpectCity length])
    {
        [self.titleLabel setHidden:YES];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 0 ) );
        }];
        [self.separatorLine setHidden:YES];
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.titleLabel.mas_bottom );
            make.height.equalTo( @( 0 ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.separatorEndLine setHidden:YES];
        [self.separatorEndLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.mas_bottom );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 0 ) );
        }];
        return;
    }
    if ([_resumeModel.ExpectEmployType isEqualToString:@"1"]) {
        type = @"全职";
    }else if([_resumeModel.ExpectEmployType isEqualToString:@"4"])
    {
        type = @"实习";
    }else
    {
        type = @"";
    }
    NSString *separatorLine = @"  |  ";
    NSMutableArray *arrarCode = [BaseCode baseCodeWithCodeKeys:resumeModel.ExpectJobFunction];
    for (BaseCode *i in arrarCode) {
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.CodeName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        BaseCode *last = [arrarCode lastObject];
        if ( ![i.CodeName isEqualToString:last.CodeName] )
        {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
        }
    }
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]}]];
    for (Region *i in array)
    {
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.RegionName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        if ( ![i isEqual:[array lastObject]] )
        {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"/" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
        }
    }
    if ( 0 < [type length] )
    {
        if ( 0 < [attStr length] )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
        }
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
    }
    if ( 0 < [resumeModel.ExpectSalary length] )
    {
        if ( 0 < [attStr length] )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
        }
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:resumeModel.ExpectSalary attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
    }
    if( resumeModel.ResumeType.intValue == 2 )
    {
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]}]];
    }
    if( resumeModel.ResumeType.intValue == 2 )
    {
        NSString *availabelStr = nil;
        if( resumeModel.AvailableType && resumeModel.AvailableType.length > 0 )
        {
            availabelStr = [NSString stringWithFormat:@"%@到岗", resumeModel.AvailableType];
        }
        else
        {
            availabelStr = [NSString stringWithFormat:@"%@到岗时间", @"不限"];
        }
        if ( availabelStr )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:availabelStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        // 1不服从，0服从
        NSString *allowStr = nil;
        if ( resumeModel.IsAllowDistribution && resumeModel.IsAllowDistribution > 0 )
        {
            allowStr = resumeModel.IsAllowDistribution.intValue ? @"，服从分配" : @"，不服从分配";
        }
        if ( allowStr )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:allowStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:40 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [self.contentLabel setAttributedText:attStr];
}
#pragma mark - getter methods
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setText:@"期望工作"];
    }
    return _titleLabel;
}
- (CPPositionDetailDescribeLabel *)contentLabel
{
    if ( !_contentLabel )
    {
        _contentLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_contentLabel setVerticalAlignment:VerticalAlignmentTop];
        [_contentLabel setNumberOfLines:0];
    }
    return _contentLabel;
}
@end
