//
//  RecommendVC.m
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "RecommendVC.h"
#import "RecommendVM.h"
#import "DynamicBannerCell.h"
#import "RecommendCell.h"
#import "RecommendTitleCell.h"
#import "CPRecommendTitleCell.h"
#import "JobSearchModel.h"
#import "DynamicWebVC.h"
#import "NewJobDetialVC.h"
#import "UIViewController+NavicationUI.h"
#import "PositionIdModel.h"
#import "CPCommon.h"
#import "UIImage+CP.h"
#import "CPRecommendModelFrame.h"
#import "CPRecommendCell.h"
#import "NSString+Extension.h"
#import "CPHomeChangeCityButton.h"
#import "CPHomeBindTestView.h"
#import "AdScrollView.h"
#import "CPHomeGuessHeaderView.h"
#import "CPHomeRecommendHeaderView.h"
#import "CPHomeHotRecruitHeaderView.h"
#import "CPHomeGuessCell.h"
#import "CPHomeRecommendCell.h"
#import "CPHomeRegisterView.h"
#import "CPHomeChangeCityController.h"
#import "CPHomePositionDetailController.h"
#import "RTNetworking+Position.h"
#import "LoginAlterView.h"
#import "GuideStatesMv.h"
#import "CPCompanyDetailController.h"
#import "JobSearchResultVC.h"
#import "AllResumeVC.h"
#import "DynamicExamVC.h"
#import "CPHomeCheckExpectWorkView.h"
#import "ModifyEmailVC.h"
#import "AddExpectJobVC.h"
#import "DynamicExamDetailVC.h"
#import "CPHomePositionRecommendHeaderView.h"
#import "CPGuessYouLikePositionParam.h"
#import "CPGuessYouLikePositionCacheReformer.h"
#import "CPGuessYLPositionVM.h"
#import "JobSearchVC.h"
#import "TBAppDelegate.h"
#import "DynamicExamNotHomeVC.h"
#import "SDCycleScrollView.h"
#import "SignupGuideResumeVC.h"
#import "CPTipsView.h"
#import "RTNetworking+Resume.h"
#import "SendResumeVC.h"
#import "CPNMediator+CPNMediatorModuleLoginActions.h"
#import "CPNMediator+CPNMediatorModuleSignupActions.h"
#define CPRECOMMEND_ROW_HEIGHT ((50 + 261 + 24 + 36 + 50 + 261 + 24 + 36 + 50 + 30) / 3.0)
@interface RecommendVC ()<DynamicBannerCellDelegate, CPHomeRecommendHeaderViewDelegate,ChangeCityListener, CPHomeBindTestViewDelegate, CPHomeRegisterViewDelegate, CPHomeCheckExpectWorkViewDelegate, CPHomeGuessCellDelegate, CPHomeRecommendCellDelegate, CPHomeHotRecruitHeaderViewDelegate, CPHomePositionRecommendHeaderViewDelegate,SDCycleScrollViewDelegate, CPTipsViewDelegate>;
@property (nonatomic, strong) RecommendVM *viewModel;
@property (nonatomic, strong) CPGuessYLPositionVM *guessPositionVM;
@property (nonatomic,assign) int imageHight;
@property (nonatomic,strong) UIImageView *bannerImage;
@property (nonatomic,strong) UIView *footView;
/** 用户信息 */
@property (nonatomic, copy) NSString *userStr;
@property (nonatomic, strong) CPRecommendModelFrame *recommendModelFrame;
/** 当前view是否将要隐藏，可以控制下来刷新提示 */
@property (nonatomic, assign) BOOL isWillHide;
/** 将要显示推送提示 */
@property (nonatomic, assign) BOOL isShowingTips;
@property (nonatomic, strong) UIView *homeHeaderView;
@property (nonatomic, strong) AdScrollView *adScrollView;
@property (nonatomic, strong) CPHomeBindTestView *bindTestView;
@property (nonatomic, strong) CPHomeRegisterView *registerView;
@property (nonatomic, strong) CPHomeGuessHeaderView *guessHeaderView;
@property (nonatomic, strong) CPHomeRecommendHeaderView *recommendHeaderView;
@property (nonatomic, strong) CPHomeHotRecruitHeaderView *hotRecruitHeaderView;
@property (nonatomic, strong) CPHomePositionRecommendHeaderView *positionRecommendHeaderView;
@property (nonatomic, strong) NSMutableArray *guessLikeArrayM;
@property (nonatomic, strong) NSMutableArray *visibleLikeArrayM;
@property (nonatomic, strong) NSMutableArray *allGuessLikeDictArrayM;
@property (nonatomic, strong) NSMutableArray *visibleGuessLikeDictArrayM;
@property (nonatomic, strong) NSMutableArray *companyArrayM;
@property (nonatomic, assign) NSUInteger benginIndex;
@property(nonatomic,strong) CPHomeChangeCityButton *changeCityBtn;
@property(nonatomic,strong) Region *locationRegion;
@property(nonatomic,strong) LoginAlterView *loginView;
@property (nonatomic, strong) CPHomeCheckExpectWorkView *checkExpectWorkView;
@property (nonatomic, strong) NSDictionary *defaultResumeInfoDict;
@property (nonatomic, strong) NSDictionary *examFinishDict;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) CPTipsView *tipsView;
@property (nonatomic, strong) BannerModel *selectedBannerModel;
@property (nonatomic, strong) UIView *maxSelecetdTipsView;
@property (nonatomic, assign) CGFloat contentTalbleViewHeight;
@property (nonatomic, assign) CGFloat sectionFooterHeight;
@end
@implementation RecommendVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewModel = [RecommendVM new];
        self.bannerImage = [UIImageView new];
        self.isWillHide = NO;
        self.guessPositionVM = [[CPGuessYLPositionVM alloc] init];
    }
    return self;
}
/**
 *监听城市发生变化
 */
#pragma mark-监听城市变化
-(void)changeCity:(Region *)cityRegion{
    if (nil==self.changeCityBtn)
    {
        return;
    }
    [self.changeCityBtn setTitle:cityRegion.RegionName forState:UIControlStateNormal];
    self.locationRegion = cityRegion;
    TBAppDelegate *appdelagate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelagate.homeCity = self.locationRegion.RegionName;
    self.viewModel.cityCode = cityRegion.PathCode;
    //刷新数据
    self.viewModel.likePage = 1;
    self.guessPositionVM.locationRegion = cityRegion;
    [self.viewModel.likeArray removeAllObjects];
    [self reloadData];
    //保存
//    [[NSUserDefaults standardUserDefaults]setObject:self.locationRegion.RegionName forKey:@"home_city"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.changeCityBtn];
    self.parentViewController.navigationItem.rightBarButtonItem = rightBarButton;
    self.parentViewController.navigationItem.titleView = nil;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    self.isWillHide = NO;
    [self getDefaultResume];
    [self changeRegisterOrBind];
    [self initHotCity];
//    if ( self.userStr )
//    {
        [self.viewModel HomeAutoLogin];
//    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // fir.im 上的自动更新代码，只供内侧使用，上线前请注释
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self checkUpdateFromFirim];
        [self checkUpdateFromServer];
    });
}
- (void)checkUpdateFromServer
{
    [self.viewModel checkVersionUpdateFromeServer];
    @weakify(self)
    [RACObserve(self.viewModel, updateVersionStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            NSDictionary *updateVersionDict = self.viewModel.updateVersionDict;
            if ( 0 == [updateVersionDict count] )
                return;
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            NSString *newVersion = [updateVersionDict valueForKey:@"NewVesion"];
            currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            newVersion = [newVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            if ( [newVersion intValue] <= [currentVersion intValue] )
                return;
            NSNumber *isUpdate = [updateVersionDict valueForKey:@"IsUpdate"];
            NSString *update_url = @"https://itunes.apple.com/cn/app/ce-pin/id894486180?mt=8";
            NSString *newURLString = [updateVersionDict valueForKey:@"NewUrl"];
            if ( ![newURLString isKindOfClass:[NSNull class]] )
            {
                if ( 0 < [newURLString length] )
                    update_url = newURLString;
            }
            NSString *versionInfo = [updateVersionDict valueForKey:@"VesionInfo"];
            if ( [versionInfo isKindOfClass:[NSNull class]] )
            {
                versionInfo = @"有新版本更新";
            }
            if ( 1 == [isUpdate intValue] )
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:versionInfo preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:update_url]];
                }];
                [alertController addAction:sureAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:versionInfo preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:update_url]];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:sureAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }];
}
- (void)checkUpdateFromFirim
{
    NSString *idUrlString = @"http://api.fir.im/apps/latest/5714e07ce75e2d3ea7000009?api_token=1b624a7dd90be948788534e34a6d6f47";
    NSURL *requestURL = [NSURL URLWithString:idUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    NSOperationQueue *operationQueue = [NSOperationQueue currentQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            //do something
        }
        else
        {
            NSError *jsonError = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError && [object isKindOfClass:[NSDictionary class]]) {
                //do something
                NSString *versionShort = [object valueForKey:@"version"];
                NSString *localVersionShort=[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
                CGFloat versionShortFloat = [versionShort substringFromIndex:2].floatValue;
                CGFloat localVersionShortFloat = [localVersionShort substringFromIndex:2 ].floatValue;
                if ( ![versionShort isEqualToString:localVersionShort] && versionShortFloat > localVersionShortFloat )
                {
                    NSString *update_url = [object valueForKey:@"update_url"];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"内部测试有新版本更新" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:update_url]];
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:sureAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        }
    }];
}
#pragma mark-预先获取热门城市数据
-(void)initHotCity{
    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    //判断是否已经请求过热门城市的接口
    if(nil == delegate.cityData){
        // 请求热门城市接口
        RACSignal *companySignal = (RACSignal *)[[RTNetworking shareInstance] getHotCityData];
        [companySignal subscribeNext:^(RACTuple *tuple)
         {
             NSDictionary *dict = (NSDictionary *)tuple.second;
             if([dict resultSucess])
             {
                 NSArray *array = [dict resultObject];
                 if( array )
                 {
                     NSMutableArray *allCity = [NSMutableArray arrayWithCapacity:array.count+1];
                     Region *rg = [Region new];
                     rg.PathCode = @"";
                     rg.RegionName = @"全国";
                     [allCity addObject:rg];
                     for (int i=0;i<array.count; i++) {
                         Region *region = [Region beanFromDictionary:array[i]];
                         [allCity addObject:region];
                     }
                     [delegate setCityData:allCity];
                     
                 }
             }
         }];
    }
}
#pragma mark - private method
#pragma mark - 切换显示注册或者绑定邮箱页
- (void)changeRegisterOrBind
{
    self.userStr = [MemoryCacheData shareInstance].userLoginData.UserId;
    if ( self.userStr && 0 < [self.userStr length] )
    {
        [self.bindTestView setHidden:NO];
        [self.registerView setHidden:YES];
    }
    else
    {
        [self.bindTestView setHidden:YES];
        [self.registerView setHidden:NO];
    }
}
#pragma mark - 是否显示底部引导到期望工作页
- (void)changeExpectWorkView
{
    BOOL isHideToExpectView = NO;
    CGFloat tempHeight = 0 / CP_GLOBALSCALE;
    NSString *strUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if ( 0 == [strUserID length] || 0 == [strTocken length] ){
        [self.checkExpectWorkView setHidden:NO];
        self.checkExpectWorkView.viewHeight = tempHeight;
        return;
    }
    if ( !self.defaultResumeInfoDict ){
        [self.checkExpectWorkView setHidden:NO];
        self.checkExpectWorkView.viewHeight = tempHeight;
        return;
    }
    if ( [[self.defaultResumeInfoDict objectForKey:@"ExpectCity"] isKindOfClass:[NSNull class]] )
    {
        [self.checkExpectWorkView setHidden:isHideToExpectView];
        self.checkExpectWorkView.viewHeight = tempHeight;
        return;
    }
    if ( [[self.defaultResumeInfoDict objectForKey:@"ExpectJobFunction"] isKindOfClass:[NSNull class]] )
    {
        [self.checkExpectWorkView setHidden:isHideToExpectView];
        self.checkExpectWorkView.viewHeight = tempHeight;
        return;
    }
    if ( [[self.defaultResumeInfoDict objectForKey:@"ExpectSalary"] isKindOfClass:[NSNull class]] )
    {
        [self.checkExpectWorkView setHidden:isHideToExpectView];
        self.checkExpectWorkView.viewHeight = tempHeight;
        return;
    }
    if ( [[self.defaultResumeInfoDict objectForKey:@"WorkYearKey"] isKindOfClass:[NSNull class]] )
    {
        [self.checkExpectWorkView setHidden:isHideToExpectView];
        self.checkExpectWorkView.viewHeight = tempHeight;
        return;
    }
    isHideToExpectView = YES;
    [self.checkExpectWorkView setHidden:isHideToExpectView];
    if ( 0 != self.checkExpectWorkView.viewHeight )
    {
        self.checkExpectWorkView.viewHeight = 0;
    }
}
#pragma mark - 获取默认简历
- (void)getDefaultResume
{
    NSString *strUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if ( 0 == [strUserID length] || 0 == [strTocken length] ){
        return;
    }
    __weak typeof( self ) weakSelf = self;
    RACSignal *defaultResumeSignal = [[RTNetworking shareInstance] getDefaultResumeInfoWithTokenId:strTocken userId:strUserID];
    [defaultResumeSignal subscribeNext:^(RACTuple *tuple) {
        NSDictionary *dict = (NSDictionary *)tuple.second;
        if([dict resultSucess])
        {
            weakSelf.defaultResumeInfoDict = [dict resultObject];
        }else{
            weakSelf.defaultResumeInfoDict = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakSelf getAllDefaultResume];
            });
        }
    }];
}
- (void)getAllDefaultResume
{
    if ( 0 == [[MemoryCacheData shareInstance] userId] || 0 == [[MemoryCacheData shareInstance] userTokenId] )
        return;
    RACSignal *signal = [[RTNetworking shareInstance] getResumeListWithTokenId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId ResumeType:[NSString stringWithFormat:@"%@", nil]];
    __weak typeof( self ) weakSelf = self;
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            if (array &&  ![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                NSDictionary *resultDict = array[0];
                NSString *resumeIDString = [resultDict objectForKey:@"ResumeId"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [weakSelf getAllDefaultResumeInfoWithResumeID:resumeIDString];
                });
            }
        }
    }];
}
- (void)getAllDefaultResumeInfoWithResumeID:(NSString *)resumeID
{
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    __weak typeof( self ) weakSelf = self;
    RACSignal *signal = [[RTNetworking shareInstance]getThridResumeDetailWithResumeId:resumeID userId:userId tokenId:TokenId];
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            weakSelf.defaultResumeInfoDict = [dic resultObject];
        }
    }];
}
- (void)comeFromGetDefaultResume
{
    NSString *strUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if ( 0 == [strUserID length] || 0 == [strTocken length] ){
        return;
    }
    TBLoading *load = [[TBLoading alloc] init];
    [load start];
    __weak typeof( self ) weakSelf = self;
    RACSignal *defaultResumeSignal = [[RTNetworking shareInstance] getDefaultResumeInfoWithTokenId:strTocken userId:strUserID];
    [defaultResumeSignal subscribeNext:^(RACTuple *tuple) {
        NSDictionary *dict = (NSDictionary *)tuple.second;
        if([dict resultSucess])
        {
            weakSelf.defaultResumeInfoDict = [dict resultObject];
            if ( load )
            {
                [load stop];
            }
            [weakSelf getDefaultResumeToWhere];
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getAllResumeWithLoad:load];
            });
        }
    } error:^(NSError *error) {
        weakSelf.defaultResumeInfoDict = nil;
        if ( load )
            [load stop];
    }];
}
- (void)getAllResumeWithLoad:(TBLoading *)load
{
    RACSignal *signal = [[RTNetworking shareInstance] getResumeListWithTokenId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId ResumeType:[NSString stringWithFormat:@"%@", nil]];
    __weak typeof( self ) weakSelf = self;
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            if (array &&  ![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                NSDictionary *resultDict = array[0];
                NSString *resumeIDString = [resultDict objectForKey:@"ResumeId"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [weakSelf getResumeInfoWithLoad:load resumeID:resumeIDString];
                });
            }
            else
            {
                weakSelf.defaultResumeInfoDict = nil;
                if ( load )
                    [load stop];
                [weakSelf getDefaultResumeToWhere];
            }
        }
        else
        {
            weakSelf.defaultResumeInfoDict = nil;
            if ( load )
                [load stop];
            [weakSelf getDefaultResumeToWhere];
        }
    } error:^(NSError *error){
        weakSelf.defaultResumeInfoDict = nil;
        if ( load )
            [load stop];
    }];
}
- (void)getResumeInfoWithLoad:(TBLoading *)load resumeID:(NSString *)resumeID
{
    NSString *userId = [[MemoryCacheData shareInstance] userId];
    NSString *TokenId = [[MemoryCacheData shareInstance] userTokenId];
    __weak typeof( self ) weakSelf = self;
    RACSignal *signal = [[RTNetworking shareInstance] getThridResumeDetailWithResumeId:resumeID userId:userId tokenId:TokenId];
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            weakSelf.defaultResumeInfoDict = [dic resultObject];
        }
        else
        {
            weakSelf.defaultResumeInfoDict = nil;
        }
        if ( load )
            [load stop];
        [weakSelf getDefaultResumeToWhere];
    } error:^(NSError *error){
        weakSelf.defaultResumeInfoDict = nil;
        if ( load )
            [load stop];
    }];
}
- (void)checkIsExam
{
    NSString *strUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    NSString *IsHasEmailVerify = [MemoryCacheData shareInstance].userLoginData.Email;
    if ( 0 == [strUserID length] || 0 == [strTocken length] )
        return;
    self.examFinishDict = nil;
    __weak typeof( self ) weakSelf = self;
    RACSignal *checkExamSignal = [[RTNetworking shareInstance] isExamWithTokenId:strTocken userId:strUserID];
    [checkExamSignal subscribeNext:^(RACTuple *tuple) {
        NSDictionary *dict = (NSDictionary *)tuple.second;
        if ( [dict resultSucess] )
        {
            weakSelf.examFinishDict = [dict resultObject];
        }
        [weakSelf.bindTestView resetFrameWithUserData:IsHasEmailVerify examData:weakSelf.examFinishDict];
        [weakSelf resetHeadFrame];
    }];
}
- (void)resetHeadFrame
{
    NSString *IsHasEmailVerify = [MemoryCacheData shareInstance].userLoginData.Email;
    NSDictionary *dict = self.examFinishDict;
    NSString *finishExam = nil;
    [self.bindTestView setHidden:NO];
    if ( ![[dict objectForKey:@"IsFinshed"] isKindOfClass:[NSNull class]] )
    {
        finishExam = [dict objectForKey:@"IsFinshed"];
    }
    if ( finishExam.intValue == 1 && (!IsHasEmailVerify || 0 == [IsHasEmailVerify length]) )
    {
        self.homeHeaderView.viewHeight = (350 / CP_GLOBALSCALE + 180 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE);
        [self.bindTestView setFrame:CGRectMake(0, 350 / CP_GLOBALSCALE, kScreenWidth, 180 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE)];
        self.tableView.tableHeaderView = self.homeHeaderView;
    }
    else if ( (!finishExam || finishExam.intValue == 0 ) && (IsHasEmailVerify && 0 < [IsHasEmailVerify length]) )
    {
        self.homeHeaderView.viewHeight = (350 / CP_GLOBALSCALE + 180 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE);
        [self.bindTestView setFrame:CGRectMake(0, 350 / CP_GLOBALSCALE, kScreenWidth, 180 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE)];
        self.tableView.tableHeaderView = self.homeHeaderView;
    }
    else if ( finishExam.intValue == 1 && (IsHasEmailVerify && 0 < [IsHasEmailVerify length]) )
    {
        [self.homeHeaderView setFrame:CGRectMake(0, 0, kScreenWidth, (350 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE))];
        self.bindTestView.frame = CGRectMake(0, 350 / CP_GLOBALSCALE, kScreenWidth, 0);
        [self.bindTestView setHidden:YES];
        self.tableView.tableHeaderView = self.homeHeaderView;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"into_recommendactivity"];
    self.benginIndex = 0;
    // 加载用户信息
    self.userStr = [[MemoryCacheData shareInstance] userId];
    self.title = @"首页";
    self.loginView = [[LoginAlterView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight)];
    [self.view addSubview:self.loginView];
    self.loginView.hidden = YES;
    CGFloat tempHeight = 98.0 + 40 / CP_GLOBALSCALE;
    if ( CP_IS_IPHONE_6P )
    {
        tempHeight = 55.0 + 144 / CP_GLOBALSCALE;
    }
    else if ( CP_IS_IPHONE_6 )
    {
        tempHeight = 98.0 + 36 / CP_GLOBALSCALE;
    }
    self.contentTalbleViewHeight = self.view.viewHeight - tempHeight;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.contentTalbleViewHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableHeaderView = self.homeHeaderView;
    @weakify(self)
    [RACObserve(self.viewModel, bannerStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            if (0 < [self.viewModel.bannerDatas count] ){
                NSMutableArray *imgArray = [[NSMutableArray alloc]init];
                for (int i= 0;i<[self.viewModel.bannerDatas count]; i++){
                    BannerModel *model = [BannerModel beanFromDictionary:self.viewModel.bannerDatas[i]];
                    [imgArray addObject:model.ImgUrl];
                }
                [self.homeHeaderView addSubview:self.cycleScrollView];
                _cycleScrollView.imageURLStringsGroup = imgArray;
            }
        }
    }];
    [RACObserve(self.viewModel, recommendStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self stopUpdateAnimation];
            [self.tableView reloadData];
            self.tableView.hidden = NO;
            self.viewModel.isLoading = NO;
            self.networkImage.hidden = YES;
            self.networkLabel.hidden = YES;
            self.networkButton.hidden = YES;
            self.clickImage.hidden = YES;
            self.tableView.hidden = NO;
        }
        else if ([self requestStateWithStateCode:stateCode] == HUDCodeNone )
        {
            if ( [self isNetworkValid] )
            {
                if ( [self.viewModel.allRecommendPositionArrayM count] > [self.viewModel.visiabelRecommendPositionArrayM count] )
                {
                    [self stopUpdateAnimation];
                }
            }
            else
            {
                [self stopUpdateAnimation];
            }
            self.tableView.hidden = NO;
            self.viewModel.isLoading = NO;
            self.networkImage.hidden = YES;
            self.networkLabel.hidden = YES;
            self.networkButton.hidden = YES;
            self.clickImage.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            if ( [self isNetworkValid] ){
                if ( [self.viewModel.allRecommendPositionArrayM count] == [self.viewModel.visiabelRecommendPositionArrayM count] )
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                else
                    [self.tableView.mj_footer endRefreshing];
                [self changeExpectWorkView];
            }
        }
        else if ( [self requestStateWithStateCode:stateCode] == hudCodeUpdateSucess )
        {
            [self stopRefleshAnimation];
        }
    }];
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if (!stateCode)
        {
            return ;
        }
        switch ([self requestStateWithStateCode:stateCode])
        {
            case HUDCodeDownloading:
                self.viewModel.isLoading = YES;
                [self startRefleshAnimation];
                self.networkImage.hidden = YES;
                self.networkLabel.hidden = YES;
                self.networkButton.hidden = YES;
                self.clickImage.hidden = YES;
                self.tableView.hidden = NO;
                break;
            case HUDCodeReflashSucess:
                [self stopRefleshAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                self.networkImage.hidden = YES;
                self.networkLabel.hidden = YES;
                self.networkButton.hidden = YES;
                self.clickImage.hidden = YES;
                self.tableView.hidden = NO;
                if ( [self isNetworkValid] )
                {
                    NSString *stateString = @"正在刷新职位...";
                    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.tableView.mj_header;
                    [header setTitle:stateString forState:MJRefreshStateRefreshing];
                    self.tableView.mj_header = header;
                }
                break;
            case hudCodeUpdateSucess:
                [self stopUpdateAnimation];
                [self.tableView reloadData];
                self.tableView.hidden = NO;
                self.viewModel.isLoading = NO;
                self.networkImage.hidden = YES;
                self.networkLabel.hidden = YES;
                self.networkButton.hidden = YES;
                self.clickImage.hidden = YES;
                self.tableView.hidden = NO;
                break;
            case HUDCodeNetWork:
            {
                if ( [self.viewModel.visiabelRecommendPositionArrayM count] == 0 )
                {
                    self.networkImage.hidden = NO;
                    self.networkLabel.hidden = NO;
                    self.networkButton.hidden = NO;
                    self.clickImage.hidden = NO;
                    self.tableView.hidden = YES;
                }
                else
                {
                    self.networkImage.hidden = YES;
                    self.networkLabel.hidden = YES;
                    self.networkButton.hidden = YES;
                    self.clickImage.hidden = YES;
                    self.tableView.hidden = NO;
                }
                if ( ![self isNetworkValid] )
                {
                    if ( self.viewModel.page > 1 )
                    {
                        if ( ![self isNetworkValid] && [self.viewModel.visiabelRecommendPositionArrayM count] >= [self.viewModel.allRecommendPositionArrayM count] )
                        {
                            [self showTipsView];
                            return;
                        }
                    }
                    else
                    {
                        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.tableView.mj_header;
                        [header setTitle:@"当前网络不可用，请检查网络设置" forState:MJRefreshStateRefreshing];
                        self.tableView.mj_header = header;
                    }
                }
            }
                break;
        }
    }];
    [self.viewModel getBanner];
    [self setupRefleshScrollView];
    [self setupDropDownScrollView];
    [self.checkExpectWorkView setHidden:YES];
    NSString *locationCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCity"];
    //获取当前城市对象
    if( nil==locationCity || [locationCity isEqualToString:@""] )
    {
        locationCity=@"全国";
        self.locationRegion = [Region new];
        self.locationRegion.RegionName = locationCity;
        self.locationRegion.PathCode = @"";
    }
    else
    {
        self.locationRegion = [Region searchAddressWithAddressString:locationCity];
        locationCity = self.locationRegion.RegionName;
    }
    TBAppDelegate *appdelagate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    if (nil == appdelagate.homeCity || NULL == appdelagate.homeCity || !appdelagate.homeCity)
    {
        appdelagate.homeCity =locationCity;
    }
    else
    {
        locationCity =  appdelagate.homeCity;
    }
    NSString *tempPathCode = [self selectedCityPathCode];
    if ( ![tempPathCode isEqualToString:self.locationRegion.PathCode] )
        self.viewModel.cityCode = tempPathCode;
    else
        self.viewModel.cityCode = self.locationRegion.PathCode;
    self.viewModel.isTranslate = self.isTranslate;
    [self reloadData];
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    NSString *city = @"全国";
    if ( self.locationRegion && 0 < [self.locationRegion.RegionName length] )
        city = self.locationRegion.RegionName;
    self.guessPositionVM.locationRegion = self.locationRegion;
    [RACObserve(self.guessPositionVM, guessYLStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ( [self requestStateWithStateCode:stateCode] == HUDCodeSucess )
        {
        }
        self.guessPositionVM.isLoading = NO;
        [self.tableView reloadData];
    }];
    [RACObserve( self.viewModel, homeAutoLoginStateCode ) subscribeNext:^(id stateCode) {
        if ( 0 == [self.userStr length] )
        {
            self.userStr = [[MemoryCacheData shareInstance] userId];
        }
        [self getDefaultResume];
        [self checkIsExam];
        if ( [self.guessPositionVM.visiabelGuessYLPositionArrayM count] == 0 )
            [self.guessPositionVM getAllGuessYLPosition];
    }];
    // 请求名企推荐的数据
    RACSignal *companySignal = [[RTNetworking shareInstance] getEnterprisesRecruitmentListWithTokenId:strTocken userId:strUser PageIndex:0 PageSize:30];
    [companySignal subscribeNext:^(RACTuple *tuple)
    {
        NSDictionary *dict = (NSDictionary *)tuple.second;
        if([dict resultSucess])
        {
            NSArray *array = [dict resultObject];
            if( array )
            {
                [self.companyArrayM addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
    }];
    [self.view addSubview:self.maxSelecetdTipsView];
    // 添加监听中心－－对清除缓存的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCacheNotification:) name:CP_PROFILE_CLEARCACHE object:nil];
    // 监听切换用户
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChange:) name:CP_ACCOUNT_CHANGE object:nil];
    // 监听设置设置默认简历
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultResumeChange:) name:CP_DEFAULT_RESUME object:nil];
    // 监听默认简历编辑期望工作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expectedWorkChange:) name:CP_EXPECTED_WORK object:nil];
    [self.tableView reloadData];
}
/** 监听到清除缓存后要实现的方法 */
- (void)clearCacheNotification:(NSNotification *)userNot
{
    NSNumber *valueNum = [userNot.userInfo valueForKey:CP_PROFILE_CLEARCACHE_COMFIRT];
    // 刷新数据
    if ( [valueNum intValue] == 1 )
    {
        if ( self.userStr && self.userStr.length > 0 )
        {
            [self.tableView reloadData];
        }
        else
        {
            [self.viewModel.likeArray removeAllObjects];
            [self.guessPositionVM.visiabelGuessYLPositionArrayM removeAllObjects];
            [self.tableView.mj_header beginRefreshing];
        }
    }
}
/** 监听到切换用户后要实现的方法 */
- (void)accountChange:(NSNotification *)userNot
{
    [self.checkExpectWorkView setHidden:YES];
    self.sectionFooterHeight = 0.0;
    NSNumber *valueNum = [userNot.userInfo valueForKey:CP_ACCOUNT_CHANGE_VALUE];
    // 刷新数据
    if ( [valueNum intValue] == HUDCodeSucess )
    {
        self.viewModel.likePage = 1;
        [self.viewModel.likeArray removeAllObjects];
        [self.guessPositionVM.visiabelGuessYLPositionArrayM removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
        [self.guessPositionVM getAllGuessYLPosition];
        [self getDefaultResume];
    }
}
/** 监听到设置默认简历后要实现的方法 */
- (void)defaultResumeChange:(NSNotification *)userNot
{
    [self.checkExpectWorkView setHidden:YES];
    self.sectionFooterHeight = 0.0;
    NSNumber *valueNum = [userNot.userInfo valueForKey:CP_DEFAULT_RESUME_CHANGE];
    // 刷新数据
    if ( [valueNum intValue] == HUDCodeSucess )
    {
        self.viewModel.likePage = 1;
        [self.viewModel.likeArray removeAllObjects];
        [self.guessPositionVM.visiabelGuessYLPositionArrayM removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
        [self.guessPositionVM getAllGuessYLPosition];
        [self getDefaultResume];
    }
}
/** 监听到默认简历编辑期望工作后要实现的方法 */
- (void)expectedWorkChange:(NSNotification *)userNot
{
    [self.checkExpectWorkView setHidden:YES];
    self.sectionFooterHeight = 0.0;
    NSNumber *valueNum = [userNot.userInfo valueForKey:CP_EXPECTED_WORK_SAVE];
//    return;
    // 刷新数据
    if ( [valueNum intValue] == HUDCodeSucess )
    {
        self.viewModel.likePage = 1;
        [self.viewModel.likeArray removeAllObjects];
        [self.guessPositionVM.visiabelGuessYLPositionArrayM removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
        [self.guessPositionVM getAllGuessYLPosition];
        [self getDefaultResume];
    }
}
#pragma mark - private methods
#pragma mark - cache GuessYouLike
- (void)setGuessYouLikeCache
{
    if ( [self.visibleGuessLikeDictArrayM count] == 0 )
        return;
    [CPGuessYouLikePositionCacheReformer clearup];
    NSInteger page = [self.visibleLikeArrayM count] / 10;
    CPGuessYouLikePositionParam *params = [[CPGuessYouLikePositionParam alloc] init];
    params.pageString = [NSString stringWithFormat:@"%ld", (long)page];
    params.userid = self.userStr;
    for ( NSDictionary *dict in self.visibleGuessLikeDictArrayM )
    {
        [CPGuessYouLikePositionCacheReformer addGuessYouLikePositionDict:dict params:params];
    }
}
- (void)addCacheWithDictionary:(NSDictionary *)dict
{
    NSInteger page = [self.visibleLikeArrayM count] / 10;
    CPGuessYouLikePositionParam *params = [[CPGuessYouLikePositionParam alloc] init];
    params.pageString = [NSString stringWithFormat:@"%ld", (long)page];
    params.userid = self.userStr;
    [CPGuessYouLikePositionCacheReformer addGuessYouLikePositionDict:dict params:params];
}
#pragma mark - event
- (void)clickedChangeCity
{
    [MobClick event:@"into_choose_city"];
    CPHomeChangeCityController *changeCityVC = [[CPHomeChangeCityController alloc] init];
    changeCityVC.cityDelegate = self;
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:changeCityVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getBanner];
    [self reloadData];
}
-(void)reloadData
{
    [self refleshTable];
}
-(void)refleshTable
{
    // 统计刷新
    [MobClick event:@"on_refresh"];
    [self.viewModel reflashPage];
    if ( self.userStr && 0 < [self.userStr length] )
    {
        if ( self.tableView.mj_header.isRefreshing )
            return;
        [self.guessPositionVM getAllGuessYLPosition];
    }
}
-(void)updateTable
{
    //统计加载更多
    [MobClick event:@"onload_more"];
    [self.viewModel nextPage];
}
#pragma mark - 轮播点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [self didPushWith:index];
}
#pragma mark-广告点击事件
- (void)didPushWith:(NSInteger)pageIndex
{
    BannerModel *model = [BannerModel beanFromDictionary:self.viewModel.bannerDatas[pageIndex]];
    //统计banber点击
    NSString *adEventString = [NSString stringWithFormat:@"iOS_ad_%@", model.Id];
    [MobClick event:adEventString];
    self.selectedBannerModel = model;
    BOOL isLogin;
    if ( ![MemoryCacheData shareInstance].isLogin )
    {
        isLogin = NO;
    }
    else
    {
        isLogin = YES;
    }
    UIViewController *vc;
    //判断跳到网页还是app页面
    if( model.AdvType.intValue == 1 )
    {
        //跳到app页面
        if ( model.AppPage.intValue == 1 )
        {
            //登录页面
            if (isLogin)
            {
                [OMGToast showWithText:@"账号已登录" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                return;
            }
            NSDictionary *params = [NSDictionary dictionaryWithObject:@"homelogin" forKey:@"comfrom"];
            vc = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if( model.AppPage.intValue == 2 )
        {
            //注册
            if (isLogin)
            {
                [OMGToast showWithText:@"您已注册账号" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                return;
            }
            NSDictionary *params = [NSDictionary dictionaryWithObject:@"homeRegister" forKey:@"comfrom"];
            vc = [[CPNMediator alloc] CPNMediator_viewControllerForSignup:params];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else if( model.AppPage.intValue == 3 )
        {
            //简历引导
            if (!isLogin)
            {
                [self showMessageTips:@"需要登录后才能进入简历引导" identifier:1002];
                return;
            }
            NSString *mobiel = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccout"];
            SignupGuideResumeVC *vc = [[SignupGuideResumeVC alloc] initWithMobiel:mobiel comeFromString:@"homeADGuide"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if( model.AppPage.intValue == 4 )
        {
            //公司详情
            if ( model.AppPageParam )
            {
                 NSString *companyId = nil;
                NSArray *array = [model.AppPageParam componentsSeparatedByString:@"="];
                if ( array )
                {
                    if( array.count == 2 )
                    {
                        companyId=array[1];
                    }
                    else
                    {
                        companyId=array[0];
                    }
                }
                CPCompanyDetailController *companyDetailVC = [[CPCompanyDetailController alloc] init];
                [companyDetailVC configWithPositionWithCompanyId:companyId];
                [self.navigationController pushViewController:companyDetailVC animated:YES];
            }
           
        }
        else if( model.AppPage.intValue == 5 )
        {
            if ( model.AppPageParam )
            {
                NSArray *array = [model.AppPageParam componentsSeparatedByString:@"&"];
                NSString *city = @"",*jobFun=@"",*searchKey=@"",*Salary=@"",*zplxKey=@"",*gzxzKey=@"",*WorkYear=@"",*Degree=@"";
                if (array) {
                    for (NSString *st in array) {
                        NSArray *paramsArray = [st componentsSeparatedByString:@"="];
                        if (paramsArray && [paramsArray[0] isEqualToString:@"City"]) {
                            //地区
                            city = paramsArray[1];
                        }else if(paramsArray && [paramsArray[0] isEqualToString:@"JobFunction"]){
                            //职能
                            jobFun = paramsArray[1];
                        }
                        else if(paramsArray && [paramsArray[0] isEqualToString:@"SearchKey"]){
                            //搜素关键词
                            searchKey = paramsArray[1];
                        }
                        else if(paramsArray && [paramsArray[0] isEqualToString:@"Salary"]){
                            //薪酬
                            Salary = paramsArray[1];
                        }
                        else if(paramsArray && [paramsArray[0] isEqualToString:@"PositionType"]){
                            //招聘类型
                            zplxKey = paramsArray[1];
                        }
                        else if(paramsArray && [paramsArray[0] isEqualToString:@"EmployType"]){
                            //工作性质
                            gzxzKey = paramsArray[1];
                        }
                        else if(paramsArray && [paramsArray[0] isEqualToString:@"WorkYear"]){
                            //功能年限
                            WorkYear = paramsArray[1];
                        }
                        else if(paramsArray && [paramsArray[0] isEqualToString:@"Degree"]){
                            //学历
                            Degree = paramsArray[1];
                        }
                    }
                }
                //职位搜索
                JobSearchResultVC *vc = [[JobSearchResultVC alloc]initWithKeyWord:searchKey city:city JobFunction:jobFun Salary:Salary PositionType:zplxKey EmployType:gzxzKey WorkYear:WorkYear Degree:Degree];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if( model.AppPage.intValue == 6 )
        {
            if ( !isLogin )
            {
                [self showMessageTips:@"需要登录后才能查看我的简历" identifier:1000];
                return;
            }
            //简历列表
            vc = [AllResumeVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if( model.AppPage.intValue == 7 )
        {
            //测一测 hometest
             vc = [[DynamicExamNotHomeVC alloc] initWithType:examTwo comeFromString:@"homedynamictest"];
             [self.navigationController pushViewController:vc animated:YES];
        }
        else if( model.AppPage.intValue == 8 )
        {
            //测评详情
            if ( !isLogin )
            {
                [self showMessageTips:@"需要登录后才能进入极速测评" identifier:1001];
                return;
            }
            DynamicExamDetailVC *vc  = nil;
            vc = [[DynamicExamDetailVC alloc] initWithUrl:model.LinkUrl examDetail:examDetailOther];
            vc.title = model.Title;
            vc.strTitle = model.Title;
            vc.urlPath = model.LinkUrl;
            vc.isJiSuCepin = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        if([model.LinkUrl rangeOfString:@"examcenter/desc?id=2"].location != NSNotFound){
            //测评详情
            if ( !isLogin )
            {
                [self showMessageTips:@"需要登录后才能进入极速测评" identifier:1001];
                return;
            }
            DynamicExamDetailVC *vc  = nil;
            vc = [[DynamicExamDetailVC alloc] initWithUrl:model.LinkUrl examDetail:examDetailOther];
            vc.title = model.Title;
            vc.strTitle = model.Title;
            vc.urlPath = model.LinkUrl;
            vc.isJiSuCepin = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //跳到网页
            DynamicWebVC *vc = [[DynamicWebVC alloc] initWithTitleAndlUrl:model.Title url:model.LinkUrl];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 0 < [self.guessPositionVM.visiabelGuessYLPositionArrayM count] )
    {
        if ( 0 == indexPath.section )
        {
            CPRecommendModelFrame *recommendModelFrame = self.guessPositionVM.visiabelGuessYLPositionArrayM[indexPath.row];
            CGFloat cellHeight = recommendModelFrame.totalHeight;
            if ( indexPath.row == [self.guessPositionVM.visiabelGuessYLPositionArrayM count] - 1 )
            {
                if ( [self.guessPositionVM.visiabelGuessYLPositionArrayM count] != [self.guessPositionVM.allGuessYLPositionArrayM count] )
                    cellHeight += ( 144 + 30 ) / CP_GLOBALSCALE;
                else
                    cellHeight += 30 / CP_GLOBALSCALE;
            }
            return cellHeight;
        }
        else if ( 1 == indexPath.section )
        {
            CGFloat tempHeight = ([[UIScreen mainScreen] bounds].size.width - 50 * 2 / CP_GLOBALSCALE - 40 * 2 / CP_GLOBALSCALE ) / 3.0;
            CGFloat height = tempHeight + 24 / CP_GLOBALSCALE + 36 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
            if ( 0 < [self.companyArrayM count] )
            {
                return height * 2.0 + 60 / CP_GLOBALSCALE;
            }
            else
                return 0;
        }
        else
        {
            CPRecommendModelFrame *recommendModelFrame = self.viewModel.visiabelRecommendPositionArrayM[indexPath.row];
            CGFloat cellHeight = recommendModelFrame.totalHeight;
            if ( indexPath.row == [self.viewModel.visiabelRecommendPositionArrayM count] - 1 )
            {
                if ( [self isNetworkValid] )
                {
                    if ( [self.viewModel.visiabelRecommendPositionArrayM count] != [self.viewModel.allRecommendPositionArrayM count] )
                        cellHeight += ( 144 + 30 ) / CP_GLOBALSCALE;
                    else
                        cellHeight += 30 / CP_GLOBALSCALE;
                }
                else
                {
                    cellHeight += ( 144 + 30 ) / CP_GLOBALSCALE;
                }
            }
            return cellHeight;
        }
    }
    else
    {
        if ( 0 == indexPath.section )
        {
            CGFloat tempHeight = ([[UIScreen mainScreen] bounds].size.width - 50 * 2 / CP_GLOBALSCALE - 40 * 2 / CP_GLOBALSCALE ) / 3.0;
            CGFloat height = tempHeight + 24 / CP_GLOBALSCALE + 36 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
            if ( 0 < [self.companyArrayM count] )
            {
                return height * 2.0 + 60 / CP_GLOBALSCALE;
            }
            else
                return 0;
        }
        else
        {
            CPRecommendModelFrame *recommendModelFrame = self.viewModel.visiabelRecommendPositionArrayM[indexPath.row];
            CGFloat cellHeight = recommendModelFrame.totalHeight;
            if ( indexPath.row == [self.viewModel.visiabelRecommendPositionArrayM count] - 1 )
            {
                if ( [self isNetworkValid] )
                {
                    if ( [self.viewModel.visiabelRecommendPositionArrayM count] != [self.viewModel.allRecommendPositionArrayM count] )
                        cellHeight += ( 144 + 30 ) / CP_GLOBALSCALE;
                    else
                        cellHeight += 30 / CP_GLOBALSCALE;
                }
                else
                {
                    cellHeight += ( 144 + 30 ) / CP_GLOBALSCALE;
                }
            }
            return cellHeight;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeaderHeight = ( 40 + 42 + 40) / CP_GLOBALSCALE;
    if ( 0 < [self.guessPositionVM.visiabelGuessYLPositionArrayM count] )
    {
        if ( 0 == section )
        {
            return sectionHeaderHeight;
        }
        else if ( 1 == section )
        {
            if ( 0 < [self.companyArrayM count] )
                return sectionHeaderHeight;
            else
                return 0;
        }
        else
        {
            return sectionHeaderHeight;
        }
    }
    else
    {
        if ( 0 == section )
        {
            if ( 0 < [self.companyArrayM count] )
                return sectionHeaderHeight;
            else
                return 0;
        }
        else
            return sectionHeaderHeight;
    }
}
// LFK新添加显示多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( 0 < [self.guessPositionVM.visiabelGuessYLPositionArrayM count] )
        return 3;
    else
        return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 < [self.guessPositionVM.visiabelGuessYLPositionArrayM count] )
    {
        if ( 0 == section )
        {
            return [self.guessPositionVM.visiabelGuessYLPositionArrayM count];
        }
        else if ( 1 == section )
        {
            if ( 0 < [self.companyArrayM count] )
                return 1;
            else
                return 0;
        }
        else
        {
            return [self.viewModel.visiabelRecommendPositionArrayM count];
        }
    }
    else
    {
        if ( 0 == section )
        {
            if ( 0 < [self.companyArrayM count] )
                return 1;
            else
                return 0;
        }
        else
            return [self.viewModel.visiabelRecommendPositionArrayM count];
    }
}
// 绘制cell
- (void)drawCell:(CPRecommendCell *)cell withIndexPath:(NSIndexPath *)indexPath offSet:(NSInteger)offSet datas:(NSArray *)datas
{
    [cell clear];
    CPRecommendModelFrame *recommendModelFrame;
    recommendModelFrame = datas[indexPath.row - offSet];
    // 检查cell是否被查阅过
    BOOL isChecked = NO;
    JobSearchModel *recommendModel = nil;
    if( [recommendModelFrame.recommendModel isKindOfClass:[JobSearchModel class]] )
        recommendModel = (JobSearchModel *)recommendModelFrame.recommendModel;
    if( nil != recommendModel )
    {
        for (PositionIdModel *model in self.viewModel.positionIdArray) {
            
            if ([model.positionId isEqualToString:recommendModel.PositionId]) {
                isChecked = YES;
                break;
            }
        }
    }
    recommendModelFrame.isCheck = isChecked;
    cell.recommendModelFrame = recommendModelFrame;
    [cell draw];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( 0 < [self.guessPositionVM.visiabelGuessYLPositionArrayM count] )
    {
        if ( 0 == indexPath.section )
        {
            CPHomeGuessCell *cell = [CPHomeGuessCell guessCellWithTableView:tableView];
            [cell setHomeGuessCellDelegate:self];
            CPRecommendModelFrame *modeFrame = self.guessPositionVM.visiabelGuessYLPositionArrayM[indexPath.row];
            BOOL hideCheckMoreButton = YES;
            BOOL hideSeparatorBlock = YES;
            BOOL isRead = NO;
            if ( indexPath.row == [self.guessPositionVM.visiabelGuessYLPositionArrayM count] - 1 )
            {
                if ( [self.guessPositionVM.visiabelGuessYLPositionArrayM count] != [self.guessPositionVM.allGuessYLPositionArrayM count] )
                {
                    hideCheckMoreButton = NO;
                }
                else
                    hideSeparatorBlock = NO;
            }
            JobSearchModel *model = (JobSearchModel *)modeFrame.recommendModel;
            for ( PositionIdModel *positionID in self.viewModel.positionIdArray )
            {
                if ( [model.PositionId isEqualToString:positionID.positionId] )
                {
                    isRead = YES;
                    break;
                }
            }
            cell.indexPath = indexPath;
            [cell configCellWithDatas:modeFrame hideCheckMoreButton:hideCheckMoreButton];
            [cell setSeparatorIsHide:hideSeparatorBlock];
            [cell setContentIsRead:isRead];
            return cell;
        }
        else if ( 1 == indexPath.section )
        {
            CPHomeRecommendCell *cell = [CPHomeRecommendCell homeRecommendCellWithTableView:tableView];
            [cell setHomeRecommendCellDelegate:self];
            [cell configWithDataArray:self.companyArrayM next:self.benginIndex];
            return cell;
        }
        else
        {
            CPHomeGuessCell *cell = [CPHomeGuessCell guessCellWithTableView:tableView];
            [cell setHomeGuessCellDelegate:self];
            CPRecommendModelFrame *modeFrame = self.viewModel.visiabelRecommendPositionArrayM[indexPath.row];
            BOOL hideCheckMoreButton = YES;
            BOOL hideSeparatorBlock = YES;
            BOOL isRead = NO;
            BOOL isHideSeparator = NO;
            if ( indexPath.row == [self.viewModel.visiabelRecommendPositionArrayM count] - 1 )
            {
                if ( [self isNetworkValid] )
                {
                    if ( [self.viewModel.visiabelRecommendPositionArrayM count] != [self.viewModel.allRecommendPositionArrayM count] )
                    {
                        hideCheckMoreButton = NO;
                    }
                    else
                    {
                        hideSeparatorBlock = NO;
                        isHideSeparator = YES;
                    }
                }
                else
                {
                    hideCheckMoreButton = NO;
                }
            }
            JobSearchModel *model = (JobSearchModel *)modeFrame.recommendModel;
            for ( PositionIdModel *positionID in self.viewModel.positionIdArray )
            {
                if ( [model.PositionId isEqualToString:positionID.positionId] )
                {
                    isRead = YES;
                    break;
                }
            }
            cell.indexPath = indexPath;
            [cell configCellWithDatas:modeFrame hideCheckMoreButton:hideCheckMoreButton];
            [cell setSeparatorIsHide:hideSeparatorBlock];
            [cell setContentIsRead:isRead];
            [cell setLastCellIsHide:isHideSeparator];
            return cell;
        }
    }
    else
    {
        if ( 0 == indexPath.section )
        {
            CPHomeRecommendCell *cell = [CPHomeRecommendCell homeRecommendCellWithTableView:tableView];
            [cell setHomeRecommendCellDelegate:self];
            [cell configWithDataArray:self.companyArrayM next:self.benginIndex];
            return cell;
        }
        else
        {
            CPHomeGuessCell *cell = [CPHomeGuessCell guessCellWithTableView:tableView];
            [cell setHomeGuessCellDelegate:self];
            CPRecommendModelFrame *modeFrame = self.viewModel.visiabelRecommendPositionArrayM[indexPath.row];
            BOOL hideCheckMoreButton = YES;
            BOOL hideSeparatorBlock = YES;
            BOOL isRead = NO;
            BOOL isHideSeparator = NO;
            if ( indexPath.row == [self.viewModel.visiabelRecommendPositionArrayM count] - 1 )
            {
                if ( [self isNetworkValid] )
                {
                    if ( [self.viewModel.visiabelRecommendPositionArrayM count] != [self.viewModel.allRecommendPositionArrayM count] )
                    {
                        hideCheckMoreButton = NO;
                    }
                    else
                    {
                        hideSeparatorBlock = NO;
                        isHideSeparator = YES;
                    }
                }
                else
                {
                    hideCheckMoreButton = NO;
                }
            }
            JobSearchModel *model = (JobSearchModel *)modeFrame.recommendModel;
            for ( PositionIdModel *positionID in self.viewModel.positionIdArray )
            {
                if ( [model.PositionId isEqualToString:positionID.positionId] )
                {
                    isRead = YES;
                    break;
                }
            }
            cell.indexPath = indexPath;
            [cell configCellWithDatas:modeFrame hideCheckMoreButton:hideCheckMoreButton];
            [cell setSeparatorIsHide:hideSeparatorBlock];
            [cell setContentIsRead:isRead];
            [cell setLastCellIsHide:isHideSeparator];
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( 0 < [self.guessPositionVM.visiabelGuessYLPositionArrayM count] )
    {
        if ( 0 == indexPath.section )
        {
            [MobClick event:@"click_may_like"];
            CPRecommendModelFrame *recommendModelFrame = self.guessPositionVM.visiabelGuessYLPositionArrayM[indexPath.row];
            JobSearchModel *bean = recommendModelFrame.recommendModel;
            CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
            [companyDetailVC configWithPosition:bean];
            [self.navigationController pushViewController:companyDetailVC animated:YES];
            [PositionIdModel savePositionIdWith:bean.PositionId];
            [self.viewModel allPositionId];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *indexPathArray = [NSArray arrayWithObject:indexPath];
                    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            });
        }
        else if ( 1 == indexPath.section )
        {
            
        }
        else
        {
            [MobClick event:@"click_hot_position"];
            CPRecommendModelFrame *recommendModelFrame = self.viewModel.visiabelRecommendPositionArrayM[indexPath.row];
            JobSearchModel *bean = recommendModelFrame.recommendModel;
            CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
            [companyDetailVC configWithPosition:bean];
            [self.navigationController pushViewController:companyDetailVC animated:YES];
            [PositionIdModel savePositionIdWith:bean.PositionId];
            [self.viewModel allPositionId];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *indexPathArray = [NSArray arrayWithObject:indexPath];
                    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            });
        }
    }
    else
    {
        if ( 0 == indexPath.section )
        {
            
        }
        else
        {
            [MobClick event:@"click_hot_position"];
            CPRecommendModelFrame *recommendModelFrame = self.viewModel.visiabelRecommendPositionArrayM[indexPath.row];
            JobSearchModel *bean = recommendModelFrame.recommendModel;
            CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
            [companyDetailVC configWithPosition:bean];
            [self.navigationController pushViewController:companyDetailVC animated:YES];
            [PositionIdModel savePositionIdWith:bean.PositionId];
            [self.viewModel allPositionId];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *indexPathArray = [NSArray arrayWithObject:indexPath];
                    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            });
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( 0 < [self.guessPositionVM.visiabelGuessYLPositionArrayM count] && self.userStr )
    {
        if ( 0 == section )
            return self.guessHeaderView;        // 猜你喜欢
        else if ( 1 == section )
        {
            if ( 0 < [self.companyArrayM count] )
                return self.recommendHeaderView;    // 企业推荐
            else
                return nil;
        }
        else
            return self.hotRecruitHeaderView;   // 热招职位
    }
    else
    {
        if ( 0 == section )
            return self.recommendHeaderView;     // 企业推荐
        else
        {
            return self.hotRecruitHeaderView;   // 热招职位
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( 0 < [self.guessPositionVM.visiabelGuessYLPositionArrayM count] && self.userStr )
    {
        if ( 0 == section )
            return nil;
        else if ( 1 == section )
        {
            return nil;
        }
        else
            return self.checkExpectWorkView;
    }
    else
    {
        if ( 0 == section )
            return nil;
        else
        {
            return self.checkExpectWorkView;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( 0 < [self.guessPositionVM.visiabelGuessYLPositionArrayM count] && self.userStr )
    {
        if ( 0 == section )
            return 0;
        else if ( 1 == section )
        {
            return 0;
        }
        else
            return self.sectionFooterHeight;
    }
    else
    {
        if ( 0 == section )
            return 0;
        else
        {
            return self.sectionFooterHeight;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 将要隐藏属性
    self.isWillHide = YES;
    for( UIView *subView in self.navigationController.view.subviews)
    {
        if( [subView isKindOfClass:[UIButton class]] )
        {
            [subView removeFromSuperview];
        }
    }
}
/**
 *  显示最新职位的数量
 *
 *  @param count 最新职位的数量
 */
- (void)showNewStatusCount:(NSUInteger)count
{
    if ( self.isWillHide || self.isShowingTips )
        return;
    self.isShowingTips = YES;
    __weak typeof(self) weakSelf = self;
    // 1.创建一个按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // btn会显示在self.navigationController.navigationBar的下面
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    // 2.设置图片和文字
    btn.userInteractionEnabled = NO;
    //    [btn setBackgroundImage:[UIImage resizedImageWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
    [btn setBackgroundColor:CPColor(0xfb, 0xa1, 0x5e, 1.0)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    if( count )
    {
        NSString *title = [NSString stringWithFormat:@"为您推荐%lu个职位", count];
        [btn setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:@"没有更新的职位" forState:UIControlStateNormal];
    }
    // 3.设置按钮的初始frame
    CGFloat btnH = 40;
    CGFloat btnY = CPStatusHeight + CPNavigationBarHeight - btnH;
    CGFloat btnX = 0;
    CGFloat btnW = CPScreenWidth - 2 * btnX;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    // 4.通过动画移动按钮（按钮向下移动）
    [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if ( btn )
            btn.transform = CGAffineTransformMakeTranslation(0, btnH);
    } completion:^(BOOL finished) {  // 向下移动的动画执行完毕后
        [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            if ( btn )
                btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            weakSelf.isShowingTips = NO;
            if ( btn )
            {
                // 将btn从内存中移除
                [btn removeFromSuperview];
            }
        }];
    }];
}
CGFloat _lastPostionY = 0;
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentPositionY = scrollView.contentOffset.y;
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if ( currentPositionY - _lastPostionY > 3.0 ) // scrollUp
    {
        CGFloat tempHeight = self.sectionFooterHeight;
        if ( distanceFromBottom <= (height + (120) / CP_GLOBALSCALE) )
        {
            if ( [self.viewModel.visiabelRecommendPositionArrayM count] == [self.viewModel.allRecommendPositionArrayM count] )
            {
                if ( ![self.checkExpectWorkView isHidden] )
                {
                    self.sectionFooterHeight = (120) / CP_GLOBALSCALE;
                    if ( ((120) / CP_GLOBALSCALE) != tempHeight )
                    {
                        [self.tableView reloadData];
                    }
                }
            }
        }
        else
        {
            
        }
    }
    else if ( _lastPostionY - currentPositionY > 3.0 ) // scrollDown
    {
        if ( distanceFromBottom <= (height + (120) / CP_GLOBALSCALE) )
        {
            
        }
        else
        {
            CGFloat tempHeight = self.sectionFooterHeight;
            self.sectionFooterHeight = 0.0;
            if ( 0 != tempHeight )
            {
                [self.tableView reloadData];
            }
        }
    }
    _lastPostionY = currentPositionY;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 清除控制器加载的用户信息
    if(self.userStr)
        self.userStr = nil;
}
#pragma mark - CPHomeRecommendHeaderViewDelegate
- (void)recommendView:(CPHomeRecommendHeaderView *)recommendView changeImageWithIndex:(NSUInteger)index
{
    [MobClick event:@"btn_change_company"];
    if ( [self.guessPositionVM.visiabelGuessYLPositionArrayM count] > 0 )
    {
        self.benginIndex++;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        self.benginIndex++;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark - CPHomeBindTestViewDelegate
- (void)homeBindTestView:(CPHomeBindTestView *)homeBindTestView isCanBind:(BOOL)isCanBind
{
    ModifyEmailVC *vc = [ModifyEmailVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)homeBindTestView:(CPHomeBindTestView *)homeBindTestView isCanTest:(BOOL)isCanTest
{
    NSString *url = [NSString stringWithFormat:@"%@/examcenter/desc?id=2",kHostMUrl];
    DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:url examDetail:examDetailOther];
    vc.title = @"极速职业测评";
    vc.strTitle = @"极速职业测评";
    vc.urlPath = url;
    vc.isJiSuCepin = YES;
    vc.urlLogo = @"http://file.cepin.com/da/speadexam_480_262.png";
    vc.contentText = @"你是否处于职业困惑中，不知道自己适合干什么？或者总觉得对现在的工作不感兴趣，毫无动力？再或者面临职业发展和转型，犹豫着何去何从？极速职业测评基于大五人格理论，可以帮助你深入了解自己的性格特点和脸谱类型、评估个人的能力水平和优劣势，并根据你的性格与能力帮助你找到最适合的岗位和企业。超过1000万测评者亲证，绝对duang duang的！为确保结果能真实反映你的水平，请：在安静、独立的空间完成测评根据第一反应答题如遇网络问题，退出后可以重新进入答题界面";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - CPHomeRegisterViewDelegate
- (void)homeRegisterView:(CPHomeRegisterView *)homeRegisterView isCanRegister:(BOOL)isCanRegister
{
    [MobClick event:@"module_to_regist"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"homeRegister" forKey:@"comfrom"];
    UIViewController *vc = [[CPNMediator alloc] CPNMediator_viewControllerForSignup:params];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - CPHomeCheckExpectWorkViewDelegate
- (void)homeCheckExpectWorkView:(CPHomeCheckExpectWorkView *)homeCheckExpectWorkView isCheckExpectWork:(BOOL)isCheckExpectWork
{
    //    @property(nonatomic,strong)NSNumber<Optional> *ResumeType;//（1：普通简历,2：应届生）简历类型(社招=1，校招=2)
    [MobClick event:@"btn_to_expect_work"];
    NSString *strUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if ( 0 == [strUserID length] || 0 == [strTocken length] )
    {
        NSDictionary *params = [NSDictionary dictionaryWithObject:@"homeexperience" forKey:@"comfrom"];
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        if ( !self.defaultResumeInfoDict )
        {
            NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
            GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:mobile];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:NO completion:nil];
        }
        else
        {
            ResumeNameModel *resume = [ResumeNameModel beanFromDictionary:self.defaultResumeInfoDict];
            BOOL isSocial = NO;
            if ( 1 == [resume.ResumeType intValue] )
                isSocial = YES;
            AddExpectJobVC *vc = [[AddExpectJobVC alloc] initWithModel:resume isSocial:isSocial];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - CPHomeGuessCellDelegate
- (void)homeGuessCell:(CPHomeGuessCell *)homeGuessCell clickedLoadMoreButton:(UIButton *)loadMoreButton
{
    NSIndexPath *indexPath = homeGuessCell.indexPath;
    if ( 0 == indexPath.section )
    {
        [self.guessPositionVM clickedMoreButton];
        [self.tableView reloadData];
    }
    else if ( 1 == indexPath.section || 2 == indexPath.section )
    {
        if ( ![self isNetworkValid] && [self.viewModel.visiabelRecommendPositionArrayM count] >= [self.viewModel.allRecommendPositionArrayM count] )
        {
            [self showTipsView];
            return;
        }
        [self.viewModel clickedMoreButton];
        [self.tableView reloadData];
    }
}
#pragma mark - CPHomeRecommendCellDelegate
- (void)homeRecommendCell:(CPHomeRecommendCell *)homeRecommendCell clickedButton:(UIButton *)clickedButton
{
    [MobClick event:@"click_big_company"];
    NSDictionary *dict = self.companyArrayM[clickedButton.tag];
    JobSearchModel *job = [JobSearchModel beanFromDictionary:dict];
    CPCompanyDetailController *companyDetailVC = [[CPCompanyDetailController alloc] init];
    [companyDetailVC configWithPosition:job];
    [self.navigationController pushViewController:companyDetailVC animated:YES];
}
#pragma mark - CPHomeHotRecruitHeaderViewDelegate
- (void)homeHotRcruitHeaderView:(CPHomeHotRecruitHeaderView *)homeHotRcruitHeaderView clickedMoreButton:(CPHomeRecommendButton *)moreButton
{
    //职位搜索
//    JobSearchResultVC *vc = [[JobSearchResultVC alloc]initWithKeyWord:self.locationRegion.PathCode];
    JobSearchResultVC *vc = [[JobSearchResultVC alloc]initWithCity:self.locationRegion.RegionName patchCode:self.locationRegion.PathCode];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - CPHomePositionRecommendHeaderViewDelegate
- (void)homePositionRecommendHeaderView:(CPHomePositionRecommendHeaderView *)homePositionRecommendHeaderView clickedMoreButton:(CPHomeRecommendButton *)moreButton
{
    JobSearchResultVC *vc = [[JobSearchResultVC alloc] initWithCity:self.locationRegion.RegionName patchCode:self.locationRegion.PathCode];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)showMessageTips:(NSString *)tips identifier:(NSInteger)identifier
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [self.tipsView setIdentifier:identifier];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
- (void)comeFromeWithString:(NSString *)string
{
    if ( !string || 0 == [string length] )
        return;
    if ( [string isEqualToString:@"homeResume"] )
    {
        TBLoading *load = [[TBLoading alloc] init];
        [load start];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ( load )
                [load stop];
            //简历列表
            AllResumeVC *vc = [AllResumeVC new];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
    else if ( [string isEqualToString:@"homeTestList"] )
    {
        if ( !self.selectedBannerModel )
            return;
        DynamicExamDetailVC *vc  = nil;
        vc = [[DynamicExamDetailVC alloc] initWithUrl:self.selectedBannerModel.LinkUrl examDetail:examDetailOther];
        vc.title = self.selectedBannerModel.Title;
        vc.strTitle = self.selectedBannerModel.Title;
        vc.urlPath = self.selectedBannerModel.LinkUrl;
        vc.isJiSuCepin = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( [string isEqualToString:@"homeADGuide"] )
    {
        NSString *mobiel = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
        SignupGuideResumeVC *vc = [[SignupGuideResumeVC alloc] initWithMobiel:mobiel comeFromString:@"homeADGuide"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( [string isEqualToString:@"homedelivery"] )
    {
        // 打开投递记录
        SendResumeVC *vc = [SendResumeVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( [string isEqualToString:@"homeexperience"] )
    {
        [self comeFromGetDefaultResume];
    }
}
- (void)comeFromeWithString:(NSString *)string notificationDict:(NSDictionary *)notificationDict
{
    if ( [string isEqualToString:@"notificationshomeTestList"] )
    {
        NSString *title = [notificationDict valueForKey:@"title"];
        NSString *url = [notificationDict valueForKey:@"url"];
        DynamicExamDetailVC *vc  = nil;
        vc = [[DynamicExamDetailVC alloc] initWithUrl:url examDetail:examDetailOther];
        vc.title = title;
        vc.strTitle = title;
        vc.urlPath = url;
        vc.isJiSuCepin = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)toWorkExperience
{
    ResumeNameModel *resume = [ResumeNameModel beanFromDictionary:self.defaultResumeInfoDict];
    BOOL isSocial = NO;
    if ( 1 == [resume.ResumeType intValue] )
        isSocial = YES;
    AddExpectJobVC *vc = [[AddExpectJobVC alloc] initWithModel:resume isSocial:isSocial];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getDefaultResumeToWhere
{
    if ( !self.defaultResumeInfoDict )
    {
        NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
        GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:mobile];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:NO completion:nil];
    }
    else
    {
        BOOL isHideToExpectView = NO;
        if ( [[self.defaultResumeInfoDict objectForKey:@"ExpectCity"] isKindOfClass:[NSNull class]] )
        {
            [self.checkExpectWorkView setHidden:isHideToExpectView];
            [self toWorkExperience];
            return;
        }
        if ( [[self.defaultResumeInfoDict objectForKey:@"ExpectJobFunction"] isKindOfClass:[NSNull class]] )
        {
            [self.checkExpectWorkView setHidden:isHideToExpectView];
            [self toWorkExperience];
            return;
        }
        if ( [[self.defaultResumeInfoDict objectForKey:@"ExpectSalary"] isKindOfClass:[NSNull class]] )
        {
            [self.checkExpectWorkView setHidden:isHideToExpectView];
            [self toWorkExperience];
            return;
        }
        if ( [[self.defaultResumeInfoDict objectForKey:@"WorkYearKey"] isKindOfClass:[NSNull class]] )
        {
            [self.checkExpectWorkView setHidden:isHideToExpectView];
            [self toWorkExperience];
            return;
        }
        isHideToExpectView = YES;
        [self.checkExpectWorkView setHidden:isHideToExpectView];
        self.checkExpectWorkView.viewHeight = 0.0;
    }
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton
{
    NSInteger identifier = self.tipsView.identifier;
    self.tipsView = nil;
    if ( 1000 == identifier )
    {
        NSDictionary *params = [NSDictionary dictionaryWithObject:@"MeResume" forKey:@"comfrom"];
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if ( 1001 == identifier )
    {
        NSDictionary *params = [NSDictionary dictionaryWithObject:@"testList" forKey:@"comfrom"];
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton identifier:(NSInteger)identifier
{
    self.tipsView = nil;
    if ( 1000 == identifier )
    {
        NSDictionary *params = [NSDictionary dictionaryWithObject:@"homeResume" forKey:@"comfrom"];
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if ( 1001 == identifier )
    {
        NSDictionary *params = [NSDictionary dictionaryWithObject:@"homeTestList" forKey:@"comfrom"];
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if ( 1002 == identifier )
    {
        NSDictionary *params = [NSDictionary dictionaryWithObject:@"homeADGuide" forKey:@"comfrom"];
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)showTipsView
{
    if ( !self.maxSelecetdTipsView.isHidden )
        return;
    [self.maxSelecetdTipsView setHidden:NO];
    [self.maxSelecetdTipsView setAlpha:1.0];
    __weak typeof( self ) weakSelf = self;
    [UIView animateWithDuration:2.0 animations:^{
        [weakSelf.maxSelecetdTipsView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [weakSelf.maxSelecetdTipsView setHidden:YES];
    }];
}
- (BOOL)isNetworkValid
{
    BOOL isValid = NO;
    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    if ( delegate.isHaveNetwork )
        isValid = YES;
    return isValid;
}
#pragma mark - getter methods
- (CPTipsView *)messageTipsViewWithTips:(NSString *)tips
{
    if ( !_tipsView )
    {
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"暂不登录", @"去登录"] showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
- (UIView *)homeHeaderView
{
    if ( !_homeHeaderView )
    {
        _homeHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 350 / CP_GLOBALSCALE + 180 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE)];
        [_homeHeaderView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_homeHeaderView addSubview:self.bindTestView];
        [_homeHeaderView addSubview:self.registerView];
        [_homeHeaderView.layer setMasksToBounds:YES];
    }
    return _homeHeaderView;
}
- (CPHomeRegisterView *)registerView
{
    if ( !_registerView )
    {
        _registerView = [[CPHomeRegisterView alloc] initWithFrame:CGRectMake(0, 350 / CP_GLOBALSCALE, kScreenWidth, 180 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE)];
        [_registerView setHomeRegisterViewDelegate:self];
    }
    return _registerView;
}
- (CPHomeBindTestView *)bindTestView
{
    if ( !_bindTestView )
    {
        _bindTestView = [[CPHomeBindTestView alloc] initWithFrame:CGRectMake(0, 350 / CP_GLOBALSCALE, kScreenWidth, 180 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE)];
        [_bindTestView setHomeBindTestViewDelegate:self];
    }
    return _bindTestView;
}
- (AdScrollView *)adScrollView
{
    if ( !_adScrollView )
    {
        _adScrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 350 / CP_GLOBALSCALE)];
        _adScrollView.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"ffffff"];
        _adScrollView.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"e1e1e3"];
        _adScrollView.bannerDelegate = self;
    }
    return _adScrollView;
}
-(SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        //网络加载 --- 创建带标题的图片轮播器
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 350 / CP_GLOBALSCALE) imageURLStringsGroup:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.delegate = self;
        _cycleScrollView.infiniteLoop = YES;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"index_banner_null"];
        _cycleScrollView.autoScroll = YES;
    }
    return _cycleScrollView;
}
- (CPHomeGuessHeaderView *)guessHeaderView
{
    if ( !_guessHeaderView )
    {
        _guessHeaderView = [[CPHomeGuessHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (40 + 42 + 40) / CP_GLOBALSCALE)];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_guessHeaderView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _guessHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _guessHeaderView.mas_bottom );
            make.right.equalTo( _guessHeaderView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _guessHeaderView;
}
- (CPHomeRecommendHeaderView *)recommendHeaderView
{
    if ( !_recommendHeaderView )
    {
        _recommendHeaderView = [[CPHomeRecommendHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (40 + 42 + 40) / CP_GLOBALSCALE)];
        _recommendHeaderView.recommendHeaderViewDelegate = self;
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_recommendHeaderView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _recommendHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _recommendHeaderView.mas_bottom );
            make.right.equalTo( _recommendHeaderView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _recommendHeaderView;
}
- (CPHomeHotRecruitHeaderView *)hotRecruitHeaderView
{
    if ( !_hotRecruitHeaderView )
    {
        _hotRecruitHeaderView = [[CPHomeHotRecruitHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (40 + 42 + 40) / CP_GLOBALSCALE)];
        [_hotRecruitHeaderView setHomeHotRecruitHeaderViewDelegate:self];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_hotRecruitHeaderView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _hotRecruitHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _hotRecruitHeaderView.mas_bottom );
            make.right.equalTo( _hotRecruitHeaderView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _hotRecruitHeaderView;
}
- (CPHomePositionRecommendHeaderView *)positionRecommendHeaderView
{
    if ( !_positionRecommendHeaderView )
    {
        _positionRecommendHeaderView = [[CPHomePositionRecommendHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 40 + 42 + 40 ) / CP_GLOBALSCALE )];
        [_positionRecommendHeaderView setHomePositionRecommendHeaderViewDelegate:self];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_positionRecommendHeaderView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _positionRecommendHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _positionRecommendHeaderView.mas_bottom );
            make.right.equalTo( _positionRecommendHeaderView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _positionRecommendHeaderView;
}
- (NSMutableArray *)companyArrayM
{
    if ( !_companyArrayM )
    {
        _companyArrayM = [NSMutableArray array];
    }
    return _companyArrayM;
}
- (NSMutableArray *)guessLikeArrayM
{
    if ( !_guessLikeArrayM )
    {
        _guessLikeArrayM = [NSMutableArray array];
    }
    return _guessLikeArrayM;
}
- (CPHomeCheckExpectWorkView *)checkExpectWorkView
{
    if ( !_checkExpectWorkView )
    {
        _checkExpectWorkView = [[CPHomeCheckExpectWorkView alloc] initWithFrame:CGRectMake(0, 0.0, kScreenWidth, 0.0)];
        [_checkExpectWorkView setHomeCheckExpectWorkViewDelegate:self];
        [_checkExpectWorkView setHidden:YES];
    }
    return _checkExpectWorkView;
}
- (NSMutableArray *)visibleLikeArrayM
{
    if ( !_visibleLikeArrayM )
    {
        _visibleLikeArrayM = [NSMutableArray array];
    }
    return _visibleLikeArrayM;
}
- (NSMutableArray *)allGuessLikeDictArrayM
{
    if ( !_allGuessLikeDictArrayM )
    {
        _allGuessLikeDictArrayM = [NSMutableArray array];
    }
    return _allGuessLikeDictArrayM;
}
- (NSMutableArray *)visibleGuessLikeDictArrayM
{
    if ( !_visibleGuessLikeDictArrayM )
    {
        _visibleGuessLikeDictArrayM = [NSMutableArray array];
    }
    return _visibleGuessLikeDictArrayM;
}
- (UIView *)maxSelecetdTipsView
{
    if ( !_maxSelecetdTipsView )
    {
        NSString *tipsString = @"加载失败";
        CGSize tipsStringSize = [tipsString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]} context:nil].size;
        CGFloat W = tipsStringSize.width + 80 / CP_GLOBALSCALE;
        CGFloat H = 42 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
        CGFloat X = ( kScreenWidth - W ) / 2.0;
        CGFloat Y = kScreenHeight - H - 60 / CP_GLOBALSCALE - 49.0 - 64.0;
        _maxSelecetdTipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [_maxSelecetdTipsView.layer setCornerRadius:H / 4.0];
        [_maxSelecetdTipsView.layer setMasksToBounds:YES];
        [_maxSelecetdTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000"]];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [titleLabel setText:tipsString];
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
- (CPHomeChangeCityButton *)changeCityBtn
{
    if ( !_changeCityBtn )
    {
        NSString *locationCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
        //获取当前城市对象
        if( nil==locationCity || [locationCity isEqualToString:@""] )
        {
            locationCity=@"全国";
            self.locationRegion = [Region new];
            self.locationRegion.RegionName = locationCity;
            self.locationRegion.PathCode = @"";
        }
        else
        {
            self.locationRegion = [Region searchAddressWithAddressString:locationCity];
            locationCity = self.locationRegion.RegionName;
        }
        TBAppDelegate *appdelagate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
        if (nil == appdelagate.homeCity || NULL == appdelagate.homeCity || !appdelagate.homeCity)
        {
            appdelagate.homeCity =locationCity;
        }
        else
        {
            locationCity =  appdelagate.homeCity;
        }
        self.viewModel.cityCode = self.locationRegion.PathCode;
        _changeCityBtn = [CPHomeChangeCityButton buttonWithType:UIButtonTypeCustom];
        [_changeCityBtn setBackgroundColor:[UIColor clearColor]];
        [_changeCityBtn.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_changeCityBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_changeCityBtn setTitle:locationCity forState:UIControlStateNormal];
        _changeCityBtn.viewSize = CGSizeMake(_changeCityBtn.titleLabel.font.pointSize * 5 + 20 / CP_GLOBALSCALE + 70 / CP_GLOBALSCALE, 70 / CP_GLOBALSCALE);
        [_changeCityBtn setImage:[UIImage imageNamed:@"index_ic_down副本"] forState:UIControlStateNormal];
        [_changeCityBtn addTarget:self action:@selector(clickedChangeCity) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeCityBtn;
}
- (NSString *)selectedCityPathCode
{
    NSString *cityPathCode = @"";
    NSString *tempCity = self.changeCityBtn.titleLabel.text;
    if ( ![tempCity isEqualToString:@"全国"] )
    {
        Region *tempRegion = [Region searchAddressWithAddressString:tempCity];
        cityPathCode = tempRegion.PathCode;
    }
    return cityPathCode;
}
@end