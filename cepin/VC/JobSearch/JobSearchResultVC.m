//
//  JobSearchResultVC.m
//  cepin
//
//  Created by dujincai on 15/5/21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobSearchResultVC.h"
#import "JobSearchVM.h"
#import "JobSearchTitleCell.h"
#import "JobSearchContentCell.h"
#import "JobSearchResultCell.h"
#import "JobModelDTO.h"
#import "NewJobDetialVC.h"
#import "SubscriptionJobVC.h"
#import "UIViewController+NavicationUI.h"
#import "TBTextUnit.h"
#import "BookingJobFilterModel.h"
#import "JobSearchTitleCell.h"
#import "JobSearchModel.h"
#import "JobSearchVC.h"
#import "PositionIdModel.h"
#import "RecommendCell.h"
#import "CPRecommendModelFrame.h"
#import "CPRecommendCell.h"
#import "CPCommon.h"
#import "CPSearchFilterView.h"
#import "CPSearchTextField.h"
#import "CPSearchMoreFilterView.h"
#import "CPSearchCityFilterView.h"
#import "CPHomeGuessCell.h"
#import "CPHomePositionDetailController.h"
#import "CPSearchMatchDTO.h"
#import "RTNetworking+Position.h"
#import "CPSearchMatchCell.h"
#import "CPSearchDefaultBean.h"
#import "CPSearchWithRightTextField.h"
#import "CPSearchFuzzaMatchCell.h"
#import "CPPinyin.h"
#import "CPChineseString.h"
#import "TBAppDelegate.h"
@interface JobSearchResultVC ()<UITextFieldDelegate,UIGestureRecognizerDelegate,SubscriptionJobVCDelegate, CPSearchFilterDelegate,filterChangeDeleger>
@property (nonatomic, strong) JobSearchVM *viewModel;
@property (nonatomic, strong) UIImageView *errorImgView;
@property (nonatomic, strong) UILabel *secondLable;
@property (nonatomic, strong) CPSearchWithRightTextField *textSearch;
@property (nonatomic, assign) NSInteger countdata;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UITapGestureRecognizer *pan;
@property (nonatomic, strong) CPSearchFilterView *searchFilterView;
@property (nonatomic, strong) NSArray *topButtonTitleArray;
@property (nonatomic, strong) CPSearchMoreFilterView *searchMoreFilterView;
@property (nonatomic, strong) UITableView *searchMatchTableView;
@property (nonatomic, copy) NSArray *tempSearchMatchArray;
@property (nonatomic, strong) NSString  *matchString;
@property (nonatomic, assign) BOOL isCity;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSIndexPath *customSelectIndexPath;
@end
@implementation JobSearchResultVC
- (instancetype)initWithKeyWord:(NSString *)keyWord
{
    self = [super init];
    if (self) {
        self.viewModel = [JobSearchVM new];
        self.viewModel.keyword = keyWord;
        TBAppDelegate *appdelagate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
        if (nil == appdelagate.homeCity || NULL == appdelagate.homeCity || !appdelagate.homeCity)
        {
            NSString *locationCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCity"];
            locationCity = @"广州";
            //获取当前城市对象
            if( nil==locationCity || [locationCity isEqualToString:@""] )
            {
                locationCity=@"全国";
                self.viewModel.subModel.address = locationCity;
                self.viewModel.subModel.addresskey = @"";
            }
            else
            {
                Region *locationRegion = [Region searchAddressWithAddressString:locationCity];
                if (nil != locationCity) {
                    self.viewModel.subModel.address = locationRegion.RegionName;
                    self.viewModel.subModel.addresskey = locationRegion.PathCode;
                }
                
            }
        }
        else
        {
            if([@"全国" isEqualToString:appdelagate.homeCity]){
                self.viewModel.subModel.address = appdelagate.homeCity;
                self.viewModel.subModel.addresskey = @"";

            }else{
                Region *locationRegion = [Region searchAddressWithAddressString:appdelagate.homeCity];
                if (nil != appdelagate.homeCity) {
                    self.viewModel.subModel.address = locationRegion.RegionName;
                    self.viewModel.subModel.addresskey = locationRegion.PathCode;
                }

            }
            
        }
       
    }
    return self;
}
- (instancetype)initWithCity:(NSString *)city patchCode:(NSString *)code{
    self = [super init];
    if (self) {
        self.viewModel = [JobSearchVM new];
        self.viewModel.keyword = @"";
        if(!code || nil == code || [@"" isEqualToString:code]){
            TBAppDelegate *appdelagate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            if (nil == appdelagate.homeCity || NULL == appdelagate.homeCity || !appdelagate.homeCity)
            {
                NSString *locationCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCity"];
                locationCity = @"广州";
                //获取当前城市对象
                if( nil==locationCity || [locationCity isEqualToString:@""] )
                {
                    locationCity=@"全国";
                    self.viewModel.subModel.address = locationCity;
                    self.viewModel.subModel.addresskey = @"";
                }
                else
                {
                    Region *locationRegion = [Region searchAddressWithAddressString:locationCity];
                    if (nil != locationCity) {
                        self.viewModel.subModel.address = locationRegion.RegionName;
                        self.viewModel.subModel.addresskey = locationRegion.PathCode;
                    }
                    
                }
            }
            else
            {
                if([@"全国" isEqualToString:appdelagate.homeCity]){
                    self.viewModel.subModel.address = appdelagate.homeCity;
                    self.viewModel.subModel.addresskey = @"";
                    
                }else{
                    Region *locationRegion = [Region searchAddressWithAddressString:appdelagate.homeCity];
                    if (nil != appdelagate.homeCity) {
                        self.viewModel.subModel.address = locationRegion.RegionName;
                        self.viewModel.subModel.addresskey = locationRegion.PathCode;
                    }
                    
                }
                
            }
        }else{
            self.viewModel.subModel.address = city;
            self.viewModel.subModel.addresskey = code;
        }
       
        self.isCity = YES;
    }
    return self;
}
-(instancetype)initWithKeyWord:(NSString *)keyWord city:(NSString *)city JobFunction:(NSString *)JobFunction Salary:(NSString *)Salary PositionType:(NSString *)PositionType EmployType:(NSString *)EmployType WorkYear:(NSString *)WorkYear Degree:(NSString *)Degree{
    self = [super init];
    if (self) {
        self.viewModel = [JobSearchVM new];
        self.viewModel.keyword = keyWord;
        self.viewModel.subModel.DegreeStr = Degree;
        self.viewModel.subModel.jobFunctions = JobFunction;
        self.viewModel.subModel.salary = Salary;
        self.viewModel.subModel.salarykey = Salary;
        
        if(nil != Degree){
            if([Degree isEqualToString:@"中专及以下"]){
                self.viewModel.subModel.Degree = @"12";
            }else if([Degree isEqualToString:@"大专"]){
                self.viewModel.subModel.Degree = @"13";
            }else if([Degree isEqualToString:@"本科"]){
                self.viewModel.subModel.Degree = @"14";
            }else if([Degree isEqualToString:@"MBA"]){
                self.viewModel.subModel.Degree = @"15";
            }else if([Degree isEqualToString:@"硕士"]){
                self.viewModel.subModel.Degree = @"16";
            }else if([Degree isEqualToString:@"博士及以上"]){
                self.viewModel.subModel.Degree = @"17";
            }else if([Degree isEqualToString:@"EMBA"]){
                self.viewModel.subModel.Degree = @"7065";
            }else{
                self.viewModel.subModel.Degree = @"";
            }
        }
        
        if (EmployType && [EmployType isEqualToString:@"全职"]) {
            self.viewModel.subModel.jobPropertyskey = @"1";
            self.viewModel.subModel.jobPropertys = EmployType;
        }else if(EmployType && [EmployType isEqualToString:@"实习"]){
            self.viewModel.subModel.jobPropertyskey = @"4";
            self.viewModel.subModel.jobPropertys = EmployType;
        }
        self.viewModel.subModel.workYear = WorkYear;
        if(WorkYear&& ![@"" isEqualToString:WorkYear] ){
            NSArray *array = [WorkYear componentsSeparatedByString:@"~"];
            if(array.count>1){
                self.viewModel.subModel.workYearMin = array[0];
                self.viewModel.subModel.workYearMax = array[1];
                if([array[0] isEqualToString:@"-1"]){
                    self.viewModel.subModel.workYear = @"1年以下";
                }else{
                    self.viewModel.subModel.workYear = [NSString stringWithFormat:@"%@-%@年",array[0],array[1]];
                }
            }else{
                self.viewModel.subModel.workYearMin = WorkYear;
                self.viewModel.subModel.workYearMax = WorkYear;
                if ([WorkYear isEqualToString:@"0"]) {
                    self.viewModel.subModel.workYear = @"应届生";
                }else if([WorkYear isEqualToString:@"-1"]){
                    self.viewModel.subModel.workYear = @"在读学生";
                }
                
            }
            
        }else{
            self.viewModel.subModel.workYearMin = @"";
            self.viewModel.subModel.workYearMax = @"";

        }
        if(!city || nil == city || [@"" isEqualToString:city]){
            TBAppDelegate *appdelagate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            if (nil == appdelagate.homeCity || NULL == appdelagate.homeCity || !appdelagate.homeCity)
            {
                NSString *locationCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCity"];
                locationCity = @"广州";
                //获取当前城市对象
                if( nil==locationCity || [locationCity isEqualToString:@""] )
                {
                    locationCity=@"全国";
                    self.viewModel.subModel.address = locationCity;
                    self.viewModel.subModel.addresskey = @"";
                }
                else
                {
                    Region *locationRegion = [Region searchAddressWithAddressString:locationCity];
                    if (nil != locationCity) {
                        self.viewModel.subModel.address = locationRegion.RegionName;
                        self.viewModel.subModel.addresskey = locationRegion.PathCode;
                    }
                    
                }
            }
            else
            {
                if([@"全国" isEqualToString:appdelagate.homeCity]){
                    self.viewModel.subModel.address = appdelagate.homeCity;
                    self.viewModel.subModel.addresskey = @"";
                    
                }else{
                    Region *locationRegion = [Region searchAddressWithAddressString:appdelagate.homeCity];
                    if (nil != appdelagate.homeCity) {
                        self.viewModel.subModel.address = locationRegion.RegionName;
                        self.viewModel.subModel.addresskey = locationRegion.PathCode;
                    }
                    
                }
                
            }
        }else{
            self.viewModel.subModel.address = city;
            Region *region = [Region searchAddressWithAddressString:city];
            if (region) {
                self.viewModel.subModel.addresskey = region.PathCode;
            }
        }
        self.viewModel.subModel.positionType = PositionType;
        if (PositionType && [PositionType isEqualToString:@"社会招聘"]) {
            self.viewModel.subModel.positionTypekey = @"2";
        }else if(PositionType && [PositionType isEqualToString:@"校园招聘"]){
            self.viewModel.subModel.positionTypekey = @"1";
        }
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.textSearch;
    [self.viewModel allPositionId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( self.customSelectIndexPath )
            {
                NSArray *indexPathArray = [NSArray arrayWithObject:self.customSelectIndexPath];
                [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                self.customSelectIndexPath = nil;
            }
        });
    });
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textSearch endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
#pragma mark--城市筛选
-(void)cityselect:(Region *)cityRegion selectBtn:(UIButton *)selectBtn{
    [self.view endEditing:YES];
    NSLog(@"%@",cityRegion.RegionName);
    self.viewModel.subModel.address = cityRegion.RegionName;
    self.viewModel.subModel.addresskey = cityRegion.PathCode;
    [selectBtn setTitle:cityRegion.RegionName forState:UIControlStateNormal];
    
    [selectBtn setTitleColor:[UIColor colorWithHexString:@"288add"]  forState:UIControlStateNormal];
    [selectBtn setTitle:cityRegion.RegionName forState:UIControlStateNormal];
    [self refleshTable];
    [MobClick event:@"working_place_succeed"];
}

#pragma mark 薪酬筛选
-(void)salarySelect:(NSString *)salary selectBtn:(UIButton *)selectBtn{
    [self.view endEditing:YES];
    if([salary isEqualToString:@"全部"]){
        self.viewModel.subModel.salary = @"";
        self.viewModel.subModel.salarykey = @"";
    }else{
        if([salary isEqualToString:@"25K以上"]){
            self.viewModel.subModel.salary = @"25K以上";
            self.viewModel.subModel.salarykey = @"25K-100K";
        }else{
            self.viewModel.subModel.salary = salary;
            self.viewModel.subModel.salarykey = salary;
        }
        
    }
    [selectBtn setTitleColor:[UIColor colorWithHexString:@"288add"]  forState:UIControlStateNormal];
    [selectBtn setTitle:salary forState:UIControlStateNormal];
    [self refleshTable];
    [MobClick event:@"expected_salary_succeed"];
}
#pragma mark 更多筛选
-(void)moreSure{
    [self.view endEditing:YES];
    [self refleshTable];
}
#pragma mark 工作年限筛选
-(void)workSelect:(NSString *)workYear selectBtn:(UIButton *)selectBtn{
    [self.view endEditing:YES];
    if ([workYear isEqualToString:@"全部"]) {
        self.viewModel.subModel.workYear = @"";
        self.viewModel.subModel.workYearkey = @"";
    }else if([workYear isEqualToString:@"在读学生"]){
        self.viewModel.subModel.workYear = @"在读学生";
        self.viewModel.subModel.workYearkey = @"-1";
    }else if([workYear isEqualToString:@"应届生"]){
        self.viewModel.subModel.workYear = @"应届生";
        self.viewModel.subModel.workYearkey = @"0";
    }else if([workYear isEqualToString:@"1年以下"]){
        self.viewModel.subModel.workYear = @"1年以下";
        self.viewModel.subModel.workYearkey = @"-1~1";
    }else if([workYear isEqualToString:@"1-3年"]){
        self.viewModel.subModel.workYear = @"1-3年";
        self.viewModel.subModel.workYearkey = @"1~3";
    }else if([workYear isEqualToString:@"3-5年"]){
        self.viewModel.subModel.workYear = @"3-5年";
        self.viewModel.subModel.workYearkey = @"3~5";
    }else if([workYear isEqualToString:@"5-7年"]){
        self.viewModel.subModel.workYear = @"5-7年";
        self.viewModel.subModel.workYearkey = @"5~7";
    }else if([workYear isEqualToString:@"7-10年"]){
        self.viewModel.subModel.workYear = @"7-10年";
        self.viewModel.subModel.workYearkey = @"7~10";
    }else{
        self.viewModel.subModel.workYear = @"10年以上";
        self.viewModel.subModel.workYearkey = @"10~100";
    }
    [selectBtn setTitleColor:[UIColor colorWithHexString:@"288add"]  forState:UIControlStateNormal];
    [selectBtn setTitle:workYear forState:UIControlStateNormal];
    [self refleshTable];
    [MobClick event:@"working_year_succeed"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [MobClick event:@"into_result_of_find"];
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0 + 120 / CP_GLOBALSCALE, self.view.viewWidth, (self.view.viewHeight) - 64.0 - 120 / CP_GLOBALSCALE) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] shadeColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    /**
     *
     *未获取到数据的错误提示页面
     */
    self.errorImgView = [[UIImageView alloc]initWithImage:UIIMAGE(@"null_job")];
    [self.view addSubview:self.errorImgView];
    [self.errorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+366/CP_GLOBALSCALE);
        make.width.equalTo(@(280/CP_GLOBALSCALE));
        make.height.equalTo(@(280/CP_GLOBALSCALE));
    }];
    self.errorImgView.hidden  = YES;
    self.secondLable = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.secondLable];
    [self.secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.errorImgView.mas_bottom).offset(90/CP_GLOBALSCALE);
        make.width.equalTo(@(self.view.viewWidth));
        make.left.equalTo(self.view.mas_left).offset(40/CP_GLOBALSCALE);
        make.right.equalTo(self.view.mas_right).offset(-40/CP_GLOBALSCALE);
        make.height.equalTo(@(60));
    }];
    self.secondLable.backgroundColor = [UIColor clearColor];
    self.secondLable.text = @"没有符合的搜索条件的职位，换个职位看看";
    self.secondLable.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE] ;
    self.secondLable.textColor = [UIColor colorWithHexString:@"404040"];
    self.secondLable.textAlignment = NSTextAlignmentCenter;
    self.secondLable.hidden = YES;
    self.secondLable.numberOfLines = 0;
    self.secondLable.lineBreakMode = NSLineBreakByWordWrapping;
    [self.searchFilterView configTopButtonWithTitles:self.topButtonTitleArray];
    [self.view addSubview:self.searchFilterView];
    self.searchFilterView.filterChangeDeleger = self;
    [self.searchFilterView setBackgroundColor:[UIColor clearColor]];
    self.searchFilterView .viewHeight = 120/CP_GLOBALSCALE*2;
    [self.view addSubview:self.searchMatchTableView];
    @weakify(self)
    //监听刷新工作搜索的刷新
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if (!stateCode)
        {
            return ;
        }
        switch ([self requestStateWithStateCode:stateCode])
        {
            case HUDCodeDownloading:
                self.viewModel.isLoading = NO;
                [self startRefleshAnimation];
                break;
            case HUDCodeLoadMore:
                self.viewModel.isLoading = YES;
                [self startUpdateAnimation];
                break;
            case HUDCodeReflashSucess:
            { [self stopRefleshAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                self.tableView.hidden = NO;
                self.errorImgView.hidden = YES;
                self.secondLable.hidden = YES;
                self.pan.enabled = YES;
            }
                break;
            case hudCodeUpdateSucess:
            {
                [self stopUpdateAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                self.tableView.hidden = NO;
                self.errorImgView.hidden = YES;
                self.secondLable.hidden = YES;
            }
                break;
            case HUDCodeNone:
            {
                [self stopRefleshAnimation];
                self.viewModel.isLoading = NO;
                if ( [self.viewModel.datas count] == 0 )
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.errorImgView.hidden = NO;
                        self.tableView.hidden = YES;
                        self.secondLable.hidden = NO;
                    });
                }
                MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)self.tableView.mj_footer;
                [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
                self.tableView.mj_footer = footer;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
                break;
            case HUDCodeNetWork:
            {
                self.pan.enabled = NO;
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.networkButton.hidden = NO;
                self.clickImage.hidden = NO;
                self.errorImgView.hidden = YES;
                self.secondLable.hidden = YES;
                self.tableView.hidden = YES;
            }
                break;
            default:
                [self stopRefleshAnimation];
                [self stopUpdateAnimation];
                self.viewModel.isLoading = NO;
                break;
        }
    }];
    [self setupDropDownScrollView];
    [self refleshTable];
    self.pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClick)];
    [self.view addGestureRecognizer:self.pan];
    self.pan.delegate = self;
    [self getSearDefault];
    [self initHotCity];
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
#pragma mark 获取默认的搜索关键字
-(void)getSearDefault
{
    RACSignal *signal = [[RTNetworking shareInstance]getSearchDefaultKey];
    [signal subscribeNext:^(RACTuple *racResult) {
        NSDictionary *dict = (NSDictionary *)racResult.second;
        if([dict resultSucess])
        {
            NSArray *dada = [dict resultObject];
            if( dada )
            {
                CPSearchDefaultBean *searchDefault =  [CPSearchDefaultBean beanFromDictionary:dada[0]];
                if (searchDefault) {
                    self.defaultSearchText = searchDefault.Title;
                    self.textSearch.placeholder =  self.defaultSearchText;
                }
            }
        }
    }];
}
- (void)clickNetWorkButton
{
    self.errorImgView.hidden = YES;
    self.secondLable.hidden = YES;
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self refleshTable];
}
- (void)popViewController
{
    [self refleshTable];
}
- (void)didClick
{
    [self.textSearch resignFirstResponder];
    if (self.viewModel.datas.count > 0) {
        self.tableView.hidden = NO;
        self.secondLable.hidden = YES;
        self.errorImgView.hidden = YES;
    }else
    {
        self.tableView.hidden = YES;
        self.errorImgView.hidden = NO;
        self.secondLable.hidden = NO;
    }
}
-(void)refleshTable
{
    if (self.viewModel.keyword && !self.isCity)
    {
        self.textSearch.text = self.viewModel.keyword;
    }
    [self.viewModel reflashPage];
}
-(void)updateTable
{
    [self.viewModel nextPage];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.viewModel.subModel config];
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        [self didClick];
        [KeywordModel saveKeywordWith:self.defaultSearchText];
        self.viewModel.keyword = self.defaultSearchText;
        self.searchMatchTableView.hidden = YES;
        [self refleshTable];
        return YES;
    }
    else
    {
        NSString *tempUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
        [KeywordModel saveKeywordWith:textField.text userID:tempUserID];
        self.viewModel.keyword = textField.text;
        self.searchMatchTableView.hidden = YES;
        [self refleshTable];
        return YES;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( 0 == range.length )
    {
        self.matchString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    }
    else if ( 1 == range.length )
    {
        if ( [textField.text length] > 1 )
            self.matchString = [textField.text substringWithRange:NSMakeRange(0, [textField.text length] - 1)];
        else
        {
            self.tempSearchMatchArray = nil;
            self.matchString = nil;
        }
    }
    [self searMatch:textField.text];
    return YES;
}
#pragma mark 搜索模糊搜索
- (void)searMatch:(NSString*)searchKey{
    
    if (self.isLoading ) {
        return;
    }
    self.isLoading = YES;
    RACSignal *signal = [[RTNetworking shareInstance] getMartchSearchKeyListWithPageSize:10 searchKey:searchKey];
    [signal subscribeNext:^(RACTuple *racResult) {
        NSDictionary *dict = (NSDictionary *)racResult.second;
        if([dict resultSucess])
        {
            NSArray *array = [dict resultObject];
            if( array )
            {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0;i<array.count; i++) {
                    SearchMatch *hotSearchKey = [SearchMatch beanFromDictionary:array[i]];
                    [tempArray addObject:hotSearchKey];
                }
                self.searchMatchTableView.hidden = NO;
                self.tempSearchMatchArray =[tempArray copy];
                [self.searchMatchTableView reloadData];
            }
        }
        self.isLoading = NO;
        
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.searchMatchTableView )
    {
        return [self.tempSearchMatchArray count];
    }
    return self.viewModel.datas.count;
}
-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self.searchMatchTableView )
    {
        return 144 / CP_GLOBALSCALE;
    }
    if( self.viewModel.datas.count == 0 )
        return IS_IPHONE_5?110:130;
    else
    {
        CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
        return recommendModelFrame.totalFrame.size.height + 55 / CP_GLOBALSCALE;
    }
}
// 绘制cell
- (void)drawCell:(CPRecommendCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    [cell clear];
    CPRecommendModelFrame *recommendModelFrame;
    recommendModelFrame = self.viewModel.datas[indexPath.row];
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
    if ( tableView == self.searchMatchTableView )
    {
        CPSearchFuzzaMatchCell *cell = [CPSearchFuzzaMatchCell searchHistoryCellWithTableView:tableView];
        SearchMatch *hotSearchKey = [SearchMatch beanFromDictionary: [self.tempSearchMatchArray objectAtIndex:indexPath.row]];
        [cell configWithKeywordModel:hotSearchKey matchText:self.matchString hideSeparator:NO];
        return cell;
    }
    CPHomeGuessCell *cell = [CPHomeGuessCell guessCellWithTableView:tableView];
    CPRecommendModelFrame *modeFrame = self.viewModel.datas[indexPath.row];
    JobSearchModel *model = (JobSearchModel *)modeFrame.recommendModel;
    BOOL isRead = NO;
    for ( PositionIdModel *positionID in self.viewModel.positionIdArray )
    {
        if ( [model.PositionId isEqualToString:positionID.positionId] )
        {
            isRead = YES;
            break;
        }
    }
    [cell configCellWithDatas:modeFrame highlightText:self.textSearch.text isRead:isRead];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self.searchMatchTableView )
    {
        SearchMatch *hotSearchKey = [SearchMatch beanFromDictionary: [self.tempSearchMatchArray objectAtIndex:indexPath.row]];
         self.viewModel.keyword  = hotSearchKey.Keyword;
        [self refleshTable];
        self.searchMatchTableView.hidden = YES;
        [self.textSearch resignFirstResponder];
        return;
    }
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
    JobSearchModel *model;
    if( [recommendModelFrame.recommendModel isKindOfClass:[JobSearchModel class] ])
        model = (JobSearchModel *)recommendModelFrame.recommendModel;
    CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
    [companyDetailVC configWithPosition:model];
    [self.navigationController pushViewController:companyDetailVC animated:YES];
    self.customSelectIndexPath = indexPath;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - CPSearchFilterDelegate
- (void)clickedMoreFilterButton
{
    [self.navigationController.view addSubview:self.searchMoreFilterView];
    [self.searchMoreFilterView resetView];
    [MobClick event:@"more_need"];
}
#pragma mark - getter methods
- (CPSearchWithRightTextField *)textSearch
{
    if ( !_textSearch )
    {
        CGFloat tempScale = 3.0;
        _textSearch = [[CPSearchWithRightTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth - 40 / tempScale * 2, 90 / tempScale)];
        UIView *imageBackView = [[UIView alloc] init];
        [imageBackView setBackgroundColor:[UIColor redColor]];
        UIImageView *customLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_ic_search"]];
        CGFloat leftW = customLeftView.image.size.width / tempScale;
        CGFloat leftH = customLeftView.image.size.height / tempScale;
        customLeftView.frame = CGRectMake(0.0, ( 90 - 48 ) / tempScale / 2.0, leftW, leftH);
        [imageBackView addSubview:customLeftView];
        _textSearch.leftView = imageBackView;
        _textSearch.rightViewMode = UITextFieldViewModeWhileEditing;
        _textSearch.leftView.backgroundColor = [UIColor clearColor];
        _textSearch.leftViewMode = UITextFieldViewModeAlways;
        _textSearch.layer.cornerRadius = 90 / tempScale / 2.0;
        _textSearch.layer.masksToBounds = YES;
        if (!self.isCity) {
            _textSearch.placeholder = self.viewModel.keyword;
        }
        _textSearch.font = [UIFont systemFontOfSize:36 / ( 3.0 * ( 1 / 1.29 ) )];
        _textSearch.textColor = [UIColor colorWithHexString:@"404040"];
        _textSearch.background = [[UIImage imageNamed:@"search_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        _textSearch.delegate = self;
        _textSearch.returnKeyType = UIReturnKeySearch;
        [_textSearch setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    }
    return _textSearch;
}
- (CPSearchFilterView *)searchFilterView
{
    if ( !_searchFilterView )
    {
         NSMutableArray *allAddress = [Region allRegions];
        //字母排序
        //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
        for( int i = 0; i < [allAddress count]; i++ )
        {
            CPChineseString *chineseString=[[CPChineseString alloc]init];
            Region *region = [allAddress objectAtIndex:i];
            chineseString.string=[NSString stringWithString:region.RegionName];
            if( chineseString.string == nil )
            {
                chineseString.string = @"";
            }
            if( ![chineseString.string isEqualToString:@""] )
            {
                NSString *pinYinResult = [NSString string];
                for( int j = 0; j<chineseString.string.length; j++ )
                {
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseString.pinYin = pinYinResult;
            }
            else
            {
                chineseString.pinYin=@"";
            }
            region.firstLetter = chineseString.pinYin;
        }
        NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES]];
        NSArray *sortedArr = [allAddress sortedArrayUsingDescriptors:sortDesc];
        _searchFilterView = [[CPSearchFilterView alloc] initWithFrame:CGRectMake(0, 64.0, kScreenWidth, self.view.viewHeight) model:self.viewModel];
        [_searchFilterView configMenuWithAddress:sortedArr expectSalary:@[@"全部", @"2K以内", @"2K-5K", @"5K-10K", @"10K-15K", @"15K-20K", @"20K-25K",@"25K以上"] workYear:@[@"全部", @"在读学生", @"应届生", @"1年以下", @"1-3年", @"3-5年", @"5-7年", @"7-10年", @"10年以上"] moreFilter:@[@"全部", @"2K以内", @"2K-5K", @"5K-10K", @"10K-15K",@"25K以上"]];
        _searchFilterView.searchFilterDelegate = self;
    }
    return _searchFilterView;
}
NSInteger nickNameSort(Region *region, Region *region2, void *context)
{
    return  [region.RegionName localizedCompare:region2.RegionName];
}
- (NSArray *)topButtonTitleArray
{
    if ( !_topButtonTitleArray )
    {
        NSMutableArray *titleArrayM = [NSMutableArray array];
        [titleArrayM addObject:@"工作地点"];
        [titleArrayM addObject:@"期望薪酬"];
        [titleArrayM addObject:@"工作年限"];
        [titleArrayM addObject:@"更多筛选"];
        _topButtonTitleArray = [titleArrayM copy];
    }
    return _topButtonTitleArray;
}
- (CPSearchMoreFilterView *)searchMoreFilterView
{
    if ( !_searchMoreFilterView )
    {
        _searchMoreFilterView =[[CPSearchMoreFilterView alloc]  initWithFrame:CGRectMake(0, 20.0, kScreenWidth, kScreenHeight - 20.0) modle:self.viewModel];
        _searchMoreFilterView.filterChangeDeleger = self;
        [_searchMoreFilterView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.8]];
    }
    return _searchMoreFilterView;
}
- (UITableView *)searchMatchTableView
{
    if ( !_searchMatchTableView )
    {
        _searchMatchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, kScreenWidth, self.view.viewHeight - 49.0) style:UITableViewStylePlain];
        _searchMatchTableView.delegate = self;
        _searchMatchTableView.dataSource = self;
        _searchMatchTableView.hidden = YES;
        _searchMatchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchMatchTableView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    }
    return _searchMatchTableView;
}
@end
