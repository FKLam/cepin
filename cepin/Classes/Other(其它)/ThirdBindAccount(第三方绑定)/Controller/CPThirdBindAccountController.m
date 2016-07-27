//
//  CPThirdBindAccountController.m
//  cepin
//
//  Created by ceping on 16/3/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPThirdBindAccountController.h"
#import "CPThirdBindAccountVM.h"
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
#import "CPPositionDetailDescribeLabel.h"
#import "CPBindExistAccountController.h"
#import "CPLoginPasswordTextField.h"
#import "CPLoginLookPWButton.h"
#import "MeVC.h"
#import "AboutVC.h"
#import "DynamicExamVC.h"
#import "RTNetworking+User.h"
#import "RecommendVC.h"
#import "DynamicExamNotHomeVC.h"
@interface CPThirdBindAccountController ()<UITextFieldDelegate>
@property (nonatomic, strong) CPThirdBindAccountVM *viewModel;
@property (nonatomic, strong) CPSearchTextField *accountField;
@property (nonatomic, strong) CPSearchTextField *codeField;
@property (nonatomic, strong) CPLoginPasswordTextField *enterPassword;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *accountExitsBg;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) Boolean isSee;
@property (nonatomic, strong) UIButton *seeBtn;
@property (nonatomic, strong) UIButton *haveAccountButton;
@property (nonatomic, strong) UserLoginDTO *userData;
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) UIView *bindTipsView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) NSString *comeFromString;
@property (nonatomic, strong) NSDictionary *notificationDict;
@end
@implementation CPThirdBindAccountController
-(instancetype)init
{
    if (self = [super init]) {
        self.viewModel = [[CPThirdBindAccountVM alloc] init];
        self.viewModel.showMessageVC = self;
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
-(void)bindAccountClickedBackBtn:(id)sender
{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetJobVC" object:nil userInfo:nil];
    [[MemoryCacheData shareInstance] disConnect];
    [self clearApptoken];//清空token信息
    if ( !self.comeFromString || 0 == [self.comeFromString length] )
    {
        TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate ChangeToMainTwo];
        // 发送设置默认简历的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"绑定测聘网帐号";
    [MobClick event:@"into_bind_new_account"];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = CPColor(0xf0, 0xef, 0xf5, 1.0);
    CALayer *custemLayer = [[CALayer alloc] init];
    CGRect custemRect = CGRectMake(0, 32 / CP_GLOBALSCALE + 44 + 20, kScreenWidth, ( 144 * 4 + 40 * 2 ) / CP_GLOBALSCALE );
    custemLayer.frame = custemRect;
    custemLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:custemLayer];
    int hight = 144.0 / CP_GLOBALSCALE;
    int width = IS_IPHONE_5?45:65;
    UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, 32 / CP_GLOBALSCALE + 44.0 + 20, width, hight)];
    accountLabel.text = @"手     机";
    accountLabel.textAlignment = NSTextAlignmentLeft;
    accountLabel.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    accountLabel.textColor = [UIColor colorWithHexString:@"404040"];
    accountLabel.viewWidth = [NSString caculateTextSize:accountLabel].width;
    [self.view addSubview:accountLabel];
    self.accountField = [[CPSearchTextField alloc] init];
    self.accountField.placeholder = @"仅支持大陆手机号码";
    self.accountField.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    self.accountField.textColor = [UIColor colorWithHexString:@"404040"];
    self.accountField.delegate = self;
    self.accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountField.delegate = self;
    [self.view addSubview:self.accountField];
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( accountLabel.mas_top );
        make.left.equalTo( accountLabel.mas_right ).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( @( hight ) );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
    }];
    @weakify(self)
    [self.accountField.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        self.viewModel.account = text;
        if ( !self.viewModel.isSendMobileValid )
        {
            if ( text.length > 0 ) {
                [self.codeButton setEnabled:YES];
            }
            else
            {
                [self.codeButton setEnabled:NO];
            }
        }
        if ( 0 < [text length] && 0 < [self.enterPassword.text length] && 0 < [self.codeField.text length] )
        {
            [self.enterButton setEnabled:YES];
        }
        else
        {
            [self.enterButton setEnabled:NO];
        }
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLabel.mas_left);
        make.right.equalTo(self.view.mas_right).offset( -40 / CP_GLOBALSCALE );
        make.bottom.equalTo(self.accountField.mas_bottom).offset(-1);
        make.height.equalTo(@(1));
    }];
    UILabel *enterLabel = [[UILabel alloc]initWithFrame:CGRectMake( accountLabel.viewX, accountLabel.viewY + accountLabel.viewHeight + 40 / CP_GLOBALSCALE, width, hight)];
    enterLabel.text = @"密     码";
    enterLabel.textAlignment = NSTextAlignmentLeft;
    enterLabel.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    enterLabel.textColor = [UIColor colorWithHexString:@"404040"];
    enterLabel.viewWidth = [NSString caculateTextSize:enterLabel].width;
    [self.view addSubview:enterLabel];
    self.enterPassword = [[CPLoginPasswordTextField alloc] init];
    self.enterPassword.placeholder = @"6-16位数字、字母区分大小写";
    self.enterPassword.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    self.enterPassword.textColor = [UIColor colorWithHexString:@"404040"];
    self.enterPassword.delegate = self;
    self.enterPassword.secureTextEntry = YES;
    [self.view addSubview:self.enterPassword];
    [self.enterPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( enterLabel.mas_top );
        make.left.equalTo( self.accountField.mas_left );
        make.height.equalTo( @( hight ) );
        make.right.equalTo( self.view.mas_right ).offset( -( 40 / CP_GLOBALSCALE * 2 + 40 / CP_GLOBALSCALE) );
    }];
    CGFloat lookPWW = 40 / CP_GLOBALSCALE * 2;
    UIButton *lookPWBtn = [CPLoginLookPWButton buttonWithType:UIButtonTypeCustom];
    [lookPWBtn setBackgroundImage:[UIImage imageNamed:@"login_ic_eye"] forState:UIControlStateNormal];
    [lookPWBtn setBackgroundImage:[UIImage imageNamed:@"login_ic_eye_selected"] forState:UIControlStateSelected];
    [lookPWBtn addTarget:self action:@selector(clickedLookPWBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lookPWBtn];
    [self.view addSubview:self.enterPassword];
    [lookPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.enterPassword.mas_top );
        make.left.equalTo( self.enterPassword.mas_right ).offset( 10 / CP_GLOBALSCALE );
        make.height.equalTo( @( hight ) );
        make.width.equalTo( @( lookPWW ) );
    }];
    [self.enterPassword.rac_textSignal subscribeNext:^(NSString *text) {
        self.viewModel.password = text;
        if ( [text length] > 0 && [self.codeField.text length] > 0 && [self.accountField.text length] > 0 )
        {
            [self.enterButton setEnabled:YES];
        }
        else
        {
            [self.enterButton setEnabled:NO];
        }
    }];
    UIView *passView = [[UIView alloc]init];
    passView.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
    [self.view addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(enterLabel.mas_left);
        make.right.equalTo(self.view.mas_right).offset( -40 / CP_GLOBALSCALE );
        make.bottom.equalTo(self.enterPassword.mas_bottom);
        make.height.equalTo(@(1));
    }];
    UILabel *account = [[UILabel alloc]initWithFrame:CGRectMake( accountLabel.viewX, enterLabel.viewY + enterLabel.viewHeight + 40 / CP_GLOBALSCALE, width, hight)];
    account.text = @"验 证 码";
    account.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    account.textColor = [UIColor colorWithHexString:@"404040"];
    account.viewWidth = [NSString caculateTextSize:account].width;
    account.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:account];
    self.codeField = [[CPSearchTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(account.frame) + 40 / CP_GLOBALSCALE, account.viewY, ( 510 - 40 ) / CP_GLOBALSCALE - (CGRectGetMaxX(account.frame) - 40 / CP_GLOBALSCALE), hight)];
    self.codeField.placeholder = @"请输入验证码";
    self.codeField.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    self.codeField.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
    self.codeField.delegate = self;
    [self.view addSubview:self.codeField];
    self.codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.codeField.rac_textSignal subscribeNext:^(NSString *text) {
        self.viewModel.mobialCode = text;
        if ( 0 < [text length] && 0 < [self.enterPassword.text length] && 0 < [self.accountField.text length] )
        {
            [self.enterButton setEnabled:YES];
        }
        else
        {
            [self.enterButton setEnabled:NO];
        }
    }];
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"247ec9"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    [self.codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
    self.codeButton.titleLabel.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.codeButton.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
    self.codeButton.layer.masksToBounds = YES;
    [self.codeButton setEnabled:NO];
    [self.view addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.codeField.mas_top );
        make.left.equalTo( self.codeField.mas_right ).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( @( hight ) );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
    }];
    [self.codeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        //统计获取验证码
        [MobClick event:@"bind_new_send_message"];
        if ( self.accountField.text.length > 0 )
        {
            [self.viewModel getMobileValidateSms];
        }
    }];
    UIView *codeView = [[UIView alloc]init];
    codeView.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
    [self.view addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(account.mas_left);
        make.right.equalTo(self.codeField.mas_right);
        make.bottom.equalTo(self.codeField.mas_bottom);
        make.height.equalTo(@(1));
    }];
    UIView *enterView = [[UIView alloc]init];
    enterView.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
    [self.view addSubview:enterView];
    [enterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(enterLabel.mas_left);
        make.right.equalTo(enterLabel.mas_right);
        make.bottom.equalTo(enterLabel.mas_bottom);
        make.height.equalTo(@(1));
    }];
    UIButton *markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [markButton setBackgroundImage:[UIImage imageNamed:@"ic_checked"] forState:UIControlStateNormal];
    [self.view addSubview: markButton];
    [markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset( 40 / CP_GLOBALSCALE );
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
        make.top.equalTo( codeView.mas_bottom ).offset( (144 / CP_GLOBALSCALE - 25) / 2.0 );
    }];
    [markButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        @strongify(self)
        self.viewModel.isSelectPro = !self.viewModel.isSelectPro;
        if (self.viewModel.isSelectPro)
        {
            [markButton setBackgroundImage:[UIImage imageNamed:@"ic_checked"] forState:UIControlStateNormal];
        }
        else
        {
            [markButton setBackgroundImage:[UIImage imageNamed:@"ic_uncheck"] forState:UIControlStateNormal];
        }
    }];
    UILabel *yueduLable = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:yueduLable];
    yueduLable.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
    yueduLable.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    yueduLable.text = @"我已阅读并同意";
    [yueduLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_bottom);
        make.left.equalTo(markButton.mas_right).offset(5);
//        make.width.equalTo(@([NSString caculateTextSize:yueduLable].width));
        make.height.equalTo(@( 144 / CP_GLOBALSCALE ));
    }];
    UnderLineLabel *underLineLable = [[UnderLineLabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:underLineLable];
    [underLineLable setBackgroundColor:[UIColor clearColor]];
    [underLineLable setTextColor:[UIColor colorWithHexString:@"288add"]];
    underLineLable.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    underLineLable.shouldUnderline = NO;
    underLineLable.text = @"测聘网用户协议";
    [underLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yueduLable.mas_right);
        make.centerY.equalTo(yueduLable.mas_centerY);
//        make.width.equalTo(@([NSString caculateTextSize:underLineLable].width));
        make.height.equalTo(@( 144 / CP_GLOBALSCALE ));
    }];
    underLineLable.userInteractionEnabled = NO;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(underLineLable.mas_left);
        make.top.equalTo(underLineLable.mas_top);
        make.width.equalTo(@(100));
        make.height.equalTo(@( 144 / CP_GLOBALSCALE ));
    }];
    btn.backgroundColor = [UIColor clearColor];
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        @strongify(self)
        CepinProtoVC *vc = [CepinProtoVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterButton.frame = CGRectMake( 40.0 / CP_GLOBALSCALE, CGRectGetMaxY(custemLayer.frame) + 84.0 / CP_GLOBALSCALE, self.view.viewWidth - 40 / CP_GLOBALSCALE * 2, 144.0 / CP_GLOBALSCALE);
    [self.enterButton setTitle:@"绑定帐号" forState:UIControlStateNormal];
    [self.enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
    [self.enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
    [self.enterButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.enterButton.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
    self.enterButton.layer.masksToBounds = YES;
    self.enterButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    [self.enterButton setEnabled:NO];
    [self.view addSubview:self.enterButton];
    self.haveAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.haveAccountButton.frame = CGRectMake( 40.0 / CP_GLOBALSCALE, CGRectGetMaxY(self.enterButton.frame) + 84.0 / CP_GLOBALSCALE, self.view.viewWidth - 40 / CP_GLOBALSCALE * 2, 144.0 / CP_GLOBALSCALE);
    [self.haveAccountButton setTitle:@"已有测聘网帐号" forState:UIControlStateNormal];
    self.haveAccountButton.backgroundColor = [UIColor whiteColor];;
    [self.haveAccountButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
    self.haveAccountButton.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
    self.haveAccountButton.layer.masksToBounds = YES;
    [self.haveAccountButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
    [self.haveAccountButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
    self.haveAccountButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    [self.view addSubview:self.haveAccountButton];
    [self.haveAccountButton setHidden:YES];
    [self.enterButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        [MobClick event:@"bind_new_btn_bind"];
        if ( self.accountField.text.length > 0 && self.codeField.text.length > 0 && self.enterPassword.text.length > 0 ) {
            [self.viewModel registerUser];
        }
    }];
    [self.haveAccountButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [MobClick event:@"bind_new_btn_toold_bind"];
        if ( [self.comeFromString isEqualToString:@"notificationshomeTestList"] )
        {
            CPBindExistAccountController *vc = [[CPBindExistAccountController alloc] initWithComeFromString:self.comeFromString notificationDict:self.notificationDict];
            [vc configeWithUserData:self.userData];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            CPBindExistAccountController *vc = [[CPBindExistAccountController alloc] initWithComeFromString:self.comeFromString];
            [vc configeWithUserData:self.userData];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    //获取验证码成功
    [RACObserve(self.viewModel, mobialStateCode) subscribeNext:^(id stateCode) {
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if ( code == HUDCodeSucess )
        {
            [self startTime];
        }
        else if( code == HUDCodeNone )
        {
            [self ShowAccountExist];
        }
    }];
    // 新建帐号绑定成功
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self showBindTips];
        }
    }];
}
- (void)clickedLookPWBtn:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    [self.enterPassword setSecureTextEntry:!sender.isSelected];
    [self.enterPassword becomeFirstResponder];
}
- (void)configWithUserData:(UserLoginDTO *)userData
{
    self.userData = userData;
    self.viewModel.userData = userData;
}
- (void)ShowAccountExist
{
    [self.existAccountTipsView setHidden:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self.existAccountTipsView];
}
- (void)showBindTips
{
    [self.bindTipsView setHidden:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bindTipsView];
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
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@秒后重新获取",strTime] forState:UIControlStateNormal];
                [self.codeButton setEnabled:NO];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    self.viewModel.isKeyBoardShow = YES;
    if (IS_IPHONE_5) {
        return YES;
    }else{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.view.frame = CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight);
//        });
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.viewModel.isKeyBoardShow = NO;
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField==self.enterPassword) {
        self.seeBtn.hidden = YES;
    }
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
    if ([string isEqualToString:@""] && textField != self.accountField )
    {
        if ( textField==self.enterPassword && self.enterPassword.text.length==1 )
        {
            self.seeBtn.hidden = YES;
        }
        return YES;
    }
    else
    {
        if (textField==self.enterPassword)
        {
            self.seeBtn.hidden = NO;
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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAccountClickedBackBtn:)];
    int hight = 84 / ( 3.0 * ( 1 / 1.29 ) );
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(44 / CP_GLOBALSCALE, 20 + ( 44 - 33 ) / 2.0, hight, hight);
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bindAccountClickedBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [left setCustomView:button];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:46 / CP_GLOBALSCALE]}];
    self.navigationItem.leftBarButtonItem = left;
}
- (UIView *)existAccountTipsView
{
    if ( !_existAccountTipsView )
    {
        _existAccountTipsView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_existAccountTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
        CGFloat H = ( 84 + 60 + 84 + 48 * 1 + 24 * 1 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
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
        NSString *str = @"账号已存在，请重新输入";
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
        self.sureButton = sureButton;
        [self.sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
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
        CGFloat H = ( 84 + 60 + 84 + 48 * 2 + 24 * 2 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
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
        NSString *str = @"您的第三方帐号已经与手机帐号绑定成功，绑定后两个帐号均可登录";
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
            [MobClick event:@"message_bind_sure"];
            [_bindTipsView setHidden:YES];
            [_bindTipsView removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_LONGIN object:nil userInfo:@{ CP_ACCOUNT_LONGIN_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
            if ( self.comeFromString && [self.comeFromString isEqualToString:@"delivery"] )
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
            else if ( self.comeFromString && [self.comeFromString isEqualToString:@"collection"] )
            {
                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
            else if ( self.comeFromString && [self.comeFromString isEqualToString:@"aboutlogin"] )
            {
                GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.account comeFromString:self.comeFromString];
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
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
            else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homedynamictest"] )
            {
                NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
                DynamicExamNotHomeVC *childVC = childArray[1];
                [childVC dismissViewControllerAnimated:NO completion:nil];
                [childVC performSelector:@selector(outSideOpenExam) withObject:nil];
            }
            else if ( self.comeFromString && [self.comeFromString isEqualToString:@"homeexperience"] )
            {
                GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.account];
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
            else
            {
                if ( [self.viewModel.allResumeArrayM count] > 0 )
                {
                    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate ChangeToMainTwo];
                    // 发送设置默认简历的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
                }
                else
                {
                    GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.account];
                    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                    [self.navigationController presentViewController:nav animated:YES completion:nil];
                }
            }
        }];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( tipsView.mas_left );
            make.right.equalTo( tipsView.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
        }];
        [_bindTipsView setHidden:YES];
    }
    return _bindTipsView;
}
- (void)clearApptoken
{
    //清除token信息
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"uapp_token"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"photourl"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    if (!strTocken) {
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance] updateAppTokenWithUserId:strUser tokenId:strTocken appDeviceToken:@""];
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
@end