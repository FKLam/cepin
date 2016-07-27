//
//  CPResumeReviewStudyView.m
//  cepin
//
//  Created by ceping on 16/2/5.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeReviewStudyView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "NSDate-Utilities.h"
#import "CPResumeReviewReformer.h"
#import "CPCommon.h"
@interface CPResumeReviewStudyView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@property (nonatomic, strong) NSMutableArray *timeCycleArrayM;
@property (nonatomic, strong) NSMutableArray *timeLabelArrayM;
@property (nonatomic, strong) NSMutableArray *companyLabelArrayM;
@property (nonatomic, strong) NSMutableArray *positionLabelArrayM;
@property (nonatomic, strong) NSMutableArray *describeLabelArrayM;
@property (nonatomic, strong) NSMutableArray *verLineArrayM;
@property (nonatomic, strong) NSMutableArray *proveCompanyArrayM;
@property (nonatomic, strong) NSMutableArray *proveManStaticArrayM;
@property (nonatomic, strong) NSMutableArray *proveManArrayM;
@property (nonatomic, strong) NSMutableArray *proveCompanyStaticArrayM;
@end
@implementation CPResumeReviewStudyView
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
    NSMutableArray<WorkListDateModel> *workList = _resumeModel.WorkList;
    CGFloat X = 30 / CP_GLOBALSCALE;
    CGFloat Y = 50 / CP_GLOBALSCALE + CGRectGetMaxY(self.titleLabel.frame) + 2 / CP_GLOBALSCALE;
    CGFloat lineY = Y;
    CGFloat LineX = X;
    UIImageView *timeCycle = nil;
    UILabel *timeLabel = nil;
    UILabel *companyLabel = nil;
    UILabel *positionLabel = nil;
    CGFloat temp = 0.0;
    NSUInteger modelCount = 0;
    NSUInteger totalCount = [workList count];
    NSInteger tag = 0;
    CPPositionDetailDescribeLabel *describeLabel = nil;
    CPPositionDetailDescribeLabel *proveCompanyLabel = nil;
    UILabel *proveManStaticLabel = nil;
    UILabel *proveCompanyStaticLabel = nil;
    [self.secondSeparatorLine setHidden:YES];
    [self.separatorLine setHidden:YES];
    for ( WorkListDateModel *work in workList)
    {
        if ( self.separatorLine.isHidden )
            [self.separatorLine setHidden:NO];
        if ( self.secondSeparatorLine.isHidden )
            [self.secondSeparatorLine setHidden:NO];
        if ( [self.titleLabel isHidden] )
            [self.titleLabel setHidden:NO];
        if ( 0 < modelCount && modelCount < totalCount)
        {
            [self drawVercitalLineX:LineX Y:lineY height:temp tag:(NSInteger)tag];
        }
        lineY = Y;
        temp = 0.0;
        CGRect frame = CGRectMake(X, Y, 48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
        timeCycle = [self reuserImageViewWithTag:tag frame:frame];
        timeLabel = [self reuseOriginLabelWithTag:tag];
        NSString *startime =  [NSDate cepinYMDFromString:[work valueForKey:@"StartDate"]];
        NSString *endTime = [NSDate cepinYMDFromString:[work valueForKey:@"EndDate"]];
        if (!endTime || [endTime isEqualToString:@""]) {
            endTime = @"至今";
        }
        NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
        [timeLabel setText:time];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( timeCycle.mas_centerY );
            make.left.equalTo( timeCycle.mas_right ).offset( 45 / CP_GLOBALSCALE );
            make.height.equalTo( @( timeLabel.font.pointSize ) );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        companyLabel = [self reuseCompanyLableWithTag:tag];
        [companyLabel setText:[work valueForKey:@"Company"]];
        [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( timeLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( timeLabel.mas_left );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        positionLabel = [self reusePositionLabelWithTag:tag];
        NSMutableString *positonStr = [NSMutableString stringWithFormat:@"%@  |  %@", [work valueForKey:@"JobFunction"], [work valueForKey:@"Industry"]];
        if ( 2 == [resumeModel.ResumeType intValue] )
        {
            [positonStr appendFormat:@"  |  %@", [work valueForKey:@"Nature"]];
        }
        [positionLabel setText:positonStr];
        [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( companyLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( companyLabel.mas_left );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        temp = (36 + 40 + 36 + 20 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE + [CPResumeReviewReformer reviewStudyTypeHeight:work resume:resumeModel];
        if ( ![[work valueForKey:@"AttestorName"] isKindOfClass:[NSNull class]] )
        {
            proveManStaticLabel = [self reuseManStaticLabelWithTag:tag];
            [proveManStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( positionLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                make.left.equalTo( positionLabel.mas_left );
                make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            }];
            CGFloat describeH = [CPResumeReviewReformer reviewStudyProveHeight:work];
            describeLabel = [self reuseDescribeLabelWithTag:tag];
            [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( positionLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                make.left.equalTo( proveManStaticLabel.mas_right );
                make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            }];
            [self setProveManLabel:describeLabel study:work];
            temp += ( 20 ) / CP_GLOBALSCALE + describeH;
            if ( ![[work valueForKey:@"AttestorCompany"] isKindOfClass:[NSNull class]] )
            {
                proveCompanyStaticLabel = [self reuseCompanyStaticLabelWithTag:tag];
                [proveCompanyStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( describeLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
                    make.left.equalTo( positionLabel.mas_left );
                    make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
                }];
                proveCompanyLabel = [self reuseProveCompanyLabelWithTag:tag];
                [proveCompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( describeLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
                    make.left.equalTo( proveCompanyStaticLabel.mas_right );
                    make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
                }];
                [self setProveCompanyLabel:proveCompanyLabel study:work];
                temp += [CPResumeReviewReformer reviewStudyProveCompanyHeight:work];
            }
        }
        else
        {
            if ( ![[work valueForKey:@"AttestorCompany"] isKindOfClass:[NSNull class]] )
            {
                proveCompanyStaticLabel = [self reuseCompanyStaticLabelWithTag:tag];
                [proveCompanyStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( positionLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                    make.left.equalTo( positionLabel.mas_left );
                    make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
                }];
                proveCompanyLabel = [self reuseProveCompanyLabelWithTag:tag];
                [proveCompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo( positionLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                    make.left.equalTo( proveCompanyStaticLabel.mas_right );
                    make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
                }];
                [self setProveCompanyLabel:proveCompanyLabel study:work];
                temp += [CPResumeReviewReformer reviewStudyProveCompanyHeight:work];
            }
        }
        Y += temp;
        modelCount++;
        tag++;
    }
}
//        *AttestorName;//	String	证明人姓名
//        *AttestorRelation;//	String	证明人关系
//        *AttestorPosition ;//	String	证明人职务
//        *AttestorCompany ;//	String	证明人单位
//        *AttestorPhone ;//	String	证明人电话
- (void)setProveCompanyLabel:(CPPositionDetailDescribeLabel *)label study:(WorkListDateModel *)study
{
    if (  [[study valueForKey:@"AttestorCompany"] isKindOfClass:[NSNull class]] )
        return;
    NSMutableString *strM = [[NSMutableString alloc] init];
    [strM appendString:[study valueForKey:@"AttestorCompany"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:strM];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    [label setAttributedText:attStr];
}
- (void)setProveManLabel:(CPPositionDetailDescribeLabel *)label study:(WorkListDateModel *)study
{
    if (  [[study valueForKey:@"AttestorName"] isKindOfClass:[NSNull class]] )
        return;
    NSMutableString *strM = [[NSMutableString alloc] init];
    [strM appendString:[study valueForKey:@"AttestorName"]];
    [strM appendString:[NSString stringWithFormat:@" /%@\n", [study valueForKey:@"AttestorRelation"]]];
    [strM appendString:[NSString stringWithFormat:@"%@ /%@", [study valueForKey:@"AttestorPosition"], [study valueForKey:@"AttestorPhone"]]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:strM];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    [label setAttributedText:attStr];
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
        for(id obj in self.companyLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.proveCompanyStaticArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.proveManStaticArrayM )
        {
            [obj removeFromSuperview];
        }
        [self.timeCycleArrayM removeAllObjects];
        [self.timeLabelArrayM removeAllObjects];
        [self.companyLabelArrayM removeAllObjects];
        [self.positionLabelArrayM removeAllObjects];
        [self.describeLabelArrayM removeAllObjects];
        [self.verLineArrayM removeAllObjects];
        [self.companyLabelArrayM removeAllObjects];
        [self.proveManStaticArrayM removeAllObjects];
        [self.proveCompanyStaticArrayM removeAllObjects];
    }
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
- (CPPositionDetailDescribeLabel *)reuseProveCompanyLabelWithTag:(NSInteger)tag
{
    for( CPPositionDetailDescribeLabel *label in self.proveCompanyArrayM )
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
    [self.proveCompanyArrayM addObject:describeLabel];
    return describeLabel;
}
- (UILabel *)reuseManStaticLabelWithTag:(NSInteger)tag
{
    for (UILabel *companyLabel in self.proveManStaticArrayM )
    {
        if ( companyLabel.tag == tag )
            return companyLabel;
    }
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [companyLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [companyLabel setTag:tag];
    [companyLabel setText:@"证明人 : "];
    [self addSubview:companyLabel];
    [self.proveManStaticArrayM addObject:companyLabel];
    return companyLabel;
}
- (UILabel *)reuseCompanyStaticLabelWithTag:(NSInteger)tag
{
    for (UILabel *companyLabel in self.proveCompanyStaticArrayM )
    {
        if ( companyLabel.tag == tag )
            return companyLabel;
    }
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [companyLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [companyLabel setTag:tag];
    [companyLabel setText:@"证明人单位 : "];
    [self addSubview:companyLabel];
    [self.proveCompanyStaticArrayM addObject:companyLabel];
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
- (UILabel *)reusePositionLabelWithTag:(NSInteger)tag
{
    for (UILabel *positionLabel in self.positionLabelArrayM )
    {
        if ( positionLabel.tag == tag )
            return positionLabel;
    }
    UILabel *positionLabel = [[UILabel alloc] init];
    [positionLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [positionLabel setTag:tag];
    [positionLabel setNumberOfLines:0];
    [self addSubview:positionLabel];
    [self.positionLabelArrayM addObject:positionLabel];
    return positionLabel;
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
        [_titleLabel setText:@"实习经历"];
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
- (NSMutableArray *)proveCompanyArrayM
{
    if ( !_proveCompanyArrayM )
    {
        _proveCompanyArrayM = [NSMutableArray array];
    }
    return _proveCompanyArrayM;
}
- (NSMutableArray *)proveCompanyStaticArrayM
{
    if ( !_proveCompanyStaticArrayM )
    {
        _proveCompanyStaticArrayM = [NSMutableArray array];
    }
    return _proveCompanyStaticArrayM;
}
- (NSMutableArray *)proveManStaticArrayM
{
    if ( !_proveManStaticArrayM )
    {
        _proveManStaticArrayM = [NSMutableArray array];
    }
    return _proveManStaticArrayM;
}
- (NSMutableArray *)proveManArrayM
{
    if ( !_proveManArrayM )
    {
        _proveManArrayM = [NSMutableArray array];
    }
    return _proveManArrayM;
}
@end