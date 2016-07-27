//
//  CPReusmeReviewTrainView.m
//  cepin
//
//  Created by ceping on 16/2/5.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPReusmeReviewTrainView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPResumeReviewReformer.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@interface CPReusmeReviewTrainView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@property (nonatomic, strong) NSMutableArray *timeCycleArrayM;
@property (nonatomic, strong) NSMutableArray *verLineArrayM;
@property (nonatomic, strong) NSMutableArray *timeLabelArrayM;
@property (nonatomic, strong) NSMutableArray *practiceNameArrayM;
@property (nonatomic, strong) NSMutableArray *describeLabelArrayM;
@end
@implementation CPReusmeReviewTrainView
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
    NSMutableArray<TrainingDataModel> *trainList = _resumeModel.TrainingList;
    CGFloat X = 30 / CP_GLOBALSCALE;
    CGFloat Y = 50 / CP_GLOBALSCALE + CGRectGetMaxY(self.titleLabel.frame);
    CGFloat lineY = Y;
    CGFloat LineX = X;
    UIImageView *timeCycle = nil;
    UILabel *timeLabel = nil;
    UILabel *practiceNameLabel = nil;
    CPPositionDetailDescribeLabel *practiceDescribeLabel = nil;
    CGFloat temp = 0.0;
    NSUInteger modelCount = 0;
    NSUInteger totalCount = [trainList count];
    NSInteger tag = 0;
    [self.secondSeparatorLine setHidden:YES];
    [self.separatorLine setHidden:YES];
    for ( TrainingDataModel *train in trainList )
    {
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
        NSString *startime =  [NSDate cepinYMDFromString:[train valueForKey:@"StartDate"]];
        NSString *endTime = [NSDate cepinYMDFromString:[train valueForKey:@"EndDate"]];
        if (!endTime || [endTime isEqualToString:@""]) {
            endTime = @"至今";
        }
        NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
        [timeLabel setText:time];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( timeCycle.mas_centerY );
            make.left.equalTo( timeCycle.mas_right ).offset( 45 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        practiceNameLabel = [self reusePracticeNameLableWithTag:tag];
        NSString *name = [train valueForKey:@"Name"];
        NSString *organization = [train valueForKey:@"Organization"];
        if ( ![organization isKindOfClass:[NSNull class]] )
            [practiceNameLabel setText:[NSString stringWithFormat:@"%@  |  %@", name, organization]];
        else
            [practiceNameLabel setText:name];
        [practiceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( timeLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( timeLabel.mas_left );
            make.right.equalTo( timeLabel.mas_right );
        }];
        temp = (36 + 40 + 36 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
        if (  ![[train valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
        {
            if ( 0 == [[train valueForKey:@"Content"] length] )
                continue;
            CGFloat describeH = [CPResumeReviewReformer reviewTrainContentHeight:train];
            practiceDescribeLabel = [self reuseDescribeLabelWithTag:tag];
            [practiceDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( practiceNameLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                make.left.equalTo( practiceNameLabel.mas_left );
                make.right.equalTo( practiceNameLabel.mas_right );
            }];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[train valueForKey:@"Content"]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
            [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, [attStr length])];
            [practiceDescribeLabel setAttributedText:attStr];
            temp += ( 40 ) / CP_GLOBALSCALE + describeH;
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
        for ( id obj in self.verLineArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.timeLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.practiceNameArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.describeLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        [self.timeCycleArrayM removeAllObjects];
        [self.verLineArrayM removeAllObjects];
        [self.timeLabelArrayM removeAllObjects];
        [self.practiceNameArrayM removeAllObjects];
        [self.describeLabelArrayM removeAllObjects];
    }
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
- (void)drawVercitalLineX:(CGFloat)X Y:(CGFloat)Y height:(CGFloat)height
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(X + 48 / CP_GLOBALSCALE / 2.0 - 3 / CP_GLOBALSCALE / 2.0, Y + 48 / CP_GLOBALSCALE - 1.0, 3 / CP_GLOBALSCALE, height)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"dddddd"]];
    [self addSubview:line];
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
- (UILabel *)reusePracticeNameLableWithTag:(NSInteger)tag
{
    for (UILabel *companyLabel in self.practiceNameArrayM )
    {
        if ( companyLabel.tag == tag )
            return companyLabel;
    }
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [companyLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [companyLabel setTag:tag];
    [self addSubview:companyLabel];
    [self.practiceNameArrayM addObject:companyLabel];
    return companyLabel;
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
    [describeLabel setNumberOfLines:0];
    [describeLabel setVerticalAlignment:VerticalAlignmentTop];
    [describeLabel setTag:tag];
    [self addSubview:describeLabel];
    [self.describeLabelArrayM addObject:describeLabel];
    return describeLabel;
}
#pragma mark - getter methods
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setText:@"培训经历"];
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
- (NSMutableArray *)verLineArrayM
{
    if ( !_verLineArrayM )
    {
        _verLineArrayM = [NSMutableArray array];
    }
    return _verLineArrayM;
}
- (NSMutableArray *)timeLabelArrayM
{
    if ( !_timeLabelArrayM )
    {
        _timeLabelArrayM = [NSMutableArray array];
    }
    return _timeLabelArrayM;
}
- (NSMutableArray *)describeLabelArrayM
{
    if ( !_describeLabelArrayM )
    {
        _describeLabelArrayM = [NSMutableArray array];
    }
    return _describeLabelArrayM;
}
- (NSMutableArray *)practiceNameArrayM
{
    if ( !_practiceNameArrayM )
    {
        _practiceNameArrayM = [NSMutableArray array];
    }
    return _practiceNameArrayM;
}
@end
