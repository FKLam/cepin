//
//  ChangePasswardVC.m
//  cepin
//
//  Created by dujincai on 15/7/1.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ChangePasswardVC.h"
#import "ChangePasswordVM.h"
#import "TBAppDelegate.h"
#import "LoginVC.h"
#import "NSString+Extension.h"
#import "CPCommon.h"
#import "CPSettingModifyPasswordTextField.h"
#import "CPTipsView.h"
@interface ChangePasswardVC ()<UITextFieldDelegate,UIAlertViewDelegate, CPTipsViewDelegate>
@property (nonatomic,strong) ChangePasswordVM *viewModel;
@property (nonatomic,strong) CPSettingModifyPasswordTextField *oldPassword;
@property (nonatomic,strong) CPSettingModifyPasswordTextField *Password;
@property (nonatomic,strong) CPSettingModifyPasswordTextField *entenNewPassword;
@property (nonatomic,strong) UIButton *enterButton;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic, strong) CPTipsView *tipsView;
@end
@implementation ChangePasswardVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewModel = [ChangePasswordVM new];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    CALayer *custemLayer = [[CALayer alloc] init];
    custemLayer.frame = CGRectMake(0, 64.0 + 32 / CP_GLOBALSCALE, kScreenWidth, 144.0 / CP_GLOBALSCALE * 3 + 2 / CP_GLOBALSCALE * 2 );
    custemLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:custemLayer];
    UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, custemLayer.frame.origin.y, 60, 144.0 / CP_GLOBALSCALE)];
    accountLabel.text = @"旧 密 码";
    accountLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    accountLabel.textColor = [UIColor colorWithHexString:@"404040"];
    accountLabel.viewWidth = [NSString caculateTextSize:accountLabel].width;
    [self.view addSubview:accountLabel];
    self.oldPassword = [[CPSettingModifyPasswordTextField alloc] initWithFrame:CGRectMake(accountLabel.viewX + accountLabel.viewWidth + 40 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE, accountLabel.viewY, kScreenWidth - CGRectGetMaxX(accountLabel.frame) - 40 / CP_GLOBALSCALE - 40 / CP_GLOBALSCALE - 40 / CP_GLOBALSCALE, accountLabel.viewHeight)];
    self.oldPassword.placeholder = @"请输入旧密码";
    self.oldPassword.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.oldPassword.textColor = [UIColor colorWithHexString:@"404040"];
    self.oldPassword.delegate = self;
    [self.oldPassword setSecureTextEntry:YES];
    [self.view addSubview:self.oldPassword];
    [self.oldPassword.rac_textSignal subscribeNext:^(NSString *text) {
        self.viewModel.oldPassword = text;
        [self.enterButton setEnabled:[self.viewModel canSubmit]];
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"ede3e6"];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset( 40 / CP_GLOBALSCALE);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.oldPassword.mas_bottom).offset( -2 / CP_GLOBALSCALE );
        make.height.equalTo(@( 1 / CP_GLOBALSCALE ));
    }];
    UILabel *enterLabel = [[UILabel alloc]initWithFrame:CGRectMake(accountLabel.viewX, accountLabel.viewY + accountLabel.viewHeight, 60, accountLabel.viewHeight)];
    enterLabel.text = @"新 密 码";
    enterLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    enterLabel.textColor = [UIColor colorWithHexString:@"404040"];
    enterLabel.viewWidth = [NSString caculateTextSize:enterLabel].width;
    [self.view addSubview:enterLabel];
    self.Password = [[CPSettingModifyPasswordTextField alloc] initWithFrame:CGRectMake(self.oldPassword.viewX, enterLabel.viewY, kScreenWidth - CGRectGetMaxX(enterLabel.frame) - 40 / CP_GLOBALSCALE - 40 / CP_GLOBALSCALE - 40 / CP_GLOBALSCALE, accountLabel.viewHeight)];
    self.Password.placeholder = @"请输入新密码";
    self.Password.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.Password.textColor = [UIColor colorWithHexString:@"404040"];
    self.Password.delegate = self;
    self.Password.secureTextEntry = YES;
    [self.view addSubview:self.Password];
    [self.Password.rac_textSignal subscribeNext:^(NSString *text) {
        self.viewModel.passWord = text;
        [self.enterButton setEnabled:[self.viewModel canSubmit]];
    }];
    UIView *passView = [[UIView alloc]init];
    passView.backgroundColor = [UIColor colorWithHexString:@"ede3e6"];
    [self.view addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset( 40 / CP_GLOBALSCALE );
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.Password.mas_bottom).offset( -2 / CP_GLOBALSCALE );
        make.height.equalTo(@( 1 / CP_GLOBALSCALE ));
    }];
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake( accountLabel.viewX, enterLabel.viewY + enterLabel.viewHeight, 60, accountLabel.viewHeight)];
    passwordLabel.text = @"确认新密码";
    passwordLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    passwordLabel.textColor = [UIColor colorWithHexString:@"404040"];
    passwordLabel.viewWidth = [NSString caculateTextSize:passwordLabel].width;
    [self.view addSubview:passwordLabel];
    self.entenNewPassword = [[CPSettingModifyPasswordTextField alloc] initWithFrame:CGRectMake(passwordLabel.viewX + passwordLabel.viewWidth + 40 / CP_GLOBALSCALE, passwordLabel.viewY, kScreenWidth - CGRectGetMaxX(passwordLabel.frame) - 40 / CP_GLOBALSCALE - 20 / CP_GLOBALSCALE, accountLabel.viewHeight)];
    self.entenNewPassword.placeholder = @"请再次输入新密码";
     self.entenNewPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.entenNewPassword.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.entenNewPassword.textColor = [UIColor colorWithHexString:@"404040"];
    self.entenNewPassword.delegate = self;
    self.entenNewPassword.secureTextEntry = YES;
    [self.view addSubview:self.entenNewPassword];
    [self.entenNewPassword.rac_textSignal subscribeNext:^(NSString *text) {
        self.viewModel.entenPassword = text;
        [self.enterButton setEnabled:[self.viewModel canSubmit]];
    }];
    self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterButton.frame = CGRectMake( 40 / CP_GLOBALSCALE, CGRectGetMaxY(custemLayer.frame) + 84.0 / CP_GLOBALSCALE, self.view.viewWidth - 40 / CP_GLOBALSCALE * 2, 144 / CP_GLOBALSCALE);
    [self.enterButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    [self.enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
    self.enterButton.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
    self.enterButton.layer.masksToBounds = YES;
    [self.enterButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    [self.enterButton setEnabled:NO];
    [self.view addSubview:self.enterButton];
    [self.enterButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.textField resignFirstResponder];
        //确认密码
        [self.viewModel changePassword];
    }];
    //修改密码成功
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self shomMessageTips:@"密码修改成功，请使用新密码登录"];
        }
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetJobVC" object:nil userInfo:nil];
    [[MemoryCacheData shareInstance] disConnect];
    LoginVC *vc = [LoginVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)shomMessageTips:(NSString *)tips
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetJobVC" object:nil userInfo:nil];
    [[MemoryCacheData shareInstance] disConnect];
    LoginVC *vc = [LoginVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CPTipsView *)messageTipsViewWithTips:(NSString *)tips
{
    if ( !_tipsView )
    {
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"好"] showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
@end
