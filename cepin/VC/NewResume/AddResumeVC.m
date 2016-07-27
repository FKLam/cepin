//
//  AddResumeVC.m
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddResumeVC.h"
#import "ResumeHeadAndNameCell.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "ResumeEditCell.h"
#import "ResumeHRCell.h"
#import "ResumeSwitchCell.h"
#import "ResumeAddMoreCell.h"
#import "SexVC.h"
#import "VPImageCropperViewController.h"
#import "RTPhotoHelper.h"
#import "AddThridEditionResumeVM.h"
#import "ResumeTimeView.h"
#import "NSDate-Utilities.h"
#import "AddressChooseVC.h"
#import "BookingJobFilterModel.h"
#import "TBTextUnit.h"
#import "WorkYearsVC.h"
#import "PoliticsVC.h"
#import "MarriedVC.h"
#import "AddressChooseHukouVC.h"
#import "ResumeThridTimeView.h"
#import "AddJobStatusVC.h"
#import "CPTestEnsureArrowCell.h"
#import "CPTestEnsureEditCell.h"
#import "CPTestEnsureSexCell.h"
#import "CPResumeMoreButton.h"
#import "CPResumeOneWordController.h"
#import "CPResumeEditInforOneWordController.h"
#import "CPResumeEditInformationReformer.h"
#import "CPEditResumeInfoTimeView.h"
#import "CPCommon.h"
#import "CPWResumeEditInfoIDCardCell.h"
#define CP_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
@interface AddResumeVC ()<UITextFieldDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,CPEditResumeInfoTimeViewDelegate,ResumeThridTimeViewDelegate,UIAlertViewDelegate, CPTestEnsureSexCellDelegate>
@property(nonatomic,retain)ResumeThridTimeView *gradueView;
@property(nonatomic)BOOL addMore;
@property(nonatomic,strong)AddThridEditionResumeVM *viewModel;
@property(nonatomic,strong)UIImage *photoImage;
@property(nonatomic,retain)CPEditResumeInfoTimeView *timeView;
@property(nonatomic,strong)UITextField *textField;
@property (nonatomic, strong) UIView *firstFooterView;
@property (nonatomic, strong) CPResumeMoreButton *moreButton;
@property (nonatomic, strong) BaseCode *defaultPolitics;
@end
@implementation AddResumeVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.addMore = YES;
        self.viewModel = [[AddThridEditionResumeVM alloc] initWithResumeModel:model];
        self.viewModel.showMessageVC = self;
        NSString *localtionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
        if ( (nil == self.viewModel.resumeNameModel.Region || [@"" isEqualToString:self.viewModel.resumeNameModel.Region]) && localtionCity && ![localtionCity isEqualToString:@""])
        {
            Region *item = [Region searchAddressWithAddressString:localtionCity];
            if ( item )
            {
                self.viewModel.resumeNameModel.Region = localtionCity;
                self.viewModel.resumeNameModel.RegionCode = [NSString stringWithFormat:@"%@",item.PathCode];
            }
        }
        [CPResumeEditInformationReformer SaveOneWord:self.viewModel.resumeNameModel.Introduces];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"基本信息";
    [self createNoHeadImageTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    @weakify(self)
    [RACObserve(self.viewModel,updateImageStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.tableView reloadData];
        }
    }];
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [CPResumeEditInformationReformer SaveOneWord:@""];
            [self.view endEditing:YES];
//            [OMGToast showWithText:@"操作成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
            [self.navigationController popViewControllerAnimated:YES];
//            if ( CP_SYSTEM_VERSION >= 8.0 )
//            {
//                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
//                [alertCtrl addAction:okAction];
//                [self presentViewController:alertCtrl animated:YES completion:nil];
//            }
//            else
//            {
//                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:@"操作成功" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
//                [alerView show];
//            }
        }
    }];
    // 增加对键盘消息的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 监听键盘的弹出和隐藏的方法
- (void)listenKeyboardWillShow:(NSNotification *)userNotification
{
    if ( 0 == self.textField.tag )
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
    if ( 0 == self.textField.tag )
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
}
-(void)popView{
    
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self.view endEditing:YES];
        if (![self.textField isExclusiveTouch]) {
            [self.textField resignFirstResponder];
        }
        self.viewModel.resumeNameModel.Introduces = [CPResumeEditInformationReformer onwWordStr];
        [self.viewModel saveThridEditionResume];
        [MobClick event:@"edit_baseinfo"];
    }];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 移除监听中心
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)resetYearMonthDay
{
    if (!self.viewModel.resumeNameModel.Birthday || [self.viewModel.resumeNameModel.Birthday isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strdaty = [date stringyyyyMMddFromDate];
        NSArray *array = [strdaty componentsSeparatedByString:@"-"];
        NSString *strYear = [NSString stringWithFormat:@"%d",[array[0] intValue]-22];
        NSString *strMonth = @"06";
        NSString *strDay = @"15";
        [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue day:strDay.intValue];
        return;
    }
    NSString *str = [self.viewModel.resumeNameModel.Birthday substringToIndex:4];
    NSString *year = str;
    NSString *month = nil;
    NSString *day = nil;
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue day:day.intValue];
}
- (void)clickCancelButton
{
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    self.viewModel.resumeNameModel.Birthday = [NSString stringWithFormat:@"%lu-01-01",(unsigned long)year];
    [self.tableView reloadData];
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
-(void)displayTimeView:(NSInteger)tag
{
    if (self.textField) {
        [self.textField resignFirstResponder];
    }
    if (!self.gradueView)
    {
        self.gradueView = [[ResumeThridTimeView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight)];
        self.gradueView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
        self.gradueView.delegate = self;
        [self.view addSubview:self.gradueView];
        self.gradueView.tag = tag;
        [self resetYearMonth];
    }
    else
    {
        self.gradueView.tag = tag;
        [self resetYearMonth];
        self.gradueView.hidden = NO;
    }
}
-(void)resetYearMonth
{
    NSString *str = nil;
    if (self.gradueView.tag == 14)
    {
        if (!self.viewModel.resumeNameModel.GraduateDate || [self.viewModel.resumeNameModel.GraduateDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = @"06";
            [self.gradueView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            
            return;
        }
        
        str = [NSDate cepinYMDFromString:self.viewModel.resumeNameModel.GraduateDate];
    }
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.gradueView setCurrentYearAndMonth:year.intValue month:month.intValue];
}
-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if (self.gradueView.tag == 14)
    {
        self.viewModel.resumeNameModel.GraduateDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    [self.tableView reloadData];
    [self.gradueView removeFromSuperview];
    self.gradueView = nil;
}
#pragma mark - CPTestEnsureSexCellDelegate
- (void)ensureSexCell:(CPTestEnsureSexCell *)ensureSexCell changeSexWithSexNumber:(NSInteger)sexNumber
{
    NSNumber *gender = nil;
    if ( CPSexButtonMale == sexNumber )
        gender = [NSNumber numberWithInt:1];
    else if ( CPSexButtonFemale == sexNumber )
        gender = [NSNumber numberWithInt:2];
    else
        gender = [NSNumber numberWithInt:0];
    self.viewModel.resumeNameModel.Gender = gender;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.textField) {
        [self.textField resignFirstResponder];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ( 0 == indexPath.section )
    {
    switch (indexPath.row ) {
        case 1:
        {
//            SexVC *vc = [[SexVC alloc]initWithModel:self.viewModel.resumeNameModel];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            if (!self.timeView)
            {
                self.timeView = [[CPEditResumeInfoTimeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                self.timeView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
                self.timeView.delegate = self;
                [[UIApplication sharedApplication].keyWindow addSubview:self.timeView];
                [self resetYearMonthDay];
            }
            else
            {
                [self resetYearMonthDay];
                self.timeView.hidden = NO;
            }
        }
            break;
        case 7:
        {
            AddressChooseVC *vc = [[AddressChooseVC alloc] initWithModel:self.viewModel.resumeNameModel isJG:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            WorkYearsVC *vc = [[WorkYearsVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {
            AddJobStatusVC *vc = [[AddJobStatusVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            NSString *oneWordStr = [CPResumeEditInformationReformer onwWordStr];
            NSString *resumeIDStr = self.viewModel.resumeNameModel.ResumeId;
            CPResumeEditInforOneWordController *vc = [[CPResumeEditInforOneWordController alloc] initWithModelId:resumeIDStr defaultDes:oneWordStr];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:
        {
            PoliticsVC *vc = [[PoliticsVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:
        {
            AddressChooseHukouVC *vc = [[AddressChooseHukouVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 13:
        {
            MarriedVC *vc = [[MarriedVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {
            [self displayTimeView:indexPath.row];
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
            case 1:
            {
                PoliticsVC *vc = [[PoliticsVC alloc] initWithModel:self.viewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 0:
            {
                MarriedVC *vc = [[MarriedVC alloc] initWithModel:self.viewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    if ( 1 == indexPath.section )
    {
        switch ( indexPath.row )
        {
            case 0:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"婚姻状况" placeholder:@"请选择婚姻状况"];
                [cell.inputTextField setText:[self.viewModel maritalString]];
                [cell setHidden:!self.moreButton.isSelected];
                if ( 1 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 1:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"政治面貌" placeholder:@"请输选择政治面貌"];
                if ( !self.viewModel.resumeNameModel.Politics || 0 == [self.viewModel.resumeNameModel.Politics length] )
                {
                    self.viewModel.resumeNameModel.Politics = self.defaultPolitics.CodeName;
                    self.viewModel.resumeNameModel.PoliticsKey = [NSString stringWithFormat:@"%@", self.defaultPolitics.CodeKey];
                }
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Politics];
                [cell setHidden:!self.moreButton.isSelected];
                if ( 1 == indexPath.row )
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
            [cell configCellLeftString:@"姓名" placeholder:@"请输入姓名"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setDelegate:self];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
            [cell.inputTextField setText:self.viewModel.resumeNameModel.ChineseName];
            @weakify(self)
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                @strongify(self)
                if ( indexPath.row != cell.inputTextField.tag )
                    return;
                self.viewModel.resumeNameModel.ChineseName = text;
            }];
            return cell;
        }
        case 1:
        {
            CPTestEnsureSexCell *cell = [CPTestEnsureSexCell ensureSexCellWithTableView:tableView];
            [cell setEnsureSexCellDelegate:self];
            [cell configWithSex:self.viewModel.resumeNameModel.Gender];
            return cell;
        }
        case 2:
        {
            CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
            [cell configCellLeftString:@"出生年份" placeholder:@"请输选择出生年份"];
            if ( self.viewModel.resumeNameModel.Birthday )
            {
                NSString *birthdayStr = [self.viewModel.resumeNameModel.Birthday substringToIndex:4];
                [cell.inputTextField setText:birthdayStr];
            }
            return cell;
        }
        case 3:
        {
            CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
            [cell configCellLeftString:@"手机号码" placeholder:@"请输入手机号码"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setDelegate:self];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.inputTextField setText:self.viewModel.resumeNameModel.Mobile];
            @weakify(self)
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                @strongify(self)
                if ( indexPath.row != cell.inputTextField.tag )
                    return;
                self.viewModel.resumeNameModel.Mobile = text;
                [MobClick event:@"input_mobil"];
            }];
            return cell;
        }
        case 4:
        {
            CPWResumeEditInfoIDCardCell *cell = [CPWResumeEditInfoIDCardCell ensureEditCellWithTableView:tableView];
            [cell configCellLeftString:@"身份证号" placeholder:@"请输入身份证号"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setDelegate:self];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
            [cell.inputTextField setText:self.viewModel.resumeNameModel.IdCardNumber];
            @weakify(self)
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                @strongify(self)
                if ( indexPath.row != cell.inputTextField.tag )
                    return;
                self.viewModel.resumeNameModel.IdCardNumber = text;
            }];
            return cell;
        }
        case 5:
        {
            CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
            [cell configCellLeftString:@"工作年限" placeholder:@"请输选择工作年限"];
            if ( self.viewModel.resumeNameModel.WorkYear )
            {
                NSString *workYear = self.viewModel.resumeNameModel.WorkYear;
                for ( BaseCode *baseCode in self.viewModel.workYearkArrayM )
                {
                    if ( baseCode.CodeKey.intValue == self.viewModel.resumeNameModel.WorkYearKey.intValue )
                    {
                        workYear = baseCode.CodeName;
                        break;
                    }
                }
                [cell.inputTextField setText:workYear];
            }
            return cell;
        }
        case 6:
        {
            CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
            [cell configCellLeftString:@"常用邮箱" placeholder:@"请输入常用邮箱"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setDelegate:self];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
            [cell.inputTextField setText:self.viewModel.resumeNameModel.Email];
            @weakify(self)
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                @strongify(self)
                if ( indexPath.row != cell.inputTextField.tag )
                    return;
                self.viewModel.resumeNameModel.Email = text;
                [MobClick event:@"input_email"];
            }];
            return cell;
        }
        case 7:
        {
            CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
            [cell configCellLeftString:@"现居住地" placeholder:@"请输选择城市"];
            [cell.inputTextField setText:self.viewModel.resumeNameModel.Region];
            return cell;
        }
        case 8:
        {
            CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
            [cell configCellLeftString:@"工作状态" placeholder:@"请输选择工作状态"];
            for (BaseCode *temp in self.viewModel.jobStatusArray)
            {
                NSString *str = [NSString stringWithFormat:@"%@",temp.CodeKey];
                if ([self.viewModel.resumeNameModel.JobStatus isEqualToString:str])
                {
                    cell.inputTextField.text = temp.CodeName;
                }
            }
            return cell;
        }
        case 9:
        {
            CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
            [cell configCellLeftString:@"一句话优势" placeholder:@"请一句话介绍自己的优势"];
            if ( 0 < [[CPResumeEditInformationReformer onwWordStr] length] )
            {
                [cell.inputTextField setText:@"已添加"];
            }
            else
            {
                [cell.inputTextField setText:@""];
            }
            return cell;
        }
        case 10:
        {
            ResumeSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeSwitchCell class])];
            if (cell == nil)
            {
                cell = [[ResumeSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeSwitchCell class])];
            }
            if ( !self.viewModel.resumeNameModel.IsSendCustomer || [self.viewModel.resumeNameModel.IsSendCustomer intValue] == 0 ) {
                [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
            }
            else 
            {
                [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
                self.viewModel.resumeNameModel.IsSendCustomer = @"1";
            }
            [cell.Switchimage handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                if (!self.viewModel.resumeNameModel.IsSendCustomer || [self.viewModel.resumeNameModel.IsSendCustomer intValue] == 0  ) {
                    [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
                    self.viewModel.resumeNameModel.IsSendCustomer = @"1";
                }
                else
                {
                    [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
                    self.viewModel.resumeNameModel.IsSendCustomer = @"0";
                }
            }];
            if ( 10 == indexPath.row )
                [cell resetSeparatorLineShowAll:YES];
            else
                [cell resetSeparatorLineShowAll:NO];
            return cell;
        }
    }
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 1 == indexPath.section )
    {
        if ( self.moreButton.isSelected )
            return 144 / CP_GLOBALSCALE;
        else
            return 0;
    }
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section )
        return 11;
    else
        return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( 1 == section )
    {
        return self.firstFooterView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( 1 == section )
        return ( 40 + 144 + 40 ) / CP_GLOBALSCALE;
    else
        return 0;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1 || textField.tag == 2) {
        return  [self validateNumber:string];
    }
    return YES;
}
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
- (void)uploadImage
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从手机相册中选择", nil), nil];
    
    [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex){
        if (sheet.cancelButtonIndex == buttonIndex)
        {
            //[(MMDrawerController *)ROOTVIEWCONTROLLER setMaximumLeftDrawerWidth:MinLeftSlideWidth animated:YES completion:nil];
            return;
        }
        if (buttonIndex == 0)
        {
            // 拍照
            if ([RTPhotoHelper isCameraAvailable] && [RTPhotoHelper doesCameraSupportTakingPhotos])
            {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([RTPhotoHelper isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     RTLog(@"Picker View Controller is presented");
                                 }];
            }
            
        } else if (buttonIndex == 1)
        {
            // 从相册中选取
            if ([RTPhotoHelper isPhotoLibraryAvailable])
            {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                controller.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWithBlock:^(id sender){
                    [controller dismissViewControllerAnimated:YES completion:^(void){
                        
                    }];
                }];
                controller.title = NSLocalizedString(@"相簿", nil);
                controller.navigationItem.leftBarButtonItem.tintColor = [[RTAPPUIHelper shareInstance] backgroundColor];
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     RTLog(@"Picker View Controller is presented");
                                 }];
            }
        }
    }];
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
    self.photoImage = editedImage;
    [self.viewModel uploadUserHeadImageWithImage:editedImage];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        //UIImage *portraitImg = UIIMAGE(UIImagePickerControllerOriginalImage);
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:CP_GLOBALSCALE];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
        }];
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) RTLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - UIScrollview
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - events respond
- (void)respondMoreButton
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1], [NSIndexPath indexPathForItem:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    if ( self.moreButton.isSelected )
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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
            [self respondMoreButton];
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
- (BaseCode *)defaultPolitics
{
    if ( !_defaultPolitics )
    {
        _defaultPolitics = [[BaseCode alloc] init];
        _defaultPolitics.CodeName = @"共青团员";
        NSMutableArray *politicsArrayM = [BaseCode politics];
        for ( BaseCode *tempPolitics in politicsArrayM )
        {
            if ( [_defaultPolitics.CodeName isEqualToString:tempPolitics.CodeName] )
            {
                _defaultPolitics = tempPolitics;
                break;
            }
        }
    }
    return _defaultPolitics;
}
@end