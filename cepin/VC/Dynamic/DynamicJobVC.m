//
//  DynamicJobVC.m
//  cepin
//
//  Created by ceping on 14-12-9.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicJobVC.h"
#import "DynamicJobVM.h"
#import "CompanyDynamicCell.h"
#import "DynamicJobModelDTO.h"
#import "CompanyDetailNewVC.h"
#import "JobDetailVC.h"
#import "JobDynamicCellNew.h"

@interface DynamicJobVC ()

@property(nonatomic,retain)DynamicJobVM *viewModel;

@end

@implementation DynamicJobVC

-(instancetype)init
{
    if (self = [super init])
    {
        self.viewModel = [DynamicJobVM new];
        return self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"工作动态";
    
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        if (!stateCode)
        {
            return ;
        }
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
                if (self.viewModel.datas.count >= self.viewModel.size)
                {
                    [self setupDropDownScrollView];
                }
                break;
            case hudCodeUpdateSucess:
                [self stopUpdateAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                break;
            default:
                [self stopRefleshAnimation];
                [self stopUpdateAnimation];
                self.viewModel.isLoading = NO;
                break;
        }
    }];
    
    [self setupRefleshScrollView];
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

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
    {
        return 90;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.viewModel.datas.count > 0)
    {
        NSDictionary *dic = [self.viewModel.datas objectAtIndex:section];
        NSArray *array = [dic objectForKey:@"PositionList"];
        return array.count + 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicJobModelDTO *companyBean = [DynamicJobModelDTO beanFromDictionary:[self.viewModel.datas objectAtIndex:indexPath.section]];
    if (indexPath.row == 0)
    {
        //生成时间
        CompanyDynamicCell *cell = [CompanyDynamicCell cellForTableView:tableView fromNib:[CompanyDynamicCell nib] andOwner:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.imageLogo setImageWithURL:[NSURL URLWithString:companyBean.Logo] placeholderImage:[UIImage imageNamed:@"tb_default_logo"]];
        cell.labelTime.text = companyBean.CreateDate;
        cell.labelName.text = companyBean.CompanyName;
        return cell;
    }
    
    JobDynamicCellNew *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JobDynamicCellNew class])];
    if(cell == nil)
    {
        cell = [[JobDynamicCellNew alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JobDynamicCellNew class])];
    }
    
    DynamicJobList *jobBean = [companyBean.PositionList objectAtIndex:indexPath.row - 1];
    if (companyBean.PositionList.count == indexPath.row)
    {
        cell.viewBlockBackground.drawnBordersSides = TKDrawnBorderSidesNone;
        cell.viewBlockBackground.roundedCorners = TKRoundedCornerBottomRight | TKRoundedCornerBottomLeft;
    }
    else
    {
        cell.viewBlockBackground.drawnBordersSides = TKDrawnBorderSidesBottom;
        cell.viewBlockBackground.roundedCorners = TKRoundedCornerNone;
    }
    
    cell.labelName.text = jobBean.PositionName;
    cell.labelAddress.text = jobBean.City;
    cell.labelSarly.text = jobBean.Salary;
    [cell setNeedsDisplay];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicJobModelDTO *companyBean = [DynamicJobModelDTO beanFromDictionary:[self.viewModel.datas objectAtIndex:indexPath.section]];
    if (indexPath.row == 0)
    {
        //跳转到公司详情页面
        CompanyDetailNewVC *vc = [[CompanyDetailNewVC alloc]initWithCompanyId:companyBean.CustomerId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        DynamicJobList *jobBean = [companyBean.PositionList objectAtIndex:indexPath.row - 1];
        //跳转到职位详情页面
        JobDetailVC *vc = [[JobDetailVC alloc]initWithJobId:jobBean.PositionId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
