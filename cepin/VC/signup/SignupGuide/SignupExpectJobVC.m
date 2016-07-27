//
//  SignupExpectJobVC.m
//  cepin
//
//  Created by dujincai on 15/7/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SignupExpectJobVC.h"
#import "ExpectJobCell.h"
#import "UIViewController+NavicationUI.h"
#import "ExpectAddressVC.h"
#import "ResumeNameModel.h"
#import "SignupExpectJobVM.h"
#import "ExpectSalaryVC.h"
#import "JobPropertyVC.h"
#import "ExpectFunctionVC.h"
#import "TBTextUnit.h"
#import "SignupEducationVC.h"
#import "TBAppDelegate.h"
#import "ResumeTimeView.h"
#import "ResumeArrowCell.h"
#import "NSDate-Utilities.h"
#import "FuCongVC.h"
#import "NSString+Extension.h"
#import "CPTestEnsureArrowCell.h"
#import "CPTestEnsureEditCell.h"
#import "SigbupProjectVM.h"
#import "ResumeThridTimeView.h"
#import "ResumeCompanyIndustryVC.h"
#import "CPAddExpectJobVM.h"
#import "CPAddProjectVM.h"
#import "CPWorkExperienceStartTimeView.h"
#import "CPCommon.h"
@interface SignupExpectJobVC ()<ResumeTimeViewDelegate, CPWorkExperienceStartTimeViewDelegate, UITextFieldDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)CPAddExpectJobVM *expectJobViewModel;
@property(nonatomic,strong)CPAddProjectVM *jobViewModel;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UIButton *skipButton;
@property(nonatomic,assign)bool isSocial;
@property(nonatomic,retain) ResumeTimeView *timeView;
@property (nonatomic, strong) UIView *firstHeaderView;
@property (nonatomic, strong) UIView *secondHeaderView;
@property (nonatomic, strong) NSArray *workExperienceArray;
@property (nonatomic, strong) CPWorkExperienceStartTimeView *thirdTimeView;
@property (nonatomic, strong) ResumeNameModel *resume;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *comeFromString;
@end
@implementation SignupExpectJobVC
- (instancetype)initWithModel:(ResumeNameModel *)model isSocial:(Boolean)isSocial
{
    self = [super init];
    if (self)
    {
        self.isSocial = isSocial;
        self.resume = model;
        if( isSocial )
        {
            self.titleArray = @[@"职能类别", @"期望薪酬", @"工作城市", @"工作性质"];
            self.workExperienceArray = @[@"公司名称", @"职位名称", @"所属行业", @"开始时间", @"结束时间"];
        }
        else
        {
            self.titleArray = @[@"职能类别",@"期望薪酬",@"工作城市",@"工作性质",@"到岗时间",@"服从分配"];
        }
        self.expectJobViewModel = [[CPAddExpectJobVM alloc] initWithResumeModel:model];
        self.jobViewModel = [[CPAddProjectVM alloc] initWithResumeid:model.ResumeId];
        self.jobViewModel.resumeType = self.resume.ResumeType;
        NSString *localtionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
        if ( nil == self.expectJobViewModel.resumeNameModel.ExpectCity && localtionCity && ![localtionCity isEqualToString:@""])
        {
            Region *item = [Region searchAddressWithAddressString:localtionCity];
            if ( item )
            {
                self.expectJobViewModel.resumeNameModel.ExpectCity = item.PathCode;
            }
        }
        self.expectJobViewModel.showMessageVC = self;
        self.jobViewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithModel:(ResumeNameModel *)model isSocial:(Boolean)isSocial comeFromString:(NSString *)comeFromString
{
    self = [self initWithModel:model isSocial:isSocial];
    self.comeFromString = comeFromString;
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *setupTitle = @"2/3";
    if ( !self.isSocial )
        setupTitle = @"2/4";
    UIButton *changeCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeCityBtn setBackgroundColor:[UIColor colorWithHexString:@"1665a7"]];
    [changeCityBtn.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [changeCityBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [changeCityBtn setTitle:setupTitle forState:UIControlStateNormal];
    [changeCityBtn.layer setCornerRadius:60 / CP_GLOBALSCALE / 2.0];
    [changeCityBtn.layer setMasksToBounds:YES];
    changeCityBtn.viewSize = CGSizeMake(110 / CP_GLOBALSCALE, 60 / CP_GLOBALSCALE);
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:changeCityBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"expect_work_launch"];
    [MobClick event:@"into_workexperience_editactivity"];
    if ( !self.isSocial )
    {
        self.title = @"期望工作";
    }
    else
    {
        self.title = @"工作信息";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 84 + 144 + 50 + 42 + 50 ) / CP_GLOBALSCALE )];
    [footView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(40 / CP_GLOBALSCALE, 84 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE * 2.0, 144 / CP_GLOBALSCALE );
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 10 / CP_GLOBALSCALE;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"ff5252"];
    [footView addSubview:self.nextButton];
    [self.nextButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //统计下一步
        [MobClick event:@"expected_not_perfect_next"];
        [self.expectJobViewModel saveExpectJob];
    }];
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipButton.frame = CGRectMake(40 / CP_GLOBALSCALE, self.nextButton.viewHeight + self.nextButton.viewY + 50 / CP_GLOBALSCALE, self.nextButton.viewWidth, 42 / CP_GLOBALSCALE);
    self.skipButton.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [self.skipButton setTitle:@"跳过填写" forState:UIControlStateNormal];
    self.skipButton.backgroundColor = [UIColor clearColor];
    [self.skipButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
    [footView addSubview:self.skipButton];
    [self.skipButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender)
    {
        //统计跳过
        [MobClick event:@"expected_not_perfect_skip"];
        if ( self.comeFromString && 0 < [self.comeFromString length] )
        {
            if ( [self.comeFromString isEqualToString:@"aboutlogin"] )
            {
                TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
                [delegate ChangeToMainTwo];
            }
            else if ( [self.comeFromString isEqualToString:@"homeADGuide"] )
            {
                TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
                [delegate ChangeToMainTwo];
            }
            else
            {
                [self.navigationController dismissViewControllerAnimated:NO completion:^{
                    BaseNavigationViewController *root = (BaseNavigationViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    NSArray *childArray = root.childViewControllers;
                    UIViewController *childVC = [childArray objectAtIndex:1];
                    [childVC dismissViewControllerAnimated:NO completion:nil];
                }];
            }
        }
        else
        {
            TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
        }
    }];
    self.tableView.tableFooterView = footView;
    @weakify(self)
    [RACObserve(self.expectJobViewModel, addExpectJob) subscribeNext:^(id stateCode){
        @strongify(self);
        if( stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            if ( !self.isSocial )
            {
                SignupEducationVC *vc = [[SignupEducationVC alloc] initWithResume:self.expectJobViewModel.resumeNameModel isSocial:self.isSocial comeFromString:self.comeFromString];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                if( stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
                {
                    [self.jobViewModel addWork];
                }
            }
        }
    }];
    [RACObserve(self.jobViewModel, stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if( stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            SignupEducationVC *vc = [[SignupEducationVC alloc] initWithResume:self.expectJobViewModel.resumeNameModel isSocial:self.isSocial comeFromString:self.comeFromString];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    // 增加对键盘消息的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 监听键盘的弹出和隐藏的方法
- (void)listenKeyboardWillShow:(NSNotification *)userNotification
{
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
    CGFloat duration = [[userNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect viewFrame = self.view.bounds;
    viewFrame.origin.y = self.view.bounds.origin.y + 44.0 + 20.0;
    viewFrame.size.height = self.view.bounds.size.height - 44 - 20;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.tableView.frame = viewFrame;
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
-(void)resetYearMonthDay
{
    if (!self.expectJobViewModel.resumeNameModel.AvailableType || [self.expectJobViewModel.resumeNameModel.AvailableType isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strdaty = [date stringyyyyMMddFromDate];
        NSArray *array = [strdaty componentsSeparatedByString:@"-"];
        NSString *strYear = [NSString stringWithFormat:@"%d",[array[0] intValue]];
        NSString *strMonth = [NSString stringWithFormat:@"%d",[array[1] intValue]];
        NSString *strDay = [NSString stringWithFormat:@"%d",[array[2] intValue]];;
        [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue day:strDay.intValue];
        return;
    }
    NSString *str = [NSDate cepinYearMonthDayFromString:self.expectJobViewModel.resumeNameModel.AvailableType];
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    NSString *day = [array objectAtIndex:2];
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue day:day.intValue];
}
- (void)setDefaultStartDate
{
    if (!self.jobViewModel.workData.StartDate || [self.jobViewModel.workData.StartDate isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strYear = [date stringyyyyFromDate];
        NSString *strMonth = @"06";
        NSString *studyStr = @"在读学生";
        NSString *educationStr = @"应届生";
        if ( ![self.resume.WorkYear isEqualToString:studyStr] && ![self.resume.WorkYear isEqualToString:educationStr] )
        {
            NSString *workYearStr = nil;
            if ( 2 < [self.resume.WorkYear length] )
                workYearStr = [self.resume.WorkYear substringToIndex:2];
            else
                workYearStr = [self.resume.WorkYear substringToIndex:1];
            NSInteger defaultYear = [strYear intValue] - [workYearStr intValue];
            NSLog(@"%ld", (long)defaultYear);
            strYear = [NSString stringWithFormat:@"%ld", (long)defaultYear];
        }
        self.jobViewModel.workData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)strYear.intValue, (unsigned long)strMonth.intValue];
    }
}
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    self.expectJobViewModel.resumeNameModel.AvailableType = [NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)year,(unsigned long)month,(unsigned long)day];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( self.isSocial )
        return 2;
    else
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section )
        return self.titleArray.count;
    else
        return self.workExperienceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *leftStr = nil;
    NSString *placeholder = nil;
    if ( 0 == indexPath.section )
    {
        CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
        leftStr = self.titleArray[indexPath.row];
        switch ( indexPath.row )
        {
            case 0:
            {
                placeholder = @"请选择期望职能类别";
                NSMutableArray *arrarCode = [BaseCode baseCodeWithCodeKeys:self.expectJobViewModel.resumeNameModel.ExpectJobFunction];
                cell.inputTextField.text = [TBTextUnit baseCodeNameWithBaseCodes:arrarCode];
                break;
            }
            case 1:
            {
                placeholder = @"请选择期望薪酬";
                if ( !self.expectJobViewModel.resumeNameModel.ExpectSalary || 0 == [self.expectJobViewModel.resumeNameModel.ExpectSalary length] )
                {
                    self.expectJobViewModel.resumeNameModel.ExpectSalary = @"5K-10K";
                }
                cell.inputTextField.text = self.expectJobViewModel.resumeNameModel.ExpectSalary;
                break;
            }
            case 2:
            {
                placeholder = @"请选择工作城市";
                if ( self.expectJobViewModel.resumeNameModel.ExpectCity )
                {
                    NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:self.expectJobViewModel.resumeNameModel.ExpectCity];
                    cell.inputTextField.text = [TBTextUnit allRegionCitiesWithRegions:array];
                    if ( 0 < [array count] )
                    {
                        NSString *expectAddressString = [TBTextUnit allRegionCitiesWithRegions:array];
                        cell.inputTextField.text = expectAddressString;
                    }
                    else
                    {
                        self.expectJobViewModel.resumeNameModel.ExpectCity = @"";
                        cell.inputTextField.text = @"";
                    }
                }
                else
                {
                    NSString *localCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
                    NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:localCity];
                    if ( 0 < [array count] )
                    {
                        self.expectJobViewModel.resumeNameModel.ExpectCity = [TBTextUnit allRegionCitiesWithRegions:array];
                        cell.inputTextField.text = self.expectJobViewModel.resumeNameModel.ExpectCity;
                    }
                    else
                    {
                        self.expectJobViewModel.resumeNameModel.ExpectCity = @"";
                        cell.inputTextField.text = @"";
                    }
                }
                break;
            }
            case 3:
            {
                placeholder = @"请选择期望工作性质";
                if ([self.expectJobViewModel.resumeNameModel.ExpectEmployType isEqualToString:@"1"])
                {
                    cell.inputTextField.text = @"全职";
                }
                else if([self.expectJobViewModel.resumeNameModel.ExpectEmployType isEqualToString:@"4"])
                {
                    cell.inputTextField.text = @"实习";
                }
                else
                {
                    self.expectJobViewModel.resumeNameModel.ExpectEmployType = @"1";
                    cell.inputTextField.text = @"全职";
                }
                break;
            }
            case 4:
            {
                placeholder = @"请选择到岗时间";
                cell.inputTextField.text = [NSDate cepinYearMonthDayFromString:self.expectJobViewModel.resumeNameModel.AvailableType];
                break;
            }
            default:
            {
                placeholder = @"请选择是否分配";
                NSString *isAllow = [NSString stringWithFormat:@"%@", self.expectJobViewModel.resumeNameModel.IsAllowDistribution];
                if([@"1" isEqualToString:isAllow])
                {
                    cell.inputTextField.text = @"是";
                }
                else if([@"0" isEqualToString:isAllow])
                {
                    cell.inputTextField.text = @"否";
                }
                else
                {
                    self.expectJobViewModel.resumeNameModel.IsAllowDistribution = @1;
                    cell.inputTextField.text = @"是";
                }
                break;
            }
        }
        [cell configCellLeftString:leftStr placeholder:placeholder];
        BOOL isShowAll = NO;
        if ( [self.titleArray count] - 1 == indexPath.row )
            isShowAll = YES;
        [cell resetSeparatorLineShowAll:isShowAll];
        return cell;
    }
    else
    {
        leftStr = self.workExperienceArray[indexPath.row];
        
        if ( 0 == indexPath.row || 1 == indexPath.row )
        {
            CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
            [cell.inputTextField setText:@""];
            [cell.inputTextField setDelegate:self];
            [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
            cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            switch ( indexPath.row )
            {
                case 0:
                {
                    placeholder = @"请输入公司名称";
                    [cell.inputTextField setText:self.jobViewModel.workData.Company];
                    @weakify(self)
                    [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                        @strongify(self)
                        if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                            return;
                        self.jobViewModel.workData.Company = text;
                    }];
                    break;
                }
                case 1:
                {
                    placeholder = @"请输入职位名称";
                    [cell.inputTextField setText:self.jobViewModel.workData.JobFunction];
                    @weakify(self)
                    [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                        @strongify(self)
                        if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                            return;
                        self.jobViewModel.workData.JobFunction = text;
                    }];
                    break;
                }
            }
            [cell configCellLeftString:leftStr placeholder:placeholder];
            [cell resetSeparatorLineShowAll:NO];
            return cell;
        }
        else
        {
            CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
            switch ( indexPath.row )
            {
                case 2:
                    placeholder = @"请选择所属行业";
                    [cell.inputTextField setText:self.jobViewModel.workData.Industry];
                    break;
                case 3:
                {
                    placeholder = @"请选择开始时间";
                    if (!self.jobViewModel.workData.StartDate || [self.jobViewModel.workData.StartDate isEqualToString:@""])
                    {
                        [self setDefaultStartDate];
                    }
                    NSString *str = [NSDate cepinYMDFromString:self.jobViewModel.workData.StartDate];
                    [cell.inputTextField setText:str];
                    break;
                }
                case 4:
                {
                    placeholder = @"请选择结束时间";
                    if ( self.jobViewModel.workData.EndDate && ![self.jobViewModel.workData.EndDate isEqualToString:@""]) {
                        cell.inputTextField.text = [NSDate cepinYMDFromString:self.jobViewModel.workData.EndDate];
                    }
                    else
                    {
                        cell.inputTextField.text = @"至今";
                    }
                    break;
                }
            }
            [cell configCellLeftString:leftStr placeholder:placeholder];
            BOOL isShowAll = NO;
            if ( 4 == indexPath.row )
                isShowAll = YES;
            [cell resetSeparatorLineShowAll:isShowAll];
            return cell;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( 0 == section )
    {
        return self.firstHeaderView;
    }
    else
        return self.secondHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( 0 == section )
    {
        return 120 / CP_GLOBALSCALE;
    }
    else
        return 120 / CP_GLOBALSCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ( 0 == indexPath.section )
    {
        switch (indexPath.row) {
            case 0:
            {
                ExpectFunctionVC *vc = [[ExpectFunctionVC alloc] initWithResumeModel:self.expectJobViewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                ExpectSalaryVC *vc = [[ExpectSalaryVC alloc] initWithModel:self.expectJobViewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                ExpectAddressVC *vc = [[ExpectAddressVC alloc] initWithModel:self.expectJobViewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                JobPropertyVC *vc = [[JobPropertyVC alloc] initWithResumeModel:self.expectJobViewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                 break;
            case 4:
            {
                //到岗时间
                if (!self.timeView)
                {
                    self.timeView = [[ResumeTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.timeView];
                    self.timeView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
                    self.timeView.delegate = self;
                    [self resetYearMonthDay];
                }
                else
                {
                    [self resetYearMonthDay];
                    self.timeView.hidden = NO;
                }
            }
                break;
            case 5:
            {
                FuCongVC *vc = [[FuCongVC alloc] initWithModel:self.expectJobViewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if ( 1 == indexPath.section )
    {
        switch ( indexPath.row )
        {
            case 2:
            {
                ResumeCompanyIndustryVC *vc = [[ResumeCompanyIndustryVC alloc]initWithWorkModel:self.jobViewModel.workData];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3:
            {
                [self displayTimeView:indexPath.row];
                break;
            }
            case 4:
            {
                [self displayTimeView:indexPath.row];
                break;
            }
        }
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    return YES;
}
- (UIView *)firstHeaderView
{
    if ( !_firstHeaderView )
    {
        _firstHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120 / CP_GLOBALSCALE)];
        [_firstHeaderView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_firstHeaderView addSubview:titleLabel];
        [titleLabel setText:@"期望工作"];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _firstHeaderView.mas_top );
            make.left.equalTo( _firstHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _firstHeaderView.mas_bottom );
        }];
    }
    return _firstHeaderView;
}
- (UIView *)secondHeaderView
{
    if ( !_secondHeaderView )
    {
        _secondHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120 / CP_GLOBALSCALE)];
        [_secondHeaderView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [titleLabel setText:@"工作经历"];
        [_secondHeaderView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _secondHeaderView.mas_top );
            make.left.equalTo( _secondHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _secondHeaderView.mas_bottom );
        }];
    }
    return _secondHeaderView;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void) displayTimeView:(NSInteger)tag
{
    if ( !self.thirdTimeView )
    {
        self.thirdTimeView = [[CPWorkExperienceStartTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.thirdTimeView];
        self.thirdTimeView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
        self.thirdTimeView.delegate = self;
        self.thirdTimeView.tag = tag;
        [self resetYearMonth];
    }
    else
    {
        self.thirdTimeView.tag = tag;
        [self resetYearMonth];
        self.thirdTimeView.hidden = NO;
    }
}
-(void)resetYearMonth
{
    NSString *str = nil;
    if ( self.thirdTimeView.tag == 3 )
    {
        if (!self.jobViewModel.workData.StartDate || [self.jobViewModel.workData.StartDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.thirdTimeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        str = [NSDate cepinYMDFromString:self.jobViewModel.workData.StartDate];
    }
    else
    {
        if (!self.jobViewModel.workData.EndDate || [self.jobViewModel.workData.EndDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.thirdTimeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            
            return;
        }
        str = [NSDate cepinYMDFromString:self.jobViewModel.workData.EndDate];
    }
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.thirdTimeView setCurrentYearAndMonth:year.intValue month:month.intValue];
}
#pragma mark - ResumeThridTimeViewDelegate
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if ( self.thirdTimeView.tag == 4 )
    {
        self.jobViewModel.workData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year, (unsigned long)month];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        self.jobViewModel.workData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year, (unsigned long)month];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
    if ( self.thirdTimeView )
    {
        [self.thirdTimeView removeFromSuperview];
        self.thirdTimeView = nil;
    }
    else if ( self.timeView )
    {
        [self.timeView removeFromSuperview];
        self.timeView = nil;
    }
}
- (void)clickCancelButton
{
    if ( self.thirdTimeView )
    {
        [self.thirdTimeView removeFromSuperview];
        self.thirdTimeView = nil;
    }
    else if ( self.timeView )
    {
        [self.timeView removeFromSuperview];
        self.timeView = nil;
    }
}
@end
