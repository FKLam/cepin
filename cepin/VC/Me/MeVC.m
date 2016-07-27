//
//  MeVC.m
//  cepin
//
//  Created by dujincai on 15/6/1.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "MeVC.h"
#import "UIViewController+NavicationUI.h"
#import "MeCell.h"
#import "MeHeadCell.h"
#import "UserInfoVC.h"
#import "SendResumeVC.h"
#import "ExamReportVC.h"
#import "MeVM.h"
#import "UMFeedbackViewController.h"
#import "DynamicSystemVC.h"
#import "CollectionStatusViewModel.h"
#import "LoginAlterView.h"
#import "CPBindExistAccountController.h"
#import "CPThirdBindAccountController.h"
#import "TBAppDelegate.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
#import "NSString+Extension.h"
#import "CPNMediator+CPNMediatorModuleSettingActions.h"
#import "CPNMediator+CPNMediatorModuleAllResumeActions.h"
#import "CPNMediator+CPNMediatorModulePositionRecommendActions.h"
#import "CPNMediator+CPNMediatorModuleMyCollectionActions.h"
#import "CPNLoginTipsView.h"
#import "CPNMediator+CPNMediatorModuleLoginActions.h"
@interface MeVC ()<UserInfoVCDelegate, SendResumeVCDelegate, DynamicSystemVCDelegate, ExamReportVCDelegate>
@property (nonatomic, strong) CollectionStatusViewModel *collectionStatus;
@property (nonatomic, strong) MeVM *viewModel;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *selecetdItemString;
@property (nonatomic, strong) CPNLoginTipsView *tipsView;
@end
@implementation MeVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewModel = [MeVM new];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.tableView reloadData];
    self.parentViewController.navigationItem.titleView = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self.parentViewController addNavicationObjectWithType:NavcationBarObjectTypeSetting] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender){
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForSetting];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[[RTNetworking shareInstance] httpManager].operationQueue cancelAllOperations];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.viewModel.showMessageVC = self;
    self.title = @"我";
    self.collectionStatus = [CollectionStatusViewModel new];
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth,self.view.viewHeight - (IsIOS7?108:66)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    [self.tableView setBackgroundColor:[UIColor colorWithHexString:@"f0eef5" alpha:1.0]];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [RACObserve(self.viewModel, stateCode)subscribeNext:^(id stateCode) {
        if ([self requestStateWithStateCode:stateCode]==HUDCodeSucess) {
            [self.tableView reloadData];
            [self markComeFrom];
            [self.collectionStatus getUnOperationCount];
        }
    }];
    [RACObserve( self.viewModel, getChangeUserStateCode) subscribeNext:^(id stateCode ) {
        if ( [self requestStateWithStateCode:stateCode] == HUDCodeSucess )
        {
            [self.tableView reloadData];
        }
    }];
    
    //侧边栏红
    @weakify(self);
    [RACObserve(self.collectionStatus, stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self.tableView reloadData];
        }
    }];
    //我的测评侧边栏红
    [RACObserve(self.collectionStatus, unExamCode)subscribeNext:^(id stateCode) {
        if ([self requestStateWithStateCode:stateCode]==HUDCodeSucess) {
            [self.tableView reloadData];
        }
    }];
    [self.viewModel userInfomation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserLogin:) name:CP_ACCOUNT_LONGIN object:nil];
}
- (void)notificationUserLogin:(NSNotification *)userNotifaction
{
    NSNumber *valueNum = [userNotifaction.userInfo valueForKey:CP_ACCOUNT_LONGIN_VALUE];
    // 刷新数据
    if ( [valueNum intValue] == HUDCodeSucess )
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.viewModel userInfomation];
        });
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 1 )
    {
        return 30.0 / CP_GLOBALSCALE;
    }
    if ( indexPath.row == 0 )
    {
        return 300.0 / CP_GLOBALSCALE;
    }
    return 144.0 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (cell == nil ) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"f0eef5" alpha:1.0];
        return cell;
    }
    if (indexPath.row == 0) {
         MeHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeHeadCell class])];
        if (cell == nil ) {
            cell = [[MeHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MeHeadCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setLabelTitleText:self.viewModel.data];
        return cell;
    }
    else
    {
        MeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeCell class])];
        if (cell == nil )
        {
            cell = [[MeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MeCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        switch (indexPath.row)
        {
            case 2:
            {
                [cell setLeftNormalImage:@"center_ic_resume" hightLightImage:@"center_ic_resume_selected"];
                cell.title.text = @"我的简历";
                cell.separatorLineShowLong = NO;
            }
                break;
            case 4:
            {
                [cell setLeftNormalImage:@"center_ic_history" hightLightImage:@"center_ic_history_selected"];
                cell.title.text = @"投递记录";
                cell.separatorLineShowLong = NO;
                
                if(self.collectionStatus.profileState && !self.collectionStatus.profileState.Apply.intValue == 0)
                {
                    cell.reminderView.hidden = NO;
                    cell.reminderView.text = [NSString stringWithFormat:@"%@",self.collectionStatus.profileState.Apply];
                }
                else
                {
                    cell.reminderView.hidden = YES;
                }
            }
                break;
            case 3:
            {
                [cell setLeftNormalImage:@"center_ic _job" hightLightImage:@"center_ic _job_selected"];
                cell.title.text = @"职位推荐";
                cell.separatorLineShowLong = NO;
               
            }
                break;
            case 5:
            {
                [cell setLeftNormalImage:@"center_ic_news" hightLightImage:@"center_ic_news_selected"];
                cell.title.text = @"我的消息";
                cell.separatorLineShowLong = NO;
                if ( self.collectionStatus.profileState && [self.collectionStatus.profileState.Message count] > 0 ) {
                    NSNumber *totalCount = [self.collectionStatus.profileState.Message valueForKey:@"TotalCount"];
                    if ( 0 < [totalCount intValue] )
                        cell.reminderView.hidden = NO;
                    else
                        [cell.reminderView setHidden:YES];
                    cell.reminderView.text = [NSString stringWithFormat:@"%@", totalCount];
                }
                else{
                    cell.reminderView.hidden = YES;
                }
            }
                break;
            case 6:
            {
                [cell setLeftNormalImage:@"center_ic_myexam" hightLightImage:@"center_ic_myexam_selected"];
                cell.title.text = @"我的测评";
                cell.separatorLineShowLong = NO;
                if ( self.collectionStatus.profileState && [self.collectionStatus.profileState.Exam count] > 0 ) {
                    NSNumber *totalCount = [self.collectionStatus.profileState.Exam valueForKey:@"TotalCount"];
                    if ( 0 < [totalCount intValue] )
                        cell.reminderView.hidden = NO;
                    else
                        [cell.reminderView setHidden:YES];
                    cell.reminderView.text = [NSString stringWithFormat:@"%@", totalCount];
                }
                else{
                    cell.reminderView.hidden = YES;
                }
            }
                break;
            case 7:
     
            {
                [cell setLeftNormalImage:@"center_ic_collection" hightLightImage:@"center_ic_collection_selected"];
                cell.title.text = @"我的收藏";
                cell.separatorLineShowLong = YES;
            }
                break;
            default:
                break;
        }
        return cell;
    }
    return nil; 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            NSString *mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
            if ( !mobileString || 0 == [mobileString length] )
            {
                mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
            }
            if ( !mobileString || 0 == [mobileString length] )
            {
                [MobClick event:@"please_login_click"];
                [MobClick event:@"slid_login"];
                //直接进入登陆页
                self.selecetdItemString = @"MeProfile";
                [self.tipsView showTips];
                return;
            }
            UserInfoVC *vc = [[UserInfoVC alloc] init];
            [vc setUserInfoVCDelegate:self];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            if (![MemoryCacheData shareInstance].isLogin)
            {
                self.selecetdItemString = @"MeResume";
                [self.tipsView showTips];
                return;
            }
            //统计我的简历
            [MobClick event:@"slide_resume"];
            UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForAllResume];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4: // 投递记录
        {
            if (![MemoryCacheData shareInstance].isLogin)
            {
                self.selecetdItemString = @"MeDelivery";
                [self.tipsView showTips];
                return;
            }
            [MobClick event:@"slide_deliver"];
            SendResumeVC *vc = [SendResumeVC new];
            [vc setSendResumeDelegate:self];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: // 职位推荐
        {
            if (![MemoryCacheData shareInstance].isLogin)
            {
                self.selecetdItemString = @"MePositionRecommend";
                [self.tipsView showTips];
                return;
            }
            //统计设置
            [MobClick event:@"news"];
            UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForPositionRecommend];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 5: // 我的消息
        {
            if (![MemoryCacheData shareInstance].isLogin)
            {
                self.selecetdItemString = @"MeMessage";
                [self.tipsView showTips];
                return;
            }
            //统计设置
            [MobClick event:@"news"];
            if ( self.collectionStatus.profileState )
            {
                NSNumber *opetion = @0;
                NSNumber *totalCount = [self.collectionStatus.profileState.Message valueForKey:@"TotalCount"];
                NSNumber *enterpriseMessage = [self.collectionStatus.profileState.Message valueForKey:@"EnterpriseMessage"];
                NSNumber *systemMessage = [self.collectionStatus.profileState.Message valueForKey:@"SystemMessage"];
                if ( [totalCount intValue] > 0 )
                {
                    if ( [enterpriseMessage intValue] == 0 && 0 < [systemMessage intValue] )
                    {
                        opetion = @1;
                    }
                }
                DynamicSystemVC *vc = [[DynamicSystemVC alloc] initWithOpetion:opetion];
                [vc setDynamicSystemDelegate:self];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                DynamicSystemVC *vc = [[DynamicSystemVC alloc] init];
                [vc setDynamicSystemDelegate:self];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 6:
        {
            if (![MemoryCacheData shareInstance].isLogin)
            {
                self.selecetdItemString = @"MeTest";
                [self.tipsView showTips];
                return;
            }
            [MobClick event:@"slide_cepin_finished"];
            ExamReportVC *vc = [[ExamReportVC alloc]init];
            [vc setExamReportVCDelegate:self];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            if (![MemoryCacheData shareInstance].isLogin)
            {
                self.selecetdItemString = @"MeCollection";
                [self.tipsView showTips];
                return;
            }
            [MobClick event:@"slide_favorite"];
            UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForMyCollection];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UserInfoVCDelegate
- (void)userInfoVCDidFinishEditing
{
    [self.viewModel getChangeUserInfor];
}
#pragma mark - SendResumeVCDelegate
- (void)sendResumeVCNotify
{
    [self.collectionStatus getUnOperationCount];
}
#pragma mark - DynamicSystemVCDelegate
- (void)dynamicSystemVCNotify
{
    [self.collectionStatus getUnOperationCount];
}
#pragma mark - ExamReportVCDelegate
- (void)examReportVCNotify
{
    [self.collectionStatus getUnOperationCount];
}
- (void)markComeFrom
{
    if ( !self.selecetdItemString || [self.selecetdItemString isEqualToString:@"MeProfile"] )
        return;
    if ( ![[MemoryCacheData shareInstance].userLoginData.UserId length] || 0 == [[MemoryCacheData shareInstance].userLoginData.UserId length] )
        return;
    if ( self.selecetdItemString && [self.selecetdItemString  isEqualToString:@"MeResume"]
             )
    {
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForAllResume];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ( self.selecetdItemString && [self.selecetdItemString isEqualToString:@"MeDelivery"]
             )
    {
        SendResumeVC *vc = [[SendResumeVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( self.selecetdItemString && [self.selecetdItemString isEqualToString:@"MePositionRecommend"]
             )
    {
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForPositionRecommend];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ( self.selecetdItemString && [self.selecetdItemString  isEqualToString:@"MeMessage"]
             )
    {
        DynamicSystemVC *vc = [[DynamicSystemVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( self.selecetdItemString && [self.selecetdItemString  isEqualToString:@"MeTest"]
             )
    {
        ExamReportVC *vc = [[ExamReportVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( self.selecetdItemString && [self.selecetdItemString  isEqualToString:@"MeCollection"]
             )
    {
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForMyCollection];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    self.selecetdItemString = nil;
}
#pragma mark - getter methods
- (CPNLoginTipsView *)tipsView
{
    if ( !_tipsView )
    {
        _tipsView = [[CPNLoginTipsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:@"提示" message:@"您还没登录，登录才能使用此功能!" confirmBlock:^{
            NSDictionary *params = [NSDictionary dictionaryWithObject:self.selecetdItemString forKey:@"comfrom"];
            UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
            [self presentViewController:nav animated:YES completion:nil];;
        } cancelBlock:^{
            self.selecetdItemString = @"";
        }];
    }
    return _tipsView;
}
@end
