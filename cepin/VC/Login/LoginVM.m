//
//  LoginVM.m
//  cepin
//
//  Created by ricky.tang on 14-10-14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "LoginVM.h"
#import "RTNetworking+User.h"
#import "RTNetworking+Resume.h"
#import "UserLoginDTO.h"
#import "RACSignal+Error.h"
#import "UserThirdLoginInfoDTO.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
#define kOmtTopOffset 220
@interface LoginVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation LoginVM
-(instancetype)init
{
    if (self = [super init])
    {
        self.datas = [NSMutableArray new];
        self.mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    }
    return self;
}
- (void)Login
{
    TBLoading *load = [TBLoading new];
    [load start];
    // inviteCode 渠道号
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sourceid" ofType:@"txt"];
    NSString *inviteCode = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if ( !inviteCode || 0 == [inviteCode length] )
        inviteCode = @"AppStore";
    RACSignal *signal = [[RTNetworking shareInstance] loginWithAccount:self.account password:self.password inviteCode:inviteCode];
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
           self.login = [UserLoginDTO beanFromDictionary:[dic resultObject]];
            if (self.login)
            {
                [MemoryCacheData shareInstance].userLoginData = self.login;
                [MemoryCacheData shareInstance].isLogin = YES;
                [MemoryCacheData shareInstance].isThirdLogin = NO;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"IsThirdPartLogin"];
                [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:@"userAccout"];
                [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:@"userPassword"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginOver" object:nil userInfo:nil];
                self.mobile = self.login.Moblie;
                [[NSUserDefaults standardUserDefaults] synchronize];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                });
                [self autoGetUserInfo];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
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
- (void)thirdPartLogin
{
    if (!self.thirdLoginType || !self.thirdLoginName || !self.thirdLoginId)
    {
        [self showShordMessage:@"登录失败"];
        return;
    }
    TBLoading *load = [TBLoading new];
    [load start];
    RACSignal *signal = [[RTNetworking shareInstance] thirdPartLoginWithUID:self.thirdLoginId userName:self.thirdLoginName type:self.thirdLoginType];
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
            self.login = [UserLoginDTO beanFromDictionary:[dic resultObject]];
            self.userDataDict = [dic resultObject];
            if (self.login)
            {
                [MemoryCacheData shareInstance].userLoginData = self.login;
                [MemoryCacheData shareInstance].isLogin = YES;
                [MemoryCacheData shareInstance].isThirdLogin = YES;
                UserThirdLoginInfoDTO *third = [UserThirdLoginInfoDTO new];
                third.username = self.thirdLoginName;
                third.usid = self.thirdLoginId;
                third.type = self.thirdLoginType;
                [third saveToFile];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"IsThirdPartLogin"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginOver" object:nil userInfo:nil];
                self.mobile = self.login.Moblie;
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self autoGetUserInfo];
                self.thirdPartLoginStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
        }
        else
        {
            [self showShordMessage:[dic resultErrorMessage]];
            self.thirdPartLoginStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } error:^(NSError *error){
        if (load)
        {
            [load stop];
        }
        @strongify(self);
        [self showShordMessage:NetWorkError];
        self.thirdPartLoginStateCode = error;
    }];
}
- (void)getMobileValidateSms
{
    //账号检查
    if (!self.mobile || [self.mobile isEqualToString:@""])
    {
        [self showShordMessage:@"请输入手机号码"];
        return;
    }
    if (![APPFunctionHelper checkPhoneText:self.mobile])
    {
        [self showShordMessage:@"手机号码不正确"];
        return;
    }
    self.isSendMobileValid = NO;
    RACSignal *signal = [[RTNetworking shareInstance] sendExemptPasswordLoginMoblieValidateSmsWithMoblie:self.mobile];
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
            self.mobialStateCode =[RTHUDModel hudWithCode:HUDCodeSucess];
            [self showShordMessage:@"验证码已经发送到手机上"];
            self.isSendMobileValid = YES;
        }
        else
        {
            if ([@"用户账号已存在" isEqualToString:[dic resultErrorMessage]])
            {
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
- (void)exemptPasswordLogin
{
    TBLoading *load = [TBLoading new];
    [load start];
    // inviteCode 渠道号
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sourceid" ofType:@"txt"];
    NSString *inviteCode = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if ( !inviteCode || 0 == [inviteCode length] )
        inviteCode = @"AppStore";
    RACSignal *signal = [[RTNetworking shareInstance] exemptPasswordLoginWithMobile:self.mobile moblieCode:self.mobileCode inviteCode:inviteCode];
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
            self.login = [UserLoginDTO beanFromDictionary:[dic resultObject]];
            if (self.login)
            {
                [MemoryCacheData shareInstance].userLoginData = self.login;
                [MemoryCacheData shareInstance].isLogin = YES;
                [MemoryCacheData shareInstance].isThirdLogin = NO;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"IsThirdPartLogin"];
                [[NSUserDefaults standardUserDefaults] setObject:self.mobile forKey:@"userAccout"];
                [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:@"userPassword"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginOver" object:nil userInfo:nil];
                self.mobile = self.login.Moblie;
                self.account = self.mobile;
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self autoGetUserInfo];
                self.freeLoginStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
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
- (void)autoGetUserInfo
{
    NSString *userTokenID = @"";
    NSString *userID = @"";
    if ( [MemoryCacheData shareInstance].userLoginData.TokenId )
        userTokenID = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if ( [MemoryCacheData shareInstance].userLoginData.UserId )
        userID = [MemoryCacheData shareInstance].userLoginData.UserId;
    TBLoading *load = [[TBLoading alloc] init];
    load.isWaitFor = YES;
    [load start];
    RACSignal *signal = [[RTNetworking shareInstance] userInfomationWithTokenId:userTokenID userId:userID];
    [signal subscribeNext:^(RACTuple *tuple) {
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            UserInfoDTO *info = [UserInfoDTO beanFromDictionary:[dic resultObject]];
            if (info)
            {
                [[NSUserDefaults standardUserDefaults] setObject:info.RealName forKey:@"RealName"];
                [[NSUserDefaults standardUserDefaults] setObject:info.Mobile forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:info.UserName forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:info.RealName forKey:@"RealName"];
                [[NSUserDefaults standardUserDefaults] setObject:info.Email forKey:@"email"];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:info.PhotoUrl]];
                [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"photourlimagedata"];
                [[NSUserDefaults standardUserDefaults] setObject:info.PhotoUrl forKey:@"photourl"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.getUserInfoStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
        }
        else
        {
        }
        self.getUserInfoStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
        if ( load )
            [load stop];
    } error:^(NSError *error) {
        self.getUserInfoStateCode = error;
        if ( load )
            [load stop];
    }];
}
- (void)showShordMessage:(NSString *)message
{
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
