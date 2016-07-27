//
//  SaveVC.m
//  cepin
//
//  Created by dujincai on 15/5/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SaveVC.h"
#import "RTTabView.h"
#import "TKRoundedView.h"
#import "UIViewController+NavicationUI.h"
#import "TBUmengShareConfig.h"
#import "SaveJobVC.h"
#import "SaveCompanyVC.h"
#import "SaveVM.h"
#import "SaveJobCell.h"
#import "SaveJobVM.h"
#import "SaveCompanyVM.h"
#import "JobSearchModel.h"
#import "CPCollectionPositioinCell.h"
#import "CPCollectionCompanyCell.h"
#import "RTNetworking+Position.h"
#import "RTNetworking+Company.h"
#import "CPHomePositionDetailController.h"
#import "CPCompanyDetailController.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"
typedef NS_ENUM(NSUInteger, CPTestButtonType)
{
    CPTestButtonPositionTest,
    CPTestButtonMiniTest
};

@interface SaveVC ()
@property(nonatomic,strong)UIButton *deleteButton;

@property (nonatomic, strong) UIView *topBackgroundView;
@property (nonatomic, strong) UIButton *positionTestButton;
@property (nonatomic, strong) UIButton *miniTestButton;
@property (nonatomic, strong) UIView *selectedSeparatorLine;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UITableView *miniTestTableView;
@property (nonatomic, strong) UIButton *selectedTestButton;
//职位错误显示界面
@property(nonatomic,strong)UIImageView     *errorImgView;
@property(nonatomic,strong)UILabel     *secondLable;
@property (nonatomic, strong) UIButton *reloadBtn;

//公司错误显示界面
@property(nonatomic,strong)UIImageView   *companyErrorImgView;
@property(nonatomic,strong)UILabel     *companySecondLable;
@property (nonatomic, strong) UIButton *companyReloadBtn;
@property(nonatomic,assign)BOOL networkError;//标记是否有网络
@property(nonatomic,assign)BOOL companyNetworkError;//标记是否有网络
@property (nonatomic, strong) SaveJobVM *saveJob;
@property (nonatomic, strong) SaveCompanyVM *saveCompany;
@property(nonatomic,strong)UITableView *currentTableView;
@property(nonatomic,assign)NSInteger companyPage;//企业当前页面
@property(nonatomic,assign)NSInteger systemPage;//系统当前页面
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,strong)TBLoading *load;
@end
@implementation SaveVC

-(instancetype)init
{
    self = [super init];
    if (self) {
        _saveJob = [[SaveJobVM alloc] init];
        _saveCompany = [[SaveCompanyVM alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.companyPage = 1;
    self.systemPage = 1;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.view addSubview:self.topBackgroundView];
    self.topBackgroundView.frame = CGRectMake(0, 64.0, kScreenWidth, 150 / CP_GLOBALSCALE);
    [self createProfileTableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 32 / CP_GLOBALSCALE, 0)];
    self.tableView.rowHeight = (40 + 60 + 42 + 40 + 42 + 40 + 36 + 60 + 6) / CP_GLOBALSCALE;
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView addSubview:self.tableView];
    [self.backgroundScrollView addSubview:self.miniTestTableView];
    self.miniTestTableView.rowHeight = (40 + 60 + 42 + 40 + 36 + 60 + 6) / CP_GLOBALSCALE;
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth * 2.0, self.view.viewHeight - 150 / CP_GLOBALSCALE - 64)];
    /**
     *
     *未获取到数据的错误提示页面
     */
    self.errorImgView = [[UIImageView alloc]initWithImage:UIIMAGE(@"null_collect")];
    [self.tableView addSubview:self.errorImgView];
    [self.errorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+366/CP_GLOBALSCALE);
        make.width.equalTo(@(280/CP_GLOBALSCALE));
        make.height.equalTo(@(280/CP_GLOBALSCALE));
    }];
    self.errorImgView.hidden  = YES;
    self.secondLable = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.tableView addSubview:self.secondLable];
    [self.secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.errorImgView.mas_bottom).offset(90/CP_GLOBALSCALE);
        make.left.equalTo(self.view.mas_left).offset(40/CP_GLOBALSCALE);
        make.right.equalTo(self.view.mas_right).offset(-40/CP_GLOBALSCALE);
        make.height.equalTo(@(60));
    }];
    self.secondLable.backgroundColor = [UIColor clearColor];
    self.secondLable.text = @"你还没有收藏职位，看看什么岗位正在热招";
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
    [self.reloadBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
    [self.tableView addSubview:self.reloadBtn];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.secondLable.mas_bottom).offset(60/CP_GLOBALSCALE);
        make.width.equalTo(@(330/CP_GLOBALSCALE));
        make.height.equalTo(@(120/CP_GLOBALSCALE));
    }];
    self.reloadBtn.hidden = YES;
    //公司错误显示界面
    self.companyErrorImgView = [[UIImageView alloc]initWithImage:UIIMAGE(@"null_collect")];
    [self.self.miniTestTableView addSubview:self.companyErrorImgView];
    [self.companyErrorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.miniTestTableView.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+366/CP_GLOBALSCALE);
        make.width.equalTo(@(280/CP_GLOBALSCALE));
        make.height.equalTo(@(280/CP_GLOBALSCALE));
    }];
    self.companyErrorImgView.hidden  = YES;
    self.companySecondLable = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.self.miniTestTableView addSubview:self.companySecondLable];
    [self.companySecondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.miniTestTableView.mas_centerX);
        make.top.equalTo(self.companyErrorImgView.mas_bottom).offset(90/CP_GLOBALSCALE);
        make.left.equalTo(self.miniTestTableView.mas_left).offset(40/CP_GLOBALSCALE);
        make.right.equalTo(self.miniTestTableView.mas_right).offset(-40/CP_GLOBALSCALE);
        make.height.equalTo(@(60));
    }];
    self.companySecondLable.backgroundColor = [UIColor clearColor];
    self.companySecondLable.text = @"你还没有收藏企业，看看什么企业正在招聘";
    self.companySecondLable.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE] ;
    self.companySecondLable.textColor = [UIColor colorWithHexString:@"404040"];
    self.companySecondLable.textAlignment = NSTextAlignmentCenter;
    [self.companySecondLable setNumberOfLines:0];
    //注意这里UILabel的numberoflines(即最大行数限制)设置成0，即不做行数限制。
    [self.companySecondLable setLineBreakMode:NSLineBreakByWordWrapping];
    self.companySecondLable.hidden = YES;
    self.companyReloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.companyReloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.companyReloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [self.companyReloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [self.companyReloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.companyReloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateSelected];
    [self.companyReloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    [self.companyReloadBtn.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [self.companyReloadBtn.layer setMasksToBounds:YES];
    [self.companyReloadBtn.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [self.companyReloadBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
    [self.miniTestTableView addSubview:self.companyReloadBtn];
    [self.companyReloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.miniTestTableView.mas_centerX);
        make.top.equalTo(self.companySecondLable.mas_bottom).offset(60/CP_GLOBALSCALE);
        make.width.equalTo(@(330/CP_GLOBALSCALE));
        make.height.equalTo(@(120/CP_GLOBALSCALE));
    }];
    self.companyReloadBtn.hidden = YES;
    [self.reloadBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [MobClick event:@"btn_post_sbgg"];
        if (self.networkError) {
            self.companyPage = 0;
            [self updateTable];
        }else{
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
        }
    }];
    [self.companyReloadBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [MobClick event:@"btn_company_sbgg"];
        if (self.companyNetworkError) {
            self.systemPage=0;
            [self updateTable];
        }else{
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
        }
        
    }];
    [self setupDropDownScrollView];
    __weak BaseTableViewController *mainvc = self;
    self.miniTestTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [mainvc updateTable];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
[super viewWillAppear:animated];
    [self refleshTable];
    [self.currentTableView reloadData];
    
}
-(void)refleshTable{
    [self.saveCompany.datas removeAllObjects];
    [self.saveJob.datas removeAllObjects];
    NSString *strUser = [[MemoryCacheData shareInstance]userId];
    NSString *strTokenId =  [[MemoryCacheData shareInstance]userTokenId];
    if (!strUser) {
        strUser = @"";
        strTokenId = @"";
    }
    if (!self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = YES;
    }
    RACSignal *signal = [[RTNetworking shareInstance] getPositionCollectionListWithTokenId:strTokenId userId:strUser PageIndex:0 PageSize:10];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        self.networkError = NO;
        if (self.load)
        {
            [self.load stop];
        }
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            [self.saveJob.datas addObjectsFromArray:array];
            [self.tableView reloadData];
            [self HideErrorViewWithType:1];
        }else{
            
            [self.tableView reloadData];
            [self showErrorViewWithContent:@"你还没有收藏职位，看看什么岗位正在热招" type:1];
        }
    } error:^(NSError *error){
        if (self.load)
        {
            [self.load stop];
        }
                [self performSelector:@selector(stop) withObject:nil afterDelay:0.5];
        self.networkError = YES;
        [self showErrorViewWithContent:@"当前网络不可用，请检查网络设置" type:1];
    }];
    RACSignal *companySignal = [[RTNetworking shareInstance] getCompanyFocusListWithTokenId:strTokenId userId:strUser PageIndex:0 PageSize:10];
    [companySignal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)tuple.second;
        self.companyNetworkError = NO;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            [self.saveCompany.datas addObjectsFromArray:array];
            [self.miniTestTableView reloadData];
            [self HideErrorViewWithType:2];
        }else{
            
            [self.miniTestTableView reloadData];
            [self showErrorViewWithContent:@"你还没有收藏企业，看看什么企业正在招聘" type:2];
        }
    } error:^(NSError *error){
        self.companyNetworkError = YES;
        [self showErrorViewWithContent:@"当前网络不可用，请检查网络设置" type:2];
    }];
}
- (void)stop
{
    if (self.load)
    {
        [self.load stop];
    }
    self.isLoad = YES;
}
-(void)updateTable
{
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString *strTocken = [[MemoryCacheData shareInstance] userTokenId];
    if(!strUser){
        return;
    }
    //判断当前数据是否属于企业消息
    if ( self.currentTableView == self.tableView ){
        self.companyPage++;
         RACSignal *signal = [[RTNetworking shareInstance] getPositionCollectionListWithTokenId:strTocken userId:strUser PageIndex:self.companyPage PageSize:10];
        @weakify(self);
        [signal subscribeNext:^(RACTuple *tuple){
            @strongify(self);
            self.networkError = NO;
            NSDictionary *dic = (NSDictionary *)tuple.second;
            if ([dic resultSucess])
            {
                NSArray *array = [dic resultObject];
                if (array)
                {
                    NSArray *array = [dic resultObject];
                    [self.saveJob.datas addObjectsFromArray:array];
                    [self stopUpdate];
                    
                }
            }else{
                if (self.companyPage==1) {
                    [self showErrorViewWithContent:@"抱歉!你还没有收藏职位，可以去看看有什么哪些热招的岗位！" type:1];
                }
                self.companyPage--;
                [self loadEnd];
              
                
            }
        } error:^(NSError *error){
            self.networkError = YES;
            if (self.companyPage==1) {
                [self showErrorViewWithContent:@"当前网络不可用，请检查网络设置" type:1];
            }
            self.companyPage--;
            [self endUpdate];
        }];
    }else if (self.currentTableView == self.miniTestTableView ){
        self.systemPage++;
       
        RACSignal *companySignal = [[RTNetworking shareInstance] getCompanyFocusListWithTokenId:strTocken userId:strUser PageIndex:self.systemPage PageSize:10];
        
        @weakify(self);
        [companySignal subscribeNext:^(RACTuple *tuple){
            @strongify(self);
            self.companyNetworkError = NO;
            NSDictionary *dic = (NSDictionary *)tuple.second;
            if ([dic resultSucess])
            {
                NSArray *array = [dic resultObject];
                if (array)
                {
                    [self.saveCompany.datas addObjectsFromArray:array];
                    [self stopUpdate];
                    [self HideErrorViewWithType:2];
                }
            }else{
                
                [self loadEnd];
                if (self.systemPage==1) {
                    [self showErrorViewWithContent:@"抱歉!你还没有收藏企业，可以去看看有什么哪些名企正在招聘！" type:2];
                }
                self.systemPage--;
                
            }
        } error:^(NSError *error){
            self.companyNetworkError = YES;
           
            [self endUpdate];
            if (self.systemPage==1) {
                [self showErrorViewWithContent:@"当前网络不可用，请检查网络设置" type:2];
            }
             self.systemPage--;
            
        }];
        
    }
    //    [self.viewModel nextPage];
}
-(void)showErrorViewWithContent:(NSString *)content type:(NSInteger)type{
    if(type==1){
        self.errorImgView.hidden = NO;
        self.secondLable.hidden = NO;
        self.reloadBtn.hidden = NO;
        self.secondLable.text = content;
        if (self.networkError) {
            self.errorImgView.image = [UIImage imageNamed:@"null_exam_linkbroken"];
            [self.reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
            
        }else{
            self.errorImgView.image = [UIImage imageNamed:@"null_collect"];
            [self.reloadBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
        }
    }else{
        self.companyErrorImgView.hidden = NO;
        self.companySecondLable.hidden = NO;
        self.companyReloadBtn.hidden = NO;
        self.companySecondLable.text = content;
        if (self.companyNetworkError) {
            self.companyErrorImgView.image = [UIImage imageNamed:@"null_exam_linkbroken"];
            [self.companyReloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        }else{
            self.companyErrorImgView.image = [UIImage imageNamed:@"null_collect"];
            [self.companyReloadBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
        }
    }
}
-(void)HideErrorViewWithType:(NSInteger)type{

    if(type==1){
        self.errorImgView.hidden = YES;
        self.secondLable.hidden = YES;
        self.reloadBtn.hidden = YES;
    }else{
        self.companyErrorImgView.hidden = YES;
        self.companySecondLable.hidden = YES;
        self.companyReloadBtn.hidden = YES;
    }
}
-(void)stopUpdate{
    //    [self stopUpdateAnimation];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.currentTableView.mj_footer endRefreshing];
    });
    self.currentTableView.hidden = NO;
    [self.currentTableView reloadData];
}
-(void)loadEnd{
    self.currentTableView.hidden = NO;
    [self stopUpdateAnimation];
    MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)self.currentTableView.mj_footer;
    [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
    self.currentTableView.mj_footer = footer;
    [self.currentTableView.mj_footer endRefreshingWithNoMoreData];
}
-(void)endUpdate{
    [self.currentTableView.mj_footer endRefreshingWithNoMoreData];
}
//滑动scrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.backgroundScrollView )
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
#pragma mark - private methods
- (void)listenSaveJob
{
    @weakify(self)
    [RACObserve(self.saveJob,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        switch ([self requestStateWithStateCode:stateCode])
        {
            case HUDCodeDownloading:
                [self startRefleshAnimation];
                self.saveJob.isLoading = YES;
                self.networkImage.hidden = YES;
                break;
            case HUDCodeLoadMore:
                self.saveJob.isLoading = YES;
                [self startUpdateAnimation];
                break;
            case HUDCodeReflashSucess:
                [self.saveJob.selectJobs removeAllObjects];
                [self stopRefleshAnimation];
                [self.tableView reloadData];
                self.tableView.hidden = NO;
                self.networkImage.hidden = YES;
                break;
            case hudCodeUpdateSucess:
                [self stopUpdateAnimation];
                [self.tableView reloadData];
                self.tableView.hidden = NO;
                self.saveJob.isLoading = NO;
                break;
            case HUDCodeNone:
            {
                [self stopUpdateAnimation];
                self.networkImage.hidden = NO;
                self.tableView.hidden = NO;
            }
                break;
            case HUDCodeNetWork:
            {
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.networkButton.hidden = NO;
                self.clickImage.hidden = NO;
                self.tableView.hidden = YES;
            }
                break;
            default:
                [self stopRefleshAnimation];
                [self stopUpdateAnimation];
                self.saveJob.isLoading = NO;
                [self.tableView reloadData];
                self.networkImage.hidden = NO;
                break;
        }
    }];
}
- (void)listenSaveCompany
{
    @weakify(self)
    [RACObserve(self.saveCompany,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        switch ([self requestStateWithStateCode:stateCode])
        {
            case HUDCodeDownloading:
                self.saveCompany.isLoading = YES;
                [self startRefleshAnimation];
                break;
            case HUDCodeLoadMore:
                self.saveCompany.isLoading = YES;
                [self startUpdateAnimation];
                break;
            case HUDCodeReflashSucess:
                [self.saveCompany.selectedCompanies removeAllObjects];
                [self stopRefleshAnimation];
                [self.miniTestTableView reloadData];
                self.miniTestTableView.hidden = NO;
                self.networkImage.hidden = YES;
                break;
            case hudCodeUpdateSucess:
                [self stopUpdateAnimation];
                [self.miniTestTableView reloadData];
                self.miniTestTableView.hidden = NO;
                self.saveCompany.isLoading = NO;
                self.networkImage.hidden = NO;
                break;
            case HUDCodeNetWork:
            {
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.networkButton.hidden = NO;
                self.clickImage.hidden = NO;
                self.miniTestTableView.hidden = YES;
            }
                break;
            default:
                [self stopRefleshAnimation];
                [self stopUpdateAnimation];
                self.saveCompany.isLoading = NO;
                [self.miniTestTableView reloadData];
                self.networkImage.hidden = NO;
                break;
        }
    }];
}
#pragma mark - events respond
- (void)changeTest:(UIButton *)sender
{
    if ( self.selectedTestButton == sender )
        return;
    
    if ( self.selectedTestButton)
        self.selectedTestButton.selected = !self.selectedTestButton.selected;
    
    sender.selected = YES;
    
    self.selectedTestButton = sender;
    
    __weak typeof(self) weakSelf = self;
    if ( CPTestButtonPositionTest == sender.tag )
    {
        self.currentTableView = self.tableView;
        [UIView animateWithDuration:0.15 animations:^{
            weakSelf.selectedSeparatorLine.viewX = 0;
           
        }];
        
        if ( 0 != weakSelf.backgroundScrollView.contentOffset.x ){
            [weakSelf.backgroundScrollView setContentOffset:CGPointMake(0, 0)];
            
        }
        
    }
    else
    {
        self.currentTableView = self.miniTestTableView;
        [UIView animateWithDuration:0.15 animations:^{
            weakSelf.selectedSeparatorLine.viewX = kScreenWidth / 2.0;
        }];
        
        
        if ( kScreenWidth != weakSelf.backgroundScrollView.contentOffset.x ){
         [weakSelf.backgroundScrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
        }
        
    }
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.currentTableView = tableView;
    if ( tableView == self.tableView )
        return [self.saveJob.datas count];
    else
        return [self.saveCompany.datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentTableView = tableView;
    if ( tableView == self.tableView )
    {
        //职位收藏
        CPCollectionPositioinCell *cell = [CPCollectionPositioinCell collectionPositionCellWithTableView:tableView];
        JobSearchModel *model = [JobSearchModel beanFromDictionary:self.saveJob.datas[indexPath.row]];
        [cell configCellWithSaveJob:model];
        [cell.cllectionButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            //取消收藏
            NSString *strUser = [[MemoryCacheData shareInstance] userId];
            if(!strUser){
                return;
            }
            RACSignal *signal = [[RTNetworking shareInstance] positionCancelCollectWithUserId:strUser positionId:model.PositionId];
            @weakify(self);
            [signal subscribeNext:^(RACTuple *tuple){
                @strongify(self);
                NSDictionary *dic = (NSDictionary *)tuple.second;
                if ([dic resultSucess])
                {
                    [self.saveJob.datas removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                    [OMGToast showWithText:@"取消收藏"];
                    if ([self.saveJob.datas count]==0) {
                        [self showErrorViewWithContent:@"抱歉!你还没有收藏职位，可以去看看有什么哪些热招的岗位！" type:1];
                    }
                }else{
                     [self.tableView reloadData];
                     [self showErrorViewWithContent:@"抱歉!你还没有收藏职位，可以去看看有什么哪些热招的岗位！" type:1];
                }
            } error:^(NSError *error){
            }];
        }];
        return cell;
    }
    else
    {
        //企业收藏
        CPCollectionCompanyCell *cell = [CPCollectionCompanyCell collectionCompanyCellWithTableView:tableView];
        JobSearchModel *model = [JobSearchModel beanFromDictionary:self.saveCompany.datas[indexPath.row]];
        [cell configCellWithSaveCompany:model];
        [cell.cllectionButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            //取消收藏
            NSString *strUser = [[MemoryCacheData shareInstance] userId];
            if(!strUser){
                return;
            }
            RACSignal *companySignal = [[RTNetworking shareInstance] companyCancelCollectWithCustomerId:model.CustomerId UserId:strUser];
            @weakify(self);
            [companySignal subscribeNext:^(RACTuple *tuple){
                @strongify(self);
                NSDictionary *dic = (NSDictionary *)tuple.second;
                if ([dic resultSucess])
                {
                    [self.saveCompany.datas removeObjectAtIndex:indexPath.row];
                    [self.miniTestTableView reloadData];
                    [OMGToast showWithText:@"取消收藏"];
                    [self.miniTestTableView reloadData];
                    if ([self.saveCompany.datas count]==0) {
                        [self showErrorViewWithContent:@"抱歉!你还没有收藏企业，可以去看看有什么哪些名企正在招聘！" type:2];
                    }
                    
                }else{
                    [self.miniTestTableView reloadData];
                    [self showErrorViewWithContent:@"抱歉!你还没有收藏企业，可以去看看有什么哪些名企正在招聘！" type:2];
                }
            } error:^(NSError *error){
                
            }];
            
        }];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ( tableView == self.tableView )
    {//职位详情
        [MobClick event:@"btn_post_item_click"];
        JobSearchModel *model = [JobSearchModel beanFromDictionary:self.saveJob.datas[indexPath.row]];
        CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
        [companyDetailVC configWithPosition:model];
        [self.navigationController pushViewController:companyDetailVC animated:YES];
        
    }else{
        [MobClick event:@"btn_company_item_click"];
        CPCompanyDetailController *companyDetailVC = [[CPCompanyDetailController alloc] init];
         JobSearchModel *model = [JobSearchModel beanFromDictionary:self.saveCompany.datas[indexPath.row]];
        [companyDetailVC configWithPosition:model];
        [self.navigationController pushViewController:companyDetailVC animated:YES];
    }
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
        [_positionTestButton setTitle:@"职位" forState:UIControlStateNormal];
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
        [_miniTestButton setTitle:@"企业" forState:UIControlStateNormal];
        [_miniTestButton setTag:CPTestButtonMiniTest];
        [_miniTestButton addTarget:self action:@selector(changeTest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _miniTestButton;
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
- (UITableView *)miniTestTableView
{
    if ( !_miniTestTableView )
    {
        _miniTestTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.view.viewHeight - 150 / CP_GLOBALSCALE - 64) style:UITableViewStylePlain];
        _miniTestTableView.delegate = self;
        _miniTestTableView.dataSource = self;
        _miniTestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_miniTestTableView setBackgroundColor:[UIColor clearColor]];
        [_miniTestTableView setContentInset:UIEdgeInsetsMake(0, 0, 32 / CP_GLOBALSCALE, 0)];
    }
    return _miniTestTableView;
}
@end
