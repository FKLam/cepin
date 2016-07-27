//
//  CPWBindMobileVM.m
//  cepin
//
//  Created by ceping on 16/4/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWBindMobileVM.h"
#import "CPPositionDetailDescribeLabel.h"
#import "RTNetworking+User.h"
#import "RTNetworking+Resume.h"
#import "CPCommon.h"
@interface CPWBindMobileVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation CPWBindMobileVM
- (void)getMobileValidateSms
{
    //账号检查
    if (!self.mobileString || [self.mobileString isEqualToString:@""])
    {
        [self showShordMessage:@"请输入账号"];
        return;
    }
    if (![APPFunctionHelper checkPhoneText:self.mobileString])
    {
        [self showShordMessage:@"手机号码不正确"];
        return;
    }
    self.isSendMobileValid = NO;
    RACSignal *signal = [[RTNetworking shareInstance] sendMobileValidateSmsForVerifyWithAccount:self.mobileString];
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
            [self showShordMessage:@"验证码已经发送到手机上"];
            self.mobileStateCode =[RTHUDModel hudWithCode:HUDCodeSucess];
            self.isSendMobileValid = YES;
        }
        else
        {
            if ([@"用户账号已存在" isEqualToString:[dic resultErrorMessage]])
            {
                self.mobileStateCode = [RTHUDModel hudWithCode:HUDCodeNone];
            }
            else
            {
                [self showShordMessage:[dic resultErrorMessage]];
            }
            self.mobileStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    }error:^(NSError *error) {
        if (load)
        {
            [load stop];
        }
        @strongify(self);
        [self showShordMessage:NetWorkError];
        self.mobileStateCode = error;
    }];
}
- (void)emailBAccountindMobile
{
    if (!self.mobileString || [self.mobileString isEqualToString:@""])
    {
        [self showShordMessage:@"请输入手机号码"];
        return;
    }
    if (![APPFunctionHelper checkPhoneText:self.mobileString])
    {
        [self showShordMessage:@"手机号码不正确"];
        return;
    }
    if (!self.mobileCodeString || [self.mobileCodeString isEqualToString:@""])
    {
        [self showShordMessage:@"验证码不能为空"];
        return;
    }
    // inviteCode 渠道号
    NSString *userID = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *tokenID = [MemoryCacheData shareInstance].userLoginData.TokenId;
    NSString *passWordString = @"";
    RACSignal *signal = [[RTNetworking shareInstance] emailAccountBindMobile:self.mobileString serId:userID tokenId:tokenID bindType:@"1" moblieValidateCode:self.mobileCodeString password:passWordString];
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
        if ([dic resultSucess])
        {
            [self getAllResume];
            [[NSUserDefaults standardUserDefaults] setObject:self.mobileString forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
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
- (void)getAllResume
{
    NSString *userID = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *tokenID = [MemoryCacheData shareInstance].userLoginData.TokenId;
    RACSignal *signal = [[RTNetworking shareInstance] getResumeListWithTokenId:tokenID userId:userID ResumeType:@""];
    TBLoading *load = [TBLoading new];
    [load start];
    @weakify(self);
    [signal subscribeNext:^(RACTuple *tuple){
        @strongify(self);
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            NSArray *array = [dic resultObject];
            if (array &&  ![array isKindOfClass:[NSNull class]] && array.count > 0)
            {
                [self.datas removeAllObjects];
                [self.datas addObjectsFromArray:[dic resultObject]];
            }
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
    } error:^(NSError *error){
        if (load)
        {
            [load stop];
        }
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
        _existAccountTipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
- (NSMutableArray *)datas
{
    if ( !_datas )
    {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
