//
//  CPWatchResumeController.m
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWatchResumeController.h"
#import "CPWatchResumeCell.h"
#import "MobClick.h"
#import "RTNetworking+Company.h"
#import "CPWatchResumeVM.h"
#import "JobSearchModel.h"
#import "CPCompanyDetailController.h"
#import "CPCommon.h"
#define CPWatchResume_Row_Height ( (40 + 60 + 42 + 32 + 36 + 60 + 6 ) / CP_GLOBALSCALE )

@interface CPWatchResumeController ()
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic,strong)NSString *resumeId;
@property (nonatomic,strong)CPWatchResumeVM *viewModel;
@end

@implementation CPWatchResumeController


-(instancetype)init{
    self = [super init];
    if (self) {
        self.viewModel = [CPWatchResumeVM new];
    }
    return self;
}

- (void)viewDidLoad {
    [MobClick event:@"into_see_resume_company"];
    [super viewDidLoad];
    [self setTitle:@"查看过我简历的"];
    [self createNoHeadImageTable];
    [self.tableView setRowHeight:CPWatchResume_Row_Height];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
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
            case HUDCodeLoadMore:
                self.viewModel.isLoading = YES;
                [self startUpdateAnimation];
                self.networkImage.hidden = YES;
                self.networkLabel.hidden = YES;
                self.networkButton.hidden = YES;
                self.clickImage.hidden = YES;
                self.tableView.hidden = NO;
                break;
            case HUDCodeReflashSucess:
                [self stopRefleshAnimation];
                [self stopUpdateAnimation];
                self.viewModel.isLoading = NO;
                self.networkImage.hidden = YES;
                self.networkLabel.hidden = YES;
                self.networkButton.hidden = YES;
                self.clickImage.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
                break;
            case hudCodeUpdateSucess:
                [self stopUpdateAnimation];
                self.tableView.hidden = NO;
                self.viewModel.isLoading = NO;
                self.networkImage.hidden = YES;
                self.networkLabel.hidden = YES;
                self.networkButton.hidden = YES;
                self.clickImage.hidden = YES;
                self.tableView.hidden = NO;
                [self.tableView reloadData];
                break;
            case HUDCodeNone:
            {
                self.viewModel.isLoading = NO;
                
                if ( self.viewModel.datas.count == 0 )
                {
                    self.networkLabel.text = @"还没有企业查看过你的简历，完善简历可以获取更多的机会哦";
                    self.tableView.hidden = YES;
                    self.networkImage.hidden = NO;
                    self.networkImage.image = [UIImage imageNamed:@"null_preview"];
                    self.networkLabel.hidden = NO;
                    
                }
                else if ( self.viewModel.datas.count > 0 )
                {
                    {
                        MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)self.tableView.mj_footer;
                        [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
                        
                        self.tableView.mj_footer = footer;
                    }
                    self.tableView.hidden = NO;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                break;
            }
            case HUDCodeNetWork:
            {
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.networkButton.hidden = NO;
                self.clickImage.hidden = NO;
                self.tableView.hidden = YES;
                [self.tableView.mj_footer endRefreshing];
                break;
            }
            default:
                [self stopRefleshAnimation];
                [self stopUpdateAnimation];
                self.viewModel.isLoading = NO;
                [self.tableView reloadData];
                break;
        }
    }];
    
    [self refleshTable];
    
    [self setupDropDownScrollView];
    
    
}

-(void)refleshTable{
    [self.viewModel reflashPage];
}

-(void)updateTable{
    
     [self.viewModel nextPage];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)configResumeId:(NSString *)resumeId{
    self.viewModel.resumeId = resumeId;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPWatchResumeCell *cell = [CPWatchResumeCell watchResumeCellWithTableView:tableView];
    JobSearchModel *model = [JobSearchModel beanFromDictionary:self.viewModel.datas[indexPath.row]];
    [cell configCellWithResume:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [MobClick event:@"see_resume_company_item_click"];
    CPCompanyDetailController *vc = [CPCompanyDetailController new];
    JobSearchModel *model = [JobSearchModel beanFromDictionary:self.viewModel.datas[indexPath.row]];
    [vc configWithPositionWithCompanyId:model.CustomerId];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
