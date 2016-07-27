//
//  SignupVC.m
//  cepin
//
//  Created by ricky.tang on 14-10-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SignupVC.h"
#import "SignupVM.h"
#import "UIViewController+NavicationUI.h"
#import "TBAppDelegate.h"
#import "UnderLineLabel.h"
#import "CepinProtoVC.h"
#import "LoginVC.h"
#import "SignupGuideResumeVC.h"
#import "GuideStatesMv.h"
#import "NSString+Extension.h"
#import "CPCommon.h"
#import "CPSearchTextField.h"
#import "CPLoginPasswordTextField.h"
#import "CPLoginLookPWButton.h"
#import "CPPositionDetailDescribeLabel.h"
#import "LoginVC.h"
#import "DynamicExamVC.h"
#import "MeVC.h"
#import "AboutVC.h"
#import "RecommendVC.h"
#import "DynamicExamNotHomeVC.h"
@interface SignupVC ()<UITextFieldDelegate>
@property(nonatomic,strong)SignupVM *viewModel;
@property(nonatomic,strong)CPSearchTextField *accountField;
@property(nonatomic,strong)CPSearchTextField *codeField;
@property(nonatomic,strong)CPLoginPasswordTextField *enterPassword;
@property(nonatomic,strong)UIButton *enterButton;
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIButton *accountExitsBg;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,assign)Boolean isSee;
@property(nonatomic,strong)UIButton *seeBtn;
@property (nonatomic, strong) UIView *bindTipsView;
@property (nonatomic, strong) NSString *comeFromString;
@property (nonatomic, strong) NSDictionary *notificationDict;
@property (nonatomic, strong) UIView *topBlueView;
@property (nonatomic, strong) UIImageView *loginImageView;
@property (nonatomic, strong) UIView *accountBackgroundView;
@property (nonatomic, strong) UIView *registeredPhoneView;
@property (nonatomic, strong) UIView *PWView;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIButton *goLoginButton;
@property (nonatomic, strong) UIButton *touristButton;
@end
@implementation SignupVC
-(instancetype)init
{
    if (self = [super init]) {
        self.viewModel = [SignupVM new];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithComeFormString:(NSString *)comeFromString
{
    self = [self init];
    self.comeFromString = comeFromString;
    return self;
}
- (instancetype)initWithComeFormString:(NSString *)comeFromString notificationDict:(NSDictionary *)notificationDict
{
    self = [self initWithComeFormString:comeFromString];
    if ( self )
    {
        self.notificationDict = notificationDict;
    }
    return self;
}
-(void)signupClickedBackBtn:(id)sender
{
    [self.view endEditing:YES];
    if ( [self.comeFromString isEqualToString:@"homeRegister"] )
        [self dismissViewControllerAnimated:YES completion:nil];
    else
    {
        if ( 1 < [self.navigationController.childViewControllers count] )
            [self.navigationController popViewControllerAnimated:YES];
        else
            [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - lift cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"register_launch"];
    if ( !self.navigationItem.leftBarButtonItem )
    {
        if ( self.navigationItem )
            self.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(signupClickedBackBtn:)];
    }
//    self.view.backgroundColor = CPColor(0xf0, 0xef, 0xf5, 1.0);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupUI];
    @weakify(self)
    [self.accountField.rac_textSignal subscribeNext:^(NSString *text) {
    @strongify(self);
        self.viewModel.account = text;
        if ( self.viewModel.isSendMobileValid )
            return;
        if ( 0 < [text length] )
        {
            [self.codeButton setEnabled:YES];
            if ( 0 < [self.enterPassword.text length] && 0 < [self.codeField.text length] && self.viewModel.isSelectPro )
            {
                [self.enterButton setEnabled:YES];
            }
        }
        else
        {
            [self.codeButton setEnabled:NO];
            [self.enterButton setEnabled:NO];
        }
    }];
    [self.enterPassword.rac_textSignal subscribeNext:^(NSString *text) {
        self.viewModel.password = text;
        if ( 0 < [self.accountField.text length] && 0 < [self.codeField.text length] && 0 < [text length]  && self.viewModel.isSelectPro )
        {
            [self.enterButton setEnabled:YES];
        }
        else
        {
            [self.enterButton setEnabled:NO];
        }
    }];
    [self.codeField.rac_textSignal subscribeNext:^(NSString *text) {
       self.viewModel.mobialCode = text;
        if ( 0 < [self.accountField.text length] && 0 < [self.enterPassword.text length] && 0 < [text length] && self.viewModel.isSelectPro )
        {
            [self.enterButton setEnabled:YES];
        }
        else
        {
            [self.enterButton setEnabled:NO];
        }
    }];
    [self.codeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.textField resignFirstResponder];
        if (self.accountField.text.length>0) {
            //统计获取验证码
            [MobClick event:@"get_verification_code"];
            [self.viewModel getMobileValidateSms];
        }
    }];
    [self.view addSubview:self.enterButton];
    [self.enterButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        if (self.accountField.text.length>0 && self.codeField.text.length>0 && self.enterPassword.text.length>0) {
            //统计注册
            [MobClick event:@"regist_to_sure"];
            //注册
            [self.viewModel registerUser];
        }
    }];
    //获取验证码成功
    [RACObserve(self.viewModel, mobialStateCode) subscribeNext:^(id stateCode) {
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self startTime];
        }
        else if( code == HUDCodeNone )
        {
            [self showBindTips];
        }
    }];
    //注册成功
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self markComeFrom];
        }
    }];
}
#pragma mark - 初始化页面
- (void)setupUI
{
    // 顶部蓝色部分
    [self.view addSubview:self.topBlueView];
    // 输入框部分
    [self.view addSubview:self.accountBackgroundView];
    // 协议 & 注册按钮 & 去登录按钮
    [self setProtocolUI];
    // 随便逛逛按钮
    [self setupTouristButtonUI];
}
#pragma mark - 设置协议UI & 注册按钮 & 去登录按钮
- (void)setProtocolUI
{
    // 协议
    UIButton *markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [markButton setBackgroundImage:[UIImage imageNamed:@"ic_checked"] forState:UIControlStateNormal];
    [self.view addSubview: markButton];
    [markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset( 40 / CP_GLOBALSCALE );
        make.width.equalTo( @(25) );
        make.height.equalTo( @(25) );
        make.top.equalTo( self.accountBackgroundView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
    }];
    @weakify(self)
    [markButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        @strongify(self)
        self.viewModel.isSelectPro = !self.viewModel.isSelectPro;
        if ( self.viewModel.isSelectPro )
        {
            if ( 0 < [self.accountField.text length] && 0 < [self.codeField.text length] && 0 < [self.enterPassword.text length] )
            {
                [self.enterButton setEnabled:YES];
            }
            [markButton setBackgroundImage:[UIImage imageNamed:@"ic_checked"] forState:UIControlStateNormal];
        }
        else
        {
            [markButton setBackgroundImage:[UIImage imageNamed:@"ic_uncheck"] forState:UIControlStateNormal];
            [self.enterButton setEnabled:NO];
        }
    }];
    UILabel *yueduLable = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:yueduLable];
    yueduLable.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
    yueduLable.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    yueduLable.text = @"我已阅读并同意";
    [yueduLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo( markButton );
        make.left.equalTo( markButton.mas_right ).offset(5);
    }];
    UnderLineLabel *underLineLable = [[UnderLineLabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:underLineLable];
    [underLineLable setBackgroundColor:[UIColor clearColor]];
    [underLineLable setTextColor:[UIColor colorWithHexString:@"288add"]];
    underLineLable.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    underLineLable.shouldUnderline = NO;
    underLineLable.text = @"测聘网用户协议";
    [underLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( yueduLable.mas_right );
        make.centerY.equalTo( yueduLable.mas_centerY );
    }];
    underLineLable.userInteractionEnabled = NO;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( underLineLable.mas_left );
        make.top.equalTo( underLineLable.mas_top );
        make.width.equalTo( underLineLable );
        make.height.equalTo( underLineLable );
    }];
    btn.backgroundColor = [UIColor clearColor];
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        @strongify(self)
        CepinProtoVC *vc = [CepinProtoVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    // 注册按钮
    [self.view addSubview:self.enterButton];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( underLineLable.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
        make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
    }];
    // 去登录按钮
    [self.view addSubview:self.goLoginButton];
    [self.goLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.enterButton.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.enterButton );
        make.right.equalTo( self.enterButton );
        make.height.equalTo( self.enterButton );
    }];
}
#pragma mark - 随便逛逛按钮
- (void)setupTouristButtonUI
{
    [self.view addSubview:self.touristButton];
    [self.touristButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo( self.view );
        make.bottom.equalTo( self.view );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
    }];
}
#pragma mark - 记录页面来源
- (void)markComeFrom
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_LONGIN object:nil userInfo:@{ CP_ACCOUNT_LONGIN_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
    if ( [self.comeFromString isEqualToString:@"delivery"] )
    {
        if ( 0 < [[MemoryCacheData shareInstance].userLoginData.ResumeCount intValue] )
        {
            
        }
        else
        {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.account comeFromString:self.comeFromString];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            BaseNavigationViewController *root = (BaseNavigationViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            NSArray *childArray = root.childViewControllers;
            UIViewController *childVC = [childArray objectAtIndex:1];
            [childVC presentViewController:nav animated:NO completion:nil];
        }
    }
    else if ( [self.comeFromString isEqualToString:@"collection"] )
    {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        BaseNavigationViewController *root = (BaseNavigationViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        NSArray *childArray = root.childViewControllers;
        UIViewController *childVC = [childArray objectAtIndex:1];
        [root popToViewController:childVC animated:NO];
        UIViewController *presentVC = childVC.presentedViewController;
        [presentVC dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( [self.comeFromString isEqualToString:@"testList"] )
    {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        BaseNavigationViewController *root = (BaseNavigationViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        NSArray *childArray = root.childViewControllers;
        UIViewController *parentVC = childArray[0];
        DynamicExamVC *childVC = parentVC.childViewControllers[1];
        [childVC.navigationController dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(outSideOpenExam) withObject:nil];
    }
    else if ( [self.comeFromString isEqualToString:@"homeRegister"] || !self.comeFromString || 0 == [self.comeFromString length] )
    {
        GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.account];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        if ( self.navigationController )
        {
            [self.navigationController presentViewController:nav animated:NO completion:nil];
        }
        else
        {
            [self presentViewController:nav animated:NO completion:nil];
        }
    }
    else if ( self.comeFromString && ([self.comeFromString isEqualToString:@"MeProfile"]
                                      || [self.comeFromString isEqualToString:@"MeResume"]
                                      || [self.comeFromString isEqualToString:@"MeDelivery"]
                                      || [self.comeFromString isEqualToString:@"MePositionRecommend"]
                                      || [self.comeFromString isEqualToString:@"MeMessage"]
                                      || [self.comeFromString isEqualToString:@"MeTest"]
                                      || [self.comeFromString isEqualToString:@"MeCollection"]))
    {
        GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"aboutmodifypw"] )
    {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        BaseNavigationViewController *root = (BaseNavigationViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        NSArray *childArray = root.childViewControllers;
        UIViewController *childVC = [childArray objectAtIndex:1];
        AboutVC *aboutVC = (AboutVC *)childVC;
        [aboutVC performSelector:@selector(configToOpen) withObject:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"aboutlogin"] )
    {
        GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeResume"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        RecommendVC *childVC = parentVC.childViewControllers[0];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(comeFromeWithString:) withObject:self.comeFromString];
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
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"notificationshomeTestList"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        RecommendVC *childVC = parentVC.childViewControllers[0];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(comeFromeWithString:notificationDict:) withObject:self.comeFromString withObject:self.notificationDict];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeADGuide"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[0];
        RecommendVC *childVC = parentVC.childViewControllers[0];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(comeFromeWithString:) withObject:self.comeFromString];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeexperience"] )
    {
        GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homedynamictest"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        DynamicExamNotHomeVC *childVC = childArray[1];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(outSideOpenExam) withObject:nil];
    }
    else if ( !self.comeFromString )
    {
        GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:NO completion:nil];
    }
    else
    {
        GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:NO completion:nil];
    }
}
- (void)clickedLookPWBtn:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    [self.enterPassword setSecureTextEntry:!sender.isSelected];
    [self.enterPassword becomeFirstResponder];
}
-(void)ShowAccountExist
{
    if (self.accountExitsBg)
    {
        self.accountExitsBg.hidden = NO;
        self.bgView.hidden = NO;
    }
    else
    {
        self.accountExitsBg = [[UIButton alloc]initWithFrame:self.view.bounds];
        self.accountExitsBg.backgroundColor = [UIColor blackColor];
        self.accountExitsBg.alpha = 0.75;
        [self.view addSubview: self.accountExitsBg];
        //背景
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(20, self.view.viewCenterY - 100, self.view.viewWidth - 40, 138)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bgView];
        
        @weakify(self)
        [ self.accountExitsBg handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            self.bgView.hidden = YES;
            self.accountExitsBg.hidden = YES;
        }];
        UILabel *titleLabel =  [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.font = [[RTAPPUIHelper shareInstance] jobInformationDeliverButtonFont];
        titleLabel.text = @"提示";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.bgView.mas_top).offset(10);
            make.height.equalTo(@(45));
            make.width.equalTo(@([NSString caculateTextSize:titleLabel].width));
        }];
        UILabel *accountExistLabel =  [[UILabel alloc]initWithFrame:CGRectZero];
        accountExistLabel.font = [[RTAPPUIHelper shareInstance] profileNameFont];
        accountExistLabel.text = @"账号已存在，请重新输入!";
        accountExistLabel.textAlignment = NSTextAlignmentCenter;
        accountExistLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.bgView addSubview:accountExistLabel];
        [accountExistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.equalTo(@(30));
            make.width.equalTo(@([NSString caculateTextSize:accountExistLabel].width + 10));
        }];
        UIView *endlineView = [[UIView alloc]initWithFrame:CGRectZero];
        endlineView.backgroundColor =[[RTAPPUIHelper shareInstance]lineColor];
        [self.bgView addSubview:endlineView];
        [endlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left);
            make.height.equalTo(@(1));
            make.width.equalTo(self.bgView.mas_width);
            make.top.equalTo(accountExistLabel.mas_bottom).offset(10);
        }];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectZero;
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[[RTAPPUIHelper shareInstance]subTitleColor] forState:UIControlStateNormal];
        [self.bgView addSubview:cancelBtn];
        [cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.accountExitsBg.hidden = YES;
            self.bgView.hidden = YES;
        }];
        UIView *centerlineView = [[UIView alloc]initWithFrame:CGRectZero];
        centerlineView.backgroundColor =[[RTAPPUIHelper shareInstance]lineColor];
        [self.bgView addSubview:centerlineView];
        [centerlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView.mas_centerX);
            make.height.equalTo(@(40));
            make.width.equalTo(@(1));
            make.top.equalTo(endlineView.mas_bottom);
        }];
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectZero;
        [loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[[RTAPPUIHelper shareInstance]labelColorGreen] forState:UIControlStateNormal];
        [loginBtn setTitleColor:[[RTAPPUIHelper shareInstance]labelColorGreen] forState:UIControlStateSelected];
        [self.bgView addSubview:loginBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(20);
            make.width.equalTo(@(100));
            make.bottom.equalTo(centerlineView.mas_bottom);
            make.height.equalTo(centerlineView.mas_height);
        }];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-20);
            make.width.equalTo(@(100));
            make.bottom.equalTo(centerlineView.mas_bottom);
            make.height.equalTo(centerlineView.mas_height);
        }];
        [loginBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.accountExitsBg.hidden = YES;
            self.bgView.hidden = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}
- (void)showBindTips
{
    [self.bindTipsView setHidden:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bindTipsView];
}
- (UIView *)bindTipsView
{
    if ( !_bindTipsView )
    {
        _bindTipsView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_bindTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
        CGFloat H = ( 84 + 60 + 84 + 48 * 1 + 24 * 1 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
        CGFloat X = 40 / CP_GLOBALSCALE;
        CGFloat Y = ( kScreenHeight - H ) / 2.0;
        UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [tipsView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [tipsView.layer setMasksToBounds:YES];
        [_bindTipsView addSubview:tipsView];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:60 / CP_GLOBALSCALE]];
        [titleLabel setText:@"提示"];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [tipsView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( tipsView.mas_top ).offset( 84 / CP_GLOBALSCALE );
            make.left.equalTo( tipsView.mas_left );
            make.right.equalTo( tipsView.mas_right );
            make.height.equalTo( @( 60 / CP_GLOBALSCALE ) );
        }];
        CPPositionDetailDescribeLabel *contentLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [contentLabel setVerticalAlignment:VerticalAlignmentTop];
        [contentLabel setNumberOfLines:0];
        NSString *str = @"账号已存在，请重新输入!";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
        [contentLabel setAttributedText:attStr];
        [tipsView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( titleLabel.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
            make.left.equalTo( tipsView.mas_left ).offset( 74 / CP_GLOBALSCALE );
            make.right.equalTo( tipsView.mas_right ).offset( -64 / CP_GLOBALSCALE );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE) );
            make.left.equalTo( tipsView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( tipsView.mas_right );
        }];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:cancelButton];
        [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_bindTipsView setHidden:YES];
            [_bindTipsView removeFromSuperview];
        }];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:@"去登录" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_bindTipsView setHidden:YES];
            [_bindTipsView removeFromSuperview];
            LoginVC *vc = [[LoginVC alloc] initWithComeFromString:self.comeFromString];
            if ( self.navigationController )
                [self.navigationController pushViewController:vc animated:YES];
            else
            {
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }];
        UIView *verSeparatorLine = [[UIView alloc] init];
        [verSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:verSeparatorLine];
        CGFloat buttonW = ( W - 2 / CP_GLOBALSCALE ) / 2.0;
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( buttonW ) );
        }];
        [verSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( cancelButton.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.width.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( tipsView.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
            make.width.equalTo( @(buttonW) );
        }];
        [_bindTipsView setHidden:YES];
    }
    return _bindTipsView;
}

//倒计时
- (void)startTime
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
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
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@秒后重新获取", strTime] forState:UIControlStateNormal];
                [self.codeButton setEnabled:NO];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
-(void)labelClicked
{
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    self.viewModel.isKeyBoardShow = YES;
    if (IS_IPHONE_5) {
        return YES;
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.view.frame = CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight);
    });
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.viewModel.isKeyBoardShow = NO;
    [textField resignFirstResponder];
    self.view.frame = CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight);

    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField==self.enterPassword) {
        self.seeBtn.hidden = YES;
    }
    if (textField == self.accountField) {
        self.codeButton.backgroundColor =  [UIColor colorWithHexString:@"288add"];
    }

    [self.enterButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    return  YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
#pragma mark - 限制手机号码输入的位数
    if ( textField == self.accountField && ![string isEqualToString:@""] )
    {
#pragma mark - 限制只能输入数字
        NSString *numberStr = @"1234567890";
        if ( [numberStr rangeOfString:string].length == 0 )
            return NO;
        if( range.location >= 11)
            return NO;
    }
    if ([string isEqualToString:@""] && textField != self.accountField ) {
        [self.enterButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        if (textField==self.enterPassword && self.enterPassword.text.length==1) {
            self.seeBtn.hidden = YES;
        }
        return YES;
    }
    else
    {
        if (textField==self.enterPassword) {
            self.seeBtn.hidden = NO;
        }
        if (textField==self.accountField && self.enterPassword.text.length>0 && self.codeField.text.length>0) {
            [self.enterButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        }else if(textField==self.enterPassword && self.codeField.text.length>0 && self.accountField.text.length>0){
            [self.enterButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        }else if(textField==self.codeField && self.enterPassword.text.length>0 && self.accountField.text.length>0){
            [self.enterButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        }
    }
    return YES;
}
-(UITextField *)creatTextfieldWithPlaceholderString:(NSString *)placeholderString nameString:(NSString *)nameString
{
    UIView *view = [self setContextWithString:nameString];
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = placeholderString;
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.borderStyle = UITextBorderStyleBezel;
    textField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textField];
    return textField;
}
-(UIView *)setContextWithString:(NSString *)string
{
    UILabel *accountLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    accountLab.text = string;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [view addSubview:accountLab];
    [self.view addSubview:view];
    return view;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.view.window == nil && [self isViewLoaded])
    {
        self.viewModel = nil;
    }
}
#pragma mark - 添加触摸空白处隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
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
- (UIView *)accountBackgroundView
{
    if ( !_accountBackgroundView )
    {
        _accountBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, CGRectGetMaxY(self.topBlueView.frame) - 144.0 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE * 2.0, 144.0 / CP_GLOBALSCALE * 3 + 20 / CP_GLOBALSCALE * 2 )];
        [_accountBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_accountBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_accountBackgroundView.layer setShadowColor:[UIColor colorWithHexString:@"000000"].CGColor];
        [_accountBackgroundView.layer setShadowOffset:CGSizeMake(0 / CP_GLOBALSCALE, 9 / CP_GLOBALSCALE)];
        [_accountBackgroundView.layer setShadowRadius:4 / CP_GLOBALSCALE];
        [_accountBackgroundView.layer setShadowOpacity:0.1];
        [_accountBackgroundView addSubview:self.registeredPhoneView];
        CGFloat tempHeight = 40 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            tempHeight = 24 / CP_GLOBALSCALE;
        CGFloat buttonHeight = 144 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            buttonHeight = 100 / ( 3.0 * ( 1 / 1.29 ) );
        [self.registeredPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _accountBackgroundView.mas_top ).offset( 0 );
            make.left.equalTo( _accountBackgroundView.mas_left );
            make.right.equalTo( _accountBackgroundView.mas_right );
            make.height.equalTo( @( buttonHeight ) );
        }];
        UIView *separatorLine1 = [[UIView alloc] init];
        [separatorLine1 setBackgroundColor:[UIColor colorFromHexCode:@"ede3e6"]];
        [_accountBackgroundView addSubview:separatorLine1];
        [separatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _accountBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _accountBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.top.equalTo( self.registeredPhoneView.mas_bottom );
        }];
        [_accountBackgroundView addSubview:self.PWView];
        [self.PWView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine1.mas_bottom );
            make.left.equalTo( _accountBackgroundView.mas_left );
            make.right.equalTo( _accountBackgroundView.mas_right );
            make.height.equalTo( @( buttonHeight ) );
        }];
        UIView *separatorLine2 = [[UIView alloc] init];
        [separatorLine2 setBackgroundColor:[UIColor colorFromHexCode:@"ede3e6"]];
        [_accountBackgroundView addSubview:separatorLine2];
        [separatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _accountBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _accountBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.top.equalTo( self.PWView.mas_bottom );
        }];
        [_accountBackgroundView addSubview:self.codeView];
        [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine2.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.left.equalTo( _accountBackgroundView.mas_left );
            make.right.equalTo( _accountBackgroundView.mas_right );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
    }
    return _accountBackgroundView;
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
        [_registeredPhoneView addSubview:self.accountField];
        [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _registeredPhoneView.mas_top );
            make.left.equalTo( lineView.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.bottom.equalTo( _registeredPhoneView.mas_bottom );
            make.right.equalTo( _registeredPhoneView.mas_right ).offset( -20 / CP_GLOBALSCALE );
        }];
    }
    return _registeredPhoneView;
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
        [_PWView addSubview:self.enterPassword];
        [self.enterPassword mas_makeConstraints:^(MASConstraintMaker *make) {
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
            make.left.equalTo( self.enterPassword.mas_right );
        }];
    }
    return _PWView;
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
        [_codeView addSubview:self.codeButton];
        [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _codeView.mas_top );
            make.height.equalTo( @( 144.0 / CP_GLOBALSCALE ) );
            make.right.equalTo( _codeView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 350 / CP_GLOBALSCALE ) );
        }];
        [_codeView addSubview:self.codeField];
        [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _codeView.mas_top );
            make.left.equalTo( lineView.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.bottom.equalTo( _codeView.mas_bottom );
            make.right.equalTo( self.codeButton.mas_left ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return _codeView;
}
- (CPSearchTextField *)accountField
{
    if ( !_accountField )
    {
        _accountField = [[CPSearchTextField alloc] init];
        _accountField.placeholder = @"仅支持大陆手机号码";
        _accountField.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
        _accountField.textColor = [UIColor colorWithHexString:@"404040"];
        _accountField.delegate = self;
        _accountField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _accountField;
}
- (CPLoginPasswordTextField *)enterPassword
{
    if ( !_enterPassword )
    {
        _enterPassword = [[CPLoginPasswordTextField alloc] init];
        _enterPassword.placeholder = @"6-16位数字、字母区分大小写";
        _enterPassword.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
        _enterPassword.textColor = [UIColor colorWithHexString:@"404040"];
        _enterPassword.delegate = self;
        _enterPassword.secureTextEntry = YES;
    }
    return _enterPassword;
}
- (CPSearchTextField *)codeField
{
    if ( !_codeField )
    {
        _codeField = [[CPSearchTextField alloc] init];
        _codeField.placeholder = @"请输入验证码";
        _codeField.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
        _codeField.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        _codeField.delegate = self;
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeField;
}
- (UIButton *)codeButton
{
    if ( !_codeButton )
    {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"247ec9"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        _codeButton.titleLabel.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeButton.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
        _codeButton.layer.masksToBounds = YES;
        [_codeButton setEnabled:NO];
    }
    return _codeButton;
}
- (UIButton *)enterButton
{
    if ( !_enterButton )
    {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"注册" forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        [_enterButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _enterButton.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
        _enterButton.layer.masksToBounds = YES;
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
        [_enterButton setEnabled:NO];
    }
    return _enterButton;
}
- (UIButton *)goLoginButton
{
    if ( !_goLoginButton )
    {
        _goLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goLoginButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE ]];
        [_goLoginButton setTitle:@"去登录" forState:UIControlStateNormal];
        [_goLoginButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_goLoginButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_goLoginButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [_goLoginButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [_goLoginButton.layer setMasksToBounds:YES];
        [_goLoginButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            LoginVC *vc = [[LoginVC alloc] initWithComeFromString:self.comeFromString];
            if ( self.navigationController )
            {
                NSUInteger count = [self.navigationController.childViewControllers count];
                if ( 1 < count )
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            else
            {
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }];
    }
    return _goLoginButton;
}
- (UIButton *)touristButton
{
    if ( !_touristButton )
    {
        // 随便逛逛按钮
        _touristButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touristButton.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        [_touristButton setTitle:@"随便逛逛 >" forState:UIControlStateNormal];
        _touristButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_touristButton setTitleColor:[UIColor colorWithHexString:@"6cbb56"] forState:UIControlStateNormal];
        [_touristButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"isFirstLaunch"];
            //统计随便逛逛
            [MobClick event:@"btn_guangguang"];
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
        }];
    }
    return _touristButton;
}
@end
