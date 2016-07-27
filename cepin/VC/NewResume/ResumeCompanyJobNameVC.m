//
//  ExpectFunctionVC.m
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyJobNameVC.h"
#import "ResumeCompanyJobNameVM.h"

#import "TBTextUnit.h"
#import "ComChooseCell.h"
#import "JobFunctionHeaderView.h"
#import "ResumeCompanyJobNameSecondVC.h"
#import "AOTag.h"
@interface ResumeCompanyJobNameVC ()<JobFunctionHeaderViewDelegate>
@property(nonatomic,strong)ResumeCompanyJobNameVM *viewModel;
@property(nonatomic,strong) AOTagList *tagListView;
@property(nonatomic,strong)NSMutableArray *secDatas;
@property(nonatomic,strong)UIView *selectedFunctionView;
@property(nonatomic)int selectedCount;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,assign)NSInteger currentSection;
@property(nonatomic,strong)NSMutableArray *headView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ResumeCompanyJobNameVC

-(instancetype)initWithWorkModel:(WorkListDateModel *)model
{
    if (self = [super init]) {
        self.viewModel = [ResumeCompanyJobNameVM new];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"职位名称";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120 / 3.0;
    self.tableView.sectionHeaderHeight = 120 / 3.0;
    self.dataArray = [NSMutableArray new];
    for (int i = 0; i < self.viewModel.JobFirstData.count; i++) {
        BaseCode *item = self.viewModel.JobFirstData[i];
        [self.dataArray addObject:item.CodeName];
    }
    [self loadModel];
    [self.tableView setContentInset:UIEdgeInsetsMake(32 / 3.0, 0, 0, 0)];
}
- (void)loadModel
{
    self.headView = [NSMutableArray new];
    for (int i = 0; i < self.dataArray.count; i ++ ) {
        JobFunctionHeaderView *headView = [[JobFunctionHeaderView alloc]init];
        headView.delegate = self;
        headView.section = i;
        headView.jobName.text = [NSString stringWithFormat:@"%@",self.dataArray[i]];
        [self.headView addObject:headView];
    }
}
#pragma mark - HeadViewdelegate
-(void)selectedWith:(JobFunctionHeaderView *)view
{
    //    self.currentRow = -1;
    if (view.open) {
        for(int i = 0;i<[self.headView count];i++)
        {
            JobFunctionHeaderView *head = [self.headView objectAtIndex:i];
            head.open = NO;
        }
        [self.tableView reloadData];
        return;
    }
    self.currentSection = view.section;
    [self reset];
    
}
//界面重置
- (void)reset
{
    for(int i = 0;i<[self.headView count];i++)
    {
        JobFunctionHeaderView *head = [self.headView objectAtIndex:i];
        
        if(head.section == self.currentSection)
        {
            head.open = YES;
        }else {
            head.open = NO;
        }
        
    }
    [self.tableView reloadData];
}
#pragma mark UITableViewDataScource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobFunctionHeaderView* headView = [self.headView objectAtIndex:indexPath.section];
    
    return headView.open? 120 / 3.0 :0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 144 / 3.0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.headView objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JobFunctionHeaderView* headView = [self.headView objectAtIndex:section];
    BaseCode *code = self.viewModel.JobFirstData[section];
    NSArray * array = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
    return headView.open?array.count:0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headView count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ComChooseCell class])];
    if(cell == nil)
    {
        cell = [[ComChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ComChooseCell class])];
    }
    BaseCode *code = self.viewModel.JobFirstData[indexPath.section];
    NSMutableArray *array = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
    BaseCode *secondCode = array[indexPath.row];
    [cell configureLableTitleText:secondCode.CodeName];
    
    cell.chooseType = ComChooseNextType;
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseCode *code = self.viewModel.JobFirstData[indexPath.section];
    NSMutableArray *temp = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
    BaseCode *secondCode = temp[indexPath.row];
    NSMutableArray *thirdTemp = [BaseCode thirdLevelJobFunctionWithPathCode:secondCode.PathCode];
    ResumeCompanyJobNameSecondVC *vc = [[ResumeCompanyJobNameSecondVC alloc] initWithData:thirdTemp seletedData:self.viewModel.JobFirstData model:self.model];
    vc.title = secondCode.CodeName;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
