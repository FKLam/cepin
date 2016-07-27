//
//  CPWBindMobileController.m
//  cepin
//
//  Created by ceping on 16/4/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWBindMobileController.h"
#import "NSString+Extension.h"
#import "CPWBindMobileVM.h"
#import "CPSearchTextField.h"
#import "CPPositionDetailDescribeLabel.h"
#import "MeVC.h"
#import "AboutVC.h"
#import "DynamicExamVC.h"
#import "LoginVC.h"
#import "SignupGuideResumeVC.h"
#import "GuideStatesMv.h"
#import "RTNetworking+User.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"
#import "RecommendVC.h"
#import "DynamicExamNotHomeVC.h"
@interface CPWBindMobileController ()<UITextFieldDelegate>
@property (nonatomic, strong) CPWBindMobileVM *viewModel;
@property (nonatomic, strong) CPSearchTextField *accountField;
@property (nonatomic, strong) CPSearchTextField *codeField;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) UIView *bindTipsView;
@property (nonatomic, strong) NSString *comeFromString;
@end
@implementation CPWBindMobileController
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.viewModel = [[CPWBindMobileVM alloc] init];
        self.viewModel.showMessageVC = self;
        self.viewModel.passwordString = [[NSUserDefaults standardUserDefaults] valueForKey:@"userPassword"];
    }
    return self;
}
- (instancetype)initWithComeFromString:(NSString *)comeFromString
{
    self = [self init];
    self.comeFromString = comeFromString;
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
    [self setTitle:@"绑定手机"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    CALayer *custemLayer = [[CALayer alloc] init];
    CGRect custemRect = CGRectMake(0, 30 / CP_GLOBALSCALE, kScreenWidth, ( 144 * 2 + 40 * 1 ) / CP_GLOBALSCALE );
    custemLayer.frame = custemRect;
    custemLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:custemLayer];
    NSInteger hight = 144.0 / CP_GLOBALSCALE;
    NSInteger width = 65.0;
    UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, 32 / CP_GLOBALSCALE, width, hight)];
    accountLabel.text = @"手     机";
    accountLabel.textAlignment = NSTextAlignmentLeft;
    accountLabel.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    accountLabel.textColor = [UIColor colorWithHexString:@"404040"];
    accountLabel.viewWidth = [NSString caculateTextSize:accountLabel].width;
    [self.view addSubview:accountLabel];
    self.accountField = [[CPSearchTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame) + 40 / CP_GLOBALSCALE, accountLabel.viewY, kScreenWidth - CGRectGetMaxX(accountLabel.frame) - 40 / CP_GLOBALSCALE * 2, hight)];
    self.accountField.placeholder = @"仅支持大陆手机号码";
    self.accountField.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    self.accountField.textColor = [UIColor colorWithHexString:@"404040"];
    self.accountField.delegate = self;
    self.accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountField.delegate = self;
    [self.view addSubview:self.accountField];
    @weakify(self)
    [self.accountField.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        self.viewModel.mobileString = text;
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
        if ( 0 < [text length] && 0 < [self.codeField.text length] )
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
    UILabel *account = [[UILabel alloc]initWithFrame:CGRectMake( accountLabel.viewX, accountLabel.viewY + accountLabel.viewHeight + 40 / CP_GLOBALSCALE, width, hight)];
    account.text = @"验 证 码";
    account.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    account.textColor = [UIColor colorWithHexString:@"404040"];
    account.viewWidth = [NSString caculateTextSize:account].width;
    account.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:account];
    self.codeField = [[CPSearchTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(account.frame) + 40 / CP_GLOBALSCALE, account.viewY, (510 - 40) / CP_GLOBALSCALE - ( CGRectGetMaxX(account.frame) - 40 / CP_GLOBALSCALE ), hight)];
    self.codeField.placeholder = @"请输入验证码";
    self.codeField.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    self.codeField.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
    self.codeField.delegate = self;
    [self.view addSubview:self.codeField];
    self.codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.codeField.rac_textSignal subscribeNext:^(NSString *text) {
        self.viewModel.mobileCodeString = text;
        if ( 0 < [text length] && 0 < [self.accountField.text length] )
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
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( @( hight ) );
    }];
    [self.codeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        //统计获取验证码
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
    [self.enterButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        if ( self.accountField.text.length > 0 && self.codeField.text.length > 0 ) {
            [self.viewModel emailBAccountindMobile];
        }
    }];
    //获取验证码成功
    [RACObserve(self.viewModel, mobileStateCode) subscribeNext:^(id stateCode) {
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
    // 手机号码绑定成功
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self showBindTips];
        }
    }];
}
//倒计时
- (void)startTime
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if( timeout <= 0 ){ //倒计时结束，关闭
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 限制手机号码输入的位数
    if ( textField == self.accountField && ![string isEqualToString:@""] )
    {
    // 限制只能输入数字
        NSString *numberStr = @"1234567890";
        if ( [numberStr rangeOfString:string].length == 0 )
            return NO;
        if( range.location >= 11 )
            return NO;
    }
    return YES;
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
- (NSInteger)requestStateWithStateCode:(id)stateCode
{
    if ([stateCode isKindOfClass:[RTHUDModel class]])
    {
        RTHUDModel *model = (RTHUDModel *)stateCode;
        return model.hudCode;
    }
    else if([stateCode isKindOfClass:[NSError class]])
    {
        NSError *error = (NSError *)stateCode;
        return error.code;
    }
    return 0;
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
        _existAccountTipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
        _bindTipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
        NSString *str = @"您的邮箱帐号已经与手机帐号绑定成功，绑定后两个帐号均可登录";
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
                if ([self.viewModel.datas count] > 0)
                {
//                    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
//                    [delegate ChangeToMainTwo];
//                    // 发送设置默认简历的通知
//                    [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
                    NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
                    UIViewController *parentVC = childArray[1];
                    [parentVC dismissViewControllerAnimated:NO completion:nil];
                }
                else
                {
                    GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobileString comeFromString:self.comeFromString];
                    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                    [self.navigationController presentViewController:nav animated:NO completion:nil];
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
                if ([self.viewModel.datas count] > 0)
                {
                    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate ChangeToMainTwo];
                    // 发送设置默认简历的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
                }
                else
                {
                    GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobileString comeFromString:self.comeFromString];
                    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                    [self.navigationController presentViewController:nav animated:NO completion:nil];
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
                NSArray *childArray = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
                UIViewController *parentVC = childArray[0];
                RecommendVC *childVC = parentVC.childViewControllers[0];
                [childVC dismissViewControllerAnimated:NO completion:nil];
                [childVC performSelector:@selector(comeFromeWithString:) withObject:self.comeFromString];
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
                if ([self.viewModel.datas count] > 0)
                {
                    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate ChangeToMainTwo];
                    // 发送设置默认简历的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:CP_ACCOUNT_CHANGE object:nil userInfo:@{ CP_ACCOUNT_CHANGE_VALUE : [NSNumber numberWithInteger:HUDCodeSucess] }];
                }
                else
                {
                    GuideStatesMv *vc = [[GuideStatesMv alloc] initWithMobiel:self.viewModel.mobileString comeFromString:self.comeFromString];
                    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
                    [self.navigationController presentViewController:nav animated:NO completion:nil];
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
-(void)clearApptoken
{
    //清除token信息
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"uapp_token"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"photourl"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
    
//    info.Mobile = [[NSUserDefaults standardUserDefaults] valueForKey:@"mobile"];
//    info.UserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
//    info.RealName = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealName"];
//    info.Email = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
//    info.PhotoUrl= [[NSUserDefaults standardUserDefaults] valueForKey:@"photourl"];
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