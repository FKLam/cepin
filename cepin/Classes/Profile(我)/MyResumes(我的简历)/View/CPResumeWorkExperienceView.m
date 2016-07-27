//
//  CPResumeWorkExperienceView.m
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeWorkExperienceView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "NSDate-Utilities.h"
#import "CPResumeEditReformer.h"
#import "CPCommon.h"
@interface CPResumeWorkExperienceView ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *guessLabel;
@property (nonatomic, strong) UIImageView *mustWriteImageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) NSMutableArray *timeCycleArrayM;
@property (nonatomic, strong) NSMutableArray *timeLabelArrayM;
@property (nonatomic, strong) NSMutableArray *companyLabelArrayM;
@property (nonatomic, strong) NSMutableArray *positionLabelArrayM;
@property (nonatomic, strong) NSMutableArray *describeLabelArrayM;
@property (nonatomic, strong) NSMutableArray *verLineArrayM;
@end
@implementation CPResumeWorkExperienceView
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
- (void)configWithResume:(ResumeNameModel *)resumeModel title:(NSString *)title hideMustWriteFlag:(BOOL)hideFlag
{
    if ( title && 0 < [title length] )
    {
        [self.guessLabel setText:title];
        [self.addMoreButton setTitle:@"添加实习经历" forState:UIControlStateNormal];
    }
    [self.mustWriteImageView setHidden:hideFlag];
    [self configWithResume:resumeModel];
}
- (void)configWithResume:(ResumeNameModel *)resumeModel
{
    [self reSet:resumeModel];
    _resumeModel = resumeModel;
    NSMutableArray<WorkListDateModel> *workList = _resumeModel.WorkList;
    if ( 0 == [workList count] )
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
    CGFloat Y = 60 / CP_GLOBALSCALE + CGRectGetMaxY(self.topView.frame);
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
    for ( WorkListDateModel *work in workList)
    {
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
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        companyLabel = [self reuseCompanyLableWithTag:tag];
        [companyLabel setText:[work valueForKey:@"Company"]];
        [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( timeLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( timeLabel.mas_left );
            make.right.equalTo( timeLabel.mas_right );
        }];
        positionLabel = [self reusePositionLabelWithTag:tag];
        NSMutableString *positonStr = [NSMutableString stringWithFormat:@"%@  |  %@", [work valueForKey:@"JobFunction"], [work valueForKey:@"Industry"]];
        if ( 2 == [resumeModel.ResumeType intValue] )
        {
            [positonStr appendFormat:@"  |  %@", [work valueForKey:@"Nature"]];
        }
        CGFloat positionH = [CPResumeEditReformer workPositionHeight:work resumeType:resumeModel.ResumeType];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        if ( (36 / CP_GLOBALSCALE * 2) < positionH )
            [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        else
            [paragraphStyle setLineSpacing:0.0];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:positonStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}];
        [positionLabel setAttributedText:attStr];
        [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( companyLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( companyLabel.mas_left );
            make.right.equalTo( companyLabel.mas_right );
        }];
        temp = (36 + 40 + 36 + 20 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE + positionH;
        if ( ![[work valueForKey:@"Content"] isKindOfClass:[NSNull class]] && 1 == [resumeModel.ResumeType intValue] )
        {
            if ( 0 == [[work valueForKey:@"Content"] length] )
                continue;
            CGFloat describeH = [CPResumeEditReformer workDescribeHeight:work];
            describeLabel = [self reuseDescribeLabelWithTag:tag];
            [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( positionLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                make.left.equalTo( positionLabel.mas_left );
                make.right.equalTo( positionLabel.mas_right );
                make.height.equalTo( @( describeH ) );
            }];
            NSString *preStr = @"工作描述 : ";
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", preStr, [work valueForKey:@"Content"]]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
            [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, [attStr length])];
            [describeLabel setAttributedText:attStr];
            temp += ( 40 ) / CP_GLOBALSCALE + describeH;
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
        [self.timeCycleArrayM removeAllObjects];
        [self.timeLabelArrayM removeAllObjects];
        [self.companyLabelArrayM removeAllObjects];
        [self.positionLabelArrayM removeAllObjects];
        [self.describeLabelArrayM removeAllObjects];
        [self.verLineArrayM removeAllObjects];
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
    [describeLabel setNumberOfLines:2];
    [describeLabel setVerticalAlignment:VerticalAlignmentTop];
    [describeLabel setTag:tag];
    [_whiteBackgroundView addSubview:describeLabel];
    [self.describeLabelArrayM addObject:describeLabel];
    return describeLabel;
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
    [_whiteBackgroundView addSubview:companyLabel];
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
    [_whiteBackgroundView addSubview:positionLabel];
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
        [_guessLabel setText:@"工作经历"];
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
- (CPResumeMoreButton *)addMoreButton
{
    if ( !_addMoreButton )
    {
        _addMoreButton = [CPResumeMoreButton buttonWithType:UIButtonTypeCustom];
        [_addMoreButton setBackgroundColor:[UIColor clearColor]];
        [_addMoreButton setTitle:@"添加工作经历" forState:UIControlStateNormal];
        [_addMoreButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_addMoreButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_addMoreButton setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [_addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeMoreButton *sender) {
            
        }];
    }
    return _addMoreButton;
}
@end


