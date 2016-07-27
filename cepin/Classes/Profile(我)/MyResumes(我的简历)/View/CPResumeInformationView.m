//
//  CPResumeInformationView.m
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeInformationView.h"
#import "BaseCodeDTO.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
#import "CPWResumeEditOneLabel.h"
@interface CPResumeInformationView ()
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *guessLabel;
@property (nonatomic, strong) UIImageView *mustWriteImageView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *staticNameLabel;
@property (nonatomic, strong) UILabel *staticSexLabel;
@property (nonatomic, strong) UILabel *staticBorndLabel;
@property (nonatomic, strong) UILabel *staticPhoneLabel;
@property (nonatomic, strong) UILabel *staticEmailLabel;
@property (nonatomic, strong) UILabel *staticWorkYearLabel;
@property (nonatomic, strong) UILabel *staticNowAddressLabel;
@property (nonatomic, strong) UILabel *staticWorkStateLabel;
@property (nonatomic, strong) UILabel *staticIdCardLabel;
@property (nonatomic, strong) CPWResumeEditOneLabel *staticOneWordLabel;
@property (nonatomic, strong) ResumeNameModel *resumeModel;
@property (nonatomic, strong) NSArray *jobStateArray;
@property (nonatomic, strong) UILabel *oneWordL;
@property (nonatomic, strong) UILabel *workYearL;
@property (nonatomic, strong) NSMutableArray *workYearBaseCodeArrayM;
@end

@implementation CPResumeInformationView

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
        _jobStateArray = [BaseCode JobStatus];
        [self.workYearBaseCodeArrayM addObjectsFromArray:[BaseCode workYears]];
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
- (void)configWithResume:(ResumeNameModel *)resume
{
    // ResumeType;//（1：普通简历,2：应届生）简历类型(社招=1，校招=2)
    _resumeModel = resume;
    [self.staticNameLabel setText:_resumeModel.ChineseName];
    if ( _resumeModel.Gender.intValue == 1 )
        [self.staticSexLabel setText:@"男"];
    else if ( _resumeModel.Gender.intValue == 2 )
        [self.staticSexLabel setText:@"女"];
    if ( 0 < [_resumeModel.Birthday length] )
        [self.staticBorndLabel setText:[_resumeModel.Birthday substringToIndex:4]];
//    [self.staticBorndLabel setText:_resumeModel.Birthday];
    [self.staticPhoneLabel setText:_resumeModel.Mobile];
    [self.staticIdCardLabel setText:_resumeModel.IdCardNumber];
    [self.staticEmailLabel setText:_resumeModel.Email];
    [self.staticNowAddressLabel setText:_resumeModel.Region];
    for (BaseCode *temp in self.jobStateArray) {
        NSString *str = [NSString stringWithFormat:@"%@", temp.CodeKey];
        if ([_resumeModel.JobStatus isEqualToString:str]) {
            [self.staticWorkStateLabel setText:temp.CodeName];
        }
    }
    NSInteger resumeTypeInt = [_resumeModel.ResumeType intValue];
    if ( 2 == resumeTypeInt )
    {
        [self.oneWordL setHidden:YES];
        [self.staticOneWordLabel setHidden:YES];
        NSString *workYear = _resumeModel.WorkYear;
        for ( BaseCode *baseCode in self.workYearBaseCodeArrayM )
        {
            if ( baseCode.CodeKey.intValue == _resumeModel.WorkYearKey.intValue )
            {
                workYear = baseCode.CodeName;
                break;
            }
        }
        [self.staticWorkYearLabel setText:workYear];
        [self.workYearL setText:@"就读状态"];
    }
    else if ( 1 == resumeTypeInt )
    {
        [self.oneWordL setHidden:NO];
        [self.staticOneWordLabel setHidden:NO];
        NSString *introducesStr = _resumeModel.Introduces;
        if ( !introducesStr || 0 == [introducesStr length] || [introducesStr isEqualToString:@"(null)"] )
        {
            [self.staticOneWordLabel setAttributedText:nil];
        }
        else
        {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:introducesStr];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
            [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
            [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
            [self.staticOneWordLabel setAttributedText:attStr];
        }
        NSString *workYear = _resumeModel.WorkYear;
        for ( BaseCode *baseCode in self.workYearBaseCodeArrayM )
        {
            if ( baseCode.CodeKey.intValue == _resumeModel.WorkYearKey.intValue )
            {
                workYear = baseCode.CodeName;
                break;
            }
        }
        [self.staticWorkYearLabel setText:workYear];
        [self.workYearL setText:@"工作年限"];
    }
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
        
        UILabel *nameL = [[UILabel alloc] init];
        [nameL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [nameL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [nameL setTextAlignment:NSTextAlignmentRight];
        [nameL setText:@"姓 名"];
        [_whiteBackgroundView addSubview:nameL];
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 255 / CP_GLOBALSCALE );
            make.height.equalTo( @( nameL.font.pointSize ) );
        }];
        [_whiteBackgroundView addSubview:self.staticNameLabel];
        [self.staticNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( nameL.mas_top );
            make.left.equalTo( nameL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset(-40/CP_GLOBALSCALE);
            make.height.equalTo( nameL );
        }];
        
        UILabel *sexL = [[UILabel alloc] init];
        [sexL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [sexL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [sexL setTextAlignment:NSTextAlignmentRight];
        [sexL setText:@"性 别"];
        [_whiteBackgroundView addSubview:sexL];
        [sexL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( nameL.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 255 / CP_GLOBALSCALE );
            make.height.equalTo( @( sexL.font.pointSize ) );
        }];
        [_whiteBackgroundView addSubview:self.staticSexLabel];
        [self.staticSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( sexL.mas_top );
            make.left.equalTo( sexL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( sexL );
        }];
        
        UILabel *borndL = [[UILabel alloc] init];
        [borndL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [borndL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [borndL setTextAlignment:NSTextAlignmentRight];
        [borndL setText:@"出生年份"];
        [_whiteBackgroundView addSubview:borndL];
        [borndL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( sexL.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 255 / CP_GLOBALSCALE );
            make.height.equalTo( @( borndL.font.pointSize ) );
        }];
        [_whiteBackgroundView addSubview:self.staticBorndLabel];
        [self.staticBorndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( borndL.mas_top );
            make.left.equalTo( borndL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( borndL );
        }];
        
        UILabel *phoneL = [[UILabel alloc] init];
        [phoneL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [phoneL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [phoneL setTextAlignment:NSTextAlignmentRight];
        [phoneL setText:@"手机号码"];
        [_whiteBackgroundView addSubview:phoneL];
        [phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( borndL.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 255 / CP_GLOBALSCALE );
            make.height.equalTo( @( phoneL.font.pointSize ) );
        }];
        [_whiteBackgroundView addSubview:self.staticPhoneLabel];
        [self.staticPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( phoneL.mas_top );
            make.left.equalTo( phoneL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( phoneL );
        }];
        UILabel *idCardL = [[UILabel alloc] init];
        [idCardL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [idCardL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [idCardL setTextAlignment:NSTextAlignmentRight];
        [idCardL setText:@"身份证号"];
        [_whiteBackgroundView addSubview:idCardL];
        [idCardL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( phoneL.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 255 / CP_GLOBALSCALE );
            make.height.equalTo( @( idCardL.font.pointSize ) );
        }];
        [_whiteBackgroundView addSubview:self.staticIdCardLabel];
        [self.staticIdCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( idCardL.mas_top );
            make.left.equalTo( idCardL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( idCardL );
        }];
        
        UILabel *emailL = [[UILabel alloc] init];
        [emailL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [emailL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [emailL setTextAlignment:NSTextAlignmentRight];
        [emailL setText:@"邮箱"];
        [_whiteBackgroundView addSubview:emailL];
        [emailL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( idCardL.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 255 / CP_GLOBALSCALE );
            make.height.equalTo( @( emailL.font.pointSize * 1.2 ) );
        }];
        [_whiteBackgroundView addSubview:self.staticEmailLabel];
        [self.staticEmailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( emailL.mas_top );
            make.left.equalTo( emailL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( emailL );
        }];
        
        UILabel *workYearL = [[UILabel alloc] init];
        [workYearL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [workYearL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [workYearL setTextAlignment:NSTextAlignmentRight];
        [workYearL setText:@"就读状态"];
        [_whiteBackgroundView addSubview:workYearL];
        _workYearL = workYearL;
        [workYearL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( emailL.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 255 / CP_GLOBALSCALE );
            make.height.equalTo( @( workYearL.font.pointSize ) );
        }];
        [_whiteBackgroundView addSubview:self.staticWorkYearLabel];
        [self.staticWorkYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( workYearL.mas_top );
            make.left.equalTo( workYearL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( workYearL );
        }];
        
        UILabel *nowAddressL = [[UILabel alloc] init];
        [nowAddressL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [nowAddressL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [nowAddressL setTextAlignment:NSTextAlignmentRight];
        [nowAddressL setText:@"现居住地"];
        [_whiteBackgroundView addSubview:nowAddressL];
        [nowAddressL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( workYearL.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 255 / CP_GLOBALSCALE );
            make.height.equalTo( @( nowAddressL.font.pointSize ) );
        }];
        [_whiteBackgroundView addSubview:self.staticNowAddressLabel];
        [self.staticNowAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( nowAddressL.mas_top );
            make.left.equalTo( nowAddressL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( nowAddressL );
        }];
        
        UILabel *workStateL = [[UILabel alloc] init];
        [workStateL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [workStateL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [workStateL setTextAlignment:NSTextAlignmentRight];
        [workStateL setText:@"工作状态"];
        [_whiteBackgroundView addSubview:workStateL];
        [workStateL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( nowAddressL.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 255 / CP_GLOBALSCALE );
            make.height.equalTo( @( workStateL.font.pointSize ) );
        }];
        [_whiteBackgroundView addSubview:self.staticWorkStateLabel];
        [self.staticWorkStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( workStateL.mas_top );
            make.left.equalTo( workStateL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right );
            make.height.equalTo( workStateL );
        }];
        
        UILabel *oneWordL = [[UILabel alloc] init];
        [oneWordL setTextColor:[UIColor colorWithHexString:@"707070"]];
        [oneWordL setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [oneWordL setTextAlignment:NSTextAlignmentRight];
        [oneWordL setText:@"一句话优势"];
        [_whiteBackgroundView addSubview:oneWordL];
        _oneWordL = oneWordL;
        [oneWordL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( workStateL.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_left ).offset( 250 / CP_GLOBALSCALE );
        }];
        [_whiteBackgroundView addSubview:self.staticOneWordLabel];
        [self.staticOneWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( oneWordL.mas_top );
            make.left.equalTo( oneWordL.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _whiteBackgroundView.mas_right ).offset( -20 / CP_GLOBALSCALE );
            make.bottom.equalTo( _whiteBackgroundView.mas_bottom );
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
        [_guessLabel setText:@"基本信息"];
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
- (UILabel *)staticNameLabel
{
    if ( !_staticNameLabel )
    {
        _staticNameLabel = [[UILabel alloc] init];
        [_staticNameLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticNameLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _staticNameLabel;
}
- (UILabel *)staticSexLabel
{
    if ( !_staticSexLabel )
    {
        _staticSexLabel = [[UILabel alloc] init];
        [_staticSexLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticSexLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _staticSexLabel;
}
- (UILabel *)staticBorndLabel
{
    if ( !_staticBorndLabel )
    {
        _staticBorndLabel = [[UILabel alloc] init];
        [_staticBorndLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticBorndLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _staticBorndLabel;
}
- (UILabel *)staticPhoneLabel
{
    if ( !_staticPhoneLabel )
    {
        _staticPhoneLabel = [[UILabel alloc] init];
        [_staticPhoneLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticPhoneLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _staticPhoneLabel;
}
- (UILabel *)staticEmailLabel
{
    if ( !_staticEmailLabel )
    {
        _staticEmailLabel = [[UILabel alloc] init];
        [_staticEmailLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticEmailLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _staticEmailLabel;
}
- (UILabel *)staticWorkYearLabel
{
    if ( !_staticWorkYearLabel )
    {
        _staticWorkYearLabel = [[UILabel alloc] init];
        [_staticWorkYearLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticWorkYearLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _staticWorkYearLabel;
}
- (UILabel *)staticNowAddressLabel
{
    if ( !_staticNowAddressLabel )
    {
        _staticNowAddressLabel = [[UILabel alloc] init];
        [_staticNowAddressLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticNowAddressLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _staticNowAddressLabel;
}
- (UILabel *)staticWorkStateLabel
{
    if ( !_staticWorkStateLabel )
    {
        _staticWorkStateLabel = [[UILabel alloc] init];
        [_staticWorkStateLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticWorkStateLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _staticWorkStateLabel;
}
- (CPWResumeEditOneLabel *)staticOneWordLabel
{
    if ( !_staticOneWordLabel )
    {
        _staticOneWordLabel = [[CPWResumeEditOneLabel alloc] init];
        [_staticOneWordLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticOneWordLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_staticOneWordLabel setNumberOfLines:0];
    }
    return _staticOneWordLabel;
}
- (UILabel *)staticIdCardLabel
{
    if ( !_staticIdCardLabel )
    {
        _staticIdCardLabel = [[UILabel alloc] init];
        [_staticIdCardLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_staticIdCardLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
    }
    return _staticIdCardLabel;
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
