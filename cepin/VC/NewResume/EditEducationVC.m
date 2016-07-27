//
//  EditEducationVC.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditEducationVC.h"
#import "ResumeArrowCell.h"
#import "ResumeThridTimeView.h"
#import "NSDate-Utilities.h"
#import "UIViewController+NavicationUI.h"
#import "EditSchoolVC.h"
#import "EditMajorVC.h"
#import "ResumeEditDegreeVC.h"
#import "EditEducationVM.h"
#import "AddDescriptionVC.h"
#import "ResumeEditCell.h"
#import "ScoreRankVC.h"
#import "CPTestEnsureArrowCell.h"
#import "CPTestEnsureEditCell.h"
#import "RTNetworking+Resume.h"
#import "CPWorkExperienceStartTimeView.h"
#import "CPResumeEducationReformer.h"
#import "CPResumeEducationSearchMatchCell.h"
#import "CPCommon.h"
@interface EditEducationVC ()<CPWorkExperienceStartTimeViewDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CPWorkExperienceStartTimeView *timeView;
@property (nonatomic, strong) EditEducationVM *viewModel;
@property (nonatomic, assign) BOOL isSocial;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *secondFooterView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *searchSchoolResultBackgroundView;
@property (nonatomic, strong) UITableView *searchSchoolResultTableView;
@property (nonatomic, strong) UIView *searchMajorResultBackgroundView;
@property (nonatomic, strong) UITableView *searchMajorResultTableView;
@property (nonatomic, strong) NSMutableArray *searchSchoolResultArrayM;
@property (nonatomic, strong) NSMutableArray *searchMajorResultArrayM;
@end
@implementation EditEducationVC
- (instancetype)initWithModel:(EducationListDateModel *)model isSocial:(BOOL)isSocial
{
    self = [super init];
    if (self) {
        self.viewModel = [[EditEducationVM alloc]initWithWork:model];
        self.isSocial = isSocial;
        if( self.isSocial )
        {
            self.viewModel.resumeType = [NSNumber numberWithInt:1];
        }
        else
        {
            self.viewModel.resumeType = [NSNumber numberWithInt:2];
        }
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑教育经历";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        [self.viewModel saveEdu];
        [MobClick event:@"save_education_experience"];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    [self.tableView setScrollEnabled:YES];
    [self.tableView setClipsToBounds:NO];
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
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
    [self.tableView addSubview:self.searchSchoolResultBackgroundView];
    [self.tableView addSubview:self.searchMajorResultBackgroundView];
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
    if ( 0 == self.textField.tag || 1 == self.textField.tag )
        return;
    NSValue *userValue = [userNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [userValue CGRectValue];
    CGFloat keyboardTop = keyboardEndFrame.origin.y;
    CGFloat duration = [[userNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.tableView.frame = viewFrame;
    }];
}
- (void)listenKeyboardWillHide:(NSNotification *)userNotification
{
    if ( 0 == self.textField.tag || 1 == self.textField.tag )
        return;
    CGFloat duration = [[userNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect viewFrame = self.view.bounds;
    viewFrame.origin.y = self.view.bounds.origin.y + 44.0 + 20.0;
    viewFrame.size.height = self.view.bounds.size.height - 44 - 20;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.tableView.frame = viewFrame;
    }];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.tableView )
    {
        if ( self.isSocial )
            return 5;
        else
            return 8;
    }
    else if ( tableView == self.searchSchoolResultTableView )
    {
        return [self.searchSchoolResultArrayM count];
    }
    else if ( tableView == self.searchMajorResultTableView )
    {
        return [self.searchMajorResultArrayM count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.isSocial && tableView == self.tableView )
    {
        switch ( indexPath.row )
        {
            case 0:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField addTarget:self action:@selector(textFieldTextDidChangeOneCI:) forControlEvents:UIControlEventEditingChanged];
                [cell configCellLeftString:@"学校名称" placeholder:@"请输入学校名称"];
                [cell.inputTextField setText:self.viewModel.eduData.School];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.eduData.School = text;
                }];
                if ( 4 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 1:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField addTarget:self action:@selector(textFieldTextDidChangeOneCI:) forControlEvents:UIControlEventEditingChanged];
                [cell configCellLeftString:@"专业名称" placeholder:@"请输入专业名称"];
                [cell.inputTextField setText:self.viewModel.eduData.Major];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.eduData.Major = text;
                }];
                if ( 4 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 2:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"学  历" placeholder:@"请选择学历"];
                [cell.inputTextField setText:self.viewModel.eduData.Degree];
                if ( 4 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 3:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"入学时间" placeholder:@"请选择入学时间"];
                [cell.inputTextField setText:[NSDate cepinYMDFromString:self.viewModel.eduData.StartDate]];
                if ( 4 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 4:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"毕业时间" placeholder:@"请选择毕业时间"];
                if ( !self.viewModel.eduData.EndDate || [self.viewModel.eduData.EndDate isEqualToString:@""])
                {
                    cell.inputTextField.text = @"至今";
                }
                else
                {
                    [cell.inputTextField setText:[NSDate cepinYMDFromString:self.viewModel.eduData.EndDate]];
                }
                if ( 4 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
        }
    }
    else if ( !self.isSocial && tableView == self.tableView )
    {
        switch ( indexPath.row )
        {
            case 0:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"学历类型" placeholder:@"请选择学历类型"];
                [cell.inputTextField setText:self.viewModel.eduData.Degree];
                return cell;
            }
            case 1:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"学位类型" placeholder:@"请选择学位类型"];
                [cell.inputTextField setText:self.viewModel.eduData.XueWei];
                return cell;
            }
            case 2:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField addTarget:self action:@selector(textFieldTextDidChangeOneCI:) forControlEvents:UIControlEventEditingChanged];
                [cell configCellLeftString:@"学校名称" placeholder:@"请输入学校名称"];
                [cell.inputTextField setText:self.viewModel.eduData.School];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.eduData.School = text;
                }];
                if ( 7 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 3:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField addTarget:self action:@selector(textFieldTextDidChangeOneCI:) forControlEvents:UIControlEventEditingChanged];
                [cell configCellLeftString:@"专业名称" placeholder:@"请输入专业名称"];
                [cell.inputTextField setText:self.viewModel.eduData.Major];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.eduData.Major = text;
                }];
                if ( 7 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 4:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"入学时间" placeholder:@"请选择入学时间"];
                if ( !self.viewModel.eduData.StartDate || [self.viewModel.eduData.StartDate isEqualToString:@""])
                {
                    cell.inputTextField.text = @"至今";
                }
                else
                {
                    [cell.inputTextField setText:[NSDate cepinYMDFromString:self.viewModel.eduData.StartDate]];
                }
                return cell;
            }
            case 5:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"毕业时间" placeholder:@"请选择毕业时间"];
                if ( !self.viewModel.eduData.EndDate || [self.viewModel.eduData.EndDate isEqualToString:@""])
                {
                    cell.inputTextField.text = @"至今";
                }
                else
                {
                    [cell.inputTextField setText:[NSDate cepinYMDFromString:self.viewModel.eduData.EndDate]];
                }
                return cell;
            }
            case 6:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"成绩排名" placeholder:@"请选择成绩排名"];
                if( self.viewModel.eduData.ScoreRanking )
                {
                    if([@"5" isEqualToString:self.viewModel.eduData.ScoreRanking])
                    {
                        cell.inputTextField.text = @"年级前5%";
                    }
                    else if([@"10" isEqualToString:self.viewModel.eduData.ScoreRanking])
                    {
                        cell.inputTextField.text = @"年级前10%";
                    }
                    else if([@"20" isEqualToString:self.viewModel.eduData.ScoreRanking])
                    {
                        cell.inputTextField.text = @"年级前20%";
                    }
                    else if([@"50" isEqualToString:self.viewModel.eduData.ScoreRanking])
                    {
                        cell.inputTextField.text = @"年级前50%";
                    }
                    else if([@"0" isEqualToString:self.viewModel.eduData.ScoreRanking])
                    {
                        cell.inputTextField.text = @"其他";
                    }
                }
                return cell;
            }
            case 7:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell configCellLeftString:@"主修课程" placeholder:@"请输入主修课程"];
                [cell.inputTextField setText:self.viewModel.eduData.Description];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.eduData.Description = text;
                }];
                if ( 7 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
        }
    }
    else if ( tableView == self.searchSchoolResultTableView )
    {
        CPResumeEducationSearchMatchCell *cell = [CPResumeEducationSearchMatchCell  educationSearchMatchCellWithTableView:tableView];
        School *school = self.searchSchoolResultArrayM[indexPath.row];
        BOOL isHideSeparatorLine = NO;
        if ( indexPath.row == [self.searchSchoolResultArrayM count] - 1 )
            isHideSeparatorLine = YES;
        [cell configWithSchool:school isHideSeparatorLine:isHideSeparatorLine];
        return cell;
    }
    else if ( tableView == self.searchMajorResultTableView )
    {
        CPResumeEducationSearchMatchCell *cell = [CPResumeEducationSearchMatchCell  educationSearchMatchCellWithTableView:tableView];
        BaseCode *major = self.searchMajorResultArrayM[indexPath.row];
        BOOL isHideSeparatorLine = NO;
        if ( indexPath.row == [self.searchMajorResultArrayM count] - 1 )
            isHideSeparatorLine = YES;
        [cell configWithMajor:major isHideSeparatorLine:isHideSeparatorLine];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ( self.textField ) {
        [self.textField resignFirstResponder];
    }
    if( self.isSocial && tableView == self.tableView )
    {
        switch (indexPath.row) {
            case 3:
            {
                [self displayTimeView:indexPath.row];
            }
                break;
            case 4:
            {
                [self displayTimeView:indexPath.row];
            }
                break;
                break;
            case 2:
            {
                ResumeEditDegreeVC *vc = [[ResumeEditDegreeVC alloc]initWithEduModel:self.viewModel.eduData isXueWei:NO];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
        
    }
    else if ( !self.isSocial && tableView == self.tableView )
    {
        switch ( indexPath.row )
        {
            case 6:
            {
                ScoreRankVC *vc = [[ScoreRankVC alloc]initWithModel:self.viewModel.eduData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                [self displayTimeView:indexPath.row];
            }
                break;
            case 5:
            {
                [self displayTimeView:indexPath.row];
            }
                break;
            case 0:
            {
                ResumeEditDegreeVC *vc = [[ResumeEditDegreeVC alloc] initWithEduModel:self.viewModel.eduData isXueWei:NO];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                ResumeEditDegreeVC *vc = [[ResumeEditDegreeVC alloc]initWithEduModel:self.viewModel.eduData isXueWei:YES];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if ( tableView == self.searchSchoolResultTableView )
    {
        [self.searchSchoolResultBackgroundView setHidden:YES];
        if ( self.isSocial )
        {
            School *school = self.searchSchoolResultArrayM[indexPath.row];
            self.viewModel.eduData.School = school.Name;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            School *school = self.searchSchoolResultArrayM[indexPath.row];
            self.viewModel.eduData.School = school.Name;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if ( tableView == self.searchMajorResultTableView )
    {
        [self.searchMajorResultBackgroundView setHidden:YES];
        if ( self.isSocial )
        {
            BaseCode *major = self.searchMajorResultArrayM[indexPath.row];
            self.viewModel.eduData.Major = major.CodeName;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            BaseCode *major = self.searchMajorResultArrayM[indexPath.row];
            self.viewModel.eduData.Major = major.CodeName;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ( scrollView != self.searchSchoolResultTableView && scrollView != self.searchMajorResultTableView )
    {
        if ( !self.searchSchoolResultBackgroundView.isHidden )
            [self.searchSchoolResultBackgroundView setHidden:YES];
        if ( !self.searchMajorResultBackgroundView.isHidden )
            [self.searchMajorResultBackgroundView setHidden:YES];
        [self.view endEditing:YES];
    }
}
- (void)textFieldTextDidChangeOneCI:(UITextField *)textField
{
    if ( self.isSocial )
    {
        if ( textField.tag == 0 )
        {
            NSString *text = textField.text;
            NSArray *tempMatchArray = [CPResumeEducationReformer searchSchoolWithMatchString:text];
            [self.searchSchoolResultArrayM removeAllObjects];
            if ( 0 < [tempMatchArray count] )
            {
                [self.searchSchoolResultBackgroundView setHidden:NO];
                [self.searchSchoolResultArrayM addObjectsFromArray:tempMatchArray];
            }
            else
                [self.searchSchoolResultBackgroundView setHidden:YES];
            [self.searchSchoolResultTableView reloadData];
        }
        else if ( textField.tag == 1 )
        {
            NSString *text = textField.text;
            NSArray *tempMatchArray = [CPResumeEducationReformer searchMajorWithMatchString:text];
            [self.searchMajorResultArrayM removeAllObjects];
            if ( 0 < [tempMatchArray count] )
            {
                [self.searchMajorResultBackgroundView setHidden:NO];
                [self.searchMajorResultArrayM addObjectsFromArray:tempMatchArray];
            }
            else
                [self.searchMajorResultBackgroundView setHidden:YES];
            [self.searchMajorResultTableView reloadData];
        }
    }
    else
    {
        if ( textField.tag == 2 )
        {
            NSString *text = textField.text;
            NSArray *tempMatchArray = [CPResumeEducationReformer searchSchoolWithMatchString:text];
            [self.searchSchoolResultArrayM removeAllObjects];
            if ( 0 < [tempMatchArray count] )
            {
                [self.searchSchoolResultBackgroundView setHidden:NO];
                [self.searchSchoolResultArrayM addObjectsFromArray:tempMatchArray];
            }
            else
                [self.searchSchoolResultBackgroundView setHidden:YES];
            [self.searchSchoolResultTableView reloadData];
        }
        else if ( textField.tag == 3 )
        {
            NSString *text = textField.text;
            NSArray *tempMatchArray = [CPResumeEducationReformer searchMajorWithMatchString:text];
            [self.searchMajorResultArrayM removeAllObjects];
            if ( 0 < [tempMatchArray count] )
            {
                [self.searchMajorResultBackgroundView setHidden:NO];
                [self.searchMajorResultArrayM addObjectsFromArray:tempMatchArray];
            }
            else
                [self.searchMajorResultBackgroundView setHidden:YES];
            [self.searchMajorResultTableView reloadData];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( !self.searchSchoolResultBackgroundView.isHidden )
        [self.searchSchoolResultBackgroundView setHidden:YES];
    if ( !self.searchMajorResultBackgroundView.isHidden )
        [self.searchMajorResultBackgroundView setHidden:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    if ( self.isSocial )
    {
        if ( 0 == textField.tag && 0 < [self.searchSchoolResultArrayM count] )
        {
            if ( self.searchSchoolResultBackgroundView.isHidden )
                [self.searchSchoolResultBackgroundView setHidden:NO];
            if ( !self.searchMajorResultBackgroundView.isHidden )
                [self.searchMajorResultBackgroundView setHidden:YES];
        }
        else if ( 0 == textField.tag && 0 == [self.searchSchoolResultArrayM count] )
        {
            if ( !self.searchMajorResultBackgroundView.isHidden )
                [self.searchMajorResultBackgroundView setHidden:YES];
        }
        else if ( 1 == textField.tag && 0 < [self.searchMajorResultArrayM count] )
        {
            if ( !self.searchSchoolResultBackgroundView.isHidden )
                [self.searchSchoolResultBackgroundView setHidden:YES];
            if ( self.searchMajorResultBackgroundView.isHidden )
                [self.searchMajorResultBackgroundView setHidden:NO];
        }
        else if ( 1 == textField.tag && 0 == [self.searchMajorResultArrayM count] )
        {
            if ( !self.searchSchoolResultBackgroundView.isHidden )
                [self.searchSchoolResultBackgroundView setHidden:YES];
        }
    }
    else
    {
        if ( 2 == textField.tag && 0 < [self.searchSchoolResultArrayM count] )
        {
            if ( self.searchSchoolResultBackgroundView.isHidden )
                [self.searchSchoolResultBackgroundView setHidden:NO];
            if ( !self.searchMajorResultBackgroundView.isHidden )
                [self.searchMajorResultBackgroundView setHidden:YES];
        }
        else if ( 2 == textField.tag && 0 == [self.searchSchoolResultArrayM count] )
        {
            if ( !self.searchMajorResultBackgroundView.isHidden )
                [self.searchMajorResultBackgroundView setHidden:YES];
        }
        else if ( 3 == textField.tag && 0 < [self.searchMajorResultArrayM count] )
        {
            if ( !self.searchSchoolResultBackgroundView.isHidden )
                [self.searchSchoolResultBackgroundView setHidden:YES];
            if ( self.searchMajorResultBackgroundView.isHidden )
                [self.searchMajorResultBackgroundView setHidden:NO];
        }
        else if ( 3 == textField.tag && 0 == [self.searchMajorResultArrayM count] )
        {
            if ( !self.searchSchoolResultBackgroundView.isHidden )
                [self.searchSchoolResultBackgroundView setHidden:YES];
        }
    }
    return YES;
}
-(void)displayTimeView:(NSInteger)tag
{
    if (self.textField)
    {
        [self.textField resignFirstResponder];
    }
    if (!self.timeView)
    {
        self.timeView = [[CPWorkExperienceStartTimeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.timeView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
        self.timeView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:self.timeView];
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
    if( self.isSocial )
    {
        if ( self.timeView.tag == 3 )
        {
            if (!self.viewModel.eduData.StartDate || [self.viewModel.eduData.StartDate isEqualToString:@""])
            {
                NSDate *date = [NSDate date];
                NSString *strYear = [NSString stringWithFormat:@"%d",[[date stringyyyyFromDate] intValue] - 4];
                NSString *strMonth = @"09";
                [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
                return;
            }
            str = [NSDate cepinYMDFromString:self.viewModel.eduData.StartDate];
        }
        else
        {
            if (!self.viewModel.eduData.EndDate || [self.viewModel.eduData.EndDate isEqualToString:@""])
            {
                NSDate *date = [NSDate date];
                NSString *strYear = [date stringyyyyFromDate];
                NSString *strMonth = @"06";
                [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
                return;
            }
            str = [NSDate cepinYMDFromString:self.viewModel.eduData.EndDate];
        }
    }
    else
    {
        if ( self.timeView.tag == 4 )
        {
            if (!self.viewModel.eduData.StartDate || [self.viewModel.eduData.StartDate isEqualToString:@""])
            {
                NSDate *date = [NSDate date];
                NSString *strYear = [NSString stringWithFormat:@"%d",[[date stringyyyyFromDate] intValue] - 4];
                NSString *strMonth = @"09";
                [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
                return;
            }
            str = [NSDate cepinYMDFromString:self.viewModel.eduData.StartDate];
        }
        else
        {
            if (!self.viewModel.eduData.EndDate || [self.viewModel.eduData.EndDate isEqualToString:@""])
            {
                NSDate *date = [NSDate date];
                NSString *strYear = [date stringyyyyFromDate];
                NSString *strMonth = @"06";
                [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
                return;
            }
            str = [NSDate cepinYMDFromString:self.viewModel.eduData.EndDate];
        }
    }
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue];
}
- (void)clickCancelButton
{
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if ( self.isSocial ) {
        if ( self.timeView.tag == 4 )
        {
            self.viewModel.eduData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)
                                              month];
        }
        else
        {
            self.viewModel.eduData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
        }
    }
    else
    {
        if (self.timeView.tag == 5)
        {
            self.viewModel.eduData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
        }
        else
        {
            self.viewModel.eduData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
        }
    }
    [self.tableView reloadData];
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
#pragma mark - getter
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
- (UIButton *)deleteButton
{
    if ( !_deleteButton )
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE ]];
        [_deleteButton setTitle:@"删除该项教育经历" forState:UIControlStateNormal];
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
            RACSignal *signal = [[RTNetworking shareInstance]deleteThridResumeEducationListWithResumeId:self.viewModel.resumeId eduId:self.viewModel.eduId userId:userId tokenId:TokenId];
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
- (UIView *)searchSchoolResultBackgroundView
{
    if ( !_searchSchoolResultBackgroundView )
    {
        CGFloat X = ( 40 + 42 * 4 + 40 ) / CP_GLOBALSCALE;
        CGFloat Y = 144 / CP_GLOBALSCALE;
        if ( !self.isSocial )
            Y += 144 / CP_GLOBALSCALE * 2;
        CGFloat W = kScreenWidth - X - 40 / CP_GLOBALSCALE;
        CGFloat H = 144 / CP_GLOBALSCALE * 4 - 8 / CP_GLOBALSCALE;
        _searchSchoolResultBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [_searchSchoolResultBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [_searchSchoolResultBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_searchSchoolResultBackgroundView.layer setShadowColor:[UIColor colorWithHexString:@"000000" alpha:1.0].CGColor];
        [_searchSchoolResultBackgroundView.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [_searchSchoolResultBackgroundView.layer setBorderColor:[UIColor colorWithHexString:@"ede3e6"].CGColor];
        [_searchSchoolResultBackgroundView.layer setShadowOffset:CGSizeMake(4 / CP_GLOBALSCALE, 5 / CP_GLOBALSCALE)];
        [_searchSchoolResultBackgroundView.layer setShadowRadius:5 / CP_GLOBALSCALE];
        [_searchSchoolResultBackgroundView.layer setShadowOpacity:0.2];
        [_searchSchoolResultBackgroundView setHidden:YES];
        [_searchSchoolResultBackgroundView addSubview:self.searchSchoolResultTableView];
    }
    return _searchSchoolResultBackgroundView;
}
- (UIView *)searchSchoolResultTableView
{
    if ( !_searchSchoolResultTableView )
    {
        CGFloat X = 0;
        CGFloat Y = 0;
        CGFloat margin = ( 40 + 42 * 4 + 40 ) / CP_GLOBALSCALE;
        CGFloat W = kScreenWidth - margin - 40 / CP_GLOBALSCALE;
        CGFloat H = 144 / CP_GLOBALSCALE * 4 - 8 / CP_GLOBALSCALE;
        _searchSchoolResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(X, Y, W, H) style:UITableViewStylePlain];
        [_searchSchoolResultTableView setDelegate:self];
        [_searchSchoolResultTableView setDataSource:self];
        [_searchSchoolResultTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_searchSchoolResultTableView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_searchSchoolResultTableView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_searchSchoolResultTableView setClipsToBounds:YES];
    }
    return _searchSchoolResultTableView;
}
- (UIView *)searchMajorResultBackgroundView
{
    if ( !_searchMajorResultBackgroundView )
    {
        CGFloat X = ( 40 + 42 * 4 + 40 ) / CP_GLOBALSCALE;
        CGFloat Y = 144 / CP_GLOBALSCALE * 2;
        if ( !self.isSocial )
            Y += 144 / CP_GLOBALSCALE * 2;
        CGFloat W = kScreenWidth - X - 40 / CP_GLOBALSCALE;
        CGFloat H = 144 / CP_GLOBALSCALE * 3 - 8 / CP_GLOBALSCALE;
        _searchMajorResultBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [_searchMajorResultBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [_searchMajorResultBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_searchMajorResultBackgroundView.layer setShadowColor:[UIColor colorWithHexString:@"000000" alpha:1.0].CGColor];
        [_searchMajorResultBackgroundView.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [_searchMajorResultBackgroundView.layer setBorderColor:[UIColor colorWithHexString:@"ede3e6"].CGColor];
        [_searchMajorResultBackgroundView.layer setShadowOffset:CGSizeMake(4 / CP_GLOBALSCALE, 5 / CP_GLOBALSCALE)];
        [_searchMajorResultBackgroundView.layer setShadowRadius:5 / CP_GLOBALSCALE];
        [_searchMajorResultBackgroundView.layer setShadowOpacity:0.2];
        [_searchMajorResultBackgroundView setHidden:YES];
        [_searchMajorResultBackgroundView addSubview:self.searchMajorResultTableView];
    }
    return _searchMajorResultBackgroundView;
}
- (UITableView *)searchMajorResultTableView
{
    if ( !_searchMajorResultTableView )
    {
        CGFloat X = 0;
        CGFloat Y = 0;
        CGFloat margin = ( 40 + 42 * 4 + 40 ) / CP_GLOBALSCALE;
        CGFloat W = kScreenWidth - margin - 40 / CP_GLOBALSCALE;
        CGFloat H = 144 / CP_GLOBALSCALE * 3 - 8 / CP_GLOBALSCALE;
        _searchMajorResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(X, Y, W, H) style:UITableViewStylePlain];
        [_searchMajorResultTableView setDelegate:self];
        [_searchMajorResultTableView setDataSource:self];
        [_searchMajorResultTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_searchMajorResultTableView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_searchMajorResultTableView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_searchMajorResultTableView setClipsToBounds:YES];
    }
    return _searchMajorResultTableView;
}
- (NSMutableArray *)searchSchoolResultArrayM
{
    if ( !_searchSchoolResultArrayM )
    {
        _searchSchoolResultArrayM = [NSMutableArray array];
    }
    return _searchSchoolResultArrayM;
}
- (NSMutableArray *)searchMajorResultArrayM
{
    if ( !_searchMajorResultArrayM )
    {
        _searchMajorResultArrayM = [NSMutableArray array];
    }
    return _searchMajorResultArrayM;
}
@end