//
//  CPNFreePWViewController.m
//  cepin
//
//  Created by ceping on 16/7/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPNFreePWViewController.h"
#import "CPCommon.h"
#import "CPTestEnsureTextFiled.h"
#import "CPNFreePasswordLoginVm.h"
#import "MobClick.h"
@interface CPNFreePWViewController()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *freePWBackgroundView;
@property (nonatomic, strong) UIView *registeredPhoneView;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *buttonFreeLogin;
@property (nonatomic, strong) CPTestEnsureTextFiled *codeTextField;
@property (nonatomic, strong) CPTestEnsureTextFiled *registeredTextField;
@property (nonatomic, strong) CPNFreePasswordLoginVm *viewModel;
@end
@implementation CPNFreePWViewController
// 通过nib创建controller会调用这个方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
    {
        // 设置页面标题
        [self setTitle:@"手机号快捷登录"];
    }
    return self;
}
// 通过代码创建controller会调用这个方法
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        // 设置页面标题
        [self setTitle:@"手机号快捷登录"];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.viewModel = [[CPNFreePasswordLoginVm alloc] init];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置页面背景色
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
}
#pragma mark - UITextFieldDelegate
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
#pragma mark - private methods
- (void)setupUI
{
    [self.view addSubview:self.freePWBackgroundView];
    [self.view addSubview:self.buttonFreeLogin];
    [self.buttonFreeLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.freePWBackgroundView.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
        make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( self.codeButton );
    }];
    [[self.registeredTextField rac_textSignal]subscribeNext:^(NSString *text) {
        self.viewModel.mobile = text;
        if ( 0 < [text length] && [self.codeTextField.text length] > 0 )
        {
            [self.buttonFreeLogin setEnabled:YES];
        }
        else
        {
            [self.buttonFreeLogin setEnabled:NO];
        }
        if ( 0 < [text length] )
        {
            [self.codeButton setEnabled:YES];
        }
        else
        {
            [self.codeButton setEnabled:NO];
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
#pragma mark - getter methods
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
        CGFloat marginTop = 30 / CP_GLOBALSCALE + 64.0;
        CGFloat W = kScreenWidth;
        CGFloat H = (buttonHeight + tempHeight) * 2.0;
        _freePWBackgroundView.frame = CGRectMake(0, marginTop, W, H);
        [_freePWBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [_freePWBackgroundView addSubview:self.registeredPhoneView];
        [_freePWBackgroundView addSubview:self.codeView];
        [_freePWBackgroundView addSubview:self.codeButton];
        UIView *separatorLine1 = [[UIView alloc] init];
        [separatorLine1 setBackgroundColor:[UIColor colorFromHexCode:@"ede3e6"]];
        [_freePWBackgroundView addSubview:separatorLine1];
        UIView *separatorLine2 = [[UIView alloc] init];
        [separatorLine2 setBackgroundColor:[UIColor colorFromHexCode:@"ede3e6"]];
        [_freePWBackgroundView addSubview:separatorLine2];
        [self.registeredPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _freePWBackgroundView.mas_top );
            make.left.equalTo( _freePWBackgroundView.mas_left ).offset( 35 / CP_GLOBALSCALE );
            make.right.equalTo( _freePWBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( buttonHeight ) );
        }];
        [separatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _freePWBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _freePWBackgroundView.mas_right );
            make.top.equalTo( self.registeredPhoneView.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
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
        [separatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _freePWBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( self.codeView.mas_bottom );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.codeView.mas_right );
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
            make.left.equalTo( _registeredPhoneView.mas_left );
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
            make.left.equalTo( _codeView.mas_left );
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
@end
