//
//  TheCompanyJobVC.m
//  cepin
//
//  Created by zhu on 14/12/21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "TheCompanyJobVC.h"
#import "TheCompanyJobVM.h"
#import "OtherJobViewCell.h"
#import "TheCompanyJobModel.h"
#import "NewJobDetialVC.h"
#import "NSDate-Utilities.h"
#import "CPRecommendModelFrame.h"
#import "CPRecommendCell.h"
#import "JobSearchModel.h"

@interface TheCompanyJobVC ()

@property(nonatomic,retain)TheCompanyJobVM *viewModel;

@end

@implementation TheCompanyJobVC

-(void)memoryRelease
{
    [self.viewModel momeryRelease];
    self.viewModel = nil;
}

-(instancetype)initWithCompanyId:(NSString*)companyId
{
    if (self = [super init])
    {
        self.viewModel = [[TheCompanyJobVM alloc] initWithCompanyId:companyId];
        return self;
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel allPositionId];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"企业职位";
    
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        switch ([self requestStateWithStateCode:stateCode])
        {
            case HUDCodeDownloading:
                self.viewModel.isLoading = YES;
                [self startRefleshAnimation];
                break;
            case HUDCodeLoadMore:
                self.viewModel.isLoading = YES;
                [self startUpdateAnimation];
                break;
            case HUDCodeReflashSucess:
                [self stopRefleshAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                break;
            case hudCodeUpdateSucess:
                [self stopUpdateAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                break;
            case HUDCodeNone:
                self.viewModel.isLoading = NO;
                self.tableView.hidden = NO;
            {
                MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)self.tableView.mj_footer;
                [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
                
                self.tableView.mj_footer = footer;
            }
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
                break;
            case HUDCodeNetWork:
            {
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.networkButton.hidden = NO;
                self.clickImage.hidden = NO;
                self.tableView.hidden = YES;
                
                [self.tableView.mj_footer endRefreshing];
            }
            default:
                self.viewModel.isLoading = NO;
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer endRefreshing];
                break;
        }
    }];
    
    [self setupRefleshScrollView];
    [self setupDropDownScrollView];
//    self.tableView.showsInfiniteScrolling = NO;
    [self refleshTable];
}

- (void)clickNetWorkButton
{
    self.viewModel.isLoad = YES;
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    self.tableView.hidden = NO;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
    return recommendModelFrame.totalFrame.size.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}

// 绘制cell
- (void)drawCell:(CPRecommendCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    [cell clear];
    
    CPRecommendModelFrame *recommendModelFrame;
    
    if( 0 < self.viewModel.datas.count )
    {
        recommendModelFrame = self.viewModel.datas[indexPath.row];
    }
    
    // 检查cell是否被查阅过
    BOOL isChecked = NO;
    
    for (PositionIdModel *model in self.viewModel.positionIdArray) {
        
        if(![recommendModelFrame.recommendModel isKindOfClass:[JobSearchModel class]])
            continue;
        
        JobSearchModel *recommendModel = (JobSearchModel *)recommendModelFrame.recommendModel;
        
        if ([recommendModel.PositionId isEqualToString:model.positionId]) {
            isChecked = YES;
            break;
        }
    }
    
    recommendModelFrame.isCheck = isChecked;
    
    cell.recommendModelFrame = recommendModelFrame;
    
    [cell draw];
}

//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommendCell *cell = [CPRecommendCell recommendCellWithTableView:tableView];
    
    [self drawCell:cell withIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommendModelFrame *recommendModelFrame = [self.viewModel.datas objectAtIndex:indexPath.row];
    JobSearchModel *bean = recommendModelFrame.recommendModel;
    NewJobDetialVC *vc = [[NewJobDetialVC alloc]initWithJobId:bean.PositionId  companyId:bean.CustomerId pstType:bean.PositionType];
    //                          bId:bean.PositionId com];
    @weakify(self)
    [RACObserve(vc,changeState) subscribeNext:^(id stateCode){
        @strongify(self)
        if ([stateCode isKindOfClass:[NSNumber class]])
        {
            NSNumber *number = (NSNumber*)stateCode;
            if (number.intValue == 0)
            {
                bean.IsCollection = [NSNumber numberWithInt:0];
            }
            if (number.intValue == 1)
            {
                bean.IsCollection = [NSNumber numberWithInt:1];
            }
            if (number.intValue == 2)
            {
                bean.IsDeliveried = [NSNumber numberWithInt:1];
            }
            [self.viewModel.datas replaceObjectAtIndex:indexPath.row withObject:[bean toDictionary]];
            [self.tableView reloadData];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
