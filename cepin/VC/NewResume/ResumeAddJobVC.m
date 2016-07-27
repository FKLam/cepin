//
//  ResumeAddJobVC.m
//  cepin
//
//  Created by dujincai on 15/6/24.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeAddJobVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "ResumeAddMoreCell.h"
#import "ResumeEditCell.h"
#import "ResumeThridTimeView.h"
#import "ResumeAddJobVM.h"
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
#import "CPResumeMoreButton.h"
#import "CPTestEnsureArrowCell.h"
#import "CPTestEnsureEditCell.h"
#import "ResumeNameModel.h"
#import "CPWorkExperienceStartTimeView.h"
#import "CPCommon.h"
@interface ResumeAddJobVC ()<UITextFieldDelegate, CPWorkExperienceStartTimeViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic)BOOL addMore;
@property(nonatomic,retain) CPWorkExperienceStartTimeView *timeView;
@property(nonatomic,strong)ResumeAddJobVM *viewModel;
@property(nonatomic,strong)UITextField *textField;
@property (nonatomic, strong) UIView *firstFooterView;
@property (nonatomic, strong) CPResumeMoreButton *moreButton;
@property (nonatomic, assign) CGFloat lastRoWHeight;
@end
@implementation ResumeAddJobVC
- (instancetype)initWithResumeId:(NSString*)resumeId
{
    self = [super init];
    if (self) {
        self.viewModel = [[ResumeAddJobVM alloc] initWithResumeid:resumeId];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithResume:(ResumeNameModel *)resume
{
    self = [super init];
    if ( self )
    {
        self.viewModel = [[ResumeAddJobVM alloc] initWtihRsume:resume];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加工作经历";
    self.lastRoWHeight = 0.0;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.textField resignFirstResponder];
        [self.viewModel addWork];
    }];
    self.addMore = YES;
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    if ( 10 != self.textField.tag )
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
    if ( 10 != self.textField.tag )
        return;
    CGFloat duration = [[userNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect viewFrame = self.view.bounds;
    viewFrame.origin.y = self.view.bounds.origin.y + 40.0 + 20.0;
    viewFrame.size.height = self.view.bounds.size.height - 40 - 20;
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
        return 2;
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
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell configCellLeftString:@"公司名称" placeholder:@"请输入公司名称"];
                [cell.inputTextField setText:self.viewModel.workData.Company];
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text)
                 {
                     if ( cell.inputTextField.tag != indexPath.row + indexPath.section * 10 )
                         return;
                     self.viewModel.workData.Company = text;
                 }];
                return cell;
            }
            case 1:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell configCellLeftString:@"职位名称" placeholder:@"请输入职位名称"];
                [cell.inputTextField setText:self.viewModel.workData.JobFunction];
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text)
                 {
                     if ( cell.inputTextField.tag != indexPath.row + indexPath.section * 10 )
                         return;
                     self.viewModel.workData.JobFunction = text;
                 }];
                return cell;
            }
            case 2:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"行  业" placeholder:@"请选择行业"];
                [cell.inputTextField setText:self.viewModel.workData.Industry];
                if ( indexPath.row == 5 )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 3:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"开始时间" placeholder:@"请选择开始时间"];
                if (!self.viewModel.workData.StartDate || [self.viewModel.workData.StartDate isEqualToString:@""])
                {
                    [self setDefaultStartDate];
                }
                [cell.inputTextField setText:[NSDate cepinYMDFromString:self.viewModel.workData.StartDate]];
                if ( indexPath.row == 5 )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 4:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"结束时间" placeholder:@"请选择结束时间"];
                if ( [self.viewModel.workData.EndDate length] > 0 )
                    [cell.inputTextField setText:[NSDate cepinYMDFromString:self.viewModel.workData.EndDate]];
                else
                    [cell.inputTextField setText:@"至今"];
                if ( indexPath.row == 5 )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 5:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"工作职责" placeholder:@"请输入工作职责"];
                if (self.viewModel.workData.Content && ![self.viewModel.workData.Content isEqualToString:@""])
                {
                    cell.inputTextField.text = @"已添加";
                }
                else
                {
                    cell.inputTextField.text = @"";
                }
                if ( indexPath.row == 5 )
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
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"薪  资" placeholder:@"请输入薪资"];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setText:self.viewModel.workData.Salary];
                cell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text)
                 {
                     if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                         return;
                     self.viewModel.workData.Salary = text;
                 }];
                [cell setHidden:!self.moreButton.isSelected];
                return cell;
            }
            case 1:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"公司规模" placeholder:@"请选择规模"];
                [cell.inputTextField setText:self.viewModel.workData.Size];
                [cell setHidden:!self.moreButton.isSelected];
                if ( indexPath.row == 1 )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
        }
    }
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
            case 2:
            {
                ResumeCompanyIndustryVC *vc = [[ResumeCompanyIndustryVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 6:
            {
                ResumeCompanyJobNameVC *vc = [[ResumeCompanyJobNameVC alloc] initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:
            {
                ResumeCompanyDescribeVC *vc = [[ResumeCompanyDescribeVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 10:
            {
                ResumeCompanyAddressVC *vc = [[ResumeCompanyAddressVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 11:
            {
                ResumeCompanyRankingVC *vc = [[ResumeCompanyRankingVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 12:
            {
                ResumeCompanyScaleVC *vc = [[ResumeCompanyScaleVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
            }
            default:
                break;
        }
    }
    else
    {
        switch ( indexPath.row )
        {
            case 1:
            {
                ResumeCompanyScaleVC *vc = [[ResumeCompanyScaleVC alloc]initWithWorkModel:self.viewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
        }
    }
}
-(void)displayTimeView:(NSUInteger)tag
{
    if (self.textField) {
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
    if ( self.timeView.tag == 3 )
    {
        if (!self.viewModel.workData.StartDate || [self.viewModel.workData.StartDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = @"06";
            NSString *studyStr = @"在读学生";
            NSString *educationStr = @"应届生";
            if ( ![self.viewModel.resume.WorkYear isEqualToString:studyStr] && ![self.viewModel.resume.WorkYear isEqualToString:educationStr] )
            {
                NSString *workYearStr = nil;
                if ( 2 < [self.viewModel.resume.WorkYear length] )
                    workYearStr = [self.viewModel.resume.WorkYear substringToIndex:2];
                else
                    workYearStr = [self.viewModel.resume.WorkYear substringToIndex:1];
                NSInteger defaultYear = [strYear intValue] - [workYearStr intValue];
                NSLog(@"%ld", (long)defaultYear);
                strYear = [NSString stringWithFormat:@"%ld", (long)defaultYear];
            }
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
- (void)setDefaultStartDate
{
    if (!self.viewModel.workData.StartDate || [self.viewModel.workData.StartDate isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strYear = [date stringyyyyFromDate];
        NSString *strMonth = @"06";
        NSString *studyStr = @"在读学生";
        NSString *educationStr = @"应届生";
        if ( ![self.viewModel.resume.WorkYear isEqualToString:studyStr] && ![self.viewModel.resume.WorkYear isEqualToString:educationStr] )
        {
            NSString *workYearStr = nil;
            if ( 0 == [self.viewModel.resume.WorkYear length] )
            {
                workYearStr = @"";
            }
            else if ( 2 < [self.viewModel.resume.WorkYear length] )
                workYearStr = [self.viewModel.resume.WorkYear substringToIndex:2];
            else
                workYearStr = [self.viewModel.resume.WorkYear substringToIndex:1];
            NSInteger defaultYear = [strYear intValue] - [workYearStr intValue];
            strYear = [NSString stringWithFormat:@"%ld", (long)defaultYear];
        }
        self.viewModel.workData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)strYear.intValue, (unsigned long)strMonth.intValue];
    }
}
- (void)clickCancelButton
{
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if (self.timeView.tag == 4)
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - getter method
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
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1], [NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
    return _moreButton;
}
- (UIView *)firstFooterView
{
    if ( !_firstFooterView )
    {
        _firstFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 40 + 144 + 40 ) / CP_GLOBALSCALE )];
        [_firstFooterView setBackgroundColor:[UIColor clearColor]];
        [_firstFooterView addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _firstFooterView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _firstFooterView.mas_left );
            make.right.equalTo( _firstFooterView.mas_right );
            make.bottom.equalTo( _firstFooterView.mas_bottom ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return _firstFooterView;
}
@end
