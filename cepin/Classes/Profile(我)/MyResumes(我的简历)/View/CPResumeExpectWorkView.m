//
//  CPResumeExpectWorkView.m
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeExpectWorkView.h"
#import "RegionDTO.h"
#import "TBTextUnit.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
#import "CPWResumeEditExpectWorkLabel.h"
@interface CPResumeExpectWorkView ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *guessLabel;
@property (nonatomic, strong) UIImageView *mustWriteImageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) CPWResumeEditExpectWorkLabel *expectWorkLabel;
@end

@implementation CPResumeExpectWorkView

#pragma mark - lift cycle
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.blackBackgroundView];
        [self.blackBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}
- (void)configWithResume:(ResumeNameModel *)resume
{
    _resumeModel = resume;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:_resumeModel.ExpectCity];
    if ( 0 < [array count] )
    {
        [self.addMoreButton setHidden:YES];
        [self.editResumeButton setHidden:NO];
    }
    else
    {
        [self.addMoreButton setHidden:NO];
        [self.editResumeButton setHidden:YES];
        return;
    }
    NSString *type = nil;
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
    NSMutableArray *arrarCode = [BaseCode baseCodeWithCodeKeys:_resumeModel.ExpectJobFunction];
    for (BaseCode *i in arrarCode) {
        if ( 0 < [attStr length] )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]}]];
        }
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.CodeName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
    }
    for (Region *i in array) {
        if ( 0 < [attStr length] )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
        }
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.RegionName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
    }
    if ( 0 < [_resumeModel.ExpectSalary length] )
    {
        if ( 0 < [attStr length] )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
        }
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:_resumeModel.ExpectSalary attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
    }
    if ( 0 < [type length] )
    {
        if ( 0 < [attStr length] )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
        }
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
    }
    if( _resumeModel.ResumeType.intValue == 2 )
    {
        if ( 0 < [attStr length] )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
        }
        NSString *availabelStr = nil;
        if( _resumeModel.AvailableType && _resumeModel.AvailableType.length > 0 )
        {
            availabelStr = [NSString stringWithFormat:@"%@到岗", _resumeModel.AvailableType];
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
        if ( _resumeModel.IsAllowDistribution && _resumeModel.IsAllowDistribution > 0 )
        {
            allowStr = _resumeModel.IsAllowDistribution.intValue ? @"，服从分配" : @"，不服从分配";
        }
        if ( allowStr )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:allowStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:18 / CP_GLOBALSCALE];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [self.expectWorkLabel setText:[attStr string]];
}
#pragma mark - getter methods
- (UIView *)blackBackgroundView
{
    if ( !_blackBackgroundView )
    {
        _blackBackgroundView = [[UIView alloc] init];
        [_blackBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.04]];
        [_blackBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_blackBackgroundView.layer setMasksToBounds:YES];
        
        [_blackBackgroundView addSubview:self.whiteBackgroundView];
        [self.whiteBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _blackBackgroundView.mas_top );
            make.left.equalTo( _blackBackgroundView.mas_left );
            make.bottom.equalTo( _blackBackgroundView.mas_bottom ).offset( -6 / CP_GLOBALSCALE );
            make.right.equalTo( _blackBackgroundView.mas_right );
        }];
    }
    return _blackBackgroundView;
}
- (UIView *)whiteBackgroundView
{
    if ( !_whiteBackgroundView )
    {
        _whiteBackgroundView = [[UIView alloc] init];
        [_whiteBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:1.0]];
        [_whiteBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_whiteBackgroundView.layer setMasksToBounds:YES];
        
        [_whiteBackgroundView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top );
            make.left.equalTo( _whiteBackgroundView.mas_left );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        
        [_whiteBackgroundView addSubview:self.expectWorkLabel];
        [self.expectWorkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.bottom.equalTo( _whiteBackgroundView.mas_bottom ).offset( 0 / CP_GLOBALSCALE );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [_whiteBackgroundView addSubview:self.addMoreButton];
        [self.addMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topView.mas_bottom );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
    }
    return _whiteBackgroundView;
}
- (UIView *)topView
{
    if ( !_topView )
    {
        _topView = [[UIView alloc] init];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [_topView addSubview:self.titleBlueLineImageView];
        [_topView addSubview:self.guessLabel];
        [_topView addSubview:self.mustWriteImageView];
        [_topView addSubview:self.editResumeButton];
        
        [self.titleBlueLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _topView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [self.guessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.titleBlueLineImageView.mas_right );
            make.centerY.equalTo( self.titleBlueLineImageView.mas_centerY );
            make.height.equalTo( @( self.guessLabel.font.pointSize ) );
        }];
        [self.mustWriteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.guessLabel.mas_right ).offset( 50 / CP_GLOBALSCALE );
            make.centerY.equalTo( self.guessLabel.mas_centerY );
            make.width.equalTo( @( 96 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [self.editResumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _topView.mas_right );
            make.top.equalTo( _topView.mas_top );
            make.width.equalTo( _topView.mas_height );
            make.height.equalTo( _topView.mas_height );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _topView.mas_bottom );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _topView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _topView;
}
- (UILabel *)guessLabel
{
    if ( !_guessLabel )
    {
        _guessLabel = [[UILabel alloc] init];
        [_guessLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [_guessLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
        [_guessLabel setText:@"期望工作"];
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
- (UIImageView *)mustWriteImageView
{
    if ( !_mustWriteImageView )
    {
        _mustWriteImageView = [[UIImageView alloc] init];
        _mustWriteImageView.image = [UIImage imageNamed:@"resume_ic_default"];
    }
    return _mustWriteImageView;
}
- (CPResumeInformationButton *)editResumeButton
{
    if ( !_editResumeButton )
    {
        _editResumeButton = [[CPResumeInformationButton alloc] init];
        [_editResumeButton setBackgroundColor:[UIColor clearColor]];
        [_editResumeButton setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
    }
    return _editResumeButton;
}
- (CPWResumeEditExpectWorkLabel *)expectWorkLabel
{
    if ( !_expectWorkLabel )
    {
        _expectWorkLabel = [[CPWResumeEditExpectWorkLabel alloc] init];
        [_expectWorkLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_expectWorkLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_expectWorkLabel setNumberOfLines:0];
    }
    return _expectWorkLabel;
}
- (CPResumeMoreButton *)addMoreButton
{
    if ( !_addMoreButton )
    {
        _addMoreButton = [CPResumeMoreButton buttonWithType:UIButtonTypeCustom];
        [_addMoreButton setBackgroundColor:[UIColor clearColor]];
        [_addMoreButton setTitle:@"添加期望工作" forState:UIControlStateNormal];
        [_addMoreButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_addMoreButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_addMoreButton setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [_addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeMoreButton *sender) {
            
        }];
    }
    return _addMoreButton;
}
@end

