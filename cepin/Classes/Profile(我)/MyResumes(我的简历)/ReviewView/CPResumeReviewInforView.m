//
//  CPResumeReviewInforView.m
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeReviewInforView.h"
#import "CPCommon.h"
#import "BaseCodeDTO.h"
@interface CPResumeReviewInforView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nationStaticLabel;
@property (nonatomic, strong) UILabel *nationLabel;
@property (nonatomic, strong) UILabel *statusStaticLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *idCardLabel;
@property (nonatomic, strong) UILabel *idCardStaticLabel;
@property (nonatomic, strong) UILabel *addressStaticLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *educationStaticLabel;
@property (nonatomic, strong) UILabel *educationLabel;
@property (nonatomic, strong) UILabel *faceStaticLabel;
@property (nonatomic, strong) UILabel *faceLabel;
@property (nonatomic, strong) UILabel *heightStaticLabel;
@property (nonatomic, strong) UILabel *heightLabel;
@property (nonatomic, strong) UILabel *weightStaticLabel;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *healthStaticLabel;
@property (nonatomic, strong) UILabel *healthLabel;
@property (nonatomic, strong) UILabel *nativeStaticLabel;
@property (nonatomic, strong) UILabel *nativeLabel;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@property (nonatomic, strong) UILabel *qqLabel;
@property (nonatomic, strong) UILabel *hukouLabel;
@property (nonatomic, strong) UILabel *marriageLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *communicationLabel;
@property (nonatomic, strong) UILabel *communicationContentLabel;
@property (nonatomic, strong) UILabel *postLabel;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *accountContent;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) NSMutableArray *workYearBaseCodeArrayM;
@end
@implementation CPResumeReviewInforView
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.workYearBaseCodeArrayM addObjectsFromArray:[BaseCode workYears]];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.titleLabel.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.idCardStaticLabel];
        [self addSubview:self.idCardLabel];
        [self.idCardStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( separatorLine.mas_left );
        }];
        [self.idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.idCardStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 + 36 / CP_GLOBALSCALE );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.nationStaticLabel];
        [self addSubview:self.statusStaticLabel];
        [self addSubview:self.nationLabel];
        [self addSubview:self.statusLabel];
        [self.nationStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.idCardStaticLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.idCardStaticLabel.mas_left );
        }];
        [self.statusStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.nationStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 2.0 + 36 / CP_GLOBALSCALE );
        }];
        [self.nationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.nationStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 + 36 / CP_GLOBALSCALE );
            make.right.equalTo( self.statusStaticLabel.mas_left ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.statusStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 * 3.0 );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.addressStaticLabel];
        [self addSubview:self.educationStaticLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.educationLabel];
        [self.addressStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.nationStaticLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( separatorLine.mas_left );
        }];
        [self.educationStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.addressStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 2.0 + 36 / CP_GLOBALSCALE );
        }];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.addressStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 + 36 / CP_GLOBALSCALE );
            make.right.equalTo( self.educationStaticLabel.mas_left ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.educationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.educationStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 * 3.0 );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.faceStaticLabel];
        [self addSubview:self.heightStaticLabel];
        [self addSubview:self.faceLabel];
        [self addSubview:self.heightLabel];
        [self.faceStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.addressStaticLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( separatorLine.mas_left );
        }];
        [self.heightStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.faceStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 2.0 + 36 / CP_GLOBALSCALE );
        }];
        [self.faceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.faceStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 + 36 / CP_GLOBALSCALE );
            make.right.equalTo( self.heightStaticLabel.mas_left ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.heightStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 * 3.0 );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.weightStaticLabel];
        [self addSubview:self.healthStaticLabel];
        [self addSubview:self.weightLabel];
        [self addSubview:self.healthLabel];
        [self addSubview:self.nativeStaticLabel];
        [self addSubview:self.nativeLabel];
        [self.weightStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.faceStaticLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( separatorLine.mas_left );
        }];
        [self.healthStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.weightStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 2.0 + 36 / CP_GLOBALSCALE );
        }];
        [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.weightStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 + 36 / CP_GLOBALSCALE );
            make.right.equalTo( self.healthStaticLabel.mas_left ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.healthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.healthStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 * 3.0 );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self.nativeStaticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.weightStaticLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( separatorLine.mas_left );
        }];
        [self.nativeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.nativeStaticLabel.mas_top );
            make.left.equalTo( self.mas_left ).offset( kScreenWidth / 4.0 + 36 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.secondSeparatorLine];
        [self.secondSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.nativeStaticLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.qqLabel];
        [self addSubview:self.hukouLabel];
        [self.qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.secondSeparatorLine.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.secondSeparatorLine.mas_left );
            make.right.lessThanOrEqualTo( self.hukouLabel.mas_left ).offset( 0 / CP_GLOBALSCALE );
        }];
        [self.hukouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.qqLabel.mas_top );
            make.left.equalTo( @( kScreenWidth / 2.0 + 36 / CP_GLOBALSCALE ) );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.marriageLabel];
        [self.marriageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.qqLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.communicationLabel];
        [self.communicationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.marriageLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.communicationContentLabel];
        [self.communicationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.communicationLabel.mas_top );
            make.left.equalTo( self.communicationLabel.mas_right );
            make.right.equalTo( self.mas_right ).offset( -20 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.postLabel];
        [self.postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.communicationContentLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.accountLabel];
        [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.postLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.accountContent];
        [self.accountContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.accountLabel.mas_top );
            make.left.equalTo( self.accountLabel.mas_right );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        [self addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.accountContent.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        UIView *separatorEndLine = [[UIView alloc] init];
        [separatorEndLine setBackgroundColor:[UIColor colorWithHexString:@"e6e6ea"]];
        [self addSubview:separatorEndLine];
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
    [self.idCardLabel setText:resumeModel.IdCardNumber];
    [self.nationLabel setText:resumeModel.Nation];
    NSString *workYear = resumeModel.WorkYear;
    for ( BaseCode *baseCode in self.workYearBaseCodeArrayM )
    {
        if ( baseCode.CodeKey.intValue == resumeModel.WorkYearKey.intValue )
        {
            workYear = baseCode.CodeName;
            break;
        }
    }
    [self.statusLabel setText:workYear];
    [self.addressLabel setText:resumeModel.Region];
    if ( resumeModel.GraduateDate && 0 < [resumeModel.GraduateDate length] )
        [self.educationLabel setText:[resumeModel.GraduateDate substringToIndex:7]];
    [self.faceLabel setText:resumeModel.Politics];
    if ( resumeModel.Height )
        [self.heightLabel setText:[NSString stringWithFormat:@"%@CM", resumeModel.Height]];
    if ( resumeModel.Weight )
        [self.weightLabel setText:[NSString stringWithFormat:@"%@KG", resumeModel.Weight]];
    NSString *healthStr = nil;
    if ( resumeModel.HealthType.intValue == 1 )
    {
        healthStr = @"健康";
    }
    else if( resumeModel.HealthType.intValue == 2 )
    {
        healthStr = @"良好";
    }
    else if( resumeModel.HealthType.intValue == 3 )
    {
        healthStr = @"有病史";
    }
    [self.healthLabel setText:healthStr];
    [self.nativeLabel setText:resumeModel.NativeCity];
    [self setLabel:self.qqLabel content:resumeModel.QQ];
    [self setLabel:self.hukouLabel content:resumeModel.Hukou];
    //婚姻状况（0 未知 1、未婚 2、已婚）
    NSNumber *marriageNumber = resumeModel.Marital;
    NSString *marriageStr = nil;
    if ( 1 == [marriageNumber intValue] )
    {
        marriageStr = @"未婚";
    }
    else if ( 2 == [marriageNumber intValue] )
    {
        marriageStr = @"已婚";
    }
    else
    {
        marriageStr = @"未婚";
    }
    [self setLabel:self.marriageLabel content:marriageStr];
    [self.communicationContentLabel setText:resumeModel.Address];
    [self setLabel:self.postLabel content:resumeModel.ZipCode];
    [self.accountContent setText:resumeModel.EmergencyContact];
    [self setLabel:self.phoneLabel content:resumeModel.EmergencyContactPhone];
    [self resetFrameWithResume:resumeModel];
}
- (void)setLabel:(UILabel *)label content:(NSString *)content
{
    if ( !content || 0 == [content length] )
    {
        return;
    }
    NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] init];
    NSString *staticStr = label.text;
    if(staticStr){
    [attStrM appendAttributedString:[[NSAttributedString alloc] initWithString:staticStr attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHexString:@"707070"] }]];
    }
    [attStrM appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"] }]];
    [label setText:@""];
    [label setAttributedText:attStrM];
}
- (void)resetFrameWithResume:(ResumeNameModel *)resumeModel
{
    if ( !resumeModel.QQ || 0 == [resumeModel.QQ length] )
    {
        [self.qqLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.secondSeparatorLine.mas_bottom ).offset( 0 );
            make.left.equalTo( self.secondSeparatorLine.mas_left );
            make.right.lessThanOrEqualTo( self.hukouLabel.mas_left ).offset( 0 / CP_GLOBALSCALE );
            make.height.equalTo( @( 0 ) );
        }];
    }
    if ( !resumeModel.Hukou || 0 == [resumeModel.Hukou length] )
    {
        [self.hukouLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.qqLabel.mas_top );
            make.left.equalTo( @( kScreenWidth / 2.0 + 36 / CP_GLOBALSCALE ) );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 0 ) );
        }];
    }
    else
    {
        if ( !resumeModel.QQ )
        {
            [self.hukouLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.secondSeparatorLine.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
                make.left.equalTo( @( 40 / CP_GLOBALSCALE ) );
                make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            }];
            [self.hukouLabel setText:@"户口所在地     "];
            [self setLabel:self.hukouLabel content:resumeModel.Hukou];
        }
        else
        {
            [self.hukouLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.secondSeparatorLine.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
                make.left.equalTo( @( kScreenWidth / 2.0 + 36 / CP_GLOBALSCALE ) );
                make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            }];
        }
    }
    if ( !resumeModel.QQ && !resumeModel.Hukou )
    {
        [self.marriageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.qqLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    else if ( (resumeModel.QQ && 0 == [resumeModel.QQ length]) )
    {
        if ( (resumeModel.Hukou && 0 == [resumeModel.Hukou length]) || !resumeModel.Hukou )
        {
            [self.marriageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.qqLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
                make.left.equalTo( self.qqLabel.mas_left );
                make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            }];
        }
        else
        {
            [self.marriageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.hukouLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                make.left.equalTo( self.qqLabel.mas_left );
                make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            }];
        }
    }
    else if ( (resumeModel.Hukou && 0 == [resumeModel.Hukou length]) )
    {
        if ( (resumeModel.QQ && 0 == [resumeModel.QQ length]) || !resumeModel.QQ )
        {
            [self.marriageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.qqLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
                make.left.equalTo( self.qqLabel.mas_left );
                make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            }];
        }
        else
        {
            [self.marriageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.qqLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
                make.left.equalTo( self.qqLabel.mas_left );
                make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            }];
        }
    }
    else if ( resumeModel.QQ )
    {
        [self.marriageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.qqLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    else if ( resumeModel.Hukou )
    {
        [self.marriageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.hukouLabel.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    if ( !resumeModel.Address || 0 == [resumeModel.Address length] )
    {
        [self.communicationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.marriageLabel.mas_bottom ).offset( 0 );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 0 ) );
        }];
    }
    if ( !resumeModel.ZipCode || 0 == [resumeModel.ZipCode length] )
    {
        [self.postLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.communicationContentLabel.mas_bottom ).offset( 0 );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 0 ) );
        }];
    }
    if ( !resumeModel.EmergencyContact || 0 == [resumeModel.EmergencyContact length] )
    {
        [self.accountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.postLabel.mas_bottom ).offset( 0 );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 0 ) );
        }];
    }
    if ( !resumeModel.EmergencyContactPhone || 0 == [resumeModel.EmergencyContactPhone length] )
    {
        [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.accountContent.mas_bottom ).offset( 0 );
            make.left.equalTo( self.qqLabel.mas_left );
            make.right.lessThanOrEqualTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 0 ) );
        }];
    }
}
#pragma mark - getter methods
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setText:@"基本信息"];
    }
    return _titleLabel;
}
- (UILabel *)nationStaticLabel
{
    if ( !_nationStaticLabel )
    {
        _nationStaticLabel = [[UILabel alloc] init];
        [_nationStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_nationStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_nationStaticLabel setText:@"民   族"];
    }
    return _nationStaticLabel;
}
- (UILabel *)nationLabel
{
    if ( !_nationLabel )
    {
        _nationLabel = [[UILabel alloc] init];
        [_nationLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_nationLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _nationLabel;
}
- (UILabel *)statusStaticLabel
{
    if ( !_statusStaticLabel )
    {
        _statusStaticLabel = [[UILabel alloc] init];
        [_statusStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_statusStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_statusStaticLabel setText:@"就读状态"];
    }
    return _statusStaticLabel;
}
- (UILabel *)statusLabel
{
    if ( !_statusLabel )
    {
        _statusLabel = [[UILabel alloc] init];
        [_statusLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_statusLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _statusLabel;
}
- (UILabel *)idCardStaticLabel
{
    if ( !_idCardStaticLabel )
    {
        _idCardStaticLabel = [[UILabel alloc] init];
        [_idCardStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_idCardStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_idCardStaticLabel setText:@"身份证号"];
    }
    return _idCardStaticLabel;
}
- (UILabel *)idCardLabel
{
    if ( !_idCardLabel )
    {
        _idCardLabel = [[UILabel alloc] init];
        [_idCardLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_idCardLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _idCardLabel;
}
- (UILabel *)addressStaticLabel
{
    if ( !_addressStaticLabel )
    {
        _addressStaticLabel = [[UILabel alloc] init];
        [_addressStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_addressStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_addressStaticLabel setText:@"现居住地"];
    }
    return _addressStaticLabel;
}
- (UILabel *)addressLabel
{
    if ( !_addressLabel )
    {
        _addressLabel = [[UILabel alloc] init];
        [_addressLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_addressLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _addressLabel;
}
- (UILabel *)educationStaticLabel
{
    if ( !_educationStaticLabel )
    {
        _educationStaticLabel = [[UILabel alloc] init];
        [_educationStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_educationStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_educationStaticLabel setText:@"毕业时间"];
    }
    return _educationStaticLabel;
}
- (UILabel *)educationLabel
{
    if ( !_educationLabel )
    {
        _educationLabel = [[UILabel alloc] init];
        [_educationLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_educationLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _educationLabel;
}
- (UILabel *)nativeStaticLabel
{
    if ( !_nativeStaticLabel )
    {
        _nativeStaticLabel = [[UILabel alloc] init];
        [_nativeStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_nativeStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_nativeStaticLabel setText:@"籍   贯"];
    }
    return _nativeStaticLabel;
}
- (UILabel *)nativeLabel
{
    if ( !_nativeLabel )
    {
        _nativeLabel = [[UILabel alloc] init];
        [_nativeLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_nativeLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _nativeLabel;
}
- (UILabel *)heightStaticLabel
{
    if ( !_heightStaticLabel )
    {
        _heightStaticLabel = [[UILabel alloc] init];
        [_heightStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_heightStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_heightStaticLabel setText:@"身高(CM)"];
    }
    return _heightStaticLabel;
}
- (UILabel *)heightLabel
{
    if ( !_heightLabel )
    {
        _heightLabel = [[UILabel alloc] init];
        [_heightLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_heightLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _heightLabel;
}
- (UILabel *)weightStaticLabel
{
    if ( !_weightStaticLabel )
    {
        _weightStaticLabel = [[UILabel alloc] init];
        [_weightStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_weightStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_weightStaticLabel setText:@"体重(KG)"];
    }
    return _weightStaticLabel;
}
- (UILabel *)weightLabel
{
    if ( !_weightLabel )
    {
        _weightLabel = [[UILabel alloc] init];
        [_weightLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_weightLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _weightLabel;
}
- (UILabel *)healthStaticLabel
{
    if ( !_healthStaticLabel )
    {
        _healthStaticLabel = [[UILabel alloc] init];
        [_healthStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_healthStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_healthStaticLabel setText:@"健康情况"];
    }
    return _healthStaticLabel;
}
- (UILabel *)healthLabel
{
    if ( !_healthLabel )
    {
        _healthLabel = [[UILabel alloc] init];
        [_healthLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_healthLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _healthLabel;
}
- (UILabel *)faceStaticLabel
{
    if ( !_faceStaticLabel )
    {
        _faceStaticLabel = [[UILabel alloc] init];
        [_faceStaticLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_faceStaticLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_faceStaticLabel setText:@"政治面貌"];
    }
    return _faceStaticLabel;
}
- (UILabel *)faceLabel
{
    if ( !_faceLabel )
    {
        _faceLabel = [[UILabel alloc] init];
        [_faceLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_faceLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _faceLabel;
}
- (UIView *)secondSeparatorLine
{
    if ( !_secondSeparatorLine )
    {
        _secondSeparatorLine = [[UIView alloc] init];
        [_secondSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _secondSeparatorLine;
}
- (UILabel *)qqLabel
{
    if ( !_qqLabel )
    {
        _qqLabel = [[UILabel alloc] init];
        [_qqLabel setText:@"QQ号码          "];
        [_qqLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _qqLabel;
}
- (UILabel *)hukouLabel
{
    if ( !_hukouLabel )
    {
        _hukouLabel = [[UILabel alloc] init];
        [_hukouLabel setText:@"户口所在地   "];
        [_hukouLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _hukouLabel;
}
- (UILabel *)marriageLabel
{
    if ( !_marriageLabel )
    {
        _marriageLabel = [[UILabel alloc] init];
        [_marriageLabel setText:@"婚姻状况         "];
        [_marriageLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _marriageLabel;
}
- (UILabel *)idLabel
{
    if ( !_idLabel )
    {
        _idLabel = [[UILabel alloc] init];
        [_idLabel setText:@"身份证号         "];
        [_idLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _idLabel;
}
- (UILabel *)communicationLabel
{
    if ( !_communicationLabel )
    {
        _communicationLabel = [[UILabel alloc] init];
        [_communicationLabel setText:@"通讯地址         "];
        [_communicationLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_communicationLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
    }
    return _communicationLabel;
}
- (UILabel *)communicationContentLabel
{
    if ( !_communicationContentLabel )
    {
        _communicationContentLabel = [[UILabel alloc] init];
        _communicationContentLabel.numberOfLines = 0;
        [_communicationContentLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_communicationContentLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _communicationContentLabel;
}
- (UILabel *)postLabel
{
    if ( !_postLabel )
    {
        _postLabel = [[UILabel alloc] init];
        [_postLabel setText:@"邮政编码         "];
        [_postLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _postLabel;
}
- (UILabel *)accountLabel
{
    if ( !_accountLabel )
    {
        _accountLabel = [[UILabel alloc] init];
        [_accountLabel setText:@"紧急联系人     "];
        [_accountLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_accountLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
    }
    return _accountLabel;
}
- (UILabel *)accountContent
{
    if ( !_accountContent )
    {
        _accountContent = [[UILabel alloc] init];
        _accountContent.numberOfLines = 0;
        [_accountContent setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_accountContent setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _accountContent;
}
- (UILabel *)phoneLabel
{
    if ( !_phoneLabel )
    {
        _phoneLabel = [[UILabel alloc] init];
        [_phoneLabel setText:@"紧急联系方式  "];
        [_phoneLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _phoneLabel;
}
- (NSMutableArray *)workYearBaseCodeArrayM
{
    if ( !_workYearBaseCodeArrayM )
    {
        _workYearBaseCodeArrayM = [NSMutableArray array];
    }
    return _workYearBaseCodeArrayM;
}
@end
