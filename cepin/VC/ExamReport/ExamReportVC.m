//
//  ExamReportVC.m
//  cepin
//
//  Created by dujincai on 15/6/9.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExamReportVC.h"
#import "ExamReportVM.h"
#import "ExamReportCell.h"
#import "DynamicExamModelDTO.h"
#import "CPRecommendModelFrame.h"
#import "DynamicExamDetailVC.h"
#import "CPMyTestInviteCell.h"
#import "CPPersionTestVM.h"
#import "RTNetworking+DynamicState.h"
#import "CPMyPositionTestCell.h"
#import "JobSearchResultVC.h"
#import "RegionDTo.h"
#import "CPCommon.h"
typedef NS_ENUM(NSUInteger, CPTestButtonType)
{
    CPTestButtonInviteTest,
    CPTestButtonPositionTest,
    CPTestButtonMiniTest
};

@interface ExamReportVC ()
@property(nonatomic,strong)ExamReportVM *viewModel;
@property (nonatomic, strong) CPPersionTestVM *persionTestVM;
@property(nonatomic,strong)UIImageView *wuImage;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,assign)int imageHight;

@property (nonatomic, strong) UIView *topBackgroundView;
@property (nonatomic, strong) UIButton *inviteTestButton;
@property (nonatomic, strong) UIButton *positionTestButton;
@property (nonatomic, strong) UIButton *miniTestButton;
@property (nonatomic, strong) UIView *selectedSeparatorLine;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UITableView *miniTestTableView;
@property (nonatomic, strong) UIButton *selectedTestButton;
@property (nonatomic, strong) UITableView *inviteTableView;
@property (nonatomic, strong) NSMutableArray *positionTestArrayM;
@property (nonatomic, strong) NSMutableArray *miniTestArrayM;
@property(nonatomic,strong)UITableView *currentTableView;
@property(nonatomic,assign)NSInteger invitePage;//邀请的测评
@property(nonatomic,assign)NSInteger jobPage;//职业测评

//邀请的测聘错误显示界面
@property(nonatomic,strong)UIImageView     *errorImgView;
@property(nonatomic,strong)UILabel     *secondLable;
@property (nonatomic, strong) UIButton *reloadBtn;

//职业测评错误显示界面
@property(nonatomic,strong)UIImageView   *JobErrorImgView;
@property(nonatomic,strong)UILabel     *JobSecondLable;
@property (nonatomic, strong) UIButton *JobReloadBtn;
@property(nonatomic,assign)BOOL networkError;//标记是否有网络
@property(nonatomic,assign)BOOL jobNetworkError;//标记是否有网络
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,strong)TBLoading *load;

@end
@implementation ExamReportVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewModel = [ExamReportVM new];
        self.persionTestVM = [[CPPersionTestVM alloc] init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refleshTable];
    [self.tableView reloadData];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ( [self.examReportVCDelegate respondsToSelector:@selector(examReportVCNotify)] )
    {
        [self.examReportVCDelegate examReportVCNotify];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的测评";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createPositionTestTableView];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.invitePage = 1;
    self.jobPage = 1;
    [self.view addSubview:self.topBackgroundView];
    self.topBackgroundView.frame = CGRectMake(0, 64.0, kScreenWidth, 150 / CP_GLOBALSCALE);
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.inviteTableView];
    [self.backgroundScrollView addSubview:self.tableView];
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth * 2.0, self.view.viewHeight - 150 / CP_GLOBALSCALE - 64)];
    /**
     *
     *未获取到数据的错误提示页面
     */
    self.errorImgView = [[UIImageView alloc]initWithImage:UIIMAGE(@"null_job_exam")];
    [self.inviteTableView addSubview:self.errorImgView];
    [self.errorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+366/CP_GLOBALSCALE);
        make.width.equalTo(@(280/CP_GLOBALSCALE));
        make.height.equalTo(@(280/CP_GLOBALSCALE));
    }];
    self.errorImgView.hidden  = YES;
    self.secondLable = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.inviteTableView addSubview:self.secondLable];
    [self.secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.errorImgView.mas_bottom).offset(90/CP_GLOBALSCALE);
        make.left.equalTo(self.view.mas_left).offset(40/CP_GLOBALSCALE);
        make.right.equalTo(self.view.mas_right).offset(-40/CP_GLOBALSCALE);
        make.height.equalTo(@(60));
    }];
    self.secondLable.backgroundColor = [UIColor clearColor];
    self.secondLable.text = @"目前还没有企业邀请你的测评，请耐心等待或主动出击投递简历";
    self.secondLable.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE] ;
    self.secondLable.textColor = [UIColor colorWithHexString:@"404040"];
    self.secondLable.textAlignment = NSTextAlignmentCenter;
    [self.secondLable setNumberOfLines:0];
    //注意这里UILabel的numberoflines(即最大行数限制)设置成0，即不做行数限制。
    [self.secondLable setLineBreakMode:NSLineBreakByWordWrapping];
    self.secondLable.hidden = YES;
    self.reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.reloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [self.reloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [self.reloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.reloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateSelected];
    [self.reloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    [self.reloadBtn.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [self.reloadBtn.layer setMasksToBounds:YES];
    [self.reloadBtn.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [self.reloadBtn setTitle:@"寻找好工作" forState:UIControlStateNormal];
    [self.inviteTableView addSubview:self.reloadBtn];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.secondLable.mas_bottom).offset(60/CP_GLOBALSCALE);
        make.width.equalTo(@(330/CP_GLOBALSCALE));
        make.height.equalTo(@(120/CP_GLOBALSCALE));
    }];
    self.reloadBtn.hidden = YES;
    //职位测聘错误显示界面
    self.JobErrorImgView = [[UIImageView alloc]initWithImage:UIIMAGE(@"null_job_exam")];
    [self.self.tableView addSubview:self.JobErrorImgView];
    [self.JobErrorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+366/CP_GLOBALSCALE);
        make.width.equalTo(@(280/CP_GLOBALSCALE));
        make.height.equalTo(@(280/CP_GLOBALSCALE));
    }];
    self.JobErrorImgView.hidden  = YES;
    self.JobSecondLable = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.self.tableView addSubview:self.JobSecondLable];
    [self.JobSecondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.top.equalTo(self.JobErrorImgView.mas_bottom).offset(90/CP_GLOBALSCALE);
        make.left.equalTo(self.tableView.mas_left).offset(40/CP_GLOBALSCALE);
        make.right.equalTo(self.tableView.mas_right).offset(-40/CP_GLOBALSCALE);
        make.height.equalTo(@(80));
    }];
    self.JobSecondLable.backgroundColor = [UIColor clearColor];
    self.JobSecondLable.text = @"来测一下极速职业测评吧！发掘你的潜在能力与优势发展行业，3D简历增加80%职业竞争力";
    self.JobSecondLable.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE] ;
    self.JobSecondLable.textColor = [UIColor colorWithHexString:@"404040"];
    self.JobSecondLable.textAlignment = NSTextAlignmentCenter;
    [self.JobSecondLable setNumberOfLines:0];
    //注意这里UILabel的numberoflines(即最大行数限制)设置成0，即不做行数限制。
    [self.JobSecondLable setLineBreakMode:NSLineBreakByWordWrapping];
    self.JobSecondLable.hidden = YES;
    
    self.JobReloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.JobReloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.JobReloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [self.JobReloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [self.JobReloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.JobReloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateSelected];
    [self.JobReloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    [self.JobReloadBtn.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [self.JobReloadBtn.layer setMasksToBounds:YES];
    [self.JobReloadBtn.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [self.JobReloadBtn setTitle:@"马上测一下" forState:UIControlStateNormal];
    [self.tableView addSubview:self.JobReloadBtn];
    [self.JobReloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.top.equalTo(self.JobSecondLable.mas_bottom).offset(60/CP_GLOBALSCALE);
        make.width.equalTo(@(330/CP_GLOBALSCALE));
        make.height.equalTo(@(120/CP_GLOBALSCALE));
    }];
    self.JobReloadBtn.hidden = YES;
    [self.reloadBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        if (self.networkError) {
            self.invitePage = 0;
            [self updateTable];
        }else{
           //寻找好工作跳转到搜索页面
             NSString *currentCity = [[NSUserDefaults standardUserDefaults] valueForKey:@"LocationCity"];
            if (!currentCity) {
               currentCity = @"";
            }
            JobSearchResultVC *searchVc = nil;
            if (!currentCity) {
                Region *region = [Region searchAddressWithAddressString:currentCity];
                 searchVc = [[JobSearchResultVC alloc]initWithKeyWord:region.PathCode];
            }else{
                 searchVc = [[JobSearchResultVC alloc]initWithKeyWord:@""];
            }
            [self.navigationController pushViewController:searchVc animated:YES];
            
        }
    }];
    
    [self.JobReloadBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if (self.jobNetworkError) {
            self.jobPage=0;
            [self updateTable];
        }else{
            //职业测评跳转到极速测评页
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
        
    }];
    [self changeTest:self.positionTestButton];
    [self setupDropDownScrollView];
    __weak BaseTableViewController *mainvc = self;
    self.inviteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [mainvc updateTable];
    }];
}

- (void)clickNetWorkButton
{
    [self reloadData];
}
-(void)reloadData
{
    [self refleshTable];
}
-(void)refleshTable
{
    
    [self.viewModel.datas removeAllObjects];
    [self.positionTestArrayM removeAllObjects];
     [self.inviteTableView reloadData];
     [self.tableView reloadData];
    
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString*tokenId = [[MemoryCacheData shareInstance] userTokenId];
    if (!strUser)
    {
        strUser = @"";
        tokenId = @"";
        
    }
    if (!self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = NO;
    }
    RACSignal *signal = [[RTNetworking shareInstance] getCustomerExamListWith:strUser tokenId:tokenId PageIndex:1 PageSize:10];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        self.networkError = NO;
        if (self.load)
        {
            [self.load stop];
        }
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            if (array)
            {
                [self.viewModel.datas addObjectsFromArray:array];
                [self.inviteTableView reloadData];
                [self HideErrorViewWithType:1];
            }else{
                [self showErrorViewWithContent:@"目前还没有企业邀请你的测评，请耐心等待或主动出击投递简历" type:1];
            }
        }else{
            [self showErrorViewWithContent:@"目前还没有企业邀请你的测评，请耐心等待或主动出击投递简历" type:1];
        }
    } error:^(NSError *error){
        //        [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
        self.networkError = YES;
        if (self.load)
        {
            [self.load stop];
        }
        [self showErrorViewWithContent:@"当前网络不可用，请检查网络设置" type:1];
    }];
    RACSignal *positionSignal = [[RTNetworking shareInstance] getSinglPersonExamListWith:strUser tokenId:tokenId examStatus:@"1" PageIndex:1 PageSize:10 ];
    [positionSignal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        self.jobNetworkError = NO;
        if (self.load)
        {
            [self.load stop];
        }
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            if (array)
            {
                [self.positionTestArrayM addObjectsFromArray:array];
                [self.tableView reloadData];
                [self HideErrorViewWithType:2];
            }else{
                [self showErrorViewWithContent:@"来测一下极速职业测评吧！发掘你的潜在能力与优势发展行业，3D简历增加80%职业竞争力" type:2];
            }
        }else{
            [self showErrorViewWithContent:@"来测一下极速职业测评吧！发掘你的潜在能力与优势发展行业，3D简历增加80%职业竞争力" type:2];
        }
    } error:^(NSError *error){
        self.jobNetworkError = YES;
        if (self.load)
        {
            [self.load stop];
        }
        [self showErrorViewWithContent:@"当前网络不可用，请检查网络设置" type:2];
    }];
}
-(void)updateTable
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString *strTocken = [[MemoryCacheData shareInstance] userTokenId];
    if(!strUser){
        return;
    }
    //判断当前数据是否邀请的测评
    if ( self.currentTableView == self.inviteTableView ){
        self.invitePage++;
       RACSignal *signal = [[RTNetworking shareInstance] getCustomerExamListWith:strUser tokenId:strTocken PageIndex:self.invitePage PageSize:10];
        @weakify(self);
        [signal subscribeNext:^(RACTuple *tuple){
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)tuple.second;
            self.networkError = NO;
            if ([dic resultSucess])
            {
                NSArray *array = [dic resultObject];
                if (array)
                {
                    [self.viewModel.datas addObjectsFromArray:array];
                    [self stopUpdate];
                }else{
                    if(self.invitePage==1){
                    [self showErrorViewWithContent:@"目前还没有企业邀请你的测评，请耐心等待或主动出击投递简历" type:1];
                    }
                }
            }else{
                [self loadEnd];
                if(_invitePage==1){
                    [self showErrorViewWithContent:@"目前还没有企业邀请你的测评，请耐心等待或主动出击投递简历" type:1];
                }
                self.invitePage--;
            }
        } error:^(NSError *error){
            self.networkError = YES;
            [self endUpdate];
            if(_invitePage==1){
                [self showErrorViewWithContent:@"当前网络不可用，请检查网络设置" type:1];
            }
            self.invitePage--;
        }];
    }else if (self.currentTableView == self.tableView ){
        self.jobPage++;
        RACSignal *positionSignal = [[RTNetworking shareInstance] getSinglPersonExamListWith:strUser tokenId:strTocken examStatus:@"1" PageIndex:self.jobPage PageSize:10 ];
        @weakify(self);
        [positionSignal subscribeNext:^(RACTuple *tuple){
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)tuple.second;
            self.jobNetworkError = NO;
            if ([dic resultSucess])
            {
                NSArray *array = [dic resultObject];
                if (array)
                {
                    [self.positionTestArrayM addObjectsFromArray:array];
                    [self stopUpdate];
                    [self HideErrorViewWithType:2];
                    
                }else{
                    if(_jobPage==1){
                        [self showErrorViewWithContent:@"来测一下极速职业测评吧！发掘你的潜在能力与优势发展行业，3D简历增加80%职业竞争力" type:2];
                    }
                }
            }else{
                [self loadEnd];
                if(_jobPage==1){
                    [self showErrorViewWithContent:@"来测一下极速职业测评吧！发掘你的潜在能力与优势发展行业，3D简历增加80%职业竞争力" type:2];
                }
                self.jobPage--;
            }
        } error:^(NSError *error){
            self.jobNetworkError = YES;
            [self endUpdate];
            if(_jobPage==1){
                [self showErrorViewWithContent:@"当前网络不可用，请检查网络设置" type:2];
            }
            self.jobPage--;
        }];
    }
}
-(void)showErrorViewWithContent:(NSString *)content type:(NSInteger)type{
    if(type==1){
        self.errorImgView.hidden = NO;
        self.secondLable.hidden = NO;
        self.reloadBtn.hidden = NO;
        self.secondLable.text = content;
        if (self.networkError) {
            
            [self.reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
            self.errorImgView.image = [UIImage imageNamed:@"null_exam_linkbroken"];
        }else{
            [self.reloadBtn setTitle:@"寻找好工作" forState:UIControlStateNormal];
            self.errorImgView.image = [UIImage imageNamed:@"null_exam"];
        }
    }else{
        self.JobErrorImgView.hidden = NO;
        self.JobSecondLable.hidden = NO;
        self.JobReloadBtn.hidden = NO;
        self.JobSecondLable.text = content;
        if (self.jobNetworkError) {
            self.JobErrorImgView.image = [UIImage imageNamed:@"null_exam_linkbroken"];
            [self.JobReloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
            
        }else{
            self.JobErrorImgView.image = [UIImage imageNamed:@"null_job_exam"];
            [self.JobReloadBtn setTitle:@"马上测一下" forState:UIControlStateNormal];
        }
    }
}
-(void)HideErrorViewWithType:(NSInteger)type{
    if(type==1){
        self.errorImgView.hidden = YES;
        self.secondLable.hidden = YES;
        self.reloadBtn.hidden = YES;
    }else{
        self.JobErrorImgView.hidden = YES;
        self.JobSecondLable.hidden = YES;
        self.JobReloadBtn.hidden = YES;
    }
}
-(void)stopUpdate{
    //    [self stopUpdateAnimation];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.currentTableView.mj_footer endRefreshing];
    });
    [self.currentTableView reloadData];
}
-(void)loadEnd{
    MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)self.currentTableView.mj_footer;
    [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
    self.currentTableView.mj_footer = footer;
    [self.currentTableView.mj_footer endRefreshingWithNoMoreData];
}
-(void)endUpdate{
    [self.currentTableView.mj_footer endRefreshingWithNoMoreData];
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight ;
    if(tableView==self.inviteTableView){
        rowHeight = ( 40 + 60 + 42 + 40 + 36 + 20 + 36 + 60 ) / CP_GLOBALSCALE;
    }else{
        DynamicExamModelDTO *bean = [DynamicExamModelDTO beanFromDictionary:self.positionTestArrayM[indexPath.row]];
       
        if( bean.ExamStatus.intValue==2){
            rowHeight = (  500 + 60 + 42 + 60 + 36 * 2 + 20 * 2 + 60 + 6 ) / CP_GLOBALSCALE;
        }else{
            rowHeight = (  500 + 60 + 42 + 60  + 60 + 6 ) / CP_GLOBALSCALE;
        }
    }
    return rowHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.currentTableView = tableView;
    if ( tableView == self.inviteTableView )
    {
        return [self.viewModel.datas count];
    }
    else if ( tableView == self.tableView )
    {
        return [self.positionTestArrayM count];
    }
    else if ( tableView == self.miniTestTableView )
    {
        return [self.miniTestArrayM count];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentTableView = tableView;
    if ( tableView == self.inviteTableView )
    {
        DynamicExamModelDTO *bean = [DynamicExamModelDTO beanFromDictionary:self.viewModel.datas[indexPath.row]];
        CPMyTestInviteCell *cell = [CPMyTestInviteCell myTestInviteCellWithTableView:tableView];
        [cell configCellWithExamModel:bean];
        [cell.testButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            DynamicExamModelDTO *bean = [DynamicExamModelDTO beanFromDictionary:self.viewModel.datas[indexPath.row]];
            DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc] initWithUrl:bean.AppExamUrl examDetail:examDetailFirst];
            vc.title = bean.ProductName;
            vc.isJiSuCepin = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    else if ( tableView == self.tableView )
    {        
        DynamicExamModelDTO *bean = [DynamicExamModelDTO beanFromDictionary:self.positionTestArrayM[indexPath.row]];
        CPMyPositionTestCell *cell = [CPMyPositionTestCell myPositionCellWithTableView:tableView];
        [cell configCellWithMyPostionTestModel:bean];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ( tableView == self.inviteTableView )
    {
    }
    else if ( tableView == self.tableView )
    {   //极速测评
        DynamicExamModelDTO *bean = [DynamicExamModelDTO beanFromDictionary:self.positionTestArrayM[indexPath.row]];
        NSString *url = [NSString stringWithFormat:@"%@/examcenter/desc?id=2",kHostMUrl];
        DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:url examDetail:examDetailOther];
        vc.title = bean.Title;
        vc.isJiSuCepin = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//滑动scrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
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
        self.currentTableView = self.inviteTableView;
        [UIView animateWithDuration:0.15 animations:^{
            weakSelf.selectedSeparatorLine.viewX = 0;
        }];
        
        if ( 0 != weakSelf.backgroundScrollView.contentOffset.x )
            [weakSelf.backgroundScrollView setContentOffset:CGPointMake(0, 0)];
    }
    else
    {
        self.currentTableView = self.tableView;
        [UIView animateWithDuration:0.15 animations:^{
            weakSelf.selectedSeparatorLine.viewX = kScreenWidth / 2.0;
        }];
        if ( kScreenWidth != weakSelf.backgroundScrollView.contentOffset.x )
            [weakSelf.backgroundScrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
    }
}
- (UIScrollView *)backgroundScrollView
{
    if ( !_backgroundScrollView )
    {
        _backgroundScrollView = [[UIScrollView alloc] init];
        _backgroundScrollView.frame = CGRectMake(0, 150 / CP_GLOBALSCALE + 64, kScreenWidth, self.view.viewHeight - 150 / CP_GLOBALSCALE - 64);
        [_backgroundScrollView setPagingEnabled:YES];
        [_backgroundScrollView setDelegate:self];
        [_backgroundScrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _backgroundScrollView;
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
            make.height.equalTo( @( 4 / CP_GLOBALSCALE ) );
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
        [_positionTestButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_positionTestButton setTitle:@"邀请的测评" forState:UIControlStateNormal];
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
        [_miniTestButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_miniTestButton setTitle:@"职业测评" forState:UIControlStateNormal];
        [_miniTestButton setTag:CPTestButtonMiniTest];
        [_miniTestButton addTarget:self action:@selector(changeTest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _miniTestButton;
}
- (UIButton *)inviteTestButton
{
    if ( !_inviteTestButton )
    {
        _inviteTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteTestButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [_inviteTestButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateSelected];
        [_inviteTestButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_inviteTestButton setTitle:@"邀请的测评" forState:UIControlStateNormal];
        [_inviteTestButton setTag:CPTestButtonInviteTest];
        [_inviteTestButton addTarget:self action:@selector(changeTest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteTestButton;
}
- (UIView *)selectedSeparatorLine
{
    if ( !_selectedSeparatorLine )
    {
        _selectedSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, ( 150 - 8) / CP_GLOBALSCALE, kScreenWidth / 2.0, 8 / CP_GLOBALSCALE)];
        [_selectedSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"288add"]];
    }
    return _selectedSeparatorLine;
}
- (UITableView *)miniTestTableView
{
    if ( !_miniTestTableView )
    {
        _miniTestTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth * 2.0, 0, kScreenWidth, self.view.viewHeight - 150 / CP_GLOBALSCALE - 64) style:UITableViewStylePlain];
        _miniTestTableView.delegate = self;
        _miniTestTableView.dataSource = self;
        _miniTestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_miniTestTableView setBackgroundColor:[UIColor clearColor]];
        [_miniTestTableView setContentInset:UIEdgeInsetsMake(0, 0, 32 / CP_GLOBALSCALE, 0)];
    }
    return _miniTestTableView;
}
- (UITableView *)inviteTableView
{
    if ( !_inviteTableView )
    {
        _inviteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.viewHeight - 150 / CP_GLOBALSCALE - 64) style:UITableViewStylePlain];
        _inviteTableView.delegate = self;
        _inviteTableView.dataSource = self;
        _inviteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_inviteTableView setBackgroundColor:[UIColor clearColor]];
        [_inviteTableView setContentInset:UIEdgeInsetsMake(0, 0, 32 / CP_GLOBALSCALE, 0)];
    }
    return _inviteTableView;
}
- (NSMutableArray *)positionTestArrayM
{
    if ( !_positionTestArrayM )
    {
        _positionTestArrayM = [NSMutableArray array];
    }
    return _positionTestArrayM;
}
- (NSMutableArray *)miniTestArrayM
{
    if ( !_miniTestArrayM )
    {
        _miniTestArrayM = [NSMutableArray array];
    }
    return _miniTestArrayM;
}
@end
