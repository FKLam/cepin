//
//  SignupVM.m
//  cepin
//
//  Created by ricky.tang on 14-10-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SignupVM.h"
#import "RTNetworking+User.h"
#import "UserLoginDTO.h"
#import "APPFunctionHelper.h"
#import "NSString+Addition.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface SignupVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation SignupVM
-(instancetype)init
{
    if (self = [super init]) {
        self.isSelectPro = YES;
    }
    return self;
}
-(void)registerUser
{
    //邮箱检查
    if (!self.account || [self.account isEqualToString:@""])
    {
        [self showShordMessage:@"请输入手机号码"];
        return;
    }
    if (![APPFunctionHelper checkPhoneText:self.account])
    {
        [self showShordMessage:@"手机号码不正确"];
        return;
    }
    //密码检查
    if (!self.password || [self.password isEqualToString:@""]) {
        [self showShordMessage:@"请输入密码"];
        return;
    }
    if (self.password.length < 6)
    {
        [self showShordMessage:@"密码不能少于6位字符"];
        return;
    }
    if (self.password.length > 16)
    {
        [self showShordMessage:@"密码不能超过16位数字或字母"];
        return;
    }
    if (![self.password checkPasswordText]) {
        [self showShordMessage:@"请输入6-16位密码、字母区分大小写"];
        return;
    }
    if ( [self.password isIncludeSpecialCharact] )
    {
        [self showShordMessage:@"请输入6-16位密码、字母区分大小写"];
        return;
    }
    if (!self.mobialCode || [self.mobialCode isEqualToString:@""]) {
        [self showShordMessage:@"验证码不能为空"];
        return;
    }
    //授权信息检查
    if (!self.isSelectPro)
    {
        [self showShordMessage:@"注册请同意测聘网用户协议"];
        return;
    }
    // inviteCode 渠道号
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sourceid" ofType:@"txt"];
    NSString *inviteCode = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if ( !inviteCode || 0 == [inviteCode length] )
        inviteCode = @"AppStore";
    RACSignal *signal = [[RTNetworking shareInstance] registerWithAccount:self.account passWord:self.password Validatecode:self.mobialCode comeFrom:100 inviteCode:inviteCode];
    TBLoading *load = [TBLoading new];
    [load start];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        if (load)
        {
            [load stop];
        }
        @strongify(self);
        NSDictionary *dic = tuple.second;
        RTLog(@"login %@",tuple.second);
        if ([dic resultSucess])
        {
            NSDictionary *resultDict = [dic resultObject];
            UserLoginDTO *bean = [UserLoginDTO new];
            bean.UserId = [resultDict objectForKey:@"UserId"];
            bean.UserName = [resultDict objectForKey:@"UserName"];
            bean.TokenId = [resultDict objectForKey:@"TokenId"];
            bean.ExpiresIn = [resultDict objectForKey:@"ExpiresIn"];
            bean.LastActiveTime = [resultDict objectForKey:@"LastActiveTime"];
            [MemoryCacheData shareInstance].userLoginData = bean;
            [MemoryCacheData shareInstance].isLogin = YES;
            [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:@"userAccout"];
            [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:@"userPassword"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.mobile = self.account;
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            [self showShordMessage:[dic resultErrorMessage]];
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } error:^(NSError *error){
        if (load)
        {
            [load stop];
        }
        @strongify(self);
        [self showShordMessage:NetWorkError];
        self.stateCode = error;
    }];
}
//141569
- (void)getMobileValidateSms
{
    //账号检查
    if (!self.account || [self.account isEqualToString:@""])
    {
        [self showShordMessage:@"请输入账号"];
        return;
    }
    if (![APPFunctionHelper checkPhoneText:self.account])
    {
        [self showShordMessage:@"请输入正确的11位手机号码"];
        return;
    }
    self.isSendMobileValid = NO;
    RACSignal *signal = [[RTNetworking shareInstance]getMobileValidateSmsAccount:self.account type:@"1"];
    TBLoading *load = [TBLoading new];
    [load start];
    @weakify(self)
    [signal subscribeNext:^(RACTuple *tuple) {
        if (load) {
            [load stop];
        }
       @strongify(self)
        NSDictionary *dic = tuple.second;
        if ([dic resultSucess])
        {
            dic = [dic resultObject];
            [self showShordMessage:@"已发送短信验证码，请查收"];
            self.mobialStateCode =[RTHUDModel hudWithCode:HUDCodeSucess];
            self.isSendMobileValid = YES;
        }
        else
        {
            if ([@"用户账号已存在" isEqualToString:[dic resultErrorMessage]]) {
                self.mobialStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
            else
            {
                [self showShordMessage:[dic resultErrorMessage]];
            }
            self.mobialStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    }error:^(NSError *error) {
        if (load)
        {
            [load stop];
        }
        @strongify(self);
        [self showShordMessage:NetWorkError];
        self.mobialStateCode = error;
    }];
}
- (void)showShordMessage:(NSString *)message
{
    if ( !self.showMessageVC )
        return;
    self.existAccountTipsView = [self shortMessageTipsView:message];
    [[UIApplication sharedApplication].keyWindow addSubview:self.existAccountTipsView];
}
#pragma mark - getter method
- (UIView *)shortMessageTipsView:(NSString *)message
{
    if ( !_existAccountTipsView )
    {
        _existAccountTipsView = [[UIView alloc] initWithFrame:self.showMessageVC.view.bounds];
        [_existAccountTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
        CGFloat maxW = kScreenWidth - ( 84 + 64 + 40 * 2 ) / CP_GLOBALSCALE;
        CGFloat H = ( 84 + 60 + 84 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
        CGFloat X = 40 / CP_GLOBALSCALE;
        CGFloat Y = ( kScreenHeight - H ) / 2.0;
        NSString *str = message;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
        CGSize strSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        H += strSize.height;
        if ( strSize.height > ( 48 + 24 + 24 ) / CP_GLOBALSCALE )
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
        else
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
        attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
        UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [tipsView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [tipsView.layer setMasksToBounds:YES];
        [_existAccountTipsView addSubview:tipsView];
        self.tipsView = tipsView;
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
        self.contentLabel = contentLabel;
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
            _existAccountTipsView = nil;
        }];
    }
    return _existAccountTipsView;
}
@end
