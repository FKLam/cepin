//
//  SchoolSignupGuideResumeVC.m
//  cepin
//
//  Created by dujincai on 15/11/3.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "SchoolSignupGuideResumeVC.h"
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
#import "HealthVC.h"
#import "NSString+Extension.h"
#import "CPCommon.h"
#import "CPSchoolResumeArrowCell.h"
#import "CPSchoolResumeEditCell.h"
#import "CPTestEnsureEditCell.h"
#import "CPTestEnsureSexCell.h"
#import "CPEditResumeInfoTimeView.h"
#import "CPTipsView.h"
#import "CPWResumeEditInfoIDCardCell.h"
#define CPSCHOOLRESUMGUIDE_ROW_HEIGHT ( ( 144 / CP_GLOBALSCALE ) )
#define CPSCHOOLRESUMGUIDE_COUNT ( 17 )
#define CP_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
@interface SchoolSignupGuideResumeVC ()<UITextFieldDelegate,UINavigationControllerDelegate,CPEditResumeInfoTimeViewDelegate,ResumeThridTimeViewDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate, CPTestEnsureSexCellDelegate, CPTipsViewDelegate>
@property(nonatomic,strong)SignupGuideResumeVM *viewModel;
@property(nonatomic,retain)CPEditResumeInfoTimeView *timeView;
@property(nonatomic,retain)ResumeThridTimeView *thridTimeView;//两列的view
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)NSString *mobiel;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,assign)BOOL isBirthday;//1表示生日 0 表示毕业时间
@property (nonatomic, strong) UIView *firstHeaderView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) BaseCode *defaultPolitics;
@property (nonatomic, strong) BaseCode *defaultJobStatus;
@property (nonatomic, strong) CPTipsView *tipsView;
@property (nonatomic, strong) NSString *comeFromString;
@end
@implementation SchoolSignupGuideResumeVC

- (instancetype)initWithMobiel:(NSString *)mobiel comeFromString:(NSString *)comeFromString
{
    self = [super init];
    if (self)
    {
        self.viewModel = [SignupGuideResumeVM new];
        self.viewModel.resumeNameModel.WorkYear = @"应届生";
        self.viewModel.resumeNameModel.WorkYearKey = @"0";
        self.viewModel.resumeNameModel.ResumeType = [NSNumber numberWithInt:2];
        self.viewModel.resumeNameModel.ResumeName = @"学生简历";
        if ([mobiel rangeOfString:@"@"].location != NSNotFound)
        {
            self.viewModel.resumeNameModel.Email = mobiel;
            self.mobiel = @"";
        }
        else
        {
            self.viewModel.resumeNameModel.Mobile = mobiel;
            self.mobiel = mobiel;
        }
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
        self.viewModel.showMessageVC = self;
        self.comeFromString = comeFromString;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"base_information_launch"];
    self.title = @"基本信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.viewWidth, self.view.viewHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    CGFloat edgeInsets = 144 / CP_GLOBALSCALE;
//    if ( CP_IS_IPHONE_4_OR_LESS )
//        edgeInsets += 144 / CP_GLOBALSCALE / 2.0;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, edgeInsets, 0)];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.firstHeaderView;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self .view.viewWidth, ( 84 + 144 + 84 ) / CP_GLOBALSCALE )];
    self.tableView.tableFooterView = footView;
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
        [self.viewModel saveThridEditionResume];
    }];
    //跳过填写
    UIButton *jumpOver = [UIButton buttonWithType:UIButtonTypeCustom];
    // 隐藏跳过填写的按钮
    [jumpOver setHidden:YES];
    jumpOver.frame = CGRectMake(0, 0, 100, 40);
    [jumpOver setTitle:@"跳过填写" forState:UIControlStateNormal];
    [jumpOver setTitleColor:[[RTAPPUIHelper shareInstance] labelColorGreen] forState:UIControlStateNormal];
    jumpOver.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
    jumpOver.titleLabel.textAlignment = NSTextAlignmentLeft;
    [footView addSubview:jumpOver];
    [jumpOver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.nextButton.mas_bottom).offset(40);
        make.width.equalTo(@([NSString caculateTextSize:jumpOver.titleLabel].width));
        make.height.equalTo(@(40));
    }];
    [jumpOver handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate ChangeToMainTwo];
    }];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
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
            [self showMessageTips:self.viewModel.sendBindEmailMessage identifier:100];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.viewModel saveThridEditionResume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self activeNextButton];
    if ( self.navigationItem.leftBarButtonItem )
    {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton *changeCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeCityBtn setBackgroundColor:[UIColor colorWithHexString:@"1665a7"]];
    [changeCityBtn.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [changeCityBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [changeCityBtn setTitle:@"1/4" forState:UIControlStateNormal];
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
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    if ( self.tableView )
    {
        CGFloat edgeInsets = 144 / CP_GLOBALSCALE;
//        if ( CP_IS_IPHONE_4_OR_LESS )
//            edgeInsets += 144 / CP_GLOBALSCALE / 2.0;
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, edgeInsets, 0)];
    }
}
-(void)displayTimeView:(int)tag
{
    if (!self.thridTimeView)
    {
        self.thridTimeView = [[ResumeThridTimeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.thridTimeView];
        self.thridTimeView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
        self.thridTimeView.delegate = self;
        self.thridTimeView.tag = tag;
        [self resetYearMonth];
    }
    else
    {
        self.thridTimeView.tag = tag;
        [self resetYearMonth];
        self.thridTimeView.hidden = NO;
    }
}
-(void)resetYearMonth
{
    NSString *str = nil;
   
    if (!self.viewModel.resumeNameModel.GraduateDate || [self.viewModel.resumeNameModel.GraduateDate isEqualToString:@""])
            {
                NSDate *date = [NSDate date];
                NSString *strYear = [date stringyyyyFromDate];
                NSString *strMonth = @"06";
                [self.thridTimeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
                return;
    }
    str = [NSDate cepinYMDFromString:self.viewModel.resumeNameModel.GraduateDate];
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.thridTimeView setCurrentYearAndMonth:year.intValue month:month.intValue];
}
-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month{
    self.viewModel.resumeNameModel.GraduateDate = [NSString stringWithFormat:@"%lu-%lu-01",(unsigned long)year,(unsigned long)month];
    [self.tableView reloadData];
    [self.timeView removeFromSuperview];
    self.timeView = nil;
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
    NSString *str;
    if( self.isBirthday )
    {
        str = [self.viewModel.resumeNameModel.Birthday substringToIndex:4];
    }
    NSString *year = str;
    NSString *month = nil;
    NSString *day = nil;
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue day:day.intValue];
}
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    if( self.isBirthday )
    {
        self.viewModel.resumeNameModel.Birthday = [NSString stringWithFormat:@"%lu-01-01",(unsigned long)year];
    }
    [self.tableView reloadData];
    [self.thridTimeView removeFromSuperview];
    self.thridTimeView = nil;
}
- (void)clickCancelButton
{
    if ( self.timeView )
    {
        [self.timeView removeFromSuperview];
        self.timeView = nil;
    }
    else if ( self.thridTimeView )
    {
        [self.thridTimeView removeFromSuperview];
        self.thridTimeView = nil;
    }
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.textField)
    {
        [self.textField resignFirstResponder];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row )
    {
        case 2:
        {
            self.isBirthday = YES;
            //出生日期
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
        {   //居住地
            AddressChooseVC *vc = [[AddressChooseVC alloc]initWithModel:self.viewModel.resumeNameModel isJG:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {   //就读状态
            WorkYearsVC *vc = [[WorkYearsVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            //工作状态
            AddJobStatusVC *vc = [[AddJobStatusVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10:
        {
            self.isBirthday = NO;
            //毕业时间
            [self displayTimeView:1];
        }
            break;
        case 11:
        {
            //政治面貌
            PoliticsVC *vc = [[PoliticsVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {
            //健康状况
            HealthVC *vc = [[HealthVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 15:
        {
            //籍贯
            AddressChooseVC *vc = [[AddressChooseVC alloc]initWithModel:self.viewModel.resumeNameModel isJG:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *leftStr = nil;
    NSString *placeholder = nil;
    NSString *contentStr = nil;
    if ( indexPath.row == 1 )
    {
        CPTestEnsureSexCell *cell = [CPTestEnsureSexCell ensureSexCellWithTableView:tableView];
        [cell setEnsureSexCellDelegate:self];
        [cell configWithSex:self.viewModel.resumeNameModel.Gender];
        return cell;
    }
    if ( indexPath.row == 5 )
    {
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
    if ( indexPath.row == 16 )
    {
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
    if (indexPath.row == 2 || indexPath.row == 7
        || indexPath.row == 8 || indexPath.row== 9 || indexPath.row == 10
        || indexPath.row== 11 || indexPath.row== 14 || indexPath.row == 15 ) {
        CPSchoolResumeArrowCell *cell = [CPSchoolResumeArrowCell ensureArrowCellWithTableView:tableView];
        switch (indexPath.row) {
            case 2:
            {
                leftStr = @"出生年份";
                placeholder = @"请选择出生年份";
                if ( self.viewModel.resumeNameModel.Birthday && 0 < [self.viewModel.resumeNameModel.Birthday length] )
                {
                    NSString *birthdayStr = [self.viewModel.resumeNameModel.Birthday substringToIndex:4];
                    contentStr = birthdayStr;
                }
                else
                {
                    NSDate *date = [NSDate date];
                    NSString *strdaty = [date stringyyyyMMddFromDate];
                    NSArray *array = [strdaty componentsSeparatedByString:@"-"];
                    NSString *strYear = [NSString stringWithFormat:@"%d",[array[0] intValue] - 22];
                    self.viewModel.resumeNameModel.Birthday = [NSString stringWithFormat:@"%@-01-01", strYear];
                    NSString *birthdayStr = [self.viewModel.resumeNameModel.Birthday substringToIndex:4];
                    contentStr = birthdayStr;
                }
                break;
            }
            case 8:
            {
                leftStr = @"现居住地";
                placeholder = @"请选择居住地";
                contentStr = self.viewModel.resumeNameModel.Region;
            }
                break;
            case 9:
            {
                leftStr = @"求职状态";
                placeholder = @"目前正在找工作";
                for (BaseCode *temp in self.viewModel.jobStatusArray) {
                    NSString *str = [NSString stringWithFormat:@"%@",temp.CodeKey];
                    if ([self.viewModel.resumeNameModel.JobStatus isEqualToString:str]) {
                        contentStr = temp.CodeName;
                    }
                }
            }
                break;
            case 7:
            {
                leftStr = @"就读状态";
                placeholder = @"应届毕业生";
                contentStr = self.viewModel.resumeNameModel.WorkYear;
            }
                break;
            case 10:
                leftStr = @"毕业时间";
                placeholder = @"请选择毕业时间";
                contentStr = [NSDate cepinYMDFromString:self.viewModel.resumeNameModel.GraduateDate];
                break;
            case 11:
                leftStr = @"政治面貌";
                placeholder = @"请选择政治面貌";
                if ( !self.viewModel.resumeNameModel.Politics || 0 == [self.viewModel.resumeNameModel.Politics length] )
                {
                    self.viewModel.resumeNameModel.Politics = self.defaultPolitics.CodeName;
                    self.viewModel.resumeNameModel.PoliticsKey = [NSString stringWithFormat:@"%@", self.defaultPolitics.CodeKey];
                }
                contentStr = self.viewModel.resumeNameModel.Politics;
                break;
            case 14:
                leftStr = @"健康状况";
                placeholder = @"请选择健康状况";
                switch (self.viewModel.resumeNameModel.HealthType.intValue) {
                    case 1:
                         contentStr = @"健康";
                        break;
                    case 2:
                         contentStr = @"良好";
                        break;
                    case 3:
                         contentStr = @"有病史";
                        break;
                    default:
                        break;
                }
                break;
            case 15:
                leftStr = @"籍  贯";
                placeholder = @"请选择籍贯";
                contentStr = self.viewModel.resumeNameModel.NativeCity;
                break;
            default:
                break;
        }
        [cell configCellLeftString:leftStr placeholder:placeholder contentString:contentStr];
        return cell;
    }
    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 3
        || indexPath.row == 6 || indexPath.row == 12 || indexPath.row == 13 )
    {
        switch (indexPath.row) {
            case 0:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setText:@""];
                leftStr = @"姓  名";
                placeholder = @"请输入姓名";
                [cell configCellLeftString:leftStr placeholder:placeholder];
                cell.inputTextField.delegate = self;
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
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
            case 3:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
//                cell.inputTextField.delegate = self;
                cell.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Email];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.Email = text;
                    [self activeNextButton];
                }];
                [cell configCellLeftString:@"邮  箱" placeholder:@"请输入邮箱地址"];
                return cell;
            }
            case 4:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setText:@""];
                leftStr = @"手机号码";
                placeholder = @"请输入手机号码";
                [cell configCellLeftString:leftStr placeholder:placeholder];
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
            case 6:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setText:@""];
                leftStr = @"民  族";
                placeholder = @"请输入民族";
                [cell configCellLeftString:leftStr placeholder:placeholder];
                cell.inputTextField.delegate = self;
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Nation];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.Nation = text;
                    [self activeNextButton];
                }];
                return cell;
            }
            case 12:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setText:@""];
                leftStr = @"身高(cm)";
                placeholder = @"请输入身高";
                [cell configCellLeftString:leftStr placeholder:placeholder];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.inputTextField.delegate = self;
                if ( self.viewModel.resumeNameModel.Height )
                {
                    if ( ![[self.viewModel.resumeNameModel.Height stringValue] isEqualToString:@"0"] )
                        [cell.inputTextField setText:[self.viewModel.resumeNameModel.Height stringValue]];
                }
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    if ( !text || 0 == text.length )
                        self.viewModel.resumeNameModel.Height = nil;
                    else
                        self.viewModel.resumeNameModel.Height = [NSNumber numberWithFloat:[text floatValue]];
                    [self activeNextButton];
                }];
                return cell;
            }
            case 13:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell.inputTextField setText:@""];
                leftStr = @"体重(kg)";
                placeholder = @"请输入体重";
                [cell configCellLeftString:leftStr placeholder:placeholder];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
                cell.inputTextField.delegate = self;
                if ( self.viewModel.resumeNameModel.Weight )
                {
                    if ( ![[self.viewModel.resumeNameModel.Weight stringValue] isEqualToString:@"0"] )
                        [cell.inputTextField setText:[self.viewModel.resumeNameModel.Weight stringValue]];
                }
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    if ( !text || 0 == text.length )
                        self.viewModel.resumeNameModel.Weight = nil;
                    else
                        self.viewModel.resumeNameModel.Weight = [NSNumber numberWithFloat:[text floatValue]];
                    [self activeNextButton];
                }];
                return cell;
            }
            default:
                break;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CPSCHOOLRESUMGUIDE_ROW_HEIGHT;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CPSCHOOLRESUMGUIDE_COUNT;
}
#pragma mark - event respond
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
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3) {
//        return  [self validateNumber:string];
//    }
//    return YES;
//}
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
#pragma mark - UISrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
        else if (buttonIndex == 1)
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
    if ( sourceImage.size.width < ORIGINAL_MAX_WIDTH )
        return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if ( sourceImage.size.width > sourceImage.size.height )
    {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    }
    else
    {
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
    if ( CGSizeEqualToSize(imageSize, targetSize) == NO )
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
        if ( widthFactor > heightFactor )
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if ( widthFactor < heightFactor )
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
- (BaseCode *)defaultJobStatus
{
    if ( !_defaultJobStatus )
    {
        _defaultJobStatus = [[BaseCode alloc] init];
        _defaultJobStatus.CodeName = @"正在找工作";
        NSMutableArray *jobStatusArrayM = [BaseCode JobStatus];
        for ( BaseCode *tempJobStatus in jobStatusArrayM )
        {
            if ( [_defaultJobStatus.CodeName isEqualToString:tempJobStatus.CodeName] )
            {
                _defaultJobStatus = tempJobStatus;
                break;
            }
        }
    }
    return _defaultJobStatus;
}
#pragma mark - 是否激活下一步按钮
- (void)activeNextButton
{
    BOOL isActive = YES;
    if ( 0 == [self.viewModel.resumeNameModel.Email length] 
        || 0 == [self.viewModel.resumeNameModel.ChineseName length] 
        || [self.viewModel.resumeNameModel.Mobile length] == 0 
        || 0 == [self.viewModel.resumeNameModel.IdCardNumber length] 
        || 0 == [self.viewModel.resumeNameModel.Region length] 
        || !self.viewModel.resumeNameModel.Weight
        || !self.viewModel.resumeNameModel.Height
        || 0 == [self.viewModel.resumeNameModel.Health length] 
        || 0 == [self.viewModel.resumeNameModel.NativeCity length] 
        || 0 == [self.viewModel.resumeNameModel.GraduateDate length] 
        || 0 == [self.viewModel.resumeNameModel.Nation length] )
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
        SignupExpectJobVC *vc = [[SignupExpectJobVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:NO comeFromString:self.comeFromString];
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