//
//  AddPracticeVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddPracticeVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "ExperListVC.h"
#import "AwardListVC.h"
#import "StudentListVC.h"
#import "PracticeAndAwardsVM.h"
#import "CPTestEnsureArrowCell.h"
#import "CPCommon.h"
@interface AddPracticeVC ()
@property(nonatomic,strong) PracticeAndAwardsVM *viewModel;
@end
@implementation AddPracticeVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[PracticeAndAwardsVM alloc]initWithResumeId:model.ResumeId];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getResumeInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实践经历";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(32 / CP_GLOBALSCALE, 0, 0, 0)];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else if ([self requestStateWithStateCode:stateCode] == HUDCodeNetWork){
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
            self.tableView.hidden = YES;
        }
    }];
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getResumeInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
    switch (indexPath.row) {
        case 0:
        {
            [cell configCellLeftString:@"学生干部" placeholder:@"请完善"];
            if (self.viewModel.resumeModel.StudentLeadersList.count > 0) {
                cell.inputTextField.text = @"已完善";
            }
            else
            {
                cell.inputTextField.text = @"";
                [cell configCellLeftString:@"学生干部" placeholder:@"请完善"];
            }
        }
            break;
        case 1:
        {
            [cell configCellLeftString:@"曾获奖励" placeholder:@"请完善"];
            if (self.viewModel.resumeModel.AwardsList.count > 0) {
                cell.inputTextField.text = @"已完善";
            }
            else
            {
                cell.inputTextField.text = @"";
                [cell configCellLeftString:@"曾获奖励" placeholder:@"请完善"];
            }
        }
            break;
        case 2:
        {
            [cell configCellLeftString:@"社会实践" placeholder:@"请完善"];
            if (self.viewModel.resumeModel.PracticeList.count > 0) {
                cell.inputTextField.text = @"已完善";
            }
            else
            {
                cell.inputTextField.text = @"";
                [cell configCellLeftString:@"社会实践" placeholder:@"请完善"];
            }
        }
            break;
        default:
            break;
    }
    if ( 2 == indexPath.row )
        [cell resetSeparatorLineShowAll:YES];
    else
        [cell resetSeparatorLineShowAll:NO];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            StudentListVC *vc = [[StudentListVC alloc] initWithModel:self.viewModel.resumeModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            AwardListVC *vc = [[AwardListVC alloc] initWithModel:self.viewModel.resumeModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            ExperListVC *vc = [[ExperListVC alloc] initWithModel:self.viewModel.resumeModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
@end