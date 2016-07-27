//
//  DynamicExamVC.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicExamNotHomeVC.h"
#import "DynamicExamVM.h"
#import "DynamicExamCell.h"
#import "DynamicExamModelDTO.h"
#import "DynamicExamDetailVC.h"

#import "UmengView.h"
#import "TBUmengShareConfig.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "LoginAlterView.h"
#import "CPRecommendModelFrame.h"

#import "CPTestEnsureInformationController.h"
#import "CPPositionTestCell.h"
#import "RTNetworking+DynamicState.h"
#import "CPPositionDetailDescribeLabel.h"
#import "LoginVC.h"
typedef NS_ENUM(NSUInteger, CPTestButtonType)
{
    CPTestButtonPositionTest,
    CPTestButtonMiniTest
};
@interface DynamicExamNotHomeVC ()<UmengViewDelegate,UMSocialUIDelegate>
@property(nonatomic,retain)DynamicExamVM *viewModel;
@property(nonatomic,retain)UmengView *umengView;
@property(nonatomic,assign)int       currentIndex;
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,assign)int imageHight;
@property(nonatomic,strong)LoginAlterView *loginView;
@property (nonatomic, strong) UIView *topBackgroundView;
@property (nonatomic, strong) UIButton *positionTestButton;
@property (nonatomic, strong) UIButton *miniTestButton;
@property (nonatomic, strong) UIView *selectedSeparatorLine;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UITableView *miniTestTableView;
@property (nonatomic, strong) UIButton *selectedTestButton;
@property(nonatomic, strong) NSMutableArray *jobCepinArray;//职业测评
@property(nonatomic, strong) NSMutableArray *smallCepinArray;//微测评
@property(nonatomic,assign)NSInteger jobPage;//职业测评当前页面
@property(nonatomic,assign)NSInteger smallPage;//微测评当前页面
@property(nonatomic,assign)UITableView *currentTableView;
@property (nonatomic, strong) UIView *loginTipsView;
@property (nonatomic, strong) NSString *selecetdItemString;
@property (nonatomic, strong) NSString *comeFromeString;
@end
@implementation DynamicExamNotHomeVC
-(instancetype)initWithType:(examType)type
{
    if (self = [super init])
    {
        self.viewModel = [DynamicExamVM new];
        self.type = type;
        self.imageview = [UIImageView new];
        self.jobCepinArray = [NSMutableArray array];
        self.smallCepinArray = [NSMutableArray array];
    }
    return self;
}
- (instancetype)initWithType:(examType)type comeFromString:(NSString *)comeFromString
{
    self = [self initWithType:type];
    if ( self )
    {
        self.comeFromeString = comeFromString;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    //统计测一测
    [MobClick event:@"slide_cepin_list"];
    [super viewWillAppear:animated];
//    self.parentViewController.navigationItem.rightBarButtonItem = nil;
//    self.parentViewController.navigationItem.titleView = nil;
    
    // 设置状态栏颜色
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20.0, kScreenWidth, 20.0)];
    [statusBarView setBackgroundColor:[UIColor colorWithHexString:@"206eb1" alpha:1.0]];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.loginView.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selecetdItemString = self.comeFromeString;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [MobClick event:@"test_list_launch"];
    self.jobPage = 1;
    self.smallPage = 1;
    self.umengView = [UmengView new];
    self.umengView.delegate = self;
    self.title = @"测一测";
    [self.view addSubview:self.topBackgroundView];
    self.topBackgroundView.frame = CGRectMake(0, 64, kScreenWidth, 150 / 3.0);
    [self.view addSubview:self.backgroundScrollView];
    
    if ( self.type == examOne ) {
        //        [self createNoHeadImageTable];
        [self createTableView];
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = YES;
        [self.backgroundScrollView addSubview:self.tableView];
    }
    else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth,self.view.viewHeight - 150 / 3.0 - 64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollsToTop = YES;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        [self.backgroundScrollView addSubview:self.tableView];
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = YES;
    }
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 49 / 2.0, 0)];
    
    [self.backgroundScrollView addSubview:self.miniTestTableView];
    
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth * 2.0, self.view.viewHeight - 150 / 3.0 - 64.0 - 49.0)];
    
    self.loginView = [[LoginAlterView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight)];
    [self.navigationController.view addSubview:self.loginView];
    self.loginView.hidden = YES;
    
    
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTocken = [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser)
    {
        strUser = @"";
        strTocken = @"";
    }
    //职业测评
    RACSignal *jobSignal = [[RTNetworking shareInstance]getDynamicStateExamListWithUUID:UUID_KEY tokenId:strTocken userId:strUser PageIndex:self.jobPage PageSize:10 examStatus:@"1"];
    @weakify(self);
    [jobSignal subscribeNext:^(RACTuple *tuple){
        
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            RTLog(@"%@",array);
            if (array)
            {
                [self.jobCepinArray addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
        
    } error:^(NSError *error){
        RTLog(@"%@",[error description]);
        self.networkImage.hidden = NO;
        self.networkLabel.hidden = NO;
        self.networkButton.hidden = NO;
        self.clickImage.hidden = NO;
        self.tableView.hidden = YES;
    }];
    
    //微测评
    RACSignal *smallJobSignal = [[RTNetworking shareInstance]getDynamicStateExamListWithUUID:UUID_KEY tokenId:strTocken userId:strUser PageIndex:self.smallPage PageSize:10 examStatus:@"2"];
    [smallJobSignal subscribeNext:^(RACTuple *tuple){
        
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            RTLog(@"%@",array);
            if (array)
            {
                [self.smallCepinArray addObjectsFromArray:array];
                [self.miniTestTableView reloadData];
            }
        }
        
    } error:^(NSError *error){
        RTLog(@"%@",[error description]);
        self.networkImage.hidden = NO;
        self.networkLabel.hidden = NO;
        self.networkButton.hidden = NO;
        self.clickImage.hidden = NO;
        self.tableView.hidden = YES;
    }];
    
    //    [self reloadData];
    //    [self setupRefleshScrollView];
    //    [self setupDropDownScrollView];
    
    [self changeTest:self.positionTestButton];
}
#pragma mark - events respond
- (void)changeTest:(UIButton *)sender
{
    if ( self.selectedTestButton == sender )
        return;
    
    if ( self.selectedTestButton )
        self.selectedTestButton.selected = !self.selectedTestButton.selected;
    
    sender.selected = YES;
    
    self.selectedTestButton = sender;
    
    __weak typeof(self) weakSelf = self;
    if ( CPTestButtonPositionTest == sender.tag )
    {
        [UIView animateWithDuration:0.15 animations:^{
            weakSelf.selectedSeparatorLine.viewX = 0;
            [weakSelf.backgroundScrollView scrollRectToVisible:CGRectMake(weakSelf.backgroundScrollView.viewX, weakSelf.backgroundScrollView.viewY, kScreenWidth, weakSelf.backgroundScrollView.viewHeight) animated:YES];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.15 animations:^{
            weakSelf.selectedSeparatorLine.viewX = kScreenWidth / 2.0;
            [weakSelf.backgroundScrollView scrollRectToVisible:CGRectMake(weakSelf.backgroundScrollView.viewX + kScreenWidth, weakSelf.backgroundScrollView.viewY, kScreenWidth, weakSelf.backgroundScrollView.viewHeight) animated:YES];
        }];
    }
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self reloadData];
}
-(void)reloadData
{
    //    [self refleshTable];
}
-(void)refleshTable
{
    [self.viewModel reflashPage];
}
-(void)updateTable
{
    [self.viewModel nextPage];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = ( 120 + 40 + 500 + 60 + 42 + 60 + 36 * 2 + 20 * 2 + 60 + 6 ) / 3.0;
    return rowHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.currentTableView = tableView;
    if (tableView == self.miniTestTableView) {
        return self.smallCepinArray.count;
    }else{
        return self.jobCepinArray.count;
    }
    return self.jobCepinArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微测评
    if ( tableView == self.miniTestTableView )
    {
        //        CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
        
        DynamicExamModelDTO *model;
        model = [DynamicExamModelDTO beanFromDictionary:self.smallCepinArray[indexPath.row]];
        
        //        if( [recommendModelFrame.recommendModel isKindOfClass:[DynamicExamModelDTO class]] )
        //            model = (DynamicExamModelDTO *)recommendModelFrame.recommendModel;
        
        CPPositionTestCell *cell = [CPPositionTestCell positionTestCellWithTableView:tableView];
        
        [cell configCellWithPostionTestModel:model];
        
        return cell;
    }
    else
    {
        //        CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
        
        DynamicExamModelDTO *model;
        model = [DynamicExamModelDTO beanFromDictionary:self.jobCepinArray[indexPath.row]];
        
        //
        //        if( [recommendModelFrame.recommendModel isKindOfClass:[DynamicExamModelDTO class]] )
        //            model = (DynamicExamModelDTO *)recommendModelFrame.recommendModel;
        
        CPPositionTestCell *cell = [CPPositionTestCell positionTestCellWithTableView:tableView];
        
        [cell configCellWithPostionTestModel:model];
        
        return cell;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( scrollView != self.backgroundScrollView )
        return;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if ( 0 == offsetX )
    {
        [self changeTest:self.positionTestButton];
    }
    else if ( kScreenWidth == offsetX )
    {
        [self changeTest:self.miniTestButton];
    }
}
-(void)didChooseUmengView:(int)tag
{
    [self.umengView disMiss];
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
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[self.currentIndex];
    DynamicExamModelDTO *bean;
    if( [recommendModelFrame.recommendModel isKindOfClass:[DynamicExamModelDTO class]] )
        bean = (DynamicExamModelDTO *)recommendModelFrame.recommendModel;
    NSString *strTitle = bean.Title;
    NSString *url = bean.ExamUrl;
    NSString *logo = bean.ImgFilePath;
    NSString *content = bean.Introduction;
    if ([platformName isEqualToString:@"sina"])
    {
        NSString *contentText = [NSString stringWithFormat:@"%@\n%@",strTitle,url];
        [[UMSocialControllerService defaultControllerService] setShareText:contentText shareImage:[UIImage imageNamed:@"cepin_icon_share"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    else
    {
        
        [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:strTitle content:content url:url imageUrl:logo completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess)
            {
#pragma mark - 屏蔽自定义提示框
                //            [OMGToast showWithText:@"分享成功" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                [OMGToast showWithText:@"分享失败" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicExamModelDTO *bean;
    if(tableView==self.miniTestTableView)
    {
        bean = [DynamicExamModelDTO beanFromDictionary:self.smallCepinArray[indexPath.row]];
        DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:bean.ExamUrl examDetail:examDetailOther noTarget:YES];
        vc.title = bean.Title;
        vc.strTitle = bean.Title;
        vc.urlPath = bean.ExamUrl;
        vc.urlLogo = bean.ImgFilePath;
        vc.contentText = bean.Introduction;
        vc.isJiSuCepin = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        bean = [DynamicExamModelDTO beanFromDictionary:self.jobCepinArray[indexPath.row]];
        if ( indexPath.row == 0 ) {
            if (![MemoryCacheData shareInstance].isLogin)
            {
                [self showLoginTips];
                return;
            }
            DynamicExamDetailVC *vc  = nil;
            if (bean.Status.intValue == 1) {
                vc = [[DynamicExamDetailVC alloc]initWithUrl:bean.ReportUrl examDetail:examDetailOther];
            }else
            {
                vc = [[DynamicExamDetailVC alloc] initWithUrl:bean.ExamUrl examDetail:examDetailOther];
            }
            vc.title = bean.Title;
            vc.strTitle = bean.Title;
            vc.urlPath = bean.ExamUrl;
            vc.urlLogo = bean.ImgFilePath;
            vc.contentText = bean.Introduction;
            vc.isJiSuCepin = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc] initWithUrl:bean.ExamUrl examDetail:examDetailOther noTarget:YES];
            vc.title = bean.Title;
            vc.strTitle = bean.Title;
            vc.urlPath = bean.ExamUrl;
            vc.urlLogo = bean.ImgFilePath;
            vc.contentText = bean.Introduction;
            vc.isJiSuCepin = NO;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter methods
- (UIView *)topBackgroundView
{
    if ( !_topBackgroundView )
    {
        _topBackgroundView = [[UIView alloc] init];
        [_topBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [_topBackgroundView addSubview:self.positionTestButton];
        [_topBackgroundView addSubview:self.miniTestButton];
        
        [self.positionTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _topBackgroundView.mas_left );
            make.top.equalTo( _topBackgroundView.mas_top );
            make.bottom.equalTo( _topBackgroundView.mas_bottom );
            make.width.equalTo( self.miniTestButton );
        }];
        [self.miniTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _topBackgroundView.mas_top );
            make.right.equalTo( _topBackgroundView.mas_right );
            make.bottom.equalTo( _topBackgroundView.mas_bottom );
            make.left.equalTo( self.positionTestButton.mas_right );
            make.width.equalTo( @( kScreenWidth / 2.0 ) );
        }];
        
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topBackgroundView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _topBackgroundView.mas_left );
            make.bottom.equalTo( _topBackgroundView.mas_bottom );
            make.right.equalTo( _topBackgroundView.mas_right );
            make.height.equalTo( @( 4 / 3.0 ) );
        }];
        
        [_topBackgroundView addSubview:self.selectedSeparatorLine];
    }
    return _topBackgroundView;
}
- (UIButton *)positionTestButton
{
    if ( !_positionTestButton )
    {
        _positionTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_positionTestButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [_positionTestButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateSelected];
        [_positionTestButton.titleLabel setFont:[UIFont systemFontOfSize:48 / 3.0]];
        [_positionTestButton setTitle:@"职业测评" forState:UIControlStateNormal];
        _positionTestButton.tag = CPTestButtonPositionTest;
        [_positionTestButton addTarget:self action:@selector(changeTest:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _positionTestButton;
}
- (UIButton *)miniTestButton
{
    if ( !_miniTestButton )
    {
        _miniTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_miniTestButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [_miniTestButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateSelected];
        [_miniTestButton.titleLabel setFont:[UIFont systemFontOfSize:48 / 3.0]];
        [_miniTestButton setTitle:@"微测评" forState:UIControlStateNormal];
        [_miniTestButton setTag:CPTestButtonMiniTest];
        [_miniTestButton addTarget:self action:@selector(changeTest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _miniTestButton;
}
- (UIView *)selectedSeparatorLine
{
    if ( !_selectedSeparatorLine )
    {
        _selectedSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, ( 150 - 8) / 3.0, kScreenWidth / 2.0, 8 / 3.0)];
        [_selectedSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"288add"]];
    }
    return _selectedSeparatorLine;
}
- (UIScrollView *)backgroundScrollView
{
    if ( !_backgroundScrollView )
    {
        _backgroundScrollView = [[UIScrollView alloc] init];
        _backgroundScrollView.frame = CGRectMake(0, 150 / 3.0+64, kScreenWidth, self.view.viewHeight -150 / 3.0-64);
        [_backgroundScrollView setPagingEnabled:YES];
        [_backgroundScrollView setDelegate:self];
        [_backgroundScrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _backgroundScrollView;
}
- (UITableView *)miniTestTableView
{
    if ( !_miniTestTableView )
    {
        _miniTestTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.view.viewHeight -150 / 3.0-64) style:UITableViewStylePlain];
        _miniTestTableView.delegate = self;
        _miniTestTableView.dataSource = self;
        _miniTestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_miniTestTableView setBackgroundColor:[UIColor clearColor]];
        [_miniTestTableView setContentInset:UIEdgeInsetsMake(0, 0, 49 / 2.0, 0)];
    }
    return _miniTestTableView;
}
#pragma mark - private methods
- (void)showLoginTips
{
    [self.loginTipsView setHidden:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self.loginTipsView];
}
#pragma mark - getter methods
- (UIView *)loginTipsView
{
    if ( !_loginTipsView )
    {
        _loginTipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_loginTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / 3.0 * 2;
        CGFloat H = ( 84 + 60 + 84 + 48 * 1 + 24 * 1 + 84 + 2 + 144 ) / 3.0;
        CGFloat X = 40 / 3.0;
        CGFloat Y = ( kScreenHeight - H ) / 2.0;
        UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [tipsView.layer setCornerRadius:10 / 3.0];
        [tipsView.layer setMasksToBounds:YES];
        [_loginTipsView addSubview:tipsView];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:60 / 3.0]];
        [titleLabel setText:@"提示"];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [tipsView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( tipsView.mas_top ).offset( 84 / 3.0 );
            make.left.equalTo( tipsView.mas_left );
            make.right.equalTo( tipsView.mas_right );
            make.height.equalTo( @( 60 / 3.0 ) );
        }];
        CPPositionDetailDescribeLabel *contentLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [contentLabel setVerticalAlignment:VerticalAlignmentTop];
        [contentLabel setNumberOfLines:0];
        NSString *str = @"您还没登录，登录才能使用此功能!";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:24 / 3.0];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / 3.0]}];
        [contentLabel setAttributedText:attStr];
        [tipsView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( titleLabel.mas_bottom ).offset( 84 / 3.0 );
            make.left.equalTo( tipsView.mas_left ).offset( 70 / 3.0 );
            make.right.equalTo( tipsView.mas_right ).offset( -60 / 3.0 );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / 3.0 + 2 / 3.0) );
            make.left.equalTo( tipsView.mas_left );
            make.height.equalTo( @( 2 / 3.0 ) );
            make.right.equalTo( tipsView.mas_right );
        }];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"暂不登录" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:48 / 3.0]];
        [tipsView addSubview:cancelButton];
        [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_loginTipsView setHidden:YES];
            [_loginTipsView removeFromSuperview];
        }];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:@"去登录" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / 3.0]];
        [tipsView addSubview:sureButton];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_loginTipsView setHidden:YES];
            [_loginTipsView removeFromSuperview];
            LoginVC *vc = [[LoginVC alloc] initWithComeFromString:self.selecetdItemString];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];;
        }];
        UIView *verSeparatorLine = [[UIView alloc] init];
        [verSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:verSeparatorLine];
        CGFloat buttonW = ( W - 2 / 3.0 ) / 2.0;
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( @( 144 / 3.0 ) );
            make.width.equalTo( @( buttonW ) );
        }];
        [verSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( cancelButton.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.width.equalTo( @( 2 / 3.0 ) );
        }];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( tipsView.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( cancelButton );
            make.width.equalTo( cancelButton );
        }];
        [_loginTipsView setHidden:YES];
    }
    return _loginTipsView;
}
- (void)outSideOpenExam
{
    DynamicExamModelDTO *bean = [DynamicExamModelDTO beanFromDictionary:self.jobCepinArray[0]];
    DynamicExamDetailVC *vc  = nil;
    if (bean.Status.intValue == 1) {
        vc = [[DynamicExamDetailVC alloc]initWithUrl:bean.ReportUrl examDetail:examDetailOther];
    }else
    {
        vc = [[DynamicExamDetailVC alloc] initWithUrl:bean.ExamUrl examDetail:examDetailOther];
    }
    vc.title = bean.Title;
    vc.strTitle = bean.Title;
    vc.urlPath = bean.ExamUrl;
    vc.urlLogo = bean.ImgFilePath;
    vc.contentText = bean.Introduction;
    vc.isJiSuCepin = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
