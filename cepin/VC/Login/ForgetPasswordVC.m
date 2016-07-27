//
//  ForgetPasswordVC.m
//  cepin
//
//  Created by ceping on 14-12-29.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "ForgetPasswordVM.h"
#import "PhoneGetPasswordVC.h"
#import "CPCommon.h"
#import "CPForgetPWTextField.h"
#import "CPTipsView.h"
@interface ForgetPasswordVC ()<UITextFieldDelegate,UIAlertViewDelegate, CPTipsViewDelegate>
@property (nonatomic, retain) CPForgetPWTextField *accountField;
@property (nonatomic, retain) ForgetPasswordVM *viewModel;
@property (nonatomic, assign) int forgotType;
@property (nonatomic, strong) CPTipsView *tipsView;
@end
@implementation ForgetPasswordVC
-(void)clickedBackBtn:(id)sender
{
    [self.view endEditing:YES];
    [ self dismissViewControllerAnimated: YES completion: nil ];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [ForgetPasswordVM new];
    self.viewModel.showMessageVC = self;
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    int hight = 144 / CP_GLOBALSCALE;
    UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0, 0, 42 / CP_GLOBALSCALE * 4, hight)];
    accountLabel.text = @"  账  号  ";
    accountLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    accountLabel.textColor = [UIColor colorWithHexString:@"404040"];
    accountLabel.viewWidth = [self caculateTextSize:accountLabel].width;
    self.accountField = [[CPForgetPWTextField alloc] initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, 64 + 30 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE * 2, hight)];
    [self.accountField setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    [self.accountField.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [self.accountField.layer setMasksToBounds:YES];
    NSString *str = @"请输入注册账号";
    [self.accountField setPlaceholder:str];
    self.accountField.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
    self.accountField.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
    self.accountField.delegate = self;
    self.accountField.textAlignment = NSTextAlignmentLeft;
    self.accountField.leftView = accountLabel;
    self.accountField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.accountField];
    [self.accountField.rac_textSignal subscribeNext:^(NSString *text) {
        self.viewModel.account = text;
    }];
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, CGRectGetMaxY(self.accountField.frame) + 84.0 / CP_GLOBALSCALE, self.view.viewWidth - 40 / CP_GLOBALSCALE * 2, hight)];
    phoneButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    [phoneButton setTitle:@"通过手机号码找回" forState:UIControlStateNormal];
    [phoneButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
    [phoneButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [phoneButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
    [phoneButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
    [phoneButton.layer setMasksToBounds:YES];
    [self.view addSubview:phoneButton];
    [phoneButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
       //通过手机
        [self.accountField resignFirstResponder];
        self.forgotType = 1;
        [self.viewModel getPasswordFromSever:self.forgotType];
    }];
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, CGRectGetMaxY( phoneButton.frame ) + 84 / CP_GLOBALSCALE, self.view.viewWidth - 40 / CP_GLOBALSCALE * 2, hight)];
    emailButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    [emailButton setTitle:@"通过电子邮箱找回" forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
    [emailButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
    [emailButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
    [emailButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
    [emailButton.layer setMasksToBounds:YES];
    [self.view addSubview:emailButton];
    [emailButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //邮箱
        [self.accountField resignFirstResponder];
        self.forgotType = 0;
        [self.viewModel getPasswordFromSever:self.forgotType];
    }];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            if (self.forgotType == 0)
            {
                [self shomMessageTips:@"重置密码邮件已发送成功"];
            }
            else
            {
                PhoneGetPasswordVC *vc = [[PhoneGetPasswordVC alloc] initWithAccount:self.viewModel.account];
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
              [self presentViewController:nav animated:YES completion:nil];
            }
          
        }
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleKeyBoard)];
    [self.view addGestureRecognizer:tap];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://400-067-3800"]];
    }else{
        [self performSelector:@selector(login) withObject:nil afterDelay:0.5];
            }
}
-(void)login{
    [ self dismissViewControllerAnimated:YES completion: nil ];
}
-(void)backClick{
    
}
- (void)cancleKeyBoard
{
    [self.accountField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (CGSize)caculateTextSize:(UIView *)control
{
    
    CGSize controlSize = CGSizeZero;
    
    if ( [control isKindOfClass:[UILabel class]] )
    {
        UILabel *label = (UILabel *)control;
        
        controlSize = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : label.font } context:nil].size;
    }
    else if ( [control isKindOfClass:[UITextField class]])
    {
        UITextField *textField = (UITextField *)control;
        controlSize = [textField.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : textField.font } context:nil].size;
    }
    
    return controlSize;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(clickedBackBtn:)];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
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
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"确定"] showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
@end
