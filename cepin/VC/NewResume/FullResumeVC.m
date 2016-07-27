 //
//  FullResumeVC.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullResumeVC.h"
#import "FullMenuView.h"
#import "UIViewController+NavicationUI.h"
#import "FullInformationCell.h"
#import "FullExpectJobCell.h"
#import "FullEducationCell.h"
#import "FullJobCell.h"
#import "FullProjectCell.h"
#import "FullPracticeCell.h"
#import "FullLanguageCell.h"
#import "FullTrainCell.h"
#import "FullAppendCell.h"
#import "FullResumeVM.h"
#import "TBTextUnit.h"
#import "FullUserRemarkCell.h"
#import "FullExamReportCell.h"
#import "FullExamReportVC.h"
#import "DynamicExamModelDTO.h"
#import "AllResumeVC.h"
#import "DynamicExamDetailVC.h"
#import "NSString+Extension.h"
#import "NSDate-Utilities.h"
#import "CPResumeReviewInforView.h"
#import "CPResumeReviewExpectWorkView.h"
#import "CPResumeReviewWorkExperienceView.h"
#import "CPResumeReviewEducationExperienceView.h"
#import "CPResumeReviewProjectExperienceView.h"
#import "CPResumeReviewSelfDescribeView.h"
#import "CPResumeReviewSkillView.h"
#import "CPResumeReviewAttachInforView.h"
#import "CPResumeReviewReformer.h"
#import "CPResumeReviewStudyView.h"
#import "CPResumeReviewPracticeVeiw.h"
#import "CPReusmeReviewTrainView.h"
#import "RTNetworking+Position.h"
#import "CPReviewJobTestView.h"
#import "CPCommon.h"
#import "SDPhotoBrowser.h"
#define CPSchoolResume_Review_Header_Heihgt (( 132 + 540 + 40 ) / CP_GLOBALSCALE)
@interface FullResumeVC ()<FullMenuViewDelegate, SDPhotoBrowserDelegate, CPReviewAttachInformationViewDelegate>
@property(nonatomic,strong) FullMenuView *menuView;
@property(nonatomic,strong) FullResumeVM *viewModel;
@property(nonatomic,strong) ResumeNameModel *model;
@property(nonatomic,strong) NSString *cityStr;
@property(nonatomic,strong) NSString *functionStr;
@property(nonatomic,assign) CGFloat proHeight;
@property(nonatomic,assign) CGFloat stuHeight;
@property(nonatomic,assign) CGFloat trainHeight;
@property(nonatomic,assign) int numbers;
@property (nonatomic, assign) CGFloat languageViewHeight;
@property (nonatomic, copy) NSDictionary *CET4ScoreDict;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *oneDescribeLabel;
@property (nonatomic, strong) UILabel *baseInforLabel;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIView *phoneEmailView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) NSMutableArray *jobStatusArray;
@property (nonatomic, strong) CPResumeReviewInforView *reviewInforView;
@property (nonatomic, strong) CPResumeReviewExpectWorkView  *reviewExpectWorkView;
@property (nonatomic, strong) CPResumeReviewWorkExperienceView *reviewWorkExperienceView;
@property (nonatomic, strong) CPResumeReviewEducationExperienceView *reviewEducationExperienceView;
@property (nonatomic, strong) CPResumeReviewProjectExperienceView *reviewProjectExperienceView;
@property (nonatomic, strong) CPResumeReviewSelfDescribeView *reviewSelfDescribeView;
@property (nonatomic, strong) CPResumeReviewSkillView *reviewSkillView;
@property (nonatomic, strong) CPResumeReviewAttachInforView *reviewAttachInforView;
@property (nonatomic, strong) CPResumeReviewStudyView *reviewStudyView;
@property (nonatomic, strong) CPResumeReviewPracticeVeiw *reviewPracticeView;
@property (nonatomic, strong) CPReusmeReviewTrainView *reviewTrainView;
@property (nonatomic, strong) CPReviewJobTestView *jobTestView;
@property (nonatomic, strong) UIButton *checkTestReportButton;
@property (nonatomic, strong) NSDictionary *examFinishDict;
@property (nonatomic, strong) UIView *maxSelecetdTipsView;
@end
@implementation FullResumeVC
- (NSDictionary *)CET4ScoreDict
{
    if ( !_CET4ScoreDict )
    {
        if (self.viewModel.data)
        {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            
            if ( self.viewModel.data.IsHasCET4Score.intValue == 1 && self.viewModel.data.CET4Score)
            {
                [tempDict setObject:self.viewModel.data.CET4Score forKey:@"英语 CET4"];
            }
            
            if ( self.viewModel.data.IsHasCET6Score.intValue == 1 && self.viewModel.data.TEM8Score)
            {
                [tempDict setObject:self.viewModel.data.CET6Score forKey:@"英语 CET6"];
            }
            
            if ( self.viewModel.data.IsHasTEM4Score.intValue == 1 && self.viewModel.data.TEM8Score)
            {
                [tempDict setObject:self.viewModel.data.TEM4Score forKey:@"英语 TEM4"];
            }
            
            if ( self.viewModel.data.IsHasTEM8Score.intValue == 1 && self.viewModel.data.TEM8Score)
            {
                [tempDict setObject:self.viewModel.data.TEM8Score forKey:@"英语 TEM8"];
            }
            
            if ( self.viewModel.data.IsHasIELTSScore.intValue == 1 && self.viewModel.data.IELTSScore)
            {
                [tempDict setObject:self.viewModel.data.IELTSScore forKey:@"英语 雅思"];
            }
            
            if ( self.viewModel.data.IsHasTOEFLScore.intValue == 1  && self.viewModel.data.TOEFLScore)
            {
                [tempDict setObject:self.viewModel.data.TOEFLScore forKey:@"英语 托福"];
            }
            
            if ( tempDict.count > 0 )
                _CET4ScoreDict = [tempDict copy];
            
        }
    }
    return _CET4ScoreDict;
}
//时间
- (NSString *)managestrTime:(NSString *)time
{
    if (!time || [time isEqualToString:@""]) {
        return @"至今";
    }else{
        return [NSDate cepinYMDFromString:time];
    }
}
// 计算专业证书的高度
- (CGFloat)caculateCredentialHeight:(CredentialListDataModel *)model
{
    if ( !model )
        return 0;
    
    NSString *time = [self managestrTime:model.Date];
    
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  专业证书";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    NSMutableString *strM = [[NSMutableString alloc] initWithString:[timeAttStr string]];
    if ( model.Name && model.Name.length > 0 )
        [strM appendFormat:@"\n%@", model.Name];
    
    CGFloat tempH = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:[strM copy] andWith:kScreenWidth - 40 - 40 / CP_GLOBALSCALE].height;
    
    return tempH + 5.0 + 40 / CP_GLOBALSCALE * 2;
}
// 计算专业技能的高度
- (CGFloat)caculateSkill:(SkillDataModel *)model
{
    if ( !model )
        return 0;
    
    SkillDataModel *skillModel = model;
    
    NSString *time = [NSString stringWithFormat:@"%@  |  %@", skillModel.Name, skillModel.MasteryLevel];
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  专业技能";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    CGFloat tempH = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:[timeAttStr string] andWith:kScreenWidth - 40 - 40 / CP_GLOBALSCALE].height;
    return tempH + 5.0 + 40 / CP_GLOBALSCALE * 2;
}
// 计算英语等级的高度
- (CGFloat)caculateEnglish:(NSString *)name score:(NSNumber *)score
{
    NSString *time = nil;
    
    if ( [score.stringValue rangeOfString:@"."].length > 0 )
        time = [NSString stringWithFormat:@"%@（%.1lf分）", name, score.floatValue];
    else
        time = [NSString stringWithFormat:@"%@（%ld分）", name, score.integerValue];
    
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  英语等级";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    CGFloat tempH = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:[timeAttStr string] andWith:kScreenWidth - 40 - 40 / CP_GLOBALSCALE].height;
    
    return tempH + 5.0 + 40 / CP_GLOBALSCALE * 2;
}
// 计算其它语言的高度
- (CGFloat)caculateOtherLanguage:(LanguageDataModel *)model
{
    LanguageDataModel *lanModel = model;
    
    NSMutableString *lanMutStr = [NSMutableString stringWithString:lanModel.Name];
    NSString *tempStr = nil;
    if ( lanModel.Speaking.length > 0 && lanModel.Writing.length > 0)
    {
        tempStr = [NSString stringWithFormat:@"（听说%@、读写%@）", lanModel.Speaking, lanModel.Writing];
    }
    else if ( lanModel.Speaking.length > 0 )
    {
        tempStr = [NSString stringWithFormat:@"（听说%@）", lanModel.Speaking];
    }
    else if ( lanModel.Writing.length > 0 )
    {
        tempStr = [NSString stringWithFormat:@"（读写%@）", lanModel.Writing];
    }
    
    if ( tempStr )
        [lanMutStr appendString:tempStr];
    
    NSMutableAttributedString *nameAttStr = [[NSMutableAttributedString alloc] initWithString:lanMutStr attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *append = @"  |  其它语言能力";
    NSAttributedString *appendAttStr = [[NSAttributedString alloc] initWithString:append attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [nameAttStr appendAttributedString:appendAttStr];
    
    CGFloat tempH = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:[nameAttStr string] andWith:kScreenWidth - 40 - 40 / CP_GLOBALSCALE].height;
    return tempH + 5.0 + 40 / CP_GLOBALSCALE * 2;
}
- (instancetype)initWithResumeId:(NSString *)resumeId
{
    self = [super init];
    if (self) {
        self.viewModel = [[FullResumeVM alloc]initWithResumeId:resumeId];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobStatusArray = [BaseCode JobStatus];
    self.title = @"预览简历";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight + 15 * 250)];
    @weakify(self)
    [RACObserve(self.viewModel, stateCode)subscribeNext:^(id stateCode) {
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            self.tableView.hidden = NO;
            self.model = self.viewModel.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resetData];
                [self checkIsExam];
            });
        }
        else if ([self requestStateWithStateCode:stateCode]== HUDCodeNetWork)
        {
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
            self.tableView.hidden = YES;
        }
    }];
    [RACObserve( self.viewModel, reportStateCode) subscribeNext:^(id stateCode ) {
        @strongify( self );
        if ( stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess )
        {
            [self checkIsExam];
        }
    }];
    [self.viewModel getFullResumeDetail];
    [self.viewModel getExamReport];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 64, kScreenWidth, 6 / CP_GLOBALSCALE );
    gradient.borderWidth = 0;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithHexString:@"000000" alpha:0.04] CGColor],
                       (id)[[UIColor clearColor] CGColor], nil];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    [self.view.layer addSublayer:gradient];
    [self.view addSubview:self.maxSelecetdTipsView];
}
- (void)checkIsExam
{
    if ( self.examFinishDict )
        self.examFinishDict = nil;
    NSString *strUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if ( 0 == [strUserID length] || 0 == [strTocken length] )
        return;
    __weak typeof( self ) weakSelf = self;
    RACSignal *checkExamSignal = [[RTNetworking shareInstance] isExamWithTokenId:strTocken userId:strUserID];
    [checkExamSignal subscribeNext:^(RACTuple *tuple) {
        NSDictionary *dict = (NSDictionary *)tuple.second;
        if ( [dict resultSucess] )
        {
            weakSelf.examFinishDict = [dict resultObject];
        }
        [weakSelf resetScrollViewSize];
    }];
}
- (void)resetScrollViewSize
{
    CGFloat changeHeight = ( 40 ) / CP_GLOBALSCALE + CPSchoolResume_Review_Header_Heihgt;
    if ( self.examFinishDict )
    {
        NSString *finishExam = nil;
        if ( ![[self.examFinishDict objectForKey:@"IsFinshed"] isKindOfClass:[NSNull class]] )
        {
            finishExam = [self.examFinishDict objectForKey:@"IsFinshed"];
        }
        if ( finishExam.intValue == 1 && 0 < [self.viewModel.reportDatas count] )
        {
            changeHeight += ( 144 + 40 ) / CP_GLOBALSCALE;
            [self.checkTestReportButton setHidden:NO];
        }
        else
        {
            [self.checkTestReportButton setHidden:YES];
        }
    }
    else
    {
        [self.checkTestReportButton setHidden:YES];
    }
    changeHeight += [CPResumeReviewReformer reviewInformationHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewInformationHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    changeHeight += [CPResumeReviewReformer reviewExpectWorkHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewExpectWorkHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    changeHeight += [CPResumeReviewReformer reviewEducationHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewEducationHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    changeHeight += [CPResumeReviewReformer reviewDescribeHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewDescribeHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    changeHeight += [CPResumeReviewReformer reviewStudyTotalHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewStudyTotalHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    changeHeight += [CPResumeReviewReformer reviewProjectTotalHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewProjectTotalHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    changeHeight += [CPResumeReviewReformer reviewTrainTotalHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewTrainTotalHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    changeHeight += [CPResumeReviewReformer reviewSkillTotalHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewSkillTotalHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    changeHeight += [CPResumeReviewReformer reviewPraciticeTotalHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewPraciticeTotalHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    changeHeight += [CPResumeReviewReformer reviewAttachmentTotalHeight:self.model] > 0 ? ([CPResumeReviewReformer reviewAttachmentTotalHeight:self.model] + 40 / CP_GLOBALSCALE) : 0;
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth, changeHeight)];
}
- (void)resetData
{
    [self setTitle:self.model.ResumeName];
    [self resetScrollViewSize];
    [self resetHeaderView];
    [self.reviewInforView configWithResume:self.model];
    [self.reviewExpectWorkView configWithResume:self.model];
    [self.reviewEducationExperienceView configWithResume:self.model];
    [self.reviewSelfDescribeView configWithResume:self.model];
    [self.reviewStudyView configWithResume:self.model];
    [self.reviewProjectExperienceView configWithResume:self.model];
    [self.reviewPracticeView configWithResume:self.model];
    [self.reviewTrainView configWithResume:self.model];
    [self.reviewSkillView configWithResume:self.model];
    [self.reviewAttachInforView configWithResume:self.model];
    [self.reviewInforView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.phoneEmailView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewInformationHeight:self.model] ) );
    }];
    [self.reviewExpectWorkView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.reviewInforView.mas_bottom ).offset( 0 == [CPResumeReviewReformer reviewExpectWorkHeight:self.model] ? 0 : 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewExpectWorkHeight:self.model] ) );
    }];
    [self.reviewEducationExperienceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.reviewExpectWorkView.mas_bottom ).offset( 0 == [CPResumeReviewReformer reviewEducationHeight:self.model] ? 0 : 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewEducationHeight:self.model] ) );
    }];
    [self.reviewSelfDescribeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.reviewEducationExperienceView.mas_bottom ).offset( 0 == [CPResumeReviewReformer reviewDescribeHeight:self.model] ? 0 : 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewDescribeHeight:self.model] ) );
    }];
    [self.reviewStudyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.reviewSelfDescribeView.mas_bottom ).offset( 0 == [CPResumeReviewReformer reviewStudyTotalHeight:self.model] ? 0 : 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewStudyTotalHeight:self.model] ) );
    }];
    [self.reviewProjectExperienceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.reviewStudyView.mas_bottom ).offset( 0 == [CPResumeReviewReformer reviewProjectTotalHeight:self.model] ? 0 : 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewProjectTotalHeight:self.model] ) );
    }];
    [self.reviewPracticeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.reviewProjectExperienceView.mas_bottom ).offset( 0 == [CPResumeReviewReformer reviewPraciticeTotalHeight:self.model] ? 0 : 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewPraciticeTotalHeight:self.model] ) );
    }];
    [self.reviewTrainView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.reviewPracticeView.mas_bottom ).offset( 0 == [CPResumeReviewReformer reviewTrainTotalHeight:self.model] ? 0 : 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewTrainTotalHeight:self.model] ) );
    }];
    [self.reviewSkillView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.reviewTrainView.mas_bottom ).offset( 0 == [CPResumeReviewReformer reviewSkillTotalHeight:self.model] ? 0 : 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewSkillTotalHeight:self.model] ) );
    }];
    [self.reviewAttachInforView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.reviewSkillView.mas_bottom ).offset( 0 == [CPResumeReviewReformer reviewAttachmentTotalHeight:self.model] ? 0 : 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ));
        make.height.equalTo( @( [CPResumeReviewReformer reviewAttachmentTotalHeight:self.model] ) );
    }];
}
- (void)resetHeaderView
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.PhotoUrlPath] placeholderImage:[UIImage imageNamed:@"portrait"]];
    [self.userNameLabel setText:self.model.ChineseName];
//    Gender;//	Int	性别（0 未知1：男 ，2：女）
    if ( 1 == [self.model.Gender intValue] )
    {
        self.sexImageView.image = [UIImage imageNamed:@"resume_ic_male"];
    }
    else if ( 2 == [self.model.Gender intValue] )
    {
        self.sexImageView.image = [UIImage imageNamed:@"resume_ic_female"];
    }
    NSMutableArray *array = [BaseCode baseWithCodeKey:self.model.JobStatus];
    BaseCode *item = array[0];
    [self.oneDescribeLabel setText:item.CodeName];
    NSMutableString *appStrM = [NSMutableString string];
    if ( self.model.Age )
        [appStrM appendFormat:@"%@岁", self.model.Age];
    if ( self.model.Degree && 0 < [self.model.Degree length] )
    {
        if ( 0 < [appStrM length] )
            [appStrM appendFormat:@"  |  %@", self.model.Degree];
        else
            [appStrM appendFormat:@"%@", self.model.Degree];
    }
    if ( self.model.WorkYear )
    {
        NSString *workYearString = self.model.WorkYear;
        for ( BaseCode *baseCode in self.viewModel.workYearArrayM )
        {
            if ( baseCode.CodeKey.intValue == self.model.WorkYearKey.intValue )
            {
                workYearString = baseCode.CodeName;
                break;
            }
        }
        if ( 0 < [appStrM length] )
            [appStrM appendFormat:@"  |  %@", workYearString];
        else
            [appStrM appendFormat:@"%@", workYearString];
    }
    [self.baseInforLabel setText:[appStrM copy]];
    [self.phoneLabel setText:self.model.Mobile];
    [self.emailLabel setText:self.model.Email];
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getFullResumeDetail];
    [self.viewModel getExamReport];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark - FullMenuViewDelegate
-(void)didResumeMenuTouch:(int)index
{
    switch (index)
    {
        case 0:
        {
            [self.viewModel toTop];
        }
            break;
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除简历" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
            break;
            
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.viewModel deleteResume];
        });
    }
}
#pragma mark - delegate - datasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numbers;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int hight = 102 / CP_GLOBALSCALE * CP_RECOMMEND_SCALE;
    CGFloat vertical_marge = 40 / CP_GLOBALSCALE * CP_RECOMMEND_SCALE;
    switch (indexPath.row) {
        case 0:
            if(self.model && [self.model.ResumeType intValue] == 2)
                return 520.0 + 40 / CP_GLOBALSCALE;
            else
                return 265.0;
            break;
        case 1: // 期望工作
        {
//            NSString *str = [NSString stringWithFormat:@"%@,%@,%@,%@",self.model.ExpectCity,self.model.ExpectEmployType,self.model.ExpectJobFunction,self.model.ExpectSalary];
//            if (str && ![str isEqualToString:@""]) {
////                int height = StringFontSizeH(str, [[RTAPPUIHelper shareInstance] searchResultSubFont], kScreenWidth - 40) + hight + vertical_marge * 2;
//                int height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultSubFont]  text:str andWith:self.view.viewWidth - 2 * vertical_marge].height + hight;
//                
//                return height;
//            }
//            return hight + vertical_marge;
            
            NSMutableArray *addressArray = [Region searchAddressWithAddressPathCodeString:self.model.ExpectCity];
            
            NSString *type = nil;
            if ([self.model.ExpectEmployType isEqualToString:@"1"] || [self.model.ExpectEmployType isEqualToString:@""] || !self.model.ExpectEmployType) {
                type = @"全职";
            }else
            {
                type = @"实习";
            }
            
            NSMutableArray *arrarCode = [BaseCode baseCodeWithCodeKeys:self.model.ExpectJobFunction];
            NSString *str = [TBTextUnit ResumeDetail:[TBTextUnit allRegionCitiesWithRegions:addressArray] nature:type job:[TBTextUnit baseCodeNameWithBaseCodes:arrarCode] salary:self.model.ExpectSalary];
            NSMutableString *strM = [NSMutableString stringWithString:str];
            if(self.model.ResumeType.intValue == 2){
                if(self.model.AvailableType)
                {
                    [strM appendFormat:@" / %@到岗，", self.model.AvailableType];
                }
                else
                {
                    [strM appendFormat:@" / %@到岗时间，", @"没填写具体"];
                }
                
                // 修复正确显示是否服从分配
                // 1不服从，0服从
                NSString *distribution = self.model.IsAllowDistribution.intValue ? @"服从分配" : @"不服从分配";
                
                [strM appendString:distribution];
            }
            
            CGFloat noWordHeight = [[RTAPPUIHelper shareInstance] searchResultSubFont].pointSize * 2.0;
            
            CGFloat height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultSubFont]  text:strM andWith:kScreenWidth - 40 / CP_GLOBALSCALE * 2].height;
            
            if ( height < noWordHeight && self.model.ResumeType.intValue == 2 )
                height = noWordHeight + 102.0 / CP_GLOBALSCALE + 5.0;
            else
                height = height + 102.0 / CP_GLOBALSCALE;
            
            return height + 40 / CP_GLOBALSCALE * 2;
            
        }
            break;
        case 2: // 自我描述
        {
            NSString *str = self.viewModel.data.UserRemark;
//            int height = StringFontSizeH(str, [[RTAPPUIHelper shareInstance] searchResultSubFont], kScreenWidth - 40) + 102 / CP_GLOBALSCALE + vertical_marge * 2;
            
            if ( !str || str.length == 0 )
            {
//                return hight + vertical_marge;
//                return 102 / CP_GLOBALSCALE + 120 / CP_GLOBALSCALE;
                
//                return 85;
                str = @"自我描述，你还可以输入500个中文字";
            }
            
            CGFloat height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultSubFont] text:str andWith:kScreenWidth - 40 / CP_GLOBALSCALE * 2].height;
            
//            if ( str.length == 500 )
//                return height + 40 / CP_GLOBALSCALE * 2 + 14.0 / CP_GLOBALSCALE;
//            else
//                return height + 40 / CP_GLOBALSCALE * 2 + 14.0 / CP_GLOBALSCALE;
            
            if ( height > 16.4 )
                return height + 102 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE * 2 + 14.0 / 4.0;
            else
                return height + 102 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE * 2;
        }
            break;
        case 3: // 教育背景
        {
            if (self.model.EducationList.count > 0) {
//                return 80*self.model.EducationList.count + 60;
//                return CP_EDUCATION_HEIGHT * self.model.EducationList.count + hight + vertical_marge / 2.0;
                CGFloat tempH = [[RTAPPUIHelper shareInstance] searchResultSubFont].pointSize * 3 + 5 * 3 + 40 / CP_GLOBALSCALE * 2;
                CGFloat totalHeight = 0;
                CGFloat maxMarge = kScreenWidth - 40 - 40 / CP_GLOBALSCALE;
                for ( NSDictionary *dict in self.model.EducationList )
                {
                    EducationListDateModel *educationModel = [EducationListDateModel beanFromDictionary:dict];
                    
                    NSMutableString *detailStrM = [NSMutableString string];
                    
                    if ( educationModel.ScoreRanking && educationModel.ScoreRanking.length > 0 )
                    {
                        if ( [educationModel.ScoreRanking intValue] == 0 )
                        {
                            [detailStrM appendFormat:@"成绩排名 : 其他"];
                        }
                        else
                            [detailStrM appendFormat:@"成绩排名 : 年级前%@%@", educationModel.ScoreRanking, @"%"];
                    }
                    
                    if ( educationModel.Description && educationModel.Description.length > 0 )
                    {
                        if ( detailStrM.length > 0 )
                        {
                            [detailStrM appendFormat:@"\n主修课程 : %@", educationModel.Description];
                        }
                        else
                        {
                            [detailStrM appendFormat:@"主修课程 : %@", educationModel.Description];
                        }
                    }
                    
                    if ( detailStrM.length > 0 )
                    {
                        totalHeight += tempH + [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultSubFont] text:detailStrM andWith:maxMarge].height + 5.0;
                    }
                    else
                        totalHeight += tempH;
                }
                
//                return totalHeight + hight + vertical_marge / 2.0;
                return totalHeight + 102 / CP_GLOBALSCALE;
            }else {
                
                return (102 + 120) / CP_GLOBALSCALE;
            }
        }
            break;
        case 4: // 实习经历
        {
            if (self.model.WorkList.count > 0) {
                
                NSInteger totalH = 0;
                CGFloat tempH = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont].pointSize * 3 + 5 * 3 + 40 / CP_GLOBALSCALE * 2;
                CGFloat maxMarge = kScreenWidth - 40  - 40 / CP_GLOBALSCALE;
                
                for ( NSDictionary *workDict in self.model.WorkList )
                {
                    WorkListDateModel *work = [WorkListDateModel beanFromDictionary:workDict];
                    
                    NSMutableString *proveStr = [NSMutableString string];
                    if(work.AttestorName)
                    {
                        [proveStr appendFormat:@"证明人：%@", work.AttestorName];
                    }
                    
                    if(work.AttestorRelation)
                    {
                        [proveStr appendFormat:@"／%@", work.AttestorRelation];
                    }
                    
                    if(work.AttestorPosition)
                    {
                        [proveStr appendFormat:@"／%@", work.AttestorPosition];
                    }
                    
                    if(work.AttestorPhone)
                    {
                        [proveStr appendFormat:@"／%@", work.AttestorPhone];
                    }
                    
                    if(work.AttestorCompany)
                    {
                        [proveStr appendFormat:@"\n证明人单位：%@", work.AttestorCompany];
                    }
                    
                    if ( proveStr.length > 0 )
                        totalH += tempH + [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] jobInformationDetaillFont] text:proveStr andWith:maxMarge].height + 5.0;
                    else
                        totalH += tempH;
                }
                
                return totalH + 102 / CP_GLOBALSCALE;
            }
            return (102 + 120) / CP_GLOBALSCALE;
            
        }
            break;
        case 5: // 项目经验
        {
            if (self.viewModel.data.ProjectList.count > 0) {
                int a = 0;
                CGFloat fixdHeiht = [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont].pointSize * 3 + 40 / CP_GLOBALSCALE * 2 + 5 * CP_GLOBALSCALE;
                CGFloat maxMarge = kScreenWidth - 40 - 40 / CP_GLOBALSCALE;
                for (int i = 0 ; i < self.model.ProjectList.count; i++) {
                    ProjectListDataModel *projectModel = [ProjectListDataModel beanFromDictionary:self.model.ProjectList[i]];
                    NSString *str = projectModel.Content?projectModel.Content:@"";
                    
                    if ( str.length == 0 )
                    {
                        a += fixdHeiht;
                        continue;
                    }
                    
                    int height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultTipsHeadFont] text:str andWith:maxMarge].height + 5.0;
                    a += height + fixdHeiht;
                }
                self.proHeight = a;
                return 102 / CP_GLOBALSCALE + a;
            }
            
            self.proHeight = 0;
//             return hight + vertical_marge;
            return ( 102 + 120 ) / CP_GLOBALSCALE;
        
        }
            break;
        case 6: // 实践经历
        {
            if (self.viewModel.data.PracticeList.count > 0 || self.viewModel.data.StudentLeadersList.count > 0 || self.viewModel.data.AwardsList.count > 0) {

                CGFloat practiceHeight = 0;
                CGFloat tempPracticeH = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize * 3 + 5 * 3 + 40 / CP_GLOBALSCALE * 2;
                
                // 社会实践
                for ( NSDictionary *dict in self.viewModel.data.PracticeList )
                {
                    CGFloat maxMarge = kScreenWidth - 40 - 40 / CP_GLOBALSCALE;
                    
                    CGSize practiceSize = CGSizeZero;
                    
                    PracticalListDataModel *practice = [PracticalListDataModel beanFromDictionary:dict];
                    
                    if ( practice.Content && practice.Content.length > 0 )
                    {
                        practiceSize = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:practice.Content andWith:maxMarge];
                        practiceHeight += practiceSize.height + 5.0;
                    }
                    
                    practiceHeight += tempPracticeH;
                }
                
                // 获奖情况
                CGFloat awardsHeight = 0;
                for ( NSDictionary *dict in self.viewModel.data.AwardsList )
                {
                    AwardsListDataModel *award = [AwardsListDataModel beanFromDictionary:dict];
                    NSString *star = [self manageStrTime:award.StartDate];
                    NSString *time = [NSString stringWithFormat:@"%@",star];
                    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
                    NSString *app = @"  |  获奖情况";
                    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
                    [timeAttStr appendAttributedString:appAttStr];
                    NSMutableString *strM = [[NSMutableString alloc] initWithString:[timeAttStr string]];
                    NSString *nameStr = [NSString stringWithFormat:@"%@  |  %@", award.Name, award.Level];
                    if ( nameStr && nameStr.length > 0 )
                        [strM appendFormat:@"\n%@", nameStr];
                    
                    if ( strM && strM.length > 0 )
                    {
                        CGFloat awardTempHeight = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:strM andWith:kScreenWidth - 40 - 40 / CP_GLOBALSCALE].height;
                        
                        awardsHeight += awardTempHeight + 5 * 2 + 40 / CP_GLOBALSCALE * 2;
                    }
                }
                
                // 学生干部
                CGFloat studentHeith = 0;
                for ( NSDictionary *dict in self.viewModel.data.StudentLeadersList )
                {
                    StudentLeadersDataModel *StuModel = [StudentLeadersDataModel beanFromDictionary:dict];
                    NSString *star = [self manageStrTime:StuModel.StartDate];
                    NSString *end = [self manageStrTime:StuModel.EndDate];
                    
                    NSString *time = [NSString stringWithFormat:@"%@ - %@", star, end];
                    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
                    NSString *app = @"  |  学生干部";
                    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
                    [timeAttStr appendAttributedString:appAttStr];
                    
                    NSMutableString *strM = [[NSMutableString alloc] initWithString:[timeAttStr string]];
                    NSString *nameStr = [NSString stringWithFormat:@"%@  |  %@", StuModel.Name, StuModel.Level];
                    if ( nameStr && nameStr.length > 0 )
                        [strM appendFormat:@"\n%@", nameStr];
                    
                    if ( strM && strM.length > 0 )
                    {
                        CGFloat studentTempHeight = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:strM andWith:kScreenWidth - 40 - 40 / CP_GLOBALSCALE].height;
                        
                        studentHeith += studentTempHeight + 5 * 2 + 40 / CP_GLOBALSCALE * 2;
                    }
                }
                
                self.stuHeight = practiceHeight + awardsHeight + studentHeith;
                return self.stuHeight + 102 / CP_GLOBALSCALE;
            }
            self.stuHeight = 0;
            return (102 + 120) / CP_GLOBALSCALE;
            
        }
            break;
        case 7: // 语言及技能
        {
            CGFloat totalHeight = 0;
            
            for ( NSDictionary *dict in self.viewModel.data.CredentialList )
            {
                CredentialListDataModel *gredentialModel = [CredentialListDataModel beanFromDictionary:dict];
                
                totalHeight += [self caculateCredentialHeight:gredentialModel];
            }
            
            for ( NSDictionary *dict in self.viewModel.data.SkillList )
            {
                SkillDataModel *skillModel = [SkillDataModel beanFromDictionary:dict];
                
                totalHeight += [self caculateSkill:skillModel];
            }
            
            for ( NSString *str in [self.CET4ScoreDict allKeys] )
            {
                NSString *name = str;
                NSNumber *score = [self.CET4ScoreDict valueForKey:name];
                
                totalHeight += [self caculateEnglish:name score:score];
            }
            
            for ( NSDictionary *dict in self.viewModel.data.LanguageList )
            {
                LanguageDataModel *otherModel = [LanguageDataModel beanFromDictionary:dict];
                totalHeight += [self caculateOtherLanguage:otherModel];
            }
            
            if ( totalHeight > 0 )
            {
                self.languageViewHeight = totalHeight;
                return self.languageViewHeight  + 102 / CP_GLOBALSCALE;
            }
            
//            self.languageViewHeight = 0;
            return (102 + 120) / CP_GLOBALSCALE;
        }
            break;
        case 8: // 培训经历
        {
            if (self.viewModel.data.TrainingList.count > 0) {
                int a = 0;
                CGFloat maxMarge = kScreenWidth - 40 - 40 / CP_GLOBALSCALE;
                CGFloat fixdHeight = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont].pointSize * 2 + 40 / CP_GLOBALSCALE * 2 + 5.0 * 2;
                for (int i = 0 ; i < self.model.TrainingList.count; i++) {
                    TrainingDataModel *TrainModel = [TrainingDataModel beanFromDictionary:self.viewModel.data.TrainingList[i]];
                    NSString *str = TrainModel.Content?TrainModel.Content:@"";
                    if ( str.length == 0 )
                        continue;
                    
                    int height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultTipsHeadFont] text:str andWith:maxMarge].height + 5.0 * 2;
                    a += fixdHeight + height;
                    
                }
                self.trainHeight = a;
                return a + 102 / CP_GLOBALSCALE ;
                
            }
            self.trainHeight = 0;
            return self.trainHeight + hight + vertical_marge;
        }
            break;
        case 9:
        {
            NSString *str = self.viewModel.data.AdditionInfo;
//            if ( str.length == 0 )
//                return hight + vertical_marge;
            
            CGFloat height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultSubFont] text:str andWith:kScreenWidth - 40 / CP_GLOBALSCALE * 2].height;
            
//            if ( str.length == 500 )
//                return height + 102 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE * 2 + 14.0 / CP_GLOBALSCALE;
//            else
//                return height + 102 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE * 2 + 14.0 / CP_GLOBALSCALE;
            if ( height > 16.4 )
                return height + 102 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE * 2 + 16.4;
            else
                return height + 102 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE * 2;
        }
            break;
        case 10:
        {
            return 47;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 基本信息
    if (indexPath.row == 0) {
        FullInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullInformationCell class])];
        if (cell == nil) {
            cell = [[FullInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullInformationCell class])];
        }
        [cell createCellWithModel:self.model];
        return cell;
    }
    // 期望工作
    if (indexPath.row == 1)
    {
        FullExpectJobCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullExpectJobCell class])];
        if (cell == nil) {
            cell = [[FullExpectJobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullExpectJobCell class])];
        }
        cell.titleLabel.text = @"期望工作";
        [cell createCellWithModel:self.model];
        return cell;
    }
    if (indexPath.row == 2) {
        FullUserRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullUserRemarkCell class])];
        if (cell == nil) {
            cell = [[FullUserRemarkCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullUserRemarkCell class])];
        }
        cell.titleLabel.text = @"自我描述";
        if (self.model.UserRemark &&![self.model.UserRemark isEqualToString:@""]) {
            [cell changeAppendText:self.model.UserRemark];
        }
        else
        {
            [cell changeAppendText:@"自我描述，你还可以输入500个中文字"];
        }
        return cell;
    }
    if(indexPath.row == 3){
        FullEducationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullEducationCell class])];
        if (cell == nil) {
            cell = [[FullEducationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullEducationCell class])];
        }
        cell.titleLabel.text = @"教育背景";
        if (self.model.EducationList.count > 0) {
            [cell createCellWithModel:self.model];
            [cell desWithOut:YES];
        }else{
            [cell desWithOut:NO];
        }
        
        return cell;
    }
    if (indexPath.row == 4) {
        FullJobCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullJobCell class])];
        if (cell == nil) {
            cell = [[FullJobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullJobCell class])];
        }
        cell.titleLabel.text = @"实习经历";
        if (self.model.WorkList.count > 0) {
            [cell createCellWithModel:self.model];
            [cell desWithOut:YES];
        }else{
            [cell desWithOut:NO];
        }
        return cell;
    }
    if (indexPath.row == 5) {
        FullProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullProjectCell class])];
        if (cell == nil) {
            cell = [[FullProjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullProjectCell class])];
        }
        cell.titleLabel.text = @"项目经验";
        if (self.model.ProjectList.count > 0) {
            [cell createCellWithModel:self.model height:self.proHeight];
            [cell desWithOut:YES];

        }else{
            [cell desWithOut:NO];
        }
        return cell;
    }
    // 实践经历
    if (indexPath.row == 6) {
        FullPracticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullPracticeCell class])];
        if (cell == nil) {
            cell = [[FullPracticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullPracticeCell class])];
        }
        cell.titleLabel.text = @"实践经历";
        if (self.model.StudentLeadersList.count > 0 || self.model.AwardsList.count > 0 || self.viewModel.data.PracticeList.count > 0) {
            [cell createCellWithModel:self.model height:self.stuHeight];
            [cell desWithOut:YES];

        }else{
            [cell desWithOut:NO];
        }
        return cell;
    }
    if (indexPath.row == 7) {
        FullLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullLanguageCell class])];
        if (cell == nil) {
            cell = [[FullLanguageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullLanguageCell class])];
        }
        cell.titleLabel.text = @"语言及技能";
        if (self.model.LanguageList.count > 0 || self.model.SkillList.count > 0 || self.model.CredentialList.count > 0 || self.model.IsHasCET4Score || self.model.IsHasCET6Score || self.model.IsHasIELTSScore || self.model.IsHasTEM4Score || self.model.IsHasTEM8Score || self.model.IsHasTOEFLScore ) {
            [cell createCellWithModel:self.model languageViewHeight:self.languageViewHeight];
            [cell desWithOut:YES];

        }else{
            [cell desWithOut:NO];
        }
        return cell;
    }
    
    if (indexPath.row == 8) {
        FullTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullTrainCell class])];
        if (cell == nil) {
            cell = [[FullTrainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullTrainCell class])];
        }
        cell.titleLabel.text = @"培训经历";
        if (self.model.TrainingList.count > 0) {
             [cell createCellWithModel:self.model height:self.trainHeight];
            [cell desWithOut:YES];

        }else{
            [cell desWithOut:NO];
        }
        return cell;
    }
    if (indexPath.row == 9) {
        FullAppendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullAppendCell class])];
        if (cell == nil) {
            cell = [[FullAppendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullAppendCell class])];
        }
        cell.titleLabel.text = @"附加信息";
        if (self.viewModel.data.AdditionInfo && ![self.viewModel.data.AdditionInfo isEqualToString:@""])
        {
            cell.appendText.text = self.viewModel.data.AdditionInfo;
        }
        else
        {
            [cell changeAppendText:@"无"];
        }
        return cell;
    }
    if (indexPath.row == 10) {
        FullExamReportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullExamReportCell class])];
        if (cell == nil) {
            cell = [[FullExamReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullExamReportCell class])];
        }
        [cell.readExam handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            DynamicExamModelDTO *model = [DynamicExamModelDTO beanFromDictionary:self.viewModel.reportDatas[0]];
            
            if([model.ReportUrl rangeOfString:@"?"].location == NSNotFound){
                 model.ReportUrl = [model.ReportUrl stringByAppendingString:@"?isPreview=1"];
            }else{
                model.ReportUrl = [model.ReportUrl stringByAppendingString:@"&isPreview=1"];
            }
            DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:model.ReportUrl examDetail:examDetailOther];;
            vc.strTitle = model.Title;
            vc.title = model.Title;
            vc.isJiSuCepin = YES;
            vc.strTitle = model.Title;
            vc.urlPath = model.ExamUrl;
            vc.urlLogo = model.ImgFilePath;
            vc.contentText = model.Introduction;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    return nil;
}
- (NSString *)manageStrTime:(NSString *)time
{
    if (!time || [time isEqualToString:@""]) {
        return @"至今";
    }
    else
    {
        return [NSDate cepinYMDFromString:time];
    }
}
#pragma mark - CPResumeAttachInformationViewDelegate
- (void)reviewAttachInformationView:(CPResumeReviewAttachInforView *)reviewAttachInformationView reviewImageButton:(UIButton *)reviewImageButton imageArray:(NSArray *)imageArray isImage:(BOOL)isImage originArray:(NSArray *)originArray
{
    if ( 0 == [imageArray count] || 0 == [originArray count] )
        return;
    if ( isImage )
    {
        NSInteger tempTag = 0;
        NSDictionary *dict = [originArray objectAtIndex:reviewImageButton.tag];
        NSString *tempNameString = [dict valueForKey:@"FilePath"];
        for( NSDictionary *tempDict in imageArray )
        {
            NSString *nameString = [tempDict valueForKey:@"FilePath"];
            if ( [tempNameString isEqualToString:nameString] )
                break;
            tempTag++;
        }
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.sourceImagesContainerView = self.view;
        browser.imageCount = [imageArray count];
        browser.currentImageIndex = tempTag;
        browser.delegate = self;
        [browser show];
    }
    else
    {
        if ( !self.maxSelecetdTipsView.isHidden )
            return;
        [self.maxSelecetdTipsView setHidden:NO];
        [self.maxSelecetdTipsView setAlpha:1.0];
        __weak typeof( self ) weakSelf = self;
        [UIView animateWithDuration:1.50 animations:^{
            [weakSelf.maxSelecetdTipsView setAlpha:0.0];
        } completion:^(BOOL finished) {
            [weakSelf.maxSelecetdTipsView setHidden:YES];
        }];
    }
}
#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImage *placeholderImage = [UIImage imageNamed:@"null_pic"];
    return placeholderImage;
}
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSMutableArray *attachArray = self.viewModel.data.ResumeAttachmentList;
    NSDictionary *attachmentDict = attachArray[index];
    NSString *filePathString = [attachmentDict valueForKey:@"FilePath"];
    NSURL *filePathURL = [NSURL URLWithString:filePathString];
    return filePathURL;
}
#pragma mark - getter methods
- (UIScrollView *)backgroundScrollView
{
    if ( !_backgroundScrollView )
    {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0, kScreenWidth, self.view.viewHeight - 64.0)];
        [_backgroundScrollView setDelegate:self];
        [_backgroundScrollView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_backgroundScrollView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _backgroundScrollView.mas_top ).offset( -kScreenHeight );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( 540 / CP_GLOBALSCALE + kScreenHeight ) );
        }];
        [_backgroundScrollView addSubview:self.phoneEmailView];
        [self.phoneEmailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topView.mas_bottom );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.height.equalTo( @( 160 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( kScreenWidth ) );
        }];
        [_backgroundScrollView addSubview:self.reviewInforView];
        [self.reviewInforView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.phoneEmailView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 * 3 ) );
        }];
        [_backgroundScrollView addSubview:self.reviewExpectWorkView];
        [self.reviewExpectWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewInforView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 ) );
        }];
        [_backgroundScrollView addSubview:self.reviewEducationExperienceView];
        [self.reviewEducationExperienceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewExpectWorkView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 * 3 ) );
        }];
        [_backgroundScrollView addSubview:self.reviewSelfDescribeView];
        [self.reviewSelfDescribeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewEducationExperienceView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 ) );
        }];
        [_backgroundScrollView addSubview:self.reviewStudyView];
        [self.reviewStudyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewSelfDescribeView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 * 5 ) );
        }];
        [_backgroundScrollView addSubview:self.reviewProjectExperienceView];
        [self.reviewProjectExperienceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewStudyView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 ) );
        }];
        [_backgroundScrollView addSubview:self.reviewPracticeView];
        [self.reviewPracticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewProjectExperienceView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 ) );
        }];
        [_backgroundScrollView addSubview:self.reviewTrainView];
        [self.reviewTrainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewPracticeView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 ) );
        }];
        [_backgroundScrollView addSubview:self.reviewSkillView];
        [self.reviewSkillView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewTrainView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 ) );
        }];
        [_backgroundScrollView addSubview:self.reviewAttachInforView];
        [self.reviewAttachInforView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewSkillView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ));
            make.height.equalTo( @( 150 ) );
        }];
        [_backgroundScrollView addSubview:self.checkTestReportButton];
        [self.checkTestReportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewAttachInforView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( kScreenWidth - 40 / CP_GLOBALSCALE * 2 ) );
        }];
        [_backgroundScrollView addSubview:self.jobTestView];
        [self.jobTestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.reviewAttachInforView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( ( 120 + 2 + 6 + 60 + 42 + 40 + 120 + 60 ) / CP_GLOBALSCALE ) );
        }];
    }
    return _backgroundScrollView;
}
- (UIView *)topView
{
    if ( !_topView )
    {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, kScreenWidth, 540 / CP_GLOBALSCALE + kScreenHeight)];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"288add"]];
        [_topView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _topView.mas_top ).offset( 40 / CP_GLOBALSCALE + kScreenHeight);
            make.centerX.equalTo( _topView.mas_centerX );
            make.width.equalTo( @( 180 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 180 / CP_GLOBALSCALE ) );
        }];
        [_topView addSubview:self.sexImageView];
        [_topView addSubview:self.userNameLabel];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self.sexImageView.mas_centerY );
            make.centerX.equalTo( _topView.mas_centerX ).offset( -( 48 + 20 ) / CP_GLOBALSCALE / 2.0 );
            make.left.greaterThanOrEqualTo( _topView.mas_left );
            make.height.equalTo( self.sexImageView );
        }];
        [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.headerImageView.mas_bottom ).offset( 35 / CP_GLOBALSCALE );
            make.left.equalTo( self.userNameLabel.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
        }];
        [_topView addSubview:self.oneDescribeLabel];
        [self.oneDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.userNameLabel.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.height.equalTo( @( self.oneDescribeLabel.font.pointSize ) );
            make.centerX.equalTo( _topView.mas_centerX );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"247dc8"]];
        [_topView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.oneDescribeLabel.mas_bottom ).offset( 45 / CP_GLOBALSCALE );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _topView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [_topView addSubview:self.baseInforLabel];
        [self.baseInforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom ).offset( 36 / CP_GLOBALSCALE );
            make.centerX.equalTo( _topView.mas_centerX );
        }];
    }
    return _topView;
}
- (UIImageView *)headerImageView
{
    if ( !_headerImageView )
    {
        _headerImageView = [[UIImageView alloc] init];
        [_headerImageView.layer setCornerRadius:186 / CP_GLOBALSCALE / 2.0];
        [_headerImageView.layer setMasksToBounds:YES];
        _headerImageView.image = [UIImage imageNamed:@"portrait"];
    }
    return _headerImageView;
}
- (UILabel *)userNameLabel
{
    if ( !_userNameLabel )
    {
        _userNameLabel = [[UILabel alloc] init];
        [_userNameLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_userNameLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_userNameLabel setText:@"姓名"];
        [_userNameLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _userNameLabel;
}
- (UIImageView *)sexImageView
{
    if ( !_sexImageView )
    {
        _sexImageView = [[UIImageView alloc] init];
        _sexImageView.image = [UIImage imageNamed:@"resume_ic_male"];
    }
    return _sexImageView;
}
- (UILabel *)oneDescribeLabel
{
    if ( !_oneDescribeLabel )
    {
        _oneDescribeLabel = [[UILabel alloc] init];
        [_oneDescribeLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_oneDescribeLabel setTextColor:[UIColor colorWithHexString:@"90caf9"]];
        [_oneDescribeLabel setTextAlignment:NSTextAlignmentCenter];
        [_oneDescribeLabel setText:@"有更好机会考虑换工作"];
    }
    return _oneDescribeLabel;
}
- (UILabel *)baseInforLabel
{
    if ( !_baseInforLabel )
    {
        _baseInforLabel = [[UILabel alloc] init];
        [_baseInforLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_baseInforLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_baseInforLabel setText:@"博士"];
    }
    return _baseInforLabel;
}
- (UIView *)phoneEmailView
{
    if ( !_phoneEmailView )
    {
        _phoneEmailView = [[UIView alloc] init];
        [_phoneEmailView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"e6e6ea"]];
        [_phoneEmailView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _phoneEmailView.mas_bottom );
            make.left.equalTo( _phoneEmailView.mas_left );
            make.right.equalTo( _phoneEmailView.mas_right );
            make.height.equalTo( @( 6 / CP_GLOBALSCALE ) );
        }];
        UIImageView *phoneImage = [[UIImageView alloc] init];
        phoneImage.image = [UIImage imageNamed:@"resume_ic_phone"];
        [_phoneEmailView addSubview:phoneImage];
        [phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _phoneEmailView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.centerY.equalTo( _phoneEmailView.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        [_phoneEmailView addSubview:self.phoneLabel];
        [_phoneEmailView addSubview:self.emailLabel];
        UIImageView *emailImage = [[UIImageView alloc] init];
        emailImage.image = [UIImage imageNamed:@"resume_ic_mail"];
        [_phoneEmailView addSubview:emailImage];
        [emailImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.phoneLabel.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.centerY.equalTo( _phoneEmailView.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( phoneImage.mas_right ).offset( 15 / CP_GLOBALSCALE );
            make.top.equalTo( _phoneEmailView.mas_top );
            make.bottom.equalTo( _phoneEmailView.mas_bottom );
        }];
        [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( emailImage.mas_right ).offset( 15 / CP_GLOBALSCALE );
            make.top.equalTo( _phoneEmailView.mas_top );
            make.bottom.equalTo( _phoneEmailView.mas_bottom );
            make.right.lessThanOrEqualTo( _phoneEmailView.mas_right );
        }];
    }
    return _phoneEmailView;
}
- (UILabel *)phoneLabel
{
    if ( !_phoneLabel )
    {
        _phoneLabel = [[UILabel alloc] init];
        [_phoneLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_phoneLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_phoneLabel setText:@"1234567890"];
    }
    return _phoneLabel;
}
- (UILabel *)emailLabel
{
    if ( !_emailLabel )
    {
        _emailLabel = [[UILabel alloc] init];
        [_emailLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [_emailLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_emailLabel setText:@"123456@qq.com7890"];
    }
    return _emailLabel;
}
- (CPResumeReviewInforView *)reviewInforView
{
    if ( !_reviewInforView )
    {
        _reviewInforView = [[CPResumeReviewInforView alloc] initWithFrame:self.view.bounds];
    }
    return _reviewInforView;
}
- (CPResumeReviewExpectWorkView *)reviewExpectWorkView
{
    if ( !_reviewExpectWorkView )
    {
        _reviewExpectWorkView = [[CPResumeReviewExpectWorkView alloc] initWithFrame:self.view.bounds];
    }
    return _reviewExpectWorkView;
}
- (CPResumeReviewWorkExperienceView *)reviewWorkExperienceView
{
    if ( !_reviewWorkExperienceView )
    {
        _reviewWorkExperienceView = [[CPResumeReviewWorkExperienceView alloc] initWithFrame:self.view.bounds];
    }
    return _reviewWorkExperienceView;
}
- (CPResumeReviewEducationExperienceView *)reviewEducationExperienceView
{
    if ( !_reviewEducationExperienceView )
    {
        _reviewEducationExperienceView = [[CPResumeReviewEducationExperienceView alloc] initWithFrame:self.view.bounds];
    }
    return _reviewEducationExperienceView;
}
- (CPResumeReviewProjectExperienceView *)reviewProjectExperienceView
{
    if ( !_reviewProjectExperienceView )
    {
        _reviewProjectExperienceView = [[CPResumeReviewProjectExperienceView alloc] initWithFrame:self.view.bounds];
    }
    return _reviewProjectExperienceView;
}
- (CPResumeReviewSelfDescribeView *)reviewSelfDescribeView
{
    if ( !_reviewSelfDescribeView )
    {
        _reviewSelfDescribeView = [[CPResumeReviewSelfDescribeView alloc] initWithFrame:self.view.bounds];
    }
    return _reviewSelfDescribeView;
}
- (CPResumeReviewSkillView *)reviewSkillView
{
    if ( !_reviewSkillView )
    {
        _reviewSkillView = [[CPResumeReviewSkillView alloc] initWithFrame:self.view.bounds];
    }
    return _reviewSkillView;
}
- (CPResumeReviewAttachInforView *)reviewAttachInforView
{
    if ( !_reviewAttachInforView )
    {
        _reviewAttachInforView = [[CPResumeReviewAttachInforView alloc] initWithFrame:self.view.bounds];
        [_reviewAttachInforView setReviewAttachInformationViewDelegate:self];
    }
    return _reviewAttachInforView;
}
- (CPResumeReviewStudyView *)reviewStudyView
{
    if ( !_reviewStudyView )
    {
        _reviewStudyView = [[CPResumeReviewStudyView alloc] initWithFrame:self.view.bounds];
    }
    return _reviewStudyView;
}
- (CPResumeReviewPracticeVeiw *)reviewPracticeView
{
    if ( !_reviewPracticeView )
    {
        _reviewPracticeView = [[CPResumeReviewPracticeVeiw alloc] initWithFrame:self.view.bounds];
    }
    return _reviewPracticeView;
}
- (CPReusmeReviewTrainView *)reviewTrainView
{
    if ( !_reviewTrainView )
    {
        _reviewTrainView = [[CPReusmeReviewTrainView alloc] initWithFrame:self.view.bounds];
    }
    return _reviewTrainView;
}
- (CPReviewJobTestView *)jobTestView
{
    if ( !_jobTestView )
    {
        _jobTestView = [[CPReviewJobTestView alloc] initWithFrame:self.view.bounds];
        [_jobTestView setHidden:YES];
        [_jobTestView.beginTestButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            NSString *url = [NSString stringWithFormat:@"%@/examcenter/desc?id=2",kHostMUrl];
            DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:url examDetail:examDetailOther];
            vc.title = @"极速职业测评";
            vc.strTitle = @"极速职业测评";
            vc.urlPath = url;
            vc.isJiSuCepin = YES;
            vc.urlLogo = @"http://file.cepin.com/da/speadexam_480_262.png";
            vc.contentText = @"你是否处于职业困惑中，不知道自己适合干什么？或者总觉得对现在的工作不感兴趣，毫无动力？再或者面临职业发展和转型，犹豫着何去何从？极速职业测评基于大五人格理论，可以帮助你深入了解自己的性格特点和脸谱类型、评估个人的能力水平和优劣势，并根据你的性格与能力帮助你找到最适合的岗位和企业。超过1000万测评者亲证，绝对duang duang的！为确保结果能真实反映你的水平，请：在安静、独立的空间完成测评根据第一反应答题如遇网络问题，退出后可以重新进入答题界面";
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _jobTestView;
}
- (UIButton *)checkTestReportButton
{
    if ( !_checkTestReportButton )
    {
        _checkTestReportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40 / CP_GLOBALSCALE * 2.0, 144 / CP_GLOBALSCALE)];
        UIImage *n = [UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0 width:kScreenWidth - 40 / CP_GLOBALSCALE * 2 height:144 / CP_GLOBALSCALE];
        UIImage *h = [UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0 width:kScreenWidth - 40 / CP_GLOBALSCALE * 2 height:144 / CP_GLOBALSCALE];
        [_checkTestReportButton setBackgroundImage:n forState:UIControlStateNormal];
        [_checkTestReportButton setBackgroundImage:h forState:UIControlStateHighlighted];
        [_checkTestReportButton setTitle:@"查看极速测评报告" forState:UIControlStateNormal];
        [_checkTestReportButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_checkTestReportButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_checkTestReportButton.layer setMasksToBounds:YES];
        [_checkTestReportButton setHidden:YES];
        [_checkTestReportButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            DynamicExamModelDTO *model = [DynamicExamModelDTO beanFromDictionary:self.viewModel.reportDatas[0]];
            if([model.ReportUrl rangeOfString:@"?"].location == NSNotFound)
            {
                model.ReportUrl = [model.ReportUrl stringByAppendingString:@"?isPreview=1"];
            }
            else
            {
                model.ReportUrl = [model.ReportUrl stringByAppendingString:@"&isPreview=1"];
            }
            DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:model.ReportUrl examDetail:examDetailOther];;
            vc.strTitle = model.Title;
            vc.title = model.Title;
            vc.isJiSuCepin = YES;
            vc.strTitle = model.Title;
            vc.urlPath = model.ExamUrl;
            vc.urlLogo = model.ImgFilePath;
            vc.contentText = model.Introduction;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _checkTestReportButton;
}
- (UIView *)maxSelecetdTipsView
{
    if ( !_maxSelecetdTipsView )
    {
        CGFloat W =  kScreenWidth - 40 / CP_GLOBALSCALE * 2.0;
        CGFloat H = 170 / CP_GLOBALSCALE;
        CGFloat X = ( kScreenWidth - W ) / 2.0;
        CGFloat Y = kScreenHeight - 144 / CP_GLOBALSCALE * 3 - H;
        _maxSelecetdTipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [_maxSelecetdTipsView.layer setCornerRadius:H / 2.0];
        [_maxSelecetdTipsView.layer setMasksToBounds:YES];
        [_maxSelecetdTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000"]];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [titleLabel setText:@"app不支持预览图片外的文件类型"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_maxSelecetdTipsView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _maxSelecetdTipsView.mas_top );
            make.left.equalTo( _maxSelecetdTipsView.mas_left );
            make.bottom.equalTo( _maxSelecetdTipsView.mas_bottom );
            make.right.equalTo( _maxSelecetdTipsView.mas_right );
        }];
        [_maxSelecetdTipsView setAlpha:0.0];
        [_maxSelecetdTipsView setHidden:YES];
    }
    return _maxSelecetdTipsView;
}
@end
