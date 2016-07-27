//
//  AddJobStatusVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//
#import "AddJobStatusVC.h"
#import "BaseCodeDTO.h"
#import "AddJobStatusVM.h"
#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface AddJobStatusVC ()
@property(nonatomic,strong)AddJobStatusVM *viewModel;
@end
@implementation AddJobStatusVC
-(instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[AddJobStatusVM alloc] initWithResume:model];
        self.resumeNameModel = model;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"求职状态";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.tableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.jobStatusArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPaths
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil)
    {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    BaseCode *item = self.viewModel.jobStatusArrays[indexPaths.row];
    cell.titleLabel.text = item.CodeName;
    NSString *str = [NSString stringWithFormat:@"%@",item.CodeKey];
    if ([self.resumeNameModel.JobStatus isEqualToString:str])
    {
        cell.chooseImage.hidden = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPaths.row == [self.viewModel.jobStatusArrays count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *item = self.viewModel.jobStatusArrays[indexPath.row];
    self.viewModel.jobNumber = item.CodeKey;
    self.viewModel.resumeNameModel.JobStatus = [NSString stringWithFormat:@"%@",item.CodeKey];
    [self.navigationController popViewControllerAnimated:YES];
}
@end