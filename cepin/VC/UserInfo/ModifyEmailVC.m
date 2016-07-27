//
//  ModifyEmailVC.m
//  cepin
//
//  Created by dujincai on 15/5/13.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ModifyEmailVC.h"
#import "UIViewController+NavicationUI.h"
#import "ModifyEmailVM.h"
#import "CPTestEnsureTextFiled.h"
#import "CPTipsView.h"
#import "CPCommon.h"
#define CP_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
@interface ModifyEmailVC ()<UITextFieldDelegate,UIAlertViewDelegate, CPTipsViewDelegate>
@property (nonatomic, strong) CPTestEnsureTextFiled *emailTextField;
@property (nonatomic, strong) ModifyEmailVM *viewModel;
@property (nonatomic, strong) UIView *customBackgroundView;
@property (nonatomic, strong) CPTipsView *tipsView;
@end
@implementation ModifyEmailVC
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.viewModel = [ModifyEmailVM new];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"input_email_launch"];
    self.title = @"绑定邮箱";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.emailTextField resignFirstResponder];
        //右边保存按钮
        [self.viewModel checkEmailAvailabel];
    }];
    [self.view addSubview:self.customBackgroundView];
    [[self.emailTextField rac_textSignal]subscribeNext:^(NSString *text) {
        self.viewModel.email = text;
    }];
    //修改邮箱成功
    @weakify(self)
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self);
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self showMessageTips:@"您的邮箱会收到一封邮件，请您验证邮箱" identifier:100];
            [MobClick event:@"bind_email_finish"];
        }
    }];
    [RACObserve( self.viewModel, checkAvailabelEmail ) subscribeNext:^(id stateCode) {
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            if ( self.viewModel.availabelEmail.intValue == 1 )
            {
                [self shomMessageTips:@"该邮箱已经绑定测聘网，请更换一个常用的新邮箱绑定。"];
            }
            else if ( self.viewModel.availabelEmail.intValue == 0 )
            {
                [self.viewModel sendBindEmailInfo];
            }
        }
    }];
    [RACObserve( self.viewModel, sendBindEmail) subscribeNext:^(id stateCode) {
        if( stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.viewModel editEmailInfo];
        }
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)shomMessageTips:(NSString *)tips
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
- (void)showMessageTips:(NSString *)tips identifier:(NSInteger)identifier
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [self.tipsView setIdentifier:identifier];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton
{
    self.tipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton identifier:(NSInteger)identifier
{
    self.tipsView = nil;
    if ( 100 == identifier )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (CPTipsView *)messageTipsViewWithTips:(NSString *)tips
{
    if ( !_tipsView )
    {
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"确定"] showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
- (UIView *)customBackgroundView
{
    if ( !_customBackgroundView )
    {
        _customBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, 32 / CP_GLOBALSCALE + 64.0, kScreenWidth - 40 / CP_GLOBALSCALE * 2, 144 / CP_GLOBALSCALE)];
        [_customBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_customBackgroundView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_customBackgroundView.layer setMasksToBounds:YES];
        UILabel *emailLabel = [[UILabel alloc] init];
        emailLabel.text = @" 邮  箱";
        emailLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        emailLabel.textColor = [UIColor colorWithHexString:@"404040"];
        [_customBackgroundView addSubview:emailLabel];
        [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _customBackgroundView.mas_top );
            make.left.equalTo( _customBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE);
            make.bottom.equalTo( _customBackgroundView.mas_bottom );
        }];
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"f8eef1"]];
        [_customBackgroundView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( emailLabel.mas_centerY );
            make.left.equalTo( emailLabel.mas_right ).offset( 20 / CP_GLOBALSCALE );
            make.height.equalTo( @( 62 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [_customBackgroundView addSubview:self.emailTextField];
        [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _customBackgroundView.mas_top );
            make.left.greaterThanOrEqualTo( emailLabel.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _customBackgroundView.mas_bottom );
            make.width.equalTo( @( _customBackgroundView.viewWidth - 40 / CP_GLOBALSCALE * 6) );
        }];
    }
    return _customBackgroundView;
}
- (CPTestEnsureTextFiled *)emailTextField
{
    if ( !_emailTextField )
    {
        _emailTextField = [[CPTestEnsureTextFiled alloc] init];
        _emailTextField.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        _emailTextField.textColor = [UIColor colorWithHexString:@"404040"];
        _emailTextField.placeholder = @"请输入绑定邮箱";
        _emailTextField.delegate = self;
        [_emailTextField setTextAlignment:NSTextAlignmentLeft];
        [_emailTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    return _emailTextField;
}
@end
