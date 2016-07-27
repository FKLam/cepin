//
//  CPPraciticeAwardCell.m
//  cepin
//
//  Created by ceping on 16/1/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPraciticeAwardCell.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@interface CPPraciticeAwardCell ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) AwardsListDataModel *award;
@end
@implementation CPPraciticeAwardCell
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
+ (instancetype)awardCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"award";
    CPPraciticeAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPPraciticeAwardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
- (void)configCellWithAward:(AwardsListDataModel *)award
{
    if ( !award )
        return;
    _award = award;
    NSString *startime =  [NSDate cepinYMDFromString:_award.StartDate];
    NSString *endTime = [NSDate cepinYMDFromString:_award.EndDate];
    if (!endTime || [endTime isEqualToString:@""]) {
        endTime = @"至今";
    }
    //    NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
    NSString *time = [NSString stringWithFormat:@"%@",startime];
    [self.timeLabel setText:time];
    [self.positionLabel setText:[NSString stringWithFormat:@"%@  |  %@", _award.Name, _award.Level]];
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
            make.top.equalTo( self.timeLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.positionLabel.font.pointSize ) );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.top.equalTo( self.companyLabel.mas_bottom );
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
@end

