//
//  AddLanguangeVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddLanguangeVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "CertificateVC.h"
#import "AbilityVC.h"
#import "LanguageVC.h"
#import "EnglishLevelVC.h"
#import "LanguageAndSkilVM.h"
#import "CPTestEnsureArrowCell.h"
#import "CPCommon.h"
@interface AddLanguangeVC ()
@property(nonatomic,strong)LanguageAndSkilVM *viewModel;
@end
@implementation AddLanguangeVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[LanguageAndSkilVM alloc]initWithResumeId:model.ResumeId];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getResumeInfo];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"相关技能";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        else if ([self requestStateWithStateCode:stateCode] == HUDCodeNetWork)
        {
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
#pragma mark - UITableViewDatasoure UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
    switch (indexPath.row) {
        case 0:
        {
            [cell configCellLeftString:@"专业证书" placeholder:@"请完善"];
            [cell.inputTextField setTag:indexPath.row];
            if ( self.viewModel.resumeModel.CredentialList.count > 0 ) {
                 cell.inputTextField.text = @"已完善";
            }
            else
            {
                cell.inputTextField.text = @"";
                [cell configCellLeftString:@"专业证书" placeholder:@"请完善"];
            }
        }
            break;
        case 1:
        {
            [cell configCellLeftString:@"专业技能" placeholder:@"请完善"];
            [cell.inputTextField setTag:indexPath.row];
            if (self.viewModel.resumeModel.SkillList.count > 0) {
                 cell.inputTextField.text = @"已完善";
            }
            else
            {
                cell.inputTextField.text = @"";
                [cell configCellLeftString:@"专业技能" placeholder:@"请完善"];
            }
        }
            break;
        case 2:
        {
            [cell configCellLeftString:@"英语等级" placeholder:@"请完善"];
            [cell.inputTextField setTag:indexPath.row];
            if (self.viewModel.resumeModel.IsHasCET4Score.intValue==1 ||self.viewModel.resumeModel.IsHasCET6Score.intValue==1 ||self.viewModel.resumeModel.IsHasIELTSScore.intValue==1||self.viewModel.resumeModel.IsHasTEM4Score.intValue==1||self.viewModel.resumeModel.IsHasTEM8Score.intValue==1||self.viewModel.resumeModel.IsHasTOEFLScore.intValue==1 )
            {
                 cell.inputTextField.text = @"已完善";
            }
            else
            {
                cell.inputTextField.text = @"";
                [cell configCellLeftString:@"英语等级" placeholder:@"请完善"];
            }
        }
            break;
        case 3:
        {
            [cell configCellLeftString:@"其它语言能力" placeholder:@"请完善"];
            [cell.inputTextField setTag:indexPath.row];
            if (self.viewModel.resumeModel.LanguageList.count > 0) {
                cell.inputTextField.text = @"已完善";
            }else
            {
                cell.inputTextField.text = @"";
                [cell configCellLeftString:@"其它语言能力" placeholder:@"请完善"];
            }
        }
            break;
        default:
            break;
    }
    if ( 3 == indexPath.row )
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
            CertificateVC *vc = [[CertificateVC alloc] initWithModel:self.viewModel.resumeModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            AbilityVC *vc = [[AbilityVC alloc] initWithModel:self.viewModel.resumeModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            LanguageVC *vc = [[LanguageVC alloc] initWithModel:self.viewModel.resumeModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            EnglishLevelVC *vc = [[EnglishLevelVC alloc] initWithModel:self.viewModel.resumeModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
@end