//
//  CPWatchResumeCell.m
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWatchResumeCell.h"
#import "JobSearchModel.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@interface CPWatchResumeCell ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *locationView;
@property (nonatomic, strong) UIImageView *experienceView;
@property (nonatomic, strong) UIImageView *degreeView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *experienceLabel;
@property (nonatomic, strong) UILabel *degreeLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation CPWatchResumeCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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

+ (instancetype)watchResumeCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"watchResumeCell";
    CPWatchResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPWatchResumeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configCellWithResume:(JobSearchModel *) model
{
    if ( model.Shortname && 0 < [model.Shortname length] )
    {
        [self.companyLabel setText:model.Shortname];
    }
    else
    {
        [self.companyLabel setText:model.CompanyName];
    }
    [self.companyLabel setText:model.CompanyName];
    [self.locationLabel setText:model.CompanyCity];
    [self.experienceLabel setText:model.CompanySize];
    [self.degreeLabel setText:model.CompanyIndustry];
    [_degreeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [self.timeLabel setText: [NSDate cepinMMminusdd:model.ViewedDate]];
    if ( !model.CompanyCity || 0 == [model.CompanyCity length] )
    {
        [self.locationView setHidden:YES];
        [self.locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 35 / CP_GLOBALSCALE );
            make.width.equalTo( @( 0 ) );
            make.height.equalTo( @( 0 ) );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        }];
        [self.experienceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 35 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.locationLabel.mas_right );
        }];
    }
    else
    {
        [self.locationView setHidden:NO];
        [self.locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 35 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        }];
        [self.experienceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 35 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.locationLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
        }];
    }
}
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize NSString:(NSString*)content
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize locationSize = [self.locationLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGSize experienceSize = [self.experienceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGSize degreeSize = [self.degreeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGFloat locationX = CGRectGetMaxX(self.locationView.frame);
    if ( !self.locationView.isHidden )
    {
        if ( 0 == locationX )
            locationX = ( 40 + 48 ) / CP_GLOBALSCALE;
        [self.locationLabel setHidden:NO];
        [self.locationLabel setFrame:CGRectMake(locationX + 10 / CP_GLOBALSCALE, self.locationView.viewY, locationSize.width, 48 / CP_GLOBALSCALE)];
        [self.experienceLabel setFrame:CGRectMake(CGRectGetMaxX(self.locationLabel.frame) + 10 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE, self.experienceView.viewY, experienceSize.width, 48 / CP_GLOBALSCALE)];
        CGFloat contentMaxW = kScreenWidth - CGRectGetMaxX(self.experienceLabel.frame) - 30 / CP_GLOBALSCALE - 48 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE - 40 / CP_GLOBALSCALE * CP_GLOBALSCALE;
        degreeSize.width = contentMaxW > degreeSize.width ? degreeSize.width : contentMaxW;
        [self.degreeLabel setFrame:CGRectMake(CGRectGetMaxX(self.experienceLabel.frame) + 10 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE, self.degreeView.viewY, degreeSize.width, 48 / CP_GLOBALSCALE)];
    }
    else
    {
        if ( 0 == locationX )
            locationX = 40 / CP_GLOBALSCALE;
        [self.locationLabel setHidden:YES];
        [self.locationLabel setFrame:CGRectMake(locationX, self.locationView.viewY, 0, 48 / CP_GLOBALSCALE)];
        [self.experienceLabel setFrame:CGRectMake(CGRectGetMaxX(self.locationLabel.frame) + 48 / CP_GLOBALSCALE + 10 / CP_GLOBALSCALE, self.experienceView.viewY, experienceSize.width, 48 / CP_GLOBALSCALE)];
        CGFloat contentMaxW = kScreenWidth - CGRectGetMaxX(self.experienceLabel.frame) - 30 / CP_GLOBALSCALE - 48 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE - 40 / CP_GLOBALSCALE * CP_GLOBALSCALE;
        degreeSize.width = contentMaxW > degreeSize.width ? degreeSize.width : contentMaxW;
        [self.degreeLabel setFrame:CGRectMake(CGRectGetMaxX(self.experienceLabel.frame) + 10 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE, self.degreeView.viewY, degreeSize.width, 48 / CP_GLOBALSCALE)];
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
        [_whiteBackgroundView addSubview:self.companyLabel];
        UIView *descriptionView = [[UIView alloc]initWithFrame:CGRectZero];
        descriptionView.backgroundColor = [UIColor redColor];
        [_whiteBackgroundView addSubview:descriptionView];
        [descriptionView addSubview:self.locationView];
        [descriptionView addSubview:self.locationLabel];
        [descriptionView addSubview:self.experienceView];
        [descriptionView addSubview:self.experienceLabel];
        [descriptionView addSubview:self.degreeView];
        [descriptionView addSubview:self.degreeLabel];
        [descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 35 / CP_GLOBALSCALE );
            make.left.equalTo(self.whiteBackgroundView.mas_left);
            make.right.equalTo(self.whiteBackgroundView.mas_right);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.timeLabel.font.pointSize ) );
            make.width.equalTo( @( self.timeLabel.font.pointSize * 4.0 ) );
            make.centerY.equalTo( self.companyLabel.mas_centerY );
        }];
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( _whiteBackgroundView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.right.equalTo( self.timeLabel.mas_left );
            make.height.equalTo( @( 42 / CP_GLOBALSCALE ) );
        }];
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 35 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( _whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        }];
        [self.experienceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 35 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.locationLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
        }];
        [self.degreeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.companyLabel.mas_bottom ).offset( 35 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.experienceLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
        }];
    }
    return _whiteBackgroundView;
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
        _experienceView.image = [UIImage imageNamed:@"ic_number"];
    }
    return _experienceView;
}
- (UIImageView *)degreeView
{
    if ( !_degreeView )
    {
        _degreeView = [[UIImageView alloc] init];
        _degreeView.image = [UIImage imageNamed:@"ic_industry"];
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
        _degreeLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    }
    return _degreeLabel;
}
- (UILabel *)companyLabel
{
    if ( !_companyLabel )
    {
        _companyLabel = [[UILabel alloc] init];
        [_companyLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_companyLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
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
@end
