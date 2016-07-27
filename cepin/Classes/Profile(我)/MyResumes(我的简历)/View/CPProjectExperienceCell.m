//
//  CPProjectExperienceCell.m
//  cepin
//
//  Created by ceping on 16/1/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPProjectExperienceCell.h"
#import "NSDate-Utilities.h"
#import "CPResumeProjectReformer.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface CPProjectExperienceCell ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *positionLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *workDetail;
@property (nonatomic, strong) UIButton *linkButton;
@property (nonatomic, strong) ProjectListDataModel *projectExperience;
@property (nonatomic, strong) UIImageView *linkImageView;
@property (nonatomic, strong) UILabel *linkLabel;
@end
@implementation CPProjectExperienceCell
#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        
        [self.contentView addSubview:self.blackBackgroundView];
        [self.blackBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return self;
}
+ (instancetype)projectExperienceCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"projectExperience";
    CPProjectExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPProjectExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
- (void)configCellWithProjectExperience:(ProjectListDataModel *)projectExperience
{
    if ( !projectExperience )
        return;
    _projectExperience = projectExperience;
    NSString *startime =  [NSDate cepinYMDFromString:_projectExperience.StartDate];
    NSString *endTime = [NSDate cepinYMDFromString:_projectExperience.EndDate];
    if (!endTime || [endTime isEqualToString:@""]) {
        endTime = @"至今";
    }
    NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
    [self.timeLabel setText:time];
    [self.companyLabel setText:_projectExperience.Name];
    [self.positionLabel setText:projectExperience.Duty];
    NSRegularExpression *dutyRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n+" options:0 error:nil];
    NSString *dutyTempStr = [dutyRegularExpression stringByReplacingMatchesInString:self.positionLabel.text options:0 range:NSMakeRange(0, projectExperience.Duty.length) withTemplate:@" "];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:dutyTempStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    if ( 21 < [CPResumeProjectReformer dutyHeightWithProject:_projectExperience] )
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    else
        [paragraphStyle setLineSpacing:0.0];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]} range:NSMakeRange(0, [attStr length])];
    [self.positionLabel setAttributedText:attStr];
    if ( _projectExperience.Content && 0 < [_projectExperience.Content length] )
    {
        NSString *projectDetailString = [NSString stringWithFormat:@"项目描述 : %@", _projectExperience.Content];
        [self.workDetail setText:projectDetailString];
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n+" options:0 error:nil];
        if(_projectExperience.Content)
        {
            NSString *tempStr = [regularExpression stringByReplacingMatchesInString:self.workDetail.text options:0 range:NSMakeRange(0, projectDetailString.length) withTemplate:@" "];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
            if ( 21 < [CPResumeProjectReformer projectDescribeWithProject:_projectExperience] )
                [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
            else
                [paragraphStyle setLineSpacing:0.0];
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, [attStr length])];
            [self.workDetail setAttributedText:attStr];
        }
    }
    else
    {
        [self.workDetail setText:nil];
    }
    [self.positionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
//        make.height.equalTo( @( [CPResumeProjectReformer dutyHeightWithProject:_projectExperience] ) );
        make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.top.equalTo( self.companyLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
    }];
    if ( _projectExperience.ProjectLink && 0 < [_projectExperience.ProjectLink length] )
    {
        [self.linkImageView setHidden:NO];
        [self.linkLabel setHidden:NO];
        [self.linkLabel setText:_projectExperience.ProjectLink];
    }
    else
    {
        [self.linkImageView setHidden:YES];
        [self.linkLabel setHidden:YES];
        [self.linkLabel setText:@""];
    }
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
        [_whiteBackgroundView addSubview:self.timeLabel];
        [_whiteBackgroundView addSubview:self.editButton];
        [_whiteBackgroundView addSubview:self.companyLabel];
        [_whiteBackgroundView addSubview:self.positionLabel];
        [_whiteBackgroundView addSubview:self.workDetail];
        [_whiteBackgroundView addSubview:self.linkImageView];
        [_whiteBackgroundView addSubview:self.linkLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.editButton.mas_left ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.timeLabel.font.pointSize ) );
        }];
        [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo( self.timeLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.timeLabel.mas_left );
            make.top.equalTo( self.timeLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
        }];
        [self.workDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( self.positionLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.linkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( self.workDetail.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [self.linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.linkImageView.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.centerY.equalTo( self.linkImageView.mas_centerY );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return _whiteBackgroundView;
}
- (CPPositionDetailDescribeLabel *)positionLabel
{
    if ( !_positionLabel )
    {
        _positionLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_positionLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_positionLabel setNumberOfLines:2];
        [_positionLabel setVerticalAlignment:VerticalAlignmentTop];
    }
    return _positionLabel;
}
- (UILabel *)companyLabel
{
    if ( !_companyLabel )
    {
        _companyLabel = [[UILabel alloc] init];
        [_companyLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_companyLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
    }
    return _companyLabel;
}
- (UILabel *)timeLabel
{
    if ( !_timeLabel )
    {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}
- (UIButton *)editButton
{
    if ( !_editButton )
    {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
    }
    return _editButton;
}
- (CPPositionDetailDescribeLabel *)workDetail
{
    if ( !_workDetail )
    {
        _workDetail = [[CPPositionDetailDescribeLabel alloc] init];
        [_workDetail setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_workDetail setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_workDetail setVerticalAlignment:VerticalAlignmentTop];
        [_workDetail setNumberOfLines:2];
    }
    return _workDetail;
}
- (UILabel *)linkLabel
{
    if ( !_linkLabel )
    {
        _linkLabel = [[UILabel alloc] init];
        [_linkLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_linkLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    return _linkLabel;
}
- (UIImageView *)linkImageView
{
    if ( !_linkImageView )
    {
        _linkImageView = [[UIImageView alloc] init];
        [_linkImageView setImage:[UIImage imageNamed:@"list_ic_link"]];
    }
    return _linkImageView;
}
@end
