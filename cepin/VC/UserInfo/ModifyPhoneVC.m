//
//  ModifyPhoneVC.m
//  cepin
//
//  Created by dujincai on 15/5/13.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ModifyPhoneVC.h"
#import "UIViewController+NavicationUI.h"
#import "ModifyPhoneVM.h"
#import "NSString+Extension.h"
#import "CPSearchTextField.h"
#import "CPCommon.h"
@interface ModifyPhoneVC ()<UITextFieldDelegate, ModifyPhoneVMDelegate>
@property(nonatomic,strong)ModifyPhoneVM *viewModel;
@property(nonatomic,strong)CPSearchTextField *Telephone;
@property(nonatomic,strong)CPSearchTextField *codeField;
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,strong)UITextField *textField;
@end
@implementation ModifyPhoneVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewModel = [ModifyPhoneVM new];
        self.viewModel.showMessageVC = self;
        [self.viewModel setModifyPhoneVMDelegate:self];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"input_phone_launch"];
    self.title = @"绑定手机";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
       //右边保存按钮
        [self.viewModel editPhoneInfo];
    }];
    CALayer *custemLayer = [[CALayer alloc] init];
    CGRect custemRect = CGRectMake(0, 30 / CP_GLOBALSCALE + 44 + 20, kScreenWidth, ( 144 * 2 + 40 * 1 ) / CP_GLOBALSCALE );
    custemLayer.frame = custemRect;
    custemLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:custemLayer];
    int hight = 144 / CP_GLOBALSCALE;
    UILabel *areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, 30 / CP_GLOBALSCALE + 64.0, 45, hight)];
    areaLabel.text = @"手     机";
    areaLabel.textAlignment = NSTextAlignmentLeft;
    areaLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    areaLabel.textColor = [UIColor colorWithHexString:@"404040"];
    areaLabel.viewWidth = [NSString caculateTextSize:areaLabel].width;
    [self.view addSubview:areaLabel];
    self.Telephone = [[CPSearchTextField alloc] initWithFrame:CGRectMake(areaLabel.viewX + areaLabel.viewWidth + 40 / CP_GLOBALSCALE, areaLabel.viewY, kScreenWidth - CGRectGetMaxX(areaLabel.frame) - 40 / CP_GLOBALSCALE - 40 / CP_GLOBALSCALE, hight)];
    self.Telephone.placeholder = @"输入手机号码";
    self.Telephone.delegate = self;
    self.Telephone.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.Telephone.textColor = [UIColor colorWithHexString:@"404040"];
    [self.Telephone setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:self.Telephone];
    [[self.Telephone rac_textSignal]subscribeNext:^(NSString *text) {
        self.viewModel.phone = text;
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
    UIView *phoneLine = [[UIView alloc] init];
    phoneLine.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
    [self.view addSubview:phoneLine];
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Telephone.mas_bottom).offset( 1 / CP_GLOBALSCALE );
        make.left.equalTo(areaLabel.mas_left);
        make.right.equalTo(self.view.mas_right).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo(@( 1 / CP_GLOBALSCALE ));
    }];
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, CGRectGetMaxY(areaLabel.frame) + 40 / CP_GLOBALSCALE + 1 / CP_GLOBALSCALE, IS_IPHONE_5?45:55, hight)];
    codeLabel.text = @"验 证 码";
    codeLabel.textColor = [UIColor colorWithHexString:@"404040"];
    codeLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    codeLabel.viewWidth = [NSString caculateTextSize:codeLabel].width;
    codeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:codeLabel];
    self.codeField = [[CPSearchTextField alloc] initWithFrame:CGRectMake(codeLabel.viewX + codeLabel.viewWidth + 40 / CP_GLOBALSCALE, codeLabel.viewY, (510 - 40 ) / CP_GLOBALSCALE - (CGRectGetMaxX(codeLabel.frame) - 40 / CP_GLOBALSCALE), hight)];
    self.codeField.placeholder = @"输入验证码";
    self.codeField.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.codeField.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
    self.codeField.delegate = self;
    [self.view addSubview:self.codeField];
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateNormal];
    [self.codeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.codeButton.layer.cornerRadius = 10.0 / CP_GLOBALSCALE;
    self.codeButton.layer.masksToBounds = YES;
//    self.codeButton.frame = CGRectMake(CGRectGetMaxX(self.codeField.frame) + 40 / CP_GLOBALSCALE, CGRectGetMaxY(self.codeField.frame) - 144.0 / CP_GLOBALSCALE, [NSString caculateTextSize:self.codeButton.titleLabel].width + 50.0, 144.0 / CP_GLOBALSCALE);
    [self.codeButton setEnabled:NO];
    [self.view addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.codeField.mas_top );
        make.left.equalTo( self.codeField.mas_right ).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
    }];
    [[self.codeField rac_textSignal]subscribeNext:^(NSString *text) {
        //
        self.viewModel.phoneCode = text;
    }];
    [self.codeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        //点击获取验证码
        [self.viewModel getMobileSms];
        if ( [self.codeButton.titleLabel.text isEqualToString:@"重新获取验证码"] )
        {
            [MobClick event:@"bind_mobile_reget_checkcode"];
        }
        else
            [MobClick event:@"bind_mobile_get_checkcode"];
    }];
    UIView *codeLine = [[UIView alloc]init];
    codeLine.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
    [self.view addSubview:codeLine];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeField.mas_bottom);
        make.left.equalTo(codeLabel.mas_left);
        make.right.equalTo(self.codeField.mas_right);
        make.height.equalTo(@( 1 / CP_GLOBALSCALE ));
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
    //修改手机号码成功
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        [self requestStateWithStateCode:stateCode];
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
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
    return YES;
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 限制手机号码输入的位数
    if ( textField == self.Telephone && ![string isEqualToString:@""] )
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
#pragma mark - ModifyPhoneVMDelegate
- (void)modifyPhoneVMClickEnsureButtonWithCode:(NSInteger)changeStateCode
{
    if ( 200 == changeStateCode )
    {
        [self.navigationController popViewControllerAnimated:YES];
        [MobClick event:@"bind_mobile_finish"];
    }
}
@end
