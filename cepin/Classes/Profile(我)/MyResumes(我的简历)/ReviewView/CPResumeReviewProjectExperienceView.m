//
//  CPResumeReviewProjectExperienceView.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeReviewProjectExperienceView.h"
#import "NSDate-Utilities.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPResumeEditReformer.h"
#import "CPResumeReviewReformer.h"
#import "CPCommon.h"
@interface CPResumeReviewProjectExperienceView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) NSMutableArray *timeCycleArrayM;
@property (nonatomic, strong) NSMutableArray *timeLabelArrayM;
@property (nonatomic, strong) NSMutableArray *companyLabelArrayM;
@property (nonatomic, strong) NSMutableArray *positionLabelArrayM;
@property (nonatomic, strong) NSMutableArray *describeLabelArrayM;
@property (nonatomic, strong) NSMutableArray *verLineArrayM;
@property (nonatomic, strong) NSMutableArray *projectLinkLabelArrayM;
@property (nonatomic, strong) NSMutableArray *scientiticLabelArrayM;
@property (nonatomic, strong) NSMutableArray *gainLabelArrayM;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@end
@implementation CPResumeReviewProjectExperienceView
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
    NSMutableArray<ProjectListDataModel> *projectList = _resumeModel.ProjectList;
    CGFloat X = 30 / CP_GLOBALSCALE;
    CGFloat Y = 50 / CP_GLOBALSCALE + CGRectGetMaxY(self.titleLabel.frame) + 2 / CP_GLOBALSCALE;
    CGFloat lineY = Y;
    CGFloat LineX = X;
    UIImageView *timeCycle = nil;
    UILabel *timeLabel = nil;
    UILabel *projectNameLabel = nil;
    CPPositionDetailDescribeLabel *dutyLabel = nil;
    CPPositionDetailDescribeLabel *describeLabel = nil;
    CPPositionDetailDescribeLabel *projectLinkLabel = nil;
    UILabel *scientificLabel = nil;
    CPPositionDetailDescribeLabel *gainLabel = nil;
    CGFloat temp = 0.0;
    NSUInteger modelCount = 0;
    NSUInteger totalCount = [projectList count];
    NSInteger tag = 0;
    [self.secondSeparatorLine setHidden:YES];
    [self.separatorLine setHidden:YES];
    for ( ProjectListDataModel *project in projectList )
    {
        projectLinkLabel = nil;
        if ( self.separatorLine.isHidden )
            [self.separatorLine setHidden:NO];
        if ( self.secondSeparatorLine.isHidden )
            [self.secondSeparatorLine setHidden:NO];
        if ( [self.titleLabel isHidden] )
            [self.titleLabel setHidden:NO];
        if ( 0 < modelCount && modelCount < totalCount)
        {
            [self drawVercitalLineX:LineX Y:lineY height:temp tag:tag];
        }
        lineY = Y;
        temp = 0.0;
        CGRect frame = CGRectMake(X, Y, 48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
        timeCycle = [self reuserImageViewWithTag:tag frame:frame];
        
        timeLabel = [self reuseOriginLabelWithTag:tag];
        NSString *startime =  [NSDate cepinYMDFromString:[project valueForKey:@"StartDate"]];
        NSString *endTime = [NSDate cepinYMDFromString:[project valueForKey:@"EndDate"]];
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
        projectNameLabel = [self reuseCompanyLableWithTag:tag];
        [projectNameLabel setText:[project valueForKey:@"Name"]];
        [projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( timeLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( timeLabel.mas_left );
            make.right.equalTo( timeLabel.mas_right );
        }];
        temp = ( 36 + 40 + 36 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
        if (  ![[project valueForKey:@"Duty"] isKindOfClass:[NSNull class]] )
        {
            dutyLabel = [self reusePositionLabelWithTag:tag];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[project valueForKey:@"Duty"]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
            if ( 21 < [CPResumeReviewReformer reviewProjectDutyHeight:project] )
                [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
            else
            {
                [paragraphStyle setLineSpacing:0.0];
            }
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]} range:NSMakeRange(0, [attStr length])];
            [dutyLabel setAttributedText:attStr];
            [dutyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( projectNameLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                make.left.equalTo( timeLabel.mas_left );
                make.right.equalTo( timeLabel.mas_right );
            }];
            temp += [CPResumeReviewReformer reviewProjectDutyHeight:project] + 40 / CP_GLOBALSCALE;
        }
        if ( ![[project valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
        {
            describeLabel = [self reuseDescribeLabelWithTag:tag];
            NSString *preStr = @"项目描述 : ";
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", preStr, [project valueForKey:@"Content"]]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
            if ( 21 < [CPResumeReviewReformer reviewProjectDescribeHeight:project] )
                [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
            else
            {
                [paragraphStyle setLineSpacing:0.0];
            }
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, [attStr length])];
            [describeLabel setAttributedText:attStr];
            if ( dutyLabel )
            {
                [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( dutyLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                    make.left.equalTo( timeLabel.mas_left );
                    make.right.equalTo( timeLabel.mas_right );
                }];
            }
            else
            {
                [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( projectNameLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                    make.left.equalTo( timeLabel.mas_left );
                    make.right.equalTo( timeLabel.mas_right );
                }];
            }
            temp += [CPResumeReviewReformer reviewProjectDescribeHeight:project] + 40 / CP_GLOBALSCALE;
        }
        if ( ![[project valueForKey:@"ProjectLink"] isKindOfClass:[NSNull class]] )
        {
            projectLinkLabel = [self projectLinkLabelWithTag:tag];
            NSString *preStr = @"项目链接 : ";
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", preStr, [project valueForKey:@"ProjectLink"]]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
            if ( 21 < [CPResumeReviewReformer reviewProjectLinkHeight:project] )
                [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
            else
            {
                [paragraphStyle setLineSpacing:0.0];
            }
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, [attStr length])];
            [projectLinkLabel setAttributedText:attStr];
            [projectLinkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( describeLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                make.left.equalTo( timeLabel.mas_left );
                make.right.equalTo( timeLabel.mas_right );
            }];
            temp += [CPResumeReviewReformer reviewProjectLinkHeight:project] + 40 / CP_GLOBALSCALE;
        }
        if ( 2 == [resumeModel.ResumeType intValue] )
        {
            scientificLabel = [self scientificLabelWithTag:tag];
            NSMutableString *scientificString = [NSMutableString string];
            if ( 0 == [[project valueForKey:@"IsKeyuan"] intValue] )
            {
                [scientificString appendString:@"不是科研项目"];
            }
            else if ( 1 == [[project valueForKey:@"IsKeyuan"] intValue] )
            {
                [scientificString appendString:@"是科研项目"];
            }
            if ( ![[project valueForKey:@"KeyanLevel"] isKindOfClass:[NSNull class]] )
            {
                [scientificString appendFormat:@"  |  %@", [project valueForKey:@"KeyanLevel"]];
            }
            [scientificLabel setText:scientificString];
            if ( projectLinkLabel )
            {
                [scientificLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( projectLinkLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                    make.left.equalTo( timeLabel.mas_left );
                    make.right.equalTo( timeLabel.mas_right );
                }];
            }
            else
            {
                [scientificLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( describeLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                    make.left.equalTo( timeLabel.mas_left );
                    make.right.equalTo( timeLabel.mas_right );
                }];
            }
            temp += 40 / CP_GLOBALSCALE + 36 / CP_GLOBALSCALE;
            if ( ![[project valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
            {
                gainLabel = [self gainLabelWithTag:tag];
                NSString *preStr = @"成果描述 : ";
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", preStr, [project valueForKey:@"Description"]]];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
                if ( 21 < [CPResumeReviewReformer reviewProjectGainHeight:project] )
                    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
                else
                {
                    [paragraphStyle setLineSpacing:0.0];
                }
                [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
                [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, [attStr length])];
                [gainLabel setAttributedText:attStr];
                [gainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( scientificLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                    make.left.equalTo( timeLabel.mas_left );
                    make.right.equalTo( timeLabel.mas_right );
                }];
                temp += 40 / CP_GLOBALSCALE + [CPResumeReviewReformer reviewProjectGainHeight:project];
            }
        }
        Y += temp;
        modelCount++;
        tag++;
    }
}
- (void)reSet:(ResumeNameModel *)resumeModel
{
    [self.titleLabel setHidden:YES];
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
        for(id obj in self.companyLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.positionLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.describeLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.verLineArrayM )
        {
            [obj removeFromSuperview];
        }
        for( id obj in self.projectLinkLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        [self.timeCycleArrayM removeAllObjects];
        [self.timeLabelArrayM removeAllObjects];
        [self.companyLabelArrayM removeAllObjects];
        [self.positionLabelArrayM removeAllObjects];
        [self.describeLabelArrayM removeAllObjects];
        [self.verLineArrayM removeAllObjects];
        [self.projectLinkLabelArrayM removeAllObjects];
    }
}
- (CPPositionDetailDescribeLabel *)reusePositionLabelWithTag:(NSInteger)tag
{
    for (CPPositionDetailDescribeLabel *positionLabel in self.positionLabelArrayM )
    {
        if ( positionLabel.tag == tag )
            return positionLabel;
    }
    CPPositionDetailDescribeLabel *positionLabel = [[CPPositionDetailDescribeLabel alloc] init];
    [positionLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [positionLabel setTag:tag];
    [positionLabel setNumberOfLines:0];
    [positionLabel setVerticalAlignment:VerticalAlignmentTop];
    [self addSubview:positionLabel];
    [self.positionLabelArrayM addObject:positionLabel];
    return positionLabel;
}
- (UILabel *)reuseCompanyLableWithTag:(NSInteger)tag
{
    for (UILabel *companyLabel in self.companyLabelArrayM )
    {
        if ( companyLabel.tag == tag )
            return companyLabel;
    }
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [companyLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [companyLabel setTag:tag];
    [self addSubview:companyLabel];
    [self.companyLabelArrayM addObject:companyLabel];
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
- (CPPositionDetailDescribeLabel *)reuseDescribeLabelWithTag:(NSInteger)tag
{
    for( CPPositionDetailDescribeLabel *label in self.describeLabelArrayM )
    {
        if ( label.tag == tag )
            return label;
    }
    CPPositionDetailDescribeLabel *describeLabel = [[CPPositionDetailDescribeLabel alloc] init];
    [describeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [describeLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [describeLabel setTag:tag];
    [describeLabel setNumberOfLines:0];
    [describeLabel setVerticalAlignment:VerticalAlignmentTop];
    [self addSubview:describeLabel];
    [self.describeLabelArrayM addObject:describeLabel];
    return describeLabel;
}
- (CPPositionDetailDescribeLabel *)projectLinkLabelWithTag:(NSInteger)tag
{
    for ( CPPositionDetailDescribeLabel *label in self.projectLinkLabelArrayM )
    {
        if ( label.tag == tag )
            return label;
    }
    CPPositionDetailDescribeLabel *projectLink = [[CPPositionDetailDescribeLabel alloc] init];
    [projectLink setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [projectLink setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [projectLink setTag:tag];
    [projectLink setNumberOfLines:0];
    [projectLink setVerticalAlignment:VerticalAlignmentTop];
    [self addSubview:projectLink];
    [self.projectLinkLabelArrayM addObject:projectLink];
    return projectLink;
}
- (UILabel *)scientificLabelWithTag:(NSInteger)tag
{
    for ( UILabel *label in self.scientiticLabelArrayM )
    {
        if ( label.tag == tag )
            return label;
    }
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [label setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [label setTag:tag];
    [label setNumberOfLines:0];
    [self addSubview:label];
    [self.scientiticLabelArrayM addObject:label];
    return label;
}
- (CPPositionDetailDescribeLabel *)gainLabelWithTag:(NSInteger)tag
{
    for ( CPPositionDetailDescribeLabel *label in self.gainLabelArrayM )
    {
        if ( label.tag == tag )
            return label;
    }
    CPPositionDetailDescribeLabel *projectLink = [[CPPositionDetailDescribeLabel alloc] init];
    [projectLink setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [projectLink setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [projectLink setTag:tag];
    [projectLink setNumberOfLines:0];
    [projectLink setVerticalAlignment:VerticalAlignmentTop];
    [self addSubview:projectLink];
    [self.gainLabelArrayM addObject:projectLink];
    return projectLink;
}
- (void)drawVercitalLineX:(CGFloat)X Y:(CGFloat)Y height:(CGFloat)height tag:(NSInteger)tag
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
        [_titleLabel setText:@"项目经验"];
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
- (NSMutableArray *)companyLabelArrayM
{
    if ( !_companyLabelArrayM )
    {
        _companyLabelArrayM = [NSMutableArray array];
    }
    return _companyLabelArrayM;
}
- (NSMutableArray *)positionLabelArrayM
{
    if ( !_positionLabelArrayM )
    {
        _positionLabelArrayM = [NSMutableArray array];
    }
    return _positionLabelArrayM;
}
- (NSMutableArray *)verLineArrayM
{
    if ( !_verLineArrayM )
    {
        _verLineArrayM = [NSMutableArray array];
    }
    return _verLineArrayM;
}
- (NSMutableArray *)describeLabelArrayM
{
    if ( !_describeLabelArrayM )
    {
        _describeLabelArrayM = [NSMutableArray array];
    }
    return _describeLabelArrayM;
}
- (NSMutableArray *)projectLinkLabelArrayM
{
    if ( !_projectLinkLabelArrayM )
    {
        _projectLinkLabelArrayM = [NSMutableArray array];
    }
    return _projectLinkLabelArrayM;
}
- (NSMutableArray *)scientiticLabelArrayM
{
    if ( !_scientiticLabelArrayM )
    {
        _scientiticLabelArrayM = [NSMutableArray array];
    }
    return _scientiticLabelArrayM;
}
- (NSMutableArray *)gainLabelArrayM
{
    if ( !_gainLabelArrayM )
    {
        _gainLabelArrayM = [NSMutableArray array];
    }
    return _gainLabelArrayM;
}
@end