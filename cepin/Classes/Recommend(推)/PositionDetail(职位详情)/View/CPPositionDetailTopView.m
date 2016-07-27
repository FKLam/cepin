//
//  CPPositionDetailTopView.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPositionDetailTopView.h"
#import "CPPositionDetailWelfare.h"
#import "CPCommon.h"
@interface CPPositionDetailTopView ()

@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIImageView *schoolImageView;
@property (nonatomic, strong) UILabel *salaryLabel;
@property (nonatomic, strong) UIImageView *locationView;
@property (nonatomic, strong) UIImageView *experienceView;
@property (nonatomic, strong) UIImageView *degreeView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *experienceLabel;
@property (nonatomic, strong) UILabel *degreeLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) CPPositionDetailWelfare *welfarePositionView;
@property (nonatomic, strong) UIView *companyBackgroundView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *addressAndPeopleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIButton *companyDetailButton;
@property (nonatomic, strong) NSDictionary *position;
@property (nonatomic, strong) NSMutableArray *labelArrayM;
@property (nonatomic, strong) CPWXinsanbanButton *xinsanbanButton;
@end
@implementation CPPositionDetailTopView
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self addSubview:self.xinsanbanButton];
        [self addSubview:self.positionLabel];
        [self addSubview:self.schoolImageView];
        [self addSubview:self.salaryLabel];
        [self addSubview:self.locationView];
        [self addSubview:self.locationLabel];
        [self addSubview:self.experienceView];
        [self addSubview:self.experienceLabel];
        [self addSubview:self.degreeView];
        [self addSubview:self.degreeLabel];
        [self addSubview:self.welfarePositionView];
        [self addSubview:self.separatorLine];
        [self.xinsanbanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.right.equalTo( self.mas_right );
            make.width.equalTo( @( 160 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 160 / CP_GLOBALSCALE ) );
        }];
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.salaryLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.salaryLabel.mas_right ).offset( 25 / CP_GLOBALSCALE );
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
        [self.welfarePositionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.salaryLabel.mas_bottom );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
        }];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.welfarePositionView.mas_bottom ).offset(60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [self addSubview:self.companyBackgroundView];
        [self.companyBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.separatorLine.mas_bottom );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.bottom.equalTo( self.mas_bottom );
        }];
    }
    return self;
}
- (void)configWithPosition:(NSDictionary *)position
{
    _position = position;
    NSString *name = [position valueForKey:@"PositionName"];
    [self.positionLabel setText:name];
    CGFloat maxW;
    NSNumber *type = [_position valueForKey:@"PositionType"];
    NSString *isXinsanbanString = [_position valueForKey:@"IsListedCompany"];
    if ( [isXinsanbanString isKindOfClass:[NSNull class]] || !isXinsanbanString || [isXinsanbanString isEqualToString:@"0"] )
    {
        if ( ![self.xinsanbanButton isHidden] )
            [self.xinsanbanButton setHidden:YES];
    }
    else if ( [isXinsanbanString isEqualToString:@"1"] )
    {
        if ( [self.xinsanbanButton isHidden] )
            [self.xinsanbanButton setHidden:NO];
    }
    if ( 2 != type.intValue )
    {
        self.schoolImageView.hidden = NO;
        maxW = kScreenWidth -(40 * 3+60 ) / CP_GLOBALSCALE;
    }
    else
    {
        self.schoolImageView.hidden = YES;
        maxW = kScreenWidth -(40*2) / CP_GLOBALSCALE;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.positionLabel.text attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"707070"], NSFontAttributeName : [UIFont systemFontOfSize:60 / CP_GLOBALSCALE]}];
//     根据获取到的字符串以及字体计算label需要的size
    CGSize strSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat positionW = strSize.width;
    CGFloat positionH = strSize.height;
    NSString *salaryString = [_position valueForKey:@"Salary"];
    [self.salaryLabel setText:salaryString];
    CGSize salarySize = [salaryString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]} context:nil].size;
    [self.positionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.mas_top ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.width.equalTo( @( positionW + 8 ) );
        make.height.equalTo( @( positionH ) );
    }];
    [self.schoolImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( self.positionLabel.mas_right ).offset( 20 / CP_GLOBALSCALE );
        make.centerY.equalTo( self.positionLabel.mas_centerY );
        make.width.equalTo( @( 60 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 60 / CP_GLOBALSCALE ) );
    }];
    [self.salaryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.positionLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE);
        make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( @( self.salaryLabel.font.pointSize ) );
        make.width.equalTo( @( salarySize.width + 5 / CP_GLOBALSCALE ) );
    }];
    [self.locationLabel setText:[_position valueForKey:@"City"]];
    [self.experienceLabel setText:[_position valueForKey:@"WorkYear"]];
    NSString *educationStr = nil;
    if ( ![[_position valueForKey:@"EducationLevel"] isKindOfClass:[NSNull class]] )
    {
        educationStr = [_position valueForKey:@"EducationLevel"];
    }
    if ( educationStr && 0 < [educationStr length] )
    {
        [self.degreeLabel setText:educationStr];
        [self.degreeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.salaryLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.experienceLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
        }];
        [self.degreeView setHidden:NO];
    }
    else
    {
        [self.degreeView setHidden:YES];
        [self.degreeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.salaryLabel.mas_centerY );
            make.width.equalTo( @( 0 ) );
            make.height.equalTo( @( 0 ) );
            make.left.equalTo( self.experienceLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
        }];
    }
    [self.companyLabel setText:[_position valueForKey:@"CompanyName"]];
    NSString *logoUrlStr = nil;
    if ( ![[_position valueForKey:@"CompanyLogoUrl"] isKindOfClass:[NSNull class]] )
        logoUrlStr = [_position valueForKey:@"CompanyLogoUrl"];
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logoUrlStr] placeholderImage:[UIImage imageNamed:@"null_logo"]];
    [self.addressAndPeopleLabel setText:[NSString stringWithFormat:@"%@  |  %@", [_position valueForKey:@"CompanyCity"], [_position valueForKey:@"CompanySize"]]];
    //职位诱惑
    NSArray *tag = [_position valueForKey:@"Tags"];
    if(nil == tag || NULL == tag || tag.count ==0 || [tag isKindOfClass:[NSNull class]]){
        [self.welfarePositionView setHidden:YES];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.salaryLabel.mas_bottom ).offset(60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        
    }
    else
    {
        //有职位诱惑
        CGFloat buttonH = ( 15 + 15 + 32 ) / CP_GLOBALSCALE;
        [self.welfarePositionView configWithArray:tag];
        [self.welfarePositionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.salaryLabel.mas_bottom).offset(40/CP_GLOBALSCALE);
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo(@(buttonH));
        }];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.salaryLabel.mas_bottom ).offset((60 / CP_GLOBALSCALE)+( 15 + 15 + 32 ) / CP_GLOBALSCALE+40/CP_GLOBALSCALE);
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }

//    CGFloat comMaxW = kScreenWidth -(140 +40+40+84+40 ) / 3.0;
    NSMutableParagraphStyle *comParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [comParagraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
    [comParagraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
//    NSMutableAttributedString *comAttStr = [[NSMutableAttributedString alloc] initWithString:self.positionLabel.text attributes:@{ NSParagraphStyleAttributeName : comParagraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"707070"], NSFontAttributeName : [UIFont systemFontOfSize:42 / 3.0]}];
    //     根据获取到的字符串以及字体计算label需要的size
//    CGSize comStrSize = [comAttStr boundingRectWithSize:CGSizeMake(comMaxW, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    CGFloat comPositionW = comStrSize.width;
//    CGFloat compositionH = comStrSize.height;
      [self.companyBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.separatorLine.mas_bottom );
        make.left.equalTo( self.mas_left );
        make.right.equalTo( self.mas_right );
        make.bottom.equalTo( self.mas_bottom );
    }];
}
- (CGFloat)companyWelfareHeightWithWalfearData:(NSArray *)companyData
{
    CGFloat height = 0;
    CGFloat buttonX = 40 / CP_GLOBALSCALE;
    CGFloat buttonY = 0;
    CGFloat buttonH = ( 15 + 15 + 32 ) / CP_GLOBALSCALE;
    CGFloat buttonW = 0;
    NSString *buttonTitle = nil;
    CGFloat maxX = kScreenWidth - 40 / CP_GLOBALSCALE;
    NSUInteger stop = 0;
    NSArray *welfareArray = companyData;
    BOOL isMultiRow = NO;
    if ( 0 == [welfareArray count] )
        return height;
    for ( NSUInteger index = 0; index < [welfareArray count]; index++ )
    {
        if ( 2 == stop )
            break;
        buttonTitle = welfareArray[index];
        buttonW = 15 / CP_GLOBALSCALE * 2 + 32 / CP_GLOBALSCALE * buttonTitle.length;
        if ( maxX < buttonW + buttonX )
            continue;
        buttonX += buttonW + 20 / CP_GLOBALSCALE;
        if ( buttonX > maxX )
        {
            stop++;
            buttonX = 40 / CP_GLOBALSCALE;
            buttonY += buttonH + 20 / CP_GLOBALSCALE;
            if ( !isMultiRow && index >= [welfareArray count] )
            {
                isMultiRow = YES;
            }
        }
    }
    if ( 0 == stop )
        height += buttonH;
    else
    {
        if ( isMultiRow )
            height += buttonH * 2.0 + 20 / CP_GLOBALSCALE;
        else
            height += buttonH;
    }
    return height;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.degreeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo( self.salaryLabel.mas_centerY );
        make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        make.left.equalTo( self.experienceLabel.mas_right ).offset( 30 / CP_GLOBALSCALE );
    }];
    CGSize salarySize = [self.salaryLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]} context:nil].size;
    CGSize locationSize = [self.locationLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGSize experienceSize = [self.experienceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGSize degreeSize = [self.degreeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
    CGFloat contentMaxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    CGFloat contentW = ( 48 + 10 + 30 ) * 3 / CP_GLOBALSCALE + salarySize.width + locationSize.width + experienceSize.width + degreeSize.width;
    if ( contentW >= contentMaxW )
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
- (CPPositionDetailWelfare *)welfarePositionView
{
    if ( !_welfarePositionView )
    {
        _welfarePositionView = [[CPPositionDetailWelfare alloc] init];
    }
    return _welfarePositionView;
}

#pragma mark - events
- (void)clickedCompanyDetailButton:(UIButton *)sender
{
    if ( [self.positonDetailDelegate respondsToSelector:@selector(checkCompanyDetail)] )
    {
        [self.positonDetailDelegate checkCompanyDetail];
    }
}
#pragma mark - getter methods
- (UILabel *)positionLabel
{
    if ( !_positionLabel )
    {
        _positionLabel = [[UILabel alloc] init];
        [_positionLabel setFont:[UIFont systemFontOfSize:60 / CP_GLOBALSCALE]];
        [_positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_positionLabel setNumberOfLines:0];
        [_positionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    }
    return _positionLabel;
}
- (UILabel *)salaryLabel
{
    if ( !_salaryLabel )
    {
        _salaryLabel = [[UILabel alloc] init];
        [_salaryLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_salaryLabel setTextColor:[UIColor colorWithHexString:@"ff5252"]];
    }
    return _salaryLabel;
}
- (UIImageView *)locationView
{
    if ( !_locationView )
    {
        _locationView = [[UIImageView alloc] init];
        _locationView.image = [UIImage imageNamed:@"ic_location"];
        _locationView.viewSize = CGSizeMake(48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
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
- (UIImageView *)schoolImageView
{
    if ( !_schoolImageView )
    {
        _schoolImageView = [[UIImageView alloc] init];
        _schoolImageView.image = [UIImage imageNamed:@"resume_ic_edutab"];
//        _schoolImageView.hidden = YES;
    }
    return _schoolImageView;
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
- (UIView *)companyBackgroundView
{
    if ( !_companyBackgroundView )
    {
        _companyBackgroundView = [[UIView alloc] init];
        [_companyBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_companyBackgroundView addSubview:self.companyDetailButton];
        [self.companyDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _companyBackgroundView.mas_top );
            make.left.equalTo( _companyBackgroundView.mas_left );
            make.bottom.equalTo( _companyBackgroundView.mas_bottom );
            make.right.equalTo( _companyBackgroundView.mas_right );
        }];
        [_companyBackgroundView addSubview:self.logoImageView];
        [_companyBackgroundView addSubview:self.companyLabel];
        [_companyBackgroundView addSubview:self.addressAndPeopleLabel];
        [_companyBackgroundView addSubview:self.arrowImageView];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _companyBackgroundView.mas_centerY );
            make.left.equalTo( _companyBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 140 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 140 / CP_GLOBALSCALE ) );
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _companyBackgroundView.mas_centerY );
            make.right.equalTo( _companyBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE);
            make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 84 / CP_GLOBALSCALE ) );
        }];
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.logoImageView.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( _companyBackgroundView.mas_centerY ).offset( -(self.companyLabel.font.pointSize + 10 / CP_GLOBALSCALE) );
//            make.height.equalTo( @( self.companyLabel.font.pointSize ) );
            make.right.equalTo( self.arrowImageView.mas_left );
        }];
        [self.addressAndPeopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.companyLabel.mas_left );
            make.top.equalTo( _companyLabel.mas_bottom).offset( 10 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.addressAndPeopleLabel.font.pointSize ) );
            make.right.equalTo( self.arrowImageView.mas_left );
        }];
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_companyBackgroundView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _companyBackgroundView.mas_left );
            make.bottom.equalTo( _companyBackgroundView.mas_bottom );
            make.right.equalTo( _companyBackgroundView.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _companyBackgroundView;
}
- (UIImageView *)logoImageView
{
    if ( !_logoImageView )
    {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"null_logo"];
        //是否设置边框以及是否可见
        [_logoImageView.layer setMasksToBounds:YES];
        CGFloat cornerRadius = 140/CP_GLOBALSCALE *0.5;
        [_logoImageView.layer setCornerRadius:cornerRadius];
        [_logoImageView.layer setBorderWidth:2.0/CP_GLOBALSCALE];
        //设置边框线的颜色
        [_logoImageView.layer setBorderColor:[[UIColor colorWithHexString:@"e1e1e3"] CGColor]];
    }
    return _logoImageView;
}
- (UILabel *)companyLabel
{
    if ( !_companyLabel )
    {
        _companyLabel = [[UILabel alloc] init];
        [_companyLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_companyLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
//        [_companyLabel setNumberOfLines:0];
//        [_companyLabel setLineBreakMode:NSLineBreakByWordWrapping];
    }
    return _companyLabel;
}
- (UILabel *)addressAndPeopleLabel
{
    if ( !_addressAndPeopleLabel )
    {
        _addressAndPeopleLabel = [[UILabel alloc] init];
        [_addressAndPeopleLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_addressAndPeopleLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    return _addressAndPeopleLabel;
}
- (UIImageView *)arrowImageView
{
    if ( !_arrowImageView )
    {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"ic_next"];
    }
    return _arrowImageView;
}
- (UIButton *)companyDetailButton
{
    if ( !_companyDetailButton )
    {
        _companyDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_companyDetailButton setBackgroundColor:[UIColor clearColor]];
        [_companyDetailButton addTarget:self action:@selector(clickedCompanyDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _companyDetailButton;
}
- (NSMutableArray *)labelArrayM
{
    if ( !_labelArrayM )
    {
        _labelArrayM = [NSMutableArray array];
    }
    return _labelArrayM;
}
- (CPWXinsanbanButton *)xinsanbanButton
{
    if ( !_xinsanbanButton )
    {
        _xinsanbanButton = [CPWXinsanbanButton buttonWithType:UIButtonTypeCustom];
        [_xinsanbanButton setBackgroundImage:[UIImage imageNamed:@"app_xinsanban"] forState:UIControlStateNormal];
        [_xinsanbanButton setHidden:YES];
        [_xinsanbanButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [self.positonDetailDelegate respondsToSelector:@selector(clickedXinsanbanButton)] )
            {
                [self.positonDetailDelegate clickedXinsanbanButton];
            }
        }];
    }
    return _xinsanbanButton;
}
@end
#pragma mark - CPWXinsanbanButton
@implementation CPWXinsanbanButton
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end