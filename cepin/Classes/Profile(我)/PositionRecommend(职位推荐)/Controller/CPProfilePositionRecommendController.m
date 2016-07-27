//
//  CPProfilePositionRecommendController.m
//  cepin
//
//  Created by ceping on 16/3/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPProfilePositionRecommendController.h"
#import "CPProfilePositionRecommendCell.h"
#import "CPJobRecommendModel.h"
#import "CPJobRecommendVM.h"
#import "CPHomePositionDetailController.h"
#import "CPCommon.h"
@interface CPProfilePositionRecommendController ()
//@property (nonatomic, strong) UITableView *contentTableView;
@property(nonatomic,strong)CPJobRecommendVM *viewModel;
@end
@implementation CPProfilePositionRecommendController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        self.title = @"职位推荐";
        self.viewModel = [CPJobRecommendVM new];
    }
    return self;
}
-(instancetype)init
{
    if (self = [super init]) {
        self.title = @"职位推荐";
        self.viewModel = [CPJobRecommendVM new];
    }
    return self;
}
- (void)viewDidLoad
{
    //统计推荐页
    [MobClick event:@"slide_recommend"];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [self createNoHeadImageTable];
    CGFloat rowHeight = ( 40 + 60 + 42 + 40 + 42 + 40 + 36 + 60 + 6 ) / CP_GLOBALSCALE;
    self.tableView.rowHeight = rowHeight;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
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
                    self.networkLabel.text = @"目前还没有职位推荐，简历完善度越高获取的职位越精准!";
                    self.networkImage.image = [UIImage imageNamed:@"null_info"];
                    self.tableView.hidden = YES;
                    self.networkImage.hidden = NO;
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
                self.networkImage.image = [UIImage imageNamed:@"null_exam_linkbroken"];
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
//    [self setupRefleshScrollView];
    [self setupDropDownScrollView];
    [self refleshTable];
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self refleshTable];
}
-(void)refleshTable
{
    [self.viewModel reflashPage];
}
-(void)updateTable
{
    [self.viewModel nextPage];
}
#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPProfilePositionRecommendCell *cell = [CPProfilePositionRecommendCell positionRecommendCellWithTableView:tableView];
    CPJobRecommendModel *model = self.viewModel.datas[indexPath.row];
    [cell configCellWithRecommendJob:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     CPJobRecommendModel *model = self.viewModel.datas[indexPath.row];
    CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
    [companyDetailVC configWithPositionId:model.PositionId];
    [self.navigationController pushViewController:companyDetailVC animated:YES];
}

@end