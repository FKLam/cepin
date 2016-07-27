//
//  AboutVC.m
//  cepin
//
//  Created by dujincai on 15/5/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AboutVC.h"
#import "AboutCell.h"
#import "TBAppDelegate.h"
#import "TBUmengShareConfig.h"
#import "UmengView.h"
#import <StoreKit/StoreKit.h>
#import "UMSocial.h"
#import "PositionIdModel.h"
#import "KeyWordModel.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "RTNetworking+User.h"
#import "AlertDialogView.h"
#import "CPCommon.h"
#import "CPTestEnsureArrowCell.h"
#import "CPPositionDetailDescribeLabel.h"
#import "NSString+Extension.h"
#import "CPNMediator+CPNMediatorModuleFeedbackActions.h"
#import "CPNMediator+CPNMediatorModuleChangePWActions.h"
#import "CPNMediator+CPNMediatorModuleAgreementActions.h"
#import "CPNLoginTipsView.h"
#import "CPNMediator+CPNMediatorModuleLoginActions.h"
@interface AboutVC ()<UITableViewDataSource,UITableViewDelegate,UmengViewDelegate,SKStoreProductViewControllerDelegate,UIAlertViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)NSArray *titleArrays;
@property(nonatomic,strong)NSArray *subArrays;
@property(nonatomic,strong)UIButton *exitButton;
@property(nonatomic,retain)UmengView *umengView;
@property(nonatomic,strong)AlertDialogView *alertView;
@property (nonatomic, strong) NSString *selecetdItemString;
@property (nonatomic, strong) CPNLoginTipsView *tipsView;
@property (nonatomic, strong) CPNLoginTipsView *singoutTipsView;
@end
@implementation AboutVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleArrays = @[@"给我打分",@"当前版本",@"测聘网服务条款", @"清除缓存", @"分享给好友", @"意见反馈", @"修改密码"];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        currentVersion = [@"V" stringByAppendingString:currentVersion];
        self.subArrays = @[@"", currentVersion, @"", @"", @"", @"", @""];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    if ( !mobileString || 0 == [mobileString length] )
    {
        mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    }
    if ( !mobileString || 0 == [mobileString length] )
    {
        [self.exitButton setTitle:@"登录" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    //统计设置
    [MobClick event:@"set_up"];
    self.umengView = [UmengView new];
    self.umengView .delegate = self;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.viewWidth, 7 * 144 / CP_GLOBALSCALE + 32 / CP_GLOBALSCALE) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = CPColor(0xf0, 0xef, 0xf5, 1.0);
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat loginButtonTempHeight = 84.0 / CP_GLOBALSCALE;
    if ( CP_IS_IPHONE_4_OR_LESS )
        loginButtonTempHeight = 30 / CP_GLOBALSCALE;
    self.exitButton.frame = CGRectMake( 40 / CP_GLOBALSCALE, CGRectGetMaxY(self.tableView.frame) + loginButtonTempHeight, self.view.viewWidth - 40 / CP_GLOBALSCALE * 2, 144.0 / CP_GLOBALSCALE );
    NSString *mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    if ( !mobileString || 0 == [mobileString length] )
    {
        mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    }
    if ( !mobileString || 0 == [mobileString length] )
    {
       [self.exitButton setTitle:@"登录" forState:UIControlStateNormal];
    }
    else
    {
        [self.exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    self.exitButton.titleLabel.font = [[RTAPPUIHelper shareInstance] bigTitleFont];
    [self.exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.exitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.exitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    self.exitButton.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
    self.exitButton.layer.masksToBounds = YES;
    [self.view addSubview:self.exitButton];
    [self.exitButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.exitButton.tag = 1;
        NSString *mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
        if ( !mobileString || 0 == [mobileString length] )
        {
            mobileString = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
        }
        if ( !mobileString || 0 == [mobileString length] )
        {
            NSDictionary *params = [NSDictionary dictionaryWithObject:@"aboutlogin" forKey:@"comfrom"];
            UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            [self.singoutTipsView showTips];
        }
    }];
}
-(void)exitAccount
{
    //统计退出登录
    [MobClick event:@"tabout_activity_exit"];
    self.alertView.hidden = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"resetJobVC" object:nil userInfo:nil];
    [[MemoryCacheData shareInstance]disConnect];
    [self clearApptoken];//清空token信息
    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate ChangeToMainTwo];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.exitButton.tag == 1)
    {
        if (buttonIndex == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetJobVC" object:nil userInfo:nil];
            [[MemoryCacheData shareInstance]disConnect];
            [self clearApptoken];//清空token信息
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
        }
    }
    else // 确定清除缓存
    {
        if (buttonIndex == 1) {
            [PositionIdModel deleteWithWhere:nil];
            [KeywordModel deleteWithWhere:nil];
            //移除本地图片
            [RTPictureHelper deleteImage:@"CepinBannerOne.png"];
            [OMGToast showWithText:@"清除完成" topOffset:ShowTextBottomOffsetY duration:2.0];
            // 发送通知，要推荐页刷新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:CP_PROFILE_CLEARCACHE object:nil userInfo:@{ CP_PROFILE_CLEARCACHE_COMFIRT : @1 }];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 )
    {
        return 30.0 / CP_GLOBALSCALE;
    }
    return 144.0 / CP_GLOBALSCALE;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArrays.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
    [cell configCellLeftString:self.titleArrays[indexPath.row - 1] placeholder:self.subArrays[indexPath.row - 1]];
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.titleArrays count] )
        isShowAll = YES;
    [cell resetSeparatorLineShowAll:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ( indexPath.row == 5 ) {
        //统计分享
        [MobClick event:@"tabout_activity_share"];
        [self.umengView show];
        self.selecetdItemString = @"aboutshare";
    }
    if ( indexPath.row == 1 )
    {
        //统计打分吧
        [MobClick event:@"rate"];
        //跳到AppStore
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=894486180" ];
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id894486180"];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        self.selecetdItemString = @"aboutrate";
    }
    if (indexPath.row == 2)
    {
        [MobClick event:@"setting_btn_findnew_version"];
        self.selecetdItemString = @"aboutcheckupdate";
        return;
    }
    if (indexPath.row == 3)
    {
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForAgreement];
        [self.navigationController pushViewController:viewController animated:YES];
        self.selecetdItemString = @"aboutproto";
    }
    if (indexPath.row == 7)
    {
        self.selecetdItemString = @"aboutmodifypw";
        if (![MemoryCacheData shareInstance].isLogin)
        {
            [self.tipsView showTips];
            return;
        }
        //修改密码
        [MobClick event:@"to_update_password"];
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForChangePW];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (indexPath.row == 4)
    {
        [MobClick event:@"setting_btn_clean"];
        self.exitButton.tag = 2;
        [self alertCancelWithMessage:@"是否清除缓存"];
        self.selecetdItemString = @"aboutclearcache";
    }
    if ( indexPath.row == 6 )
    {
        [MobClick event:@"setting_btn_feedback"];
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForFeedback];
        [self.navigationController pushViewController:viewController animated:YES];
        self.selecetdItemString = @"aboutfeedback";
    }
}
- (void)configToOpen
{
    if ( [self.selecetdItemString isEqualToString:@"aboutmodifypw"] )
    {
        UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForChangePW];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
-(void)didChooseUmengView:(int)tag
{
    [self.umengView disMiss];
    NSMutableArray  *title = [[NSMutableArray alloc]init];
    if([WXApi isWXAppInstalled])
    {
        [title addObject:@"微信好友"];
        [title addObject:@"朋友圈"];
    }
    [title addObject:@"新浪微博"];
    if([QQApiInterface isQQInstalled])
    {
        [title addObject:@"QQ"];
        [title addObject:@"QQ空间"];
    }
    NSString *platformName = nil;
    NSString *selectedTitle = [title objectAtIndex:tag];
    if ( [selectedTitle isEqualToString:@"新浪微博"] )
    {
        platformName = @"sina";
    }
    else if ( [selectedTitle isEqualToString:@"微信好友"] )
    {
        platformName = @"wxsession";
    }
    else if ( [selectedTitle isEqualToString:@"朋友圈"] )
    {
        platformName = @"wxfriend";
    }
    else if ( [selectedTitle isEqualToString:@"QQ"] )
    {
        platformName = @"qq";
    }
    else if ( [selectedTitle isEqualToString:@"QQ空间"] )
    {
        platformName = @"qzone";
    }
    if ([platformName isEqualToString:@"sms"]) {
        NSString *content = @"测聘网-专注精准测评的智能招聘平台！我在使用测聘网找工作，推荐你也试试哦~";
        NSString *strTitle = @"";
        NSString *url = @"http://app.cepin.com";
        [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:strTitle content:content url:url imageUrl:@"" completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess)
            {
            }
            else
            {
                [OMGToast showWithText:@"分享失败" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            
        }];
    }
    else if([platformName isEqualToString:@"sina"])
    {
        NSString *content = [NSString stringWithFormat:@"测聘网-专注精准测评的智能招聘平台！我在使用测聘网找工作，推荐你也试试哦~http://app.cepin.com"];
        [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:[UIImage imageNamed:@"cepin_icon_share"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    else
    {
        NSString *content = @"专注精准测评的智能招聘平台！";
        NSString *strTitle = @"我在使用测聘网找工作。";
        NSString *url = @"http://app.cepin.com";
        [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:strTitle content:content url:url imageUrl:@"" completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess)
            {
                [OMGToast showWithText:@"分享成功" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                [OMGToast showWithText:@"分享失败" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
        }];
    }
}
-(void)clearApptoken
{
    //清除token信息
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"uapp_token"];
    if (!strTocken) {
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance]updateAppTokenWithUserId:strUser tokenId:strTocken appDeviceToken:@""];
    [signal subscribeNext:^(RACTuple *tuple){
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            //            NSLog(@"上传apptoken成功");
        }else{
            //            NSLog(@"上传apptoken失败");
        }
    } error:^(NSError *error){
    }];
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - getter methods
- (CPNLoginTipsView *)singoutTipsView
{
    if ( !_singoutTipsView )
    {
        _singoutTipsView = [[CPNLoginTipsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:@"退出" message:@"是否退出登录" buttonTitles:@[@"取消", @"确定"] confirmBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetJobVC" object:nil userInfo:nil];
            [[MemoryCacheData shareInstance] disConnect];
            [PositionIdModel deleteWithWhere:nil];
            [self clearApptoken];//清空token信息
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
        } cancelBlock:^{
            
        }];
    }
    return _singoutTipsView;
}
- (CPNLoginTipsView *)tipsView
{
    if ( !_tipsView )
    {
        _tipsView = [[CPNLoginTipsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:@"提示" message:@"您还没登录，登录才能使用此功能!" buttonTitles:@[@"暂不登录", @"去登录"] confirmBlock:^{
            if ( ![self.selecetdItemString isEqualToString:@"aboutmodifypw"] )
                self.selecetdItemString = @"aboutlogin";
            NSDictionary *params = [NSDictionary dictionaryWithObject:self.selecetdItemString forKey:@"comfrom"];
            UIViewController *viewController = [[CPNMediator alloc] CPNMediator_viewControllerForLogin:params];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:viewController];
            [self.navigationController presentViewController:nav animated:YES completion:nil];;
        } cancelBlock:^{
            
        }];
    }
    return _tipsView;
}
@end
