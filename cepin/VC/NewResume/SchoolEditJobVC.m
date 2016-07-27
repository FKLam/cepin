//
//  SchoolEditJobVC.m
//  cepin
//
//  Created by dujincai on 15/11/16.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "SchoolEditJobVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "ResumeAddMoreCell.h"
#import "ResumeEditCell.h"
#import "ResumeThridTimeView.h"
#import "ResumeEditJobExperienceVM.h"
#import "NSDate-Utilities.h"
#import "ResumeCompanyIndustryVC.h"
#import "ResumeCompanyNatureVC.h"
#import "ResumeCompanyDescribeVC.h"
#import "ResumeCompanyJobNameVC.h"
#import "ResumeCompanyAddressVC.h"
#import "ResumeCompanyRankingVC.h"
#import "ResumeCompanyScaleVC.h"
#import "NSDate-Utilities.h"
#import "ResumeIsAbroadCell.h"
#import "CertifierVC.h"
#import "CPTestEnsureEditCell.h"
#import "CPTestEnsureArrowCell.h"
#import "CPResumeMoreButton.h"
#import "RTNetworking+Resume.h"
#import "ResumeSwitchCell.h"
#import "CPCommon.h"
@interface SchoolEditJobVC ()<UITextFieldDelegate, ResumeThridTimeViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic)BOOL addMore;
@property(nonatomic,retain)ResumeThridTimeView *timeView;
@property(nonatomic,strong)ResumeEditJobExperienceVM *viewModel;
@property(nonatomic,strong)UITextField *textField;
@property (nonatomic, strong) UIView *firstFooterView;
@property (nonatomic, strong) UIView *secondFooterView;
@property (nonatomic, strong) CPResumeMoreButton *moreButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) CGFloat lastRoWHeight;
@end
@implementation SchoolEditJobVC
-(instancetype)initWithModel:(WorkListDateModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[ResumeEditJobExperienceVM alloc] initWithWork:model];
        self.viewModel.resumeType  = [NSNumber numberWithInt:2];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithModel:(WorkListDateModel *)model resume:(ResumeNameModel *)resume
{
    self = [super init];
    if ( self )
    {
        self.viewModel = [[ResumeEditJobExperienceVM alloc] initWithResume:resume work:model];
        self.viewModel.resumeType = [NSNumber numberWithInt:2];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑实习经历";
    self.lastRoWHeight = 0.0;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.textField resignFirstResponder];
        [self.viewModel saveWork];
    }];
    self.addMore = YES;
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(32 / CP_GLOBALSCALE, 0, 0, 0)];
    self.tableView.tableFooterView = self.secondFooterView;
    @weakify(self)
    [RACObserve(self.viewModel,saveStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            [self.tableView reloadData];
        }
    }];
    // 增加对键盘消息的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClick)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
}
- (void)didClick
{
    [self.view endEditing:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark - 监听键盘的弹出和隐藏的方法
- (void)listenKeyboardWillShow:(NSNotification *)userNotification
{
    NSValue *userValue = [userNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [userValue CGRectValue];
    CGFloat keyboardTop = keyboardEndFrame.origin.y;
    CGFloat duration = [[userNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.tableView.frame = viewFrame;
        if ( 5 == weakSelf.textField.tag )
        {
            if ( !self.moreButton.isSelected )
            {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            else
            {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }];
}
- (void)listenKeyboardWillHide:(NSNotification *)userNotification
{
    CGFloat duration = [[userNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect viewFrame = self.view.bounds;
    viewFrame.origin.y = self.view.bounds.origin.y + 44.0 + 20.0;
    viewFrame.size.height = self.view.bounds.size.height - 44 - 20;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.tableView.frame = viewFrame;
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 1 == indexPath.section )
    {
        return self.lastRoWHeight;
    }
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section )
    {
        return 6;
    }
    else
    {
        return 7;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 0 == indexPath.section )
    {
        switch ( indexPath.row )
        {
            case 0:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell configCellLeftString:@"开始时间" placeholder:@"请选择开始时间"];
                [cell.inputTextField setText:[NSDate cepinYMDFromString:self.viewModel.workData.StartDate]];
                if ( 5 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 1:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell configCellLeftString:@"结束时间" placeholder:@"请选择结束时间"];
                [cell.inputTextField setText:[NSDate cepinYMDFromString:self.viewModel.workData.EndDate]];
                if (self.viewModel.workData.EndDate && ![self.viewModel.workData.EndDate isEqualToString:@""]) {
                    cell.inputTextField.text = [NSDate cepinYMDFromString:self.viewModel.workData.EndDate];
                }else
                {
                    cell.inputTextField.text = @"至今";
                }
                if ( 5 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 2:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [cell configCellLeftString:@"公司名称" placeholder:@"请输入公司名称"];
                [cell.inputTextField setText:self.viewModel.workData.Company];
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    if ( indexPath.row != cell.inputTextField.tag )
                        return;
                    self.viewModel.workData.Company = text;
                }];
                if ( 5 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
                return cell;
            }
            case 3:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell configCellLeftString:@"行业类型" placeholder:@"请选择行业类型"];
                [cell.inputTextField setText:self.viewModel.workData.Industry];
                if ( 5 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 4:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell configCellLeftString:@"公司性质" placeholder:@"请选择公司性质"];
                [cell.inputTextField setText:self.viewModel.workData.Nature];
                if ( 5 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 5:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [cell configCellLeftString:@"职位名称" placeholder:@"请输入职位名称"];
                [cell.inputTextField setText:self.viewModel.workData.JobFunction];
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    if ( indexPath.row != cell.inputTextField.tag )
                        return;
                    self.viewModel.workData.JobFunction = text;
                }];
                if ( 5 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
        }
    }
    else
    {
        switch ( indexPath.row )
        {
            case 0:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell configCellLeftString:@"公司地址" placeholder:@"请选择公司地址"];
                [cell.inputTextField setText:self.viewModel.workData.JobCity];
                return cell;
            }
            case 1:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell configCellLeftString:@"公司排名" placeholder:@"请选择公司排名"];
                [cell.inputTextField setText:self.viewModel.workData.CompanyRanking];
                return cell;
            }
            case 2:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell configCellLeftString:@"公司规模" placeholder:@"请选择公司规模"];
                [cell.inputTextField setText:self.viewModel.workData.Size];
                return cell;
            }
            case 6:
            {
                ResumeSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeSwitchCell class])];
                [cell configCellLeftTitle:@"海外经历"];
                if (cell == nil) {
                    cell = [[ResumeSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeSwitchCell class])];
                }
                if ( !self.viewModel.workData.IsAbroad )
                    self.viewModel.workData.IsAbroad = @0;
                if (self.viewModel.workData.IsAbroad.intValue == 0)
                {
                    [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
                }
                else
                {
                    [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
                }
                [cell.Switchimage handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                    if (self.viewModel.workData.IsAbroad.intValue == 0) {
                        [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
                        self.viewModel.workData.IsAbroad = @1;
                    }else
                    {
                        [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
                        self.viewModel.workData.IsAbroad = @0;
                    }
                }];
                [cell resetSeparatorLineShowAll:YES];
                return cell;
            }
            case 3:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                [cell configCellLeftString:@"薪酬(元/月)" placeholder:@"请输入薪酬"];
                [cell.inputTextField setText:self.viewModel.workData.Salary];
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    if ( indexPath.row != cell.inputTextField.tag )
                        return;
                    self.viewModel.workData.Salary = text;
                }];
                return cell;
            }
            case 4:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell configCellLeftString:@"工作职责" placeholder:@"请填写工作职责"];
                if (self.viewModel.workData.Content && ![self.viewModel.workData.Content isEqualToString:@""]) {
                    cell.inputTextField.text = @"已添加";
                }
                else
                {
                    cell.inputTextField.text = @"";
                }
                return cell;
            }
            case 5:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row];
                [cell configCellLeftString:@"证明人" placeholder:@"请完善证明人"];
                if (self.viewModel.workData.AttestorName && ![self.viewModel.workData.AttestorName isEqualToString:@""]) {
                    cell.inputTextField.text = @"已添加";
                }
                else
                {
                    cell.inputTextField.text = @"";
                }
                return cell;
            }
        }
    }
//    if (indexPath.row == 3 || indexPath.row == 12) {
//        ResumeEditCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeEditCell class])];
//        if (cell == nil) {
//            cell = [[ResumeEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeEditCell class])];
//        }
//        switch (indexPath.row) {
//            case 3:
//                
//            {
//                cell.titleLabel.text = @"公司名称";
//                cell.infoText.placeholder = @"请输入公司名称";
//                cell.infoText.delegate = self;
//                cell.infoText.text = self.viewModel.workData.Company;
//                [[cell.infoText rac_textSignal] subscribeNext:^(NSString *text) {
//                    self.viewModel.workData.Company = text;
//                }];
//            }
//                break;
//            case 12:
//            {
//                cell.titleLabel.text = @"薪酬(元/月)";
//                cell.infoText.placeholder = @"请输入薪酬";
//                cell.infoText.delegate = self;
//                cell.infoText.keyboardType = UIKeyboardTypeDecimalPad;
//                cell.infoText.text = self.viewModel.workData.Salary;
//                [[cell.infoText rac_textSignal] subscribeNext:^(NSString *text) {
//                    self.viewModel.workData.Salary = text;
//                }];
//            }
//                break;
//            default:
//                break;
//        }
//        return cell;
//    }if (indexPath.row == 7) {
//        ResumeAddMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeAddMoreCell class])];
//        if (cell == nil) {
//            cell = [[ResumeAddMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeAddMoreCell class])];
//        }
//        if (self.addMore) {
//            cell.backgroundColor = [UIColor whiteColor];
//        }else
//        {
//            cell.backgroundColor = [UIColor clearColor];
//        }
//        [cell.addButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//            self.addMore = !self.addMore;
//            [self.tableView reloadData];
//        }];
//        return cell;
//    }if(indexPath.row == 11){
//        ResumeIsAbroadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeIsAbroadCell class])];
//        if (cell == nil) {
//            cell = [[ResumeIsAbroadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeIsAbroadCell class])];
//        }
////        if (self.addMore) {
////            cell.line.hidden = NO;
////        }else
////        {
////            cell.line.hidden = YES;
////        }
//        if ( self.viewModel.workData.IsAbroad.intValue == 1 ) {
//            [cell.buttonImage setBackgroundImage:[UIImage imageNamed:@"ic_switch_on"] forState:UIControlStateNormal];
//        }else
//        {
//            [cell.buttonImage setBackgroundImage:[UIImage imageNamed:@"ic_switch_off"] forState:UIControlStateNormal];
//        }
//        
//        [cell.buttonImage handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//            if (self.viewModel.workData.IsAbroad.intValue==1) {
//                [cell.buttonImage setBackgroundImage:[UIImage imageNamed:@"ic_switch_off"] forState:UIControlStateNormal];
//                
//                self.viewModel.workData.IsAbroad = @"0";
//            }else{
//                [cell.buttonImage setBackgroundImage:[UIImage imageNamed:@"ic_switch_on"] forState:UIControlStateNormal];
//                
//                self.viewModel.workData.IsAbroad = @"1";
//            }
//        }];
//        return cell;
//    }else{
//        ResumeArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeArrowCell class])];
//        if (cell == nil) {
//            cell = [[ResumeArrowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeArrowCell class])];
//        }
//        switch (indexPath.row) {
//            case 1:
//            {
//                cell.titleLabel.text = @"开始时间";
//                cell.infoText.placeholder = @"请选择开始时间";
//                cell.infoText.text = [NSDate cepinYMDFromString:self.viewModel.workData.StartDate];
//            }
//                break;
//            case 2:
//            {
//                cell.titleLabel.text = @"结束时间";
//                cell.infoText.placeholder = @"请选择结束时间";
//                if (self.viewModel.workData.EndDate && ![self.viewModel.workData.EndDate isEqualToString:@""]) {
//                    cell.infoText.text = [NSDate cepinYMDFromString:self.viewModel.workData.EndDate];
//                }else
//                {
//                    cell.infoText.text = @"至今";
//                }
//                
//            }
//                break;
//            case 4:
//            {
//                cell.titleLabel.text = @"行业类型";
//                cell.infoText.placeholder = @"请选择行业";
//                cell.infoText.text = self.viewModel.workData.Industry;
//            }
//                break;
//            case 5:
//            {
//                cell.titleLabel.text = @"公司性质";
//                cell.infoText.placeholder = @"请选择公司性质";
//                cell.infoText.text = self.viewModel.workData.Nature;
//            }
//                break;
//            case 6:
//            {
//                cell.titleLabel.text = @"职位名称";
//                cell.infoText.placeholder = @"请选择职位名称";
//                cell.infoText.text = self.viewModel.workData.JobFunction;
//            }
//                break;
//                
//            case 8:
//            {
//                cell.titleLabel.text = @"公司地址";
//                cell.infoText.placeholder = @"请选择公司地点";
//                cell.infoText.text = self.viewModel.workData.JobCity;
//                
//            }
//                break;
//            case 9:
//            {
//                cell.titleLabel.text = @"公司排名";
//                cell.infoText.placeholder = @"请选择公司排名";
//                cell.infoText.text = self.viewModel.workData.CompanyRanking;
//                
//            }
//                break;
//            case 10:
//            {
//                cell.titleLabel.text = @"公司规模";
//                cell.infoText.placeholder = @"请选择公司规模";
//                cell.infoText.text = self.viewModel.workData.Size;
//            }
//                break;
//            case 13:
//            {
//                cell.titleLabel.text = @"工作职责";
//                cell.infoText.placeholder = @"请填写工作职责";
//                if (self.viewModel.workData.Content && ![self.viewModel.workData.Content isEqualToString:@""]) {
//                    cell.infoText.text = @"已添加";
//                }else{
//                    cell.infoText.text = @"";
//                }
//            }
//                break;
//            case 14:
//            {
//                cell.titleLabel.text = @"证明人";
//                cell.infoText.placeholder = @"请完善证明人";
//                if (self.viewModel.workData.AttestorName && ![self.viewModel.workData.AttestorName isEqualToString:@""]) {
//                    cell.infoText.text = @"已添加";
//                }else{
//                    cell.infoText.text = @"";
//                }
//            }
//                break;
//                
//            default:
//                break;
//        }
//        return cell;
//    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.textField) {
        [self.textField resignFirstResponder];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    if ( 0 == indexPath.section )
    {
        switch (indexPath.row) {
            case 0:
            {
                [self displayTimeView:indexPath.row];
            }
                break;
            case 1:
            {
                [self displayTimeView:indexPath.row];
            }
                break;
            case 3:
            {
                ResumeCompanyIndustryVC *vc = [[ResumeCompanyIndustryVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                ResumeCompanyNatureVC *vc = [[ResumeCompanyNatureVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
//            case 5:
//            {
//                ResumeCompanyJobNameVC *vc = [[ResumeCompanyJobNameVC alloc]initWithWorkModel:self.viewModel.workData];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
            default:
                break;
        }
    }
    else
    {
        switch ( indexPath.row )
        {
            case 4:
            {
                ResumeCompanyDescribeVC *vc = [[ResumeCompanyDescribeVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 0:
            {
                ResumeCompanyAddressVC *vc = [[ResumeCompanyAddressVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                ResumeCompanyRankingVC *vc = [[ResumeCompanyRankingVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                ResumeCompanyScaleVC *vc = [[ResumeCompanyScaleVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:
            {
                CertifierVC *vc = [[CertifierVC alloc] initWithModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( 0 == section )
    {
        return self.firstFooterView;
    }
    else
    {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight = 0;
    if ( 0 == section )
    {
        footerHeight = ( 40 + 144 + 40 ) / CP_GLOBALSCALE;
    }
    else
    {
        footerHeight = 0;
    }
    return footerHeight;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)displayTimeView:(NSInteger)tag
{
    if (self.textField) {
        [self.textField resignFirstResponder];
    }
    if (!self.timeView)
    {
        self.timeView = [[ResumeThridTimeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.timeView];
        self.timeView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
        self.timeView.delegate = self;
        self.timeView.tag = tag;
        
        [self resetYearMonth];
    }
    else
    {
        self.timeView.tag = tag;
        [self resetYearMonth];
        self.timeView.hidden = NO;
    }
}
-(void)resetYearMonth
{
    NSString *str = nil;
    if (self.timeView.tag == 0)
    {
        if (!self.viewModel.workData.StartDate || [self.viewModel.workData.StartDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        str = [NSDate cepinYMDFromString:self.viewModel.workData.StartDate];
    }
    else
    {
        if (!self.viewModel.workData.EndDate || [self.viewModel.workData.EndDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        str = [NSDate cepinYMDFromString:self.viewModel.workData.EndDate];
    }
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue];
}
-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if (self.timeView.tag == 1)
    {
        self.viewModel.workData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    else
    {
        self.viewModel.workData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    
    [self.tableView reloadData];
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
- (void)clickCancelButton
{
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    return YES;
}
#pragma mark - getter
- (UIView *)firstFooterView
{
    if ( !_firstFooterView )
    {
        _firstFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 40 + 144 + 40 ) / CP_GLOBALSCALE)];
        [_firstFooterView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_firstFooterView addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _firstFooterView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _firstFooterView.mas_left );
            make.bottom.equalTo( _firstFooterView.mas_bottom ).offset( -40 / CP_GLOBALSCALE );
            make.right.equalTo( _firstFooterView.mas_right );
        }];
    }
    return _firstFooterView;
}
- (UIView *)secondFooterView
{
    if ( !_secondFooterView )
    {
        _secondFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 60 + 144 + 60 ) / CP_GLOBALSCALE)];
        [_secondFooterView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_secondFooterView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _secondFooterView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _secondFooterView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _secondFooterView.mas_bottom ).offset( -60 / CP_GLOBALSCALE );
            make.right.equalTo( _secondFooterView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return _secondFooterView;
}
- (CPResumeMoreButton *)moreButton
{
    if ( !_moreButton )
    {
        _moreButton = [CPResumeMoreButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"247ec9"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_moreButton setTitle:@"展开更多模块" forState:UIControlStateNormal];
        [_moreButton setTitle:@"收起更多模块" forState:UIControlStateSelected];
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_moreButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_moreButton.layer setMasksToBounds:YES];
        [_moreButton setImage:[UIImage imageNamed:@"ic_down"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"ic_up"] forState:UIControlStateSelected];
        [_moreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeMoreButton *sender) {
            sender.selected = !sender.isSelected;
            if ( sender.selected )
                self.lastRoWHeight = 144 / CP_GLOBALSCALE;
            else
                self.lastRoWHeight = 0.0;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1], [NSIndexPath indexPathForRow:1 inSection:1], [NSIndexPath indexPathForRow:2 inSection:1], [NSIndexPath indexPathForRow:3 inSection:1], [NSIndexPath indexPathForRow:4 inSection:1], [NSIndexPath indexPathForRow:5 inSection:1], [NSIndexPath indexPathForRow:6 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
    }
    return _moreButton;
}
- (UIButton *)deleteButton
{
    if ( !_deleteButton )
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE ]];
        [_deleteButton setTitle:@"删除该项实习经历" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_deleteButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_deleteButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [_deleteButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [_deleteButton.layer setMasksToBounds:YES];
        [_deleteButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            TBLoading *load = [TBLoading new];
            [load start];
            NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
            NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
            RACSignal *signal = [[RTNetworking shareInstance] deleteThridResumeWorkListWithResumeId:self.viewModel.resumeId workId:self.viewModel.workId userId:userId tokenId:TokenId];
            @weakify(self);
            [signal subscribeNext:^(RACTuple *tuple){
                @strongify(self);
                if (load)
                {
                    [load stop];
                }
                NSDictionary *dic = (NSDictionary *)tuple.second;
                if ([dic resultSucess])
                {
//                    [OMGToast showWithText:@"操作成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    if ([dic isMustAutoLogin])
                    {
                        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                    }
                    else
                    {
                        [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                    }
                }
            } error:^(NSError *error){
                if (load)
                {
                    [load stop];
                }
                [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }];
        }];
    }
    return _deleteButton;
}
@end
