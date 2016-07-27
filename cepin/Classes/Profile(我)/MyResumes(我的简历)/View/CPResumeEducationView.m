
//
//  CPResumeEducationView.m
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEducationView.h"
#import "NSDate-Utilities.h"
#import "MobClick.h"
#import "CPCommon.h"
@interface CPResumeEducationView ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *guessLabel;
@property (nonatomic, strong) UIImageView *mustWriteImageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) NSMutableArray *timeCycleArrayM;
@property (nonatomic, strong) NSMutableArray *verLineArrayM;
@property (nonatomic, strong) NSMutableArray *timeLabelArrayM;
@property (nonatomic, strong) NSMutableArray *schoolLabelArrayM;
@property (nonatomic, strong) NSMutableArray *majorLabelArrayM;
@property (nonatomic, strong) NSMutableArray *scoreRankArrayM;
@property (nonatomic, strong) NSMutableArray *descriptArrayM;
@end
@implementation CPResumeEducationView
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
        [MobClick event:@"into_education_experienceactivity"];
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
- (void)configWithResume:(ResumeNameModel *)resumeModel
{
    [self reSet:resumeModel];
    _resumeModel = resumeModel;
    NSMutableArray<EducationListDateModel> *educationList = _resumeModel.EducationList;
    if ( 0 == [educationList count] )
    {
        [self.addMoreButton setHidden:NO];
        [self.editResumeButton setHidden:YES];
    }
    else
    {
        [self.addMoreButton setHidden:YES];
        [self.editResumeButton setHidden:NO];
    }
    CGFloat X = 30 / CP_GLOBALSCALE;
    CGFloat Y = 50 / CP_GLOBALSCALE + CGRectGetMaxY(self.topView.frame);
    CGFloat lineY = Y;
    CGFloat LineX = X;
    UIImageView *timeCycle = nil;
    UILabel *timeLabel = nil;
    UILabel *schoolLabel = nil;
    UILabel *majorLabel = nil;
    UILabel *scoreRankLabel = nil;
    UILabel *descriptLabel = nil;
    CGFloat temp = 0.0;
    NSUInteger modelCount = 0;
    NSUInteger totalCount = [educationList count];
    NSInteger tag = 0;
    for ( EducationListDateModel *education in educationList )
    {
        if ( 0 < modelCount && modelCount < totalCount)
        {
            [self drawVercitalLineX:LineX Y:lineY height:temp tag:tag];
        }
        lineY = Y;
        temp = 0.0;
        CGRect frame = CGRectMake(X, Y, 48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
        timeCycle = [self reuserImageViewWithTag:tag frame:frame];
        
        timeLabel = [self reuseOriginLabelWithTag:tag];
        NSString *startime =  [NSDate cepinYMDFromString:[education valueForKey:@"StartDate"]];
        NSString *endTime = [NSDate cepinYMDFromString:[education valueForKey:@"EndDate"]];
        if (!endTime || [endTime isEqualToString:@""]) {
            endTime = @"至今";
        }
        NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
        [timeLabel setText:time];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( timeCycle.mas_centerY );
            make.left.equalTo( timeCycle.mas_right ).offset( 45 / CP_GLOBALSCALE );
            make.height.equalTo( @( timeLabel.font.pointSize ) );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        schoolLabel = [self reuseCompanyLableWithTag:tag];
        [schoolLabel setText:[education valueForKey:@"School"]];
        [schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( timeLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( timeLabel.mas_left );
            make.right.equalTo( timeLabel.mas_right );
        }];
        majorLabel = [self reusePositionLabelWithTag:tag];
        NSMutableString *tempMajor = [NSMutableString stringWithString: [education valueForKey:@"Major"]];
        [majorLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [tempMajor appendString:[NSString stringWithFormat:@"  |  %@", [education valueForKey:@"Degree"]]];
        if ( ![[education valueForKey:@"XueWei"] isKindOfClass:[NSNull class]] )
        {
            [tempMajor appendString:[NSString stringWithFormat:@"  |  %@学位", [education valueForKey:@"XueWei"]]];
        }
        [majorLabel setText:[tempMajor copy]];
        [majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( schoolLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( schoolLabel.mas_left );
            make.right.equalTo( schoolLabel.mas_right );
        }];
        temp = ( 36 + 40 + 36 + 40 + 36 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
        NSString *scoreRankString = nil;
        if ( ![[education valueForKey:@"ScoreRanking"] isKindOfClass:[NSNull class]] )
        {
            scoreRankLabel = [self scoreRankLabelWithTag:tag];
            if([@"5" isEqualToString:[education valueForKey:@"ScoreRanking"]])
            {
                scoreRankString = @"年级前5%";
            }
            else if([@"10" isEqualToString:[education valueForKey:@"ScoreRanking"]])
            {
                scoreRankString = @"年级前10%";
            }
            else if([@"20" isEqualToString:[education valueForKey:@"ScoreRanking"]])
            {
                scoreRankString = @"年级前20%";
            }
            else if([@"50" isEqualToString:[education valueForKey:@"ScoreRanking"]])
            {
                scoreRankString = @"年级前50%";
            }
            else if([@"0" isEqualToString:[education valueForKey:@"ScoreRanking"]])
            {
                scoreRankString = @"其他";
            }
            [scoreRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( majorLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
                make.left.equalTo( majorLabel.mas_left );
                make.right.equalTo( schoolLabel.mas_right );
            }];
        }
        NSString *des = nil;
        if ( ![[education valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
        {
            descriptLabel = [self descriptLabelWithTag:tag];
            des = [education valueForKey:@"Description"];
        }
        if ( scoreRankString && des )
        {
            [scoreRankLabel setText:[NSString stringWithFormat:@"%@  |  %@", scoreRankString, des]];
            temp += ( 36 + 20 ) / CP_GLOBALSCALE;
        }
        Y += temp;
        modelCount++;
        tag++;
    }
}
- (void)reSet:(ResumeNameModel *)resumeModel
{
    if ( _resumeModel != resumeModel )
    {
        for(id obj in self.timeCycleArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.timeLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.verLineArrayM )
        {
            [obj removeFromSuperview];
        }
        for (id obj in self.schoolLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for ( id obj in self.majorLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        [self.timeCycleArrayM removeAllObjects];
        [self.timeLabelArrayM removeAllObjects];
        [self.verLineArrayM removeAllObjects];
        [self.schoolLabelArrayM removeAllObjects];
        [self.majorLabelArrayM removeAllObjects];
    }
}
- (UILabel *)reusePositionLabelWithTag:(NSInteger)tag
{
    for (UILabel *positionLabel in self.majorLabelArrayM )
    {
        if ( positionLabel.tag == tag )
            return positionLabel;
    }
    UILabel *positionLabel = [[UILabel alloc] init];
    [positionLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [positionLabel setTag:tag];
    [_whiteBackgroundView addSubview:positionLabel];
    [self.majorLabelArrayM addObject:positionLabel];
    return positionLabel;
}
- (UILabel *)scoreRankLabelWithTag:(NSInteger)tag
{
    for ( UILabel *scoreRankLabel in self.scoreRankArrayM )
    {
        if ( scoreRankLabel.tag == tag )
            return scoreRankLabel;
    }
    UILabel *scoreRankLabel = [[UILabel alloc] init];
    [scoreRankLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [scoreRankLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [scoreRankLabel setTag:tag];
    [_whiteBackgroundView addSubview:scoreRankLabel];
    [self.scoreRankArrayM addObject:scoreRankLabel];
    return scoreRankLabel;
}
- (UILabel *)descriptLabelWithTag:(NSInteger)tag
{
    for ( UILabel *descriptLabel in self.descriptArrayM )
    {
        if ( descriptLabel.tag == tag )
            return descriptLabel;
    }
    UILabel *descriptLabel = [[UILabel alloc] init];
    [descriptLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [descriptLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [descriptLabel setTag:tag];
    [_whiteBackgroundView addSubview:descriptLabel];
    [self.descriptArrayM addObject:descriptLabel];
    return descriptLabel;
}
- (UILabel *)reuseCompanyLableWithTag:(NSInteger)tag
{
    for (UILabel *companyLabel in self.schoolLabelArrayM )
    {
        if ( companyLabel.tag == tag )
            return companyLabel;
    }
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [companyLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [companyLabel setTag:tag];
    [_whiteBackgroundView addSubview:companyLabel];
    [self.schoolLabelArrayM addObject:companyLabel];
    return companyLabel;
}
- (UIImageView *)reuserImageViewWithTag:(NSInteger)tag frame:(CGRect)frame
{
    for( UIImageView *timeCycle in self.timeCycleArrayM )
    {
        if ( timeCycle.tag == tag )
            return timeCycle;
    }
    UIImageView *timeCycle = [[UIImageView alloc] init];
    timeCycle.image = [UIImage imageNamed:@"resume_dot"];
    timeCycle.frame = frame;
    [timeCycle setTag:tag];
    [self.timeCycleArrayM addObject:timeCycle];
    [self.whiteBackgroundView addSubview:timeCycle];
    return timeCycle;
}
- (UILabel *)reuseOriginLabelWithTag:(NSInteger)tag
{
    for( UILabel *timeLabel in self.timeLabelArrayM )
    {
        if ( timeLabel.tag == tag )
        {
            return timeLabel;
        }
    }
    UILabel *timeLabel = [[UILabel alloc] init];
    [timeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [timeLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [timeLabel setTag:tag];
    [self.timeLabelArrayM addObject:timeLabel];
    [_whiteBackgroundView addSubview:timeLabel];
    return timeLabel;
}
- (void)drawVercitalLineX:(CGFloat)X Y:(CGFloat)Y height:(CGFloat)height  tag:(NSInteger)tag
{
    UIView *line = nil;
    for( UIView *tempLine in self.verLineArrayM )
    {
        if ( tempLine.tag == tag )
        {
            line = tempLine;
            if ( line.viewHeight != height )
                line.viewHeight = height;
            return;
        }
    }
    line = [[UIView alloc] initWithFrame:CGRectMake(X + 48 / CP_GLOBALSCALE / 2.0 - 3 / CP_GLOBALSCALE / 2.0, Y + 48 / CP_GLOBALSCALE - 1.0, 3 / CP_GLOBALSCALE, height)];
    [line setTag:tag];
    [line setBackgroundColor:[UIColor colorWithHexString:@"dddddd"]];
    [self.whiteBackgroundView addSubview:line];
    [self.verLineArrayM addObject:line];
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
        [_guessLabel setText:@"教育经历"];
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
- (NSMutableArray *)timeCycleArrayM
{
    if ( !_timeCycleArrayM )
    {
        _timeCycleArrayM = [NSMutableArray array];
    }
    return _timeCycleArrayM;
}
- (NSMutableArray *)timeLabelArrayM
{
    if ( !_timeLabelArrayM )
    {
        _timeLabelArrayM = [NSMutableArray array];
    }
    return _timeLabelArrayM;
}
- (NSMutableArray *)schoolLabelArrayM
{
    if ( !_schoolLabelArrayM )
    {
        _schoolLabelArrayM = [NSMutableArray array];
    }
    return _schoolLabelArrayM;
}
- (NSMutableArray *)majorLabelArrayM
{
    if ( !_majorLabelArrayM )
    {
        _majorLabelArrayM = [NSMutableArray array];
    }
    return _majorLabelArrayM;
}
- (NSMutableArray *)verLineArrayM
{
    if ( !_verLineArrayM )
    {
        _verLineArrayM = [NSMutableArray array];
    }
    return _verLineArrayM;
}
- (NSMutableArray *)scoreRankArrayM
{
    if ( !_scoreRankArrayM )
    {
        _scoreRankArrayM = [NSMutableArray array];
    }
    return _scoreRankArrayM;
}
- (NSMutableArray *)descriptArrayM
{
    if ( !_descriptArrayM )
    {
        _descriptArrayM = [NSMutableArray array];
    }
    return _descriptArrayM;
}
- (CPResumeMoreButton *)addMoreButton
{
    if ( !_addMoreButton )
    {
        _addMoreButton = [CPResumeMoreButton buttonWithType:UIButtonTypeCustom];
        [_addMoreButton setBackgroundColor:[UIColor clearColor]];
        [_addMoreButton setTitle:@"添加教育经历" forState:UIControlStateNormal];
        [_addMoreButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_addMoreButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_addMoreButton setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [_addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeMoreButton *sender) {
            
        }];
    }
    return _addMoreButton;
}
@end



