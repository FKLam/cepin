//
//  CPEducationExperienceCell.m
//  cepin
//
//  Created by ceping on 16/1/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPEducationExperienceCell.h"
#import "NSDate-Utilities.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface CPEducationExperienceCell ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) EducationListDateModel *educationExperience;
@property (nonatomic, strong) UILabel *scoreRankLabel;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *mainClassLabel;
@end

@implementation CPEducationExperienceCell

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

+ (instancetype)educationExperienceCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"workExperienceCell";
    CPEducationExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPEducationExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
- (void)configCellWithEducationExperience:(EducationListDateModel *)educationExperience
{
    if ( !educationExperience )
        return;
    _educationExperience = educationExperience;
    NSString *startime =  [NSDate cepinYMDFromString:_educationExperience.StartDate];
    NSString *endTime = [NSDate cepinYMDFromString:_educationExperience.EndDate];
    if (!endTime || [endTime isEqualToString:@""]) {
        endTime = @"至今";
    }
    NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
    [self.timeLabel setText:time];
    [self.companyLabel setText:_educationExperience.School];
    NSMutableString *positionString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@  |  %@", _educationExperience.Major, _educationExperience.Degree]];
    if ( _educationExperience.XueWei && 0 < [_educationExperience.XueWei length] )
    {
        [positionString appendFormat:@"  |  %@学位", _educationExperience.XueWei];
    }
    [self.positionLabel setText:positionString];
    NSMutableString *scoreString = [NSMutableString string];
    if ( self.educationExperience.ScoreRanking )
    {
        if([@"5" isEqualToString:self.educationExperience.ScoreRanking])
        {
            [scoreString appendFormat:@"%@", @"年级前5%"];
        }
        else if([@"10" isEqualToString:self.educationExperience.ScoreRanking])
        {
            [scoreString appendFormat:@"%@", @"年级前10%"];
        }
        else if([@"20" isEqualToString:self.educationExperience.ScoreRanking])
        {
            [scoreString appendFormat:@"%@", @"年级前20%"];
        }
        else if([@"50" isEqualToString:self.educationExperience.ScoreRanking])
        {
            [scoreString appendFormat:@"%@", @"年级前50%"];
        }
        else if([@"0" isEqualToString:self.educationExperience.ScoreRanking])
        {
            [scoreString appendFormat:@"%@", @"其他"];
        }
    }
    NSString *preStr = nil;
    if ( self.educationExperience.Description )
    {
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", preStr, self.educationExperience.Description]];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
//        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
//        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
//        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, [attStr length])];
//        [self.mainClassLabel setAttributedText:attStr];
        preStr = self.educationExperience.Description;
    }
    if ( 0 < [scoreString length] && preStr )
    {
        [self.scoreRankLabel setText:[NSString stringWithFormat:@"%@  |  %@", scoreString, preStr]];
    }
}
//if([@"5" isEqualToString:self.viewModel.eduData.ScoreRanking])
//{
//    cell.inputTextField.text = @"年级前5%";
//}
//else if([@"10" isEqualToString:self.viewModel.eduData.ScoreRanking])
//{
//    cell.inputTextField.text = @"年级前10%";
//}
//else if([@"20" isEqualToString:self.viewModel.eduData.ScoreRanking])
//{
//    cell.inputTextField.text = @"年级前20%";
//}
//else if([@"50" isEqualToString:self.viewModel.eduData.ScoreRanking])
//{
//    cell.inputTextField.text = @"年级前50%";
//}
//else if([@"0" isEqualToString:self.viewModel.eduData.ScoreRanking])
//{
//    cell.inputTextField.text = @"其他";
//}
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
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _whiteBackgroundView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.editButton.mas_left ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo( self.timeLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.timeLabel.mas_left );
            make.top.equalTo( self.timeLabel.mas_bottom ).offset( 45 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
        }];
        [_whiteBackgroundView addSubview:self.scoreRankLabel];
        [_whiteBackgroundView addSubview:self.mainClassLabel];
        [self.scoreRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.timeLabel.mas_left );
            make.top.equalTo( self.positionLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];;
        [self.mainClassLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.timeLabel.mas_left );
            make.top.equalTo( self.scoreRankLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return _whiteBackgroundView;
}
- (UILabel *)positionLabel
{
    if ( !_positionLabel )
    {
        _positionLabel = [[UILabel alloc] init];
        [_positionLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
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
- (UILabel *)scoreRankLabel
{
    if ( !_scoreRankLabel )
    {
        _scoreRankLabel = [[UILabel alloc] init];
        [_scoreRankLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_scoreRankLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_scoreRankLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _scoreRankLabel;
}
- (CPPositionDetailDescribeLabel *)mainClassLabel
{
    if ( !_mainClassLabel )
    {
        _mainClassLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_mainClassLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_mainClassLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_mainClassLabel setNumberOfLines:2];
    }
    return _mainClassLabel;
}
@end
