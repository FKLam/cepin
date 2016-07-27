//
//  EducationListVC.m
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EducationListVC.h"
#import "ResumeArrowCell.h"
#import "ResumeThridTimeView.h"
#import "NSDate-Utilities.h"
#import "UIViewController+NavicationUI.h"
#import "EditSchoolVC.h"
#import "EditMajorVC.h"
#import "ResumeEditDegreeVC.h"
#import "EducationListVM.h"
#import "ScoreRankVC.h"
#import "AddDescriptionVC.h"
#import "ResumeEditCell.h"
#import "CPTestEnsureArrowCell.h"
#import "RTNetworking+Resume.h"
#import "CPTestEnsureEditCell.h"
#import "BaseCodeDTO.h"
#import "CPWorkExperienceStartTimeView.h"
#import "CPResumeEducationReformer.h"
#import "CPResumeEducationSearchMatchCell.h"
#import "CPCommon.h"
@interface EducationListVC ()<CPWorkExperienceStartTimeViewDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, retain) CPWorkExperienceStartTimeView *timeView;
@property (nonatomic, strong) EducationListVM *viewModel;
@property (nonatomic, assign) BOOL isSocial;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) BaseCode *defaultDegree;
@property (nonatomic, strong) ResumeNameModel *resume;
@property (nonatomic, strong) UIView *searchSchoolResultBackgroundView;
@property (nonatomic, strong) UITableView *searchSchoolResultTableView;
@property (nonatomic, strong) UIView *searchMajorResultBackgroundView;
@property (nonatomic, strong) UITableView *searchMajorResultTableView;
@property (nonatomic, strong) NSMutableArray *searchSchoolResultArrayM;
@property (nonatomic, strong) NSMutableArray *searchMajorResultArrayM;
@end
@implementation EducationListVC
- (instancetype)initWithResumeId:(NSString *)resumeId isSocial:(Boolean)isSocial
{
    self = [super init];
    if (self) {
        self.isSocial  = isSocial;
        self.viewModel = [[EducationListVM alloc] initWithResumeid:resumeId];
        if ( !self.isSocial )
        {
            self.viewModel.resumeType = [NSNumber numberWithInt:2];
        }
        else
        {
            self.viewModel.resumeType = [NSNumber numberWithInt:1];
        }
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithResume:(ResumeNameModel *)resume isSocial:(Boolean)isSocial
{
    self = [super init];
    if ( self )
    {
        self.isSocial = isSocial;
        self.resume = resume;
        self.viewModel = [[EducationListVM alloc] initWithResumeid:resume.ResumeId];
        if ( !self.isSocial )
        {
            self.viewModel.resumeType = [NSNumber numberWithInt:2];
        }
        else
        {
            self.viewModel.resumeType = [NSNumber numberWithInt:1];
        }
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpDefaultDegree];
    [self setDefaultStartDate];
    [self setDefaultEndDate];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"教育经历";
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        [self.viewModel addEdu];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(32 / CP_GLOBALSCALE, 0, 0, 0)];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
           [self.navigationController popViewControllerAnimated:YES];
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
    if ( self.textField.keyboardType == UIKeyboardTypeNumberPad )
        viewFrame.size.height = keyboardTop - self.view.bounds.origin.y + 44.0;
    else
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.tableView )
        return  self.isSocial ? 5 : 8;
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
- (void)setUpDefaultDegree
{
    if ( !self.viewModel.eduData.Degree || 0 == [self.viewModel.eduData.Degree length] )
    {
        self.viewModel.eduData.Degree = self.defaultDegree.CodeName;
        self.viewModel.eduData.DegreeKey = [NSString stringWithFormat:@"%@", self.defaultDegree.CodeKey];
    }
}
- (void)setDefaultStartDate
{
    if (!self.viewModel.eduData.StartDate || [self.viewModel.eduData.StartDate isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strYear = [date stringyyyyFromDate];
        NSString *strMonth = @"09";
        NSString *studyStr = @"在读学生";
        NSString *educationStr = @"应届生";
        if ( ![self.resume.WorkYear isEqualToString:studyStr] && ![self.resume.WorkYear isEqualToString:educationStr] )
        {
            NSString *workYearStr = nil;
            if ( 0 == [self.resume.WorkYear length] )
            {
                workYearStr = @"";
            }
            else if ( 2 < [self.resume.WorkYear length] )
                workYearStr = [self.resume.WorkYear substringToIndex:2];
            else
                workYearStr = [self.resume.WorkYear substringToIndex:1];
            NSInteger defaultYear = [strYear intValue] - [workYearStr intValue] - 4;
            strYear = [NSString stringWithFormat:@"%ld", (long)defaultYear];
        }
        else
        {
            NSInteger defaultYear = [strYear intValue] - 4;
            strYear = [NSString stringWithFormat:@"%ld", (long)defaultYear];
        }
        self.viewModel.eduData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)strYear.intValue, (unsigned long)strMonth.intValue];
    }
}
- (void)setDefaultEndDate
{
    NSString *studyStr = @"在读学生";
    NSString *educationStr = @"应届生";
    NSString *degree1 = @"本科";
    NSString *degree2 = @"中专及以下";
    NSString *degree3 = @"大专";
    NSString *str = [NSDate cepinYMDFromString:self.viewModel.eduData.StartDate];
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = @"06";
    if ( ![self.resume.WorkYear isEqualToString:studyStr] && ![self.resume.WorkYear isEqualToString:educationStr] )
    {
        NSInteger defaultYear = [year intValue];
        if ( !self.viewModel.eduData.Degree || 0 == [self.viewModel.eduData.Degree length] )
        {
            defaultYear += 4;
        }
        else if ( [self.viewModel.eduData.Degree isEqualToString:degree1] )
        {
            defaultYear += 4;
            month = @"09";
        }
        else if ( [self.viewModel.eduData.Degree isEqualToString:degree2] || [self.viewModel.eduData.Degree isEqualToString:degree3] )
        {
            defaultYear += 3;
            month = @"09";
        }
        else
        {
            defaultYear += 2;
            month = @"09";
        }
        year = [NSString stringWithFormat:@"%ld", (long)defaultYear];
        self.viewModel.eduData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year.intValue, (unsigned long)month.intValue];
    }
    else
    {
        year = [NSString stringWithFormat:@"%ld", (long)([year intValue] + 4)];
        self.viewModel.eduData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year.intValue, (unsigned long)month.intValue];
    }
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
                BOOL isShowAll = NO;
                if ( 4 == indexPath.row )
                    isShowAll = YES;
                [cell resetSeparatorLineShowAll:isShowAll];
                return cell;
            }
            case 3:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"入学时间" placeholder:@"请选择入学时间"];
                if ( self.viewModel.eduData.StartDate && 0 < [self.viewModel.eduData.StartDate length] )
                {
                    NSString *startStr = [NSDate cepinYMDFromString:self.viewModel.eduData.StartDate];
                    [cell.inputTextField setText:startStr];
                }
                BOOL isShowAll = NO;
                if ( 4 == indexPath.row )
                    isShowAll = YES;
                [cell resetSeparatorLineShowAll:isShowAll];
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
                    NSString *startStr = [NSDate cepinYMDFromString:self.viewModel.eduData.EndDate];
                    [cell.inputTextField setText:startStr];
                }
                BOOL isShowAll = NO;
                if ( 4 == indexPath.row )
                    isShowAll = YES;
                [cell resetSeparatorLineShowAll:isShowAll];
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
                BOOL isShowAll = NO;
                if ( 7 == indexPath.row )
                    isShowAll = YES;
                [cell resetSeparatorLineShowAll:isShowAll];
                return cell;
            }
            case 1:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"学位类型" placeholder:@"请选择学位类型"];
                [cell.inputTextField setText:self.viewModel.eduData.XueWei];
                BOOL isShowAll = NO;
                if ( 7 == indexPath.row )
                    isShowAll = YES;
                [cell resetSeparatorLineShowAll:isShowAll];
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
                BOOL isShowAll = NO;
                if ( 7 == indexPath.row )
                    isShowAll = YES;
                [cell resetSeparatorLineShowAll:isShowAll];
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
                BOOL isShowAll = NO;
                if ( 7 == indexPath.row )
                    isShowAll = YES;
                [cell resetSeparatorLineShowAll:isShowAll];
                return cell;
            }
            case 6:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"成绩排名" placeholder:@"请选择成绩排名"];
                [cell.inputTextField setText:self.viewModel.eduData.ScoreRanking];
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
                BOOL isShowAll = NO;
                if ( 7 == indexPath.row )
                    isShowAll = YES;
                [cell resetSeparatorLineShowAll:isShowAll];
                return cell;
            }
            case 7:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell configCellLeftString:@"主修课程" placeholder:@"请输入主修课程"];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setText:self.viewModel.eduData.Description];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.eduData.Description = text;
                }];
                BOOL isShowAll = NO;
                if ( 7 == indexPath.row )
                    isShowAll = YES;
                [cell resetSeparatorLineShowAll:isShowAll];
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
    if (self.textField) {
        [self.textField resignFirstResponder];
    }
    if( self.isSocial && tableView == self.tableView )
    {
        switch (indexPath.row) {
            case 3:
            {
                if ( !self.searchSchoolResultBackgroundView.isHidden )
                    [self.searchSchoolResultBackgroundView setHidden:YES];
                if ( !self.searchMajorResultBackgroundView.isHidden )
                    [self.searchMajorResultBackgroundView setHidden:YES];
                [self displayTimeView:indexPath.row];
            }
                break;
            case 4:
            {
                if ( !self.searchSchoolResultBackgroundView.isHidden )
                    [self.searchSchoolResultBackgroundView setHidden:YES];
                if ( !self.searchMajorResultBackgroundView.isHidden )
                    [self.searchMajorResultBackgroundView setHidden:YES];
                [self displayTimeView:indexPath.row];
            }
                break;
            case 2:
            {
                if ( !self.searchSchoolResultBackgroundView.isHidden )
                    [self.searchSchoolResultBackgroundView setHidden:YES];
                if ( !self.searchMajorResultBackgroundView.isHidden )
                    [self.searchMajorResultBackgroundView setHidden:YES];
                ResumeEditDegreeVC *vc = [[ResumeEditDegreeVC alloc] initWithEduModel:self.viewModel.eduData isXueWei:NO];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
        
    }
    else if ( !self.isSocial && tableView == self.tableView )
    {
        switch (indexPath.row) {
            case 6:
            {
                if ( !self.searchSchoolResultBackgroundView.isHidden )
                    [self.searchSchoolResultBackgroundView setHidden:YES];
                if ( !self.searchMajorResultBackgroundView.isHidden )
                    [self.searchMajorResultBackgroundView setHidden:YES];
                ScoreRankVC *vc = [[ScoreRankVC alloc] initWithModel:self.viewModel.eduData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                if ( !self.searchSchoolResultBackgroundView.isHidden )
                    [self.searchSchoolResultBackgroundView setHidden:YES];
                if ( !self.searchMajorResultBackgroundView.isHidden )
                    [self.searchMajorResultBackgroundView setHidden:YES];
                [self displayTimeView:indexPath.row];
            }
                break;
            case 5:
            {
                if ( !self.searchSchoolResultBackgroundView.isHidden )
                    [self.searchSchoolResultBackgroundView setHidden:YES];
                if ( !self.searchMajorResultBackgroundView.isHidden )
                    [self.searchMajorResultBackgroundView setHidden:YES];
                [self displayTimeView:indexPath.row];
            }
                break;
            case 1:
            {
                if ( !self.searchSchoolResultBackgroundView.isHidden )
                    [self.searchSchoolResultBackgroundView setHidden:YES];
                if ( !self.searchMajorResultBackgroundView.isHidden )
                    [self.searchMajorResultBackgroundView setHidden:YES];
                ResumeEditDegreeVC *vc = [[ResumeEditDegreeVC alloc] initWithEduModel:self.viewModel.eduData isXueWei:YES];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 0:
            {
                if ( !self.searchSchoolResultBackgroundView.isHidden )
                    [self.searchSchoolResultBackgroundView setHidden:YES];
                if ( !self.searchMajorResultBackgroundView.isHidden )
                    [self.searchMajorResultBackgroundView setHidden:YES];
                ResumeEditDegreeVC *vc = [[ResumeEditDegreeVC alloc] initWithEduModel:self.viewModel.eduData isXueWei:NO];
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
    }else
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
-(void)displayTimeView:(NSInteger)tag
{
    if (self.textField) {
        [self.textField resignFirstResponder];
    }
    if (!self.timeView)
    {
        self.timeView = [[CPWorkExperienceStartTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
    if(self.isSocial){
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
-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if ( self.isSocial )
    {
        if (self.timeView.tag == 4)
        {
            self.viewModel.eduData.EndDate = [NSString stringWithFormat:@"%lu-%lu-01",(unsigned long)year,(unsigned long)month];
        }
        else
        {
            self.viewModel.eduData.StartDate = [NSString stringWithFormat:@"%lu-%lu-01",(unsigned long)year,(unsigned long)month];
            [self setDefaultEndDate];
        }
    }
    else
    {
        if (self.timeView.tag == 5)
        {
            self.viewModel.eduData.EndDate = [NSString stringWithFormat:@"%lu-%lu-01",(unsigned long)year,(unsigned long)month];
        }
        else
        {
            self.viewModel.eduData.StartDate = [NSString stringWithFormat:@"%lu-%lu-01",(unsigned long)year,(unsigned long)month];
        }
    }
    [self.tableView reloadData];
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
#pragma mark - getter methods
- (BaseCode *)defaultDegree
{
    if ( !_defaultDegree )
    {
        _defaultDegree = [[BaseCode alloc] init];
        _defaultDegree.CodeName = @"本科";
        NSMutableArray *baseCodeArrayM = [BaseCode degrees];
        for ( BaseCode *tempBaseCode in baseCodeArrayM )
        {
            if ( [_defaultDegree.CodeName isEqualToString:tempBaseCode.CodeName] )
            {
                _defaultDegree = tempBaseCode;
                break;
            }
        }
    }
    return _defaultDegree;
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
