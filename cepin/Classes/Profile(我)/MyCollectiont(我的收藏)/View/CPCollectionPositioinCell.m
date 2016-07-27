//
//  CPCollectionPositioinCell.m
//  cepin
//
//  Created by ceping on 16/1/16.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCollectionPositioinCell.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@interface CPCollectionPositioinCell ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIImageView *locationView;
@property (nonatomic, strong) UIImageView *experienceView;
@property (nonatomic, strong) UIImageView *degreeView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *experienceLabel;
@property (nonatomic, strong) UILabel *degreeLabel;
@property (nonatomic, strong) UILabel *salaryLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *schoolImageView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) JobSearchModel *saveJobModel;
@property (nonatomic, strong) NSMutableArray *labelArrayM;
@end
@implementation CPCollectionPositioinCell

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
+ (instancetype)collectionPositionCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"collectionPositionCell";
    CPCollectionPositioinCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPCollectionPositioinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configCellWithSaveJob:(JobSearchModel *)saveJobModel
{
    if ( !saveJobModel )
        return;
    _saveJobModel = saveJobModel;
    [self.positionLabel setText:_saveJobModel.PositionName];
    [self.salaryLabel setText:_saveJobModel.Salary];
    [self.timeLabel setText:[NSDate cepinJobYearMonthDayFromString:_saveJobModel.PublishDate]];
    if ( _saveJobModel.Shortname && 0 < [_saveJobModel.Shortname length] )
    {
        [self.companyLabel setText:_saveJobModel.Shortname];
    }
    else
    {
        [self.companyLabel setText:_saveJobModel.CompanyName];
    }
    [self.locationLabel setText:_saveJobModel.City];
    [self.experienceLabel setText:_saveJobModel.WorkYear];
    [self.degreeLabel setText:_saveJobModel.EducationLevel];
    if ( 2 != _saveJobModel.PositionType.intValue )
    {
        self.schoolImageView.hidden = NO;
    }
    else
    {
        self.schoolImageView.hidden = YES;
    }
    if ( 0 != _saveJobModel.IsTop.intValue )
    {
        self.topImageView.hidden = NO;
    }
    else
    {
        self.topImageView.hidden = YES;
    }
    [self layoutIfNeeded];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize positionSize = [self.positionLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.positionLabel.font } context:nil].size;
    CGFloat positionW = positionSize.width;
    CGFloat positionH = self.positionLabel.font.pointSize;
    CGFloat positionX = 40 / CP_GLOBALSCALE;
    CGFloat positionY = 60 / CP_GLOBALSCALE;
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4 - 25 / CP_GLOBALSCALE - 70 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE;
    // 校招
    if ( 2 != _saveJobModel.PositionType.intValue )
    {
        maxW -= 40 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE;
        [self.schoolImageView setHidden:NO];
    }
    else
    {
        self.schoolImageView.hidden = YES;
    }
    // 置顶
    if ( 0 != _saveJobModel.IsTop.intValue )
    {
        maxW -= 40 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE;
    }
    if ( positionW > maxW )
        positionW = maxW;
    self.positionLabel.frame = CGRectMake(positionX, positionY, positionW, positionH);
    // 校招
    if ( 2 != _saveJobModel.PositionType.intValue )
    {
        self.schoolImageView.viewY = self.positionLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0;
        self.schoolImageView.viewX = CGRectGetMaxX(self.positionLabel.frame) + 40 / CP_GLOBALSCALE;
        self.schoolImageView.viewSize = CGSizeMake(48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
    }
    // 置顶
    if ( 0 != _saveJobModel.IsTop.intValue )
    {
        if ( 2 == _saveJobModel.PositionType.intValue )
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
    CGSize salarySize = [self.salaryLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.salaryLabel.font } context:nil].size;
    CGSize locationSize = [self.locationLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGSize experienceSize = [self.experienceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGSize degreeSize = [self.degreeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGFloat contentMaxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4;
    CGFloat contentW = ( 48 + 10 + 30 ) * 3 / CP_GLOBALSCALE + salarySize.width + locationSize.width + experienceSize.width + degreeSize.width;
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
        contentW = ( 48 + 10 + 30 ) * 3 / CP_GLOBALSCALE + salarySize.width + locationSize.width + experienceSize.width + degreeSize.width;
        if ( contentW >= contentMaxW )
        {
            UILabel *secondLabel = [self secondContentLabel];
            NSString *secondTempString = [NSString stringWithFormat:@"%@...", [secondLabel.text substringToIndex:2]];
            [secondLabel setText:secondTempString];
            if ( [secondLabel isEqual:self.locationLabel] )
            {
                locationSize = [maxTempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
            }
            else if ( [secondLabel isEqual:self.experienceLabel] )
            {
                experienceSize = [maxTempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
            }
            else if ( [secondLabel isEqual:self.degreeLabel] )
            {
                degreeSize = [maxTempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
            }
        }
        contentW = ( 48 + 10 + 30 ) * 3 / CP_GLOBALSCALE + salarySize.width + locationSize.width + experienceSize.width + degreeSize.width;
        if ( contentW >= contentMaxW )
        {
            UILabel *thirdLabel = [self thirdContentLabel];
            NSString *secondTempString = [NSString stringWithFormat:@"%@...", [thirdLabel.text substringToIndex:2]];
            [thirdLabel setText:secondTempString];
            if ( [thirdLabel isEqual:self.locationLabel] )
            {
                locationSize = [maxTempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
            }
            else if ( [thirdLabel isEqual:self.experienceLabel] )
            {
                experienceSize = [maxTempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
            }
            else if ( [thirdLabel isEqual:self.degreeLabel] )
            {
                degreeSize = [maxTempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
            }
        }
    }
    [self.salaryLabel setFrame:CGRectMake(kScreenWidth - salarySize.width - 40 / CP_GLOBALSCALE * 3, CGRectGetMaxY(self.cllectionButton.frame) + 24 / CP_GLOBALSCALE, salarySize.width, self.salaryLabel.font.pointSize)];
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
- (UILabel *)secondContentLabel
{
    UILabel *maxContentLabel = [self maxContentLabel];
    NSMutableArray *tempArrayM = [NSMutableArray array];
    for ( UILabel *label in self.labelArrayM )
    {
        if ( label == maxContentLabel )
            continue;
        [tempArrayM addObject:label];
    }
    UILabel *tempLabel = tempArrayM[0];
    UILabel *nextLabel = tempArrayM[1];
    if ( [tempLabel.text length] >= [nextLabel.text length] )
        return tempLabel;
    else
        return nextLabel;
}
- (UILabel *)thirdContentLabel
{
    UILabel *maxContentLabel = [self maxContentLabel];
    UILabel *secondContentLabel = [self secondContentLabel];
    UILabel *tempLabel = nil;
    for ( UILabel *label in self.labelArrayM )
    {
        if ( label == maxContentLabel )
            continue;
        if ( label == secondContentLabel )
            continue;
        tempLabel = label;
    }
    return tempLabel;
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
        [_whiteBackgroundView addSubview:self.positionLabel];
        [_whiteBackgroundView addSubview:self.cllectionButton];
        [_whiteBackgroundView addSubview:self.salaryLabel];
        [_whiteBackgroundView addSubview:self.companyLabel];
        [_whiteBackgroundView addSubview:self.timeLabel];
        [_whiteBackgroundView addSubview:self.schoolImageView];
        [_whiteBackgroundView addSubview:self.topImageView];
        [_whiteBackgroundView addSubview:self.locationView];
        [_whiteBackgroundView addSubview:self.locationLabel];
        [_whiteBackgroundView addSubview:self.experienceView];
        [_whiteBackgroundView addSubview:self.experienceLabel];
        [_whiteBackgroundView addSubview:self.degreeView];
        [_whiteBackgroundView addSubview:self.degreeLabel];
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.salaryLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        }];
        [self.experienceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.salaryLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.locationLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
        }];
        [self.degreeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.salaryLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.experienceLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
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
        [_cllectionButton setFrame:CGRectMake(kScreenWidth - ( 40 * 3 + 70 ) / CP_GLOBALSCALE, (60 - (70 - 42) / 2) / CP_GLOBALSCALE, 70 / CP_GLOBALSCALE, 70 / CP_GLOBALSCALE)];
    }
    return _cllectionButton;
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
        CGSize locationSize = [_locationLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : _locationLabel.font } context:nil].size;
        [_locationLabel setFrame:CGRectMake(CGRectGetMaxX(self.locationView.frame) + 10 / CP_GLOBALSCALE, self.locationView.viewY, locationSize.width, 48 / CP_GLOBALSCALE)];
        [self.labelArrayM addObject:_locationLabel];
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
        [self.labelArrayM addObject:_experienceLabel];
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
        [self.labelArrayM addObject:_degreeLabel];
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
- (NSMutableArray *)labelArrayM
{
    if ( !_labelArrayM )
    {
        _labelArrayM = [NSMutableArray array];
    }
    return _labelArrayM;
}
@end
