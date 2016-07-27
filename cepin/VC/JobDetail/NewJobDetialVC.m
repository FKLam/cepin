//
//  NewJobDetialVC.m
//  cepin
//
//  Created by dujincai on 15/5/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "NewJobDetialVC.h"
#import "RTTabView.h"
#import "TKRoundedView.h"
#import "JobDetailVC.h"
#import "CompanyDetailNewVC.h"
#import "UmengView.h"
#import "UIViewController+NavicationUI.h"
#import "TBUmengShareConfig.h"
#import "NewJobDetialVM.h"
#import "LoginVC.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "LoginAlterView.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"

@interface NewJobDetialVC ()<UmengViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)NewJobDetialVM *viewModel;
@property(nonatomic,strong)RTTabView *tabView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic,strong) NSArray *viewControllers;
@property(nonatomic,retain)UIButton  *collectionButton;
@property(nonatomic,retain)UIButton  *shareButton;
@property(nonatomic,retain)UmengView *umengView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSString *jobId;
@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong)JobDetailModelDTO *jobModel;
@property(nonatomic,strong)NSNumber *resumeType;
@property(nonatomic,strong)LoginAlterView *loginView;
@end

@implementation NewJobDetialVC

-(instancetype)initWithJobId:(NSString *)jobId companyId:(NSString *)comanyId pstType:(NSNumber *)pstType
{
    self = [super init];
    if (self) {
        self.jobId = jobId;
        self.companyId = comanyId;
        if (pstType.intValue==1) {
            self.resumeType = [NSNumber numberWithInt:2];
        }else{
            self.resumeType = [NSNumber numberWithInt:1];
        }
        self.viewModel = [[NewJobDetialVM alloc] initWithJobId:jobId companyId:comanyId];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.index = 0;
    
    // 去掉导航栏下方的横线
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[RTAPPUIHelper shareInstance] labelColorGreen] cornerRadius:0] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resetCollection];
    self.loginView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    self.view.backgroundColor = [UIColor clearColor];
    self.umengView = [UmengView new];
    self.umengView.delegate = self;
    
    [self.viewModel getPositionDetail];
    
    [self.viewModel getCompanyDetail];
    
   
//    self.loginView.hidden = YES;
    
    int hight = IS_IPHONE_5?21:25;
    @weakify(self)
    self.collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, hight, hight)];

    [[self.collectionButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id stateCode) {
        @strongify(self)
        
        if (![MemoryCacheData shareInstance].isLogin)
        {
           
            self.loginView = [[LoginAlterView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight)];
            TBAppDelegate *app = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:self.loginView];
            self.loginView.hidden = NO;
            [self.loginView ShowLogin];

            return;
        }
        if (self.index == 0) {
            if (self.viewModel.data.IsCollection.intValue == 1)
            {
                [self.viewModel deleteJob];
            }
            else
            {
                [MobClick event:@"job_details_collection"];
                [self.viewModel collectionJob];
            }
        }else{
            if (self.viewModel.companyData.IsCollection.intValue == 1) {
                [self.viewModel deleteCompany];
            }
            else
            {
                [MobClick event:@"company_detail_collect"];
                [self.viewModel saveCompany];
            }
        }
    }];
    
    self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, hight, hight)];
    [self.shareButton setImage:[UIImage imageNamed:@"ic_share_white"] forState:UIControlStateNormal];
    [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self)
        
        [self.umengView show];
    }];
    
    [self addNavicationCollectionObjectWithImage:self.shareButton share:self.collectionButton];
    
    
    self.tabView = [[RTTabView alloc]initWithFrame:CGRectMake(0, 64.0, self.view.viewWidth, 48)];
    self.tabView.titles = @[@"职位详情",@"企业详情"];
    self.tabView.textColor = [[RTAPPUIHelper shareInstance] whiteColor];
    self.tabView.textHightedColor = [[RTAPPUIHelper shareInstance] whiteColor];
    self.tabView.font = [[RTAPPUIHelper shareInstance] jobInformationTitleFont];
    self.tabView.collectionView.backgroundColor = [[RTAPPUIHelper shareInstance] labelColorGreen];
    self.tabView.imageBackground = TKRoundedCornerImage(CGSizeMake(self.view.viewWidth / 3, 48), TKRoundedCornerNone, TKDrawnBorderSidesNone, [[RTAPPUIHelper shareInstance] labelColorGreen], [[RTAPPUIHelper shareInstance] lineColor], 0.5, 1);
    
    self.tabView.imageHightedBackground = TKRoundedCornerImage(CGSizeMake(self.view.viewWidth / 3, 48 - 20), TKRoundedCornerNone, TKDrawnBorderSidesBottom, [[RTAPPUIHelper shareInstance] labelColorGreen], [[RTAPPUIHelper shareInstance] lineColor], 2, 1);
    [self.view addSubview:self.tabView];
    [self.tabView selectedWithIndex:self.index];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY( self.tabView.frame ), kScreenWidth, self.view.viewHeight - CGRectGetMaxY( self.tabView.frame ) - 64.0)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*2, self.scrollView.frame.size.height);
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    JobDetailVC *job = [[JobDetailVC alloc]initWithJobId:self.jobId resumeType:self.resumeType];
    job.view.frame = CGRectMake(0, 0, self.scrollView.viewWidth, self.scrollView.viewHeight);
    [self.scrollView addSubview:job.view];
    [self addChildViewController:job];
    
    CompanyDetailNewVC *company = [[CompanyDetailNewVC alloc] initWithCompanyId:self.companyId];
    company.view.frame = CGRectMake(self.scrollView.viewWidth, 0, self.scrollView.viewWidth, self.scrollView.viewHeight);
    [self.scrollView addSubview:company.view];
    [self addChildViewController:company];
    
    self.viewControllers = @[job,company];
    

    self.tabView.selectedObject = ^void(NSInteger index){
        @strongify(self)
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth*index,0) animated:YES];
        self.index = index;
 
    };
    
    [RACObserve(self, index) subscribeNext:^(id x) {
        NSString * indexStr = [NSString stringWithFormat:@"%@",x];
        if ([indexStr isEqualToString:@"1"]) {
            [self resetCompanyCollection];
        }
        else{
            [self resetCollection];
        }
    }];
    
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.jobModel = self.viewModel.data;
        
            [self resetCollection];
        }
    }];
    
    [RACObserve(self.viewModel, deleteJobStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.viewModel.data.IsCollection = [NSNumber numberWithInt:0];
            [self resetCollection];
        }

    }];
    
    [RACObserve(self.viewModel, collectionJobStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.jobModel = self.viewModel.data;
            self.jobModel.IsCollection = [NSNumber numberWithInt:1];
            [self resetCollection];
        }
    }];
    
    
    
    [RACObserve(self.viewModel, deleteCompanyStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.viewModel.companyData.IsCollection = [NSNumber numberWithInt:0];
            [self resetCompanyCollection];
        }
   
    }];
    [RACObserve(self.viewModel, saveCompanyStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.viewModel.companyData.IsCollection = [NSNumber numberWithInt:1];
            [self resetCompanyCollection];
        }
    }];
    
}


-(void)resetCollection
{
    if (self.jobModel.IsCollection.intValue == 1)
    {
        [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"tb_position_collected_new"] forState:UIControlStateNormal];
    }
    else
    {
        [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"tb_position_uncollect_new"] forState:UIControlStateNormal];
    }
}
-(void)resetCompanyCollection
{
    if (self.viewModel.companyData.IsCollection.intValue == 1)
    {
        [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"tb_position_collected_new"] forState:UIControlStateNormal];
    }
    else
    {
        [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"tb_position_uncollect_new"] forState:UIControlStateNormal];
    }
}


//滑动scrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.tabView selectedWithIndex:page];
    self.index = page;
    
    if ( page == 0 )
    {
        [MobClick event:@"company_detail_to_job_detail"];
    }
    else
    {
        [MobClick event:@"job_detail_to_company_detail"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didChooseUmengView:(int)tag
{
    [self.umengView disMiss];
    
    
    NSMutableArray  *title = [[NSMutableArray alloc]init];
    
    
    if([WXApi isWXAppInstalled]){
        [title addObject:@"微信好友"];
        [title addObject:@"朋友圈"];
    }
    if([QQApiInterface isQQInstalled]){
        [title addObject:@"QQ"];
        [title addObject:@"QQ空间"];
    }
    
    NSArray *titlesArray = @[@"新浪微博",@"短信",@"邮箱"];
    [title addObjectsFromArray:titlesArray];
    NSString *platformName = nil;
    
    if([title count]==3){
        switch (tag)
        {
            case 0:platformName = @"sina";
                break;
            case 1: platformName = @"sms";
                break;
            case 2: platformName = @"email";
                break;
            default:
                break;
        }
        
    }else if(title.count==5){
        if([WXApi isWXAppInstalled]){
            [title addObject:@"微信好友"];
            [title addObject:@"朋友圈"];
            switch (tag)
            {
                case 0:platformName = @"wxsession";
                    break;
                case 1:platformName = @"wxfriend";
                    break;
                case 2: platformName = @"sina";
                    break;
                case 3: platformName = @"sms";
                    break;
                case 4:platformName = @"email";
                    break;
                default:
                    break;
            }
        }else{
            switch (tag)
            {
                case 0:platformName = @"qq";
                    break;
                case 1:platformName = @"qzone";
                    break;
                case 2: platformName = @"sina";
                    break;
                case 3: platformName = @"sms";
                    break;
                case 4:platformName = @"email";
                    break;
                default:
                    break;
            }
        }
        
    }else{
        switch (tag)
        {
            case 0:platformName = @"wxsession";
                break;
            case 1:platformName = @"wxfriend";
                break;
            case 2: platformName = @"qq";
                break;
            case 3: platformName = @"qzone";
                break;
            case 4:platformName = @"sina";
                break;
            case 5:platformName = @"sms";
                break;
            case 6:platformName = @"email";
                break;
            default:
                break;
        }
    }
    

    if (self.index == 0) {
        
        [MobClick event:@"job_details_share"];
        
        NSMutableString *shareBody = [[NSMutableString alloc] init];
        if (![self.viewModel.data.Salary isKindOfClass:[NSNull class]])
        {
            [shareBody appendFormat:@"薪水:%@",self.viewModel.data.Salary];
        }
        if (![self.viewModel.data.City isKindOfClass:[NSNull class]])
        {
            [shareBody appendFormat:@"城市:%@",self.viewModel.data.City];
        }
        if (![self.viewModel.data.CompanyName isKindOfClass:[NSNull class]])
        {
            [shareBody appendFormat:@"公司名称:%@",self.viewModel.data.CompanyName];
        }
        
        NSString *url = [NSString stringWithFormat:@"%@/JobSearch/PositionDetail?positionId=%@",kHostShareUrl,self.viewModel.data.PositionId];
        
        if ([platformName isEqualToString:@"sina"]) {
            NSString *contentText = [NSString stringWithFormat:@"%@,%@",shareBody,url];
            [[UMSocialControllerService defaultControllerService] setShareText:contentText shareImage:[UIImage imageNamed:@"cepin_icon_share"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }else{
        
        
        [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:self.viewModel.data.PositionName content:shareBody url:url imageUrl:self.logo completion:^(UMSocialResponseEntity *response) {
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
    }else
    {
        
        [MobClick event:@"company_detail_share"];
        
        NSString *strTitle = [NSString stringWithFormat:@"%@ %@",self.viewModel.data.CompanyName,@"招聘"];
        
        NSString *url = [NSString stringWithFormat:@"%@/Customer/CompanyInfo?customerId=%@",kHostShareUrl,self.viewModel.data.CustomerId];
        
        if ([platformName isEqualToString:@"sina"]) {
            NSString *contentText = [NSString stringWithFormat:@"%@,%@",strTitle,url];
            [[UMSocialControllerService defaultControllerService] setShareText:contentText shareImage:[UIImage imageNamed:@"cepin_icon_share"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
        else{
            
            // 处理分享本公司信息出错的问题
            NSString *logoStr = self.viewModel.companyData.Logo;
            if ( [strTitle rangeOfString:@"广东倍智人才网络科技有限公司"].length > 0 )
                logoStr = nil;
            
        [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:strTitle content:self.viewModel.companyData.Introduction url:url imageUrl:logoStr completion:^(UMSocialResponseEntity *response) {
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
 
}

@end
