//
//  CPProfilePositionRecommendCell.m
//  cepin
//
//  Created by ceping on 16/3/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPProfilePositionRecommendCell.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@interface CPProfilePositionRecommendCell ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *salaryLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *matchLabel;
@property (nonatomic, strong) CPJobRecommendModel *recommendModel;
@end
@implementation CPProfilePositionRecommendCell
#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        
        [self.contentView addSubview:self.blackBackgroundView];
        [self.blackBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return self;
}
+ (instancetype)positionRecommendCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"CPProfilePositionRecommendCell";
    CPProfilePositionRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPProfilePositionRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configCellWithRecommendJob:(CPJobRecommendModel *)recommendJobModel
{
    if ( !recommendJobModel )
        return;
    _recommendModel = recommendJobModel;
    [self.positionLabel setText:_recommendModel.PositionName];
    [self.salaryLabel setText:_recommendModel.Salary];
    [self.timeLabel setText:[NSDate cepinJobYearMonthDayFromString:_recommendModel.CreateDate]];
    if ( !_recommendModel.Shortname || nil==_recommendModel.Shortname )
    {
        [self.companyLabel setText:_recommendModel.CompanyName];
    }
    else
    {
        [self.companyLabel setText:_recommendModel.Shortname];
    }
    if( _recommendModel.MatchRate.intValue >= 70 )
    {
        [_matchLabel setTextColor:[UIColor colorWithHexString:@"6ebb58"]];
    }
    else
    {
        [_matchLabel setTextColor:[UIColor colorWithHexString:@"ff5252"]];
    }
    [self.matchLabel setText:[NSString stringWithFormat:@"匹配度:%@%%", _recommendModel.MatchRate]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat positionH = self.positionLabel.font.pointSize;
    CGFloat positionX = 40 / CP_GLOBALSCALE;
    CGFloat positionY = 60 / CP_GLOBALSCALE;
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4 - 25 / CP_GLOBALSCALE - 70 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE;
    self.positionLabel.frame = CGRectMake(positionX, positionY, maxW, positionH);
}
#pragma mark - getter methos
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
        [_whiteBackgroundView addSubview:self.positionLabel];
        [_whiteBackgroundView addSubview:self.matchLabel];
        [_whiteBackgroundView addSubview:self.cllectionButton];
        [_whiteBackgroundView addSubview:self.salaryLabel];
        [_whiteBackgroundView addSubview:self.companyLabel];
        [_whiteBackgroundView addSubview:self.timeLabel];
        [self.cllectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo( self.positionLabel.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        self.cllectionButton.hidden = YES;
        [self.salaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.cllectionButton.mas_bottom ).offset( 24 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.matchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.salaryLabel.mas_centerY );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.salaryLabel.mas_bottom ).offset( 28 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.timeLabel.font.pointSize ) );
            make.width.equalTo( @( self.timeLabel.font.pointSize * 4.0 ) );
        }];
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.timeLabel.mas_centerY );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.timeLabel.mas_left );
        }];
    }
    return _whiteBackgroundView;
}
- (UILabel *)positionLabel
{
    if ( !_positionLabel )
    {
        _positionLabel = [[UILabel alloc] init];
        [_positionLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _positionLabel;
}
- (UIButton *)cllectionButton
{
    if ( !_cllectionButton )
    {
        _cllectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cllectionButton setImage:[UIImage imageNamed:@"list_ic_collect"] forState:UIControlStateNormal];
        [_cllectionButton setImage:[UIImage imageNamed:@"list_ic_collect"] forState:UIControlStateSelected];
    }
    return _cllectionButton;
}
- (UILabel *)timeLabel
{
    if ( !_timeLabel )
    {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _timeLabel;
}
- (UILabel *)salaryLabel
{
    if ( !_salaryLabel )
    {
        _salaryLabel = [[UILabel alloc] init];
        [_salaryLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_salaryLabel setTextColor:[UIColor colorWithHexString:@"ff5252"]];
    }
    return _salaryLabel;
}
- (UILabel *)companyLabel
{
    if ( !_companyLabel )
    {
        _companyLabel = [[UILabel alloc] init];
        [_companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_companyLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
    }
    return _companyLabel;
}
- (UILabel *)matchLabel
{
    if ( !_matchLabel )
    {
        _matchLabel = [[UILabel alloc] init];
        [_matchLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_matchLabel setTextColor:[UIColor colorWithHexString:@"6ebb58"]];
    }
    return _matchLabel;
}
@end