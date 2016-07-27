//
//  CreateResumeByInfoVC.m
//  cepin
//  创建社招简历-基本信息
//  Created by dujincai on 15/11/10.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "CreateResumeByInfoVC.h"
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
#import "ResumeNameVC.h"
#import "CPCommon.h"
#import "CPTestEnsureEditCell.h"
#import "CPTestEnsureArrowCell.h"
#import "CPTestEnsureSexCell.h"
#import "CPResumedGuideEditCell.h"
#import "CPResumedGuideEditTipsCell.h"
#import "CPResumeOneWordController.h"
#import "CPResumeEditInformationReformer.h"
#import "CPResumeEditInforOneWordController.h"
#import "CPEditResumeInfoTimeView.h"
#import "CPWResumeEditInfoIDCardCell.h"
@interface CreateResumeByInfoVC ()<UITextFieldDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,CPEditResumeInfoTimeViewDelegate,ResumeThridTimeViewDelegate,UIAlertViewDelegate, CPTestEnsureSexCellDelegate>
@property (nonatomic, strong) UIView *firstHeaderView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property(nonatomic,retain)ResumeThridTimeView *gradueView;
@property(nonatomic,strong)AddThridEditionResumeVM *viewModel;
@property(nonatomic,strong)UIImage *photoImage;
@property(nonatomic,retain)CPEditResumeInfoTimeView *timeView;
@property(nonatomic,strong)UITextField *textField;;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)NSString *modelId;
@property(nonatomic,strong)NSString *resumeName;
@property (nonatomic, strong) UIImageView *tempHeaderImageView;
@end

@implementation CreateResumeByInfoVC
- (instancetype)initWithModelId:(NSString *)modelId resumeName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        self.modelId = modelId;
        self.resumeName = name;
        self.viewModel = [[AddThridEditionResumeVM alloc] initWithResumeModelId:modelId];
        self.viewModel.resumeNameModel.ResumeName = name;
        self.viewModel.resumeNameModel.WorkYear = @"3年";
        self.viewModel.resumeNameModel.WorkYearKey = @"3";
        self.viewModel.resumeNameModel.ResumeType = [NSNumber numberWithInt:1];
        NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccout"];
        if ([mobile rangeOfString:@"@"].location != NSNotFound)
        {
            self.viewModel.resumeNameModel.Email = mobile;
            mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
            self.viewModel.resumeNameModel.Mobile = mobile;
        }
        else
        {
            self.viewModel.resumeNameModel.Mobile = mobile;
        }
        NSArray *jobStatusArray = [BaseCode JobStatus];
        BaseCode *state = jobStatusArray[0];
        self.viewModel.resumeNameModel.JobStatus = [NSString stringWithFormat:@"%@",state.CodeKey];
        NSString *localtionCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCity"];
        if ((nil == self.viewModel.resumeNameModel.Region || [@"" isEqualToString:self.viewModel.resumeNameModel.Region]) && localtionCity && ![localtionCity isEqualToString:@""]) {
            self.viewModel.resumeNameModel.Region = localtionCity;
            Region *item = [Region searchAddressWithAddressString:localtionCity];
            self.viewModel.resumeNameModel.RegionCode = [NSString stringWithFormat:@"%@",item.PathCode];
        }
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad {
    [MobClick event:@"start_create_social_resume"];
    [super viewDidLoad];
    self.title = @"基本信息";
    [self createNoHeadImageTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self .view.viewWidth, (84 + 144 + 40) / CP_GLOBALSCALE)];
    self.tableView.tableFooterView = footView;
    self.tableView.tableHeaderView = self.firstHeaderView;
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake( 40 / CP_GLOBALSCALE, 84 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE * 2, 144.0 / CP_GLOBALSCALE);
    [self.nextButton setTitle:@"创建简历" forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [[RTAPPUIHelper shareInstance] jobInformationDeliverButtonFont];
    self.nextButton.layer.cornerRadius = 10 / CP_GLOBALSCALE;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"ff5252"];
    [footView addSubview:self.nextButton];
    [self.nextButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.viewModel.resumeNameModel.Introduces = [CPResumeEditInformationReformer onwWordStr];
        [self.viewModel creteResumeWithResume:1];
        [MobClick event:@"btn_save_social_resume"];
    }];
    @weakify(self)
    [RACObserve(self.viewModel, updateImageStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.tableView reloadData];
//            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:@"操作成功" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
//            [alerView show];
//            [OMGToast showWithText:@"操作成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
            ResumeNameVC *vc = [[ResumeNameVC alloc] initWithResumeId:self.viewModel.resumeNameModel.ResumeId];
            [self.navigationController pushViewController:vc animated:YES];
            [CPResumeEditInformationReformer SaveOneWord:@""];
        }
    }];
    [RACObserve(self.viewModel, resumeStateCode) subscribeNext:^(id resumeStateCode){
        @strongify(self);
        if(resumeStateCode && [self requestStateWithStateCode:resumeStateCode] == HUDCodeSucess)
        {
            self.viewModel.resumeNameModel.ResumeId = @"";
            self.viewModel.resumeNameModel.ResumeType= [NSNumber numberWithInt:1];
            self.viewModel.resumeNameModel.ResumeName = self.resumeName;
            self.tableView.hidden = NO;
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.resumeNameModel.PhotoUrlPath] placeholderImage:[UIImage imageNamed:@"portrait_edit"]];
            [CPResumeEditInformationReformer SaveOneWord:self.viewModel.resumeNameModel.Introduces];
            [self.tableView reloadData];
        }
        else if ([self requestStateWithStateCode:resumeStateCode] == HUDCodeNetWork)
        {
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
            self.tableView.hidden = YES;
        }
    }];
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            if ( self.tempHeaderImageView.image )
                [self.viewModel uploadCreateResumeHeadImageWithImage:self.headerImageView.image];
            else
            {
                ResumeNameVC *vc = [[ResumeNameVC alloc] initWithResumeId:self.viewModel.resumeNameModel.ResumeId];
                [self.navigationController pushViewController:vc animated:YES];
                [CPResumeEditInformationReformer SaveOneWord:@""];
            }
        }
    }];
    [self.viewModel getResumeInfo];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ResumeNameVC *vc = [[ResumeNameVC alloc] initWithResumeId:self.viewModel.resumeNameModel.ResumeId];
    [self.navigationController pushViewController:vc animated:YES];
    [CPResumeEditInformationReformer SaveOneWord:@""];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setDefaultBirthday];
    [self.tableView reloadData];
}
- (void)setDefaultBirthday
{
    if ( [self.viewModel.resumeNameModel.Birthday length] == 0 || !self.viewModel.resumeNameModel.Birthday )
    {
        NSDate *date = [NSDate date];
        NSString *strdaty = [date stringyyyyMMddFromDate];
        NSArray *array = [strdaty componentsSeparatedByString:@"-"];
        NSString *strYear = [NSString stringWithFormat:@"%d",[array[0] intValue] - 22];
        self.viewModel.resumeNameModel.Birthday = [NSString stringWithFormat:@"%@-01-01", strYear];
    }
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
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    self.viewModel.resumeNameModel.Birthday = [NSString stringWithFormat:@"%lu-01-01",(unsigned long)year];
    [self.tableView reloadData];
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
- (void)clickCancelButton
{
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
        self.gradueView = [[ResumeThridTimeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.gradueView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
        self.gradueView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:self.timeView];
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
            NSString *strMonth = [date stringMMFromDate];
            [self.gradueView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        str = [NSDate cepinYMDFromString:self.viewModel.resumeNameModel.GraduateDate];
    }
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = @"06";
    [self.gradueView setCurrentYearAndMonth:year.intValue month:month.intValue];
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
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.textField) {
        [self.textField resignFirstResponder];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
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
                self.timeView = [[CPEditResumeInfoTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
            break;
        }
        case 9:
        {
            CPResumeEditInforOneWordController *vc = [[CPResumeEditInforOneWordController alloc] initWithModelId:self.viewModel.resumeNameModel.ResumeId defaultDes:[CPResumeEditInformationReformer onwWordStr]];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:
        {
            PoliticsVC *vc = [[PoliticsVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:
        {
            AddressChooseHukouVC *vc = [[AddressChooseHukouVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 13:
        {
            MarriedVC *vc = [[MarriedVC alloc] initWithModel:self.viewModel.resumeNameModel];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 0 == indexPath.row || 3 == indexPath.row || 6 == indexPath.row )
    {
        CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
        [cell.inputTextField setDelegate:self];
        switch ( indexPath.row )
        {
            case 0:
            {
                [cell configCellLeftString:@"姓  名" placeholder:@"请输入姓名"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.ChineseName];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [cell.inputTextField setTag:indexPath.row];
                @weakify(self);
                [[cell.inputTextField rac_textSignal]subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( cell.inputTextField.tag != indexPath.row )
                        return;
                    self.viewModel.resumeNameModel.ChineseName = text;
                }];
            }
                break;
            case 3:
            {
                [cell configCellLeftString:@"手机号码" placeholder:@"请输入手机号码"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Mobile];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                [cell.inputTextField setTag:indexPath.row];
                @weakify(self);
                [[cell.inputTextField rac_textSignal]subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( cell.inputTextField.tag != indexPath.row )
                        return;
                    self.viewModel.resumeNameModel.Mobile = text;
                }];
            }
                break;
            case 6:
            {
                [cell configCellLeftString:@"常用邮箱" placeholder:@"请输入常用邮箱"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Email];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [cell.inputTextField setTag:indexPath.row];
                @weakify(self);
                [[cell.inputTextField rac_textSignal]subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( cell.inputTextField.tag != indexPath.row )
                        return;
                    self.viewModel.resumeNameModel.Email = text;
                }];
            }
                break;
        }
        return cell;
    }
    else if ( 1 == indexPath.row )
    {
        CPTestEnsureSexCell *cell = [CPTestEnsureSexCell ensureSexCellWithTableView:tableView];
        [cell configWithSex:self.viewModel.resumeNameModel.Gender];
        [cell setEnsureSexCellDelegate:self];
        return cell;
    }
    else if ( 2 == indexPath.row || 5 == indexPath.row || 7 == indexPath.row || 8 == indexPath.row || 9 == indexPath.row )
    {
        CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
        switch ( indexPath.row )
        {
            case 2:
                [cell configCellLeftString:@"出生年份" placeholder:@"请选择出生年份"];
                if ( self.viewModel.resumeNameModel.Birthday && 0 < [self.viewModel.resumeNameModel.Birthday length] )
                {
                    NSString *birthdayStr = [self.viewModel.resumeNameModel.Birthday substringToIndex:4];
                    [cell.inputTextField setText:birthdayStr];
                }
                break;
            case 5:
                [cell configCellLeftString:@"工作年限" placeholder:@"请选择工作年限"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.WorkYear];
                break;
            case 7:
                [cell configCellLeftString:@"现居住地" placeholder:@"请选择城市"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Region];
                break;
            case 8:
            {
                [cell configCellLeftString:@"工作状态" placeholder:@"请选择工作状态"];
                if ( 0 < [self.viewModel.resumeNameModel.JobStatus length] )
                {
                    for (BaseCode *temp in self.viewModel.jobStatusArray)
                    {
                        NSString *str = [NSString stringWithFormat:@"%@",temp.CodeKey];
                        if ([self.viewModel.resumeNameModel.JobStatus isEqualToString:str]) {
                            cell.inputTextField.text = temp.CodeName;
                            break;
                        }
                    }
                }
                else if ( !self.viewModel.resumeNameModel.JobStatus || 0 == [self.viewModel.resumeNameModel.JobStatus length] )
                {
                    self.viewModel.resumeNameModel.JobStatus = @"正在找工作";
                    [cell.inputTextField setText:self.viewModel.resumeNameModel.JobStatus];
                }
            }
                break;
            case 9:
                [cell configCellLeftString:@"一句话优势" placeholder:@"请一句话介绍自己的优势"];
                if ( 0 < [[CPResumeEditInformationReformer onwWordStr] length] )
                {
                    [cell.inputTextField setText:@"已添加"];
                }
                else
                {
                    [cell.inputTextField setText:@""];
                }
                break;
        }
        return cell;
    }
    else if ( 4 == indexPath.row )
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
    else if (indexPath.row == 10)
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
            if (self.viewModel.resumeNameModel.IsSendCustomer.intValue == 0) {
                [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
                self.viewModel.resumeNameModel.IsSendCustomer = @"1";
            }
            else
            {
                [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
                self.viewModel.resumeNameModel.IsSendCustomer = @"0";
            }
        }];
        [cell resetSeparatorLineShowAll:YES];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
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
    return YES;
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
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( [navigationController isKindOfClass:[UIImagePickerController class]] )
    {
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        viewController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:46 / CP_GLOBALSCALE]}];
    }
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
    self.headerImageView.image = editedImage;
    self.tempHeaderImageView.image = editedImage;
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        //UIImage *portraitImg = UIIMAGE(UIImagePickerControllerOriginalImage);
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
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
    
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - getter methods
- (UIView *)firstHeaderView
{
    if ( !_firstHeaderView )
    {
        _firstHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 140 + 144 ) / CP_GLOBALSCALE )];
        [_firstHeaderView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        CALayer *topBackgroundLayer = [[CALayer alloc] init];
        [topBackgroundLayer setBackgroundColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [topBackgroundLayer setFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, 140 / CP_GLOBALSCALE + kScreenHeight)];
        [_firstHeaderView.layer addSublayer:topBackgroundLayer];
        [_firstHeaderView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _firstHeaderView.mas_centerX );
            make.top.equalTo( _firstHeaderView.mas_top ).offset( (140 - 180 / 2.0) / CP_GLOBALSCALE );
            make.width.equalTo( @( 180 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 180 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLineSecond = [[UIView alloc] init];
        [separatorLineSecond setBackgroundColor:[UIColor colorWithHexString:@"ede3d6"]];
        [_firstHeaderView addSubview:separatorLineSecond];
        [separatorLineSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _firstHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( _firstHeaderView.mas_right );
            make.bottom.equalTo( _firstHeaderView.mas_bottom );
        }];
    }
    return _firstHeaderView;
}
- (UIImageView *)headerImageView
{
    if ( !_headerImageView )
    {
        _headerImageView = [[UIImageView alloc] init];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.resumeNameModel.PhotoUrlPath] placeholderImage:[UIImage imageNamed:@"portrait_edit"]];
        [_headerImageView.layer setCornerRadius:186 / CP_GLOBALSCALE / 2.0];
        [_headerImageView.layer setMasksToBounds:YES];
        [_headerImageView setUserInteractionEnabled:YES];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [_headerImageView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _headerImageView.mas_top );
            make.left.equalTo( _headerImageView.mas_left );
            make.bottom.equalTo( _headerImageView.mas_bottom );
            make.right.equalTo( _headerImageView.mas_right );
        }];
        [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self uploadImage];
        }];
    }
    return _headerImageView;
}
- (UIImageView *)tempHeaderImageView
{
    if ( !_tempHeaderImageView )
    {
        _tempHeaderImageView = [[UIImageView alloc] init];
    }
    return _tempHeaderImageView;
}
@end
