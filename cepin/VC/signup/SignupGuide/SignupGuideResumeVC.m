//
//  SignupGuideResumeVC.m
//  cepin
//
//  Created by dujincai on 15/7/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SignupGuideResumeVC.h"
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
#import "SignupGuideResumeVM.h"
#import "ResumeTimeView.h"
#import "NSDate-Utilities.h"
#import "AddressChooseVC.h"
#import "BookingJobFilterModel.h"
#import "TBTextUnit.h"
#import "WorkYearsVC.h"
#import "PoliticsVC.h"
#import "MarriedVC.h"
#import "TBAppDelegate.h"
#import "AddressChooseHukouVC.h"
#import "ResumeThridTimeView.h"
#import "AddJobStatusVC.h"
#import "SignupExpectJobVC.h"
#import "NSString+Extension.h"
#import "CPCommon.h"
#import "CPTestEnsureEditCell.h"
#import "CPTestEnsureSexCell.h"
#import "CPTestEnsureArrowCell.h"
#import "CPResumedGuideEditCell.h"
#import "CPResumedGuideEditTipsCell.h"
#import "CPTestEnsureEditCell.h"
#import "CPEditResumeInfoTimeView.h"
#import "CPResumeEditInforOneWordController.h"
#import "CPResumeEditInformationReformer.h"
#import "CPTipsView.h"
#import "CPWResumeEditInfoIDCardCell.h"
#define CPFixld_Height (( 60 + 42 + 42 + 18 * 2 + 60 ) / CP_GLOBALSCALE )
#define CP_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
@interface SignupGuideResumeVC ()<UITextFieldDelegate,UINavigationControllerDelegate, CPEditResumeInfoTimeViewDelegate, CPResumedGuideEditCellDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate, CPTestEnsureSexCellDelegate, CPTipsViewDelegate>
@property(nonatomic,strong)SignupGuideResumeVM *viewModel;
@property(nonatomic,retain)CPEditResumeInfoTimeView *timeView;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)NSString *mobiel;
@property(nonatomic,strong)UIButton *nextButton;
@property (nonatomic, strong) UIView *firstHeaderView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *secondHeaderView;
@property (nonatomic, strong) UIView *bottomFooterView;
@property (nonatomic, strong) UITextField *emailEditTextField;
@property (nonatomic, assign) BOOL editEmail;
@property (nonatomic, assign) CGFloat emailTipsHeight;
@property (nonatomic, strong) CPTipsView *tipsView;
@property (nonatomic, strong) NSString *comeFromString;
@end
@implementation SignupGuideResumeVC
- (instancetype)initWithMobiel:(NSString *)mobiel comeFromString:(NSString *)comeFromString
{
    self = [super init];
    if (self)
    {
        self.viewModel = [SignupGuideResumeVM new];
        self.viewModel.resumeNameModel.ResumeType = [NSNumber numberWithInt:1];
        self.viewModel.resumeNameModel.ResumeName = @"我的简历";
        if ([mobiel rangeOfString:@"@"].location != NSNotFound) {
            self.viewModel.resumeNameModel.Email = mobiel;
            NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
            self.mobiel = mobile;
            self.viewModel.resumeNameModel.Mobile = mobile;
        }
        else
        {
            self.viewModel.resumeNameModel.Mobile = mobiel;
            self.mobiel = mobiel;
        }
        self.viewModel.resumeNameModel.WorkYear = @"3年";
        self.viewModel.resumeNameModel.WorkYearKey = @"3";
        NSString *localtionCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
        if ((nil == self.viewModel.resumeNameModel.Region || [@"" isEqualToString:self.viewModel.resumeNameModel.Region]) && localtionCity && ![localtionCity isEqualToString:@""])
        {
            Region *item = [Region searchAddressWithAddressString:localtionCity];
            if ( item )
            {
                self.viewModel.resumeNameModel.Region = localtionCity;
                self.viewModel.resumeNameModel.RegionCode = [NSString stringWithFormat:@"%@",item.PathCode];
            }
        }
        [CPResumeEditInformationReformer SaveOneWord:@""];
        self.viewModel.showMessageVC = self;
        self.comeFromString = comeFromString;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailTipsHeight = 0;
    [MobClick event:@"base_information_launch"];
    self.title = @"基本信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.viewWidth, self.view.viewHeight) style:UITableViewStylePlain];
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.delegate = self;
    CGFloat edgeInsets = 144 / CP_GLOBALSCALE;
    if ( CP_IS_IPHONE_4_OR_LESS )
        edgeInsets += 144 / CP_GLOBALSCALE / 2.0;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, edgeInsets, 0)];
    self.tableView.tableHeaderView = self.firstHeaderView;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self .view.viewWidth, ( 84 + 144 + 84 ) / CP_GLOBALSCALE )];
    self.bottomFooterView = footView;
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(40 / CP_GLOBALSCALE, 84.0 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE * 2, 144.0 / CP_GLOBALSCALE);
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    self.nextButton.layer.cornerRadius = 10 / CP_GLOBALSCALE;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
    [self.nextButton setEnabled:NO];
    [footView addSubview:self.nextButton];
    [self.nextButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //统计下一步
        [MobClick event:@"baseinfo_next"];
        [self.viewModel saveThridEditionResume];
    }];
    //跳过填写
    UIButton *jumpOver = [UIButton buttonWithType:UIButtonTypeCustom];
    // 隐藏跳过填写的按钮
    [jumpOver setHidden:YES];
    [jumpOver setTitle:@"跳过填写" forState:UIControlStateNormal];
    [jumpOver setTitleColor:[[RTAPPUIHelper shareInstance] labelColorGreen] forState:UIControlStateNormal];
    jumpOver.titleLabel.font = [[RTAPPUIHelper shareInstance] titleFont];
    jumpOver.viewWidth = [NSString caculateTextSize:jumpOver.titleLabel].width;
    jumpOver.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:jumpOver];
    [jumpOver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
    [jumpOver handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate ChangeToMainTwo];
    }];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if( stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess )
        {
            [self.viewModel checkEmailAvailabel];
            if ( self.headerImageView.image )
                [self.viewModel uploadResumeHeadImageWithImage:self.headerImageView.image];
        }
    }];
    [RACObserve( self.viewModel, checkAvailabelEmail ) subscribeNext:^(id stateCode) {
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            if ( self.viewModel.availabelEmail.intValue == 1 )
            {
                [self shomMessageTips:@"该邮箱已经绑定测聘网，请更换一个常用的新邮箱绑定。"];
            }
            else if ( self.viewModel.availabelEmail.intValue == 0 )
            {
                [self.viewModel sendBindEmailInfo];
            }
        }
    }];
    [RACObserve( self.viewModel, sendBindEmail ) subscribeNext:^(id stateCode) {
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
            {
                [self showMessageTips:self.viewModel.sendBindEmailMessage identifier:100];
            }
        }
    }];
    [self.tableView reloadData];
    
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
    viewFrame.size.height = keyboardTop - self.view.bounds.origin.y - 44.0 - 20.0;
    viewFrame.origin.y = self.view.bounds.origin.y + 44 + 20;
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.viewModel saveThridEditionResume];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton *changeCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeCityBtn setBackgroundColor:[UIColor colorWithHexString:@"1665a7"]];
    [changeCityBtn.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [changeCityBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [changeCityBtn setTitle:@"1/3" forState:UIControlStateNormal];
    [changeCityBtn.layer setCornerRadius:60 / CP_GLOBALSCALE / 2.0];
    [changeCityBtn.layer setMasksToBounds:YES];
    changeCityBtn.viewSize = CGSizeMake(110 / CP_GLOBALSCALE, 60 / CP_GLOBALSCALE);
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:changeCityBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.tableView reloadData];
    [self activeNextButton];
    if ( self.navigationItem.leftBarButtonItem )
    {
        if ( [self.comeFromString isEqualToString:@"homeADGuide"] )
            return;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    if ( self.tableView )
    {
        CGFloat edgeInsets = 144 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            edgeInsets += 144 / CP_GLOBALSCALE / 2.0;
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, edgeInsets, 0)];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self activeNextButton];
    if ( self.navigationItem.leftBarButtonItem )
    {
        if ( [self.comeFromString isEqualToString:@"homeADGuide"] )
            return;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
}
-(void)resetYearMonthDay
{
    if (!self.viewModel.resumeNameModel.Birthday || [self.viewModel.resumeNameModel.Birthday isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strdaty = [date stringyyyyMMddFromDate];
        NSArray *array = [strdaty componentsSeparatedByString:@"-"];
        NSString *strYear = [NSString stringWithFormat:@"%d",[array[0] intValue] - 22];
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
#pragma mark - CPEditResumeInfoTimeViewDelegate
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
#pragma mark - UITableViewDatasource UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    switch (indexPath.row ) {
        case 2:
        {
//            SexVC *vc = [[SexVC alloc]initWithModel:self.viewModel.resumeNameModel];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            if (!self.timeView)
            {
                self.timeView = [[CPEditResumeInfoTimeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
        case 8:
        {
            AddressChooseVC *vc = [[AddressChooseVC alloc]initWithModel:self.viewModel.resumeNameModel isJG:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            WorkYearsVC *vc = [[WorkYearsVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            AddJobStatusVC *vc = [[AddJobStatusVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10:
        {
            NSString *oneWordStr = [CPResumeEditInformationReformer onwWordStr];
            NSString *resumeIDStr = self.viewModel.resumeNameModel.ResumeId;
            CPResumeEditInforOneWordController *vc = [[CPResumeEditInforOneWordController alloc] initWithModelId:resumeIDStr defaultDes:oneWordStr];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 0 == indexPath.row )
    {
        CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
        [cell.inputTextField setText:@""];
        cell.inputTextField.delegate = self;
        [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
        cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
        [cell.inputTextField setText:self.viewModel.resumeNameModel.Email];
        @weakify(self)
        [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
            @strongify(self)
            if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                return;
            self.viewModel.resumeNameModel.Email = text;
            [self activeNextButton];
        }];
        BOOL isShowAll = NO;
        if ( 0 != self.emailTipsHeight )
            isShowAll = YES;
        [cell resetSeparatorLineShowAll:isShowAll];
        [cell configCellLeftString:@"邮  箱" placeholder:@"请输入邮箱地址"];
        return cell;
    }
    else if ( 1 == indexPath.row )
    {
        CPResumedGuideEditTipsCell *cell = [CPResumedGuideEditTipsCell guideEditTipsCellWithTableView:tableView];
        return cell;
    }
    else if ( 2 == indexPath.row || 5 == indexPath.row )
    {
        switch ( indexPath.row )
        {
            case 2:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setText:@""];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
                [cell configCellLeftString:@"姓  名" placeholder:@"请输入姓名"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.ChineseName];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.ChineseName = text;
                    [self activeNextButton];
                }];
                return cell;
            }
            case 5:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setText:@""];
                [cell configCellLeftString:@"手机号码" placeholder:@"请输入手机号码"];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
                if (!self.viewModel.resumeNameModel.Mobile || [self.viewModel.resumeNameModel.Mobile isEqualToString:@""]) {
                    [cell.inputTextField setText:self.mobiel];
                }
                else
                {
                    [cell.inputTextField setText:self.viewModel.resumeNameModel.Mobile];
                }
                cell.inputTextField.delegate = self;
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.Mobile = text;
                    [self activeNextButton];
                }];
                return cell;
            }
        }
    }
    else if ( indexPath.row == 6 )
    {
        NSString *leftStr = nil;
        NSString *placeholder = nil;
        CPWResumeEditInfoIDCardCell *cell = [CPWResumeEditInfoIDCardCell ensureEditCellWithTableView:tableView];
        [cell.inputTextField setText:@""];
        leftStr = @"身份证号";
        placeholder = @"请输入身份证号";
        [cell configCellLeftString:leftStr placeholder:placeholder];
        cell.inputTextField.delegate = self;
        [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
        cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
        [cell.inputTextField setText:self.viewModel.resumeNameModel.IdCardNumber];
        @weakify(self)
        [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
            @strongify(self)
            if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                return;
            self.viewModel.resumeNameModel.IdCardNumber = text;
            [self activeNextButton];
        }];
        return cell;
    }
    else if ( 3 == indexPath.row )
    {
        CPTestEnsureSexCell *cell = [CPTestEnsureSexCell ensureSexCellWithTableView:tableView];
        [cell setEnsureSexCellDelegate:self];
        [cell configWithSex:self.viewModel.resumeNameModel.Gender];
        return cell;
    }
    else if ( 4 == indexPath.row || 7 == indexPath.row || 8 == indexPath.row || 9 == indexPath.row || 10 == indexPath.row )
    {
        CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
        switch ( indexPath.row )
        {
            case 4:
            {
                [cell configCellLeftString:@"出生年份" placeholder:@"请选择出生年份"];
                if ( self.viewModel.resumeNameModel.Birthday && 0 < [self.viewModel.resumeNameModel.Birthday length] )
                {
                    NSString *birthdayStr = [self.viewModel.resumeNameModel.Birthday substringToIndex:4];
                    [cell.inputTextField setText:birthdayStr];
                }
                else
                {
                    NSDate *date = [NSDate date];
                    NSString *strdaty = [date stringyyyyMMddFromDate];
                    NSArray *array = [strdaty componentsSeparatedByString:@"-"];
                    NSString *strYear = [NSString stringWithFormat:@"%d",[array[0] intValue] - 22];
                    self.viewModel.resumeNameModel.Birthday = [NSString stringWithFormat:@"%@-01-01", strYear];
                    NSString *birthdayStr = [self.viewModel.resumeNameModel.Birthday substringToIndex:4];
                    [cell.inputTextField setText:birthdayStr];
                }
                break;
            }
            case 7:
            {
                [cell configCellLeftString:@"工作年限" placeholder:@"请选择工作年限"];
                if ( !self.viewModel.resumeNameModel.WorkYear || 0 == [self.viewModel.resumeNameModel.WorkYear length] || [self.viewModel.resumeNameModel.WorkYear isEqualToString:@"一年以上"] )
                {
                    self.viewModel.resumeNameModel.WorkYear = @"3年";
                }
                [cell.inputTextField setText:self.viewModel.resumeNameModel.WorkYear];
                break;
            }
            case 8:
            {
                [cell configCellLeftString:@"现居住地" placeholder:@"请选择城市"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Region];
                break;
            }
            case 9:
            {
                [cell configCellLeftString:@"工作状态" placeholder:@"请选择工作状态"];
                for (BaseCode *temp in self.viewModel.jobStatusArray)
                {
                    NSString *str = [NSString stringWithFormat:@"%@",temp.CodeKey];
                    if ([self.viewModel.resumeNameModel.JobStatus isEqualToString:str]) {
                        cell.inputTextField.text = temp.CodeName;
                        break;
                    }
                }
                break;
            }
            case 10:
                [cell configCellLeftString:@"一句话优势" placeholder:@"请一句话介绍自己的优势"];
                if ( 0 < [[CPResumeEditInformationReformer onwWordStr] length] )
                {
                    self.viewModel.resumeNameModel.Introduces = [CPResumeEditInformationReformer onwWordStr];
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
    else if ( indexPath.row == 11 ) {
        ResumeSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeSwitchCell class])];
        if (cell == nil)
        {
            cell = [[ResumeSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeSwitchCell class])];
        }
        if ( [self.viewModel.resumeNameModel.IsSendCustomer intValue] == 1 || [self.viewModel.resumeNameModel.IsSendCustomer isEqualToString:@"true"] )
        {
            self.viewModel.resumeNameModel.IsSendCustomer = @"1";
        }
        else
        {
            self.viewModel.resumeNameModel.IsSendCustomer = @"0";
        }
        if ( [self.viewModel.resumeNameModel.IsSendCustomer intValue] == 0 || [self.viewModel.resumeNameModel.IsSendCustomer isEqualToString:@"false"] )
        {
            [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.Switchimage setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        }
        [cell.Switchimage handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [self.viewModel.resumeNameModel.IsSendCustomer intValue] == 0 )
            {
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
    if ( 1 == indexPath.row )
    {
        return self.emailTipsHeight;
    }
    else
        return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - CPTestEnsureSexCellDelegate
- (void)ensureSexCell:(CPTestEnsureSexCell *)ensureSexCell changeSexWithSexNumber:(NSInteger)sexNumber
{
    [self.view endEditing:YES];
    NSNumber *gender = nil;
    if ( CPSexButtonMale == sexNumber )
        gender = [NSNumber numberWithInt:1];
    else if ( CPSexButtonFemale == sexNumber )
        gender = [NSNumber numberWithInt:2];
    else
        gender = [NSNumber numberWithInt:0];
    self.viewModel.resumeNameModel.Gender = gender;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    NSString *placeholder = textField.placeholder;
    if ( [placeholder isEqualToString:@"请输入邮箱地址"] )
    {
        self.emailTipsHeight = CPFixld_Height;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *placeholder = textField.placeholder;
    if ( [placeholder isEqualToString:@"请输入邮箱地址"] )
    {
        self.emailTipsHeight = 0;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3) {
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
        }
        else if ( buttonIndex == 1 )
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
        [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:60 / CP_GLOBALSCALE]}];
    }
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
    self.headerImageView.image = editedImage;
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
        if ( widthFactor > heightFactor )
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
        else if (widthFactor < heightFactor)
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
            make.bottom.equalTo( _firstHeaderView.mas_bottom ).offset( -74 / CP_GLOBALSCALE );
            make.width.equalTo( @( 180 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 180 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3d6"]];
        [_firstHeaderView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _firstHeaderView ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( _firstHeaderView.mas_right ).offset( -40 / CP_GLOBALSCALE );
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
            [self.view endEditing:YES];
            [self uploadImage];
        }];
    }
    return _headerImageView;
}
- (UIView *)secondHeaderView
{
    if ( !_secondHeaderView )
    {
        _secondHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 60 + 42 + 42 + 18 * 2 + 60 ) / CP_GLOBALSCALE )];
        [_secondHeaderView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        UILabel *tipsLabel = [[UILabel alloc] init];
        [tipsLabel setNumberOfLines:0];
        NSString *tipsStr = @"绑定邮箱，可获得找回密码、职位推荐、投递动态、HR通知等服务，请输入常用邮箱并完成注册后登录邮箱验证。";
        NSMutableParagraphStyle *paragrapHStyle = [[NSMutableParagraphStyle alloc] init];
        [paragrapHStyle setLineSpacing:18 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithString:tipsStr attributes:@{
                                NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE],
                                NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"],
                                NSParagraphStyleAttributeName : paragrapHStyle
                                }];
        [tipsLabel setAttributedText:attStrM];
        [_secondHeaderView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _secondHeaderView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _secondHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _secondHeaderView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( ( 60 + 42 * 2 + 18 * 2 + 60 ) / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3d6"]];
        [_secondHeaderView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _secondHeaderView );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( _secondHeaderView.mas_right );
            make.bottom.equalTo( _secondHeaderView.mas_bottom );
        }];
    }
    return _secondHeaderView;
}
#pragma mark - 是否激活下一步按钮
- (void)activeNextButton
{
    BOOL isActive = YES;
    if ( 0 == [self.viewModel.resumeNameModel.Email length] || 0 == [self.viewModel.resumeNameModel.ChineseName length] || [self.viewModel.resumeNameModel.Mobile length] == 0 || 0 == [self.viewModel.resumeNameModel.IdCardNumber length] || 0 == [self.viewModel.resumeNameModel.Region length] || 0 == [self.viewModel.resumeNameModel.Introduces length])
    {
        isActive = NO;
    }
    [self.nextButton setEnabled:isActive];
}
- (void)shomMessageTips:(NSString *)tips
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
- (void)showMessageTips:(NSString *)tips identifier:(NSInteger)identifier
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [self.tipsView setIdentifier:identifier];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton
{
    self.tipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton identifier:(NSInteger)identifier
{
    self.tipsView = nil;
    if ( 100 == identifier )
    {
        [CPResumeEditInformationReformer SaveOneWord:@""];
        SignupExpectJobVC *vc = [[SignupExpectJobVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:YES comeFromString:self.comeFromString];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CPTipsView *)messageTipsViewWithTips:(NSString *)tips
{
    if ( !_tipsView )
    {
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"确定"] showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
@end