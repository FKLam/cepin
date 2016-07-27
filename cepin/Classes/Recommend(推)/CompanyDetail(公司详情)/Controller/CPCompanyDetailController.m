//
//  CPCompanyDetailController.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyDetailController.h"
#import "CPCompanyDetailDescribeView.h"
#import "CPCompanyInformationView.h"
#import "CPCompanyDetailWelfareView.h"
#import "CPCompanyDetailIntroduceView.h"
#import "CPCompanyDetailEnviromentView.h"
#import "CPCompanyDetailPositionView.h"
#import "CPCompanyEnviromentController.h"
#import "RTNetworking+Company.h"
#import "NSDictionary+NetworkBean.h"
#import "CPCompanyDetailReformer.h"
#import "CPCompanyDetailPositionCell.h"
#import "CPCompanyDetailCollectButton.h"
#import "CPHomePositionDetailController.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "TBUmengShareConfig.h"
#import "UmengView.h"
#import "NewJobDetialVM.h"
#import "CPTipsView.h"
#import "LoginVC.h"
#import "MJRefresh.h"
#import "CPWCompanyDetailVM.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"
@interface CPCompanyDetailController ()<CPCompanyDetailEnviromentViewDelegate, UmengViewDelegate, UMSocialUIDelegate, CPTipsViewDelegate>
@property (nonatomic, strong) UIScrollView *detailBackgroundView;
@property (nonatomic, strong) CPCompanyDetailCollectButton *collectionButton;
@property (nonatomic, strong) CPCompanyDetailDescribeView *detailDescribeView;
@property (nonatomic, strong) CPCompanyInformationView *detailInformationView;
@property (nonatomic, strong) CPCompanyDetailWelfareView *detailWelfareView;
@property (nonatomic, strong) CPCompanyDetailIntroduceView *detailIntroduceView;
@property (nonatomic, strong) CPCompanyDetailEnviromentView *detailEnviromentView;
@property (nonatomic, strong) CPCompanyDetailPositionView *detailPositionView;
@property (nonatomic, strong) JobSearchModel *position;
@property (nonatomic, strong) NSDictionary *companyDetailDict;
@property (nonatomic, strong) UITableView *positionTableView;
@property (nonatomic, strong) NSMutableArray *positonArrayM;
@property (nonatomic, strong) NSMutableArray *visiablePositionArrayM;
@property(nonatomic,retain)UmengView *umengView;
@property(nonatomic,strong)NSMutableArray *imags;
@property (nonatomic, strong) CPWCompanyDetailVM *viewModel;
@property (nonatomic, strong) CPTipsView *noUerTipsView;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSIndexPath *custemSelecetdIndexPath;
@property (nonatomic, strong) UIView *noNetworkView;
@property (nonatomic, strong) UIView *maxSelecetdTipsView;
@property (nonatomic,strong)NSString *companyId;//企业id
@property (nonatomic,assign)BOOL isLoadMore;//是否加载更多了

@end
@implementation CPCompanyDetailController
#pragma mark - lift cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        [self setTitle:@"企业详情"];
        [self.view setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        self.imags = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    // 导航栏右边分享按钮 ic_share
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setBackgroundColor:[UIColor clearColor]];
    [shareBtn setTitle:@"分享微门户" forState:UIControlStateNormal];
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
    shareBtn.viewSize = CGSizeMake(42 / CP_GLOBALSCALE * 5, 42 / CP_GLOBALSCALE);
    [shareBtn addTarget:self action:@selector(clickedShareButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [self.viewModel allPositionId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( self.custemSelecetdIndexPath )
            {
                NSArray *indexPathArray = [NSArray arrayWithObject:self.custemSelecetdIndexPath];
                [self.positionTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                self.custemSelecetdIndexPath = nil;
            }
        });
    });
    
    if (self.companyId) {
         [self loadCompany];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"into_companydetail"];
    CGFloat describeHeight = ( 60 + 100 * 2 + 60 ) / CP_GLOBALSCALE;
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, 1, 1);
    [self.view addSubview:self.detailBackgroundView];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ( [self.visiablePositionArrayM count] < [self.positonArrayM count] )
        {
            [self loadMorePosition];
            [self reSetSubViewFrame];
            [self.positionTableView reloadData];
            if ( [self.visiablePositionArrayM count] == [self.positonArrayM count] )
            {
                [self.detailBackgroundView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.detailBackgroundView.mj_footer endRefreshing];
            }
        }
        else if ( [self.visiablePositionArrayM count] == [self.positonArrayM count] )
        {
            [self.detailBackgroundView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
    self.detailBackgroundView.mj_footer = footer;
    [self.view addSubview:self.collectionButton];
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo( @( 150 / CP_GLOBALSCALE ) );
        make.left.equalTo( self.view.mas_left );
        make.bottom.equalTo( self.view.mas_bottom );
        make.right.equalTo( self.view.mas_right );
    }];
    self.detailDescribeView.frame = CGRectMake(0, 0, self.view.viewWidth, describeHeight);
    self.detailInformationView.frame = CGRectMake(0, CGRectGetMaxY(self.detailDescribeView.frame) + 30 / CP_GLOBALSCALE, self.view.viewWidth, 200);
    self.detailWelfareView.frame = CGRectMake(0, CGRectGetMaxY(self.detailInformationView.frame) + 30 / CP_GLOBALSCALE, self.view.viewWidth, 150);
    self.detailIntroduceView.frame = CGRectMake(0, CGRectGetMaxY(self.detailWelfareView.frame) + 30 / CP_GLOBALSCALE, self.view.viewWidth, 150);
    self.detailEnviromentView.frame = CGRectMake(0, CGRectGetMaxY(self.detailIntroduceView.frame) + 30 / CP_GLOBALSCALE, self.view.viewWidth, 144 / CP_GLOBALSCALE);
    self.detailPositionView.frame = CGRectMake(0, CGRectGetMaxY(self.detailEnviromentView.frame) + 30 / CP_GLOBALSCALE, self.view.viewWidth, 200);
    [self.detailBackgroundView setContentSize:CGSizeMake(self.view.viewWidth, 0)];
    [self.detailIntroduceView.lookMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPWCompanyDetailButton *sender) {
        [sender setSelected:!sender.isSelected];
        self.isLoadMore =sender.isSelected;
        [self.detailIntroduceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.detailWelfareView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.left.equalTo( self.detailBackgroundView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( [CPCompanyDetailReformer companyIntroduceHeightWithCampanyData:self.companyDetailDict isSelected:sender.isSelected] ) );
        }];
        CGFloat describeHeight = [CPCompanyDetailReformer companyDescriptViewHeightWithText:self.companyDetailDict];
        CGFloat enviromentHeight = 144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE;
        CGFloat contentHeith = describeHeight + [CPCompanyDetailReformer companyInforHeightWithCompanyData:self.companyDetailDict] + [CPCompanyDetailReformer companyWelfareHeightWithCompanyData:self.companyDetailDict] + [CPCompanyDetailReformer companyIntroduceHeightWithCampanyData:self.companyDetailDict isSelected:sender.isSelected] + enviromentHeight + [CPCompanyDetailReformer companyPositionHeightWithCampanyData:self.companyDetailDict offset:self.offset] + 30 / CP_GLOBALSCALE * 5;
        [self.detailBackgroundView setContentSize:CGSizeMake(kScreenWidth, contentHeith - 40 / CP_GLOBALSCALE)];
    }];
    [self.view addSubview:self.noNetworkView];
    [self.view addSubview:self.maxSelecetdTipsView];
}
-(void)loadCompany
{
    self.detailBackgroundView.hidden = YES;
    self.viewModel = [[CPWCompanyDetailVM alloc] initWithJobId:_position.PositionId companyId:self.companyId];
    [self.viewModel getCompanyDetail];
    @weakify(self)
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        if ( !stateCode ){
            return;
        }
        
        if ( self.viewModel.companyDict )
        {
            self.companyDetailDict = self.viewModel.companyDict;
            [self.detailDescribeView configWithDict:self.companyDetailDict];
            [self.detailInformationView configWithDict:self.companyDetailDict];
            [self.detailIntroduceView configWithDict:self.companyDetailDict];
            NSArray *positionArray = [CPCompanyDetailReformer positionWithCompanyData:self.companyDetailDict toClass:[JobSearchModel class]];
            [self.positonArrayM addObjectsFromArray:positionArray];
            [self loadMorePosition];
            if ( positionArray )
                [self.positionTableView reloadData];
            NSArray *welfareArray = [CPCompanyDetailReformer welfareWithCompanyData:self.companyDetailDict];
            if ( 0 < [welfareArray count] )
                [self.detailWelfareView configWithArray:welfareArray];
            NSNumber *isCollection = [self.companyDetailDict valueForKey:@"IsCollection"];
            if (isCollection.intValue==1) {
                [self.collectionButton setSelected:YES];
            }
            // PicDescription ,PicId,PicPath;
            NSArray *imgArray = [self.companyDetailDict valueForKey:@"AppEnvironmentList"];
            if (imgArray) {
                int i = 0;
                NSInteger size = [imgArray count];
                for (;i<size;i++){
                    NSDictionary *imgdic  = imgArray[i];
                    [self.imags addObject:[imgdic valueForKey:@"PicPath"]];
                    
                }
            }
            if ([self.imags count]>0) {
                [self.detailEnviromentView setHidden:NO];
            }else{
                [self.detailEnviromentView setHidden:YES];
            }
            [self reSetSubViewFrame];
            [self.noNetworkView setHidden:YES];
            self.detailBackgroundView.hidden = NO;
        }
        else
        {
            [self.noNetworkView setHidden:NO];
        }
    }];
}
- (void)configWithPosition:(JobSearchModel *)position
{
    _position = position;
    self.companyId = _position.CustomerId;
}
- (void)configWithPositionWithCompanyId:(NSString *)companyId
{
    self.companyId = companyId;

}
- (void)reSetSubViewFrame
{
   if(self.offset<=10)
   {
        [self.detailDescribeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.detailBackgroundView.mas_top );
            make.left.equalTo( self.detailBackgroundView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( [CPCompanyDetailReformer companyDescriptViewHeightWithText:self.companyDetailDict] ) );
        }];
        [self.detailInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.detailDescribeView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.left.equalTo( self.detailBackgroundView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( [CPCompanyDetailReformer companyInforHeightWithCompanyData:self.companyDetailDict] ) );
        }];
        [self.detailWelfareView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.detailInformationView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.left.equalTo( self.detailBackgroundView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( [CPCompanyDetailReformer companyWelfareHeightWithCompanyData:self.companyDetailDict] ) );
        }];
    }
    if(self.isLoadMore)
    {
        [self.detailIntroduceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.detailWelfareView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.left.equalTo( self.detailBackgroundView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( [CPCompanyDetailReformer companyIntroduceHeightWithCampanyData:self.companyDetailDict isSelected:self.isLoadMore] ) );
        }];
    }
    else
    {
        [self.detailIntroduceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.detailWelfareView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.left.equalTo( self.detailBackgroundView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( [CPCompanyDetailReformer companyIntroduceHeightWithCampanyData:self.companyDetailDict] ) );
        }];
    }
    if ([self.imags count]>0)
    {
        [self.detailEnviromentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.detailIntroduceView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.left.equalTo( self.detailBackgroundView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE ) );
        }];
        [self.detailPositionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.detailEnviromentView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.left.equalTo( self.detailBackgroundView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( [CPCompanyDetailReformer companyPositionHeightWithCampanyData:self.companyDetailDict offset:self.offset] - 40 / CP_GLOBALSCALE) );
        }];
    }
    else
    {
        [self.detailPositionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.detailIntroduceView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
            make.left.equalTo( self.detailBackgroundView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( [CPCompanyDetailReformer companyPositionHeightWithCampanyData:self.companyDetailDict offset:self.offset] - 40 / CP_GLOBALSCALE) );
        }];
    }
    CGFloat describeHeight = [CPCompanyDetailReformer companyDescriptViewHeightWithText:self.companyDetailDict];
    CGFloat enviromentHeight = 0;
    if ( [self.imags count] > 0 )
    {
        enviromentHeight = 144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE;
    }
    CGFloat contentHeith = describeHeight + [CPCompanyDetailReformer companyInforHeightWithCompanyData:self.companyDetailDict] + [CPCompanyDetailReformer companyWelfareHeightWithCompanyData:self.companyDetailDict] + [CPCompanyDetailReformer companyIntroduceHeightWithCampanyData:self.companyDetailDict isSelected:self.isLoadMore] + enviromentHeight + [CPCompanyDetailReformer companyPositionHeightWithCampanyData:self.companyDetailDict offset:self.offset] + 30 / CP_GLOBALSCALE * 5;
    [self.detailBackgroundView setContentSize:CGSizeMake(kScreenWidth, contentHeith - 40 / CP_GLOBALSCALE)];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.visiablePositionArrayM count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPCompanyDetailPositionCell *cell = [CPCompanyDetailPositionCell guessCellWithTableView:tableView];
    CPRecommendModelFrame *recommend = self.visiablePositionArrayM[indexPath.row];
    BOOL isRead = NO;
    BOOL isHideSeparatorLine = NO;
    JobSearchModel *model = recommend.recommendModel;
    for (PositionIdModel *positionID in self.viewModel.positionIdArray )
    {
        if ( [model.PositionId isEqualToString:positionID.positionId] )
        {
            isRead = YES;
            break;
        }
    }
    if ( indexPath.row == [self.visiablePositionArrayM count] - 1 )
    {
        isHideSeparatorLine = YES;
    }
    [cell setContentIsRead:isRead];
    [cell configCellWithDatas:recommend];
    [cell setLastCellIsHide:isHideSeparatorLine];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CPRecommendModelFrame *recommendModelFrame = self.visiablePositionArrayM[indexPath.row];
    JobSearchModel *bean = recommendModelFrame.recommendModel;
    CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
    [companyDetailVC configWithPosition:bean];
    [self.navigationController pushViewController:companyDetailVC animated:YES];
    self.custemSelecetdIndexPath = indexPath;
}
#pragma mark - CPCompanyDetailEnviromentViewDelegate
- (void)checkEnviroment
{
    if ([self.imags count]==0) {
        [OMGToast showWithText:@"当前企业未上传企业环境图片"];
        return;
    }
    CPCompanyEnviromentController *enviromentVC = [[CPCompanyEnviromentController alloc] init];
    [enviromentVC configImags:self.imags];
    [self.navigationController pushViewController:enviromentVC animated:YES];
}
#pragma mark - events respond
- (void)clickedShareButton
{
    [MobClick event:@"company_detail_share"];
    [self.umengView show];
}
- (void)loadMorePosition
{
    if ( 10 < [self.positonArrayM count] )
    {
        NSInteger end = ( self.offset + 10 ) > [self.positonArrayM count] ? self.positonArrayM.count : ( self.offset + 10 );
        for ( NSInteger index = self.offset; index < end; index++ )
        {
            [self.visiablePositionArrayM addObject:self.positonArrayM[index]];
            self.offset++;
        }
    }
    else
    {
        [self.visiablePositionArrayM addObjectsFromArray:self.positonArrayM];
        self.offset += [self.visiablePositionArrayM count];
    }
    [self.detailIntroduceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.detailWelfareView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
        make.left.equalTo( self.detailBackgroundView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        make.height.equalTo( @( [CPCompanyDetailReformer companyIntroduceHeightWithCampanyData:self.companyDetailDict isSelected:self.isLoadMore] ) );
    }];
    CGFloat describeHeight = [CPCompanyDetailReformer companyDescriptViewHeightWithText:self.companyDetailDict];
    CGFloat enviromentHeight = 144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE;
    CGFloat contentHeith = describeHeight + [CPCompanyDetailReformer companyInforHeightWithCompanyData:self.companyDetailDict] + [CPCompanyDetailReformer companyWelfareHeightWithCompanyData:self.companyDetailDict] + [CPCompanyDetailReformer companyIntroduceHeightWithCampanyData:self.companyDetailDict isSelected:self.isLoadMore] + enviromentHeight + [CPCompanyDetailReformer companyPositionHeightWithCampanyData:self.companyDetailDict offset:self.offset] + 30 / CP_GLOBALSCALE * 5;
    [self.detailBackgroundView setContentSize:CGSizeMake(kScreenWidth, contentHeith - 40 / CP_GLOBALSCALE)];
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
    NSString *companyName = [self.companyDetailDict valueForKey:@"Shortname"];
    if ( [companyName isKindOfClass:[NSNull class]] )
    {
        companyName = [self.companyDetailDict valueForKey:@"CompanyName"];
    }
    NSArray *applyPositionArray = [self.companyDetailDict valueForKey:@"AppPositionInfoList"];
    NSUInteger count = 0;
    if ( applyPositionArray )
        count = [applyPositionArray count];
    NSString *strTitle = [NSString stringWithFormat:@"%@－%ld个职位热招中－测聘网", companyName, (unsigned long)count];
//    NSString *url = [NSString stringWithFormat:@"%@/Customer/CompanyInfo?customerId=%@", kHostShareUrl, [self.companyDetailDict valueForKey:@"CustomerId"]];
    NSString *url = [NSString stringWithFormat:@"%@/speical/portal/doorindex?customerId=%@", kHostShareUrl, [self.companyDetailDict valueForKey:@"CustomerId"]];
    UIImage *shareImage = [UIImage imageNamed:@"cepin_icon_share"];
    NSString *logoURLString = [self.companyDetailDict valueForKey:@"Logo"];
    if ( ![logoURLString isKindOfClass:[NSNull class]] && 0 < [logoURLString length] )
    {
        shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoURLString]]];
    }
    else
    {
        logoURLString = @"";
    }
    NSString *introductionString = @"";
    if ( ![[self.companyDetailDict valueForKey:@"Introduction"] isKindOfClass:[NSNull class]] )
    {
        introductionString = [self.companyDetailDict valueForKey:@"Introduction"];
    }
    if ([platformName isEqualToString:@"sina"])
    {
        NSString *contentText = [NSString stringWithFormat:@"%@%@", strTitle, url];
        [[UMSocialControllerService defaultControllerService] setShareText:contentText shareImage:shareImage socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    else
    {
        [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:strTitle content:introductionString url:url imageUrl:logoURLString completion:^(UMSocialResponseEntity *response) {
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
#pragma mark - getter methods
- (UIScrollView *)detailBackgroundView
{
    if ( !_detailBackgroundView )
    {
        _detailBackgroundView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_detailBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_detailBackgroundView setContentInset:UIEdgeInsetsMake(64, 0, 150 / CP_GLOBALSCALE, 0)];
        [_detailBackgroundView addSubview:self.detailDescribeView];
        [_detailBackgroundView addSubview:self.detailInformationView];
        [_detailBackgroundView addSubview:self.detailWelfareView];
        [_detailBackgroundView addSubview:self.detailIntroduceView];
        [_detailBackgroundView addSubview:self.detailEnviromentView];
        [_detailBackgroundView addSubview:self.detailPositionView];
        __weak BaseTableViewController *mainvc = self;
       
        self.positionTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [mainvc updateTable];
        }];
    }
    return _detailBackgroundView;
}
- (CPCompanyDetailDescribeView *)detailDescribeView
{
    if ( !_detailDescribeView )
    {
        _detailDescribeView = [[CPCompanyDetailDescribeView alloc] init];
    }
    return _detailDescribeView;
}
- (CPCompanyInformationView *)detailInformationView
{
    if ( !_detailInformationView )
    {
        _detailInformationView = [[CPCompanyInformationView alloc] init];
    }
    return _detailInformationView;
}
- (CPCompanyDetailWelfareView *)detailWelfareView
{
    if ( !_detailWelfareView )
    {
        _detailWelfareView = [[CPCompanyDetailWelfareView alloc] init];
    }
    return _detailWelfareView;
}
- (CPCompanyDetailIntroduceView *)detailIntroduceView
{
    if ( !_detailIntroduceView )
    {
        _detailIntroduceView = [[CPCompanyDetailIntroduceView alloc] init];
    }
    return _detailIntroduceView;
}
- (CPCompanyDetailEnviromentView *)detailEnviromentView
{
    if ( !_detailEnviromentView )
    {
        _detailEnviromentView = [[CPCompanyDetailEnviromentView alloc] init];
        _detailEnviromentView.detailEnviromentDelegate = self;
    }
    return _detailEnviromentView;
}
- (CPCompanyDetailPositionView *)detailPositionView
{
    if ( !_detailPositionView )
    {
        _detailPositionView = [[CPCompanyDetailPositionView alloc] init];
        [_detailPositionView addSubview:self.positionTableView];
        [self.positionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _detailPositionView.mas_top ).offset( 60 / CP_GLOBALSCALE + 42/ CP_GLOBALSCALE);
            make.left.equalTo( _detailPositionView.mas_left );
            make.right.equalTo( _detailPositionView.mas_right );
            make.bottom.equalTo( _detailPositionView.mas_bottom );
        }];
    }
    return _detailPositionView;
}
- (UITableView *)positionTableView
{
    if ( !_positionTableView )
    {
        _positionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _positionTableView.dataSource = self;
        _positionTableView.delegate = self;
        _positionTableView.scrollEnabled = NO;
        [_positionTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_positionTableView setRowHeight:(60 + 48 + 40 + 36 + 60) / CP_GLOBALSCALE];
    }
    return _positionTableView;
}
- (NSMutableArray *)positonArrayM
{
    if ( !_positonArrayM )
    {
        _positonArrayM = [NSMutableArray array];
    }
    return _positonArrayM;
}
- (NSMutableArray *)visiablePositionArrayM
{
    if ( !_visiablePositionArrayM )
    {
        _visiablePositionArrayM = [NSMutableArray array];
    }
    return _visiablePositionArrayM;
}
- (CPCompanyDetailCollectButton *)collectionButton
{
    if ( !_collectionButton )
    {
        _collectionButton = [CPCompanyDetailCollectButton buttonWithType:UIButtonTypeCustom];
        [_collectionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_collectionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"247ec9"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectionButton setTitle:@"收藏" forState:UIControlStateSelected];
        [_collectionButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_collectionButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_collectionButton setImage:[UIImage imageNamed:@"ic_collocation_null"] forState:UIControlStateNormal];
        [_collectionButton setImage:[UIImage imageNamed:@"ic_collocation"] forState:UIControlStateSelected];
        [_collectionButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPCompanyDetailCollectButton *sender) {
            if ( ![self isNetworkValid] )
            {
                [self showTipsView];
                return;
            }
            if ( ![MemoryCacheData shareInstance].userLoginData.UserId || 0 == [MemoryCacheData shareInstance].userLoginData.UserId  )
            {
                [self collectionShowNoUserTips:@"您还没登录,登录才能使用此功能!"];
            }
            else
            {
                sender.selected = !sender.isSelected;
    //            [self respondcollectionButton];
                if ([sender isSelected]) {
                    [self.viewModel saveCompany];
                }else{
                    [self.viewModel deleteCompany];
                }
            }
        }];
    }
    return _collectionButton;
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
#pragma mark - getter methods
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
    LoginVC *vc = [[LoginVC alloc] initWithComeFromString:[NSString stringWithUTF8String:object_getClassName(self)]];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton identifier:(NSInteger)identifier
{
    self.noUerTipsView = nil;
    if ( 1001 == identifier )
    {
        LoginVC *vc = [[LoginVC alloc] initWithComeFromString:@"collection"];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}
- (CPTipsView *)noUserViewWithTips:(NSString *)tips
{
    if ( !_noUerTipsView )
    {
        _noUerTipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"暂不登录", @"去登录"] showMessageRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight) message:tips];
        _noUerTipsView.tipsViewDelegate = self;
    }
    return _noUerTipsView;
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
            [self.viewModel getCompanyDetail];
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