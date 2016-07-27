//
//  CPHomeCompanyDetailController.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomePositionDetailController.h"
#import "CPPositionDetailTopView.h"
#import "CPPositionDetailRequireView.h"
#import "CPPositionDetailDescribeView.h"
#import "CPCompanyDetailController.h"
#import "CPPositionDetailButton.h"
#import "RTNetworking+Position.h"
#import "NSDictionary+NetworkBean.h"
#import "JobDetailModelDTO.h"
#import "UmengView.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "TBUmengShareConfig.h"
#import "NewJobDetialVM.h"
#import "CPPositionDetaildelivery.h"
#import "CPDeliveryNoResumeTipsView.h"
#import "ResumeNameVC.h"
#import "CPSchoolResumeEditController.h"
#import "CreateResumeByInfoVC.h"
#import "CPPositionDeliveryController.h"
#import "CPTipsView.h"
#import "LoginVC.h"
#import "CreateSchoolResumeByInfoVC.h"
#import "AllResumeVC.h"
#import "CPPositionDetailWelfare.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"
#import "CPWXinsanbanController.h"
@interface CPHomePositionDetailController ()<CPPositionDetailTopViewDelegate, UmengViewDelegate, UMSocialUIDelegate, CPPositionDetaildeliveryDelegate, CPDeliveryNoResumeTipsViewDelegate, CPTipsViewDelegate, CPSchoolResumeEditControllerDelegate, ResumeNameVCDelegate>
@property (nonatomic, strong) UIView *bottomBackgroundView;
@property (nonatomic, strong) UIButton *deliverButton;
@property (nonatomic, strong) CPPositionDetailButton *collectionButton;
@property (nonatomic, strong) UIView *collectionView;
@property (nonatomic, strong) UIScrollView *positionDetailBackgroundView;
@property (nonatomic, strong) CPPositionDetailTopView *detailTopView;
@property (nonatomic, strong) CPPositionDetailRequireView *detailRequireView;
@property (nonatomic, strong) CPPositionDetailDescribeView *detailDescribeView;
@property (nonatomic, strong) JobSearchModel *position;
@property (nonatomic, strong) NSDictionary *positionDetail;
@property (nonatomic, retain) UmengView *umengView;
@property (nonatomic, strong) NewJobDetialVM *viewModel;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) CPPositionDetaildelivery *deliveryView;
@property (nonatomic, strong) CPDeliveryNoResumeTipsView *noResumeTips;
@property (nonatomic, strong) CPTipsView *noUerTipsView;
@property (nonatomic, strong) UIView *noNetworkView;
@property (nonatomic, strong) UIView *maxSelecetdTipsView;
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,strong)TBLoading *load;

@end
@implementation CPHomePositionDetailController
#pragma mark - lift cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        [self setTitle:@"职位详情"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"position_detail_launch"];
    [self.view addSubview:self.positionDetailBackgroundView];
    self.detailTopView.frame = CGRectMake(0, 0, self.positionDetailBackgroundView.viewWidth, (60 + 60 + 60 + 42 + 60 + 140 + 60 + 60) / CP_GLOBALSCALE);
    self.detailRequireView.frame = CGRectMake(0, CGRectGetMaxY(self.detailTopView.frame) + 30 / CP_GLOBALSCALE, self.positionDetailBackgroundView.viewWidth, (60 + 42 + 60 + 36 + 40 + 36 + 60) / CP_GLOBALSCALE);
    self.detailDescribeView.frame = CGRectMake(0, CGRectGetMaxY(self.detailRequireView.frame) + 30 / CP_GLOBALSCALE, self.view.viewWidth, (60 + 42 + 60 + 60) / CP_GLOBALSCALE + 300);
    [self.positionDetailBackgroundView setContentSize:CGSizeMake(self.view.viewWidth, CGRectGetMaxY(self.detailDescribeView.frame) + 30 / CP_GLOBALSCALE)];
    [self.view addSubview:self.bottomBackgroundView];
    [self.view addSubview:self.noNetworkView];
    [self.bottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( self.view.mas_left );
        make.bottom.equalTo( self.view.mas_bottom );
        make.right.equalTo( self.view.mas_right );
        make.height.equalTo( @( 150 / CP_GLOBALSCALE ) );
    }];
    [self.view addSubview:self.maxSelecetdTipsView];
}
- (void)configWithPosition:(JobSearchModel *)position
{
    // PositionType 1 是校招
    _position = position;
    [self.positionDetailBackgroundView setHidden:YES];
    self.viewModel = [[NewJobDetialVM alloc] initWithJobId:_position.PositionId companyId:_position.CustomerId];
    [self.viewModel getPositionDetail];
    @weakify(self)
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        if ( !stateCode )
            return;
        if ( self.viewModel.positionDetail )
        {
            self.positionDetail = [self.viewModel.positionDetail copy];
            _position = [JobSearchModel beanFromDictionary:self.positionDetail];
            [self.detailTopView configWithPosition:self.positionDetail];
            [self.detailRequireView configWithPosition:self.positionDetail];
            [self.detailDescribeView configWithPosition:self.positionDetail];
            if ( self.position.IsCollection.intValue == 1 )
            {
                [self.collectionButton setSelected:YES];
            }
            else
            {
              [self.collectionButton setSelected:NO];
            }
            if ( [self.position.IsDeliveried intValue] == 1 )
            {
                [self.deliverButton setEnabled:NO];
            }
            else
            {
                [self.deliverButton setEnabled:YES];
            }
             [self resView];
            [self.noNetworkView setHidden:YES];
            [self.positionDetailBackgroundView setHidden:NO];
        }
        else
        {
            [self.noNetworkView setHidden:NO];
        }
        if ( !position.PositionType )
            [self.viewModel getAllResumeWithPositionType:_position.PositionType];
        else
            [self.viewModel getAllResumeWithPositionType:position.PositionType];
    }error:^(NSError *error) {
         [self.noNetworkView setHidden:NO];
    }];
    [RACObserve(self.viewModel, deliveryResumeStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        if ([stateCode isKindOfClass:[RTHUDModel class]])
        {
            RTHUDModel *model = (RTHUDModel *)stateCode;
            if ( model.hudCode == HUDCodeSucess )
            {
                [self.deliverButton setEnabled:NO];
                CPPositionDeliveryController *vc = [[CPPositionDeliveryController alloc] initWithPositionId:self.position.PositionId];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self showErrorMessage:self.viewModel.message];
            }
        }
        else if([stateCode isKindOfClass:[NSError class]])
        {
            [self showErrorMessage:self.viewModel.message];
        }
    }];
}
- (void)configWithPositionId:(NSString *)positionId
{
    if (!self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = YES;
    }
    [self.positionDetailBackgroundView setHidden:YES];
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance] userTokenId];
    self.viewModel = [[NewJobDetialVM alloc] initWithJobId:positionId companyId:@""];
    RACSignal *signal = [[RTNetworking shareInstance] getPositionDetailWithTokenId:strTokenId userId:strUser positionId:positionId];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ( [dic resultSucess] )
        {
            NSDictionary *positionDict = [dic resultObject];
            self.positionDetail = [positionDict copy];
            _position = [JobSearchModel beanFromDictionary:self.positionDetail];
             [self.viewModel getAllResumeWithPositionType:_position.PositionType];
            [self.detailTopView configWithPosition:self.positionDetail];
            [self.detailRequireView configWithPosition:self.positionDetail];
            [self.detailDescribeView configWithPosition:self.positionDetail];
            if ( self.position.IsCollection.intValue == 1 )
            {
                [self.collectionButton setSelected:YES];
            }
            else
            {
                [self.collectionButton setSelected:NO];
            }
            
            if ( [self.position.IsDeliveried intValue] == 1 )
            {
                [self.deliverButton setEnabled:NO];
            }
            else
            {
                [self.deliverButton setEnabled:YES];
            }
            [self.positionDetailBackgroundView setHidden:NO];
            [self.noNetworkView setHidden:YES];
            [self resView];
        }else
        {
            [self.noNetworkView setHidden:NO];
        }
        if (self.load)
        {
            [self.load stop];
        }
    } error:^(NSError *error){
        if (self.load)
        {
            [self.load stop];
        }
    }];
    
    [RACObserve(self.viewModel, deliveryResumeStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        if ([stateCode isKindOfClass:[RTHUDModel class]])
        {
            RTHUDModel *model = (RTHUDModel *)stateCode;
            if ( model.hudCode == HUDCodeSucess )
            {
                [self.deliverButton setEnabled:NO];
                CPPositionDeliveryController *vc = [[CPPositionDeliveryController alloc] initWithPositionId:self.position.PositionId];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                //                [self showMessageTips:self.viewModel.message];
                [self showErrorMessage:self.viewModel.message];
            }
        }
        else if([stateCode isKindOfClass:[NSError class]])
        {
            [self showErrorMessage:self.viewModel.message];
            //            [self showMessageTips:self.viewModel.message];
        }
    }];
}
- (void)resView
{
    CGFloat maxW;
    if ( 2 != _position.PositionType.intValue )
    {
          maxW = kScreenWidth -(40 * 3+60 ) / CP_GLOBALSCALE;
    }
    else
    {
        maxW = kScreenWidth -(40*2) / CP_GLOBALSCALE;
    }
//    CGFloat maxW = kScreenWidth -(40 * 3+60 ) / 3.0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_position.PositionName attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"707070"], NSFontAttributeName : [UIFont systemFontOfSize:60 / CP_GLOBALSCALE]}];
    //     根据获取到的字符串以及字体计算label需要的size
    CGSize strSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    CGFloat positionW = strSize.width;
    CGFloat positionH = strSize.height;
    CGFloat welfareSize = [self.detailTopView companyWelfareHeightWithWalfearData:[self.positionDetail valueForKey:@"Tags"]];
    NSString *jobDescriptionString = [self.positionDetail valueForKey:@"HtmlJobDescription"];
    if(nil != jobDescriptionString && ![@"" isEqualToString:jobDescriptionString]){
        jobDescriptionString = [jobDescriptionString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        jobDescriptionString = [jobDescriptionString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    }
    NSMutableAttributedString *jobDescriptionAttString = [[NSMutableAttributedString alloc] initWithString:jobDescriptionString];
    NSMutableParagraphStyle *jobDescriptionParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [jobDescriptionParagraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [jobDescriptionAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [jobDescriptionString length])];
    [jobDescriptionAttString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:NSMakeRange(0, [jobDescriptionString length])];
    CGSize jobDescriptionSize = [jobDescriptionAttString boundingRectWithSize:CGSizeMake(kScreenWidth - 40 / CP_GLOBALSCALE - 30 / CP_GLOBALSCALE, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    CGFloat jobDescriptionH = jobDescriptionSize.height + 10.0;
    self.detailTopView.frame = CGRectMake(0, 0, self.positionDetailBackgroundView.viewWidth, (60 + 60 + 60 + 60 + 140 + 60) / CP_GLOBALSCALE + positionH + welfareSize );
    self.detailRequireView.frame = CGRectMake(0, CGRectGetMaxY(self.detailTopView.frame) + 30 / CP_GLOBALSCALE, self.positionDetailBackgroundView.viewWidth, (60 + 42 + 60 + 36 + 40 + 36 + 60) / CP_GLOBALSCALE);
    CGFloat leftMarge = kScreenHeight - CGRectGetMaxY( self.detailRequireView.frame ) - 30 / 3.0;
    if ( jobDescriptionH > leftMarge )
        self.detailDescribeView.frame = CGRectMake(0, CGRectGetMaxY(self.detailRequireView.frame) + 30 / CP_GLOBALSCALE, self.view.viewWidth, (60 + 42 + 60 + 60) / CP_GLOBALSCALE + jobDescriptionH);
    else
        [self.detailDescribeView setFrame:CGRectMake(0, CGRectGetMaxY( self.detailRequireView.frame ) + 30 / CP_GLOBALSCALE, self.view.viewWidth, leftMarge+30)];
    [self.positionDetailBackgroundView setContentSize:CGSizeMake(self.view.viewWidth, CGRectGetMaxY(self.detailDescribeView.frame) + 150 / CP_GLOBALSCALE)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    // 导航栏右边分享按钮 ic_share
    CPWPositionShareButton *shareBtn = [CPWPositionShareButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setBackgroundColor:[UIColor clearColor]];
    shareBtn.viewSize = CGSizeMake(70 / CP_GLOBALSCALE, 70 / CP_GLOBALSCALE);
    [shareBtn setImage:[UIImage imageNamed:@"ic_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickedShareButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    if (self.viewModel && !self.viewModel.isLoad ) {
        [self.viewModel getPositionDetail];
    }
    if ( !self.viewModel.isLoad && self.position)
    {
        if ( self.position.PositionType )
            [self.viewModel getAllResumeWithPositionType:self.position.PositionType];
    }
}
#pragma mark - CPPositionDetailTopViewDelegate
- (void)checkCompanyDetail
{
    CPCompanyDetailController *companyDetailVC = [[CPCompanyDetailController alloc] init];
    [companyDetailVC configWithPosition:self.position];
    [self.navigationController pushViewController:companyDetailVC animated:YES];
}
- (void)clickedXinsanbanButton
{
    // http://ipo.cepin.com/
    CPWXinsanbanController *vc = [[CPWXinsanbanController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - event
- (void)clickedShareButton
{
    [MobClick event:@"job_details_share"];
    [self.umengView show];
}
#pragma mark - UmengViewDelegate
- (void)didChooseUmengView:(int)tag
{
    [self.umengView disMiss];
    if ( ![self isNetworkValid] )
    {
        [self showTipsView];
        return;
    }
    NSMutableArray  *title = [[NSMutableArray alloc]init];
    if([WXApi isWXAppInstalled])
    {
        [title addObject:@"微信好友"];
        [title addObject:@"朋友圈"];
    }
    [title addObject:@"新浪微博"];
    if([QQApiInterface isQQInstalled])
    {
        [title addObject:@"QQ"];
        [title addObject:@"QQ空间"];
    }
    NSString *platformName = nil;
    NSString *selectedTitle = [title objectAtIndex:tag];
    if ( [selectedTitle isEqualToString:@"新浪微博"] )
    {
        platformName = @"sina";
    }
    else if ( [selectedTitle isEqualToString:@"微信好友"] )
    {
        platformName = @"wxsession";
    }
    else if ( [selectedTitle isEqualToString:@"朋友圈"] )
    {
        platformName = @"wxfriend";
    }
    else if ( [selectedTitle isEqualToString:@"QQ"] )
    {
        platformName = @"qq";
    }
    else if ( [selectedTitle isEqualToString:@"QQ空间"] )
    {
        platformName = @"qzone";
    }
    NSMutableString *shareBody = [[NSMutableString alloc] init];
    if (![_position.Salary isKindOfClass:[NSNull class]])
    {
        [shareBody appendFormat:@"月入%@",_position.Salary];
    }
    if ( ![_position.PositionName isKindOfClass:[NSNull class]] )
    {
        [shareBody appendFormat:@"-诚招%@", _position.PositionName];
    }
    if (![_position.CompanyName isKindOfClass:[NSNull class]])
    {
        [shareBody appendFormat:@"-%@",_position.CompanyName];
    }
    if (![_position.City isKindOfClass:[NSNull class]])
    {
        [shareBody appendFormat:@"%@-测聘网",_position.City];
    }
//    /speical/portal/doorindex
//    NSString *url = [NSString stringWithFormat:@"%@/JobSearch/PositionDetail?positionId=%@",kHostShareUrl,_position.PositionId];
    NSString *url = [NSString stringWithFormat:@"http://m.cepin.com/#/positions?id=%@", _position.PositionId];
    if ( [platformName isEqualToString:@"sina"] ) {
        NSMutableString *tagString = [NSMutableString string];
        if ( [_position.Tags count] > 0 )
        {
            for ( NSString *str in _position.Tags )
            {
                if ( 0 < [tagString length] )
                {
                    [tagString appendFormat:@",%@", str];
                }
                else
                    [tagString appendString:str];
            }
        }
        NSString *contentText = [NSString stringWithFormat:@"%@%@", shareBody, url];
        if ( !_position.CompanyLogoUrl || 0 == [_position.CompanyLogoUrl length] )
        {
            [[UMSocialControllerService defaultControllerService] setShareText:contentText shareImage:[UIImage imageNamed:@"cepin_icon_share"] socialUIDelegate:self];
        }
        else
        {
            [[UMSocialControllerService defaultControllerService] setShareText:contentText shareImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:_position.CompanyLogoUrl]] socialUIDelegate:self];
        }
               //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    else
    {
        NSMutableString *tagString = [NSMutableString string];
        if ( [_position.Tags count] > 0 )
        {
            for ( NSString *str in _position.Tags )
            {
                if ( 0 < [tagString length] )
                {
                    [tagString appendFormat:@",%@", str];
                }
                else
                    [tagString appendString:str];
            }
        }
        NSString *contentText = [NSString stringWithFormat:@"%@-职位诱惑:%@", _position.Introduction, tagString];
        [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:shareBody content:contentText url:url imageUrl:_position.CompanyLogoUrl completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess)
            {
                //                [OMGToast showWithText:@"分享成功" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                //                [OMGToast showWithText:@"分享失败" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
        }];
    }
}
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
#pragma mark - CPPositionDetaildeliveryDelegate
- (void)positionDetailDeliveryView:(CPPositionDetaildelivery *)positionDetailDeliveryView selectedResume:(ResumeNameModel *)selectedResume
{
    [self.deliveryView setHidden:YES];
    self.deliveryView = nil;
    if ( [selectedResume.IsCompleteResume intValue] == 1 )
    {
        [self.viewModel resumeDeliveryWithResumeID:selectedResume.ResumeId];
    }
    else
    {
        [MobClick event:@"choose_resume_not_perfect"];
        NSString *positionDetail = @"positionDetail";
        NSInteger typeInt = [selectedResume.ResumeType intValue];
        if ( 1 == typeInt )
        {
            ResumeNameVC *vc = [[ResumeNameVC alloc] initWithResumeId:selectedResume.ResumeId deliveryString:positionDetail];
            [vc setSocialResumeEditDelegate:self];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( 2 == typeInt )
        {
            CPSchoolResumeEditController *vc = [[CPSchoolResumeEditController alloc] initWithResumeId:selectedResume.ResumeId deliveryString:positionDetail];
            [vc setSchoolResumeEditDelegate:self];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)positionDetailDeliveryViewTouchFreeArea
{
    [self.deliveryView setHidden:YES];
    self.deliveryView = nil;
}
- (void)showIsHaveResumeTips
{
    if ( [self.viewModel.resumeArrayM count] > 0 )
    {
        [MobClick event:@"deliver_dialog"];
        [self.deliveryView configWithArray:self.viewModel.resumeArrayM];
        [[UIApplication sharedApplication].keyWindow addSubview:self.deliveryView];
    }
    else
    {
        if ( 1 == [self.position.PositionType intValue] )
        {
            if ( 0 < [[MemoryCacheData shareInstance].userLoginData.ResumeCount intValue] )
            {
                if ( [self.viewModel.resumeArrayM count] == 0 && self.viewModel.isSuccessGetAllResume )
                    [self showMessageTips:@"你还没有校园招聘简历，不符合校招职位投递条件，是否创建校园招聘简历？"];
                else
                    [self showMessageTips:@"网络不给力，是否重新加载简历？"];
            }
            else
                [self showMessageTips:@"你还没有校园招聘简历，不符合校招职位投递条件，是否创建校园招聘简历？"];
        }
        else
        {
            if ( 0 < [[MemoryCacheData shareInstance].userLoginData.ResumeCount intValue] && !self.viewModel.isSuccessGetAllResume )
                [self showMessageTips:@"网络不给力，是否重新加载简历？"];
            else
            {
                [self showMessageTips:@"你还没有简历可投递，马上创建简历获得好工作？"];
            }
        }
    }
}
- (void)showMessageTips:(NSString *)tips
{
    self.noResumeTips = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.noResumeTips];
}
-(void)showErrorMessage:(NSString *)tips
{
    CPDeliveryNoResumeTipsView *errorResumeTips = [CPDeliveryNoResumeTipsView tipsViewWithButtonTitles:@[@"确定"] showMessageVC:self message:tips];
//    [_noResumeTips setDeliveryNoResumeTipsViewDelegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:errorResumeTips];
}
#pragma mark - CPDeliveryNoResumeTipsViewDelegate
- (void)deliveryNoResumeTipsView:(CPDeliveryNoResumeTipsView *)deliveryNoResumeTipsView clickedCancleButton:(UIButton *)cancleButon
{
    self.noResumeTips = nil;
    if ( 0 == [[MemoryCacheData shareInstance].userLoginData.ResumeCount intValue] )
    {
        [MobClick event:@"no_resume_cancel_click"];
        [MobClick event:@"social_cancel"];
        if ( 1 == [self.position.PositionType intValue] )
            [MobClick event:@"no_school_resume_cancel_click"];
    }
    else
    {
        if ( 1 == [self.position.PositionType intValue] )
        {
            if ( [self.viewModel.resumeArrayM count] == 0 )
                [MobClick event:@"no_school_resume_cancel_click"];
        }
        else
        {
            [MobClick event:@"social_cancel"];
        }
    }
}
- (void)deliveryNoResumeTipsView:(CPDeliveryNoResumeTipsView *)deliveryNoResumeTipsView clickedSureButton:(UIButton *)sureButon
{
    [MobClick event:@"no_resume_confirm_click"];
    [MobClick event:@"social_sure"];
    self.noResumeTips = nil;
    if ( 0 < [[MemoryCacheData shareInstance].userLoginData.ResumeCount intValue] )
    {
        if ( !self.viewModel.isSuccessGetAllResume )
            [self.viewModel getAllResumeWithPositionType:self.position.PositionType];
        else
        {
            AllResumeVC *vc = [AllResumeVC new];
            [self.navigationController pushViewController:vc animated:YES];
                }
//        [self.viewModel regetAllResumeWithPositionType:self.position.PositionType];
    }
    else
    {
        [MobClick event:@"no_school_resume_confirm_click"];
        AllResumeVC *vc = [AllResumeVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - getter methods
- (void)showNoUserTips:(NSString *)tips
{
    self.noUerTipsView = [self noUserViewWithTips:tips];
    self.noUerTipsView.identifier = 1000;
    [[UIApplication sharedApplication].keyWindow addSubview:self.noUerTipsView];
}
- (void)collectionShowNoUserTips:(NSString *)tips
{
    self.noUerTipsView = [self noUserViewWithTips:tips];
    self.noUerTipsView.identifier = 1001;
    [[UIApplication sharedApplication].keyWindow addSubview:self.noUerTipsView];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.noUerTipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton
{
    self.noUerTipsView = nil;
    LoginVC *vc = [[LoginVC alloc] initWithComeFromString:@"delivery"];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton identifier:(NSInteger)identifier
{
    self.noUerTipsView = nil;
    if ( identifier == 1000 )
    {
        LoginVC *vc = [[LoginVC alloc] initWithComeFromString:@"delivery"];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    else if ( identifier == 1001 )
    {
        LoginVC *vc = [[LoginVC alloc] initWithComeFromString:@"collection"];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark - CPSchoolResumeEditControllerDelegate
- (void)schoolResumeEdit:(CPSchoolResumeEditController *)schoolResumeEdit deliveryResume:(ResumeNameModel *)deliveryResume
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewModel resumeDeliveryWithResumeID:deliveryResume.ResumeId];
    });
}
#pragma mark - ResumeNameVCDelegate
- (void)socialResumeEdit:(ResumeNameVC *)socialResumeEdit deliveryResume:(ResumeNameModel *)deliveryResume
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewModel resumeDeliveryWithResumeID:deliveryResume.ResumeId];
    });
}
- (void)showTipsView
{
    if ( !self.maxSelecetdTipsView.isHidden )
        return;
    [self.maxSelecetdTipsView setHidden:NO];
    [self.maxSelecetdTipsView setAlpha:1.0];
    __weak typeof( self ) weakSelf = self;
    [UIView animateWithDuration:2.5 animations:^{
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
#pragma mark getter methods
- (CPTipsView *)noUserViewWithTips:(NSString *)tips
{
    if ( !_noUerTipsView )
    {
        _noUerTipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"暂不登录", @"去登录"] showMessageRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight) message:tips];
        _noUerTipsView.tipsViewDelegate = self;
    }
    return _noUerTipsView;
}
- (UIView *)bottomBackgroundView
{
    if ( !_bottomBackgroundView )
    {
        _bottomBackgroundView = [[UIView alloc] init];
        [_bottomBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_bottomBackgroundView addSubview:self.deliverButton];
        [_bottomBackgroundView addSubview:self.collectionButton];
        [self.collectionButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( ![self isNetworkValid] )
            {
                [self showTipsView];
                return;
            }
            if ( ![MemoryCacheData shareInstance].userLoginData.UserId || 0 == [MemoryCacheData shareInstance].userLoginData.UserId )
            {
                [self collectionShowNoUserTips:@"您还没登录,登录才能使用此功能!"];
            }
            else
            {
                if ([self.collectionButton isSelected])
                {
                    [self.collectionButton setSelected:NO];
                    [self.viewModel deleteJob];
                }
                else
                {
                    [self.collectionButton setSelected:YES];
                    [self.viewModel collectionJob];
                }
            }
        }];
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _bottomBackgroundView.mas_top );
            make.right.equalTo( _bottomBackgroundView.mas_right );
            make.bottom.equalTo( _bottomBackgroundView.mas_bottom );
            make.width.equalTo( @( 200 / CP_GLOBALSCALE ) );
        }];
        [self.deliverButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _bottomBackgroundView.mas_top );
            make.left.equalTo( _bottomBackgroundView.mas_left );
            make.bottom.equalTo( _bottomBackgroundView.mas_bottom );
            make.right.equalTo( self.collectionButton.mas_left ).offset( -2 / CP_GLOBALSCALE );
        }];
    }
    return _bottomBackgroundView;
}
- (UIButton *)deliverButton
{
    if ( !_deliverButton )
    {
        _deliverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deliverButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"6cbb56"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_deliverButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ea34b"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_deliverButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        [_deliverButton setTitle:@"马上投递" forState:UIControlStateNormal];
        [_deliverButton setTitle:@"已投递" forState:UIControlStateDisabled];
        [_deliverButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_deliverButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_deliverButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( ![self isNetworkValid] )
            {
                [self showTipsView];
                return;
            }
            if ( ![MemoryCacheData shareInstance].userLoginData.UserId || 0 == [MemoryCacheData shareInstance].userLoginData.UserId )
            {
                [self showNoUserTips:@"您还没登录,登录才能使用此功能!"];
            }
            else
                [self showIsHaveResumeTips];
        }];
    }
    return _deliverButton;
}
- (CPPositionDetailButton *)collectionButton
{
    if ( !_collectionButton )
    {
        _collectionButton = [[CPPositionDetailButton alloc] init];
        [_collectionButton setBackgroundColor:[UIColor colorWithHexString:@"288add"]];
        [_collectionButton setImage:[UIImage imageNamed:@"ic_collocation_null"] forState:UIControlStateNormal];
        [_collectionButton setImage:[UIImage imageNamed:@"ic_collocation"] forState:UIControlStateSelected];
    }
    return _collectionButton;
}
- (UIScrollView *)positionDetailBackgroundView
{
    if ( !_positionDetailBackgroundView )
    {
        _positionDetailBackgroundView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_positionDetailBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_positionDetailBackgroundView setContentInset:UIEdgeInsetsMake(0, 0, 150 / CP_GLOBALSCALE, 0)];
        [_positionDetailBackgroundView addSubview:self.detailTopView];
        [_positionDetailBackgroundView addSubview:self.detailRequireView];
        [_positionDetailBackgroundView addSubview:self.detailDescribeView];
    }
    return _positionDetailBackgroundView;
}
- (CPPositionDetailTopView *)detailTopView
{
    if ( !_detailTopView )
    {
        _detailTopView = [[CPPositionDetailTopView alloc] init];
        [_detailTopView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        _detailTopView.positonDetailDelegate = self;
    }
    return _detailTopView;
}
- (CPPositionDetailRequireView *)detailRequireView
{
    if ( !_detailRequireView )
    {
        _detailRequireView = [[CPPositionDetailRequireView alloc] init];
    }
    return _detailRequireView;
}
- (CPPositionDetailDescribeView *)detailDescribeView
{
    if ( !_detailDescribeView )
    {
        _detailDescribeView = [[CPPositionDetailDescribeView alloc] init];
    }
    return _detailDescribeView;
}
- (UIView *)collectionView
{
    if ( !_collectionView )
    {
        _collectionView = [[UIView alloc] init];
        [_collectionView setBackgroundColor:[UIColor colorWithHexString:@"288add"]];
        [_collectionView addSubview:self.collectionButton];
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _collectionView.mas_top );
            make.left.equalTo( _collectionView.mas_left );
            make.bottom.equalTo( _collectionView.mas_bottom );
            make.right.equalTo( _collectionView.mas_right );
        }];
    }
    return _collectionView;
}
- (UmengView *)umengView
{
    if ( !_umengView )
    {
        _umengView = [[UmengView alloc] init];
        [_umengView setDelegate:self];
    }
    return _umengView;
}
- (CPPositionDetaildelivery *)deliveryView
{
    if ( !_deliveryView )
    {
        [MobClick event:@"choose_resume_launch"];
        _deliveryView = [[CPPositionDetaildelivery alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_deliveryView setPositionDetailDeliveryViewDelegate:self];
    }
    return _deliveryView;
}
- (CPDeliveryNoResumeTipsView *)messageTipsViewWithTips:(NSString *)tips
{
    if ( !_noResumeTips )
    {
        _noResumeTips = [CPDeliveryNoResumeTipsView tipsViewWithButtonTitles:@[@"取消", @"确定"] showMessageVC:self message:tips];
        [_noResumeTips setDeliveryNoResumeTipsViewDelegate:self];
    }
    return _noResumeTips;
}
- (UIView *)noNetworkView
{
    if ( !_noNetworkView )
    {
        _noNetworkView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_noNetworkView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        UIImageView *errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"null_exam_linkbroken"]];
        [_noNetworkView addSubview:errorImageView];
        [errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _noNetworkView.mas_centerX );
            make.top.equalTo( _noNetworkView.mas_top ).offset( 366 / CP_GLOBALSCALE );
            make.width.equalTo( @( 280 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 280 / CP_GLOBALSCALE ) );
        }];
        UILabel *tipsLabel = [[UILabel alloc] init];
        [_noNetworkView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _noNetworkView.mas_centerX );
            make.top.equalTo( errorImageView.mas_bottom ).offset( 90 / CP_GLOBALSCALE );
            make.left.equalTo( _noNetworkView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _noNetworkView.mas_right ).offset( -40 / CP_GLOBALSCALE);
        }];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.text = @"当前网络不可用，请检查网络设置";
        tipsLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE] ;
        tipsLabel.textColor = [UIColor colorWithHexString:@"404040"];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [tipsLabel setNumberOfLines:0];
        UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [reloadButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        [reloadButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
        [reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateSelected];
        [reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [reloadButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [reloadButton.layer setMasksToBounds:YES];
        [reloadButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_noNetworkView addSubview:reloadButton];
        [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _noNetworkView.mas_centerX );
            make.top.equalTo( tipsLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.width.equalTo( @( 330 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        [reloadButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( ![self isNetworkValid] )
            {
                [self showTipsView];
                return;
            }
            [self.viewModel getPositionDetail];
            [self.viewModel getAllResumeWithPositionType:self.position.PositionType];
        }];
        [_noNetworkView setHidden:YES];
    }
    return _noNetworkView;
}
- (UIView *)maxSelecetdTipsView
{
    if ( !_maxSelecetdTipsView )
    {
        NSString *tipsString = @"您的网络不可用，请检查网络连接";
        CGSize tipsStringSize = [tipsString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE]} context:nil].size;
        CGFloat W = tipsStringSize.width + 80 / CP_GLOBALSCALE;
        CGFloat H = 42 / CP_GLOBALSCALE + 80 / CP_GLOBALSCALE;
        CGFloat X = ( kScreenWidth - W ) / 2.0;
        CGFloat Y = kScreenHeight - 144 / CP_GLOBALSCALE * 3 - H;
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
@end
#pragma mark - CPWPositionShareButton
@implementation CPWPositionShareButton
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
