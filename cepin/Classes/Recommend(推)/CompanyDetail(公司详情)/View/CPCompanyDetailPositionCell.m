//
//  CPCompanyDetailPositionCell.m
//  cepin
//
//  Created by ceping on 16/1/27.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyDetailPositionCell.h"
#import "JobSearchModel.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@interface CPCompanyDetailPositionCell ()
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIImageView *locationView;
@property (nonatomic, strong) UIImageView *experienceView;
@property (nonatomic, strong) UIImageView *degreeView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *experienceLabel;
@property (nonatomic, strong) UILabel *degreeLabel;
@property (nonatomic, strong) UILabel *salaryLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIImageView *schoolImageView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIButton *checkMoreButton;
@property (nonatomic, strong) UIView *checkMoreBackgroundView;
@end

@implementation CPCompanyDetailPositionCell
#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.contentView addSubview:self.positionLabel];
        [self.contentView addSubview:self.locationView];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.experienceView];
        [self.contentView addSubview:self.experienceLabel];
        [self.contentView addSubview:self.degreeView];
        [self.contentView addSubview:self.degreeLabel];
        [self.contentView addSubview:self.salaryLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.separatorLine];
        [self.contentView addSubview:self.schoolImageView];
        [self.contentView addSubview:self.topImageView];
        [self.salaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.positionLabel.mas_centerY );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.salaryLabel.font.pointSize ) );
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.salaryLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.timeLabel.font.pointSize ) );
        }];
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.timeLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
        }];
        [self.experienceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.timeLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.locationLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
        }];
        [self.degreeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.timeLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.experienceLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
        }];
    }
    return self;
}
+ (instancetype)guessCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"CPCompanyDetailPositionCell";
    CPCompanyDetailPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPCompanyDetailPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)setContentIsRead:(BOOL)isRead
{
    if ( isRead )
    {
        [self.positionLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    else
    {
        [self.positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
}
- (void)configCellWithDatas:(CPRecommendModelFrame *)modelFrame
{
    if ( !modelFrame )
        return;
    // 取出职位模型
    _recommendModel = modelFrame.recommendModel;
    [self.positionLabel setText:_recommendModel.PositionName];
    [self.salaryLabel setText:_recommendModel.Salary];
    [self.timeLabel setText:[NSDate cepinJobYearMonthDayFromString:_recommendModel.PublishDate]];
    if ( _recommendModel.Address && 0 < [_recommendModel.Address length] )
        [self.locationLabel setText:_recommendModel.Address];
    else if ( _recommendModel.City && 0 < [_recommendModel.City length] )
        [self.locationLabel setText:_recommendModel.City];
    [self.experienceLabel setText:_recommendModel.WorkYear];
    NSString *educationStr = _recommendModel.EducationLevel;
    if ( educationStr && 0 < [educationStr length] )
    {
        [self.degreeView setHidden:NO];
        [self.degreeLabel setHidden:NO];
    }
    else
    {
        [self.degreeView setHidden:YES];
        [self.degreeLabel setHidden:YES];
    }
    [self.degreeLabel setText:educationStr];
    if ( 2 != _recommendModel.PositionType.intValue )
    {
        self.schoolImageView.hidden = NO;
    }
    else
    {
        self.schoolImageView.hidden = YES;
    }
    
    if ( 0 != _recommendModel.IsTop.intValue )
    {
        self.topImageView.hidden = NO;
    }
    else
    {
        self.topImageView.hidden = YES;
    }
    [self layoutIfNeeded];
}
- (void)setLastCellIsHide:(BOOL)isHide
{
    [self.separatorLine setHidden:isHide];
    [self layoutIfNeeded];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize positionSize = [self.positionLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.positionLabel.font } context:nil].size;
    CGSize salarySize = [self.recommendModel.Salary boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE] } context:nil].size;
    CGFloat positionW = positionSize.width;
    CGFloat positionH = self.positionLabel.font.pointSize + 10 / CP_GLOBALSCALE;
    CGFloat positionX = 40 / CP_GLOBALSCALE;
    CGFloat positionY = 50 / CP_GLOBALSCALE;
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2 - 25 / CP_GLOBALSCALE - salarySize.width;
    // 校招
    if ( 2 != _recommendModel.PositionType.intValue )
    {
        maxW -= 40 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE;
    }
    else
    {
        self.schoolImageView.hidden = YES;
    }
    // 置顶
    if ( 0 != _recommendModel.IsTop.intValue )
    {
        maxW -= 40 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE;
    }
    if ( positionW > maxW )
        positionW = maxW;
    self.positionLabel.frame = CGRectMake(positionX, positionY, positionW, positionH);
    // 校招
    if ( 2 != _recommendModel.PositionType.intValue )
    {
        self.schoolImageView.viewY = self.positionLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0;
        self.schoolImageView.viewX = CGRectGetMaxX(self.positionLabel.frame) + 40 / CP_GLOBALSCALE;
        self.schoolImageView.viewSize = CGSizeMake(48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
    }
    // 置顶
    if ( 0 != _recommendModel.IsTop.intValue )
    {
        if ( 2 == _recommendModel.PositionType.intValue )
        {
            self.topImageView.viewY = self.positionLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0;
            self.topImageView.viewX = CGRectGetMaxX(self.positionLabel.frame) + 40 / CP_GLOBALSCALE;
            self.topImageView.viewSize = CGSizeMake(48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
        }
        else
        {
            self.topImageView.viewY = self.schoolImageView.viewY;
            self.topImageView.viewX = CGRectGetMaxX(self.schoolImageView.frame) + 40 / CP_GLOBALSCALE;
            self.topImageView.viewSize = CGSizeMake(48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
        }
    }
    CGFloat separatorLineX = 40 / CP_GLOBALSCALE;
    CGFloat separatorLineW = self.viewWidth - separatorLineX * 2;
    CGFloat separatorLineH = 2 / CP_GLOBALSCALE;
    CGFloat separatorLineY = self.viewHeight - separatorLineH;
    self.separatorLine.frame = CGRectMake(separatorLineX, separatorLineY, separatorLineW, separatorLineH);
    CGSize timeSize = [self.salaryLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.timeLabel.font } context:nil].size;
    CGSize locationSize = [self.locationLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGSize experienceSize = [self.experienceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGSize degreeSize = [self.degreeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGFloat contentMaxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    CGFloat contentW = ( 48 + 10 + 30 ) * 3 / CP_GLOBALSCALE + timeSize.width + locationSize.width + experienceSize.width + degreeSize.width;
    if ( contentW > contentMaxW )
    {
        UILabel *maxContentLabel = [self maxContentLabel];
        NSString *maxTempString = [NSString stringWithFormat:@"%@...",[maxContentLabel.text substringToIndex:2]];
        [maxContentLabel setText:maxTempString];
        if ( [maxContentLabel isEqual:self.locationLabel] )
        {
            locationSize = [maxTempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
        }
        else if ( [maxContentLabel isEqual:self.experienceLabel] )
        {
            experienceSize = [maxTempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
        }
        else if ( [maxContentLabel isEqual:self.degreeLabel] )
        {
            degreeSize = [maxTempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
        }
    }
    [self.locationLabel setFrame:CGRectMake(CGRectGetMaxX(self.locationView.frame) + 10 / CP_GLOBALSCALE, self.locationView.viewY, locationSize.width, 48 / CP_GLOBALSCALE)];
    [self.experienceLabel setFrame:CGRectMake(CGRectGetMaxX(self.locationLabel.frame) + 10 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE, self.experienceView.viewY, experienceSize.width, 48 / CP_GLOBALSCALE)];
    [self.degreeLabel setFrame:CGRectMake(CGRectGetMaxX(self.experienceLabel.frame) + 10 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE, self.degreeView.viewY, degreeSize.width, 48 / CP_GLOBALSCALE)];
}
- (UILabel *)maxContentLabel
{
    UILabel *tempLabel = self.locationLabel;
    if ( [tempLabel.text length] < [self.experienceLabel.text length] )
        tempLabel = self.experienceLabel;
    if ( [tempLabel.text length] < [self.degreeLabel.text length] )
        tempLabel = self.degreeLabel;
    return tempLabel;
}
#pragma mark - getter methods
- (UILabel *)positionLabel
{
    if ( !_positionLabel )
    {
        _positionLabel = [[UILabel alloc] init];
        [_positionLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_positionLabel setNumberOfLines:0];
        [_positionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _positionLabel;
}
- (UIImageView *)locationView
{
    if ( !_locationView )
    {
        _locationView = [[UIImageView alloc] init];
        _locationView.image = [UIImage imageNamed:@"ic_location"];
    }
    return _locationView;
}
- (UIImageView *)experienceView
{
    if ( !_experienceView )
    {
        _experienceView = [[UIImageView alloc] init];
        _experienceView.image = [UIImage imageNamed:@"ic_experience"];
    }
    return _experienceView;
}
- (UIImageView *)degreeView
{
    if ( !_degreeView )
    {
        _degreeView = [[UIImageView alloc] init];
        _degreeView.image = [UIImage imageNamed:@"ic_degree"];
    }
    return _degreeView;
}
- (UILabel *)locationLabel
{
    if ( !_locationLabel )
    {
        _locationLabel = [[UILabel alloc] init];
        [_locationLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_locationLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    return _locationLabel;
}
- (UILabel *)experienceLabel
{
    if ( !_experienceLabel )
    {
        _experienceLabel = [[UILabel alloc] init];
        [_experienceLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_experienceLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    return _experienceLabel;
}
- (UILabel *)degreeLabel
{
    if ( !_degreeLabel )
    {
        _degreeLabel = [[UILabel alloc] init];
        [_degreeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_degreeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    return _degreeLabel;
}
- (UILabel *)salaryLabel
{
    if ( !_salaryLabel )
    {
        _salaryLabel = [[UILabel alloc] init];
        [_salaryLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_salaryLabel setTextAlignment:NSTextAlignmentRight];
        [_salaryLabel setTextColor:[UIColor colorWithHexString:@"ff5252"]];
    }
    return _salaryLabel;
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
- (UIView *)separatorLine
{
    if ( !_separatorLine )
    {
        _separatorLine = [[UIView alloc] init];
        [_separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _separatorLine;
}
- (UIImageView *)schoolImageView
{
    if ( !_schoolImageView )
    {
        _schoolImageView = [[UIImageView alloc] init];
        _schoolImageView.image = [UIImage imageNamed:@"resume_ic_edutab"];
        _schoolImageView.hidden = YES;
    }
    return _schoolImageView;
}
- (UIImageView *)topImageView
{
    if ( !_topImageView )
    {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"list_ic__totop"];
        _topImageView.hidden = YES;
    }
    return _topImageView;
}
- (UIButton *)checkMoreButton
{
    if ( !_checkMoreButton )
    {
        __weak typeof( self ) weakSelf = self;
        _checkMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkMoreButton setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_checkMoreButton setTitle:@"点击查看更多岗位" forState:UIControlStateNormal];
        [_checkMoreButton.titleLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_checkMoreButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_checkMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [weakSelf.companyDetailPositionCellDelegate respondsToSelector:@selector(companyDetailPositionCell:clickedLoadMoreButton:)] )
            {
                [weakSelf.companyDetailPositionCellDelegate companyDetailPositionCell:weakSelf clickedLoadMoreButton:weakSelf.checkMoreButton];
            }
        }];
    }
    return _checkMoreButton;
}
- (UIView *)checkMoreBackgroundView
{
    if ( !_checkMoreBackgroundView )
    {
        _checkMoreBackgroundView = [[UIView alloc] init];
        [_checkMoreBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_checkMoreBackgroundView addSubview:self.checkMoreButton];
        [self.checkMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _checkMoreBackgroundView.mas_top );
            make.left.equalTo( _checkMoreBackgroundView.mas_left );
            make.bottom.equalTo( _checkMoreBackgroundView.mas_bottom ).offset( -( 2 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE ) );
            make.right.equalTo( _checkMoreBackgroundView.mas_right );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_checkMoreBackgroundView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _checkMoreBackgroundView.mas_left );
            make.height.equalTo ( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( _checkMoreBackgroundView.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
            make.right.equalTo( _checkMoreBackgroundView.mas_right );
        }];
    }
    return _checkMoreBackgroundView;
}
@end


