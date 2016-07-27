//
//  MeVM.m
//  cepin
//
//  Created by dujincai on 15/6/6.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "MeVM.h"
#import "RTNetworking+User.h"
#import "AutoLoginVM.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface MeVM()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;

@end

@implementation MeVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLoad = YES;
    }
    return self;
}
//获取个人信息
-(void)userInfomation
{
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    if (!userId)
    {
        UserInfoDTO *info = [[UserInfoDTO alloc] init];
        info.Mobile = [[NSUserDefaults standardUserDefaults] valueForKey:@"mobile"];
        info.UserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        info.RealName = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealName"];
        info.Email = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
        info.PhotoUrl= [[NSUserDefaults standardUserDefaults] valueForKey:@"photourl"];
        NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:@"photourlimagedata"];
        self.tempImage = [UIImage imageWithData:imageData];
        self.data = info;
        return;
    }
    TBLoading *load = nil;
    if (self.isLoad) {
        load = [TBLoading new];
        [load start];
        self.isLoad = NO;
    }
    RACSignal *signal = [[RTNetworking shareInstance] userInfomationWithTokenId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId];
    [signal subscribeNext:^(RACTuple *tuple) {
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            UserInfoDTO *info = [UserInfoDTO beanFromDictionary:[dic resultObject]];
            if (info)
            {
                self.data = info;
                [[NSUserDefaults standardUserDefaults] setObject:info.RealName forKey:@"RealName"];
                [[NSUserDefaults standardUserDefaults] setObject:info.Mobile forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:info.UserName forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:info.RealName forKey:@"RealName"];
                [[NSUserDefaults standardUserDefaults] setObject:info.Email forKey:@"email"];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:info.PhotoUrl]];
                [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"photourlimagedata"];
                [[NSUserDefaults standardUserDefaults] setObject:info.PhotoUrl forKey:@"photourl"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
        }
        else
        {
            if ([dic isMustAutoLogin])
            {
                [self showShordMessage:NetWorkError];
            }
            else
            {
                [self showShordMessage:[dic resultErrorMessage]];
            }
            self.stateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
        
    } error:^(NSError *error) {
        if (load)
        {
            [load stop];
            UserInfoDTO *info = [[UserInfoDTO alloc] init];
            info.Mobile = [[NSUserDefaults standardUserDefaults] valueForKey:@"mobile"];
            info.UserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
            info.RealName = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealName"];
            info.Email = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
            info.PhotoUrl= [[NSUserDefaults standardUserDefaults] valueForKey:@"photourl"];
            NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:@"photourlimagedata"];
            self.tempImage = [UIImage imageWithData:imageData];
            self.data = info;
        }
        self.stateCode = error;
    }];
}
- (void)getChangeUserInfor
{
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    if (!userId)
    {
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance] userInfomationWithTokenId:[MemoryCacheData shareInstance].userLoginData.TokenId userId:[MemoryCacheData shareInstance].userLoginData.UserId];
    [signal subscribeNext:^(RACTuple *tuple) {
        NSDictionary *dic = (NSDictionary *)tuple.second;
        if ([dic resultSucess])
        {
            UserInfoDTO *info = [UserInfoDTO beanFromDictionary:[dic resultObject]];
            if (info)
            {
                self.data = info;
                [[NSUserDefaults standardUserDefaults] setObject:info.RealName forKey:@"RealName"];
                [[NSUserDefaults standardUserDefaults] setObject:info.Mobile forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:info.UserName forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:info.RealName forKey:@"RealName"];
                [[NSUserDefaults standardUserDefaults] setObject:info.Email forKey:@"email"];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:info.PhotoUrl]];
                [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"photourlimagedata"];
                [[NSUserDefaults standardUserDefaults] setObject:info.PhotoUrl forKey:@"photourl"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.getChangeUserStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
            }
        }
    } error:^(NSError *error) {
    }];
}
- (void)showShordMessage:(NSString *)message
{
    if ( !self.existAccountTipsView )
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

-(void)autoLogin{
    self.autoVm = [AutoLoginVM new];
    self.autoVm.showMessageVC = self.showMessageVC;
    [self.autoVm autoLogin];
}
@end
