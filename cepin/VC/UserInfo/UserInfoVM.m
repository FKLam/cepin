//
//  UserInfoVM.m
//  cepin
//
//  Created by Ricky Tang on 14-11-3.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UserInfoVM.h"
#import "RTNetworking+User.h"
#import "UserLoginDTO.h"
#import "UserInfoDTO.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPRequestOperationManager.h"
#import "HttpUploadImage.h"
#import "NSString+WeiResume.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
@interface UserInfoVM ()
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation UserInfoVM
-(instancetype)init
{
    if (self = [super init])
    {
        self.data = [UserInfoDTO new];
        return self;
    }
    return nil;
}
- (void)editUserInfo
{
    NSString *error = nil;
    if (![self.data.RealName CheckRealName:&error])
    {
        [self showShordMessage:error];
        return;
    }
    if (![self.data.UserName CheckUserName:&error])
    {
        [self showShordMessage:error];
        return;
    }
    TBLoading *load = [TBLoading new];
    [load start];
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *tokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if ( 0 == [userId length] || 0 == [tokenId length] )
    {
        [self showShordMessage:@"登录异常，请重新登录"];
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance]userInfomationWithTokenId:tokenId userId:userId Realname:self.data.RealName UserName:self.data.UserName];
    [signal subscribeNext:^(RACTuple *tuple) {
        if (load) {
            [load stop];
        }
        NSDictionary *dic = tuple.second;
        if ([dic resultSucess]) {
            
            [MemoryCacheData shareInstance].userLoginData.UserName = self.data.UserName;
            [MemoryCacheData shareInstance].userLoginData.realName = self.data.RealName;
//            [self autoGetUserInfo];
            self.editUserInfoStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
        }
        else
        {
            [self showShordMessage:[dic resultErrorMessage]];
            self.editUserInfoStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    }error:^(NSError *error) {
        if (load) {
            [load stop];
        }
        [self showShordMessage:NetWorkError];
        self.editUserInfoStateCode = error;
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
            NSLog(@"%@", info);
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
//获取个人信息
-(void)userInfomation
{
    TBLoading *load = [TBLoading new];
    [load start];
    self.data = nil;
    NSString *userTokenID = @"";
    NSString *userID = @"";
    if ( [MemoryCacheData shareInstance].userLoginData.TokenId )
        userTokenID = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if ( [MemoryCacheData shareInstance].userLoginData.UserId )
        userID = [MemoryCacheData shareInstance].userLoginData.UserId;
    RACSignal *signal = [[RTNetworking shareInstance] userInfomationWithTokenId:userTokenID userId:userID];
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
                [[NSUserDefaults standardUserDefaults] setObject:info.RealName forKey:@"RealName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.data = info;
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
        }
        UserInfoDTO *info = [[UserInfoDTO alloc] init];
        
//        [[NSUserDefaults standardUserDefaults] setObject:info.RealName forKey:@"RealName"];
//        [[NSUserDefaults standardUserDefaults] setObject:info.Mobile forKey:@"mobile"];
//        [[NSUserDefaults standardUserDefaults] setObject:info.UserName forKey:@"username"];
//        [[NSUserDefaults standardUserDefaults] setObject:info.RealName forKey:@"RealName"];
//        [[NSUserDefaults standardUserDefaults] setObject:info.Email forKey:@"email"];
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:info.PhotoUrl]];
//        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"photourlimagedata"];
//        [[NSUserDefaults standardUserDefaults] setObject:info.PhotoUrl forKey:@"photourl"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        info.Mobile = [[NSUserDefaults standardUserDefaults] valueForKey:@"mobile"];
        info.UserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        info.RealName = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealName"];
        info.Email = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
        info.PhotoUrl= [[NSUserDefaults standardUserDefaults] valueForKey:@"photourl"];
        NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:@"photourlimagedata"];
        self.tempImage = [UIImage imageWithData:imageData];
        self.data = info;
        self.stateCode = [RTHUDModel hudWithCode:HUDCodeNetWork];
    }];
}
//上传头像
-(void)uploadUserHeadImageWithImage:(UIImage *)imageLogo
{
    
    if (!imageLogo) {
        return;
    }
    
    TBLoading *load = [TBLoading new];
    [load start];
    
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strUserTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    [HttpUploadImage uploadImage:@{@"tokenId":strUserTocken,@"userId":strUser,@"upFile":imageLogo} success:^(id responseObject) {
        if (load)
        {
            [load stop];
        }
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic resultSucess])
        {
//            [OMGToast showWithText:@"上传头像成功" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            self.updateImageStateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
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
            self.updateImageStateCode = [NSError errorWithErrorMessage:[dic resultErrorMessage]];
        }
    } failure:^(id responseObject) {
        if (load)
        {
            [load stop];
        }
        [self showShordMessage:NetWorkError];
    }];
}

-(void)test
{
    
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
