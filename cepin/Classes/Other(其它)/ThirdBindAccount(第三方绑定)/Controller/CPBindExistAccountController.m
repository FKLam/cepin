//
//  CPBindExistAccountController.m
//  cepin
//
//  Created by ceping on 16/3/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPBindExistAccountController.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPTestEnsureTextFiled.h"
#import "CPBindExistAccountVM.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"
#import "GuideStatesMv.h"
#import "CPLoginPasswordTextField.h"
#import "CPLoginLookPWButton.h"
#import "AboutVC.h"
#import "DynamicExamVC.h"
#import "MeVC.h"
#import "RecommendVC.h"
#import "DynamicExamNotHomeVC.h"
#import "CPCommon.h"
@interface CPBindExistAccountController ()<UITextFieldDelegate>
@property (nonatomic, strong) CPPositionDetailDescribeLabel *staticContentLabel;
@property (nonatomic, strong) UIView *accountView;
@property (nonatomic, strong) UIView *PWView;
@property (nonatomic, strong) UIButton *loginBindButton;
@property (nonatomic, strong) CPTestEnsureTextFiled *accountField;
@property (nonatomic, strong) CPLoginPasswordTextField *passwordField;
@property (nonatomic, strong) CPBindExistAccountVM *viewModel;
@property (nonatomic, strong) UserLoginDTO *userData;
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) UIView *bindTipsView;
@property (nonatomic, strong) NSString *comeFromString;
@property (nonatomic, strong) NSDictionary *notificationDict;
@end
@implementation CPBindExistAccountController
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.viewModel = [[CPBindExistAccountVM alloc] init];
    }
    return self;
}
- (instancetype)initWithComeFromString:(NSString *)comeFromString
{
    self = [self init];
    self.comeFromString = comeFromString;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"绑定测聘网帐号"];
    [MobClick event:@"into_bind_old_account"];
    self.viewModel.setViewController = self;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.view addSubview:self.staticContentLabel];
    [self.staticContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.view.mas_top ).offset( 64.0 + 84 / CP_GLOBALSCALE );
        make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.right.equalTo( self.view.mas_right ).offset( -20 / CP_GLOBALSCALE );
    }];
    [self.view addSubview:self.accountView];
    [self.view addSubview:self.PWView];
    [self.view addSubview:self.loginBindButton];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.staticContentLabel.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
        make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
    }];
    [self.PWView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.accountView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.accountView );
        make.height.equalTo( self.accountView );
        make.right.equalTo( self.accountView );
    }];
    [self.loginBindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.PWView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
        make.left.equalTo( self.PWView );
        make.height.equalTo( self.PWView );
        make.right.equalTo( self.PWView );
    }];
    @weakify(self)
    [self.accountField.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        self.viewModel.account = text;
        if ( 0 < [text length] && [self.passwordField.text length] > 0 )
        {
            [self.loginBindButton setEnabled:YES];
        }
        else
        {
            [self.loginBindButton setEnabled:NO];
        }
    }];
    [self.passwordField.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        self.viewModel.password = text;
        if ( 0 < [text length] && [self.accountField.text length] > 0 )
        {
            [self.loginBindButton setEnabled:YES];
        }
        else
        {
            [self.loginBindButton setEnabled:NO];
        }
    }];
    // 绑定已有帐号成功
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if ( code == HUDCodeSucess )
        {
            [self showBindTips];
        }
    }];
}
- (void)configeWithUserData:(UserLoginDTO *)userData
{
    self.userData = userData;
    self.viewModel.userData = userData;
}
- (void)showBindTips
{
    [MobClick event:@"message_bind_show"];
    [self.bindTipsView setHidden:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bindTipsView];
}
- (void)clickedLookPWBtn:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    [self.passwordField setSecureTextEntry:!sender.isSelected];
    [self.passwordField becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( textField == self.accountField && ![string isEqualToString:@""] )
    {
        NSString *numberStr = @"1234567890";
        if ( [numberStr rangeOfString:string].length == 0 )
            return NO;
        if( range.location >= 11)
            return NO;
    }
    return YES;
}
#pragma mark - getter method
- (CPPositionDetailDescribeLabel *)staticContentLabel
{
    if ( !_staticContentLabel )
    {
        _staticContentLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_staticContentLabel setVerticalAlignment:VerticalAlignmentTop];
        [_staticContentLabel setFont:[UIFont systemFontOfSize:40 / CP_GLOBALSCALE]];
        [_staticContentLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_staticContentLabel setNumberOfLines:0];
        NSString *str = @"请绑定您的测聘网帐号，绑定后，使用第三方平台名或者测聘网帐号均可以登录到你现有的帐号";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:12 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:40 / CP_GLOBALSCALE]}];
        [_staticContentLabel setAttributedText:attStr];
    }
    return _staticContentLabel;
}
- (UIButton *)loginBindButton
{
    if ( !_loginBindButton )
    {
        _loginBindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBindButton setTitle:@"登录并绑定" forState:UIControlStateNormal];
        [_loginBindButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_loginBindButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_loginBindButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_loginBindButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        _loginBindButton.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
        _loginBindButton.layer.masksToBounds = YES;
        _loginBindButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
        [_loginBindButton setEnabled:NO];
        [_loginBindButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.view endEditing:YES];
            [MobClick event:@"bind_old_btn_bind"];
            [self.viewModel bindUser];
        }];
    }
    return _loginBindButton;
}
- (CPTestEnsureTextFiled *)accountField
{
    if ( !_accountField )
    {
        _accountField = [[CPTestEnsureTextFiled alloc] init];
        [_accountField setFont:[[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont]];
        [_accountField setTextColor:[UIColor colorWithHexString:@"404040"]];
        _accountField.placeholder = @"手机号码";
        _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_accountField setKeyboardType:UIKeyboardTypeNumberPad];
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
    }
    return _passwordField;
}
- (UIView *)PWView
{
    if ( !_PWView )
    {
        _PWView = [[UIView alloc] init];
        [_PWView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_PWView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_PWView.layer setMasksToBounds:YES];
        
        UIImageView *accountImage = [[UIImageView alloc] init];
        accountImage.image = [UIImage imageNamed:@"login_ic_lock"];
        [_PWView addSubview:accountImage];
        [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _PWView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.centerY.equalTo( _PWView.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        [_PWView addSubview:self.passwordField];
        [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _PWView.mas_top );
            make.left.equalTo( accountImage.mas_right ).offset( 20 / CP_GLOBALSCALE );
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
- (UIView *)accountView
{
    if ( !_accountView )
    {
        _accountView = [[UIView alloc] init];
        [_accountView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_accountView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_accountView.layer setMasksToBounds:YES];
        
        UIImageView *accountImage = [[UIImageView alloc] init];
        accountImage.image = [UIImage imageNamed:@"login_ic_id"];
        [_accountView addSubview:accountImage];
        [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _accountView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.centerY.equalTo( _accountView.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        [_accountView addSubview:self.accountField];
        [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _accountView.mas_top );
            make.left.equalTo( accountImage.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.bottom.equalTo( _accountView.mas_bottom );
            make.right.equalTo( _accountView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return _accountView;
}
- (UIView *)existAccountTipsView
{
    if ( !_existAccountTipsView )
    {
        _existAccountTipsView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_existAccountTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
        CGFloat H = ( 84 + 60 + 84 + 48 * 3 + 24 * 3 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
        CGFloat X = 40 / CP_GLOBALSCALE;
        CGFloat Y = ( kScreenHeight - H ) / 2.0;
        UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [tipsView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [tipsView.layer setMasksToBounds:YES];
        [_existAccountTipsView addSubview:tipsView];
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
        NSString *str = @"你输入的测聘网账号已与其他QQ(微信、微博)绑定过，请更换账号或直接登录。";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
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
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.right.equalTo( tipsView.mas_right );
        }];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_existAccountTipsView setHidden:YES];
            [_existAccountTipsView removeFromSuperview];
        }];
        [_existAccountTipsView setHidden:YES];
    }
    return _existAccountTipsView;
}
- (UIView *)bindTipsView
{
    if ( !_bindTipsView )
    {
        _bindTipsView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_bindTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
        CGFloat H = ( 84 + 60 + 84 + 48 * 4 + 24 * 4 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
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
        NSString *str = @"您正在绑定账号,绑定后两个账号下的简历及收藏,投递记录将合并,默认简历、个人信息及极速职业测评报告将以绑定的测聘网账号为准";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
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
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_bindTipsView setHidden:YES];
            [_bindTipsView removeFromSuperview];
            // 发送设置默认简历的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
//            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
//            [delegate ChangeToMainTwo];
            [self markComeFrom];
        }];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
            make.right.equalTo( tipsView.mas_right );
        }];
        [_bindTipsView setHidden:YES];
    }
    return _bindTipsView;
}
- (void)markComeFrom
{
    if ( [self.comeFromString isEqualToString:@"delivery"] )
    {
        if ( 0 < [self.viewModel.allResumeArrayM count] )
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
    else if ( [self.comeFromString isEqualToString:@"collection"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        UIViewController *parentVC = childArray[1];
        [parentVC dismissViewControllerAnimated:NO completion:nil];
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
    else if ( self.comeFromString && ([self.comeFromString isEqualToString:@"MeProfile"]
                                      || [self.comeFromString isEqualToString:@"MeResume"]
                                      || [self.comeFromString isEqualToString:@"MeDelivery"]
                                      || [self.comeFromString isEqualToString:@"MePositionRecommend"]
                                      || [self.comeFromString isEqualToString:@"MeMessage"]
                                      || [self.comeFromString isEqualToString:@"MeTest"]
                                      || [self.comeFromString isEqualToString:@"MeCollection"]))
    {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        BaseNavigationViewController *root = (BaseNavigationViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        NSArray *childArray = root.childViewControllers;
        UIViewController *parentVC = childArray[0];
        MeVC *childVC = (MeVC *)parentVC.childViewControllers[3];
        [childVC.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"aboutlogin"] )
    {
        if ( 0 < [self.viewModel.allResumeArrayM count] )
        {
            TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
        }
        else
        {
            GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homelogin"] )
    {
        if ( 0 < [self.viewModel.allResumeArrayM count] )
        {
            TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate ChangeToMainTwo];
        }
        else
        {
            GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobile];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
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
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeexperience"] )
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
    else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homedynamictest"] )
    {
        NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        DynamicExamNotHomeVC *childVC = childArray[1];
        [childVC dismissViewControllerAnimated:NO completion:nil];
        [childVC performSelector:@selector(outSideOpenExam) withObject:nil];
    }
}
@end
