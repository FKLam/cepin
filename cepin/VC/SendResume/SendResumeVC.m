//
//  SendResumeVC.m
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SendResumeVC.h"
#import "UserSaveJobCell.h"
#import "SendReumeVM.h"
#import "SendReumeModel.h"
#import "JobDetailVC.h"
#import "NewJobDetialVC.h"
#import "CPRecommendModelFrame.h"
#import "CPSendResumeRecordCell.h"
#import "CPHomePositionDetailController.h"
#import "CPCommon.h"
#define CPResumeRecord_Row_Height ( (40 + 60 + 42 + 40 + 36 + 60 + 6) / CP_GLOBALSCALE )

@interface SendResumeVC ()

@property(nonatomic,strong)SendReumeVM *viewModel;
@property(nonatomic,strong)UIImageView *wuImage;
@property(nonatomic,strong)UILabel *subLabel;
@end

@implementation SendResumeVC

-(instancetype)init
{
    if (self = [super init]) {
        self.viewModel = [SendReumeVM new];
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ( [self.sendResumeDelegate respondsToSelector:@selector(sendResumeVCNotify)] )
    {
        [self.sendResumeDelegate sendResumeVCNotify];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"投递记录";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    
    [self createNoHeadImageTable];
    self.tableView.rowHeight = CPResumeRecord_Row_Height;
    
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
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
                    self.networkLabel.text = @"你还没有投递过职位!";
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
                self.networkImage.image = [UIImage imageNamed:@"null_exam_linkbroken"];
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
    [self setupRefleshScrollView];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}
#pragma mark - UITableViewDatasource UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
    
    SendReumeModel *bean;
    
    if( [recommendModelFrame.recommendModel isKindOfClass:[SendReumeModel class]] )
        bean = (SendReumeModel *)recommendModelFrame.recommendModel;
    
    CPSendResumeRecordCell *cell = [CPSendResumeRecordCell sendResumeRecordCellWithTableView:tableView];
    
    [cell configCellWithResumeRecord:bean];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
    
    SendReumeModel *bean;
    
    if( [recommendModelFrame.recommendModel isKindOfClass:[SendReumeModel class]] )
        bean = (SendReumeModel *)recommendModelFrame.recommendModel;
    
//    NewJobDetialVC *vc = [[NewJobDetialVC alloc]initWithJobId:bean.PositionId companyId:bean.CustomerId pstType:bean.PositionType];
//    vc.title = bean.PositionName;
    CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
    [companyDetailVC configWithPosition:bean];
    [self.navigationController pushViewController:companyDetailVC animated:YES];
}

@end
