//
//  LoginVC.m
//  cepin
//
//  Created by ricky.tang on 14-10-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "LoginVC.h"
#import "UMSocialSnsPlatformManager.h"
#import "LoginVM.h"
#import "SignupVC.h"
#import "UserThirdLoginInfoDTO.h"
#import "UIViewController+NavicationUI.h"
#import "UIHyperlinksButton.h"
#import "DKCircleButton.h"
#import "CustemLineLable.h"
#import "UserThirdLoginInfoDTO.h"
#import "UMSocial.h"
#import "TBAppDelegate.h"
#import "ForgetPasswordVC.h"
#import "SignupGuideResumeVC.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "NOQQVC.h"
#import "GuideStatesMv.h"
#import "CPCommon.h"
#import <CoreLocation/CoreLocation.h>
#import "NSString+Extension.h"
#import "CPThirdBindAccountController.h"
#import "CPTestEnsureTextFiled.h"
#import "CPLoginPasswordTextField.h"
#import "CPLoginLookPWButton.h"
#import "UserInfoVC.h"
#import "AllResumeVC.h"
#import "SendResumeVC.h"
#import "CPProfilePositionRecommendController.h"
#import "SaveVC.h"
#import "DynamicSystemVC.h"
#import "ExamReportVC.h"
#import "DynamicExamVC.h"
#import "AboutVC.h"
#import "CPWBindMobileController.h"
#import "RecommendVC.h"
#import "DynamicExamNotHomeVC.h"
#import "CPNMediator+CPNMediatorModuleFreePasswordLoginActions.h"
@interface LoginVC ()<UITextFieldDelegate,CLLocationManagerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *buttonQQ;
@property (nonatomic, strong) UIButton *buttonWeiBo;
@property (nonatomic, strong) UIButton *buttonWeiXin;
@property (nonatomic, strong) UIButton *buttonLogin;
@property (nonatomic, strong) LoginVM *viewModel;
@property (nonatomic, retain) CPTestEnsureTextFiled *accountField;
@property (nonatomic, strong) CPLoginPasswordTextField *passwordField;
@property (nonatomic, strong) CPTestEnsureTextFiled *textField;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *currentCityName;
@property (nonatomic, strong) UIView *topBlueView;
@property (nonatomic, strong) UIImageView *loginImageView;
@property (nonatomic, strong) UIButton *accountLoginButton;
@property (nonatomic, strong) UIButton *freePWLoginButton;
@property (nonatomic, strong) UIView *accountView;
@property (nonatomic, strong) UIView *PWView;
@property (nonatomic, strong) UIButton *selectedLoginButton;
@property (nonatomic, strong) UIImageView *selectedFlagImageView;
@property (nonatomic, strong) UIView *accountBackgroundView;
@property (nonatomic, strong) UIView *freePWBackgroundView;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIView *registeredPhoneView;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) CPTestEnsureTextFiled *registeredTextField;
@property (nonatomic, strong) CPTestEnsureTextFiled *codeTextField;
@property (nonatomic, strong) UIButton *buttonFreeLogin;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *touristButton;
@property (nonatomic, strong) NSString *comeFromString;
@property (nonatomic, strong) NSDictionary *notificationDict;
@end
@implementation LoginVC
-(instancetype)init
{
    if (self = [super init])
    {
        self.isFirstPush = true;
        self.viewModel = [LoginVM new];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithComeFromString:(NSString *)comeFromString
{
    self = [super init];
    if ( self )
    {
        self.isFirstPush = true;
        self.viewModel = [LoginVM new];
        self.viewModel.showMessageVC = self;
        self.comeFromString = comeFromString;
    }
    return self;
}
- (instancetype)initWithComeFromString:(NSString *)comeFromString notificationDict:(NSDictionary *)notificationDict
{
    self = [self initWithComeFromString:comeFromString];
    if ( self )
    {
        self.notificationDict = notificationDict;
    }
    return self;
}
-(void)clickedBackBtn:(id)sender
{
    [self.view endEditing:YES];
    if ( self.navigationController.presentingViewController )
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [MobClick event:@"login_launch"];
#pragma mark - 纪录运行程序的情况
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"launchButNotLogin"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    //当城市为空时才开始请求gprs数据
    self.locationManager = [[CLLocationManager alloc] init] ;
    self.locationManager.delegate = self;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ( version.floatValue >= 8.f )
    {
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    [self.locationManager startUpdatingLocation];
    [self.view addSubview:self.topBlueView];
    [self.view addSubview:self.accountBackgroundView];
    [self setupUI];
    RAC(self.viewModel,account) = self.accountField.rac_textSignal;
    @weakify(self)
    [self.passwordField.rac_textSignal subscribeNext:^(NSString *text){
        @strongify(self);
        self.viewModel.password = text;
        if ([text isEqualToString:@""] || [self.accountField.text isEqualToString:@""]) {
            [self.buttonLogin setEnabled:NO];
        }
        else
        {
            [self.buttonLogin setEnabled:YES];
        }
    }];
    [self.accountField.rac_textSignal subscribeNext:^(NSString *text){
        @strongify(self);
        self.viewModel.account = text;
        if ([text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
            [self.buttonLogin setEnabled:NO];
        }
        else
        {
            [self.buttonLogin setEnabled:YES];
        }
    }];
    [[self.registeredTextField rac_textSignal]subscribeNext:^(NSString *text) {
        self.viewModel.mobile = text;
        if ( !self.viewModel.isSendMobileValid )
        {
            if ( 0 < [text length] )
            {
                [self.codeButton setEnabled:YES];
            }
            else
            {
                [self.codeButton setEnabled:NO];
            }
        }
    }];
    [self.buttonLogin handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        @strongify(self);
        if(!self.viewModel.account || !self.viewModel.password || [@"" isEqualToString:self.viewModel.account] || [@"" isEqualToString:self.viewModel.password]){
            return;
        }
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"isFirstLaunch"];
        //统计登录
        [MobClick event:@"login"];
        [self.textField resignFirstResponder];
        [self.viewModel Login];
    }];
    [self.buttonQQ handleControlEvent:UIControlEventTouchUpInside withBlock:^(id button){
        @strongify(self);
        //统计微信登录点击次数
        [MobClick event:@"btn_qq"];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess)
            {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                self.viewModel.thirdLoginType = @"Tencent";
                self.viewModel.thirdLoginId = snsAccount.usid;
                self.viewModel.thirdLoginName =  snsAccount.userName;
                [self.viewModel thirdPartLogin];
            }
            else
            {
                [OMGToast showWithText:@"获取授权失败" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
        });
    }];
    [self.buttonWeiBo handleControlEvent:UIControlEventTouchUpInside withBlock:^(id button){
        @strongify(self);
        //统计sina登录点击次数
        [MobClick event:@"btn_sina"];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if ( response.responseCode == UMSResponseCodeSuccess )
            {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                self.viewModel.thirdLoginType = @"Sina";
                self.viewModel.thirdLoginId = snsAccount.usid;
                self.viewModel.thirdLoginName =  snsAccount.userName;
                [self.viewModel thirdPartLogin];
            }
            else
            {
                [OMGToast showWithText:@"获取授权失败" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
        });
    }];
    [self.buttonWeiXin handleControlEvent:UIControlEventTouchUpInside withBlock:^(id button){
        @strongify(self);
        //统计微信登录点击次数
        [MobClick event:@"btn_weixin"];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess)
            {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
                self.viewModel.thirdLoginType = @"weixin";
                self.viewModel.thirdLoginId = snsAccount.usid;
                self.viewModel.thirdLoginName =  snsAccount.userName;
                [self.viewModel thirdPartLogin];
            }
            else
            {
                [OMGToast showWithText:@"获取授权失败" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
        });
    }];
    //登录简历引导
    [RACObserve(self.viewModel,AllResumeStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
           
        }
        else if (code == HUDCodeNone){
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate guidResumeVC:self.viewModel.mobile isSocialResume:true comeFromString:nil];
        }
    }];
    //自己服务器登录
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            //统计登录成功
            [MobClick event:@"login_succeed"];
            [self comeFromLogin];
        }
    }];
    //第三方登录
    [RACObserve(self.viewModel, thirdPartLoginStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if ( code == HUDCodeSucess )
        {
            //统计第三方登录成功
            if ( [@"Tencent" isEqualToString:self.viewModel.thirdLoginType] )
            {
                [MobClick event:@"succeed_by_qq"];
            }
            else if ( [@"weixin" isEqualToString:self.viewModel.thirdLoginType] )
            {
                [MobClick event:@"succeed_by_weixin"];
            }
            else if ( [@"Sina" isEqualToString:self.viewModel.thirdLoginType] )
            {
                [MobClick event:@"succeed_by_sina"];
            }
            // 判断第三方登录帐号是否有绑定手机
            if ( self.viewModel.login.Moblie && 0 < [self.viewModel.login.Moblie length] )
            {
                [self comeFromLogin];
            }
            else
            {
                if ( [self.comeFromString isEqualToString:@"notificationshomeTestList"] )
                {
                    CPThirdBindAccountController *vc = [[CPThirdBindAccountController alloc] initWithComeFromString:self.comeFromString notificationDict:self.notificationDict];
                    [vc configWithUserData:self.viewModel.login];
                    if ( self.navigationController )
                        [self.navigationController pushViewController:vc animated:YES];
                    else
                    {
                        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                        [self presentViewController:nav animated:YES completion:nil];
                    }
                }
                else
                {
                    CPThirdBindAccountController *vc = [[CPThirdBindAccountController alloc] initWithComeFromString:self.comeFromString];
                    [vc configWithUserData:self.viewModel.login];
                    if ( self.navigationController )
                        [self.navigationController pushViewController:vc animated:YES];
                    else
                    {
                        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                        [self presentViewController:nav animated:YES completion:nil];
                    }
                }
            }
        }
    }];
    [RACObserve(self.viewModel, getUserInfoStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if ( code == HUDCodeSucess )
        {
            [self comeFromeGetUserInfo];
        }
    }];
    NSString *accountText = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAccout"];
    if (accountText)
    {
        self.accountField.text = accountText;
        self.viewModel.account = accountText;
    }
    [[self.registeredTextField rac_textSignal]subscribeNext:^(NSString *text) {
        if ( 0 < [text length] && [self.codeTextField.text length] > 0 )
        {
            [self.buttonFreeLogin setEnabled:YES];
        }
        else
        {
            [self.buttonFreeLogin setEnabled:NO];
        }
    }];
    [[self.codeTextField rac_textSignal]subscribeNext:^(NSString *text) {
        self.viewModel.mobileCode = text;
        if ( 0 < [text length] && [self.registeredTextField.text length] > 0 )
        {
            [self.buttonFreeLogin setEnabled:YES];
        }
        else
        {
            [self.buttonFreeLogin setEnabled:NO];
        }
    }];
    // 成功获取验证码
    [RACObserve( self.viewModel, mobialStateCode) subscribeNext:^(id stateCode ) {
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if ( code == HUDCodeSucess )
        {
            [self startTime];
        }
    }];
    // 免密码登录成功
    [RACObserve( self.viewModel, freeLoginStateCode ) subscribeNext:^(id stateCode ) {
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            //统计登录成功
            [MobClick event:@"login_succeed"];
            [self comeFromLogin];
        }
    }];
}
#pragma mark - 初始化UI
- (void)setupUI
{
    // 手机号快捷登录按钮
    UIButton *fastLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fastLoginButton.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [fastLoginButton setTitle:@"手机号快捷登录" forState:UIControlStateNormal];
    fastLoginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [fastLoginButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
    [self.view addSubview:fastLoginButton];
    [fastLoginButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        UIViewController *viewController = [[CPNMediator sharedInstance] CPNMediator_viewControllerForFreePassword];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [fastLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.top.equalTo(self.accountBackgroundView.mas_bottom).offset(0);
        make.height.equalTo(@( 144 / CP_GLOBALSCALE ));
    }];
    // 忘记密码按钮
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [forgetButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
    [self.view addSubview:forgetButton];
    [forgetButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"isFirstLaunch"];
        ForgetPasswordVC *vc = [ForgetPasswordVC new];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accountBackgroundView.mas_right).offset( -40 / CP_GLOBALSCALE );
        make.top.equalTo(self.accountBackgroundView.mas_bottom).offset(0);
        make.height.equalTo(@( 144 / CP_GLOBALSCALE ));
    }];
    // 登录按钮
    self.buttonLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonLogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.buttonLogin setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.buttonLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.buttonLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
    [self.buttonLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    self.buttonLogin.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
    self.buttonLogin.layer.masksToBounds = YES;
    self.buttonLogin.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    [self.view addSubview:self.buttonLogin];
    [self.buttonLogin setEnabled:NO];
    CGFloat loginButtonHeight = 40 / CP_GLOBALSCALE;
    if ( CP_IS_IPHONE_4_OR_LESS )
        loginButtonHeight = 24 / CP_GLOBALSCALE;
    CGFloat buttonHeight = 144 / CP_GLOBALSCALE;
    if ( CP_IS_IPHONE_4_OR_LESS )
        buttonHeight = 100 / ( 3.0 * ( 1 / 1.29 ) );
    [self.buttonLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.top.equalTo( fastLoginButton.mas_bottom );
        make.height.equalTo( @( buttonHeight ) );
    }];
    // 注册按钮
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.buttonLogin.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.buttonLogin );
        make.right.equalTo( self.buttonLogin );
        make.height.equalTo( self.buttonLogin );
    }];
    [self.registerBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"isFirstLaunch"];
        //统计立即注册文字引导
        [MobClick event:@"lead_to_regist"];
        [MobClick event:@"register_id"];
        if ( self.comeFromString && 0 < [self.comeFromString length] )
        {
            if ( [self.comeFromString isEqualToString:@"notificationshomeTestList"] )
            {
                SignupVC *vc = [[SignupVC alloc] initWithComeFormString:self.comeFromString notificationDict:self.notificationDict];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                SignupVC *vc = [[SignupVC alloc] initWithComeFormString:self.comeFromString];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else
        {
            SignupVC *vc = [[SignupVC alloc] init];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
    // 第三方登录标签
    CustemLineLable *thirdPartLab = [[CustemLineLable alloc] init];
    thirdPartLab.text = @"第三方登录";
    thirdPartLab.lineType = LineTypeMiddle;
    thirdPartLab.textColor = [UIColor colorWithHexString:@"9d9d9d"];
    thirdPartLab.font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
    thirdPartLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thirdPartLab];
    [thirdPartLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.registerBtn.mas_bottom ).offset( 80 / CP_GLOBALSCALE );
        make.centerX.equalTo( self.registerBtn );
        make.height.equalTo( @(36 / CP_GLOBALSCALE) );
    }];
    // 第三方登录按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"login_qq_null"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateHighlighted];
    self.buttonQQ = btn;
    [self.view addSubview:self.buttonQQ];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"login_weibo_null"] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"login_weibo"] forState:UIControlStateHighlighted];
    self.buttonWeiBo = btn1;
    [self.view addSubview:self.buttonWeiBo];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"login_wechat_null"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateHighlighted];
    self.buttonWeiXin = btn2;
    [self.view addSubview:self.buttonWeiXin];
    CGFloat forgetHeight = 180 / CP_GLOBALSCALE;
    if ( CP_IS_IPHONE_4_OR_LESS )
        forgetHeight = 150 / CP_GLOBALSCALE;
    [self.buttonWeiXin mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.top.equalTo( thirdPartLab.mas_bottom ).offset( 50 / CP_GLOBALSCALE );
        maker.height.equalTo( @( 114.0 / CP_GLOBALSCALE ) );
        maker.width.equalTo( @( 114.0 / CP_GLOBALSCALE ) );
        maker.centerX.equalTo( self.view.mas_centerX );
    }];
    [self.buttonQQ mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.right.equalTo( self.buttonWeiXin.mas_left ).offset( -115 / CP_GLOBALSCALE );
        maker.height.equalTo( self.buttonWeiXin );
        maker.width.equalTo( self.buttonWeiXin );
        maker.centerY.equalTo( self.buttonWeiXin );
    }];
    [self.buttonWeiBo mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.left.equalTo( self.buttonWeiXin.mas_right ).offset( 115 / CP_GLOBALSCALE );
        maker.height.equalTo( self.buttonWeiXin );
        maker.width.equalTo( self.buttonWeiXin );
        maker.centerY.equalTo( self.buttonWeiXin );
    }];
    // 随便逛逛按钮
    UIButton *touristButton = [UIButton buttonWithType:UIButtonTypeCustom];
    touristButton.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [touristButton setTitle:@"随便逛逛 >" forState:UIControlStateNormal];
    touristButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [touristButton setTitleColor:[UIColor colorWithHexString:@"6cbb56"] forState:UIControlStateNormal];
    [self.view addSubview:touristButton];
    [touristButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo( self.view );
        make.bottom.equalTo( self.view );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
    }];
    [touristButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"isFirstLaunch"];
        //统计随便逛逛
        [MobClick event:@"btn_guangguang"];
        TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate ChangeToMainTwo];
    }];
}
#pragma mark - 记录来源
- (void)comeFromeGetUserInfo
{
    if ( ( [self.viewModel.account rangeOfString:@"@"].location != NSNotFound ) && (!self.viewModel.login.Moblie || 0 == [self.viewModel.login.Moblie length]) )
    {
        NSArray *childArray = self.navigationController.childViewControllers;
        UIViewController *childVC = [childArray lastObject];
        if ( ![childVC isKindOfClass:[self class]] )
            return;
        if ( [self.comeFromString isEqualToString:@"notificationshomeTestList"] )
        {
            CPWBindMobileController *vc = [[CPWBindMobileController alloc] initWithComeFromString:self.comeFromString];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            CPWBindMobileController *vc = [[CPWBindMobileController alloc] initWithComeFromString:self.comeFromString];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeADGuide"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        RecommendVC *childVC = parentVC.childViewControllers[0];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(comeFromeWithString:) withObject:self.comeFromString];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeResume"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        RecommendVC *childVC = parentVC.childViewControllers[0];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(comeFromeWithString:) withObject:self.comeFromString];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeexperience"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        RecommendVC *childVC = parentVC.childViewControllers[0];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(comeFromeWithString:) withObject:self.comeFromString];
    }
}
- (void)comeFromLogin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
    [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_LONGIN object:nil userInfo:@{ CP_ACCOUNT_LONGIN_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
    if ( !self.navigationController )
    {
        if ( ( [self.viewModel.account rangeOfString:@"@"].location != NSNotFound ) && (!self.viewModel.login.Moblie || 0 == [self.viewModel.login.Moblie length]) )
        {
            CPWBindMobileController *vc = [[CPWBindMobileController alloc] initWithComeFromString:self.comeFromString];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            if (self.viewModel.login.ResumeCount.intValue > 0)
            {
                TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate ChangeToMainTwo];
                // 发送设置默认简历的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
            }
            else
            {
                GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
        return;
    }
    if ( ( [self.viewModel.account rangeOfString:@"@"].location != NSNotFound ) && (!self.viewModel.login.Moblie || 0 == [self.viewModel.login.Moblie length]) )
    {
//        NSArray *childArray = self.navigationController.childViewControllers;
//        NSLog(@"%@", childArray);
        if ( [self.comeFromString isEqualToString:@"notificationshomeTestList"] )
        {
            CPWBindMobileController *vc = [[CPWBindMobileController alloc] initWithComeFromString:self.comeFromString];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            CPWBindMobileController *vc = [[CPWBindMobileController alloc] initWithComeFromString:self.comeFromString];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    if ( self.comeFromString && [self.comeFromString isEqualToString:@"collection"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[1];
        [parentVC dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"delivery"] )
    {
        if (self.viewModel.login.ResumeCount.intValue > 0)
        {
            NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
            UIViewController *parentVC = childArray[1];
            [parentVC dismissViewControllerAnimated:NO completion:nil];
        }
        else
        {
            GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile comeFromString:@"delivery"];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"MeProfile"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        UIViewController *childVC = parentVC.childViewControllers[3];
        [childVC dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"MeResume"]
             )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        UIViewController *childVC = parentVC.childViewControllers[3];
        [childVC dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"MeDelivery"]
             )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        UIViewController *childVC = parentVC.childViewControllers[3];
        [childVC dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"MePositionRecommend"]
             )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        UIViewController *childVC = parentVC.childViewControllers[3];
        if ( childVC.presentedViewController )
            [childVC dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"MeMessage"]
             )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        UIViewController *childVC = parentVC.childViewControllers[3];
        [childVC dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"MeTest"]
             )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        UIViewController *childVC = parentVC.childViewControllers[3];
        [childVC dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"MeCollection"]
             )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        UIViewController *childVC = parentVC.childViewControllers[3];
        [childVC dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"testList"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        DynamicExamVC *childVC = parentVC.childViewControllers[1];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(outSideOpenExam) withObject:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"aboutmodifypw"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[1];
        AboutVC *aboutVC = (AboutVC *)parentVC;
        [aboutVC dismissViewControllerAnimated:NO completion:nil];
        [aboutVC performSelector:@selector(configToOpen) withObject:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homelogin"] )
    {
        if (self.viewModel.login.ResumeCount.intValue > 0)
        {
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
            // 发送设置默认简历的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
        }
        else
        {
            GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeResume"] )
    {
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homedelivery"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        RecommendVC *childVC = parentVC.childViewControllers[0];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(comeFromeWithString:) withObject:self.comeFromString];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeTestList"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        RecommendVC *childVC = parentVC.childViewControllers[0];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(comeFromeWithString:) withObject:self.comeFromString];
    }
    else if ( [self.comeFromString isEqualToString:@"notificationshomeTestList"] && self.comeFromString )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        RecommendVC *childVC = parentVC.childViewControllers[0];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(comeFromeWithString:notificationDict:) withObject:self.comeFromString withObject:self.notificationDict];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeexperience"] )
    {
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeADGuide"] )
    {
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homedynamictest"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        DynamicExamNotHomeVC *childVC = childArray[1];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(outSideOpenExam) withObject:nil];
    }
    else
    {
        if (self.viewModel.login.ResumeCount.intValue > 0)
        {
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
            // 发送设置默认简历的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
        }
        else
        {
            GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}
//倒计时
- (void)startTime
{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if( timeout <= 0 )
        { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                [self.codeButton setEnabled:YES];
                if ( self.viewModel.isSendMobileValid )
                    self.viewModel.isSendMobileValid = NO;
            });
        }
        else
        {
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            if ( [[strTime substringToIndex:1] isEqualToString:@"0"] )
            {
                strTime = [strTime substringWithRange:NSMakeRange(1, 1)];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@秒后重新获取",strTime] forState:UIControlStateNormal];
                [self.codeButton setEnabled:NO];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    if ( self.comeFromString && 0 < [self.comeFromString length] )
    {
        int hight = 66.0 / 2.0;
        if ( CP_IS_IPHONE_6P )
            hight = 66.0 / ( 2 * 2.6 / 3.0 );
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(44 / CP_GLOBALSCALE, 20 + ( 44 - 33 ) / 2.0, hight, hight);
        [button setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.buttonLogin setEnabled:NO];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(CPTestEnsureTextFiled *)textField
{
    self.textField = textField;
    return YES;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if(self.currentCityName && ![@"" isEqualToString:self.currentCityName]){
            return;
        }
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city)
            {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            self.currentCityName = city;
            if ([self.currentCityName hasSuffix:@"省"] || [self.currentCityName hasSuffix:@"市"] || [self.currentCityName hasSuffix:@"县"])
            {
                self.currentCityName = [self.currentCityName substringToIndex:self.currentCityName.length - 1];
            }
        }
        else
        {
            self.currentCityName = @"";
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.currentCityName forKey:@"LocationCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)
    {
        //提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( textField == self.registeredTextField && ![string isEqualToString:@""] )
    {
        NSString *numberStr = @"1234567890";
        if ( [numberStr rangeOfString:string].length == 0 )
            return NO;
        if( range.location >= 11)
            return NO;
    }
    return YES;
}
#pragma mark - events respond
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)changeLoginFunction:(UIButton *)sender
{
    if ( sender == self.freePWLoginButton )
    {
        [MobClick event:@"click_into_fast_login"];
    }
    if ( !sender || self.selectedLoginButton == sender )
        return;
    [self.view endEditing:YES];
    self.selectedLoginButton.selected = !self.selectedLoginButton.isSelected;
    sender.selected = YES;
    self.selectedLoginButton = sender;
    if ( 0 == sender.tag )
    {
        [self.selectedFlagImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.topBlueView.mas_bottom );
            make.centerX.equalTo( self.accountLoginButton.mas_centerX );
            make.width.equalTo( @( 43 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 18 / CP_GLOBALSCALE ) );
        }];
        [self.backgroundScrollView setContentOffset:CGPointMake(0, 0)];
        [self.registerBtn setHidden:NO];
        [self.touristButton setHidden:NO];
    }
    else
    {
        [self.selectedFlagImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.topBlueView.mas_bottom );
            make.centerX.equalTo( self.freePWLoginButton.mas_centerX );
            make.width.equalTo( @( 43 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 18 / CP_GLOBALSCALE ) );
        }];
        [self.backgroundScrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
        [self.registerBtn setHidden:YES];
        [self.touristButton setHidden:YES];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( scrollView != self.backgroundScrollView )
        return;
    CGFloat offsetX = scrollView.contentOffset.x;
    if ( 0 == offsetX )
    {
        [self changeLoginFunction:self.accountLoginButton];
    }
    else if ( kScreenWidth == offsetX )
    {
        [self changeLoginFunction:self.freePWLoginButton];
    }
}
- (void)clickedLookPWBtn:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    [self.passwordField setSecureTextEntry:!sender.isSelected];
    [self.passwordField becomeFirstResponder];
}
#pragma mark - getter methods
- (UIView *)topBlueView
{
    if ( !_topBlueView )
    {
        CGFloat originHeight = 520.0 + 144.0;
        CGFloat scale = 0.9;
        CGFloat tempHeight = 26;
        CGFloat blueHeight = 40.0;
        if ( !CP_IS_IPHONE_6P || !CP_IS_IPHONE_6 )
        {
            tempHeight = 47.0;
            blueHeight += 18.8;
        }
        if ( CP_IS_IPHONE_4_OR_LESS )
        {
            scale = 0.8;
        }
        if ( CP_IS_IPHONE_4_OR_LESS )
            originHeight = 460;
        _topBlueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, originHeight / CP_GLOBALSCALE)];
        [_topBlueView setBackgroundColor:[UIColor colorWithHexString:@"288add"]];
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20.0)];
        [statusBarView setBackgroundColor:[UIColor colorWithHexString:@"288add" alpha:1.0]];
        [_topBlueView addSubview:statusBarView];
        [_topBlueView addSubview:self.loginImageView];
        [self.loginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _topBlueView.mas_bottom ).offset( -84 / CP_GLOBALSCALE - 144.0 / CP_GLOBALSCALE );
            make.centerX.equalTo( _topBlueView.mas_centerX );
            make.width.equalTo( @( 242 / CP_GLOBALSCALE * scale ) );
            make.height.equalTo( @( 264 / CP_GLOBALSCALE * scale ) );
        }];
        [_topBlueView addSubview:self.accountLoginButton];
        [_topBlueView addSubview:self.freePWLoginButton];
        [self.accountLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _topBlueView.mas_left );
            make.bottom.equalTo( _topBlueView.mas_bottom ).offset( -15 / CP_GLOBALSCALE );
            make.width.equalTo( @( kScreenWidth / 2.0 ) );
        }];
        [self.freePWLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.accountLoginButton.mas_top );
            make.height.equalTo( self.accountLoginButton );
            make.left.equalTo( self.accountLoginButton.mas_right );
            make.width.equalTo( self.accountLoginButton );
        }];
        [_topBlueView addSubview:self.selectedFlagImageView];
    }
    return _topBlueView;
}
- (UIImageView *)loginImageView
{
    if ( !_loginImageView )
    {
        _loginImageView = [[UIImageView alloc] init];
        _loginImageView.image = [UIImage imageNamed:@"login_logo"];
    }
    return _loginImageView;
}
- (UIButton *)accountLoginButton
{
    if ( !_accountLoginButton )
    {
        _accountLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accountLoginButton setTitle:@"账号登录" forState:UIControlStateNormal];
        [_accountLoginButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_accountLoginButton setTitleColor:[UIColor colorWithHexString:@"abcaee"] forState:UIControlStateNormal];
        [_accountLoginButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        [_accountLoginButton addTarget:self action:@selector(changeLoginFunction:) forControlEvents:UIControlEventTouchUpInside];
        [_accountLoginButton setTag:0.0];
        [_accountLoginButton setHidden:YES];
    }
    return _accountLoginButton;
}
- (UIButton *)freePWLoginButton
{
    if ( !_freePWLoginButton )
    {
        _freePWLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_freePWLoginButton setTitle:@"免密码快捷登录" forState:UIControlStateNormal];
        [_freePWLoginButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_freePWLoginButton setTitleColor:[UIColor colorWithHexString:@"abcaee"] forState:UIControlStateNormal];
        [_freePWLoginButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        [_freePWLoginButton addTarget:self action:@selector(changeLoginFunction:) forControlEvents:UIControlEventTouchUpInside];
        [_freePWLoginButton setTag:1.0];
        [_freePWLoginButton setHidden:YES];
    }
    return _freePWLoginButton;
}
- (UIView *)accountView
{
    if ( !_accountView )
    {
        _accountView = [[UIView alloc] init];
        [_accountView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_accountView.layer setCornerRadius:10 / CP_GLOBALSCALE];
//        [_accountView.layer setMasksToBounds:YES];
        UIImageView *accountImage = [[UIImageView alloc] init];
        accountImage.image = [UIImage imageNamed:@"login_ic_id"];
        [_accountView addSubview:accountImage];
        [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _accountView.mas_left ).offset( 30 / CP_GLOBALSCALE );
            make.centerY.equalTo( _accountView.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"f8eef1"]];
        [_accountView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo( _accountView.mas_centerY );
            make.left.equalTo( accountImage.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.height.equalTo( @( 62 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [_accountView addSubview:self.accountField];
        [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _accountView.mas_top );
            make.left.equalTo( lineView.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.bottom.equalTo( _accountView.mas_bottom );
            make.right.equalTo( _accountView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return _accountView;
}
- (UIView *)PWView
{
    if ( !_PWView )
    {
        _PWView = [[UIView alloc] init];
        [_PWView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_PWView.layer setCornerRadius:10 / CP_GLOBALSCALE];
//        [_PWView.layer setMasksToBounds:YES];
        UIImageView *accountImage = [[UIImageView alloc] init];
        accountImage.image = [UIImage imageNamed:@"login_ic_lock"];
        [_PWView addSubview:accountImage];
        [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _PWView.mas_left ).offset( 30 / CP_GLOBALSCALE );
            make.centerY.equalTo( _PWView.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"f8eef1"]];
        [_PWView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _PWView.mas_centerY );
            make.left.equalTo( accountImage.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.height.equalTo(@(62/CP_GLOBALSCALE));
            make.width.equalTo(@(2/CP_GLOBALSCALE));
        }];
        [_PWView addSubview:self.passwordField];
        [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _PWView.mas_top );
            make.left.equalTo( lineView.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.bottom.equalTo( _PWView.mas_bottom );
            make.right.equalTo( _PWView.mas_right ).offset( -(70 + 40) / CP_GLOBALSCALE );
        }];
        UIButton *lookPWBtn = [CPLoginLookPWButton buttonWithType:UIButtonTypeCustom];
        [lookPWBtn setBackgroundImage:[UIImage imageNamed:@"login_ic_eye"] forState:UIControlStateNormal];
        [lookPWBtn setBackgroundImage:[UIImage imageNamed:@"login_ic_eye_selected"] forState:UIControlStateSelected];
        [lookPWBtn addTarget:self action:@selector(clickedLookPWBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_PWView addSubview:lookPWBtn];
        [lookPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _PWView.mas_top );
            make.right.equalTo( _PWView.mas_right );
            make.bottom.equalTo( _PWView.mas_bottom );
            make.left.equalTo( self.passwordField.mas_right );
        }];
    }
    return _PWView;
}
- (CPTestEnsureTextFiled *)accountField
{
    if ( !_accountField )
    {
        _accountField = [[CPTestEnsureTextFiled alloc] init];
        [_accountField setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_accountField setTextColor:[UIColor colorWithHexString:@"404040"]];
        _accountField.placeholder = @"邮箱／手机号码";
        _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountField.delegate = self;
        _accountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _accountField;
}
- (CPLoginPasswordTextField *)passwordField
{
    if ( !_passwordField )
    {
        _passwordField = [[CPLoginPasswordTextField alloc] init];
        [_passwordField setFont:[[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont]];
        [_passwordField setTextColor:[UIColor colorWithHexString:@"404040"]];
        _passwordField.placeholder = @"请输入密码";
        [_passwordField setSecureTextEntry:YES];
        _passwordField.delegate = self;
        _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _passwordField;
}
- (UIImageView *)selectedFlagImageView
{
    if ( !_selectedFlagImageView )
    {
        _selectedFlagImageView = [[UIImageView alloc] init];
        _selectedFlagImageView.image = [UIImage imageNamed:@"login_selected"];
        [_selectedFlagImageView setHidden:YES];
    }
    return _selectedFlagImageView;
}
- (UIScrollView *)backgroundScrollView
{
    if ( !_backgroundScrollView )
    {
        _backgroundScrollView = [[UIScrollView alloc] init];
//        [_backgroundScrollView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_backgroundScrollView setShowsHorizontalScrollIndicator:NO];
        [_backgroundScrollView setPagingEnabled:YES];
        [_backgroundScrollView setDelegate:self];
        [_backgroundScrollView addSubview:self.accountBackgroundView];
        [_backgroundScrollView addSubview:self.freePWBackgroundView];
    }
    return _backgroundScrollView;
}
- (UIView *)accountBackgroundView
{
    if ( !_accountBackgroundView )
    {
        _accountBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, CGRectGetMaxY(self.topBlueView.frame) - 144.0 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE * 2.0, 144.0 / CP_GLOBALSCALE * 2)];
        [_accountBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_accountBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_accountBackgroundView.layer setShadowColor:[UIColor colorWithHexString:@"000000"].CGColor];
        [_accountBackgroundView.layer setShadowOffset:CGSizeMake(0 / CP_GLOBALSCALE, 9 / CP_GLOBALSCALE)];
        [_accountBackgroundView.layer setShadowRadius:4 / CP_GLOBALSCALE];
        [_accountBackgroundView.layer setShadowOpacity:0.1];
        [_accountBackgroundView addSubview:self.accountView];
        CGFloat tempHeight = 40 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            tempHeight = 24 / CP_GLOBALSCALE;
        CGFloat buttonHeight = 144 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            buttonHeight = 100 / ( 3.0 * ( 1 / 1.29 ) );
        [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _accountBackgroundView.mas_top ).offset( 0 );
            make.left.equalTo( _accountBackgroundView.mas_left );
            make.right.equalTo( _accountBackgroundView.mas_right );
            make.height.equalTo( @( buttonHeight ) );
        }];
        [_accountBackgroundView addSubview:self.PWView];
        [self.PWView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.accountView.mas_bottom );
            make.left.equalTo( _accountBackgroundView.mas_left );
            make.right.equalTo( _accountBackgroundView.mas_right );
            make.height.equalTo( @( buttonHeight ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorFromHexCode:@"ede3e6"]];
        [_accountBackgroundView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _accountBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _accountBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.top.equalTo( self.accountView.mas_bottom );
        }];
    }
    return _accountBackgroundView;
}
- (UIView *)freePWBackgroundView
{
    if ( !_freePWBackgroundView )
    {
        CGFloat tempHeight = 40 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            tempHeight = 24 / CP_GLOBALSCALE;
        CGFloat buttonHeight = 144 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            buttonHeight = 100 / ( 3.0 * ( 1 / 1.29 ) );
        _freePWBackgroundView = [[UIView alloc] init];
        [_freePWBackgroundView addSubview:self.registeredPhoneView];
        [_freePWBackgroundView addSubview:self.codeView];
        [_freePWBackgroundView addSubview:self.codeButton];
        [_freePWBackgroundView addSubview:self.buttonFreeLogin];
        [self.registeredPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _freePWBackgroundView.mas_top ).offset( tempHeight );
            make.left.equalTo( _freePWBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _freePWBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( buttonHeight ) );
        }];
        [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.registeredPhoneView.mas_bottom ).offset( tempHeight );
            make.right.equalTo( _freePWBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( buttonHeight ) );
            make.width.equalTo( @( 350 / CP_GLOBALSCALE ) );
        }];
        [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.codeButton.mas_top );
            make.left.equalTo( _freePWBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.codeButton.mas_left ).offset( -30 / CP_GLOBALSCALE );
            make.height.equalTo( self.codeButton );
        }];
        [self.buttonFreeLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.codeButton.mas_bottom ).offset( tempHeight );
            make.left.equalTo( _freePWBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _freePWBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( self.codeButton );
        }];
    }
    return _freePWBackgroundView;
}
- (UIView *)registeredPhoneView
{
    if ( !_registeredPhoneView )
    {
        _registeredPhoneView = [[UIView alloc] init];
        [_registeredPhoneView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_registeredPhoneView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_registeredPhoneView.layer setMasksToBounds:YES];
        UIImageView *accountImage = [[UIImageView alloc] init];
        accountImage.image = [UIImage imageNamed:@"resume_ic_mobile"];
        [_registeredPhoneView addSubview:accountImage];
        [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _registeredPhoneView.mas_left ).offset( 30 / CP_GLOBALSCALE );
            make.centerY.equalTo( _registeredPhoneView.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"f8eef1"]];
        [_registeredPhoneView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo( _accountView.mas_top );
            make.centerY.equalTo( _registeredPhoneView.mas_centerY );
            make.left.equalTo( accountImage.mas_right ).offset( 20 / CP_GLOBALSCALE );
            //            make.bottom.equalTo( _accountView.mas_bottom );
            make.height.equalTo(@(62/CP_GLOBALSCALE));
            make.width.equalTo(@(2/CP_GLOBALSCALE));
            //            make.right.equalTo( _accountView.mas_right ).offset( -40 / 3.0 );
        }];
        [_registeredPhoneView addSubview:self.registeredTextField];
        [self.registeredTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _registeredPhoneView.mas_top );
            make.left.equalTo( lineView.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.bottom.equalTo( _registeredPhoneView.mas_bottom );
            make.right.equalTo( _registeredPhoneView.mas_right ).offset( -20 / CP_GLOBALSCALE );
        }];
    }
    return _registeredPhoneView;
}
- (UIView *)codeView
{
    if ( !_codeView )
    {
        _codeView = [[UIView alloc] init];
        [_codeView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_codeView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_codeView.layer setMasksToBounds:YES];
        UIImageView *accountImage = [[UIImageView alloc] init];
        accountImage.image = [UIImage imageNamed:@"login_ic_code"];
        [_codeView addSubview:accountImage];
        [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _codeView.mas_left ).offset( 30 / CP_GLOBALSCALE );
            make.centerY.equalTo( _codeView.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"f8eef1"]];
        [_codeView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _codeView.mas_centerY );
            make.left.equalTo( accountImage.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.height.equalTo( @( 62 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [_codeView addSubview:self.codeTextField];
        [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _codeView.mas_top );
            make.left.equalTo( lineView.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.bottom.equalTo( _codeView.mas_bottom );
            make.right.equalTo( _codeView.mas_right ).offset( -20 / CP_GLOBALSCALE );
        }];
    }
    return _codeView;
}
- (CPTestEnsureTextFiled *)registeredTextField
{
    if ( !_registeredTextField )
    {
        _registeredTextField = [[CPTestEnsureTextFiled alloc] init];
        [_registeredTextField setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_registeredTextField setTextColor:[UIColor colorWithHexString:@"404040"]];
        _registeredTextField.placeholder = @"已注册的手机号码";
        _registeredTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _registeredTextField.delegate = self;
        _registeredTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_registeredTextField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    return _registeredTextField;
}
- (CPTestEnsureTextFiled *)codeTextField
{
    if ( !_codeTextField )
    {
        _codeTextField = [[CPTestEnsureTextFiled alloc] init];
        [_codeTextField setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_codeTextField setTextColor:[UIColor colorWithHexString:@"404040"]];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.delegate = self;
        _codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_codeTextField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    return _codeTextField;
}
- (UIButton *)codeButton
{
    if ( !_codeButton )
    {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        [_codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"247ec9"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_codeButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_codeButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_codeButton.layer setMasksToBounds:YES];
        [_codeButton setEnabled:NO];
        [_codeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.view endEditing:YES];
            [self.viewModel getMobileValidateSms];
            [MobClick event:@"fast_login_btn_send_message"];
        }];
    }
    return _codeButton;
}
- (UIButton *)buttonFreeLogin
{
    if ( !_buttonFreeLogin )
    {
        _buttonFreeLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonFreeLogin setTitle:@"登录" forState:UIControlStateNormal];
        [_buttonFreeLogin setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_buttonFreeLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_buttonFreeLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        [_buttonFreeLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        _buttonFreeLogin.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
        _buttonFreeLogin.layer.masksToBounds = YES;
        _buttonFreeLogin.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
        [_buttonFreeLogin setEnabled:NO];
        [_buttonFreeLogin handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.view endEditing:YES];
            [self.viewModel exemptPasswordLogin];
            [MobClick event:@"fast_login_btn_login"];
        }];
    }
    return _buttonFreeLogin;
}
- (UIButton *)registerBtn
{
    if ( !_registerBtn )
    {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE ]];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_registerBtn.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_registerBtn.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [_registerBtn.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [_registerBtn.layer setMasksToBounds:YES];
        [_registerBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            
        }];
    }
    return _registerBtn;
}
@end
