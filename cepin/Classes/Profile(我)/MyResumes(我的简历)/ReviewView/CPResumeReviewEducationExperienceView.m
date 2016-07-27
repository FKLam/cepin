//
//  CPResumeReviewEducationExperienceView.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeReviewEducationExperienceView.h"
#import "NSDate-Utilities.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPResumeReviewReformer.h"
#import "CPCommon.h"
@interface CPResumeReviewEducationExperienceView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) NSMutableArray *timeCycleArrayM;
@property (nonatomic, strong) NSMutableArray *verLineArrayM;
@property (nonatomic, strong) NSMutableArray *timeLabelArrayM;
@property (nonatomic, strong) NSMutableArray *schoolLabelArrayM;
@property (nonatomic, strong) NSMutableArray *majorLabelArrayM;
@property (nonatomic, strong) NSMutableArray *additionalLabelArrayM;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@end
@implementation CPResumeReviewEducationExperienceView
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        self.separatorLine = separatorLine;
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.titleLabel.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        UIView *separatorEndLine = [[UIView alloc] init];
        [separatorEndLine setBackgroundColor:[UIColor colorWithHexString:@"e6e6ea"]];
        [self addSubview:separatorEndLine];
        self.secondSeparatorLine = separatorEndLine;
        [separatorEndLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.mas_bottom );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 6 / CP_GLOBALSCALE ) );
        }];
    }
    return self;
}
- (void)configWithResume:(ResumeNameModel *)resumeModel
{
    [self reSet:resumeModel];
    _resumeModel = resumeModel;
    NSMutableArray<EducationListDateModel> *educationList = _resumeModel.EducationList;
    CGFloat X = 30 / CP_GLOBALSCALE;
    CGFloat Y = 50 / CP_GLOBALSCALE + CGRectGetMaxY(self.titleLabel.frame) + 2 / CP_GLOBALSCALE;
    CGFloat lineY = Y;
    CGFloat LineX = X;
    UIImageView *timeCycle = nil;
    UILabel *timeLabel = nil;
    UILabel *schoolLabel = nil;
    UILabel *majorLabel = nil;
    CPPositionDetailDescribeLabel *additionalLabel = nil;
    CGFloat temp = 0.0;
    NSUInteger modelCount = 0;
    NSUInteger totalCount = [educationList count];
    if ( 0 == totalCount )
        [self.titleLabel setHidden:YES];
    NSInteger tag = 0;
    [self.secondSeparatorLine setHidden:YES];
    [self.separatorLine setHidden:YES];
    for ( EducationListDateModel *education in educationList )
    {
        if ( self.separatorLine.isHidden )
            [self.separatorLine setHidden:NO];
        if ( self.secondSeparatorLine.isHidden )
            [self.secondSeparatorLine setHidden:NO];
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
        NSString *time = [NSString stringWithFormat:@"%@ - %@",startime ,endTime];
        [timeLabel setText:time];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( timeCycle.mas_centerY );
            make.left.equalTo( timeCycle.mas_right ).offset( 45 / CP_GLOBALSCALE );
            make.height.equalTo( @( timeLabel.font.pointSize ) );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        schoolLabel = [self reuseCompanyLableWithTag:tag];
        [schoolLabel setText:[education valueForKey:@"School"]];
        [schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( timeLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( timeLabel.mas_left );
            make.right.equalTo( timeLabel.mas_right );
        }];
        majorLabel = [self reusePositionLabelWithTag:tag];
        [self setMajorDegreeLabel:majorLabel education:education];
        [majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( schoolLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( schoolLabel.mas_left );
            make.right.equalTo( schoolLabel.mas_right );
        }];
        if ( 2 == [_resumeModel.ResumeType intValue] )
        {
            if ( ![[education valueForKey:@"ScoreRanking"] isKindOfClass:[NSNull class]] || ![[education valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
            {
                additionalLabel = [self reuseAdditionalLabelWithTag:tag];
                [self setAdditionalLabel:additionalLabel education:education];
                [additionalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( majorLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
                    make.left.equalTo( schoolLabel.mas_left );
                    make.right.equalTo( schoolLabel.mas_right );
                }];
                temp += [CPResumeReviewReformer reviewEducationAdditionalHeight:education];
            }
        }
        temp += ( 36 + 40 + 36 + 20 + 36 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
        Y += temp;
        modelCount++;
        tag++;
    }
}
- (void)setAdditionalLabel:(CPPositionDetailDescribeLabel *)label education:(EducationListDateModel *)education
{
    if ( [[education valueForKey:@"ScoreRanking"] isKindOfClass:[NSNull class]] && [[education valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
        return;
    NSMutableString *strM = [[NSMutableString alloc] init];
    if ( ![[education valueForKey:@"ScoreRanking"] isKindOfClass:[NSNull class]] )
    {
        [strM appendString:@"成绩排名 : "];
        NSString *scoreStr = [education valueForKey:@"ScoreRanking"];
        NSString *rankStr = nil;
        if([@"5" isEqualToString:scoreStr])
        {
            rankStr = @"年级前5%";
        }
        else if([@"10" isEqualToString:scoreStr])
        {
            rankStr = @"年级前10%";
        }
        else if([@"20" isEqualToString:scoreStr])
        {
            rankStr = @"年级前20%";
        }
        else if([@"50" isEqualToString:scoreStr])
        {
            rankStr = @"年级前50%";
        }
        else if([@"0" isEqualToString:scoreStr])
        {
            rankStr = @"其他";
        }
        [strM appendString:rankStr];
    }
    if ( ![[education valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
    {
        if ( 0 < [strM length] )
        {
            [strM appendString:@"\n"];
        }
        NSString *desStr = [education valueForKey:@"Description"];
        [strM appendString:@"主修课程 : "];
        [strM appendString:desStr];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:strM];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, [attStr length])];
    [label setAttributedText:attStr];
}
- (void)setMajorDegreeLabel:(UILabel *)label education:(EducationListDateModel *)education
{
    NSString *separatorLine = @"  |  ";
    NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] init];
    NSString *tempMajor = [NSString stringWithString: [education valueForKey:@"Major"]];
    NSString *tempDegree = nil;
    if ( ![[education valueForKey:@"Degree"] isKindOfClass:[NSNull class]] )
        tempDegree = [education valueForKey:@"Degree"];
    NSString *tempXuewei = nil;
    if ( ![[education valueForKey:@"XueWei"] isKindOfClass:[NSNull class]] )
        tempXuewei = [NSString stringWithFormat:@"%@学位", [education valueForKey:@"XueWei"]];
    if ( tempMajor )
    {
        [attStrM appendAttributedString:[[NSAttributedString alloc] initWithString:tempMajor attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"] }]];
    }
    if ( tempDegree )
    {
        if ( 0 < [attStrM length] )
        {
            [attStrM appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor] }]];
        }
        [attStrM appendAttributedString:[[NSAttributedString alloc] initWithString:tempDegree attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"] }]];
    }
    if ( tempXuewei )
    {
        if ( 0 < [attStrM length] )
        {
            [attStrM appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor] }]];
        }
        [attStrM appendAttributedString:[[NSAttributedString alloc] initWithString:tempXuewei attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"] }]];
    }
    [label setAttributedText:attStrM];
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
    [self addSubview:positionLabel];
    [self.majorLabelArrayM addObject:positionLabel];
    return positionLabel;
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
    [self addSubview:companyLabel];
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
    [self addSubview:timeCycle];
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
    [self addSubview:timeLabel];
    return timeLabel;
}
- (CPPositionDetailDescribeLabel *)reuseAdditionalLabelWithTag:(NSInteger)tag
{
    for( CPPositionDetailDescribeLabel *timeLabel in self.additionalLabelArrayM )
    {
        if ( timeLabel.tag == tag )
        {
            return timeLabel;
        }
    }
    CPPositionDetailDescribeLabel *timeLabel = [[CPPositionDetailDescribeLabel alloc] init];
    [timeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [timeLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [timeLabel setTag:tag];
    [timeLabel setVerticalAlignment:VerticalAlignmentTop];
    [timeLabel setNumberOfLines:0];
    [self.additionalLabelArrayM addObject:timeLabel];
    [self addSubview:timeLabel];
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
    [self addSubview:line];
    [self.verLineArrayM addObject:line];
}
#pragma mark - getter methods
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setText:@"教育经历"];
    }
    return _titleLabel;
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
- (NSMutableArray *)additionalLabelArrayM
{
    if ( !_additionalLabelArrayM )
    {
        _additionalLabelArrayM = [NSMutableArray array];
    }
    return _additionalLabelArrayM;
}
@end