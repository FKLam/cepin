//
//  CPResumeReviewSkillView.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeReviewSkillView.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPResumeEditReformer.h"
#import "CPCommon.h"
@interface CPResumeReviewSkillView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) NSMutableArray *timeCycleArrayM;
@property (nonatomic, strong) NSMutableArray *companyLabelArrayM;
@property (nonatomic, strong) NSMutableArray *verLineArrayM;
@property (nonatomic, strong) NSMutableArray *credentialLabelArrayM;
@property (nonatomic, strong) NSMutableArray *CETLabelArrayM;
@property (nonatomic, strong) NSMutableArray *langageArrayM;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@end
@implementation CPResumeReviewSkillView
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
- (void)configWithResume:(id)resumeModel
{
    [self reSet:resumeModel];
    _resumeModel = resumeModel;
    NSMutableArray<CredentialListDataModel> *majorList = _resumeModel.CredentialList;
    NSMutableArray<SkillDataModel> *skillList = _resumeModel.SkillList;
    NSMutableArray<LanguageDataModel> *languageList = _resumeModel.LanguageList;
    NSDictionary *cetKeyValueDict = [CPResumeEditReformer CETKeyValueDict:resumeModel];
    CGFloat X = 30 / CP_GLOBALSCALE;
    CGFloat Y = 50 / CP_GLOBALSCALE + CGRectGetMaxY(self.titleLabel.frame);
    CGFloat lineY = Y;
    CGFloat LineX = X;
    UIImageView *timeCycle = nil;
    CPPositionDetailDescribeLabel *skillLabel = nil;
    CPPositionDetailDescribeLabel *credentialLabel = nil;
    UILabel *cetLabel = nil;
    UILabel *langageLabel = nil;
    CGFloat temp = 0.0;
    NSUInteger modelCount = 0;
    NSUInteger totalCount = [majorList count] + [skillList count] + [cetKeyValueDict count] + [languageList count];
    NSInteger tag = 0;
    [self.separatorLine setHidden:YES];
    [self.secondSeparatorLine setHidden:YES];
    for ( CredentialListDataModel *credential in majorList )
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
        credentialLabel = [self reuseRedentialLableWithTag:tag];
        NSString *startTime = [credential valueForKey:@"Date"];
        startTime = [[startTime replaceString:@"-" toString:@"."] substringToIndex:startTime.length - 3];
        NSString *endTime = nil;
        if ( ![[credential valueForKey:@"ExpirationDate"] isKindOfClass:[NSNull class]] )
        {
            endTime = [credential valueForKey:@"ExpirationDate"];
        }
        if ( 0 < [endTime length] )
        {
            endTime = [[endTime replaceString:@"-" toString:@"."] substringToIndex:endTime.length - 3];
        }
        else
        {
            endTime = @"至今";
        }
        NSString *timeStr = [NSString stringWithFormat:@"%@", startTime];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]} range:NSMakeRange(0, [attStr length])];
        NSString *credentialFlagStr = @"  |  专业证书\n";
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:credentialFlagStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}]];
        if ( ![[credential valueForKey:@"Name"] isKindOfClass:[NSNull class]] )
        {
            NSAttributedString *attNameStr = [[NSAttributedString alloc] initWithString:[credential valueForKey:@"Name"] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}];
            [attStr appendAttributedString:attNameStr];
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
        [attStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
        [credentialLabel setAttributedText:attStr];
        [credentialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( timeCycle.mas_top ).offset( 1 / 2.0 );
            make.left.equalTo( timeCycle.mas_right ).offset( 45 / CP_GLOBALSCALE );
            make.height.equalTo( @( [CPResumeEditReformer credentialHeight:credential] - 60 / CP_GLOBALSCALE) );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        temp = [CPResumeEditReformer credentialHeight:credential];
        Y += temp;
        modelCount++;
        tag++;
    }
    for ( SkillDataModel *skill in skillList )
    {
        if ( self.separatorLine.isHidden )
            [self.separatorLine setHidden:NO];
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
        skillLabel = [self reuseCompanyLableWithTag:tag];
        NSString *skillName = [skill valueForKey:@"Name"];
        NSString *skillLevel = [skill valueForKey:@"MasteryLevel"];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:skillName attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  |  %@", skillLevel] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}]];
        [skillLabel setAttributedText:attStr];
        [skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( timeCycle.mas_top ).offset( 1 / 2.0 );
            make.left.equalTo( timeCycle.mas_right ).offset( 45 / CP_GLOBALSCALE );
            make.height.equalTo( @( [CPResumeEditReformer skillHeight:skill] - 60 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        temp = [CPResumeEditReformer skillHeight:skill];
        Y += temp;
        modelCount++;
        tag++;
    }
    NSArray *AllKeyArray = [cetKeyValueDict allKeys];
    for ( NSString *key in AllKeyArray )
    {
        if ( self.separatorLine.isHidden )
            [self.separatorLine setHidden:NO];
        if ( [self.titleLabel isHidden] )
            [self.titleLabel setHidden:NO];
        NSNumber *score = [cetKeyValueDict valueForKey:key];
        if ( 0 < modelCount && modelCount < totalCount)
        {
            [self drawVercitalLineX:LineX Y:lineY height:temp tag:tag];
        }
        lineY = Y;
        temp = 0.0;
        CGRect frame = CGRectMake(X, Y, 48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
        timeCycle = [self reuserImageViewWithTag:tag frame:frame];
        cetLabel = [self reuseCETLableWithTag:tag];
        NSString *preStr = @"英语";
        NSString *scoreStr = [NSString stringWithFormat:@"  |  %@（%@分）", key, [score stringValue]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:preStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:scoreStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}]];
        [cetLabel setAttributedText:attStr];
        [cetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( timeCycle.mas_centerY );
            make.left.equalTo( timeCycle.mas_right ).offset( 45 / CP_GLOBALSCALE );
            make.height.equalTo( @( [CPResumeEditReformer CETKeyValueHeigt] - 60 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        temp = [CPResumeEditReformer CETKeyValueHeigt];
        Y += temp;
        modelCount++;
        tag++;
    }
    for ( LanguageDataModel *langage in languageList )
    {
        if ( self.separatorLine.isHidden )
            [self.separatorLine setHidden:NO];
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
        langageLabel = [self reuseLangageLableWithTag:tag];
        NSString *langageName = [langage valueForKey:@"Name"];
        NSString *stateStr = [NSString stringWithFormat:@"  |  听说%@、读写%@", [langage valueForKey:@"Speaking"], [langage valueForKey:@"Writing"]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:langageName attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:stateStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}]];
        [langageLabel setAttributedText:attStr];
        [langageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( timeCycle.mas_centerY );
            make.left.equalTo( timeCycle.mas_right ).offset( 45 / CP_GLOBALSCALE );
            make.height.equalTo( @( [CPResumeEditReformer langageHeight:langage] - 60 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        temp = [CPResumeEditReformer langageHeight:langage];
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
        for(id obj in self.companyLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for(id obj in self.verLineArrayM )
        {
            [obj removeFromSuperview];
        }
        for (id obj in self.credentialLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for ( id obj in self.CETLabelArrayM )
        {
            [obj removeFromSuperview];
        }
        for ( id obj in self.langageArrayM )
        {
            [obj removeFromSuperview];
        }
        [self.timeCycleArrayM removeAllObjects];
        [self.companyLabelArrayM removeAllObjects];
        [self.verLineArrayM removeAllObjects];
        [self.credentialLabelArrayM removeAllObjects];
        [self.CETLabelArrayM removeAllObjects];
        [self.langageArrayM removeAllObjects];
    }
}
- (UILabel *)reuseLangageLableWithTag:(NSInteger)tag
{
    for (UILabel *companyLabel in self.CETLabelArrayM )
    {
        if ( companyLabel.tag == tag )
            return companyLabel;
    }
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [companyLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [companyLabel setTag:tag];
    [self addSubview:companyLabel];
    [self.langageArrayM addObject:companyLabel];
    return companyLabel;
}
- (UILabel *)reuseCETLableWithTag:(NSInteger)tag
{
    for (UILabel *companyLabel in self.CETLabelArrayM )
    {
        if ( companyLabel.tag == tag )
            return companyLabel;
    }
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [companyLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [companyLabel setTag:tag];
    [self addSubview:companyLabel];
    [self.CETLabelArrayM addObject:companyLabel];
    return companyLabel;
}
- (CPPositionDetailDescribeLabel *)reuseRedentialLableWithTag:(NSInteger)tag
{
    for (CPPositionDetailDescribeLabel *companyLabel in self.credentialLabelArrayM )
    {
        if ( companyLabel.tag == tag )
            return companyLabel;
    }
    CPPositionDetailDescribeLabel *companyLabel = [[CPPositionDetailDescribeLabel alloc] init];
    [companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [companyLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [companyLabel setTag:tag];
    [companyLabel setNumberOfLines:0];
    [companyLabel setVerticalAlignment:VerticalAlignmentTop];
    [self addSubview:companyLabel];
    [self.credentialLabelArrayM addObject:companyLabel];
    return companyLabel;
}
- (CPPositionDetailDescribeLabel *)reuseCompanyLableWithTag:(NSInteger)tag
{
    for (CPPositionDetailDescribeLabel *companyLabel in self.companyLabelArrayM )
    {
        if ( companyLabel.tag == tag )
            return companyLabel;
    }
    CPPositionDetailDescribeLabel *companyLabel = [[CPPositionDetailDescribeLabel alloc] init];
    [companyLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [companyLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    [companyLabel setTag:tag];
    [companyLabel setVerticalAlignment:VerticalAlignmentTop];
    [companyLabel setNumberOfLines:1];
    [self addSubview:companyLabel];
    [self.companyLabelArrayM addObject:companyLabel];
    return companyLabel;
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
#pragma mark - getter methods
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setText:@"相关技能"];
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
- (NSMutableArray *)companyLabelArrayM
{
    if ( !_companyLabelArrayM )
    {
        _companyLabelArrayM = [NSMutableArray array];
    }
    return _companyLabelArrayM;
}
- (NSMutableArray *)verLineArrayM
{
    if ( !_verLineArrayM )
    {
        _verLineArrayM = [NSMutableArray array];
    }
    return _verLineArrayM;
}
- (NSMutableArray *)credentialLabelArrayM
{
    if ( !_credentialLabelArrayM )
    {
        _credentialLabelArrayM = [NSMutableArray array];
    }
    return _credentialLabelArrayM;
}
- (NSMutableArray *)CETLabelArrayM
{
    if ( !_CETLabelArrayM )
    {
        _CETLabelArrayM = [NSMutableArray array];
    }
    return _CETLabelArrayM;
}
- (NSMutableArray *)langageArrayM
{
    if ( !_langageArrayM )
    {
        _langageArrayM = [NSMutableArray array];
    }
    return _langageArrayM;
}
@end