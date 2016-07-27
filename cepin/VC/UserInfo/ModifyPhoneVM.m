//
//  ModifyPhoneVM.m
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ModifyPhoneVM.h"
#import "RTNetworking+User.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface ModifyPhoneVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, assign) NSInteger changeStateCode;
@end
@implementation ModifyPhoneVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//获取验证码
- (void)getMobileSms
{
    if (!self.phone || [self.phone isEqualToString:@""])
    {
        [self showShordMessage:@"请输入手机号码" changeStateCode:0];
        return;
    }
    if (![APPFunctionHelper checkPhoneText:self.phone])
    {
        [self showShordMessage:@"手机号码格式不正确" changeStateCode:0];
        return;
    }
    self.isSendMobileValid = NO;
    RACSignal *signal = [[RTNetworking shareInstance] getMobileValidateSmsAccount:self.phone type:@"1"];
    TBLoading *load = [TBLoading new];
    [load start];
    @weakify(self)
    [signal subscribeNext:^(RACTuple *tuple) {
        if (load) {
            [load stop];
        }
        @strongify(self)
        NSDictionary *dic = tuple.second;
        if ([dic resultSucess]) {
//            dic = [dic resultObject];
            [self showShordMessage:@"验证码已经发送到手机上" changeStateCode:0];
            self.mobialStateCode =[RTHUDModel hudWithCode:HUDCodeSucess];
            self.isSendMobileValid = YES;
        }else
        {
            [self showShordMessage:[dic resultErrorMessage] changeStateCode:0];
            self.mobialStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    }error:^(NSError *error) {
        if (load)
        {
            [load stop];
        }
        
        @strongify(self);
        [self showShordMessage:NetWorkError changeStateCode:0];
        self.mobialStateCode = error;
        
    }];
}
- (void)editPhoneInfo
{
    //判断电话号码
    if (!self.phone || [self.phone isEqualToString:@""])
    {
        [self showShordMessage:@"请输入电话号码" changeStateCode:0];
        return;
    }
    if (![APPFunctionHelper checkPhoneText:self.phone])
    {
        [self showShordMessage:@"手机号码格式不正确" changeStateCode:0];
        return;
    }
    if (!self.phoneCode || [self.phoneCode isEqualToString:@""])
    {
        [self showShordMessage:@"验证码不能为空" changeStateCode:0];
        return;
    }
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *tokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    RACSignal *signal = [[RTNetworking shareInstance]userInfomationWithTokenId:tokenId userId:userId Mobile:self.phone ValidateCode:self.phoneCode];
    TBLoading *load = [TBLoading new];
    [load start];
    @weakify(self)
    [signal subscribeNext:^(RACTuple *tuple) {
        if (load) {
            [load stop];
        }
        NSDictionary *dic = tuple.second;
          @strongify(self)
        if ([dic resultSucess]) {
            [self showShordMessage:[dic resultMessage] changeStateCode:200];
            self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }else{
            [self showShordMessage:[dic resultErrorMessage] changeStateCode:0];
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } error:^(NSError *error) {
        if (load) {
            [load stop];
        }
        @strongify(self);
        [self showShordMessage:NetWorkError changeStateCode:0];
        self.stateCode = error;
    }];
}
- (void)showShordMessage:(NSString *)message changeStateCode:(NSInteger)changeStateCode
{
    if ( !self.showMessageVC )
        return;
    self.existAccountTipsView = [self shortMessageTipsView:message changeStateCode:changeStateCode];
    [[UIApplication sharedApplication].keyWindow addSubview:self.existAccountTipsView];
}
#pragma mark - getter method
- (UIView *)shortMessageTipsView:(NSString *)message changeStateCode:(NSInteger)changeStateCode
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
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / 3.0]];
        [tipsView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.right.equalTo( tipsView.mas_right );
        }];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [self.modifyPhoneVMDelegate respondsToSelector:@selector(modifyPhoneVMClickEnsureButtonWithCode:)] )
            {
                [self.modifyPhoneVMDelegate modifyPhoneVMClickEnsureButtonWithCode:changeStateCode];
            }
            [_existAccountTipsView setHidden:YES];
            [_existAccountTipsView removeFromSuperview];
            _existAccountTipsView = nil;
        }];
    }
    return _existAccountTipsView;
}
@end
