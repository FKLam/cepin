//
//  AutoLoginVM.m
//  cepin
//
//  Created by ceping on 14-11-26.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "AutoLoginVM.h"
#import "UserLoginDTO.h"
#import "RTNetworking+User.h"
#import "UserThirdLoginInfoDTO.h"
#import "NSDictionary+NetworkBean.h"
#import "RTNetworking+Resume.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface AutoLoginVM()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;

@end

@implementation AutoLoginVM

-(instancetype)init
{
    if (self = [super init])
    {
        self.isShowLoading = NO;
        self.datas = [NSMutableArray new];
        self.mobiel = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
        if (!self.mobiel)
        {
            self.mobiel = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccout"];
        }
    }
    return self;
}
-(void)autoLogin
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsThirdPartLogin"];
    if (number && number.intValue == 1)
    {
        [self performSelectorInBackground:@selector(thirdPartLogin) withObject:nil];
    }
    else
    {
        [self performSelectorInBackground:@selector(normalLogin) withObject:nil];
    }
}
-(void)normalLogin
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccout"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"];
        if (!account || !password)
        {
            self.boolNumber = [NSNumber numberWithInt:0];
            return;
        }
        TBLoading *loading = nil;
        if (self.isShowLoading)
        {
            loading = [TBLoading new];
            [loading start];
        }
        @weakify(self)
        // inviteCode 渠道号
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sourceid" ofType:@"txt"];
        NSString *inviteCode = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        if ( !inviteCode || 0 == [inviteCode length] )
            inviteCode = @"AppStore";
        RACSignal *signal = [[RTNetworking shareInstance] loginWithAccount:account password:password inviteCode:inviteCode];
        [signal subscribeNext:^(RACTuple *tuple){
            @strongify(self)
            NSDictionary *dic = tuple.second;
            RTLog(@"login %@",tuple.second);
            if ([dic resultSucess])
            {
                self.login = [UserLoginDTO beanFromDictionary:[dic resultObject]];
                [MemoryCacheData shareInstance].userLoginData = self.login;
                if (self.login)
                {
                    [MemoryCacheData shareInstance].userLoginData = self.login;
                    [MemoryCacheData shareInstance].isLogin = YES;
                    [MemoryCacheData shareInstance].isThirdLogin = NO;
                    self.mobiel = self.login.Moblie;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"IsThirdPartLogin"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self autoGetUserInfo];
                }
                self.boolNumber = [NSNumber numberWithInt:1];
            }
            else
            {
                if (self.isShowLoading)
                {
                    [self showShordMessage:[dic resultErrorMessage]];
                }
                self.boolNumber = [NSNumber numberWithInt:0];
            }
            if (loading)
            {
                [loading stop];
            }
        } error:^(NSError *error){
            @strongify(self)
            if (self.isShowLoading)
            {
                if (loading)
                {
                    [loading stop];
                }
                [self showShordMessage:NetWorkError];
            }
            self.boolNumber = [NSNumber numberWithInt:0];
        }];
//    });
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


-(void)thirdPartLogin
{
    UserThirdLoginInfoDTO *thirdPart = [UserThirdLoginInfoDTO info];
    if (!thirdPart || !thirdPart.type || !thirdPart.usid || !thirdPart.username)
    {
        self.boolNumber = [NSNumber numberWithInt:0];
        return;
    }
    TBLoading *load = nil;
    if (self.isShowLoading)
    {
        load = [TBLoading new];
        [load start];
    }
    @weakify(self)
    RACSignal *signal = [[RTNetworking shareInstance] thirdPartLoginWithUID:thirdPart.usid userName:thirdPart.username type:thirdPart.type];
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self)
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = tuple.second;
        RTLog(@"login %@",tuple.second);
        if ([dic resultSucess])
        {
            self.login = [UserLoginDTO beanFromDictionary:[dic resultObject]];
            if (self.login)
            {
                [MemoryCacheData shareInstance].userLoginData = self.login;
                [MemoryCacheData shareInstance].isLogin = YES;
                [MemoryCacheData shareInstance].isThirdLogin = YES;
                self.mobiel = self.login.Moblie;
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"IsThirdPartLogin"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginOver" object:nil userInfo:nil];
                self.boolNumber = [NSNumber numberWithInt:1];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self autoGetUserInfo];
            }
        }
        else
        {
            if (self.isShowLoading)
            {
                [self showShordMessage:[dic resultErrorMessage]];
//                [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
        }
    } error:^(NSError *error){
        @strongify(self)
        if (self.isShowLoading)
        {
            if (load)
            {
                [load stop];
            }
             [self showShordMessage:NetWorkError];
//            [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        }
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
            }
        }
        else
        {
        }
        
    } error:^(NSError *error) {
    }];
}
@end
