//
//  CPHomeGuessCell.m
//  cepin
//
//  Created by ceping on 16/1/12.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomeGuessCell.h"
#import "JobSearchModel.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"
@interface CPHomeGuessCell ()
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
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIImageView *schoolImageView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) NSArray *temptationsArray;
@property (nonatomic, strong) NSArray *temptationsButtonArray;
@property (nonatomic, strong) UIButton *checkMoreButton;
@property (nonatomic, strong) UIView *checkMoreBackgroundView;
@property (nonatomic, assign) BOOL hideCheckMoreButton;
@property (nonatomic, strong) UIView *separatorBlockView;
@property (nonatomic, assign) BOOL hideSeparatorBlock;
@property (nonatomic, strong) NSMutableArray *labelArrayM;
@end
@implementation CPHomeGuessCell

#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        _hideCheckMoreButton = YES;
        _hideSeparatorBlock = YES;
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.contentView addSubview:self.positionLabel];
        [self.contentView addSubview:self.cllectionButton];
        [self.contentView addSubview:self.salaryLabel];
        [self.contentView addSubview:self.locationView];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.experienceView];
        [self.contentView addSubview:self.experienceLabel];
        [self.contentView addSubview:self.degreeView];
        [self.contentView addSubview:self.degreeLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.checkMoreBackgroundView];
        [self.contentView addSubview:self.separatorLine];
        [self.contentView addSubview:self.schoolImageView];
        [self.contentView addSubview:self.topImageView];
        [self.contentView addSubview:self.separatorBlockView];
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.salaryLabel.mas_centerY );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
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
    }
    return self;
}
+ (instancetype)guessCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"CPHomeGuessCell";
    CPHomeGuessCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPHomeGuessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)setContentIsRead:(BOOL)isRead
{
    if ( isRead )
    {
        [self.positionLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [self.companyLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    }
    else
    {
        [self.positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [self.companyLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
    }
    if ( CP_IS_IPHONE_4_OR_LESS )
        [self layoutSubviews];
    else
        [self layoutIfNeeded];
}
- (void)configCellWithDatas:(CPRecommendModelFrame *)modelFrame hideCheckMoreButton:(BOOL)hideChekMoreButton
{
    if ( !modelFrame )
        return;
    _hideCheckMoreButton = hideChekMoreButton;
    // 取出职位模型
    _recommendModel = modelFrame.recommendModel;
    _temptationsArray = modelFrame.temptations;
    for( NSUInteger index = 0; index < [_temptationsButtonArray count]; index++ )
    {
        UIButton *btn = self.temptationsButtonArray[index];
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.frame = CGRectZero;
        [btn setHidden:YES];
    }
    _temptationsButtonArray = nil;
    [self.positionLabel setText:_recommendModel.PositionName];
    [self.salaryLabel setText:_recommendModel.Salary];
    [self.timeLabel setText:[NSDate cepinJobYearMonthDayFromString:_recommendModel.PublishDate]];
    if ( _recommendModel.Shortname && 0 < [_recommendModel.Shortname length] )
    {
        [self.companyLabel setText:_recommendModel.Shortname];
    }
    else
    {
        [self.companyLabel setText:_recommendModel.CompanyName];
    }
    [self.locationLabel setText:_recommendModel.City];
    [self.experienceLabel setText:_recommendModel.WorkYear];
    NSString *educationStr = _recommendModel.EducationLevel;
    if ( educationStr && 0 < [educationStr length] )
    {
        [self.degreeView setHidden:NO];
        [self.degreeLabel setHidden:NO];
    }
    else
    {
        [self.degreeView setHidden:YES];
        [self.degreeLabel setHidden:YES];
    }
    [self.degreeLabel setText:educationStr];
    if ( 2 != _recommendModel.PositionType.intValue )
    {
        self.schoolImageView.hidden = NO;
    }
    else
    {
        self.schoolImageView.hidden = YES;
    }
    if ( 0 != _recommendModel.IsTop.intValue )
    {
        self.topImageView.hidden = NO;
    }
    else
    {
        self.topImageView.hidden = YES;
    }
    if ( [_recommendModel.IsCollection intValue] == 0 )
        [_cllectionButton setSelected:NO];
    else
        [_cllectionButton setSelected:YES];
    _cllectionButton.hidden = YES;
    if ( CP_IS_IPHONE_4_OR_LESS )
        [self layoutSubviews];
    else
        [self layoutIfNeeded];
}
- (void)configCellWithDatas:(CPRecommendModelFrame *)modelFrame highlightText:(NSString *)text isRead:(BOOL)isRead
{
    if ( !modelFrame )
        return;
    _hideCheckMoreButton = YES;
    // 取出职位模型
    _recommendModel = modelFrame.recommendModel;
    _temptationsArray = modelFrame.temptations;
    for( NSUInteger index = 0; index < [_temptationsButtonArray count]; index++ )
    {
        UIButton *btn = self.temptationsButtonArray[index];
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.frame = CGRectZero;
        [btn setHidden:YES];
    }
    _temptationsButtonArray = nil;
//   [self.positionLabel setText:_recommendModel.PositionName];
    UIColor *textColor = [UIColor colorWithHexString:@"404040"];
    if ( isRead )
        textColor = [UIColor colorWithHexString:@"9d9d9d"];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_recommendModel.PositionName attributes:@{NSForegroundColorAttributeName : textColor, NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]}];
    NSRegularExpression *mregex = [NSRegularExpression regularExpressionWithPattern:text options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *resultArray = [mregex matchesInString:_recommendModel.PositionName options:0 range:NSMakeRange(0, [_recommendModel.PositionName length])];
    for ( NSTextCheckingResult *result in resultArray )
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:result.range];
    }
    self.positionLabel.attributedText = attString;
    [self.salaryLabel setText:_recommendModel.Salary];
    [self.timeLabel setText:[NSDate cepinJobYearMonthDayFromString:_recommendModel.PublishDate]];
    
    if ( _recommendModel.Shortname && 0 < [_recommendModel.Shortname length] )
    {
        [self.companyLabel setText:_recommendModel.Shortname];
    }
    else
    {
        [self.companyLabel setText:_recommendModel.CompanyName];
    }
    [self.locationLabel setText:_recommendModel.City];
    [self.experienceLabel setText:_recommendModel.WorkYear];
    NSString *educationStr = _recommendModel.EducationLevel;
    if ( educationStr && 0 < [educationStr length] )
    {
        [self.degreeView setHidden:NO];
        [self.degreeLabel setHidden:NO];
    }
    else
    {
        [self.degreeView setHidden:YES];
        [self.degreeLabel setHidden:YES];
    }
    [self.degreeLabel setText:educationStr];
    if ( 2 != _recommendModel.PositionType.intValue )
    {
        self.schoolImageView.hidden = NO;
    }
    else
    {
        self.schoolImageView.hidden = YES;
    }
    
    if ( 0 != _recommendModel.IsTop.intValue )
    {
        self.topImageView.hidden = NO;
    }
    else
    {
        self.topImageView.hidden = YES;
    }
    if ( [_recommendModel.IsCollection intValue] == 0 )
        [_cllectionButton setSelected:NO];
    else
        [_cllectionButton setSelected:YES];
    _cllectionButton.hidden = YES;
    if ( CP_IS_IPHONE_4_OR_LESS )
        [self layoutSubviews];
    else
        [self layoutIfNeeded];
}
- (void)setSeparatorIsHide:(BOOL)isHide
{
    self.hideSeparatorBlock = isHide;
    if ( CP_IS_IPHONE_4_OR_LESS )
        [self layoutSubviews];
    else
        [self layoutIfNeeded];
}
- (void)setLastCellIsHide:(BOOL)isHide
{
    [self.separatorLine setHidden:isHide];
    if ( CP_IS_IPHONE_4_OR_LESS )
        [self layoutSubviews];
    else
        [self layoutIfNeeded];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize positionSize = [self.positionLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.positionLabel.font } context:nil].size;
    CGFloat positionW = positionSize.width;
    CGFloat positionX = 40 / CP_GLOBALSCALE;
    CGFloat positionY = 60 / CP_GLOBALSCALE;
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE - 25 / CP_GLOBALSCALE - 70 / CP_GLOBALSCALE - 10 / CP_GLOBALSCALE;
    // 校招
    if ( 2 != _recommendModel.PositionType.intValue )
    {
        maxW -= 40 / 3.0 + 48 / CP_GLOBALSCALE;
    }
    else
    {
        self.schoolImageView.hidden = YES;
    }
    // 置顶
    if ( 0 != _recommendModel.IsTop.intValue )
    {
        maxW -= 40 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE;
    }
    if ( positionW > maxW )
        positionW = maxW;
    self.positionLabel.viewX = positionX;
    self.positionLabel.viewY = positionY;
    self.positionLabel.viewWidth = positionW;
    CGSize salarySize = [self.salaryLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.salaryLabel.font } context:nil].size;
    [self.salaryLabel setFrame:CGRectMake(kScreenWidth - salarySize.width - 40 / CP_GLOBALSCALE, CGRectGetMaxY(self.cllectionButton.frame) + 54 / CP_GLOBALSCALE, salarySize.width, self.salaryLabel.font.pointSize)];
    // 校招
    if ( 2 != _recommendModel.PositionType.intValue )
    {
        self.schoolImageView.viewY = self.positionLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0;
        self.schoolImageView.viewX = CGRectGetMaxX(self.positionLabel.frame) + 40 / 3.0;
        self.schoolImageView.viewSize = CGSizeMake(48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
    }
    // 置顶
    if ( 0 != _recommendModel.IsTop.intValue )
    {
        if ( 2 == _recommendModel.PositionType.intValue )
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
    CGFloat buttonX = 40 / CP_GLOBALSCALE;
    CGFloat buttonY = CGRectGetMaxY(self.companyLabel.frame) + 40 / CP_GLOBALSCALE;
    CGFloat buttonH = ( 15 + 15 + 32 ) / CP_GLOBALSCALE;
    CGFloat buttonW = 0;
    NSString *buttonTitle = nil;
    UIButton *btn = nil;
    CGFloat maxX = kScreenWidth - 40 / CP_GLOBALSCALE;
    NSUInteger buttonIndex = 0;
    for ( NSUInteger index = 0; index < [_temptationsArray count]; index++ )
    {
        buttonTitle = _temptationsArray[index];
        buttonW = 15 / CP_GLOBALSCALE * 2 + 32 / CP_GLOBALSCALE * buttonTitle.length;
        if ( maxX < buttonW + buttonX )
            continue;
        btn = self.temptationsButtonArray[buttonIndex];
        [btn setTitle:buttonTitle forState:UIControlStateNormal];
        [btn setHidden:NO];
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        buttonX += buttonW + 20 / CP_GLOBALSCALE;
        if ( buttonX > maxX )
            break;
        buttonIndex++;
    }
    for( NSUInteger index = buttonIndex + 1; index < [_temptationsButtonArray count]; index++ )
    {
        UIButton *btn = self.temptationsButtonArray[index];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setHidden:YES];
    }
    CGFloat separatorLineX = 40 / CP_GLOBALSCALE;
    CGFloat separatorLineW = self.viewWidth - separatorLineX * 2;
    CGFloat separatorLineH = 2 / CP_GLOBALSCALE;
    CGFloat separatorLineY = self.viewHeight - separatorLineH;
    CGRect checkButtonFrame = CGRectZero;
    if ( _hideCheckMoreButton ) // 隐藏查看更多按钮
    {
        checkButtonFrame = CGRectZero;
        [self.separatorBlockView setHidden:self.hideSeparatorBlock];
        if ( self.hideSeparatorBlock )
        {
            separatorLineY = self.viewHeight - separatorLineH;
            [self.separatorBlockView setFrame:CGRectZero];
        }
        else
        {
            separatorLineY = self.viewHeight - separatorLineH - 30 / CP_GLOBALSCALE;
            [self.separatorBlockView setFrame:CGRectMake(0, self.viewHeight - 30 / CP_GLOBALSCALE, self.viewWidth, 30 / CP_GLOBALSCALE)];
        }
    }
    else    // 显示查看更多按钮
    {
        CGFloat checkButtonX = 0;
        CGFloat checkButtonH = ( 144 + 30 ) / CP_GLOBALSCALE;
        CGFloat checkButtonW = self.viewWidth;
        CGFloat checkButtonY = self.viewHeight - checkButtonH;
        checkButtonFrame = CGRectMake(checkButtonX, checkButtonY, checkButtonW, checkButtonH);
        separatorLineY = checkButtonY - separatorLineH;
    }
    [self.checkMoreBackgroundView setHidden:_hideCheckMoreButton];
    [self.checkMoreBackgroundView setFrame:checkButtonFrame];
    self.separatorLine.frame = CGRectMake(separatorLineX, separatorLineY, separatorLineW, separatorLineH);
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
    CGFloat locationX = CGRectGetMaxX(self.locationView.frame);
    if ( 0 == locationX )
        locationX = (48 + 40) / CP_GLOBALSCALE;
    [self.locationLabel setFrame:CGRectMake(locationX + 10 / CP_GLOBALSCALE, self.salaryLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0, locationSize.width, 48 / CP_GLOBALSCALE)];
    [self.experienceLabel setFrame:CGRectMake(CGRectGetMaxX(self.locationLabel.frame) + 10 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE, self.salaryLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0, experienceSize.width, 48 / CP_GLOBALSCALE)];
    [self.degreeLabel setFrame:CGRectMake(CGRectGetMaxX(self.experienceLabel.frame) + 10 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE, self.salaryLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0, degreeSize.width, 48 / CP_GLOBALSCALE)];
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
#pragma mark - getter methods
- (UILabel *)positionLabel
{
    if ( !_positionLabel )
    {
        _positionLabel = [[UILabel alloc] init];
        [_positionLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_positionLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        CGSize positionSize = [_positionLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : _positionLabel.font } context:nil].size;
        CGFloat positionW = positionSize.width;
        CGFloat positionH = _positionLabel.font.pointSize + 3.0;
        CGFloat positionX = 40 / CP_GLOBALSCALE;
        CGFloat positionY = 50 / CP_GLOBALSCALE;
        [_positionLabel setFrame:CGRectMake(positionX, positionY, positionW, positionH)];
    }
    return _positionLabel;
}
- (UIButton *)cllectionButton
{
    if ( !_cllectionButton )
    {
        _cllectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cllectionButton setImage:[UIImage imageNamed:@"list_ic_collect_null"] forState:UIControlStateNormal];
        [_cllectionButton setImage:[UIImage imageNamed:@"list_ic_collect"] forState:UIControlStateSelected];
        [_cllectionButton setFrame:CGRectMake(kScreenWidth - ( 70 + 25 ) / CP_GLOBALSCALE, (40 - (70 - 42) / 2.0) / CP_GLOBALSCALE, 70 / CP_GLOBALSCALE, 70 / CP_GLOBALSCALE)];
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
        [_locationLabel setFrame:CGRectMake(CGRectGetMaxX(self.locationView.frame) + 10 / CP_GLOBALSCALE, self.salaryLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0, locationSize.width, 48 / CP_GLOBALSCALE)];
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
        CGSize experienceSize = [_experienceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : _experienceLabel.font } context:nil].size;
        [_experienceLabel setFrame:CGRectMake(CGRectGetMaxX(self.experienceView.frame) + 10 / CP_GLOBALSCALE, self.salaryLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0, experienceSize.width, 48 / CP_GLOBALSCALE)];
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
        CGSize degreeSize = [self.degreeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.locationLabel.font } context:nil].size;
        [_degreeLabel setFrame:CGRectMake(CGRectGetMaxX(self.degreeView.frame) + 10 / CP_GLOBALSCALE, self.salaryLabel.viewY - ( 48 - 42 ) / CP_GLOBALSCALE / 2.0, degreeSize.width, 48 / CP_GLOBALSCALE)];
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
        [_salaryLabel setTextColor:[UIColor colorWithHexString:@"ff5252"]];
        CGSize salarySize = [_salaryLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : _salaryLabel.font } context:nil].size;
        [_salaryLabel setFrame:CGRectMake(kScreenWidth - salarySize.width - 40 / CP_GLOBALSCALE, CGRectGetMaxY(self.cllectionButton.frame) + 54 / CP_GLOBALSCALE, salarySize.width, _salaryLabel.font.pointSize)];
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
        [_companyLabel setTextAlignment:NSTextAlignmentLeft];
        [_companyLabel setFrame:CGRectMake(40 / CP_GLOBALSCALE, self.timeLabel.viewY, kScreenWidth - 40 / CP_GLOBALSCALE * 2 - self.timeLabel.viewWidth, _companyLabel.font.pointSize)];
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
        [_timeLabel setFrame:CGRectMake(kScreenWidth - 40 / CP_GLOBALSCALE - _timeLabel.font.pointSize * 4.0, CGRectGetMaxY(self.salaryLabel.frame) + 28 / CP_GLOBALSCALE, _timeLabel.font.pointSize * 4.0, _timeLabel.font.pointSize)];
    }
    return _timeLabel;
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
- (NSArray *)temptationsButtonArray
{
    if ( !_temptationsButtonArray )
    {
        if ( 0 == [self.temptationsArray count] )
            return nil;
        NSMutableArray *buttonM = [NSMutableArray array];
        for ( NSUInteger index = 0; index < [self.temptationsArray count]; index++ )
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:32 / CP_GLOBALSCALE]];
            [btn.layer setCornerRadius:6 / CP_GLOBALSCALE];
            [btn.layer setBorderWidth:2 / CP_GLOBALSCALE];
            [btn.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
            btn.hidden = YES;
            [btn setEnabled:NO];
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
            [self.contentView addSubview:btn];
            [buttonM addObject:btn];
        }
        _temptationsButtonArray = [buttonM copy];
    }
    return _temptationsButtonArray;
}
- (UIView *)checkMoreBackgroundView
{
    if ( !_checkMoreBackgroundView )
    {
        _checkMoreBackgroundView = [[UIView alloc] init];
        [_checkMoreBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_checkMoreBackgroundView addSubview:self.checkMoreButton];
        [self.checkMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _checkMoreBackgroundView.mas_top );
            make.left.equalTo( _checkMoreBackgroundView.mas_left );
            make.bottom.equalTo( _checkMoreBackgroundView.mas_bottom ).offset( -( 2 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE ) );
            make.right.equalTo( _checkMoreBackgroundView.mas_right );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_checkMoreBackgroundView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _checkMoreBackgroundView.mas_left );
            make.height.equalTo ( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( _checkMoreBackgroundView.mas_bottom ).offset( -30 / CP_GLOBALSCALE );
            make.right.equalTo( _checkMoreBackgroundView.mas_right );
        }];
    }
    return _checkMoreBackgroundView;
}
- (UIView *)separatorBlockView
{
    if ( !_separatorBlockView )
    {
        _separatorBlockView = [[UIView alloc] init];
        [_separatorBlockView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_separatorBlockView setHidden:YES];
    }
    return _separatorBlockView;
}
- (UIButton *)checkMoreButton
{
    if ( !_checkMoreButton )
    {
        __weak typeof( self ) weakSelf = self;
        _checkMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkMoreButton setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_checkMoreButton setTitle:@"点击查看更多岗位" forState:UIControlStateNormal];
        [_checkMoreButton.titleLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_checkMoreButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_checkMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [weakSelf.homeGuessCellDelegate respondsToSelector:@selector(homeGuessCell:clickedLoadMoreButton:)] )
            {
                [weakSelf.homeGuessCellDelegate homeGuessCell:weakSelf clickedLoadMoreButton:weakSelf.checkMoreButton];
            }
        }];
    }
    return _checkMoreButton;
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
