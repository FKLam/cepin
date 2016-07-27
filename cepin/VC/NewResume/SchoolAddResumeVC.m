//
//  SchoolAddResumeVC.m
//  cepin
//
//  Created by dujincai on 15/11/13.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "SchoolAddResumeVC.h"
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
#import "CPCommon.h"
#import "AddressChooseHukouVC.h"
#import "ResumeThridTimeView.h"
#import "AddJobStatusVC.h"
#import "HealthVC.h"
#import "CPTestEnsureArrowCell.h"
#import "CPTestEnsureEditCell.h"
#import "CPTestEnsureSexCell.h"
#import "CPResumeMoreButton.h"
#import "CPEditResumeInfoTimeView.h"
#import "CPWResumeEditInfoIDCardCell.h"
#define CP_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
@interface SchoolAddResumeVC ()<UITextFieldDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,ResumeThridTimeViewDelegate,CPEditResumeInfoTimeViewDelegate,UIAlertViewDelegate, CPTestEnsureSexCellDelegate>
@property(nonatomic,retain)ResumeThridTimeView *gradueView;
@property(nonatomic)BOOL addMore;
@property(nonatomic,strong)AddThridEditionResumeVM *viewModel;
@property(nonatomic,strong)UIImage *photoImage;
@property(nonatomic,retain)CPEditResumeInfoTimeView *timeView;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,assign)BOOL isBirthday;
@property (nonatomic, copy) NSString *EmergencyContactPhone;
@property (nonatomic, strong) UIView *firstFooterView;
@property (nonatomic, strong) CPResumeMoreButton *moreButton;
@end
@implementation SchoolAddResumeVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.addMore = YES;
        self.viewModel = [[AddThridEditionResumeVM alloc] initWithResumeModel:model];
        self.viewModel.showMessageVC = self;
        NSString *localtionCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCity"];
        if ((nil == self.viewModel.resumeNameModel.Region || [@"" isEqualToString:self.viewModel.resumeNameModel.Region]) && localtionCity && ![localtionCity isEqualToString:@""]) {
            self.viewModel.resumeNameModel.Region = localtionCity;
            Region *item = [Region searchAddressWithAddressString:localtionCity];
            self.viewModel.resumeNameModel.RegionCode = [NSString stringWithFormat:@"%@",item.PathCode];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本信息";
    [MobClick event:@"base_information_launch"];
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
            [self.view endEditing:YES];
//            [OMGToast showWithText:@"操作成功" topOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            [self.view endEditing:YES];
            [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
//            if ( CP_SYSTEM_VERSION >= 8.0 )
//            {
//                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
//                [alertCtrl addAction:okAction];
//                
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
    if ( 0 == self.textField.tag || 3 == self.textField.tag )
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
    viewFrame.origin.y = self.view.bounds.origin.y + 44.0 + 20.0;
    viewFrame.size.height = self.view.bounds.size.height - 44 - 20;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.tableView.frame = viewFrame;
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.view endEditing:YES];
    
    if ( alertView.tag == 10086 )
    {
        
    }
    else
        [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
}
-(void)popView{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if (self.EmergencyContactPhone.length > 0 && ![self regex:self.EmergencyContactPhone] )
        {
            if ( CP_SYSTEM_VERSION >= 8.0 )
            {
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"电话号码不正确"  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertCtrl addAction:okAction];
                [self presentViewController:alertCtrl animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话号码不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alertView.tag = 10086;
                [alertView show];
            }
        }
        else
        {
            [self.view endEditing:YES];
            [self.viewModel saveThridEditionResume];
        }
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
- (void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    self.viewModel.resumeNameModel.Birthday = [NSString stringWithFormat:@"%lu-01-01",(unsigned long)year];
    [self.tableView reloadData];
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
-(void)displayTimeView:(int)tag
{
    if (self.textField) {
        [self.textField resignFirstResponder];
    }
    if (!self.gradueView)
    {
        self.gradueView = [[ResumeThridTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.gradueView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
        self.gradueView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:self.gradueView];
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
    if (self.gradueView.tag == 1)
    {
        if (!self.viewModel.resumeNameModel.GraduateDate || [self.viewModel.resumeNameModel.GraduateDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
             NSString *month = @"06";
            [self.gradueView setCurrentYearAndMonth:strYear.intValue month:month.intValue];
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
    if (self.gradueView.tag == 1)
    {
        self.viewModel.resumeNameModel.GraduateDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    [self.tableView reloadData];
    [self.gradueView removeFromSuperview];
    self.gradueView = nil;
}
- (void)clickCancelButton
{
    if ( self.timeView )
    {
        [self.timeView removeFromSuperview];
        self.timeView = nil;
    }
    if ( self.gradueView )
    {
        [self.gradueView removeFromSuperview];
        self.gradueView = nil;
    }
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
    if ( self.textField ) {
        [self.textField resignFirstResponder];
    }
    if ( 0 == indexPath.section )
    {
        switch (indexPath.row ) {
            case 1:
            {   //性别
//                SexVC *vc = [[SexVC alloc]initWithModel:self.viewModel.resumeNameModel];
//                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                self.isBirthday = YES;
                //出生日期
                if ( !self.timeView )
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
            case 8:
            {   //居住地
                AddressChooseVC *vc = [[AddressChooseVC alloc] initWithModel:self.viewModel.resumeNameModel isJG:NO];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 7:
            {   //就读状态
                WorkYearsVC *vc = [[WorkYearsVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:false];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 9:
            {
                //工作状态
                AddJobStatusVC *vc = [[AddJobStatusVC alloc]initWithModel:self.viewModel.resumeNameModel];
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
            case 18:
            {
                //户口
                AddressChooseHukouVC *vc = [[AddressChooseHukouVC alloc]initWithModel:self.viewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 19:
            {
                //婚姻
                MarriedVC *vc = [[MarriedVC alloc]initWithModel:self.viewModel.resumeNameModel];
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
            case 1:
            {
                //户口
                AddressChooseHukouVC *vc = [[AddressChooseHukouVC alloc]initWithModel:self.viewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                //婚姻
                MarriedVC *vc = [[MarriedVC alloc]initWithModel:self.viewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
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
                [cell configCellLeftString:@"姓  名" placeholder:@"请输入姓名"];
                [cell.inputTextField setText:@""];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.ChineseName];
                @weakify(self);
                [[cell.inputTextField rac_textSignal]subscribeNext:^(NSString *text)
                 {
                     @strongify(self)
                     if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                         return;
                     self.viewModel.resumeNameModel.ChineseName = text;
                 }];
                return cell;
            }
            case 1:
            {
                // Int	性别（0 未知1：男 ，2：女）Gender
                CPTestEnsureSexCell *cell = [CPTestEnsureSexCell ensureSexCellWithTableView:tableView];
                [cell configWithSex:self.viewModel.resumeNameModel.Gender];
                [cell setEnsureSexCellDelegate:self];
                return cell;
            }
            case 2:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"出生年份" placeholder:@"请选择出生年份"];
                if ( self.viewModel.resumeNameModel.Birthday && 0 < [self.viewModel.resumeNameModel.Birthday length] )
                {
                    NSString *birthdayStr = [self.viewModel.resumeNameModel.Birthday substringToIndex:4];
                    [cell.inputTextField setText:birthdayStr];
                }
                return cell;
            }
            case 3:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"常用邮箱" placeholder:@"请输入常用邮箱"];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
//                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Email];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.Email = text;
                    [MobClick event:@"input_email"];
                }];
                return cell;
            }
            case 4:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"手机号码" placeholder:@"请输入手机号码"];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Mobile];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.Mobile = text;
                    [MobClick event:@"input_mobil"];
                }];
                return cell;
            }
            case 5:
            {
                CPWResumeEditInfoIDCardCell *cell = [CPWResumeEditInfoIDCardCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"身份证号" placeholder:@"请输入身份证"];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.IdCardNumber];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.IdCardNumber = text;
                }];
                return cell;
            }
            case 6:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"民  族" placeholder:@"请输入民族"];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                if ( !self.viewModel.resumeNameModel.Nation )
                {
                    self.viewModel.resumeNameModel.Nation = @"汉";
                    [cell.inputTextField setText:self.viewModel.resumeNameModel.Nation];
                }
                else
                {
                    [cell.inputTextField setText:self.viewModel.resumeNameModel.Nation];
                }
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.Nation = text;
                }];
                return cell;
            }
            case 7:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"就读状态" placeholder:@"请选择就读状态"];
                NSString *workYear = self.viewModel.resumeNameModel.WorkYear;
                for ( BaseCode *baseCode in self.viewModel.workYearkArrayM )
                {
                    if ( [baseCode.CodeKey intValue] == [self.viewModel.resumeNameModel.WorkYearKey intValue] )
                    {
                        workYear = baseCode.CodeName;
                        break;
                    }
                }
                [cell.inputTextField setText:workYear];
                return cell;
            }
            case 8:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"现居住地" placeholder:@"请选择城市"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Region];
                return cell;
            }
            case 9:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"工作状态" placeholder:@"请选择工作状态"];
                for (BaseCode *temp in self.viewModel.jobStatusArray)
                {
                    NSString *str = [NSString stringWithFormat:@"%@",temp.CodeKey];
                    if ([self.viewModel.resumeNameModel.JobStatus isEqualToString:str])
                    {
                        [cell.inputTextField setText:temp.CodeName];
                    }
                }
                return cell;
            }
            case 10:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"毕业时间" placeholder:@"请选择毕业时间"];
                [cell.inputTextField setText:[NSDate cepinYMDFromString:self.viewModel.resumeNameModel.GraduateDate]];
                return cell;
            }
            case 11:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"政治面貌" placeholder:@"请选择政治面貌"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Politics];
                return cell;
            }
            case 12:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"身高(CM)" placeholder:@"请输入身高"];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                if ( self.viewModel.resumeNameModel.Height )
                    [cell.inputTextField setText:[NSString stringWithFormat:@"%@", self.viewModel.resumeNameModel.Height]];
                else
                    [cell.inputTextField setText:@""];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    if ( !text || 0 == text.length )
                        self.viewModel.resumeNameModel.Height = nil;
                    else
                        self.viewModel.resumeNameModel.Height = [NSNumber numberWithLongLong:text.longLongValue];
                }];
                return cell;
            }
            case 13:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"体重(KG)" placeholder:@"请输入体重"];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                if ( self.viewModel.resumeNameModel.Weight )
                    [cell.inputTextField setText:[NSString stringWithFormat:@"%@", self.viewModel.resumeNameModel.Weight]];
                else
                    [cell.inputTextField setText:@""];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    if ( !text || 0 == text.length )
                        self.viewModel.resumeNameModel.Weight = nil;
                    else
                        self.viewModel.resumeNameModel.Weight = [NSNumber numberWithLongLong:text.longLongValue];
                }];
                return cell;
            }
            case 14:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"健康状况" placeholder:@"请选择健康状况"];
                NSString *health = nil;
                switch (self.viewModel.resumeNameModel.HealthType.intValue)
                {
                    case 1:
                        health = @"健康";
                        break;
                    case 2:
                        health = @"良好";
                        break;
                    case 3:
                        health = @"有病史";
                        break;
                    default:
                        health = @"";
                        break;
                }
                [cell.inputTextField setText:health];
                return cell;
            }
            case 15:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"籍  贯" placeholder:@"请选择籍贯"];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.NativeCity];
                return cell;
            }
            case 16:
            {
                ResumeSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeSwitchCell class])];
                if (cell == nil) {
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
                if ( 16 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
        }
    }
    else if ( 1 == indexPath.section )
    {
        switch ( indexPath.row )
        {
            case 0:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"QQ号码" placeholder:@"请输入常用QQ号码"];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.QQ];
                [cell setHidden:!self.moreButton.isSelected];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.QQ = text;
                }];
                if ( 6 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 1:
            {
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"户口所在地" placeholder:@"请选择户口所在地"];
                [cell setHidden:!self.moreButton.isSelected];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Hukou];
                return cell;
            }
            case 2:
            {
                //婚姻状况（0 未知 1、未婚 2、已婚）
                CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
                [cell configCellLeftString:@"婚姻状况" placeholder:@"请选择婚姻状况"];
                [cell setHidden:!self.moreButton.isSelected];
                NSString *merryStatue = nil;
                if ( 0 == [self.viewModel.resumeNameModel.Marital intValue] )
                    merryStatue = @"未知";
                else if ( 1 == [self.viewModel.resumeNameModel.Marital intValue] )
                    merryStatue = @"未婚";
                else
                    merryStatue = @"已婚";
                [cell.inputTextField setText:merryStatue];
                return cell;
            }
            case 10:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"身份证" placeholder:@"请输入身份证"];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell setHidden:!self.moreButton.isSelected];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.IdCardNumber];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.IdCardNumber = text;
                }];
                if ( 6 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 3:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"通讯地址" placeholder:@"请输入通讯地址"];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell setHidden:!self.moreButton.isSelected];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.Address];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.Address = text;
                }];
                if ( 6 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 4:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"邮政编码" placeholder:@"请输入通讯地址的邮政编码"];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell.inputTextField setDelegate:self];
                [cell setHidden:!self.moreButton.isSelected];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.ZipCode];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.ZipCode = text;
                }];
                if ( 6 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 5:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"紧急联系人" placeholder:@"如果联系不到您时，我们会试着..."];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell setHidden:!self.moreButton.isSelected];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.EmergencyContact];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.EmergencyContact = text;
                }];
                if ( 6 == indexPath.row )
                    [cell resetSeparatorLineShowAll:YES];
                else
                    [cell resetSeparatorLineShowAll:NO];
                return cell;
            }
            case 6:
            {
                CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
                [cell configCellLeftString:@"紧急联系人方式" placeholder:@"请填写紧急联系人的手机或者..."];
                [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
                [cell setHidden:!self.moreButton.isSelected];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
                [cell.inputTextField setText:self.viewModel.resumeNameModel.EmergencyContactPhone];
                @weakify(self)
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.viewModel.resumeNameModel.EmergencyContactPhone = text;
                }];
                if ( 6 == indexPath.row )
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( 1 == section )
        return self.firstFooterView;
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = ( 40 + 144 + 40 ) / CP_GLOBALSCALE;
    if ( 1 == section )
    {
        return headerHeight;
    }
    return 0;
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
   if ( 1 == section ) // 5
   {
       return 7;
   }
    return 17;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    return YES;
}
#define CP_PHONE_NUMBERS @"+0123456789\n"
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3) {
        return  [self validateNumber:string];
    }
    if ( textField.tag == 10086 )
    {
        if ( string.length == 0 )
            return YES;
        
        if ( [CP_PHONE_NUMBERS rangeOfString:string].length > 0 )
        {
            if ( textField.text.length > 0 && [string isEqualToString:@"+"] )
                return NO;
            
            if ( [self regex:textField.text] )
            {
                return  NO;
            }
            if ( textField.text.length >= 16.0 )
                return NO;
            else
                return YES;
            
        }
        else
            return NO;
    }
    
    return YES;
}
- (BOOL)regex:(NSString *)str
{
    NSString *MOBIlE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *regexMOBILE = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIlE];
    
    NSString *MOBILE_86 = @"^((\\+86)|(86))?(13)\\d{9}$";
    NSPredicate *regexMOBILE_86 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE_86];
    
    NSString *fixdPhone = @"^(0[0-9]{2,3}/-)?([2-9][0-9]{6,7})+(/-[0-9]{1,4})?$";
    NSPredicate *regexFixdPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", fixdPhone];
    
    if ( [regexMOBILE evaluateWithObject:str] == YES
        || [regexMOBILE_86 evaluateWithObject:str] == YES
        || [regexFixdPhone evaluateWithObject:str] == YES )
    {
        return  YES;
    }
    return NO;
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
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - UIScrollview
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - events respond
- (void)respondMoreButton
{
    for ( NSUInteger index = 0; index < 5; index++ )
    {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if ( self.moreButton.isSelected )
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
@end
