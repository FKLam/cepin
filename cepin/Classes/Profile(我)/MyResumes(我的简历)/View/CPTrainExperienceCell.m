//
//  CPTrainExperienceCell.m
//  cepin
//
//  Created by ceping on 16/1/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPTrainExperienceCell.h"
#import "NSDate-Utilities.h"
#import "TBTextUnit.h"
#import "CPCommon.h"
@interface CPTrainExperienceCell ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *workDetail;
@property (nonatomic, strong) TrainingDataModel *train;
@end
@implementation CPTrainExperienceCell
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
+ (instancetype)trainCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"train";
    CPTrainExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPTrainExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
- (void)configCellWithtrain:(TrainingDataModel *)train
{
    if ( !train )
        return;
    _train = train;
    NSString *startime =  [NSDate cepinYMDFromString:_train.StartDate];
    NSString *endTime = [NSDate cepinYMDFromString:_train.EndDate];
    if (!endTime || [endTime isEqualToString:@""]) {
        endTime = @"至今";
    }
    NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
    [self.timeLabel setText:time];
    [self.companyLabel setText:[NSString stringWithFormat:@"%@  |  %@", _train.Name, _train.Organization]];
    if ( _train.Content && 0 < [_train.Content length] )
    {
        [self.workDetail setText:_train.Content];
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n+" options:0 error:nil];
        if(_train.Content){
            self.workDetail.text = [regularExpression stringByReplacingMatchesInString:self.workDetail.text options:0 range:NSMakeRange(0, _train.Content.length) withTemplate:@" "];
        }
    }
    else
    {
        [self.workDetail setText:nil];
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
        [self.workDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
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
- (UILabel *)workDetail
{
    if ( !_workDetail )
    {
        _workDetail = [[UILabel alloc] init];
        [_workDetail setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_workDetail setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_workDetail setNumberOfLines:2];
        [_workDetail setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    return _workDetail;
}
@end
