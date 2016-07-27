//
//  DynamicSystemVC.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicSystemVC.h"
#import "DynamicSystemVM.h"
#import "DynamicSystemNewCell.h"
#import "DynamicSystemModelDTO.h"
#import "DynamicSystemDetailVC.h"
#import "CPRecommendModelFrame.h"
#import "CPProfileCompanyMessageCell.h"
#import "RTNetworking+DynamicState.h"
#import "CPCommon.h"
typedef NS_ENUM(NSUInteger, CPTestButtonType)
{
    CPTestButtonPositionTest,
    CPTestButtonMiniTest
};

@interface DynamicSystemVC ()<UIWebViewDelegate>

@property(nonatomic,retain) DynamicSystemVM *viewModel;

@property (nonatomic, strong) UIView *topBackgroundView;
@property (nonatomic, strong) UIButton *positionTestButton;
@property (nonatomic, strong) UIButton *miniTestButton;
@property (nonatomic, strong) UIView *selectedSeparatorLine;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UITableView *miniTestTableView;
@property (nonatomic, strong) UIButton *selectedTestButton;
@property (nonatomic, strong) NSMutableArray *systemMessageArrayM;
@property(nonatomic,strong)UITableView *currentTableView;
@property(nonatomic,assign)NSInteger companyPage;//企业当前页面
@property(nonatomic,assign)NSInteger systemPage;//系统当前页面


//企业消息错误显示界面
@property(nonatomic,strong)UIImageView     *errorImgView;
@property(nonatomic,strong)UILabel     *secondLable;
@property (nonatomic, strong) UIButton *reloadBtn;

//系统消息错误显示界面
@property(nonatomic,strong)UIImageView   *systemErrorImgView;
@property(nonatomic,strong)UILabel     *systemSecondLable;
@property (nonatomic, strong) UIButton *systemReloadBtn;
@property(nonatomic,assign)BOOL networkError;//标记是否有网络
@property(nonatomic,assign)BOOL sysNetworkError;//标记是否有网络
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,strong)TBLoading *load;
@property (nonatomic, strong) NSNumber *opetion;
@end

@implementation DynamicSystemVC

-(instancetype)init
{
    if (self = [super init])
    {
        self.viewModel = [DynamicSystemVM new];
        self.opetion = @0;
        return self;
    }
    return nil;
}
- (instancetype)initWithOpetion:(NSNumber *)opetion
{
    self = [self init];
    if ( self )
    {
        self.opetion = opetion;
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ( [self.dynamicSystemDelegate respondsToSelector:@selector(dynamicSystemVCNotify)] )
    {
        [self.dynamicSystemDelegate dynamicSystemVCNotify];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    self.companyPage = 1;
    self.systemPage = 1;
    self.networkImage.image = [UIImage imageNamed:@"ic_error"];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    
    [self.view addSubview:self.topBackgroundView];
    self.topBackgroundView.frame = CGRectMake(0, 64.0, kScreenWidth, 150 / CP_GLOBALSCALE);
    
    [self createProfileTableView];
    self.tableView.dataSource = self;
     [self.tableView setContentInset:UIEdgeInsetsMake(0, 0,  32 / CP_GLOBALSCALE, 0)];
    [self.view addSubview:self.backgroundScrollView];
    
    [self.backgroundScrollView addSubview:self.tableView];
    [self.backgroundScrollView addSubview:self.miniTestTableView];
    
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth * 2.0, self.view.viewHeight - 150 / CP_GLOBALSCALE - 64)];
    
    /**
     *
     *未获取到数据的错误提示页面
     */
    self.errorImgView = [[UIImageView alloc]initWithImage:UIIMAGE(@"ic_error")];
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
    self.secondLable.text = @"当前网络不可用，请检查网络设置";
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
    [self.reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.tableView addSubview:self.reloadBtn];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.secondLable.mas_bottom).offset(60/CP_GLOBALSCALE);
        make.width.equalTo(@(330/CP_GLOBALSCALE));
        make.height.equalTo(@(120/CP_GLOBALSCALE));
    }];
    self.reloadBtn.hidden = YES;
    
    //职位测聘错误显示界面
    self.systemErrorImgView = [[UIImageView alloc]initWithImage:UIIMAGE(@"ic_error")];
    [self.self.miniTestTableView addSubview:self.systemErrorImgView];
    [self.systemErrorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.miniTestTableView.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+366/CP_GLOBALSCALE);
        make.width.equalTo(@(280/CP_GLOBALSCALE));
        make.height.equalTo(@(280/CP_GLOBALSCALE));
    }];
    self.systemErrorImgView.hidden  = YES;
    
    self.systemSecondLable = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.miniTestTableView addSubview:self.systemSecondLable];
    [self.systemSecondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.miniTestTableView.mas_centerX);
        make.top.equalTo(self.systemErrorImgView.mas_bottom).offset(90/CP_GLOBALSCALE);
        make.left.equalTo(self.miniTestTableView.mas_left).offset(40/CP_GLOBALSCALE);
        make.right.equalTo(self.miniTestTableView.mas_right).offset(-40/CP_GLOBALSCALE);
        make.height.equalTo(@(60));
    }];
    self.systemSecondLable.backgroundColor = [UIColor clearColor];
    self.systemSecondLable.text = @"当前网络不可用，请检查网络设置";
    self.systemSecondLable.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE] ;
    self.systemSecondLable.textColor = [UIColor colorWithHexString:@"404040"];
    self.systemSecondLable.textAlignment = NSTextAlignmentCenter;
    [self.systemSecondLable setNumberOfLines:0];
    //注意这里UILabel的numberoflines(即最大行数限制)设置成0，即不做行数限制。
    [self.systemSecondLable setLineBreakMode:NSLineBreakByWordWrapping];
    self.systemSecondLable.hidden = YES;
    
    self.systemReloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.systemReloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.systemReloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [self.systemReloadBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [self.systemReloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.systemReloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateSelected];
    [self.systemReloadBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    [self.systemReloadBtn.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [self.systemReloadBtn.layer setMasksToBounds:YES];
    [self.systemReloadBtn.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [self.systemReloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.miniTestTableView addSubview:self.systemReloadBtn];
    [self.systemReloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.miniTestTableView.mas_centerX);
        make.top.equalTo(self.systemSecondLable.mas_bottom).offset(60/CP_GLOBALSCALE);
        make.width.equalTo(@(330/CP_GLOBALSCALE));
        make.height.equalTo(@(120/CP_GLOBALSCALE));
    }];
    self.systemReloadBtn.hidden = YES;
    [self.reloadBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        if (self.networkError) {
            self.companyPage = 0;
            [self updateTable];
        }
    }];
    
    [self.systemReloadBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if (self.sysNetworkError) {
            self.systemPage=0;
            [self updateTable];
        }
    }];
    NSString *strUser = [[MemoryCacheData shareInstance] userId];
    NSString *strTocken = [[MemoryCacheData shareInstance] userTokenId];
    if(!strTocken){
        strTocken = @"";
        strUser = @"";
    }
    
    if (!self.isLoad) {
        self.load = [TBLoading new];
        [self.load start];
        self.isLoad = NO;
    }
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *companyOperation = [NSBlockOperation blockOperationWithBlock:^{
        RACSignal *companySignal = [[RTNetworking shareInstance] getMessageListWithTokenId:strTocken userId:strUser PageIndex:0 PageSize:10 messageStatus:@"2"];
        @weakify(self);
        [companySignal subscribeNext:^(RACTuple *tuple){
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)tuple.second;
            self.networkError = NO;
            if ([dic resultSucess])
            {
                NSArray *array = [dic resultObject];
                if (array)
                {
                    [self.viewModel.datas addObjectsFromArray:array];
                    [self.tableView reloadData];
                    [self HideErrorViewWithType:1];
                    [self stopUpdate];
                    [self stopUpdateAnimation];
                }else{
                    if([@"" isEqualToString:strUser]){
                        [self showErrorViewWithContent:@"登录异常，请重新登录" type:1];
                    }else{
                        [self showErrorViewWithContent:@"没有更多数据了" type:1];
                    }
                    
                }
            }else{
                if([@"" isEqualToString:strUser]){
                    [self showErrorViewWithContent:@"登录异常，请重新登录" type:1];
                }else{
                    [self showErrorViewWithContent:@"没有更多数据了" type:1];
                }
            }
        } error:^(NSError *error){
            [self stopUpdate];
            self.networkError = YES;
            [self showErrorViewWithContent:@"当前网络不可用，请检查当前网络设置" type:1];
        }];
    }];
    NSBlockOperation *systemOperation = [NSBlockOperation blockOperationWithBlock:^{
        RACSignal *systemSignal = [[RTNetworking shareInstance] getMessageListWithTokenId:strTocken userId:strUser PageIndex:0 PageSize:10 messageStatus:@"1"];
        @weakify(self);
        [systemSignal subscribeNext:^(RACTuple *tuple){
            @strongify(self);
            if (self.load)
            {
                [self.load stop];
            }
            NSDictionary *dic = (NSDictionary *)tuple.second;
            self.sysNetworkError = NO;
            [self stopUpdateAnimation];
            [self stopUpdate];
            if ([dic resultSucess])
            {
                NSArray *array = [dic resultObject];
                if (array)
                {
                    [self.systemMessageArrayM addObjectsFromArray:array];
                    [self.miniTestTableView reloadData];
                    [self HideErrorViewWithType:2];
                    if ( [self.opetion intValue] != 0 )
                    {
                        [self changeTest:self.miniTestButton];
                    }
                }else{
                    if([@"" isEqualToString:strUser]){
                        [self showErrorViewWithContent:@"登录异常，请重新登录" type:2];
                    }else{
                        [self showErrorViewWithContent:@"没有更多数据了" type:2];
                    }
                }
            }else{
                if([@"" isEqualToString:strUser]){
                    [self showErrorViewWithContent:@"登录异常，请重新登录" type:2];
                }else{
                    [self showErrorViewWithContent:@"没有更多数据了" type:2];
                }
            }
        } error:^(NSError *error){
            if (self.load)
            {
                [self.load stop];
            }
            [self stopUpdateAnimation];
            self.sysNetworkError = YES;
            [self showErrorViewWithContent:@"当前网络不可用，请检查网络设置" type:2];
        }];
    }];
    [systemOperation addDependency:companyOperation];
    [operationQueue addOperation:companyOperation];
    [operationQueue addOperation:systemOperation];
    [self setupDropDownScrollView];
    __weak BaseTableViewController *mainvc = self;
    self.miniTestTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [mainvc updateTable];
    }];
}
- (void)clickNetWorkButton
{
    [self refleshTable];
}
-(void)refleshTable
{
}
-(void)showErrorViewWithContent:(NSString *)content type:(NSInteger)type{
    if(type==1){
        self.errorImgView.hidden = NO;
        self.secondLable.hidden = NO;
        self.reloadBtn.hidden = NO;
        self.secondLable.text = content;
        if ([content isEqualToString:@"没有更多数据了"]) {
            self.reloadBtn.hidden  = YES;
             self.errorImgView.image = [UIImage imageNamed:@"null_info"];
        }else{
            self.errorImgView.image = [UIImage imageNamed:@"null_exam_linkbroken"];
        }
        
    }else{
        self.systemErrorImgView.hidden = NO;
        self.systemSecondLable.hidden = NO;
        self.systemReloadBtn.hidden = NO;
        self.systemSecondLable.text = content;
        if ([content isEqualToString:@"没有更多数据了"]) {
            self.systemReloadBtn.hidden  = YES;
            self.systemErrorImgView.image = [UIImage imageNamed:@"null_info"];
        }else{
            self.systemErrorImgView.image = [UIImage imageNamed:@"null_exam_linkbroken"];
        }
    }
}
-(void)HideErrorViewWithType:(NSInteger)type{
    
    if(type==1){
        self.errorImgView.hidden = YES;
        self.secondLable.hidden = YES;
        self.reloadBtn.hidden = YES;
    }else{
        self.systemErrorImgView.hidden = YES;
        self.systemSecondLable.hidden = YES;
        self.systemReloadBtn.hidden = YES;
    }
    
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
        RACSignal *companySignal = [[RTNetworking shareInstance] getMessageListWithTokenId:strTocken userId:strUser PageIndex:self.companyPage PageSize:10 messageStatus:@"2"];
        @weakify(self);
        [companySignal subscribeNext:^(RACTuple *tuple){
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
                    [self HideErrorViewWithType:1];
                }else{
                    if (self.companyPage==1) {
                        [self showErrorViewWithContent:@"没有更多数据了" type:1];
                    }
                }
            }else{
                if (self.companyPage==1) {
                    [self showErrorViewWithContent:@"没有更多数据了" type:1];
                }
                self.companyPage--;
                [self loadEnd];
            }
        } error:^(NSError *error){
           [self endUpdate];
            self.networkError = YES;
            if (self.companyPage==1) {
                [self showErrorViewWithContent:@"当前网络不可用，请检查当前网络设置" type:1];
            }
            self.companyPage--;
        }];
    }else if (self.currentTableView == self.miniTestTableView ){
        self.systemPage++;
        RACSignal *systemSignal = [[RTNetworking shareInstance] getMessageListWithTokenId:strTocken userId:strUser PageIndex:self.systemPage PageSize:10 messageStatus:@"1"];
        @weakify(self);
        [systemSignal subscribeNext:^(RACTuple *tuple){
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)tuple.second;
            self.sysNetworkError = NO;
            if ([dic resultSucess])
            {
                NSArray *array = [dic resultObject];
                if (array)
                {
                    [self.systemMessageArrayM addObjectsFromArray:array];
                    [self stopUpdate];
                    [self HideErrorViewWithType:2];
                    
                }else{
                    if (self.systemPage==1) {
                        [self showErrorViewWithContent:@"没有更多数据了" type:2];
                    }
                }
            }else{
                if (self.systemPage==1) {
                    [self showErrorViewWithContent:@"没有更多数据了" type:2];
                }
                self.systemPage--;
                [self loadEnd];
                
            }
        } error:^(NSError *error){
            
             [self endUpdate];
            self.sysNetworkError = YES;
            if (self.systemPage==1) {
                [self showErrorViewWithContent:@"当前网络不可用，请检查当前网络设置" type:2];
            }
            self.systemPage--;
        }];

    }
//    [self.viewModel nextPage];
}

-(void)stopUpdate{
//    [self stopUpdateAnimation];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.currentTableView.mj_footer endRefreshing];
    });
    self.viewModel.isLoading = NO;
//    self.networkImage.hidden = YES;
//    self.networkLabel.hidden = YES;
//    self.networkButton.hidden = YES;
//    self.clickImage.hidden = YES;
    self.currentTableView.hidden = NO;
    [self.currentTableView reloadData];
}


-(void)loadEnd{
    self.viewModel.isLoading = NO;
//    self.networkImage.hidden = YES;
//    self.networkLabel.hidden = YES;
//    self.networkButton.hidden = YES;
//    self.clickImage.hidden = YES;
    self.currentTableView.hidden = NO;
    MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)self.currentTableView.mj_footer;
    [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
    self.currentTableView.mj_footer = footer;
    [self.currentTableView.mj_footer endRefreshingWithNoMoreData];
}

-(void)endUpdate{
//    self.networkImage.hidden = NO;
//    self.networkLabel.hidden = NO;
//    self.networkButton.hidden = NO;
//    self.clickImage.hidden = NO;
//    self.currentTableView.hidden = YES;
    [self.currentTableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = ( 40 + 60  + 36 + 60 + 20 ) / CP_GLOBALSCALE;
    CGFloat maxW = kScreenWidth - ( 80 +40 * 2 ) / CP_GLOBALSCALE;
    NSString *title = nil;
    if ( tableView == self.tableView ){
        DynamicSystemModelDTO *bean = [DynamicSystemModelDTO beanFromDictionary:self.viewModel.datas[indexPath.row]];
        title = bean.Title;

    }
    else if ( tableView == self.miniTestTableView ){
        DynamicSystemModelDTO *bean = [DynamicSystemModelDTO beanFromDictionary:self.systemMessageArrayM[indexPath.row]];
        title = bean.Title;
    }
//    CPProfileCompanyMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
    // 根据获取到的字符串以及字体计算label需要的size
   CGSize strSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
//    CGSize size = [title boundingRectWithSize:CGSizeMake(320, 0)];
    return rowHeight+strSize.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.currentTableView = tableView;
    if ( tableView == self.tableView )
        return self.viewModel.datas.count;
    else if ( tableView == self.miniTestTableView )
        return self.systemMessageArrayM.count;
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentTableView = tableView;
    if ( tableView == self.miniTestTableView )
    {
        DynamicSystemModelDTO *bean = [DynamicSystemModelDTO beanFromDictionary:self.systemMessageArrayM[indexPath.row]];
        CPProfileCompanyMessageCell *cell = [CPProfileCompanyMessageCell companyMessageCellWithTabelView:tableView];
        [cell configeCellWith:bean];
        return cell;
    }
    else
    {
        DynamicSystemModelDTO *bean = [DynamicSystemModelDTO beanFromDictionary:self.viewModel.datas[indexPath.row]];
        CPProfileCompanyMessageCell *cell = [CPProfileCompanyMessageCell companyMessageCellWithTabelView:tableView];
        [cell configeCellWith:bean];
        return cell;
    }
}
#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self.tableView )
    {
        DynamicSystemModelDTO *bean = [DynamicSystemModelDTO beanFromDictionary:self.viewModel.datas[indexPath.row]];
        DynamicSystemDetailVC *vc = [[DynamicSystemDetailVC alloc] initWithBean:bean];
        [self.navigationController pushViewController:vc animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else if ( tableView == self.miniTestTableView )
    {
        DynamicSystemModelDTO *bean = [DynamicSystemModelDTO beanFromDictionary:self.systemMessageArrayM[indexPath.row]];
        DynamicSystemDetailVC *vc = [[DynamicSystemDetailVC alloc] initWithBean:bean];
        [self.navigationController pushViewController:vc animated:YES];
        [self.miniTestTableView deselectRowAtIndexPath:indexPath animated:NO];
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
- (void)dealloc
{
     [self.tableView.mj_footer removeFromSuperview];
    [self.tableView.mj_header removeFromSuperview];
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
        self.currentTableView = self.tableView;
        [UIView animateWithDuration:0.15 animations:^{
            weakSelf.selectedSeparatorLine.viewX = 0;
//            [weakSelf.backgroundScrollView scrollRectToVisible:CGRectMake(weakSelf.backgroundScrollView.viewX, weakSelf.backgroundScrollView.viewY, kScreenWidth, weakSelf.backgroundScrollView.viewHeight) animated:YES];
        }];
        
        if ( 0 != weakSelf.backgroundScrollView.contentOffset.x )
            [weakSelf.backgroundScrollView setContentOffset:CGPointMake(0, 0)];
    }
    else
    {
        self.currentTableView = self.miniTestTableView;
        [UIView animateWithDuration:0.15 animations:^{
            weakSelf.selectedSeparatorLine.viewX = kScreenWidth / 2.0;
//            [weakSelf.backgroundScrollView scrollRectToVisible:CGRectMake(weakSelf.backgroundScrollView.viewX + kScreenWidth, weakSelf.backgroundScrollView.viewY, kScreenWidth, weakSelf.backgroundScrollView.viewHeight) animated:YES];
        }];
        
        if ( kScreenWidth != weakSelf.backgroundScrollView.contentOffset.x )
            [weakSelf.backgroundScrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
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
        [_positionTestButton setTitle:@"企业消息" forState:UIControlStateNormal];
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
        [_miniTestButton setTitle:@"系统消息" forState:UIControlStateNormal];
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
- (NSMutableArray *)systemMessageArrayM
{
    if ( !_systemMessageArrayM )
    {
        _systemMessageArrayM = [NSMutableArray array];
    }
    return _systemMessageArrayM;
}
@end
