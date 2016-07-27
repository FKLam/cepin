//
//  PhoneGetPasswordVC.m
//  cepin
//
//  Created by dujincai on 15/5/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "PhoneGetPasswordVC.h"
#import "PhoneGetPasswordVM.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"
#import "CPForgetPWTextField.h"
#import "NSString+Extension.h"
#import "CPSearchTextField.h"
#import "CPLoginLookPWButton.h"
#import "CPTipsView.h"
@interface PhoneGetPasswordVC ()<UITextFieldDelegate,UIAlertViewDelegate, CPTipsViewDelegate>
@property (nonatomic, strong) PhoneGetPasswordVM *viewModel;
@property (nonatomic, strong) CPForgetPWTextField *codeTextField;
@property (nonatomic, strong) CPForgetPWTextField *enterPassword;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) Boolean isSee;
@property (nonatomic, strong) UIButton *seeBtn;
@property (nonatomic, strong) UIView *topBackgroudView;
@property (nonatomic, strong) UIButton *buttonFreeLogin;
@property (nonatomic, strong) CPTipsView *tipsView;
@end
@implementation PhoneGetPasswordVC
- (instancetype)initWithAccount:(NSString *)account
{
    self = [super init];
    if (self) {
        self.viewModel = [[PhoneGetPasswordVM alloc] initWithAccount:account];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
-(void)clickedBackBtn:(id)sender
{
    [ self dismissViewControllerAnimated: YES completion: nil ];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"找回密码";
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(clickedBackBtn:)];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [self.view addSubview:self.topBackgroudView];
    [self.buttonFreeLogin setFrame:CGRectMake(40 / CP_GLOBALSCALE, CGRectGetMaxY(self.topBackgroudView.frame) + 84 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE * 2, 144 / CP_GLOBALSCALE)];
    [self.view addSubview:self.buttonFreeLogin];
    [self.codeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.viewModel getMobileSms];
    }];
    [self.buttonFreeLogin handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        if (![self.textField isExclusiveTouch]) {
            [self.textField resignFirstResponder];
        }
        //确认密码
        [self.viewModel saveNewPassword];
    }];
    //找回密码成功
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self shomMessageTips:@"密码已经修改，请用新密码重新登录"];
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
    }];
    [self startTime];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(login) withObject:nil afterDelay:0.5];
}
-(void)login{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"resetJobVC" object:nil userInfo:nil];
    [[MemoryCacheData shareInstance]disConnect];
    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate ChangeToMainOne];
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
            });
        }else{
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
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.enterButton setTitleColor:[UIColor colorWithHexString:@"e2782e"] forState:UIControlStateNormal];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (CGSize)caculateTextSize:(UIView *)control
{
    if ( ![control isKindOfClass:[UILabel class]] )
        return CGSizeZero;
    
    UILabel *label = (UILabel *)control;
    
    CGSize controlSize = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : label.font } context:nil].size;
    return controlSize;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)clickedLookPWBtn:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    [self.enterPassword setSecureTextEntry:!sender.isSelected];
    [self.enterPassword becomeFirstResponder];
}
- (UIView *)topBackgroudView
{
    if ( !_topBackgroudView )
    {
        _topBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 30 / CP_GLOBALSCALE, kScreenWidth, ( 184 * 2 + 144 ) / CP_GLOBALSCALE)];
        [_topBackgroudView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        UILabel *account = [[UILabel alloc]initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, 40 / CP_GLOBALSCALE, 100.0, 144 / CP_GLOBALSCALE)];
        account.text = @"验 证 码";
        account.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        account.textColor = [UIColor colorWithHexString:@"404040"];
        account.viewWidth = [NSString caculateTextSize:account].width;
        account.textAlignment = NSTextAlignmentLeft;
        [_topBackgroudView addSubview:account];
        [self.codeTextField setFrame:CGRectMake(CGRectGetMaxX(account.frame) + 40 / CP_GLOBALSCALE, account.viewY, ( 510 - 40 ) /CP_GLOBALSCALE - (CGRectGetMaxX(account.frame) - 40 / CP_GLOBALSCALE), 144 / CP_GLOBALSCALE)];
        [self.codeTextField.rac_textSignal subscribeNext:^(NSString *text) {
            self.viewModel.validateCode = text;
            if ([text isEqualToString:@""] || [self.viewModel.password length] == 0 ) {
                [self.buttonFreeLogin setEnabled:NO];
            }
            else
                [self.buttonFreeLogin setEnabled:YES];
        }];
        [_topBackgroudView addSubview:self.codeTextField];
        [_topBackgroudView addSubview:self.codeButton];
        [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.codeTextField.mas_top );
            make.left.equalTo( self.codeTextField.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _topBackgroudView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ));
        }];
        UIView *separatorLineFirst = [[UIView alloc] init];
        [separatorLineFirst setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topBackgroudView addSubview:separatorLineFirst];
        [separatorLineFirst mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _topBackgroudView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( account.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.codeButton.mas_left ).offset( -40 / CP_GLOBALSCALE );
        }];
        UILabel *enterLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, CGRectGetMaxY(account.frame) + 40 / CP_GLOBALSCALE, 100, 144 / CP_GLOBALSCALE)];
        enterLabel.text = @"新 密 码";
        enterLabel.textAlignment = NSTextAlignmentLeft;
        enterLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        enterLabel.textColor = [UIColor colorWithHexString:@"404040"];
        enterLabel.viewWidth = [NSString caculateTextSize:enterLabel].width;
        [_topBackgroudView addSubview:enterLabel];
        self.enterPassword = [[CPForgetPWTextField alloc] initWithFrame:CGRectMake(self.codeTextField.viewX, enterLabel.viewY, kScreenWidth - self.codeTextField.viewX - 20 / CP_GLOBALSCALE - 70 / CP_GLOBALSCALE, 144 / CP_GLOBALSCALE)];
        self.enterPassword.placeholder = @"6-16位数字、字母区分大小写";
        self.enterPassword.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
        self.enterPassword.textColor = [UIColor colorWithHexString:@"404040"];
        self.enterPassword.delegate = self;
        self.enterPassword.secureTextEntry = YES;
        [_topBackgroudView addSubview:self.enterPassword];
        [self.enterPassword.rac_textSignal subscribeNext:^(NSString *text) {
            self.viewModel.password = text;
            if ([text isEqualToString:@""] || [self.viewModel.validateCode length] == 0 ) {
                [self.buttonFreeLogin setEnabled:NO];
            }
            else
                [self.buttonFreeLogin setEnabled:YES];
        }];
        CGFloat lookPWW = kScreenWidth - CGRectGetMaxX(self.enterPassword.frame);
        UIButton *lookPWBtn = [CPLoginLookPWButton buttonWithType:UIButtonTypeCustom];
        [lookPWBtn setFrame:CGRectMake(CGRectGetMaxX(self.enterPassword.frame) - 20 / CP_GLOBALSCALE, enterLabel.viewY, lookPWW, 144 / CP_GLOBALSCALE)];
        [lookPWBtn setBackgroundImage:[UIImage imageNamed:@"login_ic_eye"] forState:UIControlStateNormal];
        [lookPWBtn setBackgroundImage:[UIImage imageNamed:@"login_ic_eye_selected"] forState:UIControlStateSelected];
        [lookPWBtn addTarget:self action:@selector(clickedLookPWBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_topBackgroudView addSubview:lookPWBtn];
        UIView *separatorLineSecond = [[UIView alloc] init];
        [separatorLineSecond setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topBackgroudView addSubview:separatorLineSecond];
        [separatorLineSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _topBackgroudView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( enterLabel.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( _topBackgroudView.mas_right );
        }];
        UILabel *tipsLabel = [[UILabel alloc] init];
        [tipsLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        [tipsLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [tipsLabel setText:@"密码必须为6-16位数字或字母，区分大小写"];
        [tipsLabel setTextAlignment:NSTextAlignmentCenter];
        [_topBackgroudView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _topBackgroudView.mas_left );
            make.bottom.equalTo( _topBackgroudView.mas_bottom );
            make.right.equalTo( _topBackgroudView.mas_right );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
    }
    return _topBackgroudView;
}
- (CPForgetPWTextField *)codeTextField
{
    if ( !_codeTextField )
    {
        _codeTextField = [[CPForgetPWTextField alloc] init];
        [_codeTextField setFont:[[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont]];
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
        [_codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"247ec9"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_codeButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_codeButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_codeButton.layer setMasksToBounds:YES];
        [_codeButton setEnabled:NO];
        [_codeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.view endEditing:YES];
        }];
    }
    return _codeButton;
}- (UIButton *)buttonFreeLogin
{
    if ( !_buttonFreeLogin )
    {
        _buttonFreeLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonFreeLogin setTitle:@"确认" forState:UIControlStateNormal];
        [_buttonFreeLogin setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_buttonFreeLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_buttonFreeLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_buttonFreeLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        _buttonFreeLogin.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
        _buttonFreeLogin.layer.masksToBounds = YES;
        _buttonFreeLogin.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
        [_buttonFreeLogin setEnabled:NO];
        [_buttonFreeLogin handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.view endEditing:YES];
        }];
    }
    return _buttonFreeLogin;
}
- (void)shomMessageTips:(NSString *)tips
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
    [self performSelector:@selector(login) withObject:nil afterDelay:0.5];
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton
{
    self.tipsView = nil;
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
